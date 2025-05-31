/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Functions Definition
 * 
 **/ 

-- ============================================================
-- GetUserWorkspaceBalance
-- ============================================================

DELIMITER $$

CREATE FUNCTION GetUserWorkspaceBalance(
    params JSON
) 
RETURNS JSON
DETERMINISTIC
BEGIN
    DECLARE total_balance DECIMAL(10,2);
    DECLARE status VARCHAR(50);
    DECLARE details TEXT;

    SET @workspace_id = JSON_UNQUOTE(JSON_EXTRACT(params, '$.workspace_id'));
    SET @user_id = JSON_UNQUOTE(JSON_EXTRACT(params, '$.user_id'));

    -- Calculate how much money others owe to the user
    SELECT
        COALESCE(SUM(es.amount), 0) INTO @money_others_owe
    FROM Expense e
    JOIN ExpenseSplit es
    ON es.expense_id = e.id
    WHERE e.workspace_id = @workspace_id 
    AND e.paid_by_user_id = @user_id
    AND es.user_id != @user_id;

    -- Calculate how much money the user owes to others
    SELECT 
        COALESCE(SUM(es.amount), 0) INTO @money_user_owes
    FROM Expense e
    JOIN ExpenseSplit es
    ON es.expense_id = e.id
    WHERE e.workspace_id = @workspace_id
    AND e.paid_by_user_id != @user_id
    AND es.user_id = @user_id; 

    -- Calculate total balance
    SET total_balance = @money_others_owe - @money_user_owes;

    -- Determine status
    IF total_balance > 0 THEN
        SET status = 'MoneyOwedToYou';

        -- Add details about who owes money to the user
        SELECT GROUP_CONCAT(
            CONCAT(u.name, ' te debe ', es.amount, ' Bs.')
            SEPARATOR '\n'
        ) INTO @owe_details
        FROM Expense e
        JOIN ExpenseSplit es
        ON es.expense_id = e.id
        JOIN User u
        ON u.id = es.user_id
        WHERE e.workspace_id = @workspace_id 
        AND e.paid_by_user_id = @user_id
        AND es.user_id != @user_id;

        IF @owe_details IS NOT NULL THEN
            SET details = CONCAT(details, @owe_details, '\n');
        END IF;

    ELSEIF total_balance < 0 THEN 
        SET status = 'MoneyOwedToOthers';

        -- Add details about who the user owes money to
        SELECT GROUP_CONCAT(
            CONCAT('Le debes ', es.amount, ' Bs. a ', u.name)
            SEPARATOR '\n'
        ) INTO @owes_details
        FROM Expense e
        JOIN ExpenseSplit es
        ON es.expense_id = e.id
        JOIN User u
        ON u.id = e.paid_by_user_id
        WHERE e.workspace_id = @workspace_id
        AND es.user_id = @user_id 
        AND e.paid_by_user_id != @user_id;

        IF @owes_details IS NOT NULL THEN
            SET details = CONCAT(details, @owes_details);
        END IF;

    ELSE
        SET status = 'Settled';

        -- If there are no details, it means all accounts are settled
        SET details = 'Todas las cuentas están en paz';
    END IF;

    -- Return a JSON with all the information
    RETURN JSON_OBJECT(
        'workspace_id', @workspace_id,
        'user_id', @user_id,
        'total_balance', total_balance,
        'status', status,
        'details', details
    );

END$$

DELIMITER ;