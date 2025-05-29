-- Transacción para eliminar un paciente y todos sus registros relacionados
DELIMITER //
CREATE PROCEDURE EliminarPacienteCompleto(
    IN p_paciente_id INT,
    OUT p_resultado VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_resultado = 'Error al eliminar el paciente';
    END;
    
    START TRANSACTION;
    
    -- Eliminar paciente (esto activará las eliminaciones en cascada por las FK)
    DELETE FROM Paciente WHERE id = p_paciente_id;
    
    COMMIT;
    SET p_resultado = CONCAT('Paciente con ID ', p_paciente_id, ' eliminado correctamente');
END //
DELIMITER ;