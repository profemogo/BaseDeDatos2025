-- Función calcularEdad
DELIMITER @@@
CREATE FUNCTION CalcularEdad(fecha_nacimiento DATE) 
RETURNS INT
DETERMINISTIC
BEGIN
    RETURN TIMESTAMPDIFF(YEAR, fecha_nacimiento, CURDATE());
END @@@
DELIMITER ;

-- Función puedeAdoptar
DELIMITER @@@
CREATE FUNCTION PuedeAdoptar(persona_id INT) 
RETURNS BOOLEAN
READS SQL DATA
BEGIN
    DECLARE edad INT;
    SELECT calcularEdad(fecha_nacimiento) INTO edad FROM Persona WHERE id = persona_id;
    RETURN edad >= 18;
END @@@
DELIMITER ;

-- Función contarMascotasEspecie
DELIMITER @@@
CREATE FUNCTION ContarMascotasEspecie(especie_id INT) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE total INT;
    SELECT COUNT(*) INTO total FROM Mascota WHERE especie_id = especie_id;
    RETURN total;
END @@@
DELIMITER ;

-- Procedimiento registrarAdopcion
DELIMITER @@@
CREATE PROCEDURE RegistrarAdopcion(
    IN p_mascota_id INT,
    IN p_adoptante_id INT,
    OUT p_resultado VARCHAR(200))
BEGIN
    DECLARE v_puede_adoptar BOOLEAN;
    DECLARE v_existe_mascota BOOLEAN;
    DECLARE v_existe_adoptante BOOLEAN;
    
    -- Verificar si el adoptante existe
    SELECT COUNT(*) > 0 INTO v_existe_adoptante FROM Persona WHERE id = p_adoptante_id;
    
    -- Verificar si la mascota existe
    SELECT COUNT(*) > 0 INTO v_existe_mascota FROM Mascota WHERE id = p_mascota_id;
    
    -- Verificar si el adoptante es mayor de edad
    SELECT PuedeAdoptar(p_adoptante_id) INTO v_puede_adoptar;
    
    IF NOT v_existe_adoptante THEN
        SET p_resultado = CONCAT('Error: No existe el adoptante con ID ', p_adoptante_id);
    ELSEIF NOT v_existe_mascota THEN
        SET p_resultado = CONCAT('Error: No existe la mascota con ID ', p_mascota_id);
    ELSEIF NOT v_puede_adoptar THEN
        SET p_resultado = 'Error: El adoptante debe ser mayor de edad';
    ELSE
        INSERT INTO Adopcion (mascota_id, adoptante_id, fecha_adopcion)
        VALUES (p_mascota_id, p_adoptante_id, CURDATE());
        
        SET p_resultado = CONCAT('Éxito: Adopción registrada para mascota ', p_mascota_id, 
                               ' y adoptante ', p_adoptante_id);
    END IF;
END @@@
DELIMITER ;

-- Procedimiento obtenerInfoPersona
DELIMITER @@@
CREATE PROCEDURE ObtenerInfoPersona(IN p_persona_id INT)
BEGIN
    -- Datos básicos
    SELECT * FROM Persona WHERE id = p_persona_id;
    
    -- Contactos
    SELECT * FROM Correo WHERE persona_id = p_persona_id;
    SELECT * FROM Telefono WHERE persona_id = p_persona_id;
    SELECT * FROM Direccion WHERE persona_id = p_persona_id;
    
    -- Mascotas adoptadas
    SELECT m.* FROM Mascota m
    JOIN Adopcion a ON m.id = a.mascota_id
    WHERE a.adoptante_id = p_persona_id;
END @@@
DELIMITER ;