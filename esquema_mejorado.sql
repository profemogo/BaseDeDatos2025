-- MySQL dump 10.13  Distrib 9.2.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: swimmingProject_v1
-- ------------------------------------------------------
-- Server version	9.2.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `CategoriaEdad`
--

DROP TABLE IF EXISTS `CategoriaEdad`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CategoriaEdad` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `edad_minima` int NOT NULL,
  `edad_maxima` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CategoriaEdad`
--

LOCK TABLES `CategoriaEdad` WRITE;
/*!40000 ALTER TABLE `CategoriaEdad` DISABLE KEYS */;
/*!40000 ALTER TABLE `CategoriaEdad` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Club`
--

DROP TABLE IF EXISTS `Club`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Club` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `direccion` text,
  `telefono` text,
  `email` text,
  `pais` text,
  `ciudad` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Club`
--

LOCK TABLES `Club` WRITE;
/*!40000 ALTER TABLE `Club` DISABLE KEYS */;
/*!40000 ALTER TABLE `Club` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Competencias`
--

DROP TABLE IF EXISTS `Competencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Competencias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `pais` text NOT NULL,
  `estado` text NOT NULL,
  `ciudad` text NOT NULL,
  `club_id` bigint DEFAULT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date NOT NULL,
  `descripcion` text,
  `tipo_competencia` text,
  PRIMARY KEY (`id`),
  KEY `club_id` (`club_id`),
  CONSTRAINT `competencias_ibfk_1` FOREIGN KEY (`club_id`) REFERENCES `Club` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Competencias`
--

LOCK TABLES `Competencias` WRITE;
/*!40000 ALTER TABLE `Competencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `Competencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Entrenadores`
--

DROP TABLE IF EXISTS `Entrenadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Entrenadores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `apellidos` text NOT NULL,
  `cedula` text NOT NULL,
  `club_id` bigint DEFAULT NULL,
  `email` text,
  `telefono` text,
  `especialidad` text,
  `certificado` tinyint(1) DEFAULT '0',
  `fecha_certificacion` date DEFAULT NULL,
  `fecha_vencimiento` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `club_id` (`club_id`),
  CONSTRAINT `entrenadores_ibfk_1` FOREIGN KEY (`club_id`) REFERENCES `Club` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Entrenadores`
--

LOCK TABLES `Entrenadores` WRITE;
/*!40000 ALTER TABLE `Entrenadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `Entrenadores` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EstiloMetraje`
--

DROP TABLE IF EXISTS `EstiloMetraje`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EstiloMetraje` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `estilo_id` bigint DEFAULT NULL,
  `metraje_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `estilo_id` (`estilo_id`),
  KEY `metraje_id` (`metraje_id`),
  CONSTRAINT `estilometraje_ibfk_1` FOREIGN KEY (`estilo_id`) REFERENCES `EstilosNado` (`id`),
  CONSTRAINT `estilometraje_ibfk_2` FOREIGN KEY (`metraje_id`) REFERENCES `Metrajes` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstiloMetraje`
--

LOCK TABLES `EstiloMetraje` WRITE;
/*!40000 ALTER TABLE `EstiloMetraje` DISABLE KEYS */;
/*!40000 ALTER TABLE `EstiloMetraje` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `EstilosNado`
--

DROP TABLE IF EXISTS `EstilosNado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `EstilosNado` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `EstilosNado`
--

LOCK TABLES `EstilosNado` WRITE;
/*!40000 ALTER TABLE `EstilosNado` DISABLE KEYS */;
/*!40000 ALTER TABLE `EstilosNado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Genero`
--

DROP TABLE IF EXISTS `Genero`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Genero` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Genero`
--

LOCK TABLES `Genero` WRITE;
/*!40000 ALTER TABLE `Genero` DISABLE KEYS */;
/*!40000 ALTER TABLE `Genero` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_cambios`
--

DROP TABLE IF EXISTS `historial_cambios`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_cambios` (
  `id_historial` int NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(50) DEFAULT NULL,
  `id_registro` int DEFAULT NULL,
  `tipo_cambio` enum('INSERT','UPDATE','DELETE') DEFAULT NULL,
  `campo_modificado` varchar(50) DEFAULT NULL,
  `valor_anterior` text,
  `valor_nuevo` text,
  `usuario` varchar(50) DEFAULT NULL,
  `fecha_cambio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_historial`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_cambios`
--

LOCK TABLES `historial_cambios` WRITE;
/*!40000 ALTER TABLE `historial_cambios` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_cambios` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Metrajes`
--

DROP TABLE IF EXISTS `Metrajes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Metrajes` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `metros` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Metrajes`
--

LOCK TABLES `Metrajes` WRITE;
/*!40000 ALTER TABLE `Metrajes` DISABLE KEYS */;
/*!40000 ALTER TABLE `Metrajes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Nadadores`
--

DROP TABLE IF EXISTS `Nadadores`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Nadadores` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nombre` text NOT NULL,
  `apellidos` text NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `genero_id` bigint DEFAULT NULL,
  `cedula` text NOT NULL,
  `club_id` bigint DEFAULT NULL,
  `email` text,
  `telefono` text,
  `categoria_edad_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `genero_id` (`genero_id`),
  KEY `club_id` (`club_id`),
  KEY `categoria_edad_id` (`categoria_edad_id`),
  CONSTRAINT `nadadores_ibfk_1` FOREIGN KEY (`genero_id`) REFERENCES `Genero` (`id`),
  CONSTRAINT `nadadores_ibfk_2` FOREIGN KEY (`club_id`) REFERENCES `Club` (`id`),
  CONSTRAINT `nadadores_ibfk_3` FOREIGN KEY (`categoria_edad_id`) REFERENCES `CategoriaEdad` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Nadadores`
--

LOCK TABLES `Nadadores` WRITE;
/*!40000 ALTER TABLE `Nadadores` DISABLE KEYS */;
/*!40000 ALTER TABLE `Nadadores` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`skip-grants user`@`skip-grants host`*/ /*!50003 TRIGGER `after_nadador_update` AFTER INSERT ON `nadadores` FOR EACH ROW BEGIN
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Calcular edad actual
    SET edad_actual = TIMESTAMPDIFF(YEAR, NEW.fecha_nacimiento, CURDATE());
    
    -- Buscar categoría correspondiente
    SELECT id INTO categoria_correcta
    FROM CategoriaEdad
    WHERE edad_actual BETWEEN edad_minima AND edad_maxima
    LIMIT 1;
    
    -- Si no se encuentra categoría, registrar error
    IF categoria_correcta IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No se encontró categoría de edad apropiada para el nadador';
    ELSE
        -- Actualizar categoría si es diferente
        IF NEW.categoria_edad_id != categoria_correcta THEN
            UPDATE Nadadores 
            SET categoria_edad_id = categoria_correcta
            WHERE id = NEW.id;
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Records`
--

DROP TABLE IF EXISTS `Records`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Records` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nadador_id` bigint DEFAULT NULL,
  `estilo_metraje_id` bigint DEFAULT NULL,
  `tiempo` decimal(10,2) NOT NULL,
  `fecha` date NOT NULL,
  `competencia_id` bigint DEFAULT NULL,
  `tipo_record` enum('club','regional','nacional','mundial') NOT NULL,
  PRIMARY KEY (`id`),
  KEY `nadador_id` (`nadador_id`),
  KEY `estilo_metraje_id` (`estilo_metraje_id`),
  KEY `competencia_id` (`competencia_id`),
  CONSTRAINT `records_ibfk_1` FOREIGN KEY (`nadador_id`) REFERENCES `Nadadores` (`id`),
  CONSTRAINT `records_ibfk_2` FOREIGN KEY (`estilo_metraje_id`) REFERENCES `EstiloMetraje` (`id`),
  CONSTRAINT `records_ibfk_3` FOREIGN KEY (`competencia_id`) REFERENCES `Competencias` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Records`
--

LOCK TABLES `Records` WRITE;
/*!40000 ALTER TABLE `Records` DISABLE KEYS */;
/*!40000 ALTER TABLE `Records` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `RegistroCompetencias`
--

DROP TABLE IF EXISTS `RegistroCompetencias`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `RegistroCompetencias` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `nadador_id` bigint DEFAULT NULL,
  `competencia_id` bigint DEFAULT NULL,
  `serie_id` bigint DEFAULT NULL,
  `carril` int NOT NULL,
  `estado` enum('inscrito','confirmado','retirado','finalizado') DEFAULT 'inscrito',
  `posicion_final` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_nadador_serie` (`nadador_id`,`serie_id`),
  UNIQUE KEY `unique_carril_serie_estilo` (`serie_id`,`carril`),
  KEY `competencia_id` (`competencia_id`),
  CONSTRAINT `registrocompetencias_ibfk_1` FOREIGN KEY (`nadador_id`) REFERENCES `Nadadores` (`id`),
  CONSTRAINT `registrocompetencias_ibfk_2` FOREIGN KEY (`competencia_id`) REFERENCES `Competencias` (`id`),
  CONSTRAINT `registrocompetencias_ibfk_3` FOREIGN KEY (`serie_id`) REFERENCES `Series` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `RegistroCompetencias`
--

LOCK TABLES `RegistroCompetencias` WRITE;
/*!40000 ALTER TABLE `RegistroCompetencias` DISABLE KEYS */;
/*!40000 ALTER TABLE `RegistroCompetencias` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Series`
--

DROP TABLE IF EXISTS `Series`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Series` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `competencia_id` bigint DEFAULT NULL,
  `estilo_metraje_id` bigint DEFAULT NULL,
  `fecha_hora` timestamp NOT NULL,
  `numero_serie` int NOT NULL,
  `categoria_edad_id` bigint DEFAULT NULL,
  `genero_id` bigint DEFAULT NULL,
  `num_carriles` int NOT NULL DEFAULT '8',
  PRIMARY KEY (`id`),
  KEY `competencia_id` (`competencia_id`),
  KEY `estilo_metraje_id` (`estilo_metraje_id`),
  KEY `categoria_edad_id` (`categoria_edad_id`),
  KEY `genero_id` (`genero_id`),
  CONSTRAINT `series_ibfk_1` FOREIGN KEY (`competencia_id`) REFERENCES `Competencias` (`id`),
  CONSTRAINT `series_ibfk_2` FOREIGN KEY (`estilo_metraje_id`) REFERENCES `EstiloMetraje` (`id`),
  CONSTRAINT `series_ibfk_3` FOREIGN KEY (`categoria_edad_id`) REFERENCES `CategoriaEdad` (`id`),
  CONSTRAINT `series_ibfk_4` FOREIGN KEY (`genero_id`) REFERENCES `Genero` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Series`
--

LOCK TABLES `Series` WRITE;
/*!40000 ALTER TABLE `Series` DISABLE KEYS */;
/*!40000 ALTER TABLE `Series` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Tiempos`
--

DROP TABLE IF EXISTS `Tiempos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tiempos` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `registro_competencia_id` bigint DEFAULT NULL,
  `estilo_metraje_id` bigint DEFAULT NULL,
  `tiempo` decimal(10,2) NOT NULL,
  `fecha_registro` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `es_record` tinyint(1) DEFAULT '0',
  `tipo_record` enum('personal','club','regional','nacional','mundial') DEFAULT NULL,
  `observaciones` text,
  PRIMARY KEY (`id`),
  KEY `registro_competencia_id` (`registro_competencia_id`),
  KEY `estilo_metraje_id` (`estilo_metraje_id`),
  CONSTRAINT `tiempos_ibfk_1` FOREIGN KEY (`registro_competencia_id`) REFERENCES `RegistroCompetencias` (`id`),
  CONSTRAINT `tiempos_ibfk_2` FOREIGN KEY (`estilo_metraje_id`) REFERENCES `EstiloMetraje` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Tiempos`
--

LOCK TABLES `Tiempos` WRITE;
/*!40000 ALTER TABLE `Tiempos` DISABLE KEYS */;
/*!40000 ALTER TABLE `Tiempos` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`skip-grants user`@`skip-grants host`*/ /*!50003 TRIGGER `after_tiempo_changes` AFTER UPDATE ON `tiempos` FOR EACH ROW BEGIN
    -- Variables para obtener información del nadador
    DECLARE v_nadador_id BIGINT;
    DECLARE v_competencia_id BIGINT;
    
    -- Obtener nadador_id y competencia_id desde RegistroCompetencias
    SELECT rc.nadador_id, rc.competencia_id 
    INTO v_nadador_id, v_competencia_id
    FROM RegistroCompetencias rc
    WHERE rc.id = NEW.registro_competencia_id;

    -- Registrar cambios en tiempo
    IF OLD.tiempo != NEW.tiempo THEN
        INSERT INTO historial_cambios (
            tabla_afectada,
            id_registro,
            tipo_cambio,
            campo_modificado,
            valor_anterior,
            valor_nuevo,
            usuario
        ) VALUES (
            'Tiempos',
            NEW.id,
            'UPDATE',
            'tiempo',
            OLD.tiempo,
            NEW.tiempo,
            CURRENT_USER()
        );
    END IF;

    -- Verificar y registrar cambios en es_record y tipo_record
    IF OLD.es_record != NEW.es_record OR 
       (OLD.tipo_record != NEW.tipo_record) OR 
       (OLD.tipo_record IS NULL AND NEW.tipo_record IS NOT NULL) OR
       (OLD.tipo_record IS NOT NULL AND NEW.tipo_record IS NULL) THEN
        
        -- Registrar cambio en es_record
        IF OLD.es_record != NEW.es_record THEN
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Tiempos',
                NEW.id,
                'UPDATE',
                'es_record',
                OLD.es_record,
                NEW.es_record,
                CURRENT_USER()
            );
        END IF;

        -- Registrar cambio en tipo_record
        IF (OLD.tipo_record != NEW.tipo_record) OR 
           (OLD.tipo_record IS NULL AND NEW.tipo_record IS NOT NULL) OR
           (OLD.tipo_record IS NOT NULL AND NEW.tipo_record IS NULL) THEN
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Tiempos',
                NEW.id,
                'UPDATE',
                'tipo_record',
                OLD.tipo_record,
                NEW.tipo_record,
                CURRENT_USER()
            );
        END IF;

        -- Si es un nuevo récord, actualizar la tabla Records
        IF NEW.es_record = 1 AND NEW.tipo_record IS NOT NULL THEN
            -- Insertar nuevo récord
            INSERT INTO Records (
                nadador_id,
                estilo_metraje_id,
                tiempo,
                fecha,
                competencia_id,
                tipo_record
            ) VALUES (
                v_nadador_id,
                NEW.estilo_metraje_id,
                NEW.tiempo,
                CURDATE(),
                v_competencia_id,
                NEW.tipo_record
            );
            
            -- Registrar la creación del nuevo récord
            INSERT INTO historial_cambios (
                tabla_afectada,
                id_registro,
                tipo_cambio,
                campo_modificado,
                valor_anterior,
                valor_nuevo,
                usuario
            ) VALUES (
                'Records',
                LAST_INSERT_ID(),
                'INSERT',
                'nuevo_record',
                NULL,
                CONCAT('Nuevo record ', NEW.tipo_record),
                CURRENT_USER()
            );
        END IF;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `vista_nadadores_por_club`
--

DROP TABLE IF EXISTS `vista_nadadores_por_club`;
/*!50001 DROP VIEW IF EXISTS `vista_nadadores_por_club`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `vista_nadadores_por_club` AS SELECT 
 1 AS `nombre_club`,
 1 AS `ciudad_club`,
 1 AS `total_nadadores`,
 1 AS `lista_nadadores`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'swimmingProject_v1'
--
/*!50003 DROP PROCEDURE IF EXISTS `actualizar_categorias_edad` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `actualizar_categorias_edad`()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE nadador_id BIGINT;
    DECLARE fecha_nac DATE;
    DECLARE cat_actual BIGINT;
    DECLARE edad_actual INT;
    DECLARE categoria_correcta BIGINT;
    
    -- Declarar cursor
    DECLARE cur CURSOR FOR 
        SELECT id, fecha_nacimiento, categoria_edad_id 
        FROM Nadadores;
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO nadador_id, fecha_nac, cat_actual;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calcular edad actual
        SET edad_actual = TIMESTAMPDIFF(YEAR, fecha_nac, CURDATE());
        
        -- Buscar categoría correcta
        SELECT id INTO categoria_correcta
        FROM CategoriaEdad
        WHERE edad_actual BETWEEN edad_minima AND edad_maxima
        LIMIT 1;
        
        -- Actualizar si es necesario y si existe una categoría válida
        IF categoria_correcta IS NOT NULL AND categoria_correcta != cat_actual THEN
            UPDATE Nadadores 
            SET categoria_edad_id = categoria_correcta
            WHERE id = nadador_id;
        END IF;
    END LOOP;
    
    CLOSE cur;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `registrar_nadador_competencia` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`skip-grants user`@`skip-grants host` PROCEDURE `registrar_nadador_competencia`(
    IN p_nadador_id BIGINT,
    IN p_competencia_id BIGINT,
    IN p_serie_id BIGINT,
    IN p_carril INT
)
BEGIN
    -- Variables para validaciones
    DECLARE v_categoria_nadador BIGINT;
    DECLARE v_genero_nadador BIGINT;
    DECLARE v_categoria_serie BIGINT;
    DECLARE v_genero_serie BIGINT;
    DECLARE v_carril_ocupado INT;
    DECLARE v_fecha_competencia DATE;
    DECLARE v_error_msg TEXT;
    
    -- Variable para manejo de errores
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    -- Iniciar transacción
    START TRANSACTION;
    
    -- 1. Verificar que la competencia existe y está vigente
    SELECT fecha_inicio INTO v_fecha_competencia
    FROM Competencias 
    WHERE id = p_competencia_id 
    AND fecha_inicio >= CURDATE()
    FOR UPDATE;
    
    IF v_fecha_competencia IS NULL THEN
        SET v_error_msg = 'La competencia no existe o ya ha pasado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 2. Obtener datos del nadador
    SELECT categoria_edad_id, genero_id 
    INTO v_categoria_nadador, v_genero_nadador
    FROM Nadadores
    WHERE id = p_nadador_id
    FOR UPDATE;
    
    IF v_categoria_nadador IS NULL THEN
        SET v_error_msg = 'El nadador no existe';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 3. Verificar que la serie corresponde a la categoría y género del nadador
    SELECT categoria_edad_id, genero_id 
    INTO v_categoria_serie, v_genero_serie
    FROM Series
    WHERE id = p_serie_id
    FOR UPDATE;
    
    IF v_categoria_serie != v_categoria_nadador THEN
        SET v_error_msg = 'La categoría del nadador no corresponde a la serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;
    
    IF v_genero_serie != v_genero_nadador THEN
        SET v_error_msg = 'El género del nadador no corresponde a la serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 4. Verificar que el carril esté disponible
    SELECT COUNT(*) INTO v_carril_ocupado
    FROM RegistroCompetencias
    WHERE serie_id = p_serie_id 
    AND carril = p_carril
    AND estado != 'retirado'
    FOR UPDATE;
    
    IF v_carril_ocupado > 0 THEN
        SET v_error_msg = 'El carril ya está ocupado';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 5. Verificar que el nadador no esté ya inscrito en la misma serie
    SELECT COUNT(*) INTO v_carril_ocupado
    FROM RegistroCompetencias
    WHERE serie_id = p_serie_id 
    AND nadador_id = p_nadador_id
    AND estado != 'retirado'
    FOR UPDATE;
    
    IF v_carril_ocupado > 0 THEN
        SET v_error_msg = 'El nadador ya está inscrito en esta serie';
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_error_msg;
    END IF;

    -- 6. Realizar la inscripción
    INSERT INTO RegistroCompetencias (
        nadador_id,
        competencia_id,
        serie_id,
        carril,
        estado
    ) VALUES (
        p_nadador_id,
        p_competencia_id,
        p_serie_id,
        p_carril,
        'inscrito'
    );

    -- Si todo está bien, confirmar la transacción
    COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `vista_nadadores_por_club`
--

/*!50001 DROP VIEW IF EXISTS `vista_nadadores_por_club`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`skip-grants user`@`skip-grants host` SQL SECURITY DEFINER */
/*!50001 VIEW `vista_nadadores_por_club` AS select `c`.`nombre` AS `nombre_club`,`c`.`ciudad` AS `ciudad_club`,count(`n`.`id`) AS `total_nadadores`,group_concat(concat(`n`.`nombre`,' ',`n`.`apellidos`,' (',timestampdiff(YEAR,`n`.`fecha_nacimiento`,curdate()),' años)') order by `n`.`apellidos` ASC,`n`.`nombre` ASC separator ', ') AS `lista_nadadores` from (`club` `c` left join `nadadores` `n` on((`c`.`id` = `n`.`club_id`))) group by `c`.`id`,`c`.`nombre`,`c`.`ciudad` order by `c`.`nombre` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-27 16:53:17
