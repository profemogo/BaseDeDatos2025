/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Tables Definition
 * 
 **/ 

-- User Table

CREATE TABLE User (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    avatar VARCHAR(2048),
    password_hash VARCHAR(255) NOT NULL,
    password_changed_token VARCHAR(255) NULL,
    password_changed_token_expires_at TIMESTAMP NULL,
    password_changed_at TIMESTAMP NULL,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- CategoryGroup Table

CREATE TABLE CategoryGroup (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    icon VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Category Table

CREATE TABLE Category (  
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(255) DEFAULT 'interrogation',
    category_group_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_group_id) REFERENCES CategoryGroup(id),
    UNIQUE (name, category_group_id)
);

-- Currency Table

CREATE TABLE Currency (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) UNIQUE NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP
);

-- Workspace Table

CREATE TABLE Workspace (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NOT NULL,
    image VARCHAR(2048),
    currency_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_user_id INTEGER NOT NULL,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    updated_by_user_id INTEGER,
    FOREIGN KEY (currency_id) REFERENCES Currency(id),
    FOREIGN KEY (created_by_user_id) REFERENCES User(id),
    FOREIGN KEY (updated_by_user_id) REFERENCES User(id)
);

-- WorkspaceInvitation Table

CREATE TABLE WorkspaceInvitation (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    workspace_id INTEGER NOT NULL,
    receiver_email VARCHAR(100) NOT NULL,
    sender_user_id INTEGER NOT NULL,
    status ENUM('Pending', 'Accepted', 'Rejected') DEFAULT 'Pending' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (sender_user_id) REFERENCES User(id)
);

-- WorkspaceUser Table

CREATE TABLE WorkspaceUser (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    workspace_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);

-- Expense Table

CREATE TABLE Expense (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    workspace_id INTEGER NOT NULL,
    category_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date TIMESTAMP NOT NULL,
    type ENUM('Transfer', 'SplitEqual', 'SplitUnequal') NOT NULL,
    paid_by_user_id INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_user_id INTEGER NOT NULL,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    updated_by_user_id INTEGER,
    FOREIGN KEY (workspace_id) REFERENCES Workspace(id),
    FOREIGN KEY (paid_by_user_id) REFERENCES User(id),
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (created_by_user_id) REFERENCES User(id),
    FOREIGN KEY (updated_by_user_id) REFERENCES User(id)
);

-- ExpenseSplit Table

CREATE TABLE ExpenseSplit (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    expense_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_by_user_id INTEGER NOT NULL,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    updated_by_user_id INTEGER,
    FOREIGN KEY (expense_id) REFERENCES Expense(id),
    FOREIGN KEY (user_id) REFERENCES User(id),
    FOREIGN KEY (created_by_user_id) REFERENCES User(id),
    FOREIGN KEY (updated_by_user_id) REFERENCES User(id)
);

-- ExpenseComment Table

CREATE TABLE ExpenseComment (
    id INTEGER PRIMARY KEY AUTO_INCREMENT,
    expense_id INTEGER NOT NULL,
    user_id INTEGER NOT NULL,
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NULL ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (expense_id) REFERENCES Expense(id),
    FOREIGN KEY (user_id) REFERENCES User(id)
);