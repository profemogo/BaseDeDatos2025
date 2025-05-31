# Base de Datos Red Social - Gerardo Rosetti

## Descripción
Este proyecto contiene la estructura de base de datos para una red social completa, incluyendo gestión de usuarios, publicaciones, comentarios, likes y un sistema de mensajería.

## Estructura de la Base de Datos

### Tablas

#### 1. Usuarios y Géneros
- **User**: Almacena información de los usuarios (nombre, username, email, género, estado).
- **Gender**: Define los géneros disponibles (Masculino, Femenino, No binario).

#### 2. Publicaciones y Contenido
- **Post**: Contiene las publicaciones de los usuarios.
- **PostType**: Tipos de publicaciones (Texto, Imagen, Video, Mixto).
- **ContentType**: Tipos de contenido para publicaciones.
- **PostContent**: Almacena el contenido real de las publicaciones (texto, imágenes, videos).
- **PostLike**: Registra los "me gusta" en publicaciones.
- **Comment**: Almacena comentarios en publicaciones.
- **CommentLike**: Registra los "me gusta" en comentarios.

#### 3. Sistema de Mensajería (Chat)
- **Chat**: Define conversaciones entre usuarios (individuales o grupales).
- **UserChat**: Relación muchos-a-muchos entre usuarios y chats.
- **MessageType**: Tipos de mensajes (Texto, Imagen, Video, Audio, Documento).
- **Message**: Almacena los mensajes enviados en los chats.
- **MessageReceptor**: Registra el estado de entrega y lectura de los mensajes.

## Vistas (Views)

### 1. ViewPostsDetailed
**Propósito**: Proporciona una vista detallada de las publicaciones con información de usuario, conteos de interacciones y contenido multimedia.

**Ejemplo de uso**:
```sql
SELECT * FROM ViewPostsDetailed WHERE user_id = 1;
```

## Procedimientos y Funciones

### 1. DeactivateUser
**Propósito**: Realiza el desactivado completo de un usuario (borrado lógico) incluyendo todas sus publicaciones y comentarios.

**Parámetros**:
- `p_user_id`: ID del usuario a desactivar

**Transacción**:
- Maneja una transacción con rollback en caso de error
- Actualiza el estado en User, Post y Comment
- Elimina likes asociados

**Ejemplo de uso**:
```sql
CALL DeactivateUser(5);
```

### 2. GetUserStats
**Propósito**: Obtiene estadísticas completas de un usuario incluyendo el conteo de publicaciones, comentarios, likes dados/recibidos y mensajes.

**Parámetros**:
- `p_user_id`: ID del usuario cuyas estadísticas se quieren obtener

**Ejemplo de uso**:
```sql
CALL GetUserStats(5);
```

### 3. UnreadMessagesCount
**Propósito**: Calcula el número de mensajes no leídos en un chat específico para un usuario.

**Parámetros**:
- `chat_id`: ID del chat
- `user_id`: ID del usuario

**Retorno**:
- Número entero con la cantidad de mensajes no leídos

**Ejemplo de uso**:
```sql
SELECT UnreadMessagesCount(3, 1) AS unread_count;
```

## Índices
Se han creado índices para optimizar consultas frecuentes:
- Índices en campos como `username`, fechas de creación, y relaciones entre tablas.

## Triggers

### 1. validate_chat_participant
**Propósito**: Valida que un usuario sea participante del chat antes de insertar un receptor de mensaje.

### 2. update_message_status
**Propósito**: Actualiza timestamps cuando un mensaje cambia de estado (leído/entregado).

### 3. soft_delete_user
**Propósito**: Realiza borrado lógico en cascada de publicaciones y comentarios cuando un usuario se desactiva.

Aquí tienes la sección de **Security** que puedes agregar al README.md. Recomiendo colocarla después de la sección de **Triggers** y antes de la sección de **Uso**, ya que el control de acceso es parte fundamental de la estructura de la base de datos antes de llegar a los aspectos operativos.

---

## Seguridad y Control de Acceso (Usuarios y Roles)

El sistema implementa un modelo de roles para gestionar permisos de manera granular:

### Roles Definidos

1. **super_admin**
   - Acceso completo a toda la base de datos
   - Privilegios: `ALL PRIVILEGES` en `SocialNetworkDB.*`

2. **content_manager**
   - Gestiona publicaciones y comentarios
   - Privilegios:
     - `SELECT/INSERT/UPDATE` en tablas: `Post`, `PostContent`, `Comment`
     - `SELECT/INSERT` en `PostLike` y `CommentLike`
     - Ejecución del procedimiento `DeactivateUser`

3. **user_manager**
   - Administra usuarios y chats
   - Privilegios:
     - `SELECT/INSERT/UPDATE` en `User` y `UserChat`
     - `SELECT` en `Gender`
     - Ejecución del procedimiento `DeactivateUser`

4. **moderator**
   - Moderación de contenido
   - Privilegios:
     - `SELECT` en `Post`, `PostContent`, `Comment`, `User`
     - `UPDATE(is_active)` en `Post` y `Comment` (para desactivar contenido)
     - Ejecución del procedimiento `DeactivateUser`

## Uso

Se proporciona un Makefile que facilita la gestión de la base de datos con comandos simplificados. A continuación se detallan las funcionalidades disponibles:

### Requisitos previos
- Tener instalado `make` (generalmente incluido en sistemas Unix/Linux)
- Tener acceso a MySQL

#### Instalar make (si no está disponible):
```bash
# Para sistemas basados en Debian/Ubuntu:
sudo apt-get install make
```

### Comandos principales

1. **Crear la base de datos completa** (estructura completa con valores por defecto):
   ```bash
   make create_db
   ```
   **Tambien puedes ejecutar**
   ```bash
   make all
   ```

2. **Cargar datos de prueba** (cargar archivo de prueba, después de crear la Base de Datos):
   ```bash
   make load_test_data
   ```

3. **Reconstruir completamente la base de datos**:
   ```bash
   make clean_db
   ```

4. **Eliminar la base de datos**:
   ```bash
   make drop_db
   ```

5. **Ver Guia**:
   ```bash
   make help
   ```

### Parámetros del Makefile
Puedes especificar parámetros personalizados:
```bash
# Ejemplo con credenciales personalizadas
make create_db DB_USER=mi_usuario DB_NAME=mi_bd DB_PASS=mi_contraseña DB_HOST=mi_servidor
```

### Ejemplo manual (sin make)
Si no puedes usar make, aquí están los comandos equivalentes:

1. Crear la base de datos:
```bash
mysql -u root -p -e "CREATE DATABASE SocialNetworkDB;"
```

2. Cargar la estructura:
```bash
mysql -u root -p SocialNetworkDB < sql/structure/social_network_db.sql
mysql -u root -p SocialNetworkDB < sql/structure/indexes.sql
mysql -u root -p SocialNetworkDB < sql/structure/triggers.sql
mysql -u root -p SocialNetworkDB < sql/structure/procedures_and_functions.sql
mysql -u root -p SocialNetworkDB < sql/structure/security.sql
mysql -u root -p SocialNetworkDB < sql/structure/views.sql
mysql -u root -p SocialNetworkDB < sql/structure/default_values.sql
```

3. Cargar datos de prueba (opcional):
```bash
mysql -u root -p SocialNetworkDB < sql/test/testing_data.sql
mysql -u root -p SocialNetworkDB < sql/test/create_users_test.sql
```

## Documento de planificación
Documento donde se realizó la planificación inicial del proyecto: [Documento](https://docs.google.com/document/d/12EnZHJbFXb7tiG3wbWhpl3oQzaNYEItyetY1QQ54LxY/edit?usp=sharing)

---