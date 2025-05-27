-- Lorena Fernandez CI 28.440.154
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
--     Crear las Vistas de la base de datos
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


-- Vista de resumen de balance por usuario
CREATE VIEW BalanceGeneral AS
SELECT 
    u.id as usuario_id,
    u.nombre as usuario_nombre,
    COALESCE(SUM(CASE WHEN tt.nombre = 'Ingreso' THEN t.monto ELSE 0 END), 0) as total_ingresos,
    COALESCE(SUM(CASE WHEN tt.nombre = 'Gasto' THEN t.monto ELSE 0 END), 0) as total_gastos,
    COALESCE(SUM(CASE WHEN tt.nombre = 'Ingreso' THEN t.monto ELSE -t.monto END), 0) as balance_total
FROM Usuario u
LEFT JOIN Transaccion t ON u.id = t.usuario_id
LEFT JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
GROUP BY u.id, u.nombre;

-- Vista de gastos por categoría y usuario
CREATE VIEW GastosUsuario AS
SELECT 
    u.id as usuario_id,
    u.nombre as usuario_nombre,
    c.nombre as categoria_nombre,
    SUM(t.monto) as total_gasto,
    COUNT(t.id) as numero_transacciones,
    MAX(t.fecha) as ultima_transaccion
FROM Usuario u
JOIN Transaccion t ON u.id = t.usuario_id
JOIN Categoria c ON t.categoria_id = c.id
JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
WHERE tt.nombre = 'Gasto'
GROUP BY u.id, u.nombre, c.nombre;

-- Vista de progreso de metas
CREATE VIEW SeguimientoMetasFinancieras AS
SELECT 
    u.id as usuario_id,
    u.nombre as usuario_nombre,
    m.nombre as meta_nombre,
    m.monto_objetivo,
    m.progreso,
    m.fecha_objetivo,
    ROUND((m.progreso / m.monto_objetivo * 100), 2) as porcentaje_completado,
    CASE 
        WHEN m.fecha_objetivo < CURRENT_DATE THEN 'Vencida'
        WHEN m.progreso >= m.monto_objetivo THEN 'Completada'
        ELSE 'En progreso'
    END as estado
FROM Usuario u
JOIN Meta m ON u.id = m.usuario_id;

-- Vista de estado de presupuestos
CREATE VIEW SeguimientoPresupuestos AS
SELECT 
    u.id as usuario_id,
    u.nombre as usuario_nombre,
    c.nombre as categoria_nombre,
    p.monto_limite,
    p.periodo,
    COALESCE(SUM(t.monto), 0) as gasto_actual,
    p.monto_limite - COALESCE(SUM(t.monto), 0) as saldo_disponible,
    ROUND((COALESCE(SUM(t.monto), 0) / p.monto_limite * 100), 2) as porcentaje_usado
FROM Usuario u
JOIN Presupuesto p ON u.id = p.usuario_id
JOIN Categoria c ON p.categoria_id = c.id
LEFT JOIN Transaccion t ON 
    u.id = t.usuario_id AND 
    c.id = t.categoria_id AND
    t.tipo_transaccion_id = (SELECT id FROM TipoTransaccion WHERE nombre = 'Gasto')
GROUP BY u.id, u.nombre, c.nombre, p.monto_limite, p.periodo;

-- Vista de transacciones recientes con detalles
CREATE VIEW DetalleTransacciones AS
SELECT 
    t.id as transaccion_id,
    u.nombre as usuario_nombre,
    tt.nombre as tipo_transaccion,
    c.nombre as categoria,
    cb.banco,
    cb.numero_cuenta,
    t.monto,
    t.fecha,
    t.descripcion
FROM Transaccion t
JOIN Usuario u ON t.usuario_id = u.id
JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
JOIN Categoria c ON t.categoria_id = c.id
JOIN CuentaBancaria cb ON t.cuenta_bancaria_id = cb.id
ORDER BY t.fecha DESC;

-- Vista de resumen mensual
CREATE VIEW ResumenTransacciones AS
SELECT 
    u.id as usuario_id,
    u.nombre as usuario_nombre,
    DATE_FORMAT(t.fecha, '%Y-%m-01') as mes,
    tt.nombre as tipo_transaccion,
    SUM(t.monto) as monto_total,
    COUNT(t.id) as numero_transacciones,
    AVG(t.monto) as promedio_transaccion
FROM Usuario u
JOIN Transaccion t ON u.id = t.usuario_id
JOIN TipoTransaccion tt ON t.tipo_transaccion_id = tt.id
GROUP BY u.id, u.nombre, DATE_FORMAT(t.fecha, '%Y-%m-01'), tt.nombre
ORDER BY mes DESC;