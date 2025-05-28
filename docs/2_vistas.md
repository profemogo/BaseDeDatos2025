# Vistas del Sistema

## DailyProgress
Vista que proporciona una visión detallada del progreso diario de los usuarios en sus hábitos.

### Descripción
Muestra el progreso diario por usuario y hábito, permitiendo un seguimiento fácil del cumplimiento de metas.

### Columnas
- `user_id`: Identificador del usuario
- `habit`: Nombre del hábito
- `date`: Fecha del registro
- `total`: Valor total acumulado en el día
- `target_value`: Valor objetivo establecido
- `completed`: Indicador booleano de cumplimiento

### Ejemplo de Uso
```sql
-- Consultar el progreso de hoy para un usuario específico
SELECT * FROM DailyProgress 
WHERE user_id = 1 
AND date = CURRENT_DATE;

-- Verificar hábitos completados en la última semana
SELECT habit, COUNT(*) as dias_completados
FROM DailyProgress
WHERE user_id = 1 
AND date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
AND completed = true
GROUP BY habit;
```

## UserAchievements
Vista que resume los logros obtenidos por cada usuario.

### Descripción
Proporciona un resumen consolidado de los logros alcanzados por usuario, desglosado por hábito y tipo de frecuencia.

### Columnas
- `user_id`: Identificador del usuario
- `habit`: Nombre del hábito
- `frequency_type`: Tipo de frecuencia del logro
- `total_achievements`: Total de logros obtenidos

### Ejemplo de Uso
```sql
-- Consultar todos los logros de un usuario
SELECT * FROM UserAchievements
WHERE user_id = 1;

-- Obtener usuarios con más logros por tipo de frecuencia
SELECT frequency_type, SUM(total_achievements) as total
FROM UserAchievements
GROUP BY frequency_type
ORDER BY total DESC;
```

## Consideraciones de Rendimiento

### Optimización
- Las vistas utilizan índices apropiados para mejorar el rendimiento
- Se han optimizado las joins para minimizar el tiempo de consulta
- Se utilizan columnas calculadas cuando es beneficioso

### Actualización
- Las vistas se actualizan automáticamente con los cambios en las tablas base
- No requieren mantenimiento manual
- Reflejan datos en tiempo real

## Casos de Uso Comunes

### Seguimiento Diario
```sql
-- Verificar progreso actual
SELECT * FROM DailyProgress
WHERE date = CURRENT_DATE
ORDER BY user_id, habit;

-- Resumen de cumplimiento semanal
SELECT 
    habit,
    COUNT(*) as total_dias,
    SUM(CASE WHEN completed THEN 1 ELSE 0 END) as dias_completados
FROM DailyProgress
WHERE date >= DATE_SUB(CURRENT_DATE, INTERVAL 7 DAY)
GROUP BY habit;
```

### Análisis de Logros
```sql
-- Top usuarios por logros
SELECT 
    u.name,
    SUM(ua.total_achievements) as total_logros
FROM UserAchievements ua
JOIN User u ON ua.user_id = u.id
GROUP BY u.id, u.name
ORDER BY total_logros DESC
LIMIT 10;

-- Distribución de logros por tipo de frecuencia
SELECT 
    frequency_type,
    COUNT(DISTINCT user_id) as usuarios,
    SUM(total_achievements) as total_logros
FROM UserAchievements
GROUP BY frequency_type;
```

## Notas de Implementación

- Las vistas se actualizan automáticamente cuando cambian los datos subyacentes
- Se utilizan JOINs optimizados para mejor rendimiento
- Las vistas aprovechan los índices creados en las tablas base 