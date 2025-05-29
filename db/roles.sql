
-- Creación de roles
CREATE ROLE IF NOT EXISTS 'rol_consulta_vistas';
CREATE ROLE IF NOT EXISTS 'rol_edicion_datos';

-- Permisos para el rol de consulta de vistas
GRANT SELECT ON HistoriasMedicas.VistaPacienteBasico TO 'rol_consulta_vistas';
GRANT SELECT ON HistoriasMedicas.VistaPacienteCompleto TO 'rol_consulta_vistas';
GRANT SELECT ON HistoriasMedicas.VistaControlInforme TO 'rol_consulta_vistas';

-- Permisos para el rol de edición de datos
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.Paciente TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.Telefono TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.Habito TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.ExamenFisico TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.Control TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.Informe TO 'rol_edicion_datos';

-- Tablas de antecedentes
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.AntecedenteFamiliar TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.AntecedentePersonal TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.AntecedenteObstetrico TO 'rol_edicion_datos';
GRANT SELECT, INSERT, UPDATE ON HistoriasMedicas.AntecedenteGinecologico TO 'rol_edicion_datos';

-- Permisos para tablas de referencia
GRANT SELECT ON HistoriasMedicas.TipoDocumento TO 'rol_edicion_datos';
GRANT SELECT ON HistoriasMedicas.EstadoCivil TO 'rol_edicion_datos';
GRANT SELECT ON HistoriasMedicas.TipoSangre TO 'rol_edicion_datos';
GRANT SELECT ON HistoriasMedicas.TipoInforme TO 'rol_edicion_datos';

FLUSH PRIVILEGES;