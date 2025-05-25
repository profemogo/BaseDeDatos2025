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

## Índices
Se han creado índices para optimizar consultas frecuentes:
- Índices en campos como `username`, fechas de creación, y relaciones entre tablas.

## Triggers
- **validate_chat_participant**: Valida que un usuario sea participante del chat antes de insertar un mensaje.
- **update_message_status**: Actualiza timestamps cuando un mensaje es leído o entregado.
- **soft_delete_user**: Realiza borrado lógico en cascada de publicaciones y comentarios cuando un usuario se desactiva.

## Instalación
Ejecutar el script SQL proporcionado (`social_network_db.sql`) en tu servidor MySQL para crear la base de datos completa con todas las tablas, relaciones, índices y triggers.

---