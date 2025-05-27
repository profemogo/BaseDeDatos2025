-- Bank balance update trigger
use ProjectNelsonVivas;
DELIMITER //

DROP TRIGGER IF EXISTS tr_bank_balance_update;
CREATE TRIGGER tr_bank_balance_update
AFTER INSERT ON SalesInvoice
FOR EACH ROW
BEGIN
    IF NEW.is_conciliated = TRUE THEN 
        UPDATE Bank
        SET current_balance = current_balance + NEW.total_amount
        WHERE id = NEW.bank_id;
    END IF;
END //

DELIMITER ;

-- Calculate retained amount

DELIMITER //

DROP TRIGGER IF EXISTS tr_calculate_retained_amount;
CREATE TRIGGER tr_calculate_retained_amount
BEFORE INSERT ON Retention
FOR EACH ROW
BEGIN
    DECLARE invoice_total DECIMAL(20, 2);
    DECLARE client_retention_percentage DECIMAL(5, 2);

    IF NEW.amount_retained IS NULL THEN
        IF NEW.sales_invoice_id IS NOT NULL AND NEW.client_provider_id IS NOT NULL THEN
            SELECT si.total_amount, cp.tax_retention_percentage
            INTO invoice_total, client_retention_percentage
            FROM SalesInvoice si
            JOIN ClientProvider cp ON si.client_id = cp.id
            WHERE si.id = NEW.sales_invoice_id AND cp.id = NEW.client_provider_id;

            IF invoice_total IS NOT NULL AND client_retention_percentage IS NOT NULL THEN
                SET NEW.amount_retained = (invoice_total * client_retention_percentage) / 100.0;
            END IF;

        ELSEIF NEW.purchase_invoice_id IS NOT NULL AND NEW.client_provider_id IS NOT NULL THEN
            SELECT pi.total_amount, cp.tax_retention_percentage
            INTO invoice_total, client_retention_percentage
            FROM PurchaseInvoice pi
            JOIN ClientProvider cp ON pi.provider_id = cp.id
            WHERE pi.id = NEW.purchase_invoice_id AND cp.id = NEW.client_provider_id;

            IF invoice_total IS NOT NULL AND client_retention_percentage IS NOT NULL THEN
                SET NEW.amount_retained = (invoice_total * client_retention_percentage) / 100.0;
            END IF;
        END IF;
    END IF;
END //

DELIMITER ;

-- Keep states consistent
DELIMITER //
DROP TRIGGER IF EXISTS trg_after_sales_accounting_entry;
CREATE TRIGGER trg_after_sales_accounting_entry
AFTER INSERT ON InvoiceAccountingEntry
FOR EACH ROW
BEGIN
    IF NEW.sales_invoice_id IS NOT NULL THEN
        UPDATE SalesInvoice SET is_invoiced = TRUE WHERE id = NEW.sales_invoice_id;
    END IF;
END //

DELIMITER ;


