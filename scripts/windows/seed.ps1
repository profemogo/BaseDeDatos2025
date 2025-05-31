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

# Initialize seeds
Write-Host "Initializing seeds"

# Seed the currencies
Write-Host "Seeding currencies"
# Seed the currencies
mysql -u $DbUser -p$DbPassword $DbName < .\seeds\currencies.sql

# Seed the category groups
Write-Host "Seeding category groups"
mysql -u $DbUser -p$DbPassword $DbName < .\seeds\categories-group.sql

# Seed the categories
Write-Host "Seeding categories"
mysql -u $DbUser -p$DbPassword $DbName < .\seeds\categories.sql

Write-Host "Seeds initialized successfully"