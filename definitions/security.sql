    /**
    * Expenses App
    *
    * Author: Ender Jose Puentes Vargas
    * CI: V-25153102
    *
    * Security Definition
    * 
    **/ 

    -- ================================
    -- ================================
    -- Roles
    -- ================================
    -- ================================

    DROP ROLE IF EXISTS 'administrator', 'api', 'developer';
    CREATE ROLE 'administrator', 'api', 'developer';

    -- ================================
    -- Privileges for administrator role
    -- ================================
    
    GRANT ALL PRIVILEGES ON ExpenseApp.* TO 'administrator';

    -- ================================
    -- Privileges for rest api role
    -- ================================

    -- Tables
    GRANT SELECT ON ExpenseApp.Currency TO 'api';
    GRANT SELECT ON ExpenseApp.CategoryGroup TO 'api';
    GRANT SELECT ON ExpenseApp.Category TO 'api';
    GRANT SELECT, INSERT, UPDATE ON ExpenseApp.User TO 'api';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ExpenseApp.Workspace TO 'api';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ExpenseApp.WorkspaceInvitation TO 'api';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ExpenseApp.WorkspaceUser TO 'api';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ExpenseApp.Expense TO 'api';
    GRANT SELECT, INSERT, UPDATE, DELETE ON ExpenseApp.ExpenseSplit TO 'api';
    GRANT SELECT, INSERT ON ExpenseApp.ExpenseComment TO 'api';

    -- Procedures
    GRANT EXECUTE ON PROCEDURE ExpenseApp.CreateExpenseWithSplits TO 'api';
    GRANT EXECUTE ON PROCEDURE ExpenseApp.UpdateExpenseWithSplits TO 'api';

    -- Functions
    GRANT EXECUTE ON FUNCTION ExpenseApp.GetUserWorkspaceBalance TO 'api';

    -- Views
    GRANT SELECT ON ExpenseApp.ExpenseCommentView TO 'api';

    -- ================================
    -- Privileges for developer role
    -- ================================

    -- Inherits privileges from api role
    GRANT 'api' TO 'developer';

    -- Tables
    GRANT INSERT, UPDATE, DELETE ON ExpenseApp.Currency TO 'developer';
    GRANT INSERT, UPDATE, DELETE ON ExpenseApp.CategoryGroup TO 'developer';
    GRANT INSERT, UPDATE, DELETE ON ExpenseApp.Category TO 'developer';

    -- ================================
    -- ================================
    -- Users
    -- ================================
    -- ================================

    -- ================================
    -- User Jose Mogollón (Administrator)
    -- ================================

    -- Drop Jose Mogollón (Administrator) user if they exist
    DROP USER IF EXISTS 'josemogo'@'localhost';
    DROP USER IF EXISTS 'josemogo'@'127.0.0.1';
    DROP USER IF EXISTS 'josemogo'@'192.168.0.%';
    
    -- Create Jose Mogollón (Administrator) user
    CREATE USER 'josemogo'@'localhost' IDENTIFIED BY 'mypassword.josemogo';
    CREATE USER 'josemogo'@'127.0.0.1' IDENTIFIED BY 'mypassword.josemogo';
    CREATE USER 'josemogo'@'192.168.0.%' IDENTIFIED BY 'mypassword.josemogo';

    -- Grant roles to Jose Mogollón (Administrator) user
    GRANT 'administrator' TO 'josemogo'@'localhost';
    GRANT 'administrator' TO 'josemogo'@'127.0.0.1';
    GRANT 'administrator' TO 'josemogo'@'192.168.0.%';

    -- Set administrator role as default for Jose Mogollón
    SET DEFAULT ROLE 'administrator' TO 'josemogo'@'localhost';
    SET DEFAULT ROLE 'administrator' TO 'josemogo'@'127.0.0.1';
    SET DEFAULT ROLE 'administrator' TO 'josemogo'@'192.168.0.%';

    -- ================================
    -- User APIService (API)
    -- ================================

    -- Drop APIService (API) user if they exist
    DROP USER IF EXISTS 'apiservice'@'api.expenseapp.com';
    DROP USER IF EXISTS 'apiservice'@'10.32.45.1'; -- (IP address of the API service)

    -- Create APIService (API) user 
    CREATE USER 'apiservice'@'api.expenseapp.com' IDENTIFIED BY 'mypassword.apiservice';
    CREATE USER 'apiservice'@'10.32.45.1' IDENTIFIED BY 'mypassword.apiservice';

    -- Grant roles to APIService (API) user
    GRANT 'api' TO 'apiservice'@'api.expenseapp.com';
    GRANT 'api' TO 'apiservice'@'10.32.45.1';

    -- Set api role as default for APIService
    SET DEFAULT ROLE 'api' TO 'apiservice'@'api.expenseapp.com';
    SET DEFAULT ROLE 'api' TO 'apiservice'@'10.32.45.1';

    -- ================================
    -- User Ender Puentes (Developer)
    -- ================================

    -- Drop Developer user if they exist
    DROP USER IF EXISTS 'ender_dev'@'192.168.0.1'; -- (IP address of Network Local, Only via VPN)

    -- Create Developer user
    CREATE USER 'ender_dev'@'192.168.0.1' IDENTIFIED BY 'mypassword.developer.ender_dev';

    -- Grant developer role to Developer user
    GRANT 'developer' TO 'ender_dev'@'192.168.0.1';

    -- Set developer role as default for Developer
    SET DEFAULT ROLE 'developer' TO 'ender_dev'@'192.168.0.1';

    -- ================================
    -- User Pedro Perez (Developer)
    -- ================================

    -- Drop Developer user if they exist
    DROP USER IF EXISTS 'pedro_dev'@'192.168.0.2'; -- (IP address of Network Local, Only via VPN)
    -- Create Developer user
    CREATE USER 'pedro_dev'@'192.168.0.2' IDENTIFIED BY 'mypassword.developer.pedro_dev';

    -- Grant developer role to Developer user
    GRANT 'developer' TO 'pedro_dev'@'192.168.0.2';

    -- Set developer role as default for Developer
    SET DEFAULT ROLE 'developer' TO 'pedro_dev'@'192.168.0.2';