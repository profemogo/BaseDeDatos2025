#!/bin/bash

# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to seed the database
#

# Check if required parameters are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 <database_name> <db_user> <db_password>"
    exit 1
fi

# Database credentials from parameters
DB_NAME=$1
DB_USER=$2 
DB_PASSWORD=$3

# Initialize seeds
echo "Initializing seeds"

# Seed the currencies
echo "Seeding currencies"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./seeds/currencies.sql

# Seed the category groups
echo "Seeding category groups"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./seeds/categories-group.sql

# Seed the categories   
echo "Seeding categories"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./seeds/categories.sql

echo "Seeds initialized successfully"