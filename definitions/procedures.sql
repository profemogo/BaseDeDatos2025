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
-- DeleteUser
-- ============================================================

DELIMITER $$

CREATE PROCEDURE DeleteUser(
    IN user_id INT
)
BEGIN

    -- Start transaction
    START TRANSACTION;

    -- Get name of the user
    SET @user_name = (SELECT name FROM User WHERE id = user_id);

    -- Anonymize the user
    UPDATE User SET
        name = 'Usuario Eliminado',
        email = CONCAT('usuario_eliminado', id, '@expenseapp.com'),
        phone = CONCAT('usuario_eliminado', id),
        password_hash = CONCAT('usuario_eliminado', id),
        avatar = NULL,
        deleted_at = CURRENT_TIMESTAMP
    WHERE id = user_id;

    -- Delete workspaces where the deleted user is the only member
    DELETE FROM Workspace
    WHERE id IN (
        SELECT workspace_id 
        FROM (
            SELECT wu.workspace_id
            FROM WorkspaceUser wu
            WHERE (
                SELECT COUNT(*) 
                FROM WorkspaceUser wu2 
                WHERE wu2.workspace_id = wu.workspace_id
            ) = 1
            AND wu.user_id = user_id
        ) AS SingleUserWorkspaces
    );

    -- Update comments where the user name is found
    UPDATE ExpenseComment SET
        comment = REPLACE(comment, @user_name, 'Usuario Eliminado')
    WHERE comment LIKE CONCAT('%', @user_name, '%');

    -- Commit transaction
    COMMIT;
END$$

DELIMITER ;


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
    -- Validate that expense is a valid JSON object
    -- ============================================================

    IF JSON_TYPE(expense) != 'OBJECT' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense is not a valid JSON object';
    END IF;

    -- ============================================================
    -- Validate that expense splits is a valid JSON array
    -- ============================================================

    IF JSON_TYPE(expense_splits) != 'ARRAY' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense splits is not a valid array';
    END IF;

    -- ============================================================
    -- Insert expense
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
    -- Insert expense splits
    -- ============================================================

    SET splits_count = JSON_LENGTH(expense_splits);
    
    splits_loop: WHILE split_index < splits_count DO
        -- Get split user id
        SET @split_user_id = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].user_id')));
        SET @split_amount = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].amount')));

        -- Add to accumulated total
        SET total_splits_amount = total_splits_amount + @split_amount;

        -- Validate split amount is not negative
        IF @split_amount < 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE 'C0400' 
            SET MESSAGE_TEXT = 'El monto del split es negativo';
        END IF;

        -- Validate if expense type is Transfer
        IF @expense_type = 'Transfer' THEN
            -- Validate split amount equals expense amount
            IF @split_amount != @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For Transfer type, the split amount must be equal to the expense amount';
            END IF;
        END IF;

        -- Validate if expense type is SplitEqual
        IF @expense_type = 'SplitEqual' THEN
            SET @expected_split_amount = @expense_amount / splits_count;
            -- Validate split amount equals expected amount
            IF @split_amount != @expected_split_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitEqual type, the split amount must be equal to the expected split amount';
            END IF;
        END IF;

        -- Validate if expense type is SplitUnequal
        IF @expense_type = 'SplitUnequal' THEN
            -- Validate split amount is not equal to expense amount
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
    
    -- If we get here, commit transaction
    COMMIT;

END$$

DELIMITER ;


-- ============================================================
-- UpdateExpenseWithSplits
-- ============================================================
DELIMITER $$

CREATE PROCEDURE UpdateExpenseWithSplits(
    IN expense JSON,
    IN splits JSON,
    IN expense_id INT
)
BEGIN
    DECLARE split_index INT DEFAULT 0;
    DECLARE splits_count INT;
    DECLARE total_splits_amount DECIMAL(10,2) DEFAULT 0;
    
    -- Start transaction
    START TRANSACTION;
    
    -- Get expense data
    SET @expense_name = expense->>'$.name';
    SET @expense_description = expense->>'$.description';
    SET @expense_workspace_id = expense->>'$.workspace_id';
    SET @expense_category_id = expense->>'$.category_id';
    SET @expense_amount = expense->>'$.amount';
    SET @expense_date = expense->>'$.expense_date';
    SET @expense_type = expense->>'$.type';
    SET @expense_paid_by_user_id = expense->>'$.paid_by_user_id';
    SET @expense_updated_by_user_id = expense->>'$.updated_by_user_id';

    -- Update expense
    UPDATE Expense SET
        name = @expense_name,
        description = @expense_description,
        workspace_id = @expense_workspace_id,
        category_id = @expense_category_id,
        amount = @expense_amount,
        expense_date = @expense_date,
        type = @expense_type,
        paid_by_user_id = @expense_paid_by_user_id,
        updated_by_user_id = @expense_updated_by_user_id,
        updated_at = CURRENT_TIMESTAMP
    WHERE id = expense_id;

    -- Get number of splits
    SET splits_count = JSON_LENGTH(splits);

    -- Validate number of splits
    IF splits_count < 1 THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'At least one expense split is required';
    END IF;

    -- Update existing splits
    WHILE split_index < splits_count DO
        -- Get split data
        SET @split_user_id = JSON_EXTRACT(splits, CONCAT('$[', split_index, '].user_id'));
        SET @split_amount = JSON_EXTRACT(splits, CONCAT('$[', split_index, '].amount'));
        
        -- Add to total
        SET total_splits_amount = total_splits_amount + @split_amount;

        -- Validate if expense type is SinglePayer
        IF @expense_type = 'SinglePayer' THEN
            -- Validate only one split exists
            IF splits_count > 1 THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SinglePayer type, only one split is allowed';
            END IF;
        END IF;

        -- Validate if expense type is SplitEqual
        IF @expense_type = 'SplitEqual' THEN
            -- Calculate expected split amount
            SET @expected_split_amount = @expense_amount / splits_count;
            
            -- Validate split amount equals expected amount
            IF @split_amount != @expected_split_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitEqual type, the split amount must be equal to the expected split amount';
            END IF;
        END IF;

        -- Validate if expense type is SplitUnequal
        IF @expense_type = 'SplitUnequal' THEN
            -- Validate split amount is not equal to expense amount
            IF @split_amount = @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitUnequal type, the split amount must be different from the expense amount';
            END IF;
        END IF;

        -- Update split if exists, otherwise insert new
        UPDATE ExpenseSplit SET
            amount = @split_amount,
            updated_by_user_id = @expense_updated_by_user_id,
            updated_at = CURRENT_TIMESTAMP
        WHERE expense_id = expense_id AND user_id = @split_user_id;

        IF ROW_COUNT() = 0 THEN
            INSERT INTO ExpenseSplit (
                expense_id,
                user_id,
                amount,
                created_by_user_id,
                updated_by_user_id
            ) VALUES (
                expense_id,
                @split_user_id,
                @split_amount,
                @expense_updated_by_user_id,
                @expense_updated_by_user_id
            );
        END IF;
        
        SET split_index = split_index + 1;
    END WHILE;
    
    -- Validate total splits equals expense amount
    IF total_splits_amount != expense->'$.amount' THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The sum of the splits does not match the total amount of the expense';
    END IF;
    
    -- If we get here, commit transaction
    COMMIT;

END$$

DELIMITER ;
