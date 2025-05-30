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
mysql -u $DbUser -p$DbPassword -e "DROP DATABASE IF EXISTS $DbName"

# Create the database
mysql -u $DbUser -p$DbPassword -e "CREATE DATABASE $DbName"

# Initialize the tables
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\tables.sql

# Initialize the indexes
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\indexes.sql

# Initialize the triggers
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\triggers.sql

# Initialize the views
mysql -u $DbUser -p$DbPassword $DbName < .\definitions\views.sql