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

    -- Calcula cuánto dinero le deben otros al usuario
    SELECT
        COALESCE(SUM(es.amount), 0) INTO @money_others_owe
    FROM Expense e
    JOIN ExpenseSplit es
    ON es.expense_id = e.id
    WHERE e.workspace_id = @workspace_id 
    AND e.paid_by_user_id = @user_id
    AND es.user_id != @user_id;

    -- Calcula cuánto dinero debe el usuario a otros
    SELECT 
        COALESCE(SUM(es.amount), 0) INTO @money_user_owes
    FROM Expense e
    JOIN ExpenseSplit es
    ON es.expense_id = e.id
    WHERE e.workspace_id = @workspace_id
    AND e.paid_by_user_id != @user_id
    AND es.user_id = @user_id; 

    -- Calcula el balance total
    SET total_balance = @money_others_owe - @money_user_owes;

    -- Determina el estado
    IF total_balance > 0 THEN
        SET status = 'MoneyOwedToYou';
    ELSEIF total_balance < 0 THEN 
        SET status = 'MoneyOwedToOthers';
    ELSE
        SET status = 'Settled';
    END IF;

    -- Construye los detalles de quién debe a quién
    SET details = '';

    -- Agrega detalles de quién le debe al usuario
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

    -- Agrega detalles de a quién le debe el usuario
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

    -- Si no hay detalles, significa que todas las cuentas están en paz
    IF details = '' THEN
        SET details = 'Todas las cuentas están en paz';
    END IF;

    -- Retorna un JSON con toda la información
    RETURN JSON_OBJECT(
        'workspace_id', @workspace_id,
        'user_id', @user_id,
        'total_balance', total_balance,
        'status', status,
        'details', details
    );

END$$

DELIMITER ;