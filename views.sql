use ProjectNelsonVivas;

CREATE VIEW Vw_BankBalances AS
SELECT id, name, current_balance
FROM Bank;

CREATE VIEW Vw_PendingReceivables AS
SELECT si.id AS invoice_id, cp.name AS client_name, si.total_amount, 
       -- Consider adding invoice_date here
       (SELECT cp.tax_retention_percentage FROM ClientProvider WHERE cp.id = si.client_id) as client_retention_perc
FROM SalesInvoice si
JOIN ClientProvider cp ON si.client_id = cp.id
WHERE si.is_account_receivable = TRUE AND si.is_conciliated = FALSE;

CREATE VIEW Vw_InvoiceJournalEntries AS
SELECT
    iae.id AS entry_id,
    COALESCE(si.id, pi.id) AS invoice_reference_id,
    CASE
        WHEN iae.sales_invoice_id IS NOT NULL THEN 'Venta'
        WHEN iae.purchase_invoice_id IS NOT NULL THEN 'Compra'
        ELSE 'Desconocido'
    END AS invoice_type,
    aa.name AS account_name,
    aa.type AS account_type,
    iae.amount
FROM InvoiceAccountingEntry iae
JOIN AccountingAccount aa ON iae.accounting_account_id = aa.id
LEFT JOIN SalesInvoice si ON iae.sales_invoice_id = si.id
LEFT JOIN PurchaseInvoice pi ON iae.purchase_invoice_id = pi.id;