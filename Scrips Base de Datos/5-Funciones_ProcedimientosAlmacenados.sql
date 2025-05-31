DELIMITER $$

-- Calcula el total de reservas activas (pendientes o confirmadas) de un cliente
CREATE FUNCTION total_reservas_activas_cliente(
    p_cliente_id INT
) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM Reserva
        WHERE cliente_id = p_cliente_id
          AND estado IN ('pendiente', 'confirmada')
    );
END $$

-- Obtiene el estado de una mesa por su ID
CREATE FUNCTION obtener_estado_mesa(
    p_mesa_id INT
) RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE estado_actual VARCHAR(20);

    SELECT estado
    INTO estado_actual
    FROM Mesa
    WHERE id = p_mesa_id;

    RETURN estado_actual;
END $$

-- Calcula el total de pedidos asociados a una reserva
CREATE FUNCTION total_pedidos_por_reserva(
    p_reserva_id INT
) RETURNS INT
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COUNT(*)
        FROM ReservaPedido
        WHERE reserva_id = p_reserva_id
    );
END $$

-- Retorna el monto total de una reserva sumando todos los pedidos asociados
CREATE FUNCTION total_monto_reserva(
    p_reserva_id INT
) RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN (
        SELECT COALESCE(SUM(p.total_pedido), 0)
        FROM Pedido p
        JOIN ReservaPedido rp ON p.id = rp.pedido_id
        WHERE rp.reserva_id = p_reserva_id
    );
END $$



CREATE PROCEDURE obtener_mesas_disponibles (
    IN p_fecha DATETIME,
    IN p_numero_personas INT
)
BEGIN
    /*
    Devuelve todas las mesas que:
    - tengan capacidad suficiente para la cantidad de personas
    - estén disponibles o no tengan una reserva activa para esa fecha
    */

    SELECT m.id,
           m.nombre,
           m.capacidad,
           m.ubicacion,
           m.estado
    FROM Mesa m
    WHERE m.capacidad >= p_numero_personas
      AND m.estado = 'Disponible'
      AND NOT EXISTS (
          SELECT 1
          FROM Reserva r
          WHERE r.mesa_id = m.id
            AND DATE(r.fecha_reserva) = DATE(p_fecha)
            AND r.estado IN ('pendiente', 'confirmada')
      )
    ORDER BY m.capacidad ASC;
END $$

DELIMITER ;