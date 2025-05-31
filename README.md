# Base de Datos Red Social - Juan Gómez

## Descripción

Este proyecto contiene el diseño completo de una base de datos para una red social, incluyendo funcionalidades clave como gestión de usuarios, publicaciones, comentarios, likes, sistema de mensajería y control de acceso mediante roles. El enfoque está orientado a la escalabilidad, la modularidad y la integridad de los datos.

---

## Estructura de la Base de Datos

### Tablas

#### 1. Usuarios y Géneros
- **User**: Almacena la información principal de cada usuario (nombre, apellido, email, username, estado, género, etc.).
- **Gender**: Define los géneros disponibles en la plataforma.

#### 2. Publicaciones y Contenido
- **Post**: Almacena publicaciones de los usuarios.
- **PostType**: Define los tipos de publicaciones posibles (Texto, Imagen, Video, Mixto).
- **ContentType**: Define el tipo de contenido individual dentro de cada publicación.
- **PostContent**: Guarda los datos específicos del contenido (texto, imágenes, videos).
- **PostLike**: Registra los "me gusta" en publicaciones.

#### 3. Comentarios
- **Comment**: Almacena los comentarios realizados en publicaciones.
- **CommentLike**: Guarda los likes asociados a comentarios.

#### 4. Sistema de Mensajería (Chat)
- **Chat**: Define cada conversación (individual o grupal).
- **UserChat**: Relación entre usuarios y chats.
- **MessageType**: Especifica el tipo de mensaje (Texto, Imagen, Video, etc.).
- **Message**: Almacena cada mensaje enviado.
- **MessageReceptor**: Registra el estado de lectura y entrega de los mensajes por usuario.

---

## Vistas (Views)

### 1. ViewPostsDetailed
**Propósito**: Ofrece una vista consolidada con información del autor de la publicación, cantidad de likes, comentarios y detalles del contenido.

**Ejemplo de uso:**
```sql
SELECT * FROM ViewPostsDetailed WHERE user_id = 1;
```

---

## Procedimientos y Funciones

### 1. `DeactivateUser`
**Propósito**: Realiza un borrado lógico del usuario desactivando sus publicaciones y comentarios, y eliminando sus likes.

**Parámetro**:
- `p_user_id`: ID del usuario a desactivar

**Ejemplo de uso:**
```sql
CALL DeactivateUser(5);
```

### 2. `GetUserStats`
**Propósito**: Recupera estadísticas del usuario (publicaciones, comentarios, likes dados/recibidos, mensajes enviados).

**Parámetro**:
- `p_user_id`: ID del usuario

**Ejemplo de uso:**
```sql
CALL GetUserStats(5);
```

### 3. `UnreadMessagesCount`
**Propósito**: Devuelve la cantidad de mensajes no leídos de un chat para un usuario.

**Parámetros**:
- `chat_id`: ID del chat
- `user_id`: ID del usuario

**Ejemplo de uso:**
```sql
SELECT UnreadMessagesCount(3, 1) AS unread_count;
```

---

## Triggers

1. **validate_chat_participant**: Verifica que un usuario pertenezca a un chat antes de registrar la entrega del mensaje.
2. **update_message_status**: Actualiza la fecha de lectura o entrega del mensaje cuando su estado cambia.
3. **soft_delete_user**: Realiza borrado lógico en cascada de contenido del usuario desactivado.

---

## Seguridad y Control de Acceso (Usuarios y Roles)

El sistema implementa control de acceso mediante roles definidos con permisos específicos:

### Roles Definidos

- **super_admin**  
  Acceso completo a todas las tablas y funciones.  
  _Permisos_: `ALL PRIVILEGES` sobre toda la base.

- **content_manager**  
  Maneja publicaciones y comentarios.  
  _Permisos_: `SELECT/INSERT/UPDATE` sobre `Post`, `PostContent`, `Comment`, `PostLike`, `CommentLike`, y ejecutar `DeactivateUser`.

- **user_manager**  
  Administra usuarios y su relación con chats.  
  _Permisos_: `SELECT/INSERT/UPDATE` sobre `User`, `UserChat`, `Gender`, y ejecutar `DeactivateUser`.

- **moderator**  
  Puede desactivar contenido que infrinja normas.  
  _Permisos_: `SELECT` sobre `Post`, `Comment`, `User` y `UPDATE(is_active)` en contenido.

---

## Uso

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

### Parámetros Personalizados

Puedes establecer credenciales manualmente al ejecutar los comandos:

```bash
make create_db DB_USER=usuario DB_NAME=nombre_bd DB_PASS=clave DB_HOST=localhost
```

---

### Ejecución Manual (sin Makefile)

```bash
mysql -u root -p -e "CREATE DATABASE SocialNetworkDB;"
mysql -u root -p SocialNetworkDB < sql/structure/social_network_db.sql
mysql -u root -p SocialNetworkDB < sql/structure/indexes.sql
mysql -u root -p SocialNetworkDB < sql/structure/triggers.sql
mysql -u root -p SocialNetworkDB < sql/structure/procedures_and_functions.sql
mysql -u root -p SocialNetworkDB < sql/structure/security.sql
mysql -u root -p SocialNetworkDB < sql/structure/views.sql
mysql -u root -p SocialNetworkDB < sql/structure/default_values.sql
mysql -u root -p SocialNetworkDB < sql/test/testing_data.sql
mysql -u root -p SocialNetworkDB < sql/test/create_users_test.sql
```

---

## Documento de Planificación

El diseño, planificación y desarrollo del proyecto están documentados en un archivo de planificación disponible en el repositorio:  
📄 [`documentacion/planificacion_base_red_social.pdf`](./documentacion/planificacion_base_red_social.pdf)