DELIMITER ;;

-- Al insertar una reserva se marca la mesa como Reservada
CREATE TRIGGER trg_reserva_after_insert
AFTER INSERT ON Reserva
FOR EACH ROW
BEGIN
    UPDATE Mesa
    SET estado = 'Reservada'
    WHERE id = NEW.mesa_id;
END;;
 
-- Al actualizar una reserva se actualiza el estado de mesa si cambia
CREATE TRIGGER trg_reserva_after_update
AFTER UPDATE ON Reserva
FOR EACH ROW
BEGIN
    -- Si cambió la mesa asignada
    IF OLD.mesa_id <> NEW.mesa_id THEN
        UPDATE Mesa SET estado = 'Disponible' WHERE id = OLD.mesa_id;
        UPDATE Mesa SET estado = 'Reservada' WHERE id = NEW.mesa_id;
    END IF;

    -- Si cambió el estado de la reserva
    IF OLD.estado <> NEW.estado THEN
        IF NEW.estado = 'confirmada' THEN
            UPDATE Mesa SET estado = 'Ocupada' WHERE id = NEW.mesa_id;
        ELSEIF NEW.estado = 'cancelada' THEN
            UPDATE Mesa SET estado = 'Disponible' WHERE id = NEW.mesa_id;
        ELSEIF NEW.estado = 'pendiente' THEN
            UPDATE Mesa SET estado = 'Reservada' WHERE id = NEW.mesa_id;
        END IF;
    END IF;
END;;
 
-- Al eliminar una reserva se libera la mesa, colocandola en disponible
CREATE TRIGGER trg_reserva_after_delete
AFTER DELETE ON Reserva
FOR EACH ROW
BEGIN
    UPDATE Mesa
    SET estado = 'Disponible'
    WHERE id = OLD.mesa_id;
END;;

DELIMITER ;
