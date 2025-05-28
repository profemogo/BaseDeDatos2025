BEGIN	
/*creacerio de claves foraneas*/

/*taba usuario*/

/*FK_usuario_permiso para ser usados en el front-end*/
IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_usuario_permiso')
	begin	
		Alter Table usuario 
		Add CONSTRAINT FK_usuario_permiso FOREIGN KEY (permiso) REFERENCES permiso_configuracion(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_usuario_permiso  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_usuario_localidad_asociada')
	begin	
		Alter Table usuario 
		Add CONSTRAINT FK_usuario_localidad_asociada FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_usuario_localidad_asociada  --   ')
	 end


/*tabla sesion_captura*/
IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_sesion_captura_localidad')
	begin	
		Alter Table sesion_captura 
		Add CONSTRAINT FK_sesion_captura_localidad FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_sesion_captura_localidad  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_sesion_captura_anillador')
	begin			
		Alter Table sesion_captura 
		Add CONSTRAINT FK_sesion_captura_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_sesion_captura_anillador  --   ')
	 end



/*tabla registro_colibri*/
IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_idespecie')
	begin			
		Alter Table registro_colibri 
		Add CONSTRAINT FK_registro_colibri_idespecie FOREIGN KEY (idespecie) REFERENCES leyenda_especie(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_idespecie  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_anillador')
	begin	
		Alter Table registro_colibri 
		Add CONSTRAINT FK_registro_colibri_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_anillador  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_estatus')
	begin	
		Alter Table registro_colibri 
		Add CONSTRAINT FK_registro_colibri_estatus FOREIGN KEY (estatus) REFERENCES leyenda_estatus(estatus);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_estatus  --   ')
	 end




/*tabla captura_colibri*/
IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_localidad')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_captura_colibri_localidad FOREIGN KEY (localidad_asociada) REFERENCES centro_registro_localidad(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_captura_colibri_localidad  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_estatus')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_captura_colibri_estatus FOREIGN KEY (estatus) REFERENCES leyenda_estatus(estatus);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_captura_colibri_estatus  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_idespecie')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_captura_colibri_idespecie FOREIGN KEY (jornada_Anillo) REFERENCES sesion_captura(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_captura_colibri_idespecie  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_body_molt')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_body_molt FOREIGN KEY (body_molt) REFERENCES leyenda_body_molt(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_body_molt  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_ff_molt')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_ff_molt FOREIGN KEY (ff_molt) REFERENCES leyenda_ff_molt(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_ff_molt  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_WRP')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_WRP FOREIGN KEY (WRP) REFERENCES leyenda_wrp(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_WRP  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_sexo')
	begin	
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_sexo FOREIGN KEY (sexo) REFERENCES leyenda_wrp(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_sexo  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_cor_pico')
	begin			
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_cor_pico FOREIGN KEY (cor_pico) REFERENCES leyenda_cor_pico(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_cor_pico  --   ')
	 end
	 
IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_grasa')
	begin			
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_grasa FOREIGN KEY (grasa) REFERENCES leyenda_grasa(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_grasa  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_musculo')
	begin			
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_musculo  FOREIGN KEY (musculo) REFERENCES leyenda_musculo(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_musculo  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_protuberancia_cloacal')
	begin			
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_protuberancia_cloacal FOREIGN KEY (protuberancia_cloacal) REFERENCES leyenda_protuberancia_cloacal(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_protuberancia_cloacal  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_registro_colibri_parche_reproductivo')
	begin			
		Alter Table captura_colibri 
		Add CONSTRAINT FK_registro_colibri_parche_reproductivo FOREIGN KEY (parche_reproductivo) REFERENCES leyenda_parche_reproductivo(id);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_registro_colibri_parche_reproductivo  --   ')
	 end

IF NOT EXISTS (select name from sys.foreign_keys where name = 'FK_captura_colibri_anillador')
	begin			
		Alter Table captura_colibri 
	Add CONSTRAINT FK_captura_colibri_anillador FOREIGN KEY (anillador) REFERENCES usuario(acronimo);
	 end
ELSE
	begin
		print('    ---    Ya existe la clave FK_captura_colibri_anillador  --   ')
	 end

	
END