-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear las tablas e Indices de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- Tabla de Usuario
CREATE TABLE Usuario (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de TipoTransaccion
CREATE TABLE TipoTransaccion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

-- Tabla de Categoria
CREATE TABLE Categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    tipo_transaccion_id INT,
    descripcion TEXT,
    FOREIGN KEY (tipo_transaccion_id) REFERENCES TipoTransaccion(id) ON DELETE CASCADE
);

-- Tabla de CuentaBancaria 
CREATE TABLE CuentaBancaria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    banco VARCHAR(100) NOT NULL,
    numero_cuenta VARCHAR(50) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla de Transaccion
CREATE TABLE Transaccion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    tipo_transaccion_id INT,
    cuenta_bancaria_id INT,
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    fecha TIMESTAMP NOT NULL,
    categoria_id INT,
    descripcion TEXT,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_transaccion_id) REFERENCES TipoTransaccion(id) ON DELETE CASCADE,
    FOREIGN KEY (cuenta_bancaria_id) REFERENCES CuentaBancaria(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id) ON DELETE CASCADE
);

-- Tabla de Presupuesto
CREATE TABLE Presupuesto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    categoria_id INT,
    monto_limite DECIMAL(12,2) NOT NULL CHECK (monto_limite > 0),
    periodo VARCHAR(20) NOT NULL,
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE,
    FOREIGN KEY (categoria_id) REFERENCES Categoria(id) ON DELETE CASCADE
);

-- Tabla de Meta
CREATE TABLE Meta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    nombre VARCHAR(100) NOT NULL,
    monto_objetivo DECIMAL(12,2) NOT NULL CHECK (monto_objetivo > 0),
    fecha_objetivo DATE NOT NULL,
    progreso DECIMAL(12,2) DEFAULT 0 CHECK (progreso >= 0),
    FOREIGN KEY (usuario_id) REFERENCES Usuario(id) ON DELETE CASCADE
);

-- Tabla de HistorialTransaccion
CREATE TABLE HistorialTransaccion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaccion_id INT,
    cambio TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (transaccion_id) REFERENCES Transaccion(id) ON DELETE CASCADE
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_transaccion_usuario ON Transaccion(usuario_id);
CREATE INDEX idx_transaccion_fecha ON Transaccion(fecha);
CREATE INDEX idx_categoria_tipo ON Categoria(tipo_transaccion_id);
CREATE INDEX idx_transaccion_cuenta ON Transaccion(cuenta_bancaria_id);

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
