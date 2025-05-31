#!/bin/bash

# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to test the database
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

# Test the database
echo "Testing database"
echo "Testing case 1"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./tests/case1.sql
echo "Testing case 2"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./tests/case2.sql
echo "Tests completed successfully"