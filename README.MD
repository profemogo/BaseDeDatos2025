# Sistema para la gestión de reservas de un restaurante

## Descripción

Este proyecto contiene el esquema completo y los objetos necesarios para gestionar reservas en un restaurante, incluyendo clientes, mesas, productos, pedidos y reservas con sus productos asociados. Está diseñado para funcionar con MySQL 8.0 o superior.

El repositorio incluye los siguientes archivos SQL organizados para facilitar su uso e instalación:

1. **Tablas**  
   Definición de las tablas principales que conforman la base de datos: Cliente, Mesa, Producto, Pedido, Reserva y ReservaProducto.

2. **Indices**  
   Creación de índices para optimizar consultas frecuentes sobre campos clave en las tablas.

3. **Vistas**  
   Vistas que simplifican el acceso a información agregada o combinada, útil para reportes y consultas de negocio.

4. **Disparadores (Triggers)**  
   Triggers que mantienen la integridad del sistema, como actualización automática del estado de mesas tras inserciones, actualizaciones o eliminaciones de reservas.

5. **Funciones y Procedimientos Almacenados**  
   Funciones y procedimientos que encapsulan lógica de negocio, como inserción transaccional de reservas con productos y pedidos.

6. **Roles, Usuarios y Permisos**  
   Scripts para crear roles básicos y usuarios con permisos mínimos necesarios para operar la base de datos de manera segura.

7. **Data Inicial**  
   Datos base para la puesta en marcha del sistema: mesas y productos configurados para el restaurante.

8. **Data Pruebas**  
   Datos de ejemplo para clientes, reservas y pedidos que permiten realizar pruebas funcionales y de integración.

---

## Instalación

### Requisitos

- MySQL Server versión 8.0 o superior instalado y configurado.
- Acceso con usuario administrador para crear base de datos y objetos.

### Pasos para la instalación

1. Crear la base de datos e importar las tablas:

    mysql -u usuario -p < 1-Tablas.sql
    mysql -u usuario -p < 2-Indices.sql
    mysql -u usuario -p < 3-Vistas.sql
    mysql -u usuario -p < 4-Disparadores.sql
    mysql -u usuario -p < 5-Funciones_ProcedimientosAlmacenados.sql
    mysql -u usuario -p < 6-Roles_Usuarios_Permisos.sql
    mysql -u usuario -p < 7-Data_Inicial.sql
    mysql -u usuario -p < 8-Data_Pruebas.sql

## Descripción de las tablas

    ### Cliente
    Registra los clientes con sus datos personales: nombre, apellido, teléfono y correo electrónico único.

    ### Mesa
    Almacena información sobre las mesas del restaurante, incluyendo su nombre, capacidad, ubicación y estado actual (Disponible, Ocupada, Reservada).

    ### Producto
    Catálogo de productos disponibles para pedido, con nombre, descripción y precio.

    ### Pedido
    Representa pedidos realizados dentro de una reserva, con estado y total acumulado.

    ### Reserva
    Registra las reservas hechas por los clientes para una mesa específica en una fecha y hora, con número de personas y estado de la reserva (Pendiente, Confirmada, Cancelada). Se relaciona con Cliente y Mesa.

    ### ReservaProducto
    Detalle de productos asociados a cada reserva, con cantidad y observaciones. Permite registrar pedidos específicos dentro de una reserva.


## Consideraciones adicionales

    Las relaciones entre tablas están definidas mediante claves foráneas para asegurar la integridad referencial.

    Los disparadores mantienen actualizado el estado de las mesas automáticamente al cambiar el estado de las reservas.

    Las vistas permiten consultas simplificadas para obtener informes y estados generales del restaurante.

    El sistema está preparado para manejar escenarios comunes en la gestión de reservas, pedidos y facturación básica.

    Se recomienda ejecutar los scripts en el orden indicado para evitar errores de dependencias.