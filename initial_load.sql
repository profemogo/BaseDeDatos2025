-- =====================================================
-- CARGA INICIAL DE DATOS - PROYECTO NELSON VIVAS
-- =====================================================
-- Archivo: initial_load.sql
-- Propósito: Cargar datos de ejemplo para comenzar a trabajar
-- Orden de ejecución: 6to (después de users.sql)
-- =====================================================

USE ProjectNelsonVivas;

-- =====================================================
-- CARGA DE MÉTODOS DE PAGO
-- =====================================================

INSERT INTO PaymentMethod (PaymentMethodName, Description, IsActive) VALUES
('Efectivo', 'Pago en efectivo', TRUE),
('Transferencia Bancaria', 'Transferencia electrónica entre cuentas bancarias', TRUE),
('Cheque', 'Pago mediante cheque bancario', TRUE),
('Tarjeta de Débito', 'Pago con tarjeta de débito', TRUE),
('Tarjeta de Crédito', 'Pago con tarjeta de crédito', TRUE),
('Depósito Bancario', 'Depósito directo en cuenta bancaria', TRUE),
('Pago Móvil', 'Pago a través de aplicaciones móviles bancarias', TRUE),
('Zelle', 'Transferencia mediante Zelle', TRUE),
('PayPal', 'Pago mediante PayPal', TRUE),
('Criptomonedas', 'Pago con monedas digitales (Bitcoin, USDT, etc.)', FALSE);

-- =====================================================
-- CARGA DE BANCOS
-- =====================================================

INSERT INTO Bank (BankName, AccountNumber, AccountType, Balance, BankCredentials, IsActive) VALUES
('Banco de Venezuela', '01020123456789012345', 'Corriente', 150000.00, AES_ENCRYPT('usuario_bv:password123', 'encryption_key_2025'), TRUE),
('Banesco', '01340987654321098765', 'Corriente', 250000.00, AES_ENCRYPT('banesco_user:banesco2025', 'encryption_key_2025'), TRUE),
('Banco Mercantil', '01050555666777888999', 'Ahorro', 75000.00, AES_ENCRYPT('mercantil_admin:merc2025', 'encryption_key_2025'), TRUE),
('BBVA Provincial', '01080111222333444555', 'Corriente', 320000.00, AES_ENCRYPT('bbva_user:provincial123', 'encryption_key_2025'), TRUE),
('Banco Bicentenario', '01750777888999000111', 'Ahorro', 45000.00, AES_ENCRYPT('bicent_user:bicent2025', 'encryption_key_2025'), TRUE),
('Banco del Tesoro', '01630222333444555666', 'Corriente', 180000.00, AES_ENCRYPT('tesoro_admin:tesoro123', 'encryption_key_2025'), TRUE),
('Bancaribe', '01140444555666777888', 'Corriente', 95000.00, AES_ENCRYPT('caribe_user:caribe2025', 'encryption_key_2025'), TRUE),
('Banco Exterior', '01150666777888999000', 'Ahorro', 60000.00, AES_ENCRYPT('exterior_user:ext2025', 'encryption_key_2025'), FALSE);

-- =====================================================
-- CARGA DE CUENTAS CONTABLES
-- =====================================================

INSERT INTO AccountingAccount (AccountCode, AccountName, AccountType, IsActive) VALUES
-- Cuentas de Activo
('1101', 'Caja', 'Activo', TRUE),
('1102', 'Banco de Venezuela', 'Activo', TRUE),
('1103', 'Banesco', 'Activo', TRUE),
('1104', 'Banco Mercantil', 'Activo', TRUE),
('1105', 'BBVA Provincial', 'Activo', TRUE),
('1201', 'Cuentas por Cobrar Clientes', 'Activo', TRUE),
('1202', 'Documentos por Cobrar', 'Activo', TRUE),
('1301', 'Inventario de Mercancías', 'Activo', TRUE),
('1401', 'Mobiliario y Equipos', 'Activo', TRUE),
('1402', 'Equipos de Computación', 'Activo', TRUE),

-- Cuentas de Pasivo
('2101', 'Cuentas por Pagar Proveedores', 'Pasivo', TRUE),
('2102', 'Documentos por Pagar', 'Pasivo', TRUE),
('2201', 'IVA por Pagar', 'Pasivo', TRUE),
('2202', 'ISLR Retenido por Pagar', 'Pasivo', TRUE),
('2203', 'IVA Retenido por Pagar', 'Pasivo', TRUE),
('2301', 'Préstamos Bancarios', 'Pasivo', TRUE),

-- Cuentas de Patrimonio
('3101', 'Capital Social', 'Patrimonio', TRUE),
('3201', 'Utilidades Retenidas', 'Patrimonio', TRUE),
('3301', 'Utilidad del Ejercicio', 'Patrimonio', TRUE),

-- Cuentas de Ingresos
('4101', 'Ventas de Mercancías', 'Ingreso', TRUE),
('4102', 'Ventas de Servicios', 'Ingreso', TRUE),
('4201', 'Ingresos Financieros', 'Ingreso', TRUE),
('4301', 'Otros Ingresos', 'Ingreso', TRUE),

-- Cuentas de Gastos
('5101', 'Costo de Ventas', 'Gasto', TRUE),
('5201', 'Gastos de Administración', 'Gasto', TRUE),
('5202', 'Gastos de Ventas', 'Gasto', TRUE),
('5301', 'Gastos Financieros', 'Gasto', TRUE),
('5401', 'Gastos de Personal', 'Gasto', TRUE),
('5402', 'Alquileres', 'Gasto', TRUE),
('5403', 'Servicios Públicos', 'Gasto', TRUE),
('5404', 'Mantenimiento y Reparaciones', 'Gasto', TRUE);

-- =====================================================
-- CARGA DE CLIENTES Y PROVEEDORES DE EJEMPLO
-- =====================================================

-- Clientes
CALL Sp_CreateClientProvider(
    'J-12345678-9',
    'Empresa ABC, C.A.',
    'Cliente',
    'Av. Principal, Centro Comercial ABC, Local 15, Caracas',
    '0212-555-0101',
    'ventas@empresaabc.com',
    3.00,  -- 3% de retención ISLR
    TRUE
);

CALL Sp_CreateClientProvider(
    'J-98765432-1',
    'Corporación XYZ, S.A.',
    'Cliente',
    'Calle Comercial, Torre XYZ, Piso 10, Valencia',
    '0241-555-0202',
    'compras@corpxyz.com',
    2.00,  -- 2% de retención ISLR
    TRUE
);

CALL Sp_CreateClientProvider(
    'V-11223344-5',
    'María González',
    'Cliente',
    'Urbanización Los Rosales, Casa 25, Maracay',
    '0243-555-0303',
    'maria.gonzalez@email.com',
    0.00,  -- Sin retención (persona natural)
    TRUE
);

-- Proveedores
CALL Sp_CreateClientProvider(
    'J-55667788-0',
    'Distribuidora Nacional, C.A.',
    'Proveedor',
    'Zona Industrial, Galpón 8, Sector B, Caracas',
    '0212-555-0404',
    'facturacion@distnacional.com',
    1.00,  -- 1% de retención ISLR
    TRUE
);

CALL Sp_CreateClientProvider(
    'J-33445566-7',
    'Servicios Integrales del Centro, S.A.',
    'Proveedor',
    'Centro Empresarial, Torre C, Oficina 502, Barquisimeto',
    '0251-555-0505',
    'administracion@servicentro.com',
    2.00,  -- 2% de retención ISLR
    TRUE
);

CALL Sp_CreateClientProvider(
    'V-99887766-3',
    'Carlos Rodríguez',
    'Proveedor',
    'Av. Libertador, Edificio Comercial, Local 12, Maracaibo',
    '0261-555-0606',
    'carlos.rodriguez@freelancer.com',
    0.00,  -- Sin retención (persona natural)
    TRUE
);

-- =====================================================
-- CARGA DE FACTURAS DE EJEMPLO
-- =====================================================

-- Facturas de Venta
CALL Sp_RecordSalesInvoice(
    1,  -- ClientProviderID (Empresa ABC)
    'FAC-001-2025',
    '2025-01-15',
    50000.00,
    8000.00,  -- IVA 16%
    58000.00,
    1,  -- PaymentMethodID (Efectivo)
    NULL,  -- BankID
    'Venta de productos varios según cotización #001'
);

CALL Sp_RecordSalesInvoice(
    2,  -- ClientProviderID (Corporación XYZ)
    'FAC-002-2025',
    '2025-01-16',
    125000.00,
    20000.00,  -- IVA 16%
    145000.00,
    2,  -- PaymentMethodID (Transferencia)
    2,  -- BankID (Banesco)
    'Servicios de consultoría empresarial - Enero 2025'
);

CALL Sp_RecordSalesInvoice(
    3,  -- ClientProviderID (María González)
    'FAC-003-2025',
    '2025-01-17',
    25000.00,
    4000.00,  -- IVA 16%
    29000.00,
    7,  -- PaymentMethodID (Pago Móvil)
    1,  -- BankID (Banco de Venezuela)
    'Venta al detal - productos de consumo'
);

-- Facturas de Compra
CALL Sp_RecordPurchaseInvoice(
    4,  -- ClientProviderID (Distribuidora Nacional)
    'COMP-001-2025',
    '2025-01-10',
    75000.00,
    12000.00,  -- IVA 16%
    87000.00,
    2,  -- PaymentMethodID (Transferencia)
    3,  -- BankID (Banco Mercantil)
    'Compra de mercancía para inventario'
);

CALL Sp_RecordPurchaseInvoice(
    5,  -- ClientProviderID (Servicios Integrales)
    'COMP-002-2025',
    '2025-01-12',
    35000.00,
    5600.00,  -- IVA 16%
    40600.00,
    3,  -- PaymentMethodID (Cheque)
    4,  -- BankID (BBVA Provincial)
    'Servicios de mantenimiento de equipos'
);

-- =====================================================
-- CARGA DE ASIENTOS CONTABLES DE EJEMPLO
-- =====================================================

-- Asiento por venta FAC-001-2025
CALL Sp_CreateInvoiceAccountingEntry(
    1,  -- SalesInvoiceID
    NULL,  -- PurchaseInvoiceID
    '2025-01-15',
    'Registro de venta FAC-001-2025 - Empresa ABC'
);

-- Asiento por compra COMP-001-2025
CALL Sp_CreateInvoiceAccountingEntry(
    NULL,  -- SalesInvoiceID
    1,  -- PurchaseInvoiceID
    '2025-01-10',
    'Registro de compra COMP-001-2025 - Distribuidora Nacional'
);

-- =====================================================
-- CARGA DE RETENCIONES DE EJEMPLO
-- =====================================================

-- Retención ISLR sobre venta a Empresa ABC (3%)
CALL Sp_RecordRetention(
    1,  -- SalesInvoiceID
    NULL,  -- PurchaseInvoiceID
    'ISLR',
    3.00,  -- 3%
    1500.00,  -- 3% de 50,000
    '2025-01-15',
    'Retención ISLR 3% sobre venta FAC-001-2025'
);

-- Retención ISLR sobre compra a Distribuidora Nacional (1%)
CALL Sp_RecordRetention(
    NULL,  -- SalesInvoiceID
    1,  -- PurchaseInvoiceID
    'ISLR',
    1.00,  -- 1%
    750.00,  -- 1% de 75,000
    '2025-01-10',
    'Retención ISLR 1% sobre compra COMP-001-2025'
);

-- =====================================================
-- VERIFICACIÓN DE DATOS CARGADOS
-- =====================================================

-- Mostrar resumen de datos cargados
SELECT 'RESUMEN DE CARGA INICIAL DE DATOS' AS mensaje;

SELECT 
    'Métodos de Pago' AS tabla,
    COUNT(*) AS registros_cargados
FROM PaymentMethod
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Bancos' AS tabla,
    COUNT(*) AS registros_cargados
FROM Bank
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Cuentas Contables' AS tabla,
    COUNT(*) AS registros_cargados
FROM AccountingAccount
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Clientes/Proveedores' AS tabla,
    COUNT(*) AS registros_cargados
FROM ClientProvider
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Facturas de Venta' AS tabla,
    COUNT(*) AS registros_cargados
FROM SalesInvoice

UNION ALL

SELECT 
    'Facturas de Compra' AS tabla,
    COUNT(*) AS registros_cargados
FROM PurchaseInvoice

UNION ALL

SELECT 
    'Asientos Contables' AS tabla,
    COUNT(*) AS registros_cargados
FROM InvoiceAccountingEntry

UNION ALL

SELECT 
    'Retenciones' AS tabla,
    COUNT(*) AS registros_cargados
FROM Retention;

-- =====================================================
-- CONSULTAS DE VERIFICACIÓN DETALLADAS
-- =====================================================

-- Mostrar saldos bancarios actuales
SELECT 'SALDOS BANCARIOS ACTUALES' AS titulo;
SELECT * FROM Vw_BankBalances;

-- Mostrar cuentas por cobrar pendientes
SELECT 'CUENTAS POR COBRAR PENDIENTES' AS titulo;
SELECT * FROM Vw_PendingReceivables;

-- Mostrar asientos contables generados
SELECT 'ASIENTOS CONTABLES GENERADOS' AS titulo;
SELECT * FROM Vw_InvoiceJournalEntries;

-- =====================================================
-- DATOS ADICIONALES PARA PRUEBAS
-- =====================================================

-- Crear algunos bancos adicionales para pruebas
CALL Sp_CreateBank(
    'Banco Digital Ejemplo',
    '01990123456789012345',
    'Corriente',
    100000.00,
    'digital_user:digital2025'
);

-- Crear métodos de pago adicionales
INSERT INTO PaymentMethod (PaymentMethodName, Description, IsActive) VALUES
('Binance Pay', 'Pago mediante Binance Pay', TRUE),
('Uphold', 'Transferencia mediante Uphold', TRUE),
('Reserve', 'Pago con Reserve App', TRUE);

-- Crear cuentas contables adicionales específicas
INSERT INTO AccountingAccount (AccountCode, AccountName, AccountType, IsActive) VALUES
('1106', 'Banco Digital Ejemplo', 'Activo', TRUE),
('4401', 'Ingresos por Servicios Digitales', 'Ingreso', TRUE),
('5501', 'Gastos de Tecnología', 'Gasto', TRUE),
('5502', 'Comisiones Bancarias', 'Gasto', TRUE);

-- =====================================================
-- MENSAJE FINAL
-- =====================================================

SELECT 
    'CARGA INICIAL COMPLETADA EXITOSAMENTE' AS mensaje,
    NOW() AS fecha_carga,
    'El sistema está listo para usar con datos de ejemplo' AS estado;

-- =====================================================
-- FIN DEL ARCHIVO initial_load.sql
-- =====================================================
