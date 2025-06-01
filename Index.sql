CREATE INDEX idx_habitacion ON Habitacion(numero);

CREATE  INDEX idx_cedula ON Paciente(cedula);
DROP INDEX idx_cedula_unica ON Paciente;


SELECT * FROM VistaHospitalizacion  WHERE habitacion = '101';



SELECT * FROM Paciente WHERE cedula  =   'V -12345';

