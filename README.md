# Proyecto Base de Datos Financiera Personal

Este proyecto implementa una base de datos relacional para la gestión de finanzas personales, incluyendo usuarios, transacciones, cuentas, presupuestos, metas, historial, funciones, procedimientos, triggers y vistas.

## Estructura de Archivos

### 1. **tablas.sql**
Define todas las **tablas** principales del sistema:
- Usuario
- TipoTransaccion
- Categoria
- CuentaBancaria
- Transaccion
- Presupuesto
- Meta
- HistorialTransaccion

Incluye también la creación de **índices** y la inserción de datos base (tipos de transacción y categorías).

### 2. **funciones.sql**
Contiene todas las **funciones almacenadas** útiles para reportes y análisis:
- `ObtenerSaldoUsuario`: Saldo neto de un usuario
- `TotalGastosUsuarioPeriodo`: Total de gastos en un periodo
- `TotalIngresosUsuarioPeriodo`: Total de ingresos en un periodo
- `PorcentajeAvanceMeta`: Porcentaje de avance de una meta financiera
- `CantidadTransaccionesMes`: Número de transacciones en un mes

### 3. **procedimientos.sql**
Incluye **procedimientos almacenados** para operaciones complejas:
- `RegistrarTransaccion`: Inserta una transacción y su historial
- `TransferirEntreCuentas`: Realiza una transferencia entre cuentas del mismo usuario

### 4. **trigger.sql**
Define los **triggers** para automatizar tareas y validar reglas de negocio:
- `DespuesInsertarTransaccion`: Registra en el historial al crear una transacción
- `DespuesActualizarTransaccion`: Registra en el historial al actualizar una transacción
- `DespuesInsertarTransaccionPresupuesto`: Valida y alerta cuando se supera un presupuesto

### 5. **vistas.sql**
Crea **vistas** para facilitar reportes y consultas complejas:
- `BalanceGeneral`: Resumen de ingresos, gastos y balance por usuario
- `GastosUsuario`: Gastos por categoría y usuario
- `SeguimientoMetasFinancieras`: Progreso y estado de metas
- `SeguimientoPresupuestos`: Estado y uso de presupuestos
- `DetalleTransacciones`: Detalle de todas las transacciones
- `ResumenTransacciones`: Resumen mensual de transacciones

### 6. **roles.sql**
Define el sistema de **roles y permisos** para control de acceso:

#### Roles Principales:
- **admin_role**: Acceso total al sistema
  - Gestión de usuarios, categorías y tipos de transacción
  - Control total sobre todas las tablas
- **usuario_role**: Acceso a datos personales
  - Gestión de sus propias transacciones, presupuestos y metas
  - Solo lectura en categorías y tipos de transacción
- **auditor_role**: Acceso de solo lectura
  - Visualización de todas las tablas
  - Útil para auditorías y verificación de datos

#### Procedimientos de Gestión:
- `AsignarRolUsuario`: Asignar roles a usuarios
- `RevocarRolUsuario`: Quitar roles a usuarios
- `VerificarPermisosUsuario`: Consultar permisos de un usuario

### 7. **pruebas_validas.sql**
Contiene **pruebas válidas** para verificar el funcionamiento:
- Consultas básicas de contenido de tablas
- Pruebas de vistas
- Pruebas de triggers
- Pruebas de funciones
- Pruebas de procedimientos

### 8. **pruebas_invalidas.sql**
Incluye **pruebas negativas** para validar restricciones:
- Inserciones con datos inválidos
- Intentos de superar límites de presupuesto
- Validación de claves foráneas

## Instalación y Uso

### 1. Crear la Base de Datos
```sql
mysql -u root -p -e "CREATE DATABASE FinanzasPersonales;"
```

### 2. Ejecutar los Scripts en Orden
```sql
mysql -u root -p FinanzasPersonales < tablas.sql
mysql -u root -p FinanzasPersonales < data_inicial.sql
mysql -u root -p FinanzasPersonales < funciones.sql
mysql -u root -p FinanzasPersonales < procedimientos.sql
mysql -u root -p FinanzasPersonales < trigger.sql
mysql -u root -p FinanzasPersonales < vistas.sql
mysql -u root -p FinanzasPersonales < roles.sql
```


## Notas
- Asegúrate de tener MySQL instalado y configurado correctamente
- Los scripts deben ejecutarse en el orden especificado
- Mantén una copia de seguridad antes de realizar cambios importantes

---
**Autor:** Lorena Fernandez  