USE ProjectNelsonVivas;
DELIMITER //

-- Create Client Provider
DROP PROCEDURE IF EXISTS Sp_CreateClientProvider;
CREATE PROCEDURE Sp_CreateClientProvider(
    IN p_name VARCHAR(50),
    IN p_phone_number VARCHAR(10),
    IN p_email VARCHAR(100),
    IN p_rif VARCHAR(12),
    IN p_tax_retention_percentage INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Name cannot be null or empty';
    END IF;

    IF p_phone_number IS NULL OR NOT p_phone_number REGEXP '^[0-9]{10}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phone number must be exactly 10 digits';
    END IF;

    IF p_email IS NULL OR NOT p_email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid email format';
    END IF;

    IF p_tax_retention_percentage < 0 OR p_tax_retention_percentage > 100 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Tax retention percentage must be between 0 and 100';
    END IF;

    START TRANSACTION;

    INSERT INTO ClientProvider (
        name,
        phone_number,
        email,
        rif,
        tax_retention_percentage
    ) VALUES (
        TRIM(p_name),
        p_phone_number,
        LOWER(p_email),
        UPPER(p_rif),
        p_tax_retention_percentage
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Record Sales Invoice
DROP PROCEDURE IF EXISTS Sp_RecordSalesInvoice;
CREATE PROCEDURE Sp_RecordSalesInvoice(
    IN p_client_id INT,
    IN p_bank_id INT,
    IN p_payment_method_id INT,
    IN p_total_amount DECIMAL(20, 2),
    IN p_is_account_receivable BOOLEAN,
    IN p_is_conciliated BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_total_amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ClientProvider WHERE id = p_client_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Bank WHERE id = p_bank_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bank does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM PaymentMethod WHERE id = p_payment_method_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment method does not exist';
    END IF;

    -- Business logic validation
    IF p_is_conciliated = TRUE AND p_is_account_receivable = TRUE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'A receivable invoice cannot be conciliated';
    END IF;

    START TRANSACTION;

    INSERT INTO SalesInvoice (
        client_id,
        bank_id,
        payment_method_id,
        total_amount,
        is_account_receivable,
        is_conciliated,
        is_invoiced 
    ) VALUES (
        p_client_id,
        p_bank_id,
        p_payment_method_id,
        p_total_amount,
        p_is_account_receivable,
        p_is_conciliated,
        FALSE 
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Record Purchase Invoice
DROP PROCEDURE IF EXISTS Sp_RecordPurchaseInvoice;
CREATE PROCEDURE Sp_RecordPurchaseInvoice(
    IN p_provider_id INT,
    IN p_bank_id INT,
    IN p_payment_method_id INT,
    IN p_total_amount DECIMAL(20, 2),
    IN p_is_account_payable BOOLEAN
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_total_amount < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Total amount cannot be negative';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ClientProvider WHERE id = p_provider_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Provider does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Bank WHERE id = p_bank_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bank does not exist';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM PaymentMethod WHERE id = p_payment_method_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment method does not exist';
    END IF;

    START TRANSACTION;

    INSERT INTO PurchaseInvoice (
        provider_id,
        bank_id,
        payment_method_id,
        total_amount,
        is_account_payable
    ) VALUES (
        p_provider_id,
        p_bank_id,
        p_payment_method_id,
        p_total_amount,
        p_is_account_payable
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Create Invoice Accounting Entry
DROP PROCEDURE IF EXISTS Sp_CreateInvoiceAccountingEntry;
CREATE PROCEDURE Sp_CreateInvoiceAccountingEntry(
    IN p_sales_invoice_id INT,
    IN p_purchase_invoice_id INT,
    IN p_accounting_account_id INT,
    IN p_amount DECIMAL(20, 2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Amount must be positive';
    END IF;

    IF p_sales_invoice_id IS NULL AND p_purchase_invoice_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Either sales or purchase invoice ID must be provided';
    END IF;

    IF p_sales_invoice_id IS NOT NULL AND p_purchase_invoice_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot provide both sales and purchase invoice IDs';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM AccountingAccount WHERE id = p_accounting_account_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Accounting account does not exist';
    END IF;

    IF p_sales_invoice_id IS NOT NULL AND 
       NOT EXISTS (SELECT 1 FROM SalesInvoice WHERE id = p_sales_invoice_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Sales invoice does not exist';
    END IF;

    IF p_purchase_invoice_id IS NOT NULL AND 
       NOT EXISTS (SELECT 1 FROM PurchaseInvoice WHERE id = p_purchase_invoice_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Purchase invoice does not exist';
    END IF;

    START TRANSACTION;

    INSERT INTO InvoiceAccountingEntry (
        sales_invoice_id,
        purchase_invoice_id,
        accounting_account_id,
        amount
    ) VALUES (
        p_sales_invoice_id,
        p_purchase_invoice_id,
        p_accounting_account_id,
        p_amount
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Create Bank
DROP PROCEDURE IF EXISTS Sp_CreateBank;
CREATE PROCEDURE Sp_CreateBank(
    IN p_name VARCHAR(50),
    IN p_encrypted_credentials VARCHAR(128),
    IN p_initial_balance DECIMAL(20,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Bank name cannot be null or empty';
    END IF;

    IF p_initial_balance < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Initial balance cannot be negative';
    END IF;

    START TRANSACTION;

    INSERT INTO Bank (
        name,
        encrypted_credentials,
        current_balance
    ) VALUES (
        TRIM(p_name),
        p_encrypted_credentials,
        p_initial_balance
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Create Payment Method
DROP PROCEDURE IF EXISTS Sp_CreatePaymentMethod;
CREATE PROCEDURE Sp_CreatePaymentMethod(
    IN p_name VARCHAR(50)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Payment method name cannot be null or empty';
    END IF;

    START TRANSACTION;

    INSERT INTO PaymentMethod (
        name
    ) VALUES (
        TRIM(p_name)
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Create Accounting Account
DROP PROCEDURE IF EXISTS Sp_CreateAccountingAccount;
CREATE PROCEDURE Sp_CreateAccountingAccount(
    IN p_name VARCHAR(50),
    IN p_type ENUM('income', 'expense')
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_name IS NULL OR TRIM(p_name) = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account name cannot be null or empty';
    END IF;

    IF p_type NOT IN ('income', 'expense') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Invalid account type';
    END IF;

    START TRANSACTION;

    INSERT INTO AccountingAccount (
        name,
        type
    ) VALUES (
        TRIM(p_name),
        p_type
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

-- Record Retention
DROP PROCEDURE IF EXISTS Sp_RecordRetention;
CREATE PROCEDURE Sp_RecordRetention(
    IN p_client_provider_id INT,
    IN p_sales_invoice_id INT,
    IN p_purchase_invoice_id INT,
    IN p_amount_retained DECIMAL(20,2)
)
BEGIN
    DECLARE v_invoice_total DECIMAL(20, 2);
    DECLARE v_retention_percentage INT;

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Input validation
    IF p_client_provider_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client/Provider ID is required';
    END IF;

    IF p_sales_invoice_id IS NULL AND p_purchase_invoice_id IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Either sales or purchase invoice ID must be provided';
    END IF;

    IF p_sales_invoice_id IS NOT NULL AND p_purchase_invoice_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot provide both sales and purchase invoice IDs';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM ClientProvider WHERE id = p_client_provider_id) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Client/Provider does not exist';
    END IF;

    -- Get retention percentage
    SELECT tax_retention_percentage 
    INTO v_retention_percentage
    FROM ClientProvider 
    WHERE id = p_client_provider_id;

    START TRANSACTION;

    -- Calculate retention amount if not provided
    IF p_amount_retained IS NULL THEN
        IF p_sales_invoice_id IS NOT NULL THEN
            -- Get sales invoice total
            SELECT total_amount 
            INTO v_invoice_total
            FROM SalesInvoice 
            WHERE id = p_sales_invoice_id;

            SET p_amount_retained = (v_invoice_total * v_retention_percentage) / 100;
        ELSE
            -- Get purchase invoice total
            SELECT total_amount 
            INTO v_invoice_total
            FROM PurchaseInvoice 
            WHERE id = p_purchase_invoice_id;

            SET p_amount_retained = (v_invoice_total * v_retention_percentage) / 100;
        END IF;
    END IF;

    -- Validate calculated amount
    IF p_amount_retained < 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Retention amount cannot be negative';
    END IF;

    INSERT INTO Retention (
        client_provider_id,
        sales_invoice_id,
        purchase_invoice_id,
        amount_retained
    ) VALUES (
        p_client_provider_id,
        p_sales_invoice_id,
        p_purchase_invoice_id,
        p_amount_retained
    );

    SELECT LAST_INSERT_ID() AS new_id;

    COMMIT;
END //

DELIMITER ;
