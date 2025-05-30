BEGIN	
--Para la tabla capturas_colibri, crearemos indices en las columnas des idespecie, anillo_metal, estatus, jornada_anillo y anillador
 IF EXISTS (select name from sys.indexes where name = 'i_captura_colibri_anillo_metal') 
	DROP INDEX i_captura_colibri_anillo_metal ON captura_colibri

CREATE NONCLUSTERED  INDEX i_captura_colibri_anillo_metal
		ON captura_colibri(anillo_metal)


IF EXISTS (select name from sysindexes where name = 'i_captura_colibri_estatus') 
	DROP INDEX i_captura_colibri_estatus ON captura_colibri

CREATE NONCLUSTERED  INDEX i_captura_colibri_estatus
		ON captura_colibri(estatus)


IF EXISTS (select name from sysindexes where name = 'i_captura_colibri_idespecie') 
	DROP INDEX i_captura_colibri_idespecie ON captura_colibri

CREATE NONCLUSTERED  INDEX i_captura_colibri_idespecie
		ON captura_colibri(idespecie)
	

IF EXISTS (select name from sysindexes where name = 'i_captura_colibri_jornada_anillo') 
	DROP INDEX i_captura_colibri_jornada_anillo ON captura_colibri

CREATE NONCLUSTERED  INDEX i_captura_colibri_jornada_anillo
		ON captura_colibri(jornada_anillo)
	 

 IF EXISTS (select name from sysindexes where name = 'i_captura_colibri_anillador') 
	DROP INDEX i_captura_colibri_anillador ON captura_colibri

CREATE NONCLUSTERED  INDEX i_captura_colibri_anillador
		ON captura_colibri(anillador)
	 

/*creamos los indices para la tabla registro colibri, nos ayudaran en el proceso de los inner join y group by usados en multiples consultas.*/
IF EXISTS (select name from sysindexes where name = 'i_registro_colibri_anillo_metal_primario')
	DROP INDEX i_registro_colibri_anillo_metal_primario ON registro_colibri
	
CREATE NONCLUSTERED  INDEX i_registro_colibri_anillo_metal_primario
		ON registro_colibri(anillo_metal_primario)

IF EXISTS (select name from sysindexes where name = 'i_registro_colibri_estatus') 
	DROP INDEX i_registro_colibri_estatus ON registro_colibri
	
CREATE NONCLUSTERED  INDEX i_registro_colibri_estatus
		ON registro_colibri(estatus)
		



END