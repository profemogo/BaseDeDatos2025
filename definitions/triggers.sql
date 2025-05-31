/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Triggers Definition
 * 
 **/ 

-- ============================================================
-- User Table Triggers
-- ============================================================

-- Trigger before insert (encrypt password)
DELIMITER $$
CREATE TRIGGER trigger_before_insert_user
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_key'), 256);
END$$
DELIMITER ;

-- Trigger before update (encrypt password)
DELIMITER $$
CREATE TRIGGER trigger_before_update_user
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_key'), 256);
END$$
DELIMITER ;

-- ============================================================
-- Workspace Table Triggers
-- ============================================================

-- Trigger before insert (set created by user id to member of the workspace)
DELIMITER $$
CREATE TRIGGER trigger_after_insert_workspace
AFTER INSERT ON Workspace
FOR EACH ROW
BEGIN
    INSERT INTO WorkspaceUser (workspace_id, user_id)
    VALUES (
        NEW.id,
        NEW.created_by_user_id
    );
END$$
DELIMITER ;

-- ============================================================
-- WorkspaceInvitation Table Triggers
-- ============================================================

-- Trigger before update (update status)
DELIMITER $$
CREATE TRIGGER trigger_before_update_workspace_invitation
BEFORE UPDATE ON WorkspaceInvitation
FOR EACH ROW
BEGIN   
    -- Update the status
    IF NEW.status = 'Accepted' THEN
        INSERT INTO WorkspaceUser (workspace_id, user_id)
        VALUES (
            NEW.workspace_id, 
            (SELECT id FROM User WHERE email = NEW.receiver_email)
        );
    END IF;
END$$
DELIMITER ;

-- ============================================================
-- Expense Table Triggers
-- ============================================================

-- Trigger before update (create comment)
DELIMITER $$
CREATE TRIGGER trigger_before_update_expense
BEFORE UPDATE ON Expense
FOR EACH ROW
BEGIN
    
    -- Name
    IF NEW.name != OLD.name THEN
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'El nombre de esta transacción fue cambiado de ',
                OLD.name,
                ' a ',
                NEW.name
            )
        );
    END IF;

    -- Description
    IF NEW.description != OLD.description THEN
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'La descripción de esta transacción fue cambiada de ',
                OLD.description,
                ' a ',
                NEW.description
            )
        );
    END IF;

    -- Category
    IF NEW.category_id != OLD.category_id THEN
        -- Get the old and new category names
        SET @old_category_name = '';
        SET @new_category_name = '';

        SELECT name INTO @old_category_name FROM Category WHERE id = OLD.category_id;
        SELECT name INTO @new_category_name FROM Category WHERE id = NEW.category_id;

        -- Create the comment
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'La categoría de esta transacción fue cambiada de ',
                @old_category_name,
                ' a ',
                @new_category_name
            )
        );
    END IF;

    -- Amount
    IF NEW.amount != OLD.amount THEN
        -- Create the comment
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'El monto de esta transacción fue cambiado de ',
                OLD.amount,
                ' a ',
                NEW.amount
            )
        );
    END IF;

    -- Expense date
    IF NEW.expense_date != OLD.expense_date THEN
        -- Create the comment
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'La fecha de esta transacción fue cambiada de ',
                OLD.expense_date,
                ' a ',
                NEW.expense_date,
                '"'
            )
        );
    END IF;

    -- Expense type
    IF NEW.type != OLD.type THEN 
        -- Create the comment
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.id, 
            NEW.updated_by_user_id, 
            CONCAT(
                'El tipo de esta transacción fue cambiado de ',
                OLD.type,
                ' a ',
                NEW.type,
                '"'
            )
        );
    END IF;

END$$
DELIMITER ;

-- ============================================================
-- ExpenseSplit Table Triggers
-- ============================================================

-- Trigger before update (create comment for amount changes)
DELIMITER $$
CREATE TRIGGER trigger_before_update_expense_split
BEFORE UPDATE ON ExpenseSplit
FOR EACH ROW
BEGIN
    -- Amount
    IF NEW.amount != OLD.amount THEN
        -- Get the split user name
        SET @split_user_name = '';
        SELECT name INTO @split_user_name FROM User WHERE id = NEW.user_id;

        -- Create the comment
        INSERT INTO ExpenseComment (expense_id, user_id, comment)
        VALUES (
            NEW.expense_id, 
            NEW.updated_by_user_id,
            CONCAT(
                'La contribución de ',
                @split_user_name,
                ' fue cambiada de ',
                OLD.amount,
                ' a ',
                NEW.amount
            )
        );
    END IF;
END$$
DELIMITER ;

