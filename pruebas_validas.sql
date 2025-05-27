-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Pruebas  válidas


-- Consultas básicas para ver el contenido de cada tabla

-- Ver usuarios
SELECT * FROM Usuario;


-- Ver tipos de transacción
SELECT * FROM TipoTransaccion;

-- Ver categorías
SELECT * FROM Categoria;

-- Ver cuentas bancarias
SELECT * FROM CuentaBancaria;

-- Ver transacciones
SELECT * FROM Transaccion;

-- Ver presupuestos
SELECT * FROM Presupuesto;

-- Ver metas financieras
SELECT * FROM Meta;

-- Ver historial de transacciones
SELECT * FROM HistorialTransaccion;

-- Consultas para ver el contenido de todas las vistas

-- 1. Vista de Balance General por Usuario
-- Muestra ingresos, gastos y balance total de cada usuario
SELECT * FROM BalanceGeneral;

-- 2. Vista de Gastos por Categoría y Usuario
-- Muestra el desglose de gastos por categoría para cada usuario
SELECT * FROM GastosUsuario;


-- 3. Vista de Seguimiento de Metas Financieras
-- Muestra el progreso de las metas financieras de cada usuario
SELECT * FROM SeguimientoMetasFinancieras;

-- 4. Vista de Seguimiento de Presupuestos
-- Muestra el estado actual de los presupuestos y su utilización
SELECT * FROM SeguimientoPresupuestos;

-- 5. Vista de Detalle de Transacciones
-- Muestra todas las transacciones con información detallada
SELECT * FROM DetalleTransacciones;

-- 6. Vista de Resumen Mensual de Transacciones
-- Muestra el resumen mensual de ingresos y gastos por usuario
SELECT * FROM ResumenTransacciones;

-- Pruebas de Trigger 

-- Trigger de historial al insertar una transacción
CALL RegistrarTransaccion(
    1, -- usuario_id (María González)
    2, -- tipo_transaccion_id (Gasto)
    1, -- cuenta_bancaria_id
    75.00, -- monto
    NOW(), -- fecha
    9, -- categoria_id (Alimentación)
    'Compra de verduras'
);

-- Verifica el historial:
SELECT * FROM HistorialTransaccion ORDER BY id DESC LIMIT 3;

--Trigger de historial al actualizar una transacción
UPDATE Transaccion SET descripcion = 'Compra de verduras y frutas' WHERE id = 1;

-- Verifica el historial:
SELECT * FROM HistorialTransaccion WHERE transaccion_id = 1 ORDER BY id DESC;

-- Trigger de historial al eliminar una transacción
CALL RegistrarTransaccion(
    1, -- usuario_id
    2, -- tipo_transaccion_id (Gasto)
    1, -- cuenta_bancaria_id
    500.00, -- monto (supera el presupuesto de Alimentación)
    NOW(),
    9, -- categoria_id (Alimentación)
    'Gasto grande en supermercado'
);

-- Verifica la alerta:
SELECT * FROM AlertaPresupuesto WHERE usuario_id = 1 AND categoria_id = 9 ORDER BY id DESC LIMIT 1;

-- Pruebas de funciones
-- 1. Obtener el saldo total de un usuario
SELECT ObtenerSaldoUsuario(1) AS saldo_maria;
SELECT ObtenerSaldoUsuario(2) AS saldo_juan;
SELECT ObtenerSaldoUsuario(3) AS saldo_ana;

-- 2. Obtener el Total de gastos de un usuario en un periodo
SELECT total_gastos_usuario_periodo(1, '2024-03-01', '2024-03-31') AS gastos_marzo_maria;

-- 3. Obtener el Total de ingresos de un usuario en un periodo
SELECT total_ingresos_usuario_periodo(1, '2024-03-01', '2024-03-31') AS ingresos_marzo_maria;

-- 4. Obtener el Porcentaje de avance de una meta financiera
-- Por ejemplo, para la meta con id=1
SELECT porcentaje_avance_meta(1);
--Ver los porcentajes de avance de todas las metas de un usuario
-- Por ejemplo, para el usuario con id=1
SELECT 
    id AS meta_id,
    monto_objetivo,
    progreso,
    ROUND((progreso / monto_objetivo) * 100, 2) AS porcentaje_avance
FROM 
    Meta
WHERE 
    usuario_id = 1;

--5. Obtener el Total de transacciones de un usuario en un mes específico
SELECT cantidad_transacciones_mes(1, 2024, 3) AS transacciones_marzo_maria;


-- Probar los Procedimientos
-- Registrar una transacción (ya lo hiciste arriba, puedes cambiar los valores)

CALL RegistrarTransaccion(
    2, -- usuario_id (Juan Pérez)
    1, -- tipo_transaccion_id (Ingreso)
    3, -- cuenta_bancaria_id
    1200.00, -- monto
    NOW(),
    2, -- categoria_id (Negocio Propio/Freelance)
    'Pago de proyecto freelance'
);

-- Transferir entre cuentas
CALL TransferirEntreCuentas(
    1, -- usuario_id (María González)
    1, -- cuenta_origen
    2, -- cuenta_destino
    100.00, -- monto
    'Transferencia de ahorro'
);

-- Verifica las transacciones y el historial:
SELECT * FROM Transaccion WHERE usuario_id = 1 ORDER BY id DESC LIMIT 2;
SELECT * FROM HistorialTransaccion ORDER BY id DESC LIMIT 2;