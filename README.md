# Sistema de Gestión de Competencias de Natación

Base de datos diseñada para gestionar competencias de natación, nadadores, clubes y records.

## Estructura del Proyecto

El proyecto está dividido en 6 archivos principales:

1. `tablas.sql`: Estructura base de la base de datos
2. `data_inicial.sql`: Datos fundamentales del sistema
3. `triggers.sql`: Automatizaciones para categorías y records
4. `procedimientos.sql`: Procedimientos para registro y actualización
5. `funciones.sql`: Funciones para cálculos de puntajes y rankings
6. `vistas.sql`: Vistas para reportes y estadísticas

## Características Principales

### Estilos y Distancias
- **Estilos**: Mariposa, Espalda, Pecho, Libre y Combinado
- **Distancias**: 50m, 100m, 200m, 400m, 800m y 1500m
- **Combinaciones válidas**:
  - 50m, 100m, 200m: Todos los estilos individuales
  - 400m: Libre y Combinado
  - 800m y 1500m: Solo Libre

### Categorías por Edad
- Infantil A (7-8 años)
- Infantil B (9-10 años)
- Juvenil A (11-12 años)
- Juvenil B (13-14 años)
- Junior (15-17 años)
- Senior (18-25 años)
- Master (26+ años)

### Sistema de Puntuación
- 1° lugar: 10 puntos
- 2° lugar: 8 puntos
- 3° lugar: 6 puntos
- 4° lugar: 5 puntos
- 5° lugar: 4 puntos
- 6° lugar: 3 puntos
- 7° lugar: 2 puntos
- 8° lugar: 1 punto

## Tablas Principales

### Entidades Base
- `Club`: Organizaciones deportivas participantes
- `Nadadores`: Información personal y deportiva de cada nadador
- `Entrenadores`: Staff técnico de los clubes
- `EstilosNado`: Tipos de nado permitidos
- `Metrajes`: Distancias oficiales
- `CategoriaEdad`: Rangos de edad para competencia
- `Genero`: Clasificación por género

### Competencias y Series
- `Competencias`: Eventos deportivos organizados
- `Series`: Subdivisiones de competencias
- `RegistroCompetencias`: Inscripciones y resultados
- `EstiloMetraje`: Combinaciones válidas de estilo y distancia

### Resultados y Records
- `Tiempos`: Registro de tiempos por nadador
- `Records`: Mejores marcas históricas
- `historial_cambios`: Registro de modificaciones

## Funcionalidades Automatizadas

### Triggers
- Actualización automática de categorías por edad
- Registro automático de records
- Seguimiento de cambios en tiempos

### Procedimientos Almacenados
- Actualización de categorías (de todos los registros)
- Registro de nadadores en competencias
- Validaciones de inscripción

### Funciones
- Cálculo de puntajes por competencia
- Cálculo de ranking de clubes

## Reportes Disponibles

1. **Vista Nadadores por Club**
   - Total de nadadores por club
   - Lista de nadadores con edades

2. **Vista Estadísticas**
   - Rendimiento por nadador
   - Records conseguidos
   - Estilo más fuerte

## Instalación

1. Crear la base de datos:
```sql
CREATE DATABASE swimmingProject_v1;
```

2. Ejecutar los archivos en orden:
```sql
source tablas.sql
source data_inicial.sql
source triggers.sql
source procedimientos.sql
source funciones.sql
source vistas.sql
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

- Las categorías de edad se actualizan automáticamente
- Los records se registran y validan automáticamente
- Todos los cambios quedan registrados en historial_cambios
- Sistema optimizado con índices para consultas frecuentes

Hecho Por: Julio Cesar Vasquez Garcia

