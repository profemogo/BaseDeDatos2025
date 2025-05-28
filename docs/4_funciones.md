# Funciones del Sistema

## Descripción General

Las funciones son bloques de código reutilizables que retornan un valor o conjunto de valores. En este sistema, se utilizan para operaciones específicas relacionadas con hábitos y seguimiento.

## Funciones Disponibles

### registrar_habito

Registra un nuevo hábito para un usuario.

#### Parámetros

- `p_id_usuario`: ID del usuario
- `p_nombre`: Nombre del hábito
- `p_descripcion`: Descripción del hábito
- `p_frecuencia`: Tipo de frecuencia

#### Retorno

- `INTEGER`: ID del hábito creado

#### Ejemplo de Uso

```sql
SELECT registrar_habito(1, 'Beber agua', 'Beber 2L de agua al día', 'diaria');
```

### actualizar_seguimiento

Actualiza o crea un registro de seguimiento de hábito.

#### Parámetros

- `p_id_habito`: ID del hábito
- `p_fecha`: Fecha del registro
- `p_completado`: Estado de completitud
- `p_notas`: Notas adicionales

#### Ejemplo de Uso

```sql
SELECT actualizar_seguimiento(1, CURRENT_DATE, true, 'Completado exitosamente');
```

### obtener_estadisticas_habito

Calcula estadísticas para un hábito en un período específico.

#### Parámetros

- `p_id_habito`: ID del hábito
- `p_fecha_inicio`: Fecha inicial
- `p_fecha_fin`: Fecha final

#### Retorno (tabla)

- `total_dias`: Número total de días
- `dias_completados`: Días donde se completó el objetivo
- `porcentaje_exito`: Porcentaje de éxito

#### Ejemplo de Uso

```sql
SELECT * FROM obtener_estadisticas_habito(1, '2024-01-01', '2024-12-31');
```

### GetCurrentStreak

Calcula la racha actual de días consecutivos para un usuario.

#### Parámetros

- `user_id`: ID del usuario

#### Retorno

- `INTEGER`: Número de días consecutivos en la racha actual

#### Descripción

Calcula la racha actual de días consecutivos en que el usuario ha cumplido sus metas.

#### Ejemplo de Uso

```sql
SELECT GetCurrentStreak(1);
```

### IsDailyGoalMet

Verifica si un usuario ha cumplido su meta diaria para un hábito específico.

#### Parámetros

- `user_id`: ID del usuario
- `habit_id`: ID del hábito

#### Retorno

- `BOOLEAN`: 1 si se cumplió la meta, 0 si no

#### Descripción

Compara los valores registrados en el día con la meta establecida para el hábito.

#### Ejemplo de Uso

```sql
SELECT IsDailyGoalMet(1, 2);
```

## Notas de Implementación

### Optimización

- Uso eficiente de índices
- Minimización de subconsultas
- Retorno de tipos de datos apropiados

### Manejo de Errores

- Validación de parámetros de entrada
- Manejo de casos nulos
- Retorno de errores descriptivos

### Ejemplos de Uso Común

#### Verificación de Metas y Rachas

```sql
-- Verificar cumplimiento de metas diarias para todos los hábitos de un usuario
SELECT h.name, IsDailyGoalMet(1, h.id) as meta_cumplida
FROM Habit h
WHERE h.user_id = 1;

-- Obtener racha actual y verificar logros
SET @current_streak = GetCurrentStreak(1);
IF @current_streak >= 7 THEN
    -- Lógica para otorgar logro de racha semanal
END IF;
```

#### Registro y Seguimiento

```sql
-- Registrar nuevo hábito y obtener su ID
SET @habit_id = registrar_habito(1, 'Ejercicio', 'Hacer ejercicio diario', 'diaria');

-- Registrar actividad y verificar estadísticas
SELECT actualizar_seguimiento(@habit_id, CURRENT_DATE, true, '30 minutos completados');
SELECT * FROM obtener_estadisticas_habito(@habit_id, CURRENT_DATE, CURRENT_DATE);
```

#### Consulta de Estadísticas Mensuales

```sql
-- Ver progreso del mes actual
SELECT * FROM obtener_estadisticas_habito(
    @habit_id,
    DATE_FORMAT(CURRENT_DATE, '%Y-%m-01'),
    LAST_DAY(CURRENT_DATE)
); 
```

# Procedimientos Almacenados

## LogActivityTransaction

Este procedimiento maneja el registro de actividades de forma transaccional y segura.

### Sintaxis

```sql
CALL LogActivityTransaction(habit_id, unit_id, value);
```

### Parámetros

- `habit_id`: ID del hábito a registrar
- `unit_id`: ID de la unidad de medida
- `value`: Valor de la actividad

### Funcionalidad

- Registra una actividad de forma transaccional
- Maneja errores y garantiza consistencia de datos
- Verifica la existencia del hábito y la unidad
- Mantiene la integridad referencial

### Ejemplo de Uso

```sql
CALL LogActivityTransaction(1, 2, 5.5);
```

## GenerateMonthlyReport

Genera un reporte detallado del progreso mensual de un usuario.

### Sintaxis

```sql
CALL GenerateMonthlyReport(user_id, month, year);
```

### Parámetros

- `user_id`: ID del usuario
- `month`: Mes del reporte (1-12)
- `year`: Año del reporte

### Información Incluida

- Total de actividades realizadas
- Días exitosos (cumplimiento de metas)
- Comparación con metas establecidas
- Estadísticas de progreso

### Ejemplo de Uso

```sql
CALL GenerateMonthlyReport(1, 3, 2024);
```

### Formato del Reporte

El reporte incluye:

1. Resumen general
2. Desglose por hábito
3. Análisis de tendencias
4. Recomendaciones basadas en el progreso

## Consideraciones de Uso

### Transaccionalidad

- Los procedimientos utilizan transacciones para garantizar la integridad
- Se implementa manejo de errores robusto
- Rollback automático en caso de fallos

### Optimización

- Uso de índices para consultas eficientes
- Minimización de bloqueos de tablas
- Procesamiento por lotes cuando es posible

### Seguridad

- Validación de parámetros de entrada
- Verificación de permisos de usuario
- Protección contra inyección SQL
