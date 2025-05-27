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
- `obtener_saldo_usuario`: Saldo neto de un usuario.
- `total_gastos_usuario_periodo`: Total de gastos en un periodo.
- `total_ingresos_usuario_periodo`: Total de ingresos en un periodo.
- `porcentaje_avance_meta`: Porcentaje de avance de una meta financiera.
- `cantidad_transacciones_mes`: Número de transacciones en un mes.

---

### 3. **procedimientos.sql**
Incluye **procedimientos almacenados** para operaciones complejas y atómicas:
- `registrar_transaccion`: Inserta una transacción y su historial.
- `transferir_entre_cuentas`: Realiza una transferencia entre cuentas del mismo usuario y registra ambos movimientos.
- Crea también un índice adicional para mejorar el rendimiento de alertas.

---

### 4. **trigger.sql**
Define los **triggers** (disparadores) para automatizar tareas y validar reglas de negocio:
- Insertar y actualizar historial de transacciones.
- Validar que la fecha de una meta sea futura.
- Generar alertas cuando se supera un presupuesto.

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

### 6. **pruebas_validas.sql**
Contiene **pruebas válidas** para verificar el correcto funcionamiento de la base de datos:
- Consultas básicas de contenido.
- Uso de vistas.
- Pruebas de triggers, funciones y procedimientos con datos válidos.

---

### 7. **pruebas_invalidas.sql**
Incluye **pruebas negativas** para comprobar que las restricciones, triggers y claves foráneas funcionan correctamente:
- Inserciones con datos inválidos (montos negativos, fechas pasadas, claves foráneas inexistentes, etc.).
- Cada prueba debe fallar y ser rechazada por la base de datos.

---

## Uso recomendado

1. Ejecuta `tablas.sql` para crear la estructura y datos base.
2. Ejecuta `funciones.sql`, `procedimientos.sql`, `trigger.sql` y `vistas.sql` para agregar la lógica avanzada.
3. Usa `pruebas_validas.sql` para comprobar que todo funciona correctamente.
4. Usa `pruebas_invalidas.sql` para verificar que las restricciones y validaciones están activas.

---

**Autor:** Lorena Fernandez  

---