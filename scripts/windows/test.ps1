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
Write-Host "Testing database"
Write-Host "Testing case 1"
mysql -u $DbUser -p$DbPassword $DbName < .\tests\case1.sql
Write-Host "Testing case 2"
mysql -u $DbUser -p$DbPassword $DbName < .\tests\case2.sql
Write-Host "Tests completed successfully"