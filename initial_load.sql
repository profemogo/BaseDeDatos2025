-- =====================================================
-- INITIAL DATA LOAD - NELSON VIVAS PROJECT
-- =====================================================
-- File: initial_load.sql
-- Purpose: Load sample data to start working
-- Execution order: 6th (after users.sql)
-- =====================================================

USE ProjectNelsonVivas;

-- =====================================================
-- PAYMENT METHODS LOAD
-- =====================================================

INSERT INTO PaymentMethod (PaymentMethodName, Description, IsActive) VALUES
('Efectivo', 'Pago en efectivo', TRUE),
('Transferencia Bancaria', 'Transferencia electrónica between bank accounts', TRUE),
('Cheque', 'Pago mediante cheque bancario', TRUE),
('Tarjeta de Débito', 'Pago con tarjeta de débito', TRUE),
('Tarjeta de Crédito', 'Pago con tarjeta de crédito', TRUE),
('Depósito Bancario', 'Depósito directo en cuenta bancaria', TRUE),
('Pago Móvil', 'Pago a través de aplicaciones móviles bancarias', TRUE),
('Zelle', 'Transferencia mediante Zelle', TRUE),
('PayPal', 'Pago mediante PayPal', TRUE),
('Criptomonedas', 'Pago con monedas digitales (Bitcoin, USDT, etc.)', FALSE);

-- =====================================================
-- BANKS LOAD
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
-- ACCOUNTING ACCOUNTS LOAD
-- =====================================================

INSERT INTO AccountingAccount (AccountCode, AccountName, AccountType, IsActive) VALUES
-- Asset Accounts
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

-- Liability Accounts
('2101', 'Cuentas por Pagar Proveedores', 'Pasivo', TRUE),
('2102', 'Documentos por Pagar', 'Pasivo', TRUE),
('2201', 'IVA por Pagar', 'Pasivo', TRUE),
('2202', 'ISLR Retenido por Pagar', 'Pasivo', TRUE),
('2203', 'IVA Retenido por Pagar', 'Pasivo', TRUE),
('2301', 'Préstamos Bancarios', 'Pasivo', TRUE),

-- Equity Accounts
('3101', 'Capital Social', 'Patrimonio', TRUE),
('3201', 'Utilidades Retenidas', 'Patrimonio', TRUE),
('3301', 'Utilidad del Ejercicio', 'Patrimonio', TRUE),

-- Income Accounts
('4101', 'Ventas de Mercancías', 'Ingreso', TRUE),
('4102', 'Ventas de Servicios', 'Ingreso', TRUE),
('4201', 'Ingresos Financieros', 'Ingreso', TRUE),
('4301', 'Otros Ingresos', 'Ingreso', TRUE),

-- Expense Accounts
('5101', 'Costo de Ventas', 'Gasto', TRUE),
('5201', 'Gastos de Administración', 'Gasto', TRUE),
('5202', 'Gastos de Ventas', 'Gasto', TRUE),
('5301', 'Gastos Financieros', 'Gasto', TRUE),
('5401', 'Gastos de Personal', 'Gasto', TRUE),
('5402', 'Alquileres', 'Gasto', TRUE),
('5403', 'Servicios Públicos', 'Gasto', TRUE),
('5404', 'Mantenimiento y Reparaciones', 'Gasto', TRUE);

-- =====================================================
-- SAMPLE CLIENTS AND SUPPLIERS LOAD
-- =====================================================

-- Clients
CALL Sp_CreateClientProvider(
    'J-12345678-9',
    'Empresa ABC, C.A.',
    'Cliente',
    'Av. Principal, Centro Comercial ABC, Local 15, Caracas',
    '0212-555-0101',
    'ventas@empresaabc.com',
    3.00,  -- 3% of ISLR retention
    TRUE
);

CALL Sp_CreateClientProvider(
    'J-98765432-1',
    'Corporación XYZ, S.A.',
    'Cliente',
    'Calle Comercial, Torre XYZ, Piso 10, Valencia',
    '0241-555-0202',
    'compras@corpxyz.com',
    2.00,  -- 2% of ISLR retention
    TRUE
);

CALL Sp_CreateClientProvider(
    'V-11223344-5',
    'María González',
    'Cliente',
    'Urbanización Los Rosales, Casa 25, Maracay',
    '0243-555-0303',
    'maria.gonzalez@email.com',
    0.00,  -- No retention (natural person)
    TRUE
);

-- Suppliers
CALL Sp_CreateClientProvider(
    'J-55667788-0',
    'Distribuidora Nacional, C.A.',
    'Proveedor',
    'Zona Industrial, Galpón 8, Sector B, Caracas',
    '0212-555-0404',
    'facturacion@distnacional.com',
    1.00,  -- 1% of ISLR retention
    TRUE
);

CALL Sp_CreateClientProvider(
    'J-33445566-7',
    'Servicios Integrales del Centro, S.A.',
    'Proveedor',
    'Centro Empresarial, Torre C, Oficina 502, Barquisimeto',
    '0251-555-0505',
    'administracion@servicentro.com',
    2.00,  -- 2% of ISLR retention
    TRUE
);

CALL Sp_CreateClientProvider(
    'V-99887766-3',
    'Carlos Rodríguez',
    'Proveedor',
    'Av. Libertador, Edificio Comercial, Local 12, Maracaibo',
    '0261-555-0606',
    'carlos.rodriguez@freelancer.com',
    0.00,  -- No retention (natural person)
    TRUE
);

-- =====================================================
-- SAMPLE INVOICES LOAD
-- =====================================================

-- Sales Invoices
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

-- Purchase Invoices
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
-- SAMPLE ACCOUNTING ENTRIES LOAD
-- =====================================================

-- Entry for sale FAC-001-2025
CALL Sp_CreateInvoiceAccountingEntry(
    1,  -- SalesInvoiceID
    NULL,  -- PurchaseInvoiceID
    '2025-01-15',
    'Registro de venta FAC-001-2025 - Empresa ABC'
);

-- Entry for purchase COMP-001-2025
CALL Sp_CreateInvoiceAccountingEntry(
    NULL,  -- SalesInvoiceID
    1,  -- PurchaseInvoiceID
    '2025-01-10',
    'Registro de compra COMP-001-2025 - Distribuidora Nacional'
);

-- =====================================================
-- SAMPLE RETENTIONS LOAD
-- =====================================================

-- ISLR retention on sale to ABC Company (3%)
CALL Sp_RecordRetention(
    1,  -- SalesInvoiceID
    NULL,  -- PurchaseInvoiceID
    'ISLR',
    3.00,  -- 3%
    1500.00,  -- 3% of 50,000
    '2025-01-15',
    'Retención ISLR 3% sobre venta FAC-001-2025'
);

-- ISLR retention on purchase from National Distributor (1%)
CALL Sp_RecordRetention(
    NULL,  -- SalesInvoiceID
    1,  -- PurchaseInvoiceID
    'ISLR',
    1.00,  -- 1%
    750.00,  -- 1% of 75,000
    '2025-01-10',
    'Retención ISLR 1% sobre compra COMP-001-2025'
);

-- =====================================================
-- VERIFICATION OF LOADED DATA
-- =====================================================

-- Show summary of loaded data
SELECT 'INITIAL DATA LOAD SUMMARY' AS message;

SELECT 
    'Métodos de Pago' AS table,
    COUNT(*) AS records_loaded
FROM PaymentMethod
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Bancos' AS table,
    COUNT(*) AS records_loaded
FROM Bank
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Cuentas Contables' AS table,
    COUNT(*) AS records_loaded
FROM AccountingAccount
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Clientes/Proveedores' AS table,
    COUNT(*) AS records_loaded
FROM ClientProvider
WHERE IsActive = TRUE

UNION ALL

SELECT 
    'Facturas de Venta' AS table,
    COUNT(*) AS records_loaded
FROM SalesInvoice

UNION ALL

SELECT 
    'Facturas de Compra' AS table,
    COUNT(*) AS records_loaded
FROM PurchaseInvoice

UNION ALL

SELECT 
    'Asientos Contables' AS table,
    COUNT(*) AS records_loaded
FROM InvoiceAccountingEntry

UNION ALL

SELECT 
    'Retenciones' AS table,
    COUNT(*) AS records_loaded
FROM Retention;

-- =====================================================
-- DETAILED VERIFICATION QUERIES
-- =====================================================

-- Show current bank balances
SELECT 'CURRENT BANK BALANCES' AS title;
SELECT * FROM Vw_BankBalances;

-- Show pending accounts receivable
SELECT 'PENDING ACCOUNTS RECEIVABLE' AS title;
SELECT * FROM Vw_PendingReceivables;

-- Show generated accounting entries
SELECT 'GENERATED ACCOUNTING ENTRIES' AS title;
SELECT * FROM Vw_InvoiceJournalEntries;

-- =====================================================
-- ADDITIONAL TEST DATA
-- =====================================================

-- Create some additional banks for testing
CALL Sp_CreateBank(
    'Banco Digital Ejemplo',
    '01990123456789012345',
    'Corriente',
    100000.00,
    'digital_user:digital2025'
);

-- Create additional payment methods
INSERT INTO PaymentMethod (PaymentMethodName, Description, IsActive) VALUES
('Binance Pay', 'Pago mediante Binance Pay', TRUE),
('Uphold', 'Transferencia mediante Uphold', TRUE),
('Reserve', 'Pago con Reserve App', TRUE);

-- Create specific additional accounting accounts
INSERT INTO AccountingAccount (AccountCode, AccountName, AccountType, IsActive) VALUES
('1106', 'Banco Digital Ejemplo', 'Activo', TRUE),
('4401', 'Ingresos por Servicios Digitales', 'Ingreso', TRUE),
('5501', 'Gastos de Tecnología', 'Gasto', TRUE),
('5502', 'Comisiones Bancarias', 'Gasto', TRUE);

-- =====================================================
-- FINAL MESSAGE
-- =====================================================

SELECT 
    'INITIAL LOAD COMPLETED SUCCESSFULLY' AS message,
    NOW() AS load_date,
    'The system is ready to use with sample data' AS status;

-- =====================================================
-- END OF FILE initial_load.sql
-- =====================================================
