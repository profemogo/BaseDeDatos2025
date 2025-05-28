BEGIN
CREATE TABLE leyenda_body_molt (
	id int NOT NULL,
	body_molt nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_ff_molt (
	id int NOT NULL,
	ff_molt nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_grasa (
	id int NOT NULL,
	grasa nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_musculo (
	id int NOT NULL,
	musculo nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_cor_pico (
	id int NOT NULL,
	cor_pico nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_especie (
	id int NOT NULL,
	especie nvarchar(50) NOT NULL unique,
	familia nvarchar(50) NOT NULL,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_parche_reproductivo (
	id int NOT NULL,
	parche_reproductivo nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_protuberancia_cloacal (
	id int NOT NULL,
	protuberancia_cloacal nvarchar(50) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_sexo (
	id int NOT NULL,
	sexo nvarchar(15) NOT NULL unique,
	acronimo nvarchar(2) NOT NULL unique,
	PRIMARY KEY (id)
)
CREATE TABLE leyenda_estatus (
	estatus nvarchar(2)  NOT NULL ,	
	leyenda_estatus nvarchar(50) NOT NULL unique,
	PRIMARY KEY (estatus)
)
CREATE TABLE leyenda_wrp (
	id int NOT NULL,
	wrp nvarchar(5) NOT NULL unique,
	descripcion nvarchar (250),
	PRIMARY KEY (id)
)


CREATE TABLE permiso_configuracion (
	id int NOT NULL,
	descripcion nvarchar(250) NOT NULL,
	PRIMARY KEY (id)
)

CREATE TABLE centro_registro_localidad (
	id int NOT NULL IDENTITY (0, 1),
	nombre nvarchar(50) NOT NULL,
	pais nvarchar(50) NOT NULL,
	estado nvarchar(50) NOT NULL,
	localidad nvarchar(5) NOT NULL,
	msnm int NOT NULL,
	correo nvarchar(40) NOT NULL,
	telefono nvarchar(40) NOT NULL,
	PRIMARY KEY (id)
)

CREATE TABLE usuario(
	acronimo nvarchar(10) NOT NULL,
	clave nvarchar(50) NOT NULL,
	nombre nvarchar(10) NOT NULL, 
	apellido nvarchar(10) NOT NULL,
	correo nvarchar(40) NOT NULL,
	telefono nvarchar(40) NOT NULL,
	localidad_asociada int NOT NULL,
	procedencia_institucional nvarchar(10) NOT NULL,
	permiso int NOT NULL,
	PRIMARY KEY (acronimo)
)

CREATE TABLE sesion_captura(
	id int NOT NULL IDENTITY (0, 1),
	nombre nvarchar(50) NOT NULL,	
	fecha_inicio datetime NOT NULL,	
	fecha_fin datetime,	
	anillador nvarchar(10) NOT NULL,
	localidad_asociada int NOT NULL ,	
	PRIMARY KEY (id)
)

CREATE TABLE registro_colibri(
	id int NOT NULL IDENTITY (0, 1),
	localidad_asociada int NOT NULL ,	
	anillo_metal_primario nvarchar(10) NOT NULL,
	anillo_metal_actual nvarchar(10) NOT NULL,
	tamano_anillo nvarchar(2),
	idespecie int NOT NULL,	
	fecha datetime NOT NULL,
	estatus nvarchar(2)  NOT NULL ,	
	anillador nvarchar(10) NOT NULL,
	PRIMARY KEY (id)
)

CREATE TABLE captura_colibri (
    id nvarchar(30) NOT NULL ,
	localidad_asociada int NOT NULL ,	
	estatus nvarchar(2)  NOT NULL ,
	tamano_anillo nvarchar(2),
	anillo_metal nvarchar(10) NOT NULL,	
	ra_anillo_metal nvarchar(10),	
	idespecie int NOT NULL,	
	jornada_anillo int NOT NULL,	
	fecha datetime NOT NULL,
	red int,
	m_olt_limite nvarchar(5),
	body_molt int NOT NULL,
	ff_molt int NOT NULL,
	WRP int NOT NULL,
	sexo int NOT NULL,
	cor_pico int NOT NULL,	
	ala float ,
	pico_culmen float ,
	cola float ,
	peso float ,
	grasa int NOT NULL,
	musculo int NOT NULL,
	protuberancia_cloacal int NOT NULL,
	parche_reproductivo int NOT NULL,
	anillador nvarchar(10) NOT NULL,
	primarias nvarchar(250),
	nota nvarchar(250)
	PRIMARY KEY (id)
)


END