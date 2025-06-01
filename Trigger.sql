DELIMITER $$

CREATE TRIGGER   ActualHistorialConsulta
AFTER INSERT ON Consulta
FOR EACH ROW
BEGIN
    DECLARE diagnostico_ant VARCHAR(90);

    SELECT diagnostico_nuevo INTO diagnostico_ant
    FROM HistorialConsulta
    WHERE paciente_id = NEW.paciente_id
    ORDER BY fecha DESC
    LIMIT 1;

    INSERT INTO HistorialConsulta (paciente_id, fecha, diagnostico_anterior, diagnostico_nuevo)
    VALUES (NEW.paciente_id, NEW.fecha, diagnostico_ant, NEW.motivo_consulta);
END $$

DELIMITER ;

