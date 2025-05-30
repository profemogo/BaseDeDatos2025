# 🛒 Repuestos Mérida App – Sistema de Gestión de Ventas y Stock Administrador

Este proyecto es un sistema básico de gestión para una tienda de **repuestos**. Fue diseñado para administrar usuarios, categorías, productos, solicitudes de compra, y mensajes internos, utilizando **MySQL** como base de datos y **Node.js** como backend.

Incluye lógica para:

- 👥 Manejo de roles (administrador, vendedor, cliente).
- 🛍️ Publicación y venta de repuestos por vendedores.
- 📦 Control de stock.
- 💬 Comunicación entre usuarios.
- ✅ Transacciones seguras al aprobar una venta.
- 🧠 Procedimientos almacenados y triggers para automatización.

---

## 📦 Tecnologías utilizadas

| Tecnología       | Descripción                                                   |
|------------------|---------------------------------------------------------------|
| `MySQL`          | Base de datos relacional para almacenar usuarios y repuestos  |
| `Procedures`     | Lógica encapsulada para finalizar ventas de forma segura      |
| `Triggers`       | Reglas automáticas para enviar mensajes o auditar acciones    |
| `Node.js + Express`  | API backend para manejar login, compras, vistas, etc.|

---

## 🚀 Instalación

1. Crea la base de datos ejecutando el script SQL en MySQL:
   ```sql
   source ./repuestos_merida.sql;
   ```

2. Instala dependencias si usas backend en Node.js:
   ```bash
   npm install express mysql2 cors
   ```

---

## ▶️ Uso

Despues de instalar las dependencias puedes ejecutar:
   ```bash
   npm start
   ```

Puedes probar la funcionalidad con el siguiente flujo:

1. Un **vendedor** publica un repuesto.
2. Un **cliente** realiza una **solicitud de compra**.
3. Un **administrador o sistema** aprueba la venta usando:

```sql
CALL finalizar_venta(ID_SOLICITUD);
```

Esto:
- ✅ Verifica stock.
- ✅ Resta el stock.
- ✅ Aprueba la solicitud.
- ✅ Envía un mensaje automático al comprador.

---

## 🧠 Funcionalidades Clave

### ✅ Procedimientos

- `finalizar_venta(solicitud_id)`  
  Descuenta stock y aprueba la venta si hay suficiente cantidad.

### ⚡ Triggers

- Al cambiar el `stock` de un repuesto, se notifica al administrador.
- Al crear una solicitud, se notifica al vendedor del repuesto.

---

## 🗃️ Estructura de la Base de Datos

```
repuestos_merida_db
├── users               # Usuarios con roles
├── categorias          # Tipos de repuestos
├── repuestos           # Productos en venta
├── solicitudes         # Pedidos de clientes
├── mensajes            # Comunicación interna
├── procedimientos      # Lógica de ventas (e.g., finalizar_venta)
├── triggers            # Notificaciones automáticas
└── vistas              # Vista personalizada por vendedor
```

---

## 🖥️ Capturas (opcional)

Agrega aquí capturas de:
- Panel de login
- Lista de repuestos
- Solicitudes realizadas
- Vista por rol

---

## 🙌 Autor

Desarrollado por **Elias Montilla** como parte del proyecto final para la materia **Bases de Datos** en la Universidad de los Andes – Mérida, Venezuela profesor Jose Mogollon.  
Este sistema integra conceptos de SQL, lógica de negocio, transacciones, y automatización con triggers.
