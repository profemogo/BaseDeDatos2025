-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
-- Pruebas  válidas

-- Insertar datos de prueba en las tablas
-- Insertar usuarios de prueba
INSERT INTO Usuario (nombre, email, password) VALUES
    ('María González', 'maria@email.com', 'password123'),
    ('Juan Pérez', 'juan@email.com', 'password456'),
    ('Ana Rodríguez', 'ana@email.com', 'password789');

-- Insertar cuentas bancarias
INSERT INTO CuentaBancaria (usuario_id, banco, numero_cuenta) VALUES
    (1, 'Banco Provincial', '1234-5678-9012-3456'),
    (1, 'Mercantil', '9876-5432-1098-7654'),
    (2, 'Banesco', '4567-8901-2345-6789'),
    (3, 'BOD', '8901-2345-6789-0123');

-- Insertar transacciones para María González
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion) VALUES
    -- Ingresos
    (1, 1, 1, 3000.00, '2024-03-01', 1, 'Salario mensual'),
    (1, 1, 1, 500.00, '2024-03-05', 3, 'Dividendos de inversiones'),
    -- Gastos
    (1, 2, 1, 800.00, '2024-03-02', 7, 'Alquiler'),
    (1, 2, 1, 200.00, '2024-03-03', 9, 'Compras supermercado'),
    (1, 2, 2, 150.00, '2024-03-04', 8, 'Gasolina'),
    (1, 2, 1, 120.00, '2024-04-01', 9, 'Compra de alimentos');

-- Insertar transacciones para Juan Pérez
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion) VALUES
    -- Ingresos
    (2, 1, 3, 2500.00, '2024-03-01', 2, 'Ingresos freelance'),
    -- Gastos
    (2, 2, 3, 600.00, '2024-03-02', 7, 'Alquiler'),
    (2, 2, 3, 300.00, '2024-03-03', 11, 'Curso online');

-- Insertar transacciones para Ana Rodríguez
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion) VALUES
    -- Ingresos
    (3, 1, 4, 3500.00, '2024-03-01', 1, 'Salario'),
    -- Gastos
    (3, 2, 4, 1000.00, '2024-03-02', 7, 'Alquiler'),
    (3, 2, 4, 400.00, '2024-03-03', 13, 'Ropa');

-- Insertar metas financieras
INSERT INTO Meta (usuario_id, nombre, monto_objetivo, fecha_objetivo, progreso) VALUES
    (1, 'Fondo de Emergencia', 5000.00, '2024-12-31', 2000.00),
    (1, 'Vacaciones', 3000.00, '2024-08-01', 500.00),
    (2, 'Nuevo Laptop', 2000.00, '2024-06-30', 800.00),
    (3, 'Maestría', 8000.00, '2025-01-01', 1500.00);

-- Insertar presupuestos
INSERT INTO Presupuesto (usuario_id, categoria_id, monto_limite, periodo) VALUES
    -- Presupuestos María González
    (1, 7, 1000.00, 'Mensual'),  -- Vivienda
    (1, 9, 400.00, 'Mensual'),   -- Alimentación
    (1, 8, 200.00, 'Mensual'),   -- Transporte
    
    -- Presupuestos Juan Pérez
    (2, 7, 800.00, 'Mensual'),   -- Vivienda
    (2, 11, 300.00, 'Mensual'),  -- Formación
    
    -- Presupuestos Ana Rodríguez
    (3, 7, 1200.00, 'Mensual'),  -- Vivienda
    (3, 13, 500.00, 'Mensual');  -- Ropa/Cuidado Personal

-- Insertar algunos registros en el historial de transacciones
INSERT INTO HistorialTransaccion (transaccion_id, cambio) VALUES
    (1, 'Creación de transacción de salario'),
    (3, 'Creación de transacción de alquiler'),
    (6, 'Creación de transacción de ingreso freelance');


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

-- Prueba del trigger de presupuesto
CALL RegistrarTransaccion(
    1, -- usuario_id
    2, -- tipo_transaccion_id (Gasto)
    1, -- cuenta_bancaria_id
    500.00, -- monto (supera el presupuesto de Alimentación)
    NOW(),
    9, -- categoria_id (Alimentación)
    'Gasto grande en supermercado'
);

-- Pruebas de funciones
-- 1. Obtener el saldo total de un usuario
SELECT ObtenerSaldoUsuario(1) AS saldo_maria;
SELECT ObtenerSaldoUsuario(2) AS saldo_juan;
SELECT ObtenerSaldoUsuario(3) AS saldo_ana;

-- 2. Obtener el Total de gastos de un usuario en un periodo
SELECT TotalGastosUsuarioPeriodo(1, '2024-03-01', '2024-03-31') AS GastosMarzoMaria;

-- 3. Obtener el Total de ingresos de un usuario en un periodo
SELECT TotalIngresosUsuarioPeriodo(1, '2024-03-01', '2024-03-31') AS IngresosMarzoMaria;

-- 4. Obtener el Porcentaje de avance de una meta financiera
-- Por ejemplo, para la meta con id=1
SELECT PorcentajeAvanceMeta(1);



--5. Obtener el Total de transacciones de un usuario en un mes específico
SELECT CantidadTransaccionesMes(1, 2024, 3) AS TransaccionesMarzoMaria;


-- Probar los Procedimientos

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

-- Pruebas del trigger de presupuesto
-- Primero creamos un usuario de prueba y verificamos su inserción
INSERT INTO Usuario (nombre, email, password) VALUES
('Usuario Prueba', 'prueba@test.com', '123');

-- Verificamos que el usuario se creó correctamente y guardamos su ID
SELECT @nuevo_usuario_id := id as id_usuario 
FROM Usuario 
WHERE email = 'prueba@test.com' 
ORDER BY id DESC 
LIMIT 1;

-- Verificamos que el usuario existe
SELECT * FROM Usuario WHERE id = @nuevo_usuario_id;

-- Si el usuario existe, continuamos con la creación de la cuenta bancaria
INSERT INTO CuentaBancaria (usuario_id, banco, numero_cuenta) VALUES
(@nuevo_usuario_id, 'Banco Test', '1234567890');

-- Guardamos el ID de la cuenta bancaria
SELECT @nueva_cuenta_id := id as id_cuenta
FROM CuentaBancaria
WHERE usuario_id = @nuevo_usuario_id
ORDER BY id DESC
LIMIT 1;

-- Verificamos que la cuenta se creó correctamente
SELECT * FROM CuentaBancaria WHERE id = @nueva_cuenta_id;

-- Creamos presupuestos para diferentes períodos usando el mismo ID
INSERT INTO Presupuesto (usuario_id, categoria_id, monto_limite, periodo) VALUES
-- Presupuesto mensual para Alimentación (categoría 9)
(@nuevo_usuario_id, 9, 1000.00, 'Mensual'),
-- Presupuesto anual para Vivienda (categoría 7)
(@nuevo_usuario_id, 7, 12000.00, 'Anual'),


-- Verificamos que los presupuestos se crearon correctamente
SELECT * FROM Presupuesto WHERE usuario_id = @nuevo_usuario_id;

-- Prueba 1: Transacción dentro del límite mensual
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (@nuevo_usuario_id, 2, @nueva_cuenta_id, 500.00, CURRENT_TIMESTAMP, 9, 'Compra de víveres');

-- Prueba 2: Transacción que supera el límite mensual
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (@nuevo_usuario_id, 2, @nueva_cuenta_id, 600.00, CURRENT_TIMESTAMP, 9, 'Compra de víveres adicionales');

-- Prueba 3: Transacción dentro del límite anual
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (@nuevo_usuario_id, 2, @nueva_cuenta_id, 5000.00, CURRENT_TIMESTAMP, 7, 'Pago de renta');

-- Prueba 4: Transacción que supera el límite anual
INSERT INTO Transaccion (usuario_id, tipo_transaccion_id, cuenta_bancaria_id, monto, fecha, categoria_id, descripcion)
VALUES (@nuevo_usuario_id, 2, @nueva_cuenta_id, 8000.00, CURRENT_TIMESTAMP, 7, 'Pago de renta adicional');

-- Verificar los resultados
SELECT 
    t.id,
    c.nombre as categoria,
    p.periodo,
    p.monto_limite,
    t.monto as monto_transaccion,
    DATE_FORMAT(t.fecha, '%Y-%m-%d') as fecha_transaccion
FROM Transaccion t
JOIN Categoria c ON t.categoria_id = c.id
JOIN Presupuesto p ON t.categoria_id = p.categoria_id AND t.usuario_id = p.usuario_id
WHERE t.usuario_id = @nuevo_usuario_id
ORDER BY t.id;

-- Limpiar datos de prueba
DELETE FROM Transaccion WHERE usuario_id = @nuevo_usuario_id;
DELETE FROM Presupuesto WHERE usuario_id = @nuevo_usuario_id;
DELETE FROM CuentaBancaria WHERE usuario_id = @nuevo_usuario_id;
DELETE FROM Usuario WHERE id = @nuevo_usuario_id;