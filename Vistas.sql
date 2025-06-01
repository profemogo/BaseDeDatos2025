CREATE VIEW VistaConsulta AS
SELECT 
  c.id AS consulta_id,
  CONCAT(p.nombre, ' ', p.apellido, ' ', p.cedula) AS paciente,
  CONCAT(m.nombre, ' ', m.apellido) AS medico,
  e.nombre AS especialidad,
  c.fecha,
  c.motivo_consulta
FROM Consulta c
JOIN Paciente p ON c.paciente_id = p.id
JOIN Medico m ON c.medico_id = m.id
JOIN Especialidad e ON m.especialidad_id = e.id;







CREATE VIEW VistaHospitalizacion AS
SELECT
    i.id AS ingreso_id,
    c.id AS consulta_id,
    CONCAT(p.nombre, ' ', p.apellido , ' ', p.cedula ) AS paciente,
    CONCAT(m.nombre, ' ', m.apellido) AS medico,
    h.numero AS habitacion,
    i.fecha_ingreso,
    i.diagnostico,
    c.fecha AS fecha_consulta,
    r.id AS receta_id,
    med.nombre AS medicamento,
    dr.dosis,
    dr.frecuencia
FROM Ingreso i
JOIN Paciente p ON i.paciente_id = p.id
JOIN Habitacion h ON i.habitacion_id = h.id
JOIN Consulta c ON c.paciente_id = p.id
JOIN Medico m ON c.medico_id = m.id
LEFT JOIN Recipe r ON r.consulta_id = c.id
LEFT JOIN DescripcionReceta dr ON dr.recipe_id = r.id
LEFT JOIN Medicamento med ON med.id = dr.medicamento_id;

