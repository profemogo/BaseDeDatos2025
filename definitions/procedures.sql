/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Procedures Definition
 * 
 **/ 

-- ============================================================
-- CreateExpenseWithSplits
-- ============================================================

DELIMITER $$

CREATE PROCEDURE CreateExpenseWithSplits(
    IN expense JSON,
    IN expense_splits JSON,
    OUT new_expense_id INTEGER
)
BEGIN
    DECLARE total_splits_amount DECIMAL(10,2) DEFAULT 0;
    DECLARE split_index INTEGER DEFAULT 0;
    DECLARE splits_count INTEGER;
    
    -- Start transaction
    START TRANSACTION;

    -- ============================================================
    -- Validate expense is a valid JSON object
    -- ============================================================

    IF JSON_TYPE(expense) != 'OBJECT' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense is not a valid JSON object';
    END IF;

    -- ============================================================
    -- Validate expense splits is a valid JSON array
    -- ============================================================

    IF JSON_TYPE(expense_splits) != 'ARRAY' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense splits is not a valid array';
    END IF;

    -- ============================================================
    -- Insert the expense
    -- ============================================================

    SET @expense_name = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.name'));
    SET @expense_description = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.description'));
    SET @expense_workspace_id = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.workspace_id'));
    SET @expense_category_id = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.category_id'));
    SET @expense_amount = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.amount'));
    SET @expense_date = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.expense_date'));
    SET @expense_type = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.type'));
    SET @expense_paid_by_user_id = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.paid_by_user_id'));
    SET @expense_created_by_user_id = JSON_UNQUOTE(JSON_EXTRACT(expense, '$.created_by_user_id'));

    INSERT INTO Expense (
        name,
        description,
        workspace_id,
        category_id,
        amount,
        expense_date,
        type,
        paid_by_user_id,
        created_by_user_id
    ) VALUES (
        @expense_name,
        @expense_description,
        @expense_workspace_id,
        @expense_category_id,
        @expense_amount,
        @expense_date,
        @expense_type,
        @expense_paid_by_user_id,
        @expense_created_by_user_id
    );
    SET new_expense_id = LAST_INSERT_ID();

    -- ============================================================
    -- Insert the expense splits
    -- ============================================================

    SET splits_count = JSON_LENGTH(expense_splits);
    
    splits_loop: WHILE split_index < splits_count DO
        -- Get the split user id
        SET @split_user_id = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].user_id')));
        SET @split_amount = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].amount')));

        -- Add to running total
        SET total_splits_amount = total_splits_amount + @split_amount;

        -- Validate split amount is not negative
        IF @split_amount < 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE 'C0400' 
            SET MESSAGE_TEXT = 'The split amount is negative';
        END IF;

        -- Validate if Expense type is SinglePayer or Transfer
        IF @expense_type = 'SinglePayer' OR @expense_type = 'Transfer' THEN
            -- Validate that the split amount is equal to the expense amount
            IF @split_amount != @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SinglePayer or Transfer type, the split amount must be equal to the expense amount';
            END IF;
            -- Validate that there is only one split
            IF splits_count > 1 THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SinglePayer or Transfer type, there must be only one split';
            END IF;
        END IF;

        -- Validate if Expense type is SplitEqual
        IF @expense_type = 'SplitEqual' THEN
            SET @expected_split_amount = @expense_amount / splits_count;
            -- Validate that the split amount is equal to the expense amount
            IF @split_amount != @expected_split_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitEqual type, the split amount must be equal to the expected split amount';
            END IF;
        END IF;

        -- Validate if Expense type is SplitUnequal
        IF @expense_type = 'SplitUnequal' THEN
            -- Validate that the split amount is not equal to the expense amount
            IF @split_amount = @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitUnequal type, the split amount must be different from the expense amount';
            END IF;
        END IF;

        -- Insert split
        INSERT INTO ExpenseSplit (
            expense_id,
            user_id,
            amount,
            created_by_user_id
        ) VALUES (
            new_expense_id,
            @split_user_id,
            @split_amount,
            @expense_created_by_user_id
        );
        
        SET split_index = split_index + 1;
    END WHILE;
    
    -- Validate total splits equals expense amount
    IF total_splits_amount != expense->'$.amount' THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The sum of the splits does not match the total amount of the expense';
    END IF;
    
    -- If we get here, commit the transaction
    COMMIT;

END$$

DELIMITER ;
