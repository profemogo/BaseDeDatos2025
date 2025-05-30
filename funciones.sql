-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear Funciones de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@



-- Función para obtener el saldo actual de un usuario
DELIMITER $$
CREATE FUNCTION ObtenerSaldoUsuario(uid INT) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE saldo DECIMAL(12,2);
    SELECT 
        COALESCE(SUM(CASE WHEN tt.nombre = 'Ingreso' THEN t.monto ELSE -t.monto END), 0)
    INTO saldo
    FROM Transaccion t
    JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
    WHERE t.usuario_id = uid;
    RETURN saldo;
END $$
DELIMITER ;

-- Función: Total de gastos de un usuario en un periodo
DELIMITER $$
    CREATE FUNCTION TotalGastosUsuarioPeriodo(
    p_usuario_id INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT COALESCE(SUM(t.monto),0) INTO total
    FROM Transaccion t
    JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
    WHERE t.usuario_id = p_usuario_id
      AND tt.nombre = 'Gasto'
      AND DATE(t.fecha) BETWEEN p_fecha_inicio AND p_fecha_fin;
    RETURN total;
END $$
DELIMITER ;

-- Función: Total de ingresos de un usuario en un periodo
DELIMITER $$
CREATE FUNCTION TotalIngresosUsuarioPeriodo(
    p_usuario_id INT,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
) RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(12,2);
    SELECT COALESCE(SUM(t.monto),0) INTO total
    FROM Transaccion t
    JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
    WHERE t.usuario_id = p_usuario_id
      AND tt.nombre = 'Ingreso'
      AND DATE(t.fecha) BETWEEN p_fecha_inicio AND p_fecha_fin;
    RETURN total;
END $$
DELIMITER ;

-- Función: Porcentaje de avance de una meta financiera

DELIMITER $$

CREATE FUNCTION PorcentajeAvanceMeta(p_meta_id INT) 
RETURNS DECIMAL(5,2)
DETERMINISTIC
BEGIN
    DECLARE avance DECIMAL(5,2);
    DECLARE objetivo_val DECIMAL(12,2);
    DECLARE progreso_val DECIMAL(12,2);

    SELECT monto_objetivo, progreso 
    INTO objetivo_val, progreso_val
    FROM Meta 
    WHERE id = p_meta_id
    LIMIT 1;

    IF objetivo_val > 0 THEN
        SET avance = ROUND((progreso_val / objetivo_val) * 100, 2);
    ELSE
        SET avance = 0;
    END IF;

    RETURN avance;
END$$

DELIMITER ;


-- Función: Cantidad de transacciones de un usuario en un mes específico
DELIMITER $$
CREATE FUNCTION CantidadTransaccionesMes(
    p_usuario_id INT,
    p_anio INT,
    p_mes INT
) RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE cantidad INT;
    SELECT COUNT(*) INTO cantidad
    FROM Transaccion
    WHERE usuario_id = p_usuario_id
      AND YEAR(fecha) = p_anio
      AND MONTH(fecha) = p_mes;
    RETURN cantidad;
END $$
DELIMITER ;
