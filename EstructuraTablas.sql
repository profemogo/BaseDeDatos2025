CREATE TABLE  Paciente (
    id  INT AUTO_INCREMENT PRIMARY KEY,

  nombre VARCHAR(100)  NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    direccion VARCHAR(20) NOT NULL,
   cedula VARCHAR(20) UNIQUE,
    fecha_nacimiento DATE,
    genero ENUM('M', 'F', 'Otro'),
    telefono VARCHAR(20)
);

CREATE TABLE Especialidad (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL  
);

CREATE TABLE  Medico (
    id  INT AUTO_INCREMENT PRIMARY KEY,
    especialidad_id INT NOT NULL,

    numero_colegiatura VARCHAR(20) UNIQUE,
    nombre VARCHAR(100)  NOT NULL,
    apellido VARCHAR(100)  NOT NULL,
    telefono VARCHAR(20),
   cedula  VARCHAR (20) UNIQUE,
    
    FOREIGN KEY (especialidad_id) REFERENCES Especialidad(id)
);

CREATE TABLE Habitacion (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(10) UNIQUE NOT NULL,
    tipo ENUM('Privada', 'Compartida', 'UCI'),
    piso INT
);


CREATE TABLE Consulta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id INT,
    medico_id INT,
    fecha  DATETIME UNIQUE,
    motivo_consulta TEXT,
    FOREIGN KEY (paciente_id) REFERENCES  Paciente(id)
ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (medico_id) REFERENCES Medico(id)

    ON DELETE CASCADE
    ON UPDATE CASCADE

);
CREATE TABLE     HistorialConsulta (
id INT AUTO_INCREMENT PRIMARY KEY,
 paciente_id INT,
 fecha DATETIME UNIQUE , 
diagnostico_anterior  VARCHAR(90), 

diagnostico_nuevo  VARCHAR (90),
    FOREIGN KEY (paciente_id) REFERENCES  Paciente(id)
ON DELETE CASCADE
        ON UPDATE CASCADE
);











CREATE TABLE Ingreso (
    id INT AUTO_INCREMENT PRIMARY KEY,
    paciente_id  INT,
    habitacion_id INT,
    fecha_ingreso   DATETIME  UNIQUE,
    fecha_egreso  DATETIME  UNIQUE,
    diagnostico TEXT,
    FOREIGN KEY (paciente_id) REFERENCES  Paciente(id)

ON DELETE CASCADE
        ON UPDATE CASCADE,

    FOREIGN KEY (habitacion_id) REFERENCES  Habitacion(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE


);










CREATE TABLE Medicamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE,
    descripcion TEXT
);


CREATE TABLE Recipe (
    id INT AUTO_INCREMENT PRIMARY KEY,
    consulta_id   INT NOT NULL,
    fecha    DATETIME  UNIQUE,
    FOREIGN KEY (consulta_id) REFERENCES  Consulta(id)
    ON DELETE CASCADE
    ON UPDATE CASCADE

);


CREATE TABLE DescripcionReceta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    recipe_id INT,
    medicamento_id INT,
    dosis VARCHAR(50),
    frecuencia VARCHAR(50),
    FOREIGN KEY (recipe_id) 
        REFERENCES Recipe(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (medicamento_id) 
        REFERENCES Medicamento(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    UNIQUE (recipe_id, medicamento_id)
);

