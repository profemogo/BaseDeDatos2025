-- =====================================================
-- SISTEMA DE USUARIOS Y ROLES - PROYECTO NELSON VIVAS
-- =====================================================
-- Archivo: users.sql
-- Propósito: Crear roles y usuarios con diferentes niveles de acceso
-- Orden de ejecución: 5to (después de processes.sql)
-- =====================================================

USE ProjectNelsonVivas;

-- =====================================================
-- ELIMINACIÓN DE USUARIOS Y ROLES EXISTENTES (SI EXISTEN)
-- =====================================================

-- Eliminar usuarios si existen
DROP USER IF EXISTS 'admin_nelson'@'localhost';
DROP USER IF EXISTS 'contabilidad'@'localhost';
DROP USER IF EXISTS 'facturacion'@'localhost';
DROP USER IF EXISTS 'consultas'@'localhost';
DROP USER IF EXISTS 'auditoria'@'localhost';
DROP USER IF EXISTS 'backup_user'@'localhost';

-- Eliminar roles si existen (MySQL 8.0+)
DROP ROLE IF EXISTS 'role_admin';
DROP ROLE IF EXISTS 'role_accounting';
DROP ROLE IF EXISTS 'role_billing';
DROP ROLE IF EXISTS 'role_readonly';
DROP ROLE IF EXISTS 'role_audit';

-- =====================================================
-- CREACIÓN DE ROLES
-- =====================================================

-- Rol de Administrador: Acceso completo
CREATE ROLE 'role_admin';

-- Rol de Contabilidad: Gestión contable y reportes
CREATE ROLE 'role_accounting';

-- Rol de Facturación: Gestión de facturas y clientes
CREATE ROLE 'role_billing';

-- Rol de Solo Lectura: Consultas únicamente
CREATE ROLE 'role_readonly';

-- Rol de Auditoría: Acceso a logs y auditoría
CREATE ROLE 'role_audit';

-- =====================================================
-- PERMISOS PARA ROL ADMINISTRADOR
-- =====================================================

-- Acceso completo a todas las tablas
GRANT ALL PRIVILEGES ON ProjectNelsonVivas.* TO 'role_admin';

-- Permisos para crear/eliminar usuarios y roles
GRANT CREATE USER ON *.* TO 'role_admin';
GRANT RELOAD ON *.* TO 'role_admin';
GRANT PROCESS ON *.* TO 'role_admin';

-- =====================================================
-- PERMISOS PARA ROL CONTABILIDAD
-- =====================================================

-- Acceso completo a tablas contables
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.AccountingAccount TO 'role_accounting';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.InvoiceAccountingEntry TO 'role_accounting';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.Retention TO 'role_accounting';

-- Acceso de lectura a facturas para reportes
GRANT SELECT ON ProjectNelsonVivas.SalesInvoice TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.PurchaseInvoice TO 'role_accounting';

-- Acceso a clientes/proveedores (solo lectura y actualización)
GRANT SELECT, UPDATE ON ProjectNelsonVivas.ClientProvider TO 'role_accounting';

-- Acceso a bancos para conciliación
GRANT SELECT, UPDATE ON ProjectNelsonVivas.Bank TO 'role_accounting';

-- Acceso a vistas
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.Vw_InvoiceJournalEntries TO 'role_accounting';

-- Procedimientos almacenados contables
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateAccountingAccount TO 'role_accounting';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateInvoiceAccountingEntry TO 'role_accounting';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordRetention TO 'role_accounting';

-- =====================================================
-- PERMISOS PARA ROL FACTURACIÓN
-- =====================================================

-- Acceso completo a facturas
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.SalesInvoice TO 'role_billing';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.PurchaseInvoice TO 'role_billing';

-- Acceso completo a clientes y proveedores
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.ClientProvider TO 'role_billing';

-- Acceso a métodos de pago
GRANT SELECT, INSERT, UPDATE ON ProjectNelsonVivas.PaymentMethod TO 'role_billing';

-- Acceso de lectura a bancos
GRANT SELECT ON ProjectNelsonVivas.Bank TO 'role_billing';

-- Acceso de lectura a cuentas contables
GRANT SELECT ON ProjectNelsonVivas.AccountingAccount TO 'role_billing';

-- Acceso a vistas relevantes
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_billing';
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_billing';

-- Procedimientos almacenados de facturación
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateClientProvider TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordSalesInvoice TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordPurchaseInvoice TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreatePaymentMethod TO 'role_billing';

-- =====================================================
-- PERMISOS PARA ROL SOLO LECTURA
-- =====================================================

-- Solo consultas en todas las tablas
GRANT SELECT ON ProjectNelsonVivas.* TO 'role_readonly';

-- Acceso a todas las vistas
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_readonly';
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_readonly';
GRANT SELECT ON ProjectNelsonVivas.Vw_InvoiceJournalEntries TO 'role_readonly';

-- =====================================================
-- PERMISOS PARA ROL AUDITORÍA
-- =====================================================

-- Acceso de solo lectura a todas las tablas
GRANT SELECT ON ProjectNelsonVivas.* TO 'role_audit';

-- Permisos especiales para auditoría
GRANT PROCESS ON *.* TO 'role_audit';
GRANT SHOW DATABASES ON *.* TO 'role_audit';

-- Acceso a logs del sistema (si están disponibles)
GRANT SELECT ON mysql.general_log TO 'role_audit';
GRANT SELECT ON mysql.slow_log TO 'role_audit';

-- =====================================================
-- CREACIÓN DE USUARIOS
-- =====================================================

-- Usuario Administrador Principal
CREATE USER 'admin_nelson'@'localhost' IDENTIFIED BY 'AdminNelson2025!';
GRANT 'role_admin' TO 'admin_nelson'@'localhost';
SET DEFAULT ROLE 'role_admin' TO 'admin_nelson'@'localhost';

-- Usuario de Contabilidad
CREATE USER 'contabilidad'@'localhost' IDENTIFIED BY 'Conta2025#';
GRANT 'role_accounting' TO 'contabilidad'@'localhost';
SET DEFAULT ROLE 'role_accounting' TO 'contabilidad'@'localhost';

-- Usuario de Facturación
CREATE USER 'facturacion'@'localhost' IDENTIFIED BY 'Factura2025$';
GRANT 'role_billing' TO 'facturacion'@'localhost';
SET DEFAULT ROLE 'role_billing' TO 'facturacion'@'localhost';

-- Usuario de Consultas (Solo Lectura)
CREATE USER 'consultas'@'localhost' IDENTIFIED BY 'Consulta2025%';
GRANT 'role_readonly' TO 'consultas'@'localhost';
SET DEFAULT ROLE 'role_readonly' TO 'consultas'@'localhost';

-- Usuario de Auditoría
CREATE USER 'auditoria'@'localhost' IDENTIFIED BY 'Audit2025&';
GRANT 'role_audit' TO 'auditoria'@'localhost';
SET DEFAULT ROLE 'role_audit' TO 'auditoria'@'localhost';

-- Usuario para Backups
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'Backup2025*';
GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON ProjectNelsonVivas.* TO 'backup_user'@'localhost';
