-- =====================================================
-- USERS AND ROLES - NELSON VIVAS PROJECT
-- =====================================================
-- File: users.sql
-- Purpose: Create roles and users with different access levels
-- Execution order: 5th (after processes.sql)
-- =====================================================

USE ProjectNelsonVivas;

-- =====================================================
-- DELETION OF EXISTING USERS AND ROLES (IF EXISTS)
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
-- CREATION OF ROLES
-- =====================================================

-- Admin role: Full access
CREATE ROLE 'role_admin';

-- Accounting role: Accounting management and reports
CREATE ROLE 'role_accounting';

-- Billing role: Invoice management and clients
CREATE ROLE 'role_billing';

-- Read-only role: Only queries
CREATE ROLE 'role_readonly';

-- Audit role: Access to logs and audit
CREATE ROLE 'role_audit';

-- =====================================================
-- PERMISSIONS FOR ADMIN ROLE
-- =====================================================

-- Full access to all tables
GRANT ALL PRIVILEGES ON ProjectNelsonVivas.* TO 'role_admin';

-- Permissions to create/delete users and roles
GRANT CREATE USER ON *.* TO 'role_admin';
GRANT RELOAD ON *.* TO 'role_admin';
GRANT PROCESS ON *.* TO 'role_admin';

-- =====================================================
-- PERMISSIONS FOR ACCOUNTING ROLE
-- =====================================================

-- Full access to accounting tables
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.AccountingAccount TO 'role_accounting';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.InvoiceAccountingEntry TO 'role_accounting';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.Retention TO 'role_accounting';

-- Read access to invoices for reports
GRANT SELECT ON ProjectNelsonVivas.SalesInvoice TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.PurchaseInvoice TO 'role_accounting';

-- Access to clients/providers (read and update)
GRANT SELECT, UPDATE ON ProjectNelsonVivas.ClientProvider TO 'role_accounting';

-- Access to banks for reconciliation
GRANT SELECT, UPDATE ON ProjectNelsonVivas.Bank TO 'role_accounting';

-- Access to views
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_accounting';
GRANT SELECT ON ProjectNelsonVivas.Vw_InvoiceJournalEntries TO 'role_accounting';

-- Stored procedures
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateAccountingAccount TO 'role_accounting';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateInvoiceAccountingEntry TO 'role_accounting';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordRetention TO 'role_accounting';

-- =====================================================
-- PERMISSIONS FOR BILLING ROLE
-- =====================================================

-- Full access to invoices
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.SalesInvoice TO 'role_billing';
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.PurchaseInvoice TO 'role_billing';

-- Full access to clients and providers
GRANT SELECT, INSERT, UPDATE, DELETE ON ProjectNelsonVivas.ClientProvider TO 'role_billing';

-- Access to payment methods
GRANT SELECT, INSERT, UPDATE ON ProjectNelsonVivas.PaymentMethod TO 'role_billing';

-- Read access to banks
GRANT SELECT ON ProjectNelsonVivas.Bank TO 'role_billing';

-- Read access to accounting accounts
GRANT SELECT ON ProjectNelsonVivas.AccountingAccount TO 'role_billing';

-- Access to relevant views
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_billing';
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_billing';

-- Billing stored procedures
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreateClientProvider TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordSalesInvoice TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_RecordPurchaseInvoice TO 'role_billing';
GRANT EXECUTE ON PROCEDURE ProjectNelsonVivas.Sp_CreatePaymentMethod TO 'role_billing';

-- =====================================================
-- PERMISSIONS FOR READ-ONLY ROLE
-- =====================================================

-- Only queries in all tables
GRANT SELECT ON ProjectNelsonVivas.* TO 'role_readonly';

-- Access to all views
GRANT SELECT ON ProjectNelsonVivas.Vw_BankBalances TO 'role_readonly';
GRANT SELECT ON ProjectNelsonVivas.Vw_PendingReceivables TO 'role_readonly';
GRANT SELECT ON ProjectNelsonVivas.Vw_InvoiceJournalEntries TO 'role_readonly';

-- =====================================================
-- PERMISSIONS FOR AUDIT ROLE
-- =====================================================

-- Read-only access to all tables
GRANT SELECT ON ProjectNelsonVivas.* TO 'role_audit';

-- Special permissions for audit
GRANT PROCESS ON *.* TO 'role_audit';
GRANT SHOW DATABASES ON *.* TO 'role_audit';

-- Access to system logs (if available)
GRANT SELECT ON mysql.general_log TO 'role_audit';
GRANT SELECT ON mysql.slow_log TO 'role_audit';

-- =====================================================
-- CREATION OF USERS
-- =====================================================

-- Main Admin User
CREATE USER 'admin_nelson'@'localhost' IDENTIFIED BY 'AdminNelson2025!';
GRANT 'role_admin' TO 'admin_nelson'@'localhost';
SET DEFAULT ROLE 'role_admin' TO 'admin_nelson'@'localhost';

-- Accounting User
CREATE USER 'contabilidad'@'localhost' IDENTIFIED BY 'Conta2025#';
GRANT 'role_accounting' TO 'contabilidad'@'localhost';
SET DEFAULT ROLE 'role_accounting' TO 'contabilidad'@'localhost';

-- Billing User
CREATE USER 'facturacion'@'localhost' IDENTIFIED BY 'Factura2025$';
GRANT 'role_billing' TO 'facturacion'@'localhost';
SET DEFAULT ROLE 'role_billing' TO 'facturacion'@'localhost';

-- Queries User
CREATE USER 'consultas'@'localhost' IDENTIFIED BY 'Consulta2025%';
GRANT 'role_readonly' TO 'consultas'@'localhost';
SET DEFAULT ROLE 'role_readonly' TO 'consultas'@'localhost';

-- Audit User
CREATE USER 'auditoria'@'localhost' IDENTIFIED BY 'Audit2025&';
GRANT 'role_audit' TO 'auditoria'@'localhost';
SET DEFAULT ROLE 'role_audit' TO 'auditoria'@'localhost';

-- Backup User
CREATE USER 'backup_user'@'localhost' IDENTIFIED BY 'Backup2025*';
GRANT SELECT, LOCK TABLES, SHOW VIEW, EVENT, TRIGGER ON ProjectNelsonVivas.* TO 'backup_user'@'localhost';
