/*Siempre que se realice una nueva captura o un reanillado se registrara para poder tener un seguimiento del historico del colibri recapturado.*/
IF EXISTS (SELECT name FROM SYS.triggers where name = 'tg_colibri_agregar_registro_colibri') 
	DROP TRIGGER tg_colibri_agregar_registro_colibri

GO

CREATE TRIGGER  tg_colibri_agregar_registro_colibri  ON  captura_colibri
	FOR INSERT 
	 AS
	 BEGIN TRY
		DECLARE @estatus nvarchar(2)
		DECLARE @localidad int
		DECLARE @anillo_metal_primario nvarchar(10)
		DECLARE @anillo_metal_actual nvarchar(10)
		DECLARE @tamano_anillo nvarchar(2)
		DECLARE @idespecie int
		DECLARE @fecha datetime
		DECLARE @anillador nvarchar(10)

		select  @estatus = estatus, @localidad = localidad_asociada, @anillo_metal_actual = anillo_metal, @anillo_metal_primario = ra_anillo_metal,
		@tamano_anillo = tamano_anillo, @idespecie = idespecie, @fecha = fecha , @anillador = anillador  from inserted

		IF( @estatus ='N')
			BEGIN
				IF(select count (*) from registro_colibri where anillo_metal_actual = @anillo_metal_actual) = 0
					BEGIN
						INSERT INTO registro_colibri(localidad_asociada, anillo_metal_primario, anillo_metal_actual , tamano_anillo, idespecie, fecha , estatus, anillador)
						values (@localidad, @anillo_metal_actual, @anillo_metal_actual ,@tamano_anillo , @idespecie, @fecha , @estatus, @anillador)
					END
				ELSE
					BEGIN
						insert into registro_colibri(localidad_asociada, anillo_metal_primario, anillo_metal_actual , tamano_anillo, idespecie, fecha , estatus, anillador)
						values (@localidad, @anillo_metal_actual, @anillo_metal_actual ,@tamano_anillo , @idespecie, @fecha , 'R', @anillador)
					END
			END
		ELSE IF (@estatus = 'RA')
		BEGIN
			select @anillo_metal_primario = anillo_metal_primario from registro_colibri where anillo_metal_actual = @anillo_metal_primario
			
			INSERT INTO registro_colibri( localidad_asociada, anillo_metal_primario, anillo_metal_actual , tamano_anillo, idespecie, fecha , estatus, anillador)
			values (@localidad, @anillo_metal_primario, @anillo_metal_actual ,@tamano_anillo , @idespecie, @fecha , @estatus, @anillador)
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		THROW;
	END CATCH;
GO






 

 /*siempre que se modifique la especie de una captura, se buscara si anteriormente tiene un cambio de anillo (cedula) y se modificara la especie en todos el historial */
IF EXISTS ( SELECT name FROM SYS.triggers where name = 'tg_colibri_actualzar_especie_registro_colibri') 
	DROP TRIGGER  tg_colibri_actualzar_especie_registro_colibri
GO


 CREATE TRIGGER  tg_colibri_actualzar_especie_registro_colibri  ON  captura_colibri FOR update 
 AS 
		DECLARE @intErrorCode INT
		DECLARE @anillo_metal nvarchar(10)
		DECLARE @idespecie int

		select	@anillo_metal = anillo_metal, @idespecie = idespecie FROM inserted

		IF UPDATE(idespecie)
		BEGIN TRAN			

			DECLARE @anillo_metal_primario nvarchar(10)
			select @anillo_metal_primario = anillo_metal_primario from registro_colibri where anillo_metal_actual = @anillo_metal
		
			update registro_colibri set idespecie = @idespecie where anillo_metal_primario = @anillo_metal_primario 
			IF(@anillo_metal_primario != @anillo_metal)
			BEGIN		
				update captura_colibri set idespecie = @idespecie where anillo_metal in (select  anillo_metal_actual from registro_colibri where anillo_metal_primario = @anillo_metal_primario)
			END
			
			SELECT @intErrorCode = @@ERROR
			IF (@intErrorCode <> 0) GOTO PROBLEM
		COMMIT TRAN

		PROBLEM:
		IF (@intErrorCode <> 0) BEGIN
		PRINT 'error inesperado tg_colibri_actualzar_especie_registro_colibri'
			ROLLBACK TRAN
		END
 
 GO
 










