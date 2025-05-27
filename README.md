# Base de Datos de Natación

Base de datos diseñada para gestionar competencias de natación, incluyendo nadadores, clubes, competencias y registros de tiempos.

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
- Un nadador no puede estar en dos series diferentes al mismo tiempo (`unique_nadador_serie`)
- Un carril no puede estar asignado dos veces en la misma serie (`unique_carril_serie_estilo`)

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
   - Actualiza las categorías de edad de todos los nadadores
   - Uso: `CALL actualizar_categorias_edad();`
   - Se recomienda ejecutar periódicamente para mantener categorías actualizadas

2. **inscribir_nadador_competencia**:
   - Procedimiento con control de transacciones para inscribir nadadores
   - Validaciones:
     * Verifica que el nadador exista
     * Verifica que la competencia esté vigente
     * Verifica categoría de edad y género
     * Controla disponibilidad de carriles
   - Uso: 
   ```sql
   CALL inscribir_nadador_competencia(
       p_nadador_id,
       p_competencia_id,
       p_serie_id,
       @mensaje
   );
   SELECT @mensaje;
   ```

## Vistas

1. **vista_nadadores_por_club**:
   - Muestra nadadores agrupados por club
   - Incluye: nombre del club, ciudad, total de nadadores, lista de nadadores con edades
   - Uso: `SELECT * FROM vista_nadadores_por_club;`

## Uso Básico

### Inscribir Nadador en Competencia
```sql
CALL inscribir_nadador_competencia(
    p_nadador_id,
    p_competencia_id,
    p_serie_id,
    @mensaje
);
SELECT @mensaje;
```

### Actualizar Categorías de Edad
```sql
CALL actualizar_categorias_edad();
```

### Consultar Nadadores por Club
```sql
SELECT * FROM vista_nadadores_por_club;
```

## Mantenimiento

- Los triggers mantienen automáticamente:
  - Categorías de edad actualizadas
  - Historial de cambios
  - Registro de récords

- Procedimientos de mantenimiento:
  - Ejecutar `actualizar_categorias_edad()` periódicamente
  - Usar `inscribir_nadador_competencia()` para inscripciones

- La vista facilita la consulta de nadadores por club

## Notas Importantes

- Las categorías de edad se actualizan automáticamente
- Los récords se registran automáticamente cuando se detecta un nuevo mejor tiempo
- Todos los cambios relacionados a tiempos quedan registrados en la tabla historial_cambios


