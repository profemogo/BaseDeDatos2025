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

## Descripción General
Los procedimientos almacenados son rutinas que encapsulan lógica de negocio compleja y pueden realizar múltiples operaciones en una sola llamada. Se utilizan para operaciones que modifican datos o requieren múltiples pasos.

## Procedimientos Disponibles

### sp_crear_usuario
Crea un nuevo usuario con su correo principal.

#### Parámetros
- `p_nombre`: Nombre del usuario
- `p_email`: Correo electrónico
- `p_password`: Contraseña (será hasheada)

#### Funcionalidad
1. Valida los datos de entrada
2. Hashea la contraseña
3. Crea el usuario
4. Crea el correo principal

#### Ejemplo de Uso
```sql
CALL sp_crear_usuario('Juan Pérez', 'juan@ejemplo.com', 'contraseña123');
```

### sp_agregar_regla_habito
Agrega una nueva regla a un hábito existente.

#### Parámetros
- `p_habit_id`: ID del hábito
- `p_target_value`: Valor objetivo
- `p_unit_id`: ID de la unidad
- `p_frequency_id`: ID del tipo de frecuencia
- `p_target_days`: Días objetivo (opcional)

#### Funcionalidad
1. Verifica la existencia del hábito
2. Valida la unidad y frecuencia
3. Crea la regla de actividad

#### Ejemplo de Uso
```sql
CALL sp_agregar_regla_habito(1, 2.0, 1, 1, NULL);
```

## Notas de Implementación

### Seguridad
- Validación exhaustiva de parámetros
- Manejo de errores con SIGNAL
- Control de acceso a datos

### Transacciones
- Uso de transacciones para operaciones múltiples
- Puntos de guardado cuando es necesario
- Rollback automático en caso de error

### Mantenibilidad
- Nombres descriptivos de variables
- Comentarios explicativos
- Estructura consistente

## Ejemplos de Uso Común

### Configuración Inicial de Usuario
```sql
-- Crear usuario y configurar primer hábito
CALL sp_crear_usuario('Nuevo Usuario', 'email@ejemplo.com', 'contraseña123');
SET @user_id = LAST_INSERT_ID();

-- Configurar hábito con regla
SET @habit_id = registrar_habito(@user_id, 'Ejercicio', 'Rutina diaria', 'diaria');
CALL sp_agregar_regla_habito(@habit_id, 30, 4, 1, NULL);
```

### Gestión de Reglas
```sql
-- Agregar múltiples reglas a un hábito
CALL sp_agregar_regla_habito(@habit_id, 30, 4, 1, NULL);  -- Regla diaria
CALL sp_agregar_regla_habito(@habit_id, 150, 4, 2, NULL); -- Regla semanal
CALL sp_agregar_regla_habito(@habit_id, 7, NULL, 4, 7);   -- Regla de racha
```

## Consideraciones de Rendimiento

### Optimización
- Uso eficiente de índices
- Minimización de operaciones en bucle
- Gestión eficiente de memoria

### Monitoreo
- Registro de errores
- Tiempo de ejecución
- Uso de recursos 