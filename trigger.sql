-- trigger.sql

-- Eliminar triggers existentes
DROP TRIGGER IF EXISTS tr_restar_stock;
DROP TRIGGER IF EXISTS tr_mensaje_leido;
DROP TRIGGER IF EXISTS after_solicitud_insert;

-- Cambiar delimitador para definición de triggers
DELIMITER //

CREATE TRIGGER tr_restar_stock
AFTER UPDATE ON solicitudes
FOR EACH ROW
BEGIN
    IF NEW.estado = 'aprobado' AND OLD.estado != 'aprobado' THEN
        UPDATE repuestos
           SET stock = stock - NEW.cantidad
         WHERE id = NEW.repuesto_id;

        INSERT INTO historial_stock (repuesto_id, cambio, motivo)
        VALUES (NEW.repuesto_id, -NEW.cantidad, 'Venta aprobada');
    END IF;
END//

CREATE TRIGGER tr_mensaje_leido
AFTER UPDATE ON mensajes
FOR EACH ROW
BEGIN
    IF NEW.leido = TRUE AND OLD.leido = FALSE THEN
        -- Aquí puede ir lógica adicional si se desea
    END IF;
END//

CREATE TRIGGER after_solicitud_insert
AFTER INSERT ON solicitudes
FOR EACH ROW
BEGIN
    DECLARE vendedor INT;
    SELECT vendedor_id
      INTO vendedor
      FROM repuestos
     WHERE id = NEW.repuesto_id;

    INSERT INTO mensajes (emisor_id, receptor_id, contenido)
    VALUES (
        NEW.comprador_id,
        vendedor,
        CONCAT('Nueva solicitud para el repuesto ID ', NEW.repuesto_id)
    );
END//

DELIMITER ;
