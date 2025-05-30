IF(select COUNT ( * ) from sys.views where name = 'vw_captura_colibri') > 0
	DROP view vw_captura_colibri
GO
CREATE VIEW vw_captura_colibri
	AS
	select captura_colibri.localidad_asociada, estatus, tamano_anillo, anillo_metal, ra_anillo_metal, idespecie, jornada_anillo, fecha, red, m_olt_limite, body_molt as id_body_molt,
	ff_molt as id_ff_molt, WRP as id_WRP, sexo as id_sexo, cor_pico as id_corpico, ala, pico_culmen, cola, peso, grasa as id_grasa, musculo as id_musculo,
	protuberancia_cloacal as id_protuberancia_cloacal, parche_reproductivo as id_parche_reproductivo, CONCAT(nombre, ' ', apellido) as anillador, primarias, nota
	from captura_colibri
	INNER JOIN usuario on anillador = acronimo 
GO


IF(select COUNT ( * ) from sys.views where name = 'vw_registro_colibri') > 0
	DROP view vw_registro_colibri
GO
CREATE VIEW vw_registro_colibri
	AS
	select registro_colibri.localidad_asociada, estatus, tamano_anillo, anillo_metal_primario, anillo_metal_actual, idespecie,  fecha, 	CONCAT(nombre, ' ', apellido) as anillador
	from registro_colibri
	INNER JOIN usuario on anillador = acronimo 
GO


IF(select COUNT ( * ) from sys.views where name = 'vw_usuario') > 0
	DROP view vw_usuario
GO
CREATE VIEW vw_usuario
	AS
	select CONCAT(A.nombre ,' ', A.apellido) as nombre_anillador, A.correo, A.telefono, A.procedencia_institucional, B.nombre  from usuario as A
	inner join centro_registro_localidad as B on B.id = A.localidad_asociada
GO


IF(select COUNT ( * ) from sys.views where name = 'vw_centro_registro_localidad') > 0
	DROP view vw_centro_registro_localidad
GO
CREATE VIEW vw_centro_registro_localidad
	AS
	select nombre, pais, estado, localidad, msnm, correo, telefono from centro_registro_localidad
GO

