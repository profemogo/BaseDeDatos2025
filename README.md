# Habit Tracker - Base de Datos

Este proyecto contiene la estructura y scripts necesarios para implementar una base de datos de seguimiento de hábitos en MySQL.

## Estructura del Proyecto

```
.
├── README.md
├── schema.sql           # Estructura de la base de datos
├── data.sql            # Datos iniciales
├── views.sql           # Vistas
├── functions.sql       # Funciones
├── procedures.sql      # Procedimientos almacenados
├── triggers.sql        # Triggers
├── roles_users.sql     # Roles y usuarios
├── run_all.sh         # Script de implementación
└── docs/              # Documentación detallada
    ├── README.md                    # Índice de la documentación
    ├── 1_estructura_bd.md          # Estructura de la base de datos
    ├── 2_vistas.md                 # Documentación de vistas
    ├── 3_triggers.md               # Documentación de triggers
    ├── 4_funciones.md             # Documentación de funciones
    └── 5_procedimientos.md        # Documentación de procedimientos
```

## Requisitos Previos

- MySQL Server 8.0 o superior
- Acceso root a MySQL
- Terminal con bash (Linux/Mac) o Git Bash (Windows)

## Instalación

1. Clona o descarga este repositorio en tu máquina local
2. Asegúrate de que MySQL Server esté instalado y ejecutándose
3. Verifica que tienes los permisos necesarios para crear bases de datos

## Ejecución

1. Abre una terminal en el directorio del proyecto

2. Dale permisos de ejecución al script:
   ```bash
   chmod +x run_all.sh
   ```

3. Ejecuta el script:
   ```bash
   ./run_all.sh
   ```

4. Cuando se solicite, ingresa la contraseña de root de MySQL

## Documentación

### Estructura de la Documentación
La documentación completa del proyecto se encuentra en el directorio `docs/`. Para consultarla:

1. Comienza por el archivo `docs/README.md` que sirve como índice
2. Navega a las secciones específicas según tus necesidades:
   - Estructura de la base de datos
   - Vistas del sistema
   - Triggers
   - Funciones
   - Procedimientos almacenados

### Mantenimiento de la Documentación
Para mantener la documentación:

1. Cada nuevo feature debe documentarse en el archivo correspondiente
2. Seguir el formato Markdown existente
3. Actualizar el índice en `docs/README.md` si se añaden nuevas secciones
4. Incluir ejemplos prácticos de uso
5. Mantener actualizada la documentación cuando se modifique el código

## Verificación de la Instalación

Para verificar que todo se instaló correctamente, puedes:

1. Conectarte a MySQL:
   ```bash
   mysql -u root -p
   ```

2. Seleccionar la base de datos:
   ```sql
   USE habit_tracker;
   ```

3. Verificar las tablas creadas:
   ```sql
   SHOW TABLES;
   ```

## Solución de Problemas

Si encuentras algún error durante la ejecución:

1. Verifica que MySQL está ejecutándose
2. Confirma que tienes los permisos correctos
3. Revisa los mensajes de error en la terminal
4. Asegúrate de que no existe una base de datos previa con el mismo nombre

## Notas Adicionales

- El script solicitará la contraseña de root una sola vez
- Si ocurre un error, el script se detendrá y mostrará el mensaje correspondiente
- Cada paso de la ejecución mostrará un mensaje de éxito o error 