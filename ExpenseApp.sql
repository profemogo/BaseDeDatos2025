-- Ender Jose Puentes Vargas
-- CI: V-25153102

-- ------------------------------------------------------------
-- User
-- ------------------------------------------------------------

-- Create table
CREATE TABLE User (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    image VARCHAR(2048) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    password_changed_token VARCHAR(255) NULL,
    password_changed_token_expires_at TIMESTAMP NULL,
    password_changed_at TIMESTAMP NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_phone ON User(phone);

-- Create trigger before insert
DELIMITER $$
CREATE TRIGGER trigger_before_insert_user
BEFORE INSERT ON User
FOR EACH ROW
BEGIN
    SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_encryption_key'), 256);
END$$
DELIMITER ;

-- Create trigger before update
DELIMITER $$
CREATE TRIGGER trigger_before_update_user
BEFORE UPDATE ON User
FOR EACH ROW
BEGIN
    IF NEW.password_hash <> OLD.password_hash THEN
        SET NEW.password_hash = SHA2(CONCAT(NEW.password_hash, 'my_secret_key'), 256);
        SET NEW.password_changed_at = CURRENT_TIMESTAMP;
    END IF;
END$$
DELIMITER ;

-- ------------------------------------------------------------
-- CategoryGroup
-- ------------------------------------------------------------

-- Create table
CREATE TABLE CategoryGroup (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    image VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_category_group_name ON CategoryGroup(name);

-- ------------------------------------------------------------
-- Category
-- ------------------------------------------------------------

-- Create table
CREATE TABLE Category (  
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    image VARCHAR(2048) NOT NULL,
    category_group_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_group_id) REFERENCES CategoryGroup(id)
);

-- Create indexes
CREATE INDEX idx_category_name ON Category(name);
CREATE INDEX idx_category_category_group_id ON Category(category_group_id);

-- ------------------------------------------------------------
-- Currency
-- ------------------------------------------------------------

-- Create table
CREATE TABLE Currency (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Create indexes
CREATE INDEX idx_currency_name ON Currency(name);

-- ------------------------------------------------------------
-- Workspace
-- ------------------------------------------------------------

-- Create table
CREATE TABLE Workspace (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    image VARCHAR(2048) NOT NULL,
    currency_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (currency_id) REFERENCES Currency(id)
);

-- Create indexes
CREATE INDEX idx_workspace_name ON Workspace(name);
CREATE INDEX idx_workspace_currency_id ON Workspace(currency_id);

-- ------------------------------------------------------------
-- WorkspaceInvitation
-- ------------------------------------------------------------

-- Create table
CREATE TABLE WorkspaceInvitation (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    workspace_id INTEGER NOT NULL,
    receiver_email VARCHAR(100) NOT NULL,
    sender_user_id INTEGER NOT NULL,
    status VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (sender_user_id) REFERENCES User(id)
);

-- Create indexes
CREATE INDEX idx_workspace_invitation_workspace_id ON WorkspaceInvitation(workspace_id);
CREATE INDEX idx_workspace_invitation_receiver_email ON WorkspaceInvitation(receiver_email);
CREATE INDEX idx_workspace_invitation_sender_user_id ON WorkspaceInvitation(sender_user_id);
-- ------------------------------------------------------------
-- WorkspaceUser
-- ------------------------------------------------------------

-- Create table
CREATE TABLE WorkspaceUser (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    workspace_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Create indexes
CREATE INDEX idx_workspace_user_workspace_id ON WorkspaceUser(workspace_id);
CREATE INDEX idx_workspace_user_user_id ON WorkspaceUser(user_id);

-- ------------------------------------------------------------
-- Expense
-- ------------------------------------------------------------

-- Create table Expense
CREATE TABLE Expense (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    workspace_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date TIMESTAMP NOT NULL,
    type ENUM('Transfer', 'SplitEqual', 'SplitUnequal', 'SinglePayer') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (category_id) REFERENCES Category(id)
);

-- Create indexes
CREATE INDEX idx_expense_workspace_id ON Expense(workspace_id);
CREATE INDEX idx_expense_category_id ON Expense(category_id);

-- ------------------------------------------------------------
-- ExpenseSplit
-- ------------------------------------------------------------

-- Create table
CREATE TABLE ExpenseSplit (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    expense_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (expense_id) REFERENCES Expense(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Create indexes
CREATE INDEX idx_expense_split_expense_id ON ExpenseSplit(expense_id);
CREATE INDEX idx_expense_split_user_id ON ExpenseSplit(user_id);

-- ------------------------------------------------------------
-- Thanks for your time and attention.
-- ------------------------------------------------------------
