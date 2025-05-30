
create database if not exists ProjectNelsonVivas;
use ProjectNelsonVivas;

-- 
-- DROP TABLES
-- NOTE: THIS IS FOR TESTING PURPOSES ONLY
-- =====================================================

drop table if exists ClientProvider;
drop table if exists Bank;
drop table if exists PaymentMethod;
drop table if exists AccountingAccount;
drop table if exists SalesInvoice;
drop table if exists PurchaseInvoice;
drop table if exists InvoiceAccountingEntry;

-- =====================================================
-- CREATE TABLES
-- =====================================================

create table if not exists ClientProvider(
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    phone_number varchar(10) check (phone_number REGEXP '^[0-9]+$'),
    email varchar(100) check (email REGEXP '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$'),
    rif varchar(12),
    tax_retention_percentage int check (tax_retention_percentage >= 0 and tax_retention_percentage <= 100) default 0,
    UNIQUE (email),
    UNIQUE (rif)
);
create index idx_client_provider_name on ClientProvider(name);
create index idx_client_provider_rif on ClientProvider(rif);
create index idx_client_provider_email on ClientProvider(email);
create index idx_client_provider_phone_number on ClientProvider(phone_number);


create table if not exists Bank (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    encrypted_credentials varchar(128),
    current_balance DECIMAL(20, 2) NOT NULL DEFAULT 0,
    UNIQUE (name)
);
create index idx_bank_name on Bank(name);

create table if not exists PaymentMethod (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    UNIQUE (name)
);  
create index idx_payment_method_name on PaymentMethod(name);

create table if not exists AccountingAccount (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    type ENUM('income', 'expense') not null
);
create index idx_accounting_account_name on AccountingAccount(name);
create index idx_accounting_account_type on AccountingAccount(type);

create table if not exists SalesInvoice (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    client_id int not null,
    bank_id int not null,
    payment_method_id int not null,
    total_amount    DECIMAL(20, 2), 
    is_account_receivable boolean,
    is_conciliated boolean,
    is_invoiced boolean,

    FOREIGN KEY (client_id) REFERENCES ClientProvider(id),
    FOREIGN KEY (bank_id) REFERENCES Bank(id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(id)

);
create index idx_sales_invoice_client_id on SalesInvoice(client_id);
create index idx_sales_invoice_bank_id on SalesInvoice(bank_id);
create index idx_sales_invoice_payment_method_id on SalesInvoice(payment_method_id);

create table if not exists  PurchaseInvoice (
    created_at datetime not null default current_timestamp,
    id int auto_increment primary key,
    provider_id int,
    bank_id int,
    payment_method_id int,
    total_amount DECIMAL(10, 2), 
    is_account_payable boolean,

    FOREIGN KEY (provider_id) REFERENCES ClientProvider(id),
    FOREIGN KEY (bank_id) REFERENCES Bank(id),
    FOREIGN KEY (payment_method_id) REFERENCES PaymentMethod(id)
);
create index idx_purchase_invoice_provider_id on PurchaseInvoice(provider_id);
create index idx_purchase_invoice_bank_id on PurchaseInvoice(bank_id);
create index idx_purchase_invoice_payment_method_id on PurchaseInvoice(payment_method_id);

create table if not exists  InvoiceAccountingEntry (
    created_at datetime not null default current_timestamp,
    id int auto_increment primary key,
    sales_invoice_id int,
    purchase_invoice_id int,
    accounting_account_id int,
    amount decimal(10, 2),
    foreign key (sales_invoice_id) references SalesInvoice(id),
    foreign key (purchase_invoice_id) references PurchaseInvoice(id),
    foreign key (accounting_account_id) references AccountingAccount(id) 
);
create index idx_invoice_accounting_entry_sales_invoice_id on InvoiceAccountingEntry(sales_invoice_id);
create index idx_invoice_accounting_entry_purchase_invoice_id on InvoiceAccountingEntry(purchase_invoice_id);
create index idx_invoice_accounting_entry_accounting_account_id on InvoiceAccountingEntry(accounting_account_id);

create table if not exists  Retention (
    created_at datetime not null default current_timestamp,
    id int auto_increment primary key,
    client_provider_id int, 
    sales_invoice_id int,
    purchase_invoice_id int,
    amount_retained decimal(10, 2),

    foreign key (client_provider_id) references ClientProvider(id), 
    foreign key (sales_invoice_id) references SalesInvoice(id),
    foreign key (purchase_invoice_id) references PurchaseInvoice(id)
);
create index idx_retention_client_provider_id on Retention(client_provider_id);
create index idx_retention_sales_invoice_id on Retention(sales_invoice_id);
create index idx_retention_purchase_invoice_id on Retention(purchase_invoice_id);
