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

## 🚀 Ejecución Completa

Para ejecutar todo el proyecto de una vez:

```bash
# Opción 1: Ejecutar archivo por archivo
mysql -u [usuario] -p < tables.sql
mysql -u [usuario] -p < views.sql
mysql -u [usuario] -p < triggers.sql
mysql -u [usuario] -p < processes.sql

# Opción 2: Ejecutar todo en una sola sesión
mysql -u [usuario] -p -e "
source tables.sql;
source views.sql;
source triggers.sql;
source processes.sql;
"
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

## 🔧 Requisitos

- MySQL 5.7 o superior
- Usuario con permisos para:
  - Crear bases de datos
  - Crear tablas, vistas, triggers y procedimientos
  - Insertar, actualizar y consultar datos

## 📝 Notas Importantes

1. **Orden de ejecución:** Es CRÍTICO seguir el orden especificado
2. **Validaciones:** Todos los procedimientos incluyen validación de datos
3. **Transacciones:** Los procedimientos usan transacciones para garantizar consistencia
4. **Triggers:** Se ejecutan automáticamente, no requieren invocación manual
5. **Encoding:** Asegúrese de que la base de datos use UTF-8 para caracteres especiales

## 🐛 Solución de Problemas

### Error: "Table doesn't exist"
- **Causa:** No se ejecutó `tables.sql` primero
- **Solución:** Ejecutar los archivos en el orden correcto

### Error: "Procedure doesn't exist"
- **Causa:** No se ejecutó `processes.sql`
- **Solución:** Ejecutar `processes.sql` después de los demás archivos

### Error de permisos
- **Causa:** Usuario sin permisos suficientes
- **Solución:** Usar un usuario con permisos de administrador o GRANT necesarios

## 📞 Soporte

Para problemas o consultas sobre la implementación, revisar:
1. Los mensajes de error específicos de MySQL
2. Los logs de la base de datos
3. Las validaciones implementadas en los procedimientos almacenados 