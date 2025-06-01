DELIMITER //

CREATE PROCEDURE InsertarPaciente (
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_direccion VARCHAR(20),
    IN p_cedula VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('M', 'F', 'Otro'),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO Paciente(nombre, apellido, direccion, cedula, fecha_nacimiento, genero, telefono)
    VALUES(p_nombre, p_apellido, p_direccion, p_cedula, p_fecha_nacimiento, p_genero, p_telefono);
END //

DELIMITER ;



DELIMITER //

CREATE PROCEDURE InsertarData (
    -- Paciente
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_direccion VARCHAR(20),
    IN p_cedula VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('M', 'F', 'Otro'),
    IN p_telefono VARCHAR(20),

    -- Especialidad
    IN e_nombre VARCHAR(100),

    -- Habitacion
    IN h_numero VARCHAR(10),
    IN h_tipo ENUM('Privada', 'Compartida', 'UCI'),
    IN h_piso INT,

    -- Medicamento
    IN m_nombre VARCHAR(100),
    IN m_descripcion TEXT
)
BEGIN
    -- Insertar en Paciente
    INSERT INTO Paciente (nombre, apellido, direccion, cedula, fecha_nacimiento, genero, telefono)
    VALUES (p_nombre, p_apellido, p_direccion, p_cedula, p_fecha_nacimiento, p_genero, p_telefono);

    -- Insertar en Especialidad (si no existe)
    INSERT IGNORE INTO Especialidad (nombre)
    VALUES (e_nombre);

    -- Insertar en Habitacion
    INSERT INTO Habitacion (numero, tipo, piso)
    VALUES (h_numero, h_tipo, h_piso);

    -- Insertar en Medicamento (si no existe)
    INSERT IGNORE INTO Medicamento (nombre, descripcion)
    VALUES (m_nombre, m_descripcion);
END //

DELIMITER ;

CALL InsertarData(
    'Ana', 'Martínez', 'Calle 8', '0011223344', '1990-05-20', 'F', '1234567890',
    'Pediatría',
    '202', 'Privada', 3,
    'Paracetamol', 'Analgésico y antipirético común'
);





DELIMITER //

CREATE PROCEDURE VerDatos()
BEGIN
    -- Ver pacientes
    SELECT * FROM Paciente;

    -- Ver especialidades
    SELECT * FROM Especialidad;

    -- Ver médicos
    SELECT * FROM Medico;

    -- Ver habitaciones
    SELECT * FROM Habitacion;

    -- Ver consultas
    SELECT * FROM Consulta;

    -- Ver historial de consultas
    SELECT * FROM HistorialConsulta;

    -- Ver ingresos
    SELECT * FROM Ingreso;

    -- Ver medicamentos
    SELECT * FROM Medicamento;

    -- Ver recetas
    SELECT * FROM Recipe;

    -- Ver descripción de recetas
    SELECT * FROM DescripcionReceta;
END //

DELIMITER ;

CALL VerDatos();




DELIMITER //

CREATE PROCEDURE BorrarDatos()
BEGIN
    -- Desactiva validación de claves foráneas
    SET FOREIGN_KEY_CHECKS = 0;

    -- Borra datos en orden correcto
    DELETE FROM DescripcionReceta;
    DELETE FROM Recipe;
    DELETE FROM Consulta;
    DELETE FROM HistorialConsulta;
    DELETE FROM Ingreso;
    DELETE FROM Medico;
    DELETE FROM Especialidad;
    DELETE FROM Habitacion;
    DELETE FROM Medicamento;
    DELETE FROM Paciente;

    -- Reactiva validación de claves foráneas
    SET FOREIGN_KEY_CHECKS = 1;
END;
//

DELIMITER ;




DELIMITER //
CREATE PROCEDURE InsertarPaciente(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_direccion VARCHAR(20),
    IN p_cedula VARCHAR(20),
    IN p_fecha_nacimiento DATE,
    IN p_genero ENUM('M', 'F', 'Otro'),
    IN p_telefono VARCHAR(20)
)
BEGIN
    INSERT INTO Paciente(nombre, apellido, direccion, cedula, fecha_nacimiento, genero, telefono)
    VALUES (p_nombre, p_apellido, p_direccion, p_cedula, p_fecha_nacimiento, p_genero, p_telefono);
END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE InsertarEspecialidad(
    IN p_nombre VARCHAR(100)
)
BEGIN
    INSERT INTO Especialidad(nombre)
    VALUES (p_nombre);
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE InsertarMedico(
    IN p_especialidad_id INT,
    IN p_numero_colegiatura VARCHAR(20),
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_telefono VARCHAR(20),
    IN p_cedula VARCHAR(20)
)
BEGIN
    INSERT INTO Medico(especialidad_id, numero_colegiatura, nombre, apellido, telefono, cedula)
    VALUES (p_especialidad_id, p_numero_colegiatura, p_nombre, p_apellido, p_telefono, p_cedula);
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE InsertarHabitacion(
    IN p_numero VARCHAR(10),
    IN p_tipo ENUM('Privada', 'Compartida', 'UCI'),
    IN p_piso INT
)
BEGIN
    INSERT INTO Habitacion(numero, tipo, piso)
    VALUES (p_numero, p_tipo, p_piso);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertarConsulta(
    IN p_paciente_id INT,
    IN p_medico_id INT,
    IN p_fecha DATETIME,
    IN p_motivo_consulta TEXT
)
BEGIN
    INSERT INTO Consulta(paciente_id, medico_id, fecha, motivo_consulta)
    VALUES (p_paciente_id, p_medico_id, p_fecha, p_motivo_consulta);
END //
DELIMITER ;






DELIMITER //
CREATE PROCEDURE InsertarHistorialConsulta(
    IN p_paciente_id INT,
    IN p_fecha DATETIME,
    IN p_diagnostico_anterior VARCHAR(90),
    IN p_diagnostico_nuevo VARCHAR(90)
)
BEGIN
    INSERT INTO HistorialConsulta(paciente_id, fecha, diagnostico_anterior, diagnostico_nuevo)
    VALUES (p_paciente_id, p_fecha, p_diagnostico_anterior, p_diagnostico_nuevo);
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE InsertarIngreso(
    IN p_paciente_id INT,
    IN p_habitacion_id INT,
    IN p_fecha_ingreso DATETIME,
    IN p_fecha_egreso DATETIME,
    IN p_diagnostico TEXT
)
BEGIN
    INSERT INTO Ingreso(paciente_id, habitacion_id, fecha_ingreso, fecha_egreso, diagnostico)
    VALUES (p_paciente_id, p_habitacion_id, p_fecha_ingreso, p_fecha_egreso, p_diagnostico);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE InsertarMedicamento(
    IN p_nombre VARCHAR(100),
    IN p_descripcion TEXT
)
BEGIN
    INSERT INTO Medicamento(nombre, descripcion)
    VALUES (p_nombre, p_descripcion);
END //
DELIMITER ;



DELIMITER //
CREATE PROCEDURE InsertarReceta(
    IN p_consulta_id INT,
    IN p_fecha DATETIME
)
BEGIN
    INSERT INTO Recipe(consulta_id, fecha)
    VALUES (p_consulta_id, p_fecha);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE InsertarDescripcionReceta(
    IN p_recipe_id INT,
    IN p_medicamento_id INT,
    IN p_dosis VARCHAR(50),
    IN p_frecuencia VARCHAR(50)
)
BEGIN
    INSERT INTO DescripcionReceta(recipe_id, medicamento_id, dosis, frecuencia)
    VALUES (p_recipe_id, p_medicamento_id, p_dosis, p_frecuencia);
END //
DELIMITER ;





DELIMITER //
CREATE PROCEDURE VerDatosTablas()
BEGIN
    SELECT * FROM Paciente;
    SELECT * FROM Medico;
    SELECT * FROM Especialidad;
    SELECT * FROM Medicamento;
    SELECT * FROM Consulta;
    SELECT * FROM DescripcionReceta;
    SELECT * FROM Habitacion;
    SELECT * FROM HistorialConsulta;
    SELECT * FROM Ingreso;
    SELECT * FROM Recipe;
    SELECT * FROM VistaConsulta;
    SELECT * FROM VistaHospitalizacion;
END //
DELIMITER ;



CALL VerDatosTablas();



