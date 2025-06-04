# 🎉 Event Management Database - Juan Gomez

Este proyecto define la estructura de una base de datos relacional para gestionar eventos y sus sedes (venues). Puede ser utilizada como base para aplicaciones web o móviles relacionadas con la organización de eventos, conciertos, conferencias, talleres, entre otros.

## Estructura del proyecto

- **`event_db.sql`**: Contiene las sentencias SQL para crear las tablas principales del sistema:
  - `Venue`: Información de los lugares donde se realizan eventos.
  - `Event`: Detalles de los eventos asociados a un lugar.

## Tablas principales

### Venue
Almacena información sobre los lugares donde se pueden realizar eventos.

### Event
Contiene la información de los eventos: nombre, descripción, fecha y hora, costo, tipo de evento, si es destacado o recurrente, entre otros.

### User
Contiene la informacion del usuario, su id, su nombre su email y contraseña

### Favorite
Contiene la informacion cuando un evento es marcado como favorito por un usuario

## Propósito de componentes avanzados

### Vistas (Views)
Permiten simplificar consultas complejas reutilizables. 

### Procedimientos Almacenados (Stored Procedures)
Automatizan operaciones repetitivas o complejas. 

### Funciones (Functions)
Devuelven valores útiles derivados de los datos. 

### Triggers
Permiten ejecutar lógica automáticamente al realizar acciones sobre las tablas. 

### Roles y Permisos
Gestionan el acceso a la base de datos según el tipo de usuario (administrador, editor, lector).

### Índices (Indexes)
Mejoran el rendimiento de las consultas sobre columnas clave como `venue_id` o `datetime`.

### Requisitos Previos
- MySQL instalado
- `make` disponible en el sistema (generalmente en sistemas Unix/Linux)

**Instalación de `make`:**
```bash
sudo apt-get install make  # En sistemas Debian/Ubuntu
```

---

### Comandos Principales

| Comando                | Descripción                                           |
|------------------------|-------------------------------------------------------|
| `make create_db`       | Crea la base de datos con la estructura completa      |
| `make all`             | Crea la base de datos y carga datos de prueba         |
| `make load_test_data`  | Carga datos de prueba                                 |
| `make clean_db`        | Borra y reconstruye completamente la base de datos    |
| `make drop_db`         | Elimina la base de datos                              |

---

### Ejecución Manual (sin Makefile)

```bash
mysql -u root -p -e "CREATE DATABASE EventManagementDB;"
mysql -u root -p EventManagementDB < sql/structure/event_db.sql
mysql -u root -p EventManagementDB < sql/structure/indexes.sql
mysql -u root -p EventManagementDB < sql/structure/triggers.sql
mysql -u root -p EventManagementDB < sql/structure/procedures_and_functions.sql
mysql -u root -p EventManagementDB < sql/structure/roles.sql
mysql -u root -p EventManagementDB < sql/structure/views.sql
```
