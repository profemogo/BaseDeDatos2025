IF (select count(*) from leyenda_body_molt ) = 0
	begin
		insert into leyenda_body_molt  values (-1, 'sin dato'),
									(0, 'sin muda'), 
									(1, 'trazas'), 
									(2, 'ligera'), 
									(3, 'moderada'),
									(4, 'masivo')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_body_molt] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_ff_molt  )= 0
	begin	
		insert into leyenda_ff_molt  values (0, 'sin dato'),
									(1, 'ninguna'), 
									(2, 'adventicia'), 
									(3, 'cimetrica')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_ff_molt] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_grasa ) = 0
	begin	
		insert into leyenda_grasa  values  (0, 'sin grasa'), 
									(1, 'trazas de grasa'), 
									(2, 'cavidad furcular'), 
									(3, 'cavidad furcular y agdomen')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_grasa] ya contiene datos    ---   ')
	 end




IF (select count(*) from leyenda_musculo ) = 0
	begin	
		insert into leyenda_musculo  values (-1, 'sin dato'), 
									(0, 'triangulo convexo'), 
									(1, 'triangulo'), 
									(2, 'cupula')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_musculo] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_cor_pico ) = 0
	begin	
		insert into leyenda_cor_pico  values  
									(0, 'sin dato'),
									(1, 'corrugacion de pico: 95%'), 
									(2, 'corrugacion de pico: 50%'),
									(3, 'corrugacion de pico: 10%'), 
									(4, 'corrugacion de pico: 0%')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_cor_pico] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_especie ) = 0
	begin	
			insert into leyenda_especie  values  (1, 'sin dato', ''),
									 (2, 'Boissonneaua flavescens', 'TROCHILIDAE'),
									 (3, 'Heliangelus spencei', 'TROCHILIDAE'),
									 (4, 'Coeligena eos', 'TROCHILIDAE'),
									 (5, 'Campylopterus falcatus', 'TROCHILIDAE'),
									 (6, 'Colibri coruscans', 'TROCHILIDAE'),
									 (7, 'Colibri delphinae', 'TROCHILIDAE'),
									 (8, 'Colibri cyanotus', 'TROCHILIDAE'),
									 (9, 'Coeligena conradii', 'TROCHILIDAE'),
									 (10, 'Ocreatus underwoodii', 'TROCHILIDAE'),
									 (11, 'Chaetocercus heliodor', 'TROCHILIDAE'),									 
									 (12, 'Aglaiocercus kingii', 'TROCHILIDAE'),									 
									 (13, 'Ensifera ensifera', 'TROCHILIDAE'),									 
									 (14, 'Heliangelus mavors', 'TROCHILIDAE'),
									 (15, 'Adelomyia melanogenys', 'TROCHILIDAE')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_especie] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_parche_reproductivo ) = 0
	begin	
		insert into leyenda_parche_reproductivo  values  (-1, 'sin dato'), 
												(0, 'ninguno'), 
												(1, 'pequeno'),
												(2, 'mediano')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_parche_reproductivo] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_protuberancia_cloacal ) = 0
	begin	
		insert into leyenda_protuberancia_cloacal  values  (0, 'ninguno'), 
												(1, 'pequeno'),
												(2, 'mediano'),
												(3, 'larga')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_protuberancia_cloacal] ya contiene datos    ---   ')
	 end


		
IF (select count(*) from leyenda_sexo ) = 0
	begin	
		insert into leyenda_sexo  values  (0, 'desconocido', 'D'), 
									(1, 'macho', 'M'),
									(2, 'hembra', 'H'),
									(3, 'posible macho', 'PM'),
									(4, 'posible hembra', 'PH')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_sexo] ya contiene datos    ---   ')
	 end



IF (select count(*) from leyenda_estatus ) = 0
	begin	
		insert into leyenda_estatus  values  ('A', 'migratorio Astral'), 
									('B', 'migratorio Boreal'), 
									('E', 'escapado'), 
									('N', 'nueva'), 
									('R', 'recaptura'), 
									('RA', 're anillado')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_estatus] ya contiene datos    ---   ')
	 end


IF (select count(*) from leyenda_wrp ) = 0
	begin	
		insert into leyenda_wrp  values  (0, 'S/D', 'sin dato'), 
								(1, 'FCF', 'Plumaje formativo, sub adulto'),
								(2, 'DPB', 'Adulto que muda, plumaje definitivo'),
								(3, 'SPB', 'Segunda muda PreFormativa, juvenil que muda a plumaje adulto'),
								(4, 'DCB', 'Plumaje de adulto, no muda'),
								(5, 'FPF', 'Muda preFormativa, plumaje juvenil, esta mudando'),
								(6, 'FCJ', 'Plumaje Juvenil, no esta mudando'),
								(7, 'FPJ', 'Pre-Juvenil que esta mudando')
	 end
ELSE
	begin
		print('    ---    La tabla [leyenda_wrp] ya contiene datos    ---   ')
	 end


IF (select count(*) from permiso_configuracion ) = 0
	begin	
	insert into permiso_configuracion  values  (0, 'Permiso: Solo podran ver las estadisticas y lista de capturas'), 
											(5, 'Permiso: permiso de anillador +, podra abrir/cerrar nueva temporada capuras, modificar datos de sexo/specie de las capturas, descarga de exceles'),
											(15, 'Permiso: totales +, crea/ modifica y elimina usuarios'),
											(20, 'Permiso: Podran ver las estadisticas y lista de capturas y agregar capturas nuevas')
	 end
ELSE
	begin
		print('    ---    La tabla [permiso_configuracion] ya contiene datos    ---   ')
	 end
									





