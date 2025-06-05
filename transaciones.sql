USE repuestos_merida_db;

DROP PROCEDURE IF EXISTS finalizar_venta;
DELIMITER //
CREATE PROCEDURE finalizar_venta(IN solicitud_id INT)
BEGIN
    DECLARE cantidad_solicitada INT;
    DECLARE repuesto_id_val INT;
    DECLARE stock_actual INT;
    DECLARE comprador_id_val INT;
    DECLARE vendedor_id_val INT;

    SELECT repuesto_id, cantidad, comprador_id
      INTO repuesto_id_val, cantidad_solicitada, comprador_id_val
      FROM solicitudes
     WHERE id = solicitud_id
       AND estado = 'pendiente';

    SELECT stock, vendedor_id
      INTO stock_actual, vendedor_id_val
      FROM repuestos
     WHERE id = repuesto_id_val;

    IF stock_actual >= cantidad_solicitada THEN
        START TRANSACTION;

        UPDATE repuestos
           SET stock = stock_actual - cantidad_solicitada
         WHERE id = repuesto_id_val;

        UPDATE solicitudes
           SET estado = 'aprobado'
         WHERE id = solicitud_id;

        INSERT INTO mensajes (emisor_id, receptor_id, contenido)
        VALUES (
            comprador_id_val,
            vendedor_id_val,
            CONCAT('Solicitud ', solicitud_id, ' aprobada')
        );

        COMMIT;

        SELECT repuesto_id_val   AS repuesto_id,
               vendedor_id_val   AS vendedor_id,
               comprador_id_val  AS comprador_id;
    ELSE
        SIGNAL SQLSTATE '45000'
           SET MESSAGE_TEXT = 'Stock insuficiente para completar la venta.';
    END IF;
END//
DELIMITER ;
