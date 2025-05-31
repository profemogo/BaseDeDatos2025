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
  * Escenario 2:
  *
  * Carlos y Ana son hermanos que comparten un apartamento. Para mantener sus finanzas organizadas y evitar 
  * confusiones sobre quién paga qué, deciden usar ExpensesApp para registrar y dividir los gastos del 
  * apartamento de manera justa y transparente.
 */ 

-- Carlos se registra en la app con su correo electronico y contraseña
-- (Automáticamente un trigger se encarga de encriptar su contraseña)
INSERT INTO User (
    name,
    email,
    phone,
    password_hash
) VALUES (
    'Carlos Rodriguez',
    'carlos.rodriguez@example.com',
    '04123456798',
    'mypassword.carlos.rodriguez'
);
SET @user_carlos_id = LAST_INSERT_ID();

-- Carlos crea un workspace para registrar los gastos del apartamento y decide que usaran Bolivares como moneda
SET @currency_bolivar_id = (SELECT id FROM Currency WHERE symbol = 'Bs.');
INSERT INTO Workspace (
    name, 
    description, 
    currency_id,
    created_by_user_id
) VALUES (
    'Apartamento', 
    'Gastos compartidos del apartamento',
    @currency_bolivar_id,
    @user_carlos_id
);
SET @workspace_apartamento_id = LAST_INSERT_ID();

-- Carlos invita a su hermana Ana al workspace con su correo electronico
INSERT INTO WorkspaceInvitation (
    workspace_id,
    receiver_email,
    sender_user_id
) VALUES (
    @workspace_apartamento_id,
    'ana.rodriguez@example.com',
    @user_carlos_id
);

-- Ana se registra en la app con su correo electronico y contraseña
-- (Automáticamente un trigger se encarga de encriptar su contraseña)
INSERT INTO User (
    name,
    email,
    phone,
    password_hash
) VALUES (
    'Ana Rodriguez',
    'ana.rodriguez@example.com',
    '04145678572',
    'mypassword.ana.rodriguez'
);
SET @user_ana_id = LAST_INSERT_ID();

-- Ana acepta la invitacion
-- (Automáticamente un trigger se encarga de agregarla al workspace)
UPDATE WorkspaceInvitation SET status = 'Accepted' 
WHERE receiver_email = 'ana.rodriguez@example.com' 
AND workspace_id = @workspace_apartamento_id;

-- Ana hace la compra mensual del mercado y le pide a Carlos que registre el gasto
SET @category_supermercado_id = (SELECT id FROM Category WHERE name = 'Supermercado');
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Compras mercado mensual',
        'description', 'Compras del mes en el supermercado', 
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 100,
        'expense_date', '2025-05-31 12:00:05',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_ana_id,
        'created_by_user_id', @user_carlos_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 50
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 50
        )
    ),
    @new_expense_id
);

-- Carlos se equivoca al registrar el monto, el mismo arregla el error
-- para mantener las cuentas exactas
-- (Automáticamente un trigger se encarga de registrar los comentarios)
CALL UpdateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Compras mercado mensual',
        'description', 'Compras del mes en el supermercado',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 150,
        'expense_date', '2025-05-31 12:00:05',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_ana_id,
        'updated_by_user_id', @user_carlos_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 75
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 75
        )
    ),
    @new_expense_id
);

-- Los comentarios de la transacción a este punto son los siguientes (obtenidos mediante una consulta a la vista ExpenseCommentView):

-- Carlos Rodriguez modificó esta transacción: El monto de esta transacción fue cambiado de 100.00 a 150.00
-- Carlos Rodriguez modificó esta transacción: La contribución de Ana Rodriguez fue cambiada de 50.00 a 75.00
-- Carlos Rodriguez modificó esta transacción: La contribución de Carlos Rodriguez fue cambiada de 50.00 a 75.00

-- Ana paga la cena (Split igual)
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Cena en restaurante',
        'description', 'Cena del viernes',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 200,
        'expense_date', '2025-06-01 20:00:00',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_ana_id,
        'created_by_user_id', @user_ana_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 100
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 100
        )
    ),
    @new_expense_id
);

-- Carlos paga las compras del hogar (Split desigual)
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Artículos de limpieza',
        'description', 'Productos de limpieza y aseo',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 180,
        'expense_date', '2025-06-02 15:30:00',
        'type', 'SplitUnequal',
        'paid_by_user_id', @user_carlos_id,
        'created_by_user_id', @user_carlos_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 70
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 110
        )
    ),
    @new_expense_id
);

-- Ana paga el internet (Split igual)
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Servicio de Internet',
        'description', 'Internet del mes de junio',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 120,
        'expense_date', '2025-06-03 09:00:00',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_ana_id,
        'created_by_user_id', @user_ana_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 60
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 60
        )
    ),
    @new_expense_id
);

-- Carlos paga las compras del supermercado (Split desigual)
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Compras varias',
        'description', 'Snacks y bebidas',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 90,
        'expense_date', '2025-06-04 16:45:00',
        'type', 'SplitUnequal',
        'paid_by_user_id', @user_carlos_id,
        'created_by_user_id', @user_carlos_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 30
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 60
        )
    ),
    @new_expense_id
);

-- Ana paga la luz (Split igual)
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Servicio eléctrico',
        'description', 'Factura de electricidad',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 160,
        'expense_date', '2025-06-05 10:15:00',
        'type', 'SplitEqual',
        'paid_by_user_id', @user_ana_id,
        'created_by_user_id', @user_ana_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 80
        ),
        JSON_OBJECT(
            'user_id', @user_carlos_id,
            'amount', 80
        )
    ),
    @new_expense_id
);

-- Calculando el balance manualmente:
-- Ana pagó:
-- - Mercado mensual: 150 (le deben 75)
-- - Cena: 200 (le deben 100) 
-- - Internet: 120 (le deben 60)
-- - Luz: 160 (le deben 80)
-- Total pagado por Ana: 630
-- Total que le deben a Ana: 315

-- Carlos pagó:
-- - Artículos limpieza: 180 (le deben 70)
-- - Compras varias: 90 (le deben 30)
-- Total pagado por Carlos: 270
-- Total que le deben a Carlos: 100

-- Balance final:
-- Carlos debe pagarle a Ana: 315 - 100 = 215

-- Carlos le paga a Ana lo que le debe
CALL CreateExpenseWithSplits(
    JSON_OBJECT(
        'name', 'Liquidación de deudas',
        'description', 'Pago de balance pendiente',
        'workspace_id', @workspace_apartamento_id,
        'category_id', @category_supermercado_id,
        'amount', 215,
        'expense_date', '2025-06-06 11:00:00',
        'type', 'Transfer',
        'paid_by_user_id', @user_carlos_id,
        'created_by_user_id', @user_carlos_id
    ),
    JSON_ARRAY(
        JSON_OBJECT(
            'user_id', @user_ana_id,
            'amount', 215
        )
    ),
    @new_expense_id
);

-- Finalmente Carlos se independiza y se retira del workspace
DELETE FROM WorkspaceUser WHERE user_id = @user_carlos_id AND workspace_id = @workspace_apartamento_id;

-- Tiempo despues decide eliminar su cuenta de ExpenseApp porque ya no comparte gastos y no le interesa tener control de sus finanzas
CALL CreateDeleteUser(@user_carlos_id);