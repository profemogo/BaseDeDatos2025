DB_USER ?= root
DB_NAME ?= SocialNetworkDB
DB_PASS ?=
DB_HOST ?= localhost

STRUCTURE_DIR := sql/structure
TEST_DATA_DIR := sql/test

STRUCTURE_FILES := \
    $(STRUCTURE_DIR)/social_network_db.sql \
    $(STRUCTURE_DIR)/indexes.sql \
    $(STRUCTURE_DIR)/triggers.sql \
    $(STRUCTURE_DIR)/procedures_and_functions.sql \
    $(STRUCTURE_DIR)/security.sql \
    $(STRUCTURE_DIR)/views.sql \
    $(STRUCTURE_DIR)/default_values.sql

TEST_DATA_FILES := \
    $(TEST_DATA_DIR)/testing_data.sql \
    $(TEST_DATA_DIR)/create_users_test.sql

MYSQL_CONFIG_FILE := mysql_config.cnf
MYSQL_CMD := mysql --defaults-extra-file=$(MYSQL_CONFIG_FILE)
SHELL := /bin/bash

.PHONY: all init_config create_db drop_db clean_db load_test_data help

all: create_db

init_config:
	@if [ ! -f "$(MYSQL_CONFIG_FILE)" ]; then \
		echo -e "\n\033[1;31mMySQL configuration file missing!\033[0m"; \
		read -p "Create default $(MYSQL_CONFIG_FILE) with current settings? [Y/N]: " resp; \
		if [[ "$$resp" =~ ^[Yy] ]]; then \
			{ \
				echo "[client]"; \
				echo "user = $(DB_USER)"; \
				echo "password = $(DB_PASS)"; \
				echo "host = $(DB_HOST)"; \
			} > $(MYSQL_CONFIG_FILE); \
			echo -e "\033[1;32mConfiguration file created successfully!\033[0m"; \
			chmod 600 $(MYSQL_CONFIG_FILE); \
		else \
			echo -e "\033[1;33mOperation cancelled. You must create $(MYSQL_CONFIG_FILE) manually in order to use this Makefile.\033[0m"; \
			exit 1; \
		fi; \
	else \
		echo -e "\033[1;32mUsing existing $(MYSQL_CONFIG_FILE)\033[0m"; \
	fi

create_db: init_config
	@echo -e "\n\033[1;34mCreating database $(DB_NAME) with user $(DB_USER)...\033[0m"
	@$(MYSQL_CMD) -e "SET @db_name = '$(DB_NAME)'; DROP DATABASE IF EXISTS $(DB_NAME); CREATE DATABASE $(DB_NAME);"
	@for sql_file in $(STRUCTURE_FILES); do \
		echo "Processing $$sql_file..."; \
		$(MYSQL_CMD) $(DB_NAME) < $$sql_file || exit 1; \
	done
	@echo -e "\033[1;32mDatabase $(DB_NAME) successfully created with schema!\033[0m"

load_test_data: init_config
	@echo -e "\n\033[1;34mLoading test data into $(DB_NAME)...\033[0m"
	@for sql_file in $(TEST_DATA_FILES); do \
		echo "Processing $$sql_file..."; \
		$(MYSQL_CMD) $(DB_NAME) < $$sql_file || exit 1; \
	done
	@echo -e "\033[1;32mTest data loaded successfully!\033[0m"

drop_db: init_config
	@echo -e "\n\033[1;33mDropping database $(DB_NAME)...\033[0m"
	@$(MYSQL_CMD) -e "DROP DATABASE IF EXISTS $(DB_NAME);"
	@echo -e "\033[1;32mDatabase $(DB_NAME) dropped successfully!\033[0m"

clean_db: drop_db create_db
	@echo -e "\033[1;32mDatabase $(DB_NAME) has been completely reset!\033[0m"

help:
	@echo -e "\n\033[1;36mDatabase Management System\033[0m"
	@echo -e "\033[0;36mAvailable commands:\033[0m"
	@echo "  make all/create_db    - Create database and load structure"
	@echo "  make load_test_data   - Load test data"
	@echo "  make drop_db          - Delete the database"
	@echo "  make clean_db         - Reset database (drop and recreate)"
	@echo "  make help             - Show this help menu"
	@echo -e "\n\033[0;36mCustomizable variables (override with VAR=value):\033[0m"
	@echo "  DB_USER=username     - MySQL username (default: root)"
	@echo "  DB_NAME=dbname       - Database name (default: SocialNetworkDB)"
	@echo "  DB_PASS=password     - MySQL password (not default defined)"
	@echo "  DB_HOST=host         - MySQL host (default: localhost)"
	@echo -e "\n\033[0;36mExamples:\033[0m"
	@echo "  make create_db DB_USER=admin DB_PASS=secure123"
	@echo "  make clean_db DB_NAME=test_db"
	@echo "  make load_test_data DB_HOST=127.0.0.1"