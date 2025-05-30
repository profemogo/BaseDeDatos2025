# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to test the database
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

# Test the database
mysql -u $DbUser -p$DbPassword $DbName < .\tests\init.sql