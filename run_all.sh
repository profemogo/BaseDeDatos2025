#!/bin/bash


echo "Por favor, ingresa la contraseña de MySQL cuando se solicite:"
read -s MYSQL_PASSWORD


run_sql() {
    echo "Ejecutando $1..."
    mysql -u root -p"$MYSQL_PASSWORD" < "$1"
    if [ $? -eq 0 ]; then
        echo "✓ $1 ejecutado exitosamente"
    else
        echo "✗ Error al ejecutar $1"
        exit 1
    fi
}


echo "Iniciando la implementación de la base de datos..."

# 1. Crear la base de datos y tablas
run_sql schema.sql

# 2. Crear roles y usuarios
run_sql roles_users.sql

# 3. Insertar datos iniciales
run_sql data.sql

# 4. Crear vistas
run_sql views.sql

# 5. Crear funciones
run_sql functions.sql

# 6. Crear procedimientos
run_sql procedures.sql

# 7. Crear triggers
run_sql triggers.sql

echo "¡Base de datos implementada completamente!"