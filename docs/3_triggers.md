# Triggers

## trg_create_dailylog_before_activity
Este trigger se encarga de crear automáticamente un registro diario si no existe al registrar una actividad.
- **Propósito**: Garantiza la integridad de los datos
- **Momento de ejecución**: BEFORE INSERT en ActivityLog
- **Funcionalidad**: Verifica y crea el DailyLog necesario para mantener la consistencia de datos

### Activación
- **Momento**: BEFORE INSERT
- **Tabla**: ActivityLog
- **Por**: Cada fila

### Funcionalidad
1. Verifica si existe un DailyLog para el usuario y fecha actual
2. Si no existe, crea uno nuevo
3. Asigna el ID del DailyLog al nuevo registro de actividad

### Ejemplo de Uso
```sql
INSERT INTO ActivityLog (habit_id, unit_id, value)
VALUES (1, 1, 2.5);
-- El trigger creará automáticamente el DailyLog si no existe
```

## trg_update_last_activity
Actualiza la última fecha de actividad del usuario cuando se registra una nueva actividad.
- **Propósito**: Mantiene actualizado el perfil del usuario
- **Momento de ejecución**: AFTER INSERT en ActivityLog
- **Funcionalidad**: Actualiza el campo last_activity_date en la tabla User

### Activación
- **Momento**: AFTER INSERT
- **Tabla**: ActivityLog
- **Por**: Cada fila

### Funcionalidad
Actualiza el campo `last_activity_date` en la tabla User con la fecha actual.

## trg_grant_daily_achievement
Se encarga de otorgar logros cuando los usuarios alcanzan sus metas diarias.
- **Propósito**: Ejecuta verificación en tiempo real de logros
- **Momento de ejecución**: AFTER INSERT en ActivityLog
- **Funcionalidad**: Compara los valores registrados con las metas establecidas y otorga logros correspondientes

### Activación
- **Momento**: AFTER INSERT
- **Tabla**: ActivityLog
- **Por**: Cada fila

### Funcionalidad
1. Calcula el total acumulado para el hábito en el día
2. Compara con el objetivo diario
3. Si se alcanza el objetivo, crea un nuevo logro

### Variables Utilizadas
- `v_total`: Total acumulado
- `v_target`: Valor objetivo
- `v_rule_id`: ID de la regla cumplida

## trg_grant_streak_achievement
Gestiona el cálculo y otorgamiento de logros basados en rachas consecutivas.
- **Propósito**: Reconoce el cumplimiento consistente de metas
- **Momento de ejecución**: AFTER INSERT en ActivityLog
- **Funcionalidad**: Utiliza cálculos de secuencias de días para determinar rachas y otorgar logros correspondientes

### Activación
- **Momento**: AFTER INSERT
- **Tabla**: DailyLog
- **Por**: Cada fila

### Funcionalidad
1. Calcula la racha actual del usuario
2. Verifica si cumple alguna regla de racha
3. Otorga el logro correspondiente

### Cálculo de Rachas
Utiliza una CTE (Common Table Expression) para:
1. Ordenar los registros por fecha
2. Identificar días consecutivos
3. Contar la longitud de la racha actual

## Consideraciones de Rendimiento

- Los triggers utilizan índices existentes para optimizar las consultas
- Se minimiza el número de operaciones por trigger
- Se utilizan INSERT IGNORE para evitar duplicados en logros
- Las subconsultas están optimizadas para rendimiento

## Manejo de Errores

Los triggers incluyen manejo implícito de errores:
- Verificación de existencia de registros
- Validación de datos antes de inserciones
- Uso de transacciones implícitas 