/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Triggers Definition
 * 
 **/ 

-- User Table Triggers 

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

-- Expense Table Triggers

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
                ' changed expense name from "',
                OLD.name,
                '" to "',
                NEW.name,
                '"'
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
                ' changed expense description from "',
                OLD.description,
                '" to "',
                NEW.description,
                '"'
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
                ' changed expense category from "',
                old_category_name,
                '" to "',
                new_category_name,
                '"'
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
                ' changed expense amount from "',
                OLD.amount,
                '" to "',
                NEW.amount,
                '"'
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
                ' changed expense date from "',
                OLD.expense_date,
                '" to "',
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
                ' changed expense type from "',
                OLD.type,
                '" to "',
                NEW.type,
                '"'
            )
        );
    END IF;

END$$
DELIMITER ;