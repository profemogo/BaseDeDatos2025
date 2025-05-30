-- Tables

-- Estado civil
CREATE TABLE EstadoCivil (
    id Int PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50) NOT NULL UNIQUE
);

-- Tipo de Documento
CREATE TABLE TipoDocumento (
    id INT PRIMARY KEY AUTO_INCREMENT,
    abreviatura CHAR(1) NOT NULL UNIQUE,
    CONSTRAINT chk_abreviatura_mayusculas CHECK (BINARY abreviatura = BINARY UPPER(abreviatura))
);
-- Tipo de Documento
CREATE TABLE TipoInforme (
    id INT PRIMARY KEY AUTO_INCREMENT UNIQUE,
    codigo VARCHAR(20) NOT NULL UNIQUE
);

-- Tipo de Sangre
CREATE TABLE TipoSangre (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tipo VARCHAR(5) NOT NULL UNIQUE,
    CONSTRAINT chk_tipo_mayusculas CHECK (BINARY tipo = BINARY UPPER(tipo))
);

-- Pacientes
CREATE TABLE Paciente (
    id Int PRIMARY KEY AUTO_INCREMENT,
    documento VARCHAR(50) NOT NULL UNIQUE,
    tipo_documento_id Int NOT NULL,
    estado_civil_id Int NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    estudio VARCHAR(100),
    direccion VARCHAR(255),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (tipo_documento_id) REFERENCES TipoDocumento(id) ON UPDATE CASCADE,
    FOREIGN KEY (estado_civil_id) REFERENCES EstadoCivil(id) ON UPDATE CASCADE
);

-- Telefonos
CREATE TABLE Telefono (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL,
    numero VARCHAR(15) NOT NULL,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE,
    UNIQUE KEY (paciente_id, numero)
);

-- Habitos
CREATE TABLE Habito (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL UNIQUE,
    alcohol BOOLEAN DEFAULT FALSE,
    tabaco BOOLEAN DEFAULT FALSE,
    cafe BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);

-- Examen Fisico
CREATE TABLE ExamenFisico (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL UNIQUE,
    examen_mama VARCHAR(100),
    colposcopia VARCHAR(100),
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);

-- Controles
CREATE TABLE Control (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL,
    fecha DATE NOT NULL,
    peso DECIMAL(5,2),
    talla DECIMAL(5,2),
    tension_arterial VARCHAR(10),
    frecuencia_cardiaca INT,
    observaciones TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);

-- Informes
CREATE TABLE Informe (
    id Int PRIMARY KEY AUTO_INCREMENT,
    control_id Int NOT NULL,
    tipo_informe_id Int NOT NULL,
    conclusion TEXT,
    FOREIGN KEY (control_id) REFERENCES Control(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_informe_id) REFERENCES TipoInforme(id) ON UPDATE CASCADE
);

-- Antecedentes
CREATE TABLE AntecedenteFamiliar (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL UNIQUE,
    descripcion TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);

CREATE TABLE AntecedentePersonal (
    id INT PRIMARY KEY AUTO_INCREMENT,
    paciente_id INT NOT NULL UNIQUE,
    tipo_sangre_id INT NOT NULL,
    descripcion TEXT,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE,
    FOREIGN KEY (tipo_sangre_id) REFERENCES TipoSangre(id) ON UPDATE CASCADE
);

CREATE TABLE AntecedenteObstetrico (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL UNIQUE,
    gesta INT,
    vag INT,
    cec INT,
    aborto INT,
    pmf VARCHAR(30),
    fpu VARCHAR(30),
    eqx VARCHAR(30),
    fur DATE,
    fpp DATE,
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);

CREATE TABLE AntecedenteGinecologico (
    id Int PRIMARY KEY AUTO_INCREMENT,
    paciente_id Int NOT NULL UNIQUE,
    menstruacion VARCHAR(20),
    menarquia INT,
    menopausia INT,
    primera_rs INT,
    cs INT,
    ao BOOLEAN,
    tiempo_ao VARCHAR(20),
    trh VARCHAR(20),
    diu VARCHAR(20),
    sinusorragia varchar(20),
    dispauremia VARCHAR(20),
    ultima_citologia VARCHAR(20),
    resultado_citologia VARCHAR(20),
    biopsia VARCHAR(20),
    FOREIGN KEY (paciente_id) REFERENCES Paciente(id) ON DELETE CASCADE
);