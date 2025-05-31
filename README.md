# 💰 ExpenseApp

Sistema de Gestión de Gastos Compartidos

## Descripción General

ExpenseApp es un sistema de gestión de gastos compartidos que permite a grupos de usuarios administrar y dividir sus gastos de manera eficiente. Desarrollado como proyecto universitario, ofrece:

- ⚖️ División equitativa o personalizada de gastos entre usuarios
- 📁 Organización por categorías y espacios de trabajo
- 📊 Registro detallado de transacciones y balances
- 👥 Gestión de invitaciones y miembros
- 💱 Soporte para múltiples monedas

La aplicación está diseñada para simplificar el manejo de finanzas compartidas en cualquier contexto, desde gastos entre roommates hasta presupuestos familiares.

## Estructura del Proyecto

```
BaseDeDatos2025/
├── definitions/         # Definiciones de la base de datos
│   ├── tables.sql       # Definición de tablas
│   ├── functions.sql    # Funciones de la base de datos
│   ├── procedures.sql   # Procedimientos almacenados
│   ├── triggers.sql     # Triggers
│   ├── views.sql        # Vistas
│   ├── indexes.sql      # Índices
│   └── security.sql     # Configuración de seguridad
├── scripts/             # Scripts de instalación
│   ├── unix/            # Scripts para sistemas Unix
│   │   ├── init.sh      # Script de inicialización y configuración inicial
│   │   ├── seed.sh      # Script de carga de datos por defecto
│   │   └── test.sh      # Script de ejecución de pruebas automatizadas
│   └── windows/         # Scripts para Windows
│   │   ├── init.sh      # Script de inicialización y configuración inicial
│   │   ├── seed.sh      # Script de carga de datos por defecto
│   │   └── test.sh      # Script de ejecución de pruebas automatizadas
├── seeds/               # Datos iniciales
│   ├── categories.sql
│   ├── categories-group.sql
│   └── currencies.sql
└── tests/               # Casos de prueba
    ├── case1.sql
    └── case2.sql
```

## Estructura de la Base de Datos 🗄️

### 1. Tablas 📋

1. User 👤
2. CategoryGroup 📑
3. Category 🏷️
4. Currency 💱
5. Workspace 🏢
6. WorkspaceUser 👥
7. WorkspaceInvitation ✉️
8. Expense 💰
9. ExpenseSplit ⚖️
10. ExpenseComment 💬

Ver [definitions/tables.sql](definitions/tables.sql) para más detalles

### 2. Indices 🔍

Ver [definitions/indexes.sql](definitions/indexes.sql) para más detalles

### 3. Funciones ⚙️

1. **GetUserWorkspaceBalance**
   - Calcula el balance de un usuario en un workspace
   - Retorna detalles de deudas y créditos
   - Formato de salida en JSON

Ver [definitions/functions.sql](definitions/functions.sql) para más detalles

### 4. Procedimientos Almacenados 📝

1. **CreateExpenseWithSplits**

   - Creación de gastos
   - Validación de permisos y datos

2. **UpdateExpenseWithSplits**
   - Actualización de gastos
   - Validación de permisos y datos

Ver [definitions/procedures.sql](definitions/procedures.sql) para más detalles

### 5. Triggers ⚡

1. **Triggers de la Tabla User**

   - Encriptación automática de contraseñas (BEFORE INSERT)
   - Encriptación automática de contraseñas (BEFORE UPDATE)
   - Actualización de comentarios al cambiar nombre de usuario (BEFORE UPDATE)

2. **Triggers de la Tabla Workspace**

   - Asignación automática del creador como miembro (AFTER INSERT)
   - Eliminación en cascada de datos relacionados (BEFORE DELETE)

3. **Triggers de la Tabla WorkspaceInvitation**

   - Asignación automática del usuario al workspace cuando se acepta la invitación (BEFORE UPDATE)

4. **Triggers de la Tabla Expense**

   - Registro de comentarios al modificar campos (BEFORE UPDATE)
   - Eliminación en cascada de comentarios y divisiones (BEFORE DELETE)

5. **Triggers de la Tabla ExpenseSplit**
   - Registro de comentarios al modificar montos (BEFORE UPDATE)

Ver [definitions/triggers.sql](definitions/triggers.sql) para más detalles

### 6. Vistas 👀

1. **ExpenseCommentView**
   - Vista para comentarios de gastos
   - Combina información del usuario y el comentario
   - Formato: "[Nombre Usuario] modificó esta transacción: [Comentario]"
   - Ordenado por fecha de actualización descendente

Ver [definitions/views.sql](definitions/views.sql) para más detalles

### 7. Seguridad 🔒

1. **Roles**

   - Administrator: Acceso total al sistema
   - API: Acceso limitado para el servicio REST
   - Developer: Acceso extendido de API para desarrollo

2. **Usuarios**

   - Administrator: José Mogollón (josemogo)
     - Acceso local y red interna
     - Todos los privilegios
   - API Service (apiservice)
     - Acceso desde dominio api.expenseapp.com
     - Permisos de lectura/escritura para operaciones API
   - Developers: Ender Puentes, Pedro Pérez
     - Acceso solo por VPN (192.168.0.x)
     - Permisos extendidos de API + gestión de catálogos

3. **Privilegios por Rol**

   - Administrator
     - Acceso total a todas las tablas y operaciones
   - API
     - Lectura de catálogos (Currency, Category, CategoryGroup)
     - Operaciones CRUD en tablas de usuarios y workspaces
     - Operaciones CRUD en gastos y divisiones
     - Ejecución de procedimientos almacenados
     - Acceso a vistas del sistema
   - Developer
     - Todos los privilegios de API
     - Gestión completa de catálogos

4. **Restricciones de Acceso**
   - Acceso local restringido por IP
   - Conexiones API solo desde dominio autorizado
   - Desarrolladores solo vía VPN

Ver [definitions/security.sql](definitions/security.sql) para más detalles

## Instalación 🛠️

### Requisitos Previos ✅

- MySQL 8.0 o superior 🗄️
- Sistema operativo compatible (Windows/Unix) 💻

### Pasos de Instalación y llenado con datos iniciales

1. **Sistemas Unix**

```bash
  ./scripts/unix/init.sh ExpenseApp root 'your_password'
  ./scripts/unix/seed.sh ExpenseApp root 'your_password'
```

**Nota**: Si su contraseña es vacía:

```bash
  ./scripts/unix/init.sh ExpenseApp root ''
  ./scripts/unix/seed.sh ExpenseApp root ''
```

2. **Windows**

```cmd
  ./scripts/windows/init.ps1 ExpenseApp root 'your_password'
  ./scripts/windows/seed.ps1 ExpenseApp root 'your_password'
```

**Nota**: Si su contraseña es vacía:

```cmd
  ./scripts/windows/init.ps1 ExpenseApp root ''
  ./scripts/windows/seed.ps1 ExpenseApp root ''
```

## Casos de Prueba 🧪

### Ejecución de Pruebas ▶️

Para ejecutar los casos de prueba:

1. **Sistemas Unix**

```bash
  ./scripts/unix/test.sh ExpenseApp root 'your_password'
```

2. **Windows**

```cmd
  ./scripts/windows/test.ps1 ExpenseApp root 'your_password'
```

### Caso 1: Gestión de Gastos en Hogar 🏠

- Escenario: Juan y María son un matrimonio que comparten gastos del hogar pero no tienen un control adecuado de sus finanzas
- Características demostradas:
  - Registro de usuarios 👥 (Juan y María se registran en la app)
  - Creación de workspace 🏢 (Juan crea workspace "Hogar" en Bs.)
  - Sistema de invitaciones ✉️ (Juan invita a María al workspace)
  - Registro y modificación de gastos 📝 (Juan registra gasto de supermercado erróneamente)
  - División equitativa de gastos ⚖️ (Compra de Bs. 150 dividida en partes iguales)
  - Sistema de pagos y saldos 💰 (Juan paga su deuda de Bs. 75 a María)

### Caso 2: Gestión de Gastos en Apartamento Compartido 🏢

- Escenario: Carlos y Ana son hermanos que comparten un apartamento y deciden usar ExpensesApp para registrar y dividir los gastos de manera justa y transparente
- Características demostradas:
  - Registro de usuarios 👥 (Carlos y Ana se registran en la app)
  - Creación de workspace 🏢 (Carlos crea workspace "Apartamento" en Bs.)
  - Sistema de invitaciones ✉️ (Carlos invita a Ana al workspace)
  - Registro de gastos con división equitativa ⚖️ (Compras mercado mensual, cena, internet, luz)
  - Registro de gastos con división desigual 📊 (Artículos de limpieza, compras varias)
  - Sistema de corrección de errores ✏️ (Carlos corrige monto erróneo de compra)
  - Registro de auditoría de cambios 📋 (Comentarios automáticos de modificaciones)
  - Cálculo y liquidación de balances 💰 (Carlos paga deuda de Bs. 215 a Ana)
  - Gestión de membresía 👤 (Carlos se retira del workspace)
  - Eliminación de cuenta 🗑️ (Carlos elimina su cuenta)

**Nota**: Los comentarios en los test se han mantenido en español para facilitar la comprensión y mantenimiento del proyecto.

## Autor

- **Ender Puentes** 👾
  - [GitHub](https://github.com/EnderPuentes)
  - [Email](mailto:endpuent@gmail.com)

## Licencia 📄

Este proyecto es parte de un trabajo universitario y está sujeto a los términos de la licencia académica.
