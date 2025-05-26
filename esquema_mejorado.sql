-- Tabla 'genero'
CREATE TABLE Genero (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL
);

-- Tabla 'club'
CREATE TABLE Club (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL,
  direccion TEXT,
  telefono TEXT,
  email TEXT,
  pais TEXT,
  ciudad TEXT
);

-- Tabla 'CategoriaEdad'
CREATE TABLE CategoriaEdad (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL,
  edad_minima INT NOT NULL,
  edad_maxima INT NOT NULL
);

-- Tabla 'Nadadores'
CREATE TABLE Nadadores (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL,
  apellidos TEXT NOT NULL,
  fecha_nacimiento DATE NOT NULL,
  genero_id BIGINT,
  cedula TEXT NOT NULL,
  club_id BIGINT,
  email TEXT,
  telefono TEXT,
  categoria_edad_id BIGINT,
  FOREIGN KEY (genero_id) REFERENCES Genero(id),
  FOREIGN KEY (club_id) REFERENCES Club(id),
  FOREIGN KEY (categoria_edad_id) REFERENCES CategoriaEdad(id)
);

-- Tabla 'Entrenadores'
CREATE TABLE Entrenadores (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL,
  apellidos TEXT NOT NULL,
  cedula TEXT NOT NULL,
  club_id BIGINT,
  email TEXT,
  telefono TEXT,
  especialidad TEXT,
  certificado BOOLEAN DEFAULT FALSE,
  fecha_certificacion DATE,
  fecha_vencimiento DATE,
  FOREIGN KEY (club_id) REFERENCES Club(id)
);

-- Tabla 'EstilosNado'
CREATE TABLE EstilosNado (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL
);

-- Tabla 'Metrajes'
CREATE TABLE Metrajes (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  metros INT NOT NULL
);

-- Tabla 'EstiloMetraje'
CREATE TABLE EstiloMetraje (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  estilo_id BIGINT,
  metraje_id BIGINT,
  FOREIGN KEY (estilo_id) REFERENCES EstilosNado(id),
  FOREIGN KEY (metraje_id) REFERENCES Metrajes(id)
);

-- Tabla 'Competencias'
CREATE TABLE Competencias (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nombre TEXT NOT NULL,
  pais TEXT NOT NULL,
  estado TEXT NOT NULL,
  ciudad TEXT NOT NULL,
  club_id BIGINT,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  descripcion TEXT,
  tipo_competencia TEXT,
  FOREIGN KEY (club_id) REFERENCES Club(id)
);

-- Tabla 'Series'
CREATE TABLE Series (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  competencia_id BIGINT,
  estilo_metraje_id BIGINT,
  fecha_hora TIMESTAMP NOT NULL,
  numero_serie INT NOT NULL,
  categoria_edad_id BIGINT,
  genero_id BIGINT,
  num_carriles INT NOT NULL DEFAULT 8,
  FOREIGN KEY (competencia_id) REFERENCES Competencias(id),
  FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id),
  FOREIGN KEY (categoria_edad_id) REFERENCES CategoriaEdad(id),
  FOREIGN KEY (genero_id) REFERENCES Genero(id)
);

-- Tabla 'RegistroCompetencias'
CREATE TABLE RegistroCompetencias (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nadador_id BIGINT,
  competencia_id BIGINT,
  serie_id BIGINT,
  carril INT NOT NULL,
  estado ENUM('inscrito', 'confirmado', 'retirado', 'finalizado') DEFAULT 'inscrito',
  posicion_final INT,
  FOREIGN KEY (nadador_id) REFERENCES Nadadores(id),
  FOREIGN KEY (competencia_id) REFERENCES Competencias(id),
  FOREIGN KEY (serie_id) REFERENCES Series(id)
);

-- Tabla 'Tiempos'
CREATE TABLE Tiempos (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  registro_competencia_id BIGINT,
  estilo_metraje_id BIGINT,
  tiempo DECIMAL(10, 2) NOT NULL,
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  es_record BOOLEAN DEFAULT FALSE,
  tipo_record ENUM('personal', 'club', 'regional', 'nacional', 'mundial') NULL,
  observaciones TEXT,
  FOREIGN KEY (registro_competencia_id) REFERENCES RegistroCompetencias(id),
  FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id)
);

-- Tabla para registrar récords históricos
CREATE TABLE Records (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  nadador_id BIGINT,
  estilo_metraje_id BIGINT,
  tiempo DECIMAL(10, 2) NOT NULL,
  fecha DATE NOT NULL,
  competencia_id BIGINT,
  tipo_record ENUM('club', 'regional', 'nacional', 'mundial') NOT NULL,
  FOREIGN KEY (nadador_id) REFERENCES Nadadores(id),
  FOREIGN KEY (estilo_metraje_id) REFERENCES EstiloMetraje(id),
  FOREIGN KEY (competencia_id) REFERENCES Competencias(id)
); 