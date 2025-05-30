/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Indexes Definition
 * 
 **/ 

-- User Table Indexes

CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_user_phone ON User(phone);

-- CategoryGroup Table Indexes

CREATE INDEX idx_category_group_name ON CategoryGroup(name);

-- Category Table Indexes

CREATE INDEX idx_category_name ON Category(name);
CREATE INDEX idx_category_category_group_id ON Category(category_group_id);

-- Currency Table Indexes

CREATE INDEX idx_currency_name ON Currency(name);

-- Workspace Table Indexes

CREATE INDEX idx_workspace_name ON Workspace(name);
CREATE INDEX idx_workspace_currency_id ON Workspace(currency_id);

-- WorkspaceInvitation Table Indexes

CREATE INDEX idx_workspace_invitation_workspace_id ON WorkspaceInvitation(workspace_id);
CREATE INDEX idx_workspace_invitation_receiver_email ON WorkspaceInvitation(receiver_email);
CREATE INDEX idx_workspace_invitation_sender_user_id ON WorkspaceInvitation(sender_user_id);

-- WorkspaceUser Table Indexes

CREATE INDEX idx_workspace_user_workspace_id ON WorkspaceUser(workspace_id);
CREATE INDEX idx_workspace_user_user_id ON WorkspaceUser(user_id);

-- Expense Table Indexes

CREATE INDEX idx_expense_workspace_id ON Expense(workspace_id);
CREATE INDEX idx_expense_category_id ON Expense(category_id);

-- ExpenseSplit Table Indexes

CREATE INDEX idx_expense_split_expense_id ON ExpenseSplit(expense_id);
CREATE INDEX idx_expense_split_user_id ON ExpenseSplit(user_id);