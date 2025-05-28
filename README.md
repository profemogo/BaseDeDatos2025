# Sistema de Gestión de Adopciones (MySQL)
## 📌 Descripción
Este repositorio contiene un script SQL completo para implementar un sistema de gestión de adopciones de mascotas, incluyendo:
- Estructura de base de datos relacional
- Funciones almacenadas
- Procedimientos
- Vistas
- Triggers
- Roles y permisos de usuario
## 📋 Requisitos
- MySQL 5.7 o superior (8.0+ recomendado para funciones completas de roles)
- Privilegios de administrador para ejecutar el script completo
## 🚀 Instalación
1. Clona el repositorio o descarga el archivo SQL
2. Abre una terminal y ejecuta cada uno de los scripts en orden:
```bash
mysql -u root -p < schemas.sql
mysql -u root -p SistemaDeAdopcion < index.sql
mysql -u root -p SistemaDeAdopcion < functionAndProcedures.sql
mysql -u root -p SistemaDeAdopcion < triggers.sql
mysql -u root -p SistemaDeAdopcion < views.sql
mysql -u root -p SistemaDeAdopcion < roles.sql
mysql -u root -p SistemaDeAdopcion < initialData.sql
```
## 🏗️ Estructura de la Base de Datos
__Tablas Principales__
- Genero: Géneros de personas
- Persona: Datos de personas (empleados y adoptantes)
- Mascota: Registro de animales disponibles
- Adopcion: Relación entre mascotas y adoptantes
- Especie: Tipos de animales (perros, gatos, etc.)

__Elementos Avanzados__
- Vistas: Consultas predefinidas para reportes
- Funciones: Cálculo de edad, validación de adopciones
- Procedimientos: Registro de adopciones, consulta de información
- Triggers: Actualización automática de dueños
## 👥 Roles y Usuarios Predefinidos
El sistema incluye 4 roles con distintos niveles de acceso:
- __admin_adopciones:__ Acceso completo
- __empleado_adopciones:__ Gestión diaria (sin eliminaciones)
- __voluntario:__ Solo lectura y funciones básicas
- __adoptante:__ Acceso limitado a información propia

Usuarios de ejemplo:
- `admin@localhost` - Contraseña: 123123
- `empleado@localhost` - Contraseña: 123123
- `voluntario@localhost` - Contraseña: 123123
- `adoptante@localhost` - Contraseña: 123123

⚠️ __Importante:__ Cambiar las contraseñas en entornos de producción.



