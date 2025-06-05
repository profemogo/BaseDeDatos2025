USE repuestos_merida_db;

DROP PROCEDURE IF EXISTS proc_obtener_stock;
DELIMITER //
CREATE PROCEDURE proc_obtener_stock(IN rep_id INT, OUT stock_actual INT)
BEGIN
    SELECT stock INTO stock_actual
    FROM repuestos
    WHERE id = rep_id;
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS proc_crear_solicitud;
DELIMITER //
CREATE PROCEDURE proc_crear_solicitud(IN comp_id INT, IN rep_id INT, IN cantidad INT)
BEGIN
    INSERT INTO solicitudes (comprador_id, repuesto_id, cantidad, estado)
    VALUES (comp_id, rep_id, cantidad, 'pendiente');
END//
DELIMITER ;
