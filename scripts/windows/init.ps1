# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to initialize the database
#

# Check if required parameters are provided
param(
    [Parameter(Mandatory=$true)]
    [string]$DbName,
    
    [Parameter(Mandatory=$true)] 
    [string]$DbUser,
    
    [Parameter(Mandatory=$true)]
    [string]$DbPassword
)

# Remove the database if it exists
Write-Host "Removing database $DbName"
mysql -u $DbUser -p$DbPassword -e "DROP DATABASE IF EXISTS $DbName"

# Create the database
Write-Host "Creating database $DbName"
mysql -u $DbUser -p$DbPassword -e "CREATE DATABASE $DbName"

# Initialize the tables
Write-Host "Initializing tables"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\tables.sql

# Initialize the indexes
Write-Host "Initializing indexes"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\indexes.sql

# Initialize the triggers
Write-Host "Initializing triggers"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\triggers.sql

# Initialize the views
Write-Host "Initializing views"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\views.sql

# Initialize the procedures
Write-Host "Initializing procedures"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\procedures.sql

# Initialize the functions
Write-Host "Initializing functions"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\functions.sql

# Initialize the security
Write-Host "Initializing security"
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\security.sql

Write-Host "Database initialized successfully"