#!/bin/bash

# Expenses App
#
# Author: Ender Jose Puentes Vargas
# CI: V-25153102
#
# Script to initialize the database
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

# Remove the database if it exists
echo "Removing database $DB_NAME"
mysql -u $DB_USER -p$DB_PASSWORD -e "DROP DATABASE IF EXISTS $DB_NAME"

# Create the database
echo "Creating database $DB_NAME"
mysql -u $DB_USER -p$DB_PASSWORD -e "CREATE DATABASE $DB_NAME"

# Initialize the tables
echo "Initializing tables"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/tables.sql

# Initialize the indexes
echo "Initializing indexes"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/indexes.sql

# Initialize the triggers
echo "Initializing triggers"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/triggers.sql

# Initialize the views
echo "Initializing views"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/views.sql

# Initialize the procedures
echo "Initializing procedures"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/procedures.sql

# Initialize the functions
echo "Initializing functions"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/functions.sql

# Initialize the security
echo "Initializing security"
mysql -u $DB_USER -p$DB_PASSWORD $DB_NAME < ./definitions/security.sql

echo "Database $DB_NAME initialized successfully"