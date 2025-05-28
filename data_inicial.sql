-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Data Incial Necesaria de Base de Datos 
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Insertar tipos de transacción
INSERT INTO TipoTransaccion (nombre) VALUES
    ('Ingreso'),
    ('Gasto');

-- Insertar todas las categorías
INSERT INTO Categoria (nombre, tipo_transaccion_id, descripcion) VALUES
    -- Categorías de Ingresos
    ('Trabajo', 1, 'Ingresos provenientes de empleo formal'),
    ('Negocio Propio/Freelance', 1, 'Ingresos de actividades independientes'),
    ('Inversiones', 1, 'Rendimientos de inversiones'),
    ('Gobierno/Ayudas', 1, 'Subsidios y ayudas gubernamentales'),
    ('Regalos/Donaciones', 1, 'Ingresos por regalos o donaciones recibidas'),
    ('Otros Ingresos', 1, 'Ingresos diversos no categorizados'),
    
    -- Categorías de Gastos
    ('Vivienda', 2, 'Gastos relacionados con la vivienda'),
    ('Transporte', 2, 'Gastos de transporte y movilidad'),
    ('Alimentación', 2, 'Gastos en alimentos y bebidas'),
    ('Salud', 2, 'Gastos médicos y de salud'),
    ('Formación', 2, 'Gastos en educación y desarrollo personal'),
    ('Ocio', 2, 'Gastos en entretenimiento'),
    ('Ropa/Cuidado Personal', 2, 'Gastos en vestimenta y cuidado personal'),
    ('Deudas/Préstamos', 2, 'Pagos de deudas y préstamos'),
    ('Ahorro/Inversiones', 2, 'Dinero destinado a ahorro e inversiones'),
    ('Gastos Familiares', 2, 'Gastos relacionados con la familia'),
    ('Seguros', 2, 'Gastos en seguros'),
    ('Donaciones', 2, 'Donaciones y caridad'),
    ('Impuestos', 2, 'Pago de impuestos'),
    ('Gastos Profesionales', 2, 'Gastos relacionados con el trabajo'),
    ('Otros Gastos', 2, 'Gastos diversos no categorizados');
