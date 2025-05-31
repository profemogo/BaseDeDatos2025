/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Test Data
 * 
 **/ 

 /**
  * Escenario:
  *
  * Juan Perez y Maria Gomez son un matrimonio y comparten los gastos del hogar. Sin embargo no tener un 
  * control adecuado de sus finanzas hacen que se sientan incomodos al no saber cuanto gastan en cada cosa. Y 
  * quien gasta más dinero. Es por eso que Juan decide descargar la app ExpensesApp para poder registrar sus 
  * gastos y ver cuanto gasta cada uno.
 */ 

-- Juan se registra en la app con su correo electronico y contraseña
-- (Automáticamente un trigger se encarga de encriptar su contraseña)
INSERT INTO User (
    name,
    email,
    phone,
    password_hash
) VALUES (
    'Juan Perez',
    'juan.perez@example.com',
    '04123456789',
    'mypassword.juan.perez'
);

-- Juan crea un workspace para registrar los gastos del hogar y decide que usaran Bolivares como moneda
INSERT INTO Workspace (
    name, 
    description, 
    currency_id,
    created_by_user_id
) VALUES (
    'Hogar', 
    'Gastos comunes del hogar',
    (SELECT id FROM Currency WHERE symbol = 'Bs.'),
    (SELECT id FROM User WHERE email = 'juan.perez@example.com'));

-- Juan invita a Maria a su workspace con su correo electronico
INSERT INTO WorkspaceInvitation (
    workspace_id,
    receiver_email,
    sender_user_id
) VALUES (
    (SELECT id FROM Workspace WHERE name = 'Hogar'),
    'maria.gomez@example.com',
    (SELECT id FROM User WHERE email = 'juan.perez@example.com')
);

-- Maria se registra en la app con su correo electronico y contraseña
-- (Automáticamente un trigger se encarga de encriptar su contraseña)
 INSERT INTO User (
    name,
    email,
    phone,
    password_hash
) VALUES (
    'Maria Gomez',
    'maria.gomez@example.com',
    '04145678912',
    'mypassword.maria.gomez'
);

-- Maria acepta la invitacion
-- (Automáticamente un trigger se encarga de agregarla al workspace)
UPDATE WorkspaceInvitation SET status = 'Accepted' 
WHERE receiver_email = 'maria.gomez@example.com' 
AND workspace_id = (SELECT id FROM Workspace WHERE name = 'Hogar');

-- Juan va de compras con Maria y decide registrar el gasto en el workspace
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

-- Maria se queda con la mitad del gasto
INSERT INTO ExpenseSplit (
    expense_id,
    user_id,
    amount,
    created_by_user_id
) VALUES (
    @new_expense_id,
    (SELECT id FROM User WHERE email = 'maria.gomez@example.com'),
    50,
    (SELECT id FROM User WHERE email = 'juan.perez@example.com')
);

-- Juan se queda con la mitad del gasto
INSERT INTO ExpenseSplit (
    expense_id,
    user_id,
    amount,
    created_by_user_id
) VALUES (
    @new_expense_id,
    (SELECT id FROM User WHERE email = 'juan.perez@example.com'),
    50,
    (SELECT id FROM User WHERE email = 'juan.perez@example.com')
);

-- Sin embargo Juan es muy despistado y registra el pago erróneamente. Por lo que Maria decide corregirlo

-- Primero cambia el nombre del gasto para que sea mas claro
-- (Automáticamente un trigger se encarga de registrar el comentario)
UPDATE Expense SET
    name = 'Compras Carnes y Pescado',
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE id = @new_expense_id;

-- Luego cambia el monto del gasto
-- (Automáticamente un trigger se encarga de registrar el comentario)
UPDATE Expense SET
    amount = 150,
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE id = @new_expense_id;

-- Luego cambia el monto de la contribución de Maria
-- (Automáticamente un trigger se encarga de registrar el comentario)
UPDATE ExpenseSplit SET
    amount = 75,
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE expense_id = @new_expense_id
AND user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com');

-- Luego cambia el monto de la contribución de Juan
-- (Automáticamente un trigger se encarga de registrar el comentario)
UPDATE ExpenseSplit SET
    amount = 75,
    updated_by_user_id = (SELECT id FROM User WHERE email = 'maria.gomez@example.com')
WHERE expense_id = @new_expense_id
AND user_id = (SELECT id FROM User WHERE email = 'juan.perez@example.com');