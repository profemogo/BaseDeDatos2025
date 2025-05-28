# Configuración Inicial y Flujo de Trabajo

## Datos Base

### Unidades Predefinidas
El sistema incluye las siguientes unidades de medida estándar:
```sql
INSERT INTO Unit (name) VALUES
('litros'),
('kilómetros'),
('horas'),
('minutos'),
('repeticiones'),
('pasos'),
('calorías'),
('páginas');
```

### Tipos de Frecuencia
Frecuencias disponibles para las reglas de actividad:
```sql
INSERT INTO FrequencyType (name) VALUES
('diaria'),
('semanal'),
('mensual'),
('racha');
```

## Flujo de Trabajo

1. **Registro de usuario**
   - Creación de cuenta
   - Configuración de correo principal

2. **Creación de hábitos**
   - Definición de nombre y descripción
   - Asignación a usuario

3. **Definición de reglas de actividad**
   - Establecimiento de metas
   - Configuración de frecuencias
   - Asignación de unidades de medida

4. **Registro diario de actividades**
   - Ingreso de valores
   - Validación automática

5. **Seguimiento de progreso**
   - Verificación de cumplimiento
   - Cálculo de rachas

6. **Obtención de logros**
   - Evaluación automática
   - Asignación de reconocimientos

7. **Generación de reportes**
   - Resúmenes periódicos
   - Análisis de tendencias

## Ejemplos de Uso

### 1. Crear un nuevo hábito
```sql
-- Insertar nuevo hábito
INSERT INTO Habit (name, user_id) 
VALUES ('Correr diario', 1);
```

### 2. Definir meta diaria
```sql
-- Configurar regla de actividad
INSERT INTO ActivityRule (habit_id, target_value, unit_id, frequency_id)
VALUES (
    (SELECT id FROM Habit WHERE name = 'Correr diario' AND user_id = 1),
    5, 
    (SELECT id FROM Unit WHERE name = 'kilómetros'),
    (SELECT id FROM FrequencyType WHERE name = 'diaria')
);
```

### 3. Registrar actividad diaria
```sql
-- Registrar una actividad
CALL LogActivityTransaction(
    (SELECT id FROM Habit WHERE name = 'Correr diario' AND user_id = 1),
    (SELECT id FROM Unit WHERE name = 'kilómetros'),
    5.2
);
```

### 4. Obtener reporte mensual
```sql
-- Generar reporte de mayo 2025
CALL GenerateMonthlyReport(1, 5, 2025);
```

## Consideraciones de Implementación

### Datos Iniciales
- Las unidades y tipos de frecuencia son datos base que deben insertarse durante la instalación
- Se recomienda no modificar estos valores una vez establecidos
- Se pueden añadir nuevas unidades según necesidades específicas

### Validaciones
- Verificación de existencia de registros antes de inserciones
- Comprobación de coherencia en unidades de medida
- Validación de rangos de valores

### Mantenimiento
- Respaldo regular de datos
- Monitoreo de rendimiento
- Actualización de índices según patrones de uso

## Mejores Prácticas

### Registro de Actividades
- Registrar actividades el mismo día que se realizan
- Utilizar las unidades de medida apropiadas
- Verificar el cumplimiento de metas diariamente

### Configuración de Metas
- Establecer metas realistas y alcanzables
- Definir reglas claras y medibles
- Revisar y ajustar metas periódicamente

### Seguimiento
- Consultar el progreso regularmente
- Utilizar los reportes mensuales para análisis
- Mantener la consistencia en el registro de actividades 