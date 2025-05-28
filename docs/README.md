# Documentación del Sistema Habit Tracker

## Contenido

1. [Estructura de la Base de Datos](1_estructura_bd.md)
   - Diagrama Entidad-Relación
   - Tablas Principales
   - Índices y Optimizaciones

2. [Vistas del Sistema](2_vistas.md)
   - DailyProgress
   - UserAchievements
   - Ejemplos de Uso

3. [Triggers](3_triggers.md)
   - Triggers de Creación Automática
   - Triggers de Actualización
   - Triggers de Logros
   - Consideraciones de Rendimiento

4. [Funciones](4_funciones.md)
   - Registro de Hábitos
   - Actualización de Seguimiento
   - Obtención de Estadísticas
   - Ejemplos de Uso

5. [Procedimientos Almacenados](5_procedimientos.md)
   - Gestión de Usuarios
   - Configuración de Reglas
   - Transacciones y Seguridad
   - Ejemplos de Uso

## Guías Rápidas

### Instalación
Consulta el [README principal](../README.md) para instrucciones detalladas de instalación.

### Primeros Pasos
1. Instalar la base de datos usando `run_all.sh`
2. Crear un usuario de prueba
3. Configurar hábitos iniciales
4. Comenzar el registro de actividades

### Mantenimiento
- Backups recomendados diarios
- Monitoreo de rendimiento
- Limpieza de datos antiguos

## Ejemplos de Uso Común

### Crear un Nuevo Usuario
```sql
CALL sp_crear_usuario('Nuevo Usuario', 'email@ejemplo.com', 'contraseña123');
```

### Registrar un Hábito
```sql
SELECT registrar_habito(1, 'Nuevo Hábito', 'Descripción', 'diaria');
```

### Consultar Progreso
```sql
SELECT * FROM DailyProgress WHERE user_id = 1;
```

## Notas Técnicas

### Versiones Soportadas
- MySQL 8.0 o superior
- MariaDB 10.5 o superior

### Consideraciones de Seguridad
- Usar siempre consultas preparadas
- Implementar control de acceso
- Mantener actualizadas las contraseñas

### Optimización
- Índices creados para consultas frecuentes
- Vistas materializadas donde sea necesario
- Triggers optimizados para rendimiento

## Contribución
1. Fork del repositorio
2. Crear rama para nuevas características
3. Seguir estándares de código
4. Documentar cambios
5. Enviar pull request 