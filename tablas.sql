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
