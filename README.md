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

## 🖥️ Capturas 

Agrega aquí capturas de:
- Panel de login
 <img width="1226" alt="image" src="https://github.com/user-attachments/assets/fd208afa-ddcf-4f48-bd54-33b8d92245db" />

- Lista de repuestos
- Solicitudes realizadas
- Vista por rol

  <img width="1076" alt="image" src="https://github.com/user-attachments/assets/3dde7e0c-5e5b-4614-ad98-e206bc3ae673" />
<img width="956" alt="image" src="https://github.com/user-attachments/assets/68d1d74a-bb04-4da8-91b5-2da810714648" />


## base de datos: 

Puedes probar la base de datos de la siquiente forma.

- Ingrega somo usuario root o con permisos suficientes para crear y modificar base de datos, para ejecutar la creacion de la base de datos repuestos_merida_db, asi lo hago yo 

   ```bash
   mysql -u root < repuestos_merida_db.sql
   ```
- Luego entra a mysql 

 ```bash
   mysql -u root
   ```
- Selecciona la base de datos 

 ```bash
   use use repuestos_merida_db;
   ```
- Ahora si puedes cargar los demas achivos necesarios en este orden: 

```bash
   SOURCE indices.sql;
   SOURCE roles.sql;
   SOURCE vistas.sql;
   SOURCE procedimientos.sql;
   SOURCE trigger.sql;      
   SOURCE transaciones.sql;  
   SOURCE test_completo.sql;
   ```
- El ultimo ejecuta un test general y muestra los resutaldos 
---

## 🙌 Autor

Desarrollado por **Elias Montilla** como parte del proyecto final para la materia **Bases de Datos** en la Universidad de los Andes – Mérida, Venezuela profesor Jose Mogollon.  
Este sistema integra conceptos de SQL, lógica de negocio, transacciones, y automatización con triggers.
