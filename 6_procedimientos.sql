/*
Procedimientos para ser utilizados en el back-end
exec sp_estadistica_talla_anillo_especie
exec sp_estadistica_talla_anillo_especie_por_sexo @sexo = 4
exec sp_estadistica_captura_colibri_historico
exec sp_estadistica_captura_colibri_historico_semestral @semestre = 0
exec sp_estadistica_captura_colibri_campana @idjornada = 0
exec sp_colibri_historico_individuo
exec sp_colibri_historico_individuo_detalle @anillo_metal = 'ME2508'
*/
/*estadistica, talla de anillo general*/
IF EXISTS ( select name from SYS.procedures where name = 'sp_estadistica_talla_anillo_especie') 
	DROP PROCEDURE sp_estadistica_talla_anillo_especie
GO
CREATE PROCEDURE sp_estadistica_talla_anillo_especie 
AS
	select   tamano_anillo, especie,  COUNT ( * ) as total  from captura_colibri inner join leyenda_especie on leyenda_especie.id = idespecie where (estatus ='N' or estatus = 'n' or estatus = 'RA' or estatus = 'ra')  group by tamano_anillo, especie order by especie, tamano_anillo
GO

/*estadistica, talla de anillo por sexo (los machos usan anillos mas grandes que las hembras)*/
IF EXISTS ( select NAME from SYS.procedures where name = 'sp_estadistica_talla_anillo_especie_por_sexo')
	DROP PROCEDURE sp_estadistica_talla_anillo_especie_por_sexo 
GO
	CREATE PROCEDURE sp_estadistica_talla_anillo_especie_por_sexo (@sexo int)
	AS
	IF ( @sexo = 2 or @sexo = 4)
	BEGIN
		select   tamano_anillo, especie,  COUNT ( * ) as total  from captura_colibri inner join leyenda_especie on leyenda_especie.id = idespecie where (sexo = 2 or sexo = 4) and (estatus ='N' or estatus = 'n' or estatus = 'RA' or estatus = 'ra')  group by tamano_anillo, especie order by especie, tamano_anillo
	END
	ELSE IF ( @sexo = 1 OR @sexo = 3 )
	BEGIN
		select   tamano_anillo, especie,  COUNT ( * ) as total  from captura_colibri inner join leyenda_especie on leyenda_especie.id = idespecie where (sexo = 1 or sexo = 3) and (estatus ='N' or estatus = 'n' or estatus = 'RA' or estatus = 'ra')  group by tamano_anillo, especie order by especie, tamano_anillo
	END
	ELSE
	BEGIN
			select   tamano_anillo, especie,  COUNT ( * ) as total  from captura_colibri inner join leyenda_especie on leyenda_especie.id = idespecie where sexo = 0 and (estatus ='N' or estatus = 'n' or estatus = 'RA' or estatus = 'ra')  group by tamano_anillo, especie order by especie, tamano_anillo
	END
GO



/*estadistica, capturas por especie (historico)*/
IF EXISTS(select name from SYS.procedures where name = 'sp_estadistica_captura_colibri_historico') 
	DROP PROCEDURE sp_estadistica_captura_colibri_historico
GO
	CREATE PROCEDURE sp_estadistica_captura_colibri_historico
	AS 
	DECLARE @total float
	select @total = COUNT(*) from captura_colibri
	select especie, COUNT(*) as total_n, COUNT(*)/@total as total_p, estatus from captura_colibri 
	inner join leyenda_especie ON idespecie= leyenda_especie.id group by especie, estatus order by especie
GO

/*estadistica, capturas por especie (historico semestral). Permite apresiar olas migratorias entre el primer y segundo semestre*/
IF EXISTS( select name from SYS.procedures where name = 'sp_estadistica_captura_colibri_historico_semestral') 
	DROP PROCEDURE sp_estadistica_captura_colibri_historico_semestral
GO
	CREATE PROCEDURE sp_estadistica_captura_colibri_historico_semestral(@semestre int)
	AS
	DECLARE @total float
	select @total = COUNT(*) from captura_colibri
	
	IF(@semestre = 1)
	BEGIN
		select especie, COUNT(*) as total_n, COUNT(*)/@total as total_p, estatus from captura_colibri 
		inner join leyenda_especie ON idespecie= leyenda_especie.id where MONTH(fecha) <=6 group by especie, estatus order by especie	
	END
	ELSE
	BEGIN
			select especie, COUNT(*) as total_n, COUNT(*)/@total as total_p, estatus from captura_colibri 
			inner join leyenda_especie ON idespecie= leyenda_especie.id where MONTH(fecha) >6 group by especie, estatus order by especie	

	END
GO

/*estadisticas, capturas por especie por jornada de anillamiento*/
IF EXISTS ( select name from SYS.procedures where name = 'sp_estadistica_captura_colibri_campana')
	DROP PROCEDURE sp_estadistica_captura_colibri_campana
GO
	CREATE PROCEDURE sp_estadistica_captura_colibri_campana (@idjornada int)
	AS 
	DECLARE @total float
	select @total = COUNT(*) from captura_colibri
	select especie, COUNT(*) as total_n, COUNT(*)/@total as total_p, estatus from captura_colibri 
	inner join leyenda_especie on idespecie= leyenda_especie.id where jornada_anillo = @idjornada group by especie, estatus order by especie
GO

/*agrupa todas las capturas por individuo, tomando en cuenta los RA */
IF EXISTS ( select name from SYS.procedures where name = 'sp_colibri_historico_individuo') 
	DROP PROCEDURE sp_colibri_historico_individuo
GO

CREATE PROCEDURE sp_colibri_historico_individuo
AS
	select A.anillo_metal_primario, MIN(A.fecha) as min_fecha, MAX(B.fecha) as max_fecha, COUNT(*) as num_capturas, C.especie as especie from registro_colibri as A 
	inner join captura_colibri as B on B.anillo_metal = A.anillo_metal_actual
	inner join leyenda_especie as C on B.idespecie = C.id
	group by A.anillo_metal_primario, C.especie
GO


/*muestra toda la informacion de las capturas realizadas para un individuo "anillo_metal", si en una anterior captura ser realizo un cambio de 
anillo, se retornara la lista del historial independientemente del anillo actual, es decir, si ese colibri se anillo una vez, y se reanillo 2 veces mas por el
deterioro del anillo, se retornara el historial conjunto de todos los anillos que el colibri uso.*/
IF EXISTS ( select name from SYS.procedures where name = 'sp_colibri_historico_individuo_detalle') 
	DROP PROCEDURE sp_colibri_historico_individuo_detalle
GO

CREATE PROCEDURE sp_colibri_historico_individuo_detalle(@anillo_metal nvarchar(10))
AS
	declare @anillo_metal_primario nvarchar(10) 

	select @anillo_metal_primario = anillo_metal_primario from registro_colibri where anillo_metal_actual = @anillo_metal

	select B.localidad_asociada, B.estatus, B.tamano_anillo, B.anillo_metal, B.fecha, B.m_olt_limite, B.ala, B.pico_culmen, B.cola, B.peso, B.anillador, B.primarias, B.nota,
	C.especie, D.body_molt, E.ff_molt, F.cor_pico,  G.sexo, H.grasa, I.musculo, J.parche_reproductivo, K.protuberancia_cloacal, CONCAT(U.nombre, ' ', U.apellido)
	from registro_colibri as A 
	inner join captura_colibri as B on B.anillo_metal = A.anillo_metal_actual
	inner join leyenda_especie as C on A.idespecie = C.id
	inner join leyenda_body_molt as D on B.body_molt = D.id
	inner join leyenda_ff_molt as E on  B.ff_molt = E.id
	inner join leyenda_cor_pico as F on B.cor_pico = F.id
	inner join leyenda_sexo as G on B.sexo = G.id
	inner join leyenda_grasa as H on B.grasa = H.id
	inner join leyenda_musculo as I on B.musculo = I.id
	inner join leyenda_parche_reproductivo as J on B.parche_reproductivo = J.id
	inner join leyenda_protuberancia_cloacal as K on B.protuberancia_cloacal = K.id
	inner join usuario as U on B.anillador = U.acronimo
	where A.anillo_metal_primario = @anillo_metal_primario
	
GO
