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
  * Escenario 1:
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
SET @user_juan_id = LAST_INSERT_ID();

-- Juan crea un workspace para registrar los gastos del hogar y decide que usaran Bolivares como moneda
SET @currency_bolivar_id = (SELECT id FROM Currency WHERE symbol = 'Bs.');
INSERT INTO Workspace (
    name, 
    description, 
    currency_id,
    created_by_user_id
) VALUES (
    'Hogar', 
    'Gastos comunes del hogar',
    @currency_bolivar_id,
    @user_juan_id
);
SET @workspace_hogar_id = LAST_INSERT_ID();

-- Juan invita a Maria a su workspace con su correo electronico
INSERT INTO WorkspaceInvitation (
    workspace_id,
    receiver_email,
    sender_user_id
) VALUES (
    @workspace_hogar_id,
    'maria.gomez@example.com',
    @user_juan_id
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
SET @user_maria_id = LAST_INSERT_ID();

-- Maria acepta la invitacion
-- (Automáticamente un trigger se encarga de agregarla al workspace)
UPDATE WorkspaceInvitation SET status = 'Accepted' 
WHERE receiver_email = 'maria.gomez@example.com' 
AND workspace_id = @workspace_hogar_id;

-- Juan va de compras con Maria, Maria paga y le pide a Juan que registre el gasto en el workspace
SET @category_supermercado_id = (SELECT id FROM Category WHERE name = 'Supermercado');
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Compras supermercado',
        'description', 'Compras de supermercado', 
        'workspace_id', @workspace_hogar_id,
        'category_id', @category_supermercado_id,
        'amount', 100,
        'expense_date', '2025-05-31 12:00:05',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_maria_id,
        'created_by_user_id', @user_juan_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_maria_id,
            'amount', 50
        ),
        JSON_OBJECT(
            'user_id', @user_juan_id,
            'amount', 50
        )
    ),
    @new_expense_id
);

-- Sin embargo Juan es muy despistado y registra el pago erróneamente. 
-- Por lo que Maria con el fin de que los gastos sean correctos y claros
-- decide corregirlo por su cuenta y evitar discutir con Juan.
-- (Automáticamente un trigger se encarga de registrar los comentarios)
CALL UpdateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Compras Carnes y Pescado',
        'description', 'Compras de carnes y pescado',
        'workspace_id', @workspace_hogar_id,
        'category_id', @category_supermercado_id,
        'amount', 150,
        'expense_date', '2025-05-31 12:00:05',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_maria_id,
        'updated_by_user_id', @user_maria_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_maria_id,
            'amount', 75
        ),
        JSON_OBJECT(
            'user_id', @user_juan_id,
            'amount', 75
        )
    ),
    @new_expense_id
);

-- Los comentarios de la transacción a este punto son los siguientes (obtenidos mediante una consulta a la vista ExpenseCommentView):

-- Maria Gomez modificó esta transacción: El nombre de esta transacción fue cambiado de Compras supermercado a Compras Carnes y Pescado
-- Maria Gomez modificó esta transacción: La descripción de esta transacción fue cambiada de Compras de supermercado a Compras de carnes y pescado
-- Maria Gomez modificó esta transacción: El monto de esta transacción fue cambiado de 100.00 a 150.00
-- Maria Gomez modificó esta transacción: La contribución de Maria Gomez fue cambiada de 50.00 a 75.00
-- Maria Gomez modificó esta transacción: La contribución de Juan Perez fue cambiada de 50.00 a 75.00

-- Finalmente JuanOB le paga a Maria la deuda de 75 Bs.
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Pago de deuda',
        'description', 'Pago de deuda',
        'workspace_id', @workspace_hogar_id,
        'category_id', @category_supermercado_id,
        'amount', 75,
        'expense_date', '2025-05-31 12:00:05',
        'type', 'Transfer',
        'paid_by_user_id', @user_juan_id,
        'created_by_user_id', @user_maria_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_maria_id,
            'amount', 75
        )
    ),
    @new_expense_id
);