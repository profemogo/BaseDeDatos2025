DB_NAME=event_db
DB_USER=root
DB_PASSWORD=password
MYSQL=mysql -u $(DB_USER) -p$(DB_PASSWORD) $(DB_NAME)

.PHONY: init recreate clean

# Crear base de datos y cargar todos los scripts
init:
	@echo "📦 Creando base de datos '$(DB_NAME)'..."
	@mysql -u $(DB_USER) -p$(DB_PASSWORD) -e "DROP DATABASE IF EXISTS $(DB_NAME); CREATE DATABASE $(DB_NAME);"
	@echo "Ejecutando event_db.sql"
	@$(MYSQL) < event_db.sql
	@echo "Ejecutando indexes.sql"
	@$(MYSQL) < indexes.sql
	@echo "Ejecutando procedures_and_functions.sql"
	@$(MYSQL) < procedures_and_functions.sql
	@echo "Ejecutando triggers.sql"
	@$(MYSQL) < triggers.sql
	@echo "Ejecutando views.sql"
	@$(MYSQL) < views.sql
	@echo "Base de datos '$(DB_NAME)' lista."

# Eliminar completamente la base de datos
clean:
	@echo "Borrando base de datos..."
	@mysql -u $(DB_USER) -p$(DB_PASSWORD) -e "DROP DATABASE IF EXISTS $(DB_NAME);"
	@echo "Eliminada."
