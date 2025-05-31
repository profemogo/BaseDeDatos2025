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
-- CreateDeleteUser
-- ============================================================

DELIMITER $$

CREATE PROCEDURE CreateDeleteUser(
    IN user_id INT
)
BEGIN

    -- Inicia la transacción
    START TRANSACTION;

    -- Get name of the user
    SET @user_name = (SELECT name FROM User WHERE id = user_id);

    -- Anonimiza el usuario
    UPDATE User SET
        name = 'Usuario Eliminado',
        email = CONCAT('usuario_eliminado', id, '@expenseapp.com'),
        phone = CONCAT('usuario_eliminado', id),
        password_hash = CONCAT('usuario_eliminado', id),
        avatar = NULL,
        deleted_at = CURRENT_TIMESTAMP
    WHERE id = user_id;

    -- Elimina solo los workspaces donde solo el usuario eliminado es el único miembro
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

    -- Actualiza los comentarios donde en nombre del usuario se encuentre
    UPDATE ExpenseComment SET
        comment = REPLACE(comment, @user_name, 'Usuario Eliminado')
    WHERE comment LIKE CONCAT('%', @user_name, '%');

    -- Confirma la transacción
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
    
    -- Inicia la transacción
    START TRANSACTION;

    -- ============================================================
    -- Valida que el gasto sea un objeto JSON válido
    -- ============================================================

    IF JSON_TYPE(expense) != 'OBJECT' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense is not a valid JSON object';
    END IF;

    -- ============================================================
    -- Valida que los splits del gasto sean un array JSON válido
    -- ============================================================

    IF JSON_TYPE(expense_splits) != 'ARRAY' THEN
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The expense splits is not a valid array';
    END IF;

    -- ============================================================
    -- Inserta el gasto
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
    -- Inserta los splits del gasto
    -- ============================================================

    SET splits_count = JSON_LENGTH(expense_splits);
    
    splits_loop: WHILE split_index < splits_count DO
        -- Obtiene el id del usuario del split
        SET @split_user_id = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].user_id')));
        SET @split_amount = JSON_UNQUOTE(JSON_EXTRACT(expense_splits, CONCAT('$[', split_index, '].amount')));

        -- Suma al total acumulado
        SET total_splits_amount = total_splits_amount + @split_amount;

        -- Valida que el monto del split no sea negativo
        IF @split_amount < 0 THEN
            ROLLBACK;
            SIGNAL SQLSTATE 'C0400' 
            SET MESSAGE_TEXT = 'El monto del split es negativo';
        END IF;

        -- Valida si el tipo de gasto es Transferencia
        IF @expense_type = 'Transfer' THEN
            -- Valida que el monto del split sea igual al monto del gasto
            IF @split_amount != @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For Transfer type, the split amount must be equal to the expense amount';
            END IF;
        END IF;

        -- Valida si el tipo de gasto es División Igual
        IF @expense_type = 'SplitEqual' THEN
            SET @expected_split_amount = @expense_amount / splits_count;
            -- Valida que el monto del split sea igual al monto esperado
            IF @split_amount != @expected_split_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitEqual type, the split amount must be equal to the expected split amount';
            END IF;
        END IF;

        -- Valida si el tipo de gasto es División Desigual
        IF @expense_type = 'SplitUnequal' THEN
            -- Valida que el monto del split no sea igual al monto del gasto
            IF @split_amount = @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitUnequal type, the split amount must be different from the expense amount';
            END IF;
        END IF;

        -- Inserta el split
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
    
    -- Valida que el total de los splits sea igual al monto del gasto
    IF total_splits_amount != expense->'$.amount' THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The sum of the splits does not match the total amount of the expense';
    END IF;
    
    -- Si llegamos aquí, confirma la transacción
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
    
    -- Inicia la transacción
    START TRANSACTION;
    
    -- Obtiene los datos del gasto
    SET @expense_name = expense->>'$.name';
    SET @expense_description = expense->>'$.description';
    SET @expense_workspace_id = expense->>'$.workspace_id';
    SET @expense_category_id = expense->>'$.category_id';
    SET @expense_amount = expense->>'$.amount';
    SET @expense_date = expense->>'$.expense_date';
    SET @expense_type = expense->>'$.type';
    SET @expense_paid_by_user_id = expense->>'$.paid_by_user_id';
    SET @expense_updated_by_user_id = expense->>'$.updated_by_user_id';

    -- Actualiza el gasto
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

    -- Obtiene el número de divisiones
    SET splits_count = JSON_LENGTH(splits);

    -- Valida el número de divisiones
    IF splits_count < 1 THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'At least one expense split is required';
    END IF;

    -- Actualiza las divisiones existentes
    WHILE split_index < splits_count DO
        -- Obtiene los datos de la división
        SET @split_user_id = JSON_EXTRACT(splits, CONCAT('$[', split_index, '].user_id'));
        SET @split_amount = JSON_EXTRACT(splits, CONCAT('$[', split_index, '].amount'));
        
        -- Suma al total
        SET total_splits_amount = total_splits_amount + @split_amount;

        -- Valida si el tipo de gasto es SinglePayer
        IF @expense_type = 'SinglePayer' THEN
            -- Valida que solo haya una división
            IF splits_count > 1 THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SinglePayer type, only one split is allowed';
            END IF;
        END IF;

        -- Valida si el tipo de gasto es SplitEqual
        IF @expense_type = 'SplitEqual' THEN
            -- Calcula el monto esperado de la división
            SET @expected_split_amount = @expense_amount / splits_count;
            
            -- Valida que el monto de la división sea igual al monto esperado
            IF @split_amount != @expected_split_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitEqual type, the split amount must be equal to the expected split amount';
            END IF;
        END IF;

        -- Valida si el tipo de gasto es SplitUnequal
        IF @expense_type = 'SplitUnequal' THEN
            -- Valida que el monto de la división no sea igual al monto del gasto
            IF @split_amount = @expense_amount THEN
                ROLLBACK;
                SIGNAL SQLSTATE 'C0400' 
                SET MESSAGE_TEXT = 'For SplitUnequal type, the split amount must be different from the expense amount';
            END IF;
        END IF;

        -- Actualiza la división si existe, sino inserta una nueva
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
    
    -- Valida que el total de las divisiones sea igual al monto del gasto
    IF total_splits_amount != expense->'$.amount' THEN
        ROLLBACK;
        SIGNAL SQLSTATE 'C0400' 
        SET MESSAGE_TEXT = 'The sum of the splits does not match the total amount of the expense';
    END IF;
    
    -- Si llegamos aquí, confirma la transacción
    COMMIT;

END$$

DELIMITER ;
