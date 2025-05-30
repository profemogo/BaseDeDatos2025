/**
 * Expenses App
 *
 * Author: Ender Jose Puentes Vargas
 * CI: V-25153102
 *
 * Categories Seeds
 * 
 **/ 

-- Casa
INSERT INTO Category (name, icon, category_group_id) VALUES
('Alquiler', 'house', (SELECT id FROM CategoryGroup WHERE name = 'Casa')),
('Hipoteca', 'mortgage', (SELECT id FROM CategoryGroup WHERE name = 'Casa')),
('Mantenimiento', 'tools', (SELECT id FROM CategoryGroup WHERE name = 'Casa')),
('Muebles', 'furniture', (SELECT id FROM CategoryGroup WHERE name = 'Casa')),
('Expensas o condominio', 'condominium', (SELECT id FROM CategoryGroup WHERE name = 'Casa'));

-- Comidas y Bebidas
INSERT INTO Category (name, icon, category_group_id) VALUES
('Restaurantes', 'restaurant', (SELECT id FROM CategoryGroup WHERE name = 'Comidas y Bebidas')),
('Supermercado', 'grocery', (SELECT id FROM CategoryGroup WHERE name = 'Comidas y Bebidas')),
('Café', 'coffee', (SELECT id FROM CategoryGroup WHERE name = 'Comidas y Bebidas')),
('Bebidas', 'drinks', (SELECT id FROM CategoryGroup WHERE name = 'Comidas y Bebidas')),
('Licores', 'liquor', (SELECT id FROM CategoryGroup WHERE name = 'Comidas y Bebidas'));

-- Entretenimiento
INSERT INTO Category (name, icon, category_group_id) VALUES
('Cine', 'movie', (SELECT id FROM CategoryGroup WHERE name = 'Entretenimiento')),
('Música', 'music', (SELECT id FROM CategoryGroup WHERE name = 'Entretenimiento')),
('Deportes', 'sports', (SELECT id FROM CategoryGroup WHERE name = 'Entretenimiento')),
('Juegos', 'games', (SELECT id FROM CategoryGroup WHERE name = 'Entretenimiento'));

-- Transporte
INSERT INTO Category (name, icon, category_group_id) VALUES
('Combustible', 'gas', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Avión', 'plane', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Transporte Público', 'bus', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Taxi', 'taxi', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Mantenimiento Vehículo', 'car-repair', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Seguro Vehículo', 'shield', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Patente Vehículo', 'car-license', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Estacionamiento', 'parking', (SELECT id FROM CategoryGroup WHERE name = 'Transporte')),
('Peaje', 'toll', (SELECT id FROM CategoryGroup WHERE name = 'Transporte'));

-- Servicios
INSERT INTO Category (name, icon, category_group_id) VALUES
('Electricidad', 'electricity', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Agua', 'water', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Gas', 'gas', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Internet', 'wifi', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Teléfono', 'phone', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Seguros', 'shield', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Recolección de Basura', 'trash', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Limpieza', 'clean', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Mantenimiento', 'tools', (SELECT id FROM CategoryGroup WHERE name = 'Servicios')),
('Otros', 'other', (SELECT id FROM CategoryGroup WHERE name = 'Servicios'));


-- Salud
INSERT INTO Category (name, icon, category_group_id) VALUES
('Médico', 'doctor', (SELECT id FROM CategoryGroup WHERE name = 'Salud')),
('Farmacia', 'pharmacy', (SELECT id FROM CategoryGroup WHERE name = 'Salud')),
('Dentista', 'tooth', (SELECT id FROM CategoryGroup WHERE name = 'Salud')),
('Gimnasio', 'gym', (SELECT id FROM CategoryGroup WHERE name = 'Salud'));

-- Educación
INSERT INTO Category (name, icon, category_group_id) VALUES
('Matrícula', 'school', (SELECT id FROM CategoryGroup WHERE name = 'Educación')),
('Libros', 'book', (SELECT id FROM CategoryGroup WHERE name = 'Educación')),
('Cursos', 'graduation', (SELECT id FROM CategoryGroup WHERE name = 'Educación')),
('Material Escolar', 'pencil', (SELECT id FROM CategoryGroup WHERE name = 'Educación'));

-- Compras
INSERT INTO Category (name, icon, category_group_id) VALUES
('Ropa', 'clothes', (SELECT id FROM CategoryGroup WHERE name = 'Compras')),
('Electrónicos', 'electronics', (SELECT id FROM CategoryGroup WHERE name = 'Compras')),
('Accesorios', 'accessories', (SELECT id FROM CategoryGroup WHERE name = 'Compras')),
('Hogar', 'home-goods', (SELECT id FROM CategoryGroup WHERE name = 'Compras'));

-- Viajes
INSERT INTO Category (name, icon, category_group_id) VALUES
('Vuelos', 'plane', (SELECT id FROM CategoryGroup WHERE name = 'Viajes')),
('Hoteles', 'hotel', (SELECT id FROM CategoryGroup WHERE name = 'Viajes')),
('Actividades', 'activity', (SELECT id FROM CategoryGroup WHERE name = 'Viajes')),
('Transporte', 'transport', (SELECT id FROM CategoryGroup WHERE name = 'Viajes'));

-- Regalos
INSERT INTO Category (name, icon, category_group_id) VALUES
('Cumpleaños', 'birthday', (SELECT id FROM CategoryGroup WHERE name = 'Regalos')),
('Navidad', 'christmas', (SELECT id FROM CategoryGroup WHERE name = 'Regalos')),
('Aniversario', 'heart', (SELECT id FROM CategoryGroup WHERE name = 'Regalos'));

-- Mascotas
INSERT INTO Category (name, icon, category_group_id) VALUES
('Comida', 'pet-food', (SELECT id FROM CategoryGroup WHERE name = 'Mascotas')),
('Veterinario', 'vet', (SELECT id FROM CategoryGroup WHERE name = 'Mascotas')),
('Accesorios', 'pet-supplies', (SELECT id FROM CategoryGroup WHERE name = 'Mascotas'));

-- Inversiones
INSERT INTO Category (name, icon, category_group_id) VALUES
('Acciones', 'stocks', (SELECT id FROM CategoryGroup WHERE name = 'Inversiones')),
('Criptomonedas', 'crypto', (SELECT id FROM CategoryGroup WHERE name = 'Inversiones')),
('Fondos', 'funds', (SELECT id FROM CategoryGroup WHERE name = 'Inversiones'));

-- Otros
INSERT INTO Category (name, icon, category_group_id) VALUES
('Otros', 'other', (SELECT id FROM CategoryGroup WHERE name = 'Otros'));
INSERT INTO Category (name, icon, category_group_id) VALUES
('Imprevistos', 'alert', (SELECT id FROM CategoryGroup WHERE name = 'Otros'));
