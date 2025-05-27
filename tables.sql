DROP DATABASE IF EXISTS ProjectNelsonVivas;
create database if not exists ProjectNelsonVivas;
use ProjectNelsonVivas;

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

create table if not exists Bank (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    encrypted_credentials varchar(128),
    current_balance DECIMAL(20, 2) NOT NULL DEFAULT 0,
    UNIQUE (name)
);

create table if not exists PaymentMethod (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    UNIQUE (name)
);

create table if not exists AccountingAccount (
    created_at datetime not null default current_timestamp,
    id int not null primary key auto_increment,
    name varchar (50) not null,
    type ENUM('income', 'expense') not null
);

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
