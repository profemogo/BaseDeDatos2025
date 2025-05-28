# Base de Datos de Natación

Base de datos diseñada para gestionar competencias de natación, incluyendo nadadores, clubes, competencias y registros de tiempos.

## Estructura del Proyecto

El proyecto está organizado los siguientes archivos SQL principales que deben ejecutarse en orden:

1. `1_tablas.sql`: Estructura base de datos
2. `2_triggers.sql`: Triggers del sistema
3. `3_procedimientos.sql`: Procedimientos almacenados
4. `4_vistas.sql`: Vistas del sistema

## Instrucciones de Instalación

### Requisitos Previos
- MySQL 8.0 o superior
- Cliente MySQL (mysql-client) o MySQL Workbench

### Pasos de Instalación

1. Clonar el repositorio:
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd [NOMBRE_DEL_DIRECTORIO]
   ```

2. Conectarse a MySQL:
   ```bash
   mysql -u tu_usuario -p
   ```

3. Ejecutar los archivos SQL en orden:
   ```sql
   source 1_tablas.sql
   source 2_triggers.sql
   source 3_procedimientos.sql
   source 4_vistas.sql
   ```

   O desde la línea de comandos:
   ```bash
   mysql -u tu_usuario -p swimmingProject_v1 < 1_tablas.sql
   mysql -u tu_usuario -p swimmingProject_v1 < 2_triggers.sql
   mysql -u tu_usuario -p swimmingProject_v1 < 3_procedimientos.sql
   mysql -u tu_usuario -p swimmingProject_v1 < 4_vistas.sql
   ```

## Tablas Principales

- **Nadadores**: Información personal (nombre, apellidos, fecha_nacimiento, género, club, categoría)
- **Club**: Datos de clubes deportivos (nombre, dirección, contacto)
- **Competencias**: Eventos deportivos (nombre, fechas, ubicación, tipo)
- **Series**: Divisiones de competencias (número, estilo, metraje, categoría)
- **RegistroCompetencias**: Inscripciones de nadadores (nadador, competencia, serie, carril, estado)
- **Tiempos**: Registros de tiempos en competencias
- **Records**: Récords establecidos (club, regional, nacional, mundial)
- **CategoriaEdad**: Clasificación por edades
- **EstilosNado**: Tipos de estilos (libre, mariposa, etc.)
- **Metrajes**: Distancias de competencia
- **EstiloMetraje**: Relación entre estilos y distancias
- **historial_cambios**: Registro de modificaciones en la base de datos

## Restricciones Importantes

En RegistroCompetencias:
- Un nadador no puede estar en dos series diferentes al mismo tiempo
- Un carril no puede estar asignado dos veces en la misma serie

## Triggers

1. **after_nadador_update**: 
   - Actualiza automáticamente la categoría de edad de un nadador
   - Se ejecuta después de insertar un nuevo nadador

2. **after_tiempo_changes**:
   - Registra cambios en tiempos y récords
   - Actualiza la tabla de Records si se establece un nuevo récord
   - Mantiene el historial de cambios

## Procedimientos Almacenados

1. **actualizar_categorias_edad**:
   ```sql
   CALL actualizar_categorias_edad();
   ```
   - Actualiza las categorías de edad de todos los nadadores
   - Se recomienda ejecutar periódicamente

2. **registrar_nadador_competencia**:
   ```sql
   CALL registrar_nadador_competencia(
       p_nadador_id,
       p_competencia_id,
       p_serie_id,
       p_carril
   );
   ```
   - Inscribe un nadador en una competencia con validaciones completas

## Vista Principal

**vista_nadadores_por_club**:
```sql
SELECT * FROM vista_nadadores_por_club;
```
- Muestra un resumen de nadadores por club
- Incluye: nombre del club, ciudad, total de nadadores y lista detallada

## Ejemplos de Uso

### 1. Registrar un Nadador en Competencia
```sql
CALL registrar_nadador_competencia(1, 1, 1, 4);
-- Registra al nadador ID 1 en la competencia 1, serie 1, carril 4
```

### 2. Actualizar Categorías de Edad
```sql
CALL actualizar_categorias_edad();
-- Actualiza todas las categorías de edad
```

### 3. Ver Resumen de Clubes
```sql
SELECT * FROM vista_nadadores_por_club;
-- Muestra el resumen de todos los clubes con sus nadadores
```

## Mantenimiento y Respaldo

### Respaldo de la Base de Datos
```bash
mysqldump -u tu_usuario -p swimmingProject_v1 > backup.sql
```

### Restauración
```bash
mysql -u tu_usuario -p swimmingProject_v1 < backup.sql
```

## Notas Importantes

- Las categorías de edad se actualizan automáticamente al insertar nadadores
- Los récords se registran automáticamente al detectar nuevos mejores tiempos
- Todos los cambios en tiempos se registran en historial_cambios



