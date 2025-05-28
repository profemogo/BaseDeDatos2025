BEGIN	
--Para la tabla capturas_colibri, crearemos indices en las columnas des idespecie, anillo_metal, estatus, jornada_anillo y anillador
 IF NOT EXISTS (select count(*) from sysindexes where name = 'i_captura_colibri_anillo_metal')
	begin
		create nonclustered index i_captura_colibri_anillo_metal
		on captura_colibri(anillo_metal)
	 end
ELSE
	begin
		print('    ---    Ya existe ese indice   i_captura_colibri_anillo_metal  --   ')
	 end

IF NOT EXISTS (select count(*) from sysindexes where name = 'i_captura_colibri_estatus')
	begin
		create nonclustered index i_captura_colibri_estatus
		on captura_colibri(estatus)
	 end
ELSE
	begin
		print('    ---    Ya existe ese indice    i_captura_colibri_estatus  --   ')
	end


IF NOT EXISTS (select count(*) from sysindexes where name = 'i_captura_colibri_idespecie')
	begin
		create nonclustered index i_captura_colibri_idespecie
		on captura_colibri(idespecie)
	 end
ELSE
	begin
		print('    ---    Ya existe ese indice  i_captura_colibri_idespecie  --   ')
	 end

IF NOT EXISTS (select count(*) from sysindexes where name = 'i_captura_colibri_jornada_anillo')
	begin
		create nonclustered index i_captura_colibri_jornada_anillo
		on captura_colibri(jornada_anillo)
	 end
ELSE
	begin
		print('    ---    Ya existe ese indice  i_captura_colibri_jornada_anillo  --   ')
	 end

 IF NOT EXISTS (select count(*) from sysindexes where name = 'i_captura_colibri_anillador')
	begin
		create nonclustered index i_captura_colibri_anillador
		on captura_colibri(anillador)
	 end
ELSE
	begin
		print('    ---    Ya existe ese indice i_captura_colibri_anillador   --   ')
	 end


END