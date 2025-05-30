BEGIN	
/*creacerio de claves foraneas*/

/*taba usuario*/
/*FK_usuario_permiso para ser usados en el front-end*/
IF EXISTS (select name from sys.foreign_keys where name = 'FK_usuario_permiso') 
	ALTER TABLE usuario  DROP CONSTRAINT FK_usuario_permiso
	
ALTER TABLE usuario ADD CONSTRAINT FK_usuario_permiso FOREIGN KEY (permiso) REFERENCES permiso_configuracion(id);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_usuario_localidad_asociada') 
	ALTER TABLE usuario  DROP CONSTRAINT FK_usuario_localidad_asociada
	
ALTER TABLE usuario ADD CONSTRAINT FK_usuario_localidad_asociada FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);
	


/*tabla sesion_captura*/
IF EXISTS (select name from sys.foreign_keys where name = 'FK_sesion_captura_localidad') 
	ALTER TABLE sesion_captura  DROP CONSTRAINT FK_sesion_captura_localidad
	
ALTER TABLE sesion_captura ADD CONSTRAINT FK_sesion_captura_localidad FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_sesion_captura_anillador') 
	ALTER TABLE sesion_captura  DROP CONSTRAINT FK_sesion_captura_anillador
				
ALTER TABLE sesion_captura ADD CONSTRAINT FK_sesion_captura_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	 


/*tabla registro_colibri*/
IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_idespecie') 
	ALTER TABLE registro_colibri  DROP CONSTRAINT FK_registro_colibri_idespecie

ALTER TABLE registro_colibri ADD CONSTRAINT FK_registro_colibri_idespecie FOREIGN KEY (idespecie) REFERENCES leyenda_especie(id);
	 

IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_anillador')
	ALTER TABLE registro_colibri  DROP CONSTRAINT FK_registro_colibri_anillador
		
ALTER TABLE registro_colibri ADD CONSTRAINT FK_registro_colibri_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_estatus') 
	ALTER TABLE registro_colibri  DROP CONSTRAINT FK_registro_colibri_estatus

ALTER TABLE registro_colibri ADD CONSTRAINT FK_registro_colibri_estatus FOREIGN KEY (estatus) REFERENCES leyenda_estatus(estatus);
	




/*tabla captura_colibri*/
IF EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_localidad') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_captura_colibri_localidad
		
ALTER TABLE captura_colibri ADD CONSTRAINT FK_captura_colibri_localidad FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_estatus') 	
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_captura_colibri_estatus

ALTER TABLE captura_colibri ADD CONSTRAINT FK_captura_colibri_estatus FOREIGN KEY (estatus) REFERENCES leyenda_estatus(estatus);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_idespecie') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_captura_colibri_idespecie
	
ALTER TABLE captura_colibri ADD CONSTRAINT FK_captura_colibri_idespecie FOREIGN KEY (jornada_Anillo) REFERENCES sesion_captura(id);
	 

IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_body_molt') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_body_molt

Alter Table captura_colibri ADD CONSTRAINT FK_registro_colibri_body_molt FOREIGN KEY (body_molt) REFERENCES leyenda_body_molt(id);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_ff_molt') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_ff_molt
		
ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_ff_molt FOREIGN KEY (ff_molt) REFERENCES leyenda_ff_molt(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_WRP') 	
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_WRP

ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_WRP FOREIGN KEY (WRP) REFERENCES leyenda_wrp(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_sexo')
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_sexo
		
ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_sexo FOREIGN KEY (sexo) REFERENCES leyenda_wrp(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_cor_pico') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_cor_pico
		
ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_cor_pico FOREIGN KEY (cor_pico) REFERENCES leyenda_cor_pico(id);
	 
	 
IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_grasa') 	
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_grasa

ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_grasa FOREIGN KEY (grasa) REFERENCES leyenda_grasa(id);
	

IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_musculo') 
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_musculo
			
ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_musculo  FOREIGN KEY (musculo) REFERENCES leyenda_musculo(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_protuberancia_cloacal') 		
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_protuberancia_cloacal

ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_protuberancia_cloacal FOREIGN KEY (protuberancia_cloacal) REFERENCES leyenda_protuberancia_cloacal(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_parche_reproductivo') 		
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_registro_colibri_parche_reproductivo

ALTER TABLE captura_colibri ADD CONSTRAINT FK_registro_colibri_parche_reproductivo FOREIGN KEY (parche_reproductivo) REFERENCES leyenda_parche_reproductivo(id);


IF EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_anillador') 	
	ALTER TABLE captura_colibri  DROP CONSTRAINT FK_captura_colibri_anillador

ALTER TABLE captura_colibri ADD CONSTRAINT FK_captura_colibri_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	 

	
END