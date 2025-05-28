# Proyecto Base de Datos Financiera Personal

Este proyecto implementa una base de datos relacional para la gestión de finanzas personales, incluyendo usuarios, transacciones, cuentas, presupuestos, metas, historial, funciones, procedimientos, triggers y vistas.

---

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

---

### 2. **funciones.sql**
Contiene todas las **funciones almacenadas** útiles para reportes y análisis, por ejemplo:
- `ObtenerSaldoUsuario`: Saldo neto de un usuario.
- `TotalGastosUsuarioPeriodo`: Total de gastos en un periodo.
- `TotalIngresosUsuarioPeriodo`: Total de ingresos en un periodo.
- `PorcentajeAvanceMeta`: Porcentaje de avance de una meta financiera.
- `CantidadTransaccionesMes`: Número de transacciones en un mes.

---

### 3. **procedimientos.sql**
Incluye **procedimientos almacenados** para operaciones complejas y atómicas:
- `RegistrarTransaccion`: Inserta una transacción y su historial.
- `TransferirEntreCuentas`: Realiza una transferencia entre cuentas del mismo usuario y registra ambos movimientos.

---

### 4. **trigger.sql**
Define los **triggers** (disparadores) para automatizar tareas y validar reglas de negocio:
- `DespuesInsertarTransaccion`: Registra en el historial al crear una transacción.
- `DespuesActualizarTransaccion`: Registra en el historial al actualizar una transacción.
- `DespuesInsertarTransaccionPresupuesto`: Valida y alerta cuando se supera un presupuesto.

---

### 5. **vistas.sql**
Crea **vistas** para facilitar reportes y consultas complejas:
- `BalanceGeneral`: Resumen de ingresos, gastos y balance por usuario.
- `GastosUsuario`: Gastos por categoría y usuario.
- `SeguimientoMetasFinancieras`: Progreso y estado de metas.
- `SeguimientoPresupuestos`: Estado y uso de presupuestos.
- `DetalleTransacciones`: Detalle de todas las transacciones.
- `ResumenTransacciones`: Resumen mensual de transacciones.

---

### 6. **roles.sql**
Define el sistema de **roles y permisos** para control de acceso:
- **admin_role**: Acceso total al sistema
  - Puede gestionar usuarios, categorías y tipos de transacción
  - Control total sobre todas las tablas
- **usuario_role**: Acceso a datos personales
  - Gestión de sus propias transacciones, presupuestos y metas
  - Solo lectura en categorías y tipos de transacción
  - No puede modificar datos de otros usuarios
- **auditor_role**: Acceso de solo lectura
  - Puede ver todas las tablas
  - Útil para auditorías y verificación de datos

Incluye procedimientos para:
- `AsignarRolUsuario`: Asignar roles a usuarios
- `RevocarRolUsuario`: Quitar roles a usuarios
- `VerificarPermisosUsuario`: Consultar permisos de un usuario

---

### 7. **pruebas_validas.sql**
Contiene **pruebas válidas** para verificar el correcto funcionamiento de la base de datos:
- Consultas básicas de contenido de tablas
- Pruebas de vistas
- Pruebas de triggers:
  - Historial de transacciones
  - Validación de presupuestos
- Pruebas de funciones:
  - Cálculo de saldos
  - Cálculo de gastos e ingresos
  - Seguimiento de metas
- Pruebas de procedimientos:
  - Registro de transacciones
  - Transferencias entre cuentas

---

### 8. **pruebas_invalidas.sql**
Incluye **pruebas negativas** para comprobar que las restricciones, triggers y claves foráneas funcionan correctamente:
- Inserciones con datos inválidos (montos negativos, claves foráneas inexistentes, etc.)
- Intentos de superar límites de presupuesto
- Cada prueba debe fallar y ser rechazada por la base de datos

---

## Uso recomendado

1. Ejecuta `tablas.sql` para crear la estructura y datos base.
2. Ejecuta `funciones.sql`, `procedimientos.sql`, `trigger.sql` y `vistas.sql` para agregar la lógica avanzada.
3. Ejecuta `roles.sql` para configurar los permisos de acceso.
4. Usa `pruebas_validas.sql` para comprobar que todo funciona correctamente.
5. Usa `pruebas_invalidas.sql` para verificar que las restricciones y validaciones están activas.

---

**Autor:** Lorena Fernandez  

---