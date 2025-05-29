
-- Función para calcular la edad
DELIMITER //
CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
END //
DELIMITER ;

-- Procedimiento para registrar informacion personal y clinica del paciente
DELIMITER //
CREATE PROCEDURE RegistrarPacienteCompleto(
    -- Datos básicos del paciente
    IN p_documento VARCHAR(50),
    IN p_tipo_documento INT,
    IN p_estado_civil INT,
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_fecha_nacimiento DATE,
    IN p_estudio VARCHAR(100),
    IN p_direccion VARCHAR(255),
    
    -- Datos de hábitos
    IN p_alcohol BOOLEAN,
    IN p_tabaco BOOLEAN,
    IN p_cafe BOOLEAN,
    
    -- Datos de examen físico
    IN p_examen_mama VARCHAR(100),
    IN p_colposcopia VARCHAR(100),
    
    -- Datos de antecedentes familiares
    IN p_antecedente_familiar TEXT,
    
    -- Datos de antecedentes personales
    IN p_tipo_sangre_id INT,
    IN p_antecedente_personal TEXT,
    
    -- Datos de antecedentes obstétricos
    IN p_gesta INT,
    IN p_vag INT,
    IN p_cec INT,
    IN p_aborto INT,
    IN p_fur DATE,
    IN p_fpp DATE,
    
    -- Datos de antecedentes ginecológicos
    IN p_menstruacion VARCHAR(20),
    IN p_menarquia INT,
    IN p_menopausia INT,
    IN p_ultima_citologia VARCHAR(20),
    IN p_resultado_citologia VARCHAR(20),
    
    -- Parámetro de salida
    OUT p_paciente_id INT
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    
    START TRANSACTION;
    
    -- Insertar datos básicos del paciente
    INSERT INTO Paciente (
        documento, tipo_documento_id, estado_civil_id, nombre, apellido,
        fecha_nacimiento, estudio, direccion
    ) VALUES (
        p_documento, p_tipo_documento, p_estado_civil, p_nombre, p_apellido,
        p_fecha_nacimiento, p_estudio, p_direccion
    );
    
    SET p_paciente_id = LAST_INSERT_ID();
    
    -- Insertar hábitos del paciente
    INSERT INTO Habito (
        paciente_id, alcohol, tabaco, cafe
    ) VALUES (
        p_paciente_id, p_alcohol, p_tabaco, p_cafe
    );
    
    -- Insertar examen físico
    INSERT INTO ExamenFisico (
        paciente_id, examen_mama, colposcopia
    ) VALUES (
        p_paciente_id, p_examen_mama, p_colposcopia
    );
    
    -- Insertar antecedente familiar
    INSERT INTO AntecedenteFamiliar (
        paciente_id, descripcion
    ) VALUES (
        p_paciente_id, p_antecedente_familiar
    );
    
    -- Insertar antecedente personal
    INSERT INTO AntecedentePersonal (
        paciente_id, tipo_sangre_id, descripcion
    ) VALUES (
        p_paciente_id, p_tipo_sangre_id, p_antecedente_personal
    );
    
    -- Insertar antecedente obstétrico
    INSERT INTO AntecedenteObstetrico (
        paciente_id, gesta, vag, cec, aborto, fur, fpp
    ) VALUES (
        p_paciente_id, p_gesta, p_vag, p_cec, p_aborto, p_fur, p_fpp
    );
    
    -- Insertar antecedente ginecológico
    INSERT INTO AntecedenteGinecologico (
        paciente_id, menstruacion, menarquia, menopausia, 
        ultima_citologia, resultado_citologia
    ) VALUES (
        p_paciente_id, p_menstruacion, p_menarquia, p_menopausia,
        p_ultima_citologia, p_resultado_citologia
    );
    
    COMMIT;
END //
DELIMITER ;

-- Procedimiento para agregar un teléfono a paciente
DELIMITER //
CREATE PROCEDURE AgregarTelefono(
    IN doc_paciente VARCHAR(50),
    IN num VARCHAR(15)
)
BEGIN
    DECLARE paciente_id INT;
    SELECT id INTO paciente_id FROM Paciente WHERE documento = doc_paciente LIMIT 1;
    
    IF paciente_id IS NULL THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'No se encontró un paciente con ese documento';
    ELSE
        INSERT INTO Telefono (paciente_id, numero) VALUES (paciente_id, num);
    END IF;
END //
DELIMITER ;
