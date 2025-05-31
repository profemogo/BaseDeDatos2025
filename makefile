# Parámetros por defecto
DB_USER ?= root
DB_PASS ?= root
DB_NAME ?= EventDB
DB_HOST ?= localhost

# Crear toda la base de datos desde cero
create_db:
	@echo "Creando base de datos..."
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) -e "DROP DATABASE IF EXISTS $(DB_NAME); CREATE DATABASE $(DB_NAME);"
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/event_db.sql
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/indexes.sql
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/triggers.sql
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/procedures_and_functions.sql
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/views.sql
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/structure/roles.sql

# Cargar datos de prueba
load_test_data:
	@echo "Cargando datos de prueba..."
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) $(DB_NAME) < sql/test/testing_data.sql

# Eliminar la base de datos
drop_db:
	@echo "Eliminando base de datos..."
	mysql -u $(DB_USER) -p$(DB_PASS) -h $(DB_HOST) -e "DROP DATABASE IF EXISTS $(DB_NAME);"

# Limpiar base de datos (eliminar y crear de nuevo)
clean_db: drop_db create_db

# Crear y cargar datos
all: create_db load_test_data
