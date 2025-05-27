# Proyecto Base de Datos - Nelson Vivas

Este proyecto contiene la estructura completa de una base de datos para gestión de facturación, contabilidad y retenciones fiscales.

## 📋 Orden de Ejecución

Para configurar correctamente la base de datos, **DEBE** ejecutar los archivos SQL en el siguiente orden:

### 1. `tables.sql` - Estructura Base
```bash
mysql -u [usuario] -p < tables.sql
```

**Propósito:** Crea la base de datos `ProjectNelsonVivas` y todas las tablas principales:
- `ClientProvider` - Clientes y proveedores
- `Bank` - Bancos y cuentas bancarias
- `PaymentMethod` - Métodos de pago
- `AccountingAccount` - Cuentas contables
- `SalesInvoice` - Facturas de venta
- `PurchaseInvoice` - Facturas de compra
- `InvoiceAccountingEntry` - Asientos contables de facturas
- `Retention` - Retenciones fiscales

**⚠️ Importante:** Este archivo debe ejecutarse PRIMERO ya que contiene las definiciones de tablas que son referenciadas por los demás archivos.

### 2. `views.sql` - Vistas del Sistema
```bash
mysql -u [usuario] -p < views.sql
```

**Propósito:** Crea vistas para consultas frecuentes y reportes:
- `Vw_BankBalances` - Saldos actuales de bancos
- `Vw_PendingReceivables` - Cuentas por cobrar pendientes
- `Vw_InvoiceJournalEntries` - Asientos contables de facturas

**Dependencias:** Requiere que las tablas ya estén creadas.

### 3. `triggers.sql` - Automatización
```bash
mysql -u [usuario] -p < triggers.sql
```

**Propósito:** Implementa lógica automática del negocio:
- `tr_bank_balance_update` - Actualiza saldos bancarios automáticamente
- `tr_calculate_retained_amount` - Calcula montos de retención automáticamente
- `trg_after_sales_accounting_entry` - Marca facturas como procesadas

**Dependencias:** Requiere que las tablas estén creadas.

### 4. `processes.sql` - Procedimientos Almacenados
```bash
mysql -u [usuario] -p < processes.sql
```

**Propósito:** Proporciona la API de la base de datos mediante procedimientos almacenados:

#### Procedimientos Principales:
- `Sp_CreateClientProvider` - Crear clientes/proveedores
- `Sp_RecordSalesInvoice` - Registrar facturas de venta
- `Sp_RecordPurchaseInvoice` - Registrar facturas de compra
- `Sp_CreateInvoiceAccountingEntry` - Crear asientos contables
- `Sp_CreateBank` - Crear bancos
- `Sp_CreatePaymentMethod` - Crear métodos de pago
- `Sp_CreateAccountingAccount` - Crear cuentas contables
- `Sp_RecordRetention` - Registrar retenciones

**Dependencias:** Requiere que todas las tablas, vistas y triggers estén creados.

### 5. `users.sql` - Sistema de Usuarios y Roles
```bash
mysql -u [usuario] -p < users.sql
```

**Propósito:** Configura el sistema de seguridad y control de acceso:

#### Roles Creados:
- `role_admin` - Administrador completo del sistema
- `role_accounting` - Gestión contable y reportes financieros
- `role_billing` - Gestión de facturas y clientes
- `role_readonly` - Solo consultas y reportes
- `role_audit` - Auditoría y monitoreo del sistema

#### Usuarios Principales:
- `admin_nelson` - Administrador principal
- `contabilidad` - Usuario de contabilidad
- `facturacion` - Usuario de facturación
- `consultas` - Usuario de solo lectura
- `auditoria` - Usuario de auditoría
- `backup_user` - Usuario para respaldos

**Dependencias:** Requiere que todos los objetos de base de datos estén creados.

### 6. `initial_load.sql` - Datos de Ejemplo
```bash
mysql -u [usuario] -p < initial_load.sql
```

**Propósito:** Carga datos de ejemplo para comenzar a trabajar inmediatamente:

#### Datos Incluidos:
- **10 Métodos de Pago:** Efectivo, transferencias, tarjetas, pago móvil, etc.
- **8 Bancos Venezolanos:** Banco de Venezuela, Banesco, Mercantil, BBVA, etc.
- **33 Cuentas Contables:** Plan contable completo (activos, pasivos, patrimonio, ingresos, gastos)
- **6 Clientes/Proveedores:** Empresas y personas naturales con diferentes retenciones
- **5 Facturas:** 3 de venta y 2 de compra con diferentes métodos de pago
- **Asientos Contables:** Generados automáticamente
- **Retenciones ISLR:** Calculadas según porcentajes configurados

**Dependencias:** Requiere que TODOS los archivos anteriores estén ejecutados.

## 🚀 Ejecución Completa

Para ejecutar todo el proyecto de una vez:

```bash
# Opción 1: Ejecutar archivo por archivo
mysql -u [usuario] -p < tables.sql
mysql -u [usuario] -p < views.sql
mysql -u [usuario] -p < triggers.sql
mysql -u [usuario] -p < processes.sql
mysql -u [usuario] -p < users.sql
mysql -u [usuario] -p < initial_load.sql

# Opción 2: Ejecutar todo en una sola sesión
mysql -u [usuario] -p -e "
source tables.sql;
source views.sql;
source triggers.sql;
source processes.sql;
source users.sql;
source initial_load.sql;
"

# Opción 3: Script de instalación completa
cat tables.sql views.sql triggers.sql processes.sql users.sql initial_load.sql | mysql -u [usuario] -p
```

## 📊 Funcionalidades del Sistema

### Gestión de Clientes y Proveedores
- Registro con validación de email y teléfono
- Configuración de porcentajes de retención fiscal
- RIF único por entidad

### Facturación
- **Ventas:** Control de cuentas por cobrar y conciliación bancaria
- **Compras:** Gestión de cuentas por pagar
- Integración automática con contabilidad

### Sistema Bancario
- Múltiples bancos con credenciales encriptadas
- Actualización automática de saldos
- Trazabilidad de movimientos

### Contabilidad
- Cuentas de ingresos y gastos
- Asientos contables automáticos
- Reportes integrados

### Retenciones Fiscales
- Cálculo automático basado en porcentajes configurados
- Aplicable a ventas y compras
- Trazabilidad completa

### Sistema de Usuarios y Seguridad
- **5 Roles diferenciados** con permisos específicos
- **8 Usuarios predefinidos** para diferentes funciones
- **Principio de menor privilegio** aplicado
- **Separación de responsabilidades** por área funcional

## 🔧 Requisitos

- MySQL 5.7 o superior (recomendado MySQL 8.0+ para funciones avanzadas de roles)
- Usuario con permisos para:
  - Crear bases de datos
  - Crear tablas, vistas, triggers y procedimientos
  - Crear usuarios y roles
  - Insertar, actualizar y consultar datos

## 📝 Notas Importantes

1. **Orden de ejecución:** Es CRÍTICO seguir el orden especificado (1→2→3→4→5→6)
2. **Validaciones:** Todos los procedimientos incluyen validación de datos
3. **Transacciones:** Los procedimientos usan transacciones para garantizar consistencia
4. **Triggers:** Se ejecutan automáticamente, no requieren invocación manual
5. **Encoding:** Asegúrese de que la base de datos use UTF-8 para caracteres especiales
6. **Seguridad:** Las credenciales bancarias se almacenan encriptadas con AES
7. **Datos de ejemplo:** El archivo `initial_load.sql` proporciona datos listos para usar

## 🎯 Primeros Pasos Después de la Instalación

1. **Conectarse como administrador:**
   ```bash
   mysql -u admin_nelson -p
   # Contraseña: AdminNelson2025!
   ```

2. **Verificar la carga de datos:**
   ```sql
   USE ProjectNelsonVivas;
   SELECT * FROM Vw_BankBalances;
   SELECT * FROM Vw_PendingReceivables;
   ```

3. **Probar funcionalidades:**
   ```sql
   -- Crear un nuevo cliente
   CALL Sp_CreateClientProvider('V-12345678-9', 'Juan Pérez', 'Cliente', 'Caracas', '0212-1234567', 'juan@email.com', 0.00, TRUE);
   
   -- Registrar una venta
   CALL Sp_RecordSalesInvoice(1, 'FAC-004-2025', '2025-01-20', 10000.00, 1600.00, 11600.00, 1, NULL, 'Venta de prueba');
   ```

## 🐛 Solución de Problemas

### Error: "Table doesn't exist"
- **Causa:** No se ejecutó `tables.sql` primero
- **Solución:** Ejecutar los archivos en el orden correcto

### Error: "Procedure doesn't exist"
- **Causa:** No se ejecutó `processes.sql`
- **Solución:** Ejecutar `processes.sql` después de los demás archivos

### Error: "Access denied for user"
- **Causa:** No se ejecutó `users.sql` o credenciales incorrectas
- **Solución:** Verificar que `users.sql` se ejecutó correctamente

### Error de permisos
- **Causa:** Usuario sin permisos suficientes
- **Solución:** Usar un usuario con permisos de administrador o GRANT necesarios

### Error en datos de ejemplo
- **Causa:** `initial_load.sql` ejecutado antes que los otros archivos
- **Solución:** Ejecutar en orden: tables → views → triggers → processes → users → initial_load

## 📈 Reportes Disponibles

Después de la instalación completa, puede acceder a estos reportes:

```sql
-- Saldos bancarios actuales
SELECT * FROM Vw_BankBalances;

-- Cuentas por cobrar pendientes
SELECT * FROM Vw_PendingReceivables;

-- Asientos contables de facturas
SELECT * FROM Vw_InvoiceJournalEntries;

-- Usuarios activos en el sistema
SELECT * FROM Vw_ActiveUsers;
```

## 📞 Soporte

Para problemas o consultas sobre la implementación, revisar:
1. Los mensajes de error específicos de MySQL
2. Los logs de la base de datos
3. Las validaciones implementadas en los procedimientos almacenados
4. La documentación de cada archivo SQL individual 