DB_USER ?= root
DB_NAME ?= SocialNetworkDB
DB_PASS ?=
DB_HOST ?= localhost

STRUCTURE_FILES := social_network_db.sql indexes.sql triggers.sql procedures_and_functions.sql views.sql default_values.sql
TEST_DATA_FILE := testing_data.sql

.PHONY: all create_db drop_db clean_db load_test_data help

all: create_db

create_db:
	@echo "Creating database $(DB_NAME) with user $(DB_USER)..."
	@mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) -e "DROP DATABASE IF EXISTS $(DB_NAME); CREATE DATABASE $(DB_NAME);"
	@for sql_file in $(STRUCTURE_FILES); do \
		echo "Processing $$sql_file..."; \
		mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < $$sql_file || exit 1; \
	done
	@echo "Database $(DB_NAME) created and structure loaded successfully."

load_test_data:
	@echo "Loading test data into $(DB_NAME)..."
	@mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < $(TEST_DATA_FILE)
	@echo "Test data loaded successfully."

drop_db:
	@echo "Dropping database $(DB_NAME)..."
	@mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) -e "DROP DATABASE IF EXISTS $(DB_NAME);"
	@echo "Database $(DB_NAME) dropped."

clean_db:
	@echo "Cleaning database $(DB_NAME)..."
	@mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) -e "DROP DATABASE IF EXISTS $(DB_NAME); CREATE DATABASE $(DB_NAME);"
	@for sql_file in $(STRUCTURE_FILES); do \
		echo "Processing $$sql_file..."; \
		mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < $$sql_file || exit 1; \
	done
	@echo "Database $(DB_NAME) cleaned and recreated successfully."

help:
	@echo "Available options:"
	@echo "  make all/create_db    - Create database and load structure"
	@echo "  make load_test_data   - Load test data (just for testing and requires existing database)"
	@echo "  make drop_db          - Completely drop the database"
	@echo "  make clean_db         - Clean database (recreate structure)"
	@echo "  make help             - Show this help"
	@echo ""
	@echo "Customizable parameters:"
	@echo "  DB_USER=username     - Specify MySQL user (default: root)"
	@echo "  DB_NAME=dbname       - Specify database name (default: SocialNetworkDB)"
	@echo "  DB_PASS=password     - Specify password (default: empty)"
	@echo "  DB_HOST=host         - Specify host (default: localhost)"
	@echo ""
	@echo "Usage examples:"
	@echo "  make create_db DB_USER=admin DB_NAME=social_prod"
	@echo "  make load_test_data DB_NAME=test_db"
	@echo "  make clean_db DB_NAME=staging_db DB_HOST=127.0.0.1"