-- Insert users
INSERT INTO User (name, email, phone, password_hash) VALUES ('Juan Perez', 'juan.perez@example.com', '04123456789', 'mypassword.juan.perez');
INSERT INTO User (name, email, phone, password_hash) VALUES ('Maria Gomez', 'maria.gomez@example.com', '04145678912', 'mypassword.maria.gomez');

-- Insert a workspace
INSERT INTO Workspace (name, description, currency_id) VALUES ('Hogar', 'Gastos comunes del hogar', (SELECT id FROM Currency WHERE symbol = 'Bs.'));

-- Insert a workspace user
INSERT INTO WorkspaceUser (workspace_id, user_id) VALUES (
    (SELECT id FROM Workspace WHERE name = 'Hogar'),
    (SELECT id FROM User WHERE email = 'juan.perez@example.com')
);
INSERT INTO WorkspaceUser (workspace_id, user_id) VALUES (
    (SELECT id FROM Workspace WHERE name = 'Hogar'),
    (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
);

-- Insert a Expense
INSERT INTO Expense (
    name,
    description,
    workspace_id,
    category_id,
    amount,
    expense_date,
    type,
    created_by_user_id
) VALUES (
    'Compras supermercado',
    '', 
    (SELECT id FROM Workspace WHERE name = 'Hogar'),
    (SELECT id FROM Category WHERE name = 'Supermercado'),
    100,
    '2021-01-01',
    'SplitEqual',
    (SELECT id FROM User WHERE email = 'juan.perez@example.com')
);
SELECT LAST_INSERT_ID() INTO @new_expense_id;

-- Update the expense name
UPDATE Expense SET
    name = 'Compras Carnes y Pescado',
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE id = @new_expense_id;

-- Update the expense amount
UPDATE Expense SET
    amount = 150,
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE id = @new_expense_id;

-- Update the expense date
UPDATE Expense SET
    expense_date = '2021-01-02',
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE id = @new_expense_id;