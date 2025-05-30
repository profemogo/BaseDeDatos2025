# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to seed the database
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

# Seed the currencies
mysql -u $DbUser -p$DbPassword $DbName < .\seeds\currencies.sql