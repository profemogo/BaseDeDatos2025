/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Views Definition
 * 
 **/ 

-- Expense Comment View

CREATE VIEW ExpenseCommentView AS
SELECT 
    ec.id,
    ec.expense_id,
    CONCAT(u.name, ' modificó esta transacción: ', ec.comment) AS comment,
    ec.created_at
FROM ExpenseComment ec
JOIN User u 
ON ec.user_id = u.id
ORDER BY ec.updated_at DESC;