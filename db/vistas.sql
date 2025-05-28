
-- Vista de informacion basica de paciente 
CREATE VIEW VistaPacienteBasico AS
SELECT 
    p.documento,
    td.abreviatura AS tipo_doc,
    p.nombre,
    p.apellido,
    p.fecha_nacimiento,
    TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad,
    ec.descripcion AS estado_civil,
    GROUP_CONCAT(t.numero SEPARATOR ', ') AS telefonos,
    p.direccion
FROM 
    Paciente p
JOIN 
    TipoDocumento td ON p.tipo_documento_id = td.id
JOIN 
    EstadoCivil ec ON p.estado_civil_id = ec.id
LEFT JOIN 
    Telefono t ON p.id = t.paciente_id
GROUP BY 
    p.id;

-- Vista de información clinica del paciente
CREATE VIEW VistaPacienteCompleto AS
SELECT 
    p.nombre,
    p.apellido,
    p.documento AS cedula,
    TIMESTAMPDIFF(YEAR, p.fecha_nacimiento, CURDATE()) AS edad,
    ec.descripcion AS estado_civil,
    p.estudio AS profesion_ocupacion,
    p.direccion,
    GROUP_CONCAT(DISTINCT t.numero SEPARATOR ', ') AS telefonos,
    
    -- Hábitos del paciente
    CASE 
        WHEN h.alcohol = 1 THEN 'Sí' 
        WHEN h.alcohol = 0 THEN 'No' 
        ELSE 'No registrado' 
    END AS consume_alcohol,
    CASE 
        WHEN h.tabaco = 1 THEN 'Sí' 
        WHEN h.tabaco = 0 THEN 'No' 
        ELSE 'No registrado' 
    END AS consume_tabaco,
    CASE 
        WHEN h.cafe = 1 THEN 'Sí' 
        WHEN h.cafe = 0 THEN 'No' 
        ELSE 'No registrado' 
    END AS consume_cafe,
    
    -- Examen físico
    ef.examen_mama AS examen_mamas,
    ef.colposcopia,
    
    -- Antecedente Familiar
    af.descripcion AS antecedentes_familiares,
    
    -- Antecedente Personal
    CONCAT(ts.descripcion, IF(ts.factor = 1, '+', '-')) AS grupo_sanguineo,
    ap.descripcion AS antecedentes_personales,
    
    -- Antecedente Obstétrico
    ao.gesta AS embarazos,
    ao.vag AS partos_vaginales,
    ao.cec AS cesareas,
    ao.aborto AS abortos,
    DATE_FORMAT(ao.fur, '%d/%m/%Y') AS ultima_menstruacion,
    DATE_FORMAT(ao.fpp, '%d/%m/%Y') AS fecha_probable_parto,
    
    -- Antecedente Ginecológico
    ag.menstruacion AS ciclo_menstrual,
    ag.menarquia AS edad_menarquia,
    ag.menopausia AS edad_menopausia,
    ag.ultima_citologia AS fecha_ultima_citologia,
    ag.resultado_citologia AS resultado_citologia
    
FROM 
    Paciente p
LEFT JOIN 
    EstadoCivil ec ON p.estado_civil_id = ec.id
LEFT JOIN 
    Telefono t ON p.id = t.paciente_id
LEFT JOIN 
    Habito h ON p.id = h.paciente_id
LEFT JOIN 
    ExamenFisico ef ON p.id = ef.paciente_id
LEFT JOIN 
    AntecedenteFamiliar af ON p.id = af.paciente_id
LEFT JOIN 
    AntecedentePersonal ap ON p.id = ap.paciente_id
LEFT JOIN 
    TipoSangre ts ON ap.tipo_sangre_id = ts.id
LEFT JOIN 
    AntecedenteObstetrico ao ON p.id = ao.paciente_id
LEFT JOIN 
    AntecedenteGinecologico ag ON p.id = ag.paciente_id
GROUP BY 
    p.id;


-- Vista de información de los Controles e informes de un paciente
CREATE VIEW VistaControlInforme AS
WITH ControlesNumerados AS (
    SELECT 
        c.*,
        p.nombre,
        p.apellido,
        p.documento,
        DENSE_RANK() OVER(PARTITION BY p.id ORDER BY c.fecha) AS numero_control
    FROM 
        Control c
    JOIN 
        Paciente p ON c.paciente_id = p.id
)
SELECT 
    cn.nombre,
    cn.apellido,
    cn.documento AS cedula,
    cn.numero_control,
    DATE_FORMAT(cn.fecha, '%d/%m/%Y') AS fecha_control,
    CONCAT(cn.peso, ' kg') AS peso,
    CONCAT(cn.talla, ' m') AS talla,
    cn.tension_arterial,
    cn.frecuencia_cardiaca AS frecuencia_cardiaca_bpm,
    cn.observaciones AS observaciones_control,
    ti.codigo AS codigo_informe,
    ti.descripcion AS tipo_informe,
    i.conclusion
FROM 
    ControlesNumerados cn
LEFT JOIN 
    Informe i ON cn.id = i.control_id
LEFT JOIN 
    TipoInforme ti ON i.tipo_informe_id = ti.id
ORDER BY 
    cn.apellido, cn.nombre, cn.fecha DESC, cn.numero_control, ti.codigo;