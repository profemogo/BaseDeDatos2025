-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: HistoriasMedicas
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.22.04.1

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
-- Table structure for table `AntecedenteFamiliar`
--

DROP TABLE IF EXISTS `AntecedenteFamiliar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AntecedenteFamiliar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `concepto` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `AntecedenteFamiliar_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AntecedenteGinecologico`
--

DROP TABLE IF EXISTS `AntecedenteGinecologico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AntecedenteGinecologico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `menstruacion` varchar(100) DEFAULT NULL,
  `menarquia` int DEFAULT NULL,
  `menopausia` int DEFAULT NULL,
  `1rs` int DEFAULT NULL,
  `cs` int DEFAULT NULL,
  `ao` tinyint(1) DEFAULT NULL,
  `tiempo_ao` varchar(255) DEFAULT NULL,
  `trh` varchar(255) DEFAULT NULL,
  `diu` varchar(255) DEFAULT NULL,
  `sinusorragia` varchar(255) DEFAULT NULL,
  `dispauremia` varchar(255) DEFAULT NULL,
  `lactancia` varchar(255) DEFAULT NULL,
  `ultima_citologia` varchar(255) DEFAULT NULL,
  `resultado_citologia` varchar(255) DEFAULT NULL,
  `biopsia` varchar(255) DEFAULT NULL,
  `leucorrea` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `AntecedenteGinecologico_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AntecedenteObstetrico`
--

DROP TABLE IF EXISTS `AntecedenteObstetrico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AntecedenteObstetrico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `gesta` int DEFAULT NULL,
  `vag` int DEFAULT NULL,
  `cec` int DEFAULT NULL,
  `aborto` int DEFAULT NULL,
  `pmf` varchar(255) DEFAULT NULL,
  `fpu` varchar(255) DEFAULT NULL,
  `eqx` varchar(255) DEFAULT NULL,
  `fur` date DEFAULT NULL,
  `fpp` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `AntecedenteObstetrico_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AntecedenteOtro`
--

DROP TABLE IF EXISTS `AntecedenteOtro`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AntecedenteOtro` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `concepto` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `AntecedenteOtro_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `AntecedentePersonal`
--

DROP TABLE IF EXISTS `AntecedentePersonal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `AntecedentePersonal` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `tipo_sangre_id` int NOT NULL,
  `concepto` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  KEY `tipo_sangre_id` (`tipo_sangre_id`),
  CONSTRAINT `AntecedentePersonal_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE,
  CONSTRAINT `AntecedentePersonal_ibfk_2` FOREIGN KEY (`tipo_sangre_id`) REFERENCES `TipoSangre` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Auditoria`
--

DROP TABLE IF EXISTS `Auditoria`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Auditoria` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tabla_afectada` varchar(50) NOT NULL,
  `accion` varchar(50) DEFAULT NULL,
  `id_registro` int NOT NULL,
  `usuario` varchar(50) NOT NULL,
  `fecha_hora` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `datos_anteriores` text,
  `datos_nuevos` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Control`
--

DROP TABLE IF EXISTS `Control`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Control` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `numero` int DEFAULT NULL,
  `talla` float DEFAULT NULL,
  `peso` float DEFAULT NULL,
  `tension_arterial` varchar(10) DEFAULT NULL,
  `frecuencia_cardiaca` int DEFAULT NULL,
  `observaciones` text,
  PRIMARY KEY (`id`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `Control_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ExamenFisico`
--

DROP TABLE IF EXISTS `ExamenFisico`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ExamenFisico` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `examen_mama` varchar(255) DEFAULT NULL,
  `colposcopia` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `ExamenFisico_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Habito`
--

DROP TABLE IF EXISTS `Habito`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Habito` (
  `id` int NOT NULL AUTO_INCREMENT,
  `paciente_id` int NOT NULL,
  `alcohol` tinyint(1) DEFAULT NULL,
  `tabaco` tinyint(1) DEFAULT NULL,
  `cafe` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `Habito_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Informe`
--

DROP TABLE IF EXISTS `Informe`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Informe` (
  `id` int NOT NULL AUTO_INCREMENT,
  `control_id` int NOT NULL,
  `tipo_informe_id` int NOT NULL,
  `conclusion` text,
  PRIMARY KEY (`id`),
  KEY `control_id` (`control_id`),
  KEY `tipo_informe_id` (`tipo_informe_id`),
  CONSTRAINT `Informe_ibfk_1` FOREIGN KEY (`control_id`) REFERENCES `Control` (`id`) ON DELETE CASCADE,
  CONSTRAINT `Informe_ibfk_2` FOREIGN KEY (`tipo_informe_id`) REFERENCES `TipoInforme` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Paciente`
--

DROP TABLE IF EXISTS `Paciente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Paciente` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo_documento` enum('V','E','J') NOT NULL,
  `documento` int NOT NULL,
  `nombre` varchar(255) NOT NULL,
  `apellido` varchar(255) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `estado_civil` enum('casado','soltero','viudo','concubinato') NOT NULL,
  `estudio` varchar(255) DEFAULT NULL,
  `direccion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `documento` (`documento`),
  KEY `idx_paciente_nombre_apellido` (`nombre`,`apellido`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_ingreso_fecha_nacimiento_invalida` BEFORE INSERT ON `Paciente` FOR EACH ROW BEGIN
    IF NEW.fecha_nacimiento > CURDATE() THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'La fecha de nacimiento no puede ser en el futuro';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `auditoria_paciente_insert` AFTER INSERT ON `Paciente` FOR EACH ROW BEGIN
    INSERT INTO Auditoria (tabla_afectada, accion, id_registro, usuario, datos_nuevos)
    VALUES ('Paciente', 'INSERT', NEW.id, CURRENT_USER(), 
            CONCAT('Nuevo paciente: ', NEW.nombre, ' ', NEW.apellido));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `prevenir_actualizacion_datos_criticos` BEFORE UPDATE ON `Paciente` FOR EACH ROW BEGIN
    
    IF NEW.documento != OLD.documento OR 
       NEW.tipo_documento != OLD.tipo_documento OR 
       NEW.fecha_nacimiento != OLD.fecha_nacimiento THEN
        
        
        SET @mensaje_error = 'No se permite modificar los siguientes datos: ';
        
        IF NEW.documento != OLD.documento THEN
            SET @mensaje_error = CONCAT(@mensaje_error, 'documento, ');
        END IF;
        
        IF NEW.tipo_documento != OLD.tipo_documento THEN
            SET @mensaje_error = CONCAT(@mensaje_error, 'tipo de documento, ');
        END IF;
        
        IF NEW.fecha_nacimiento != OLD.fecha_nacimiento THEN
            SET @mensaje_error = CONCAT(@mensaje_error, 'fecha de nacimiento, ');
        END IF;
        
        
        SET @mensaje_error = LEFT(@mensaje_error, CHAR_LENGTH(@mensaje_error) - 2);
        
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = @mensaje_error;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `auditoria_paciente_update` AFTER UPDATE ON `Paciente` FOR EACH ROW BEGIN
    IF NEW.nombre != OLD.nombre OR NEW.apellido != OLD.apellido OR 
       NEW.estado_civil != OLD.estado_civil OR NEW.estudio != OLD.estudio OR 
       NEW.direccion != OLD.direccion THEN
        
        INSERT INTO Auditoria (tabla_afectada, accion, id_registro, usuario, datos_anteriores, datos_nuevos)
        VALUES ('Paciente', 'UPDATE', NEW.id, CURRENT_USER(),
                CONCAT('Nombre: ', OLD.nombre, ' ', OLD.apellido, 
                       ', Estado civil: ', OLD.estado_civil,
                       ', Estudio: ', IFNULL(OLD.estudio, 'NULL'),
                       ', Dirección: ', IFNULL(OLD.direccion, 'NULL')),
                CONCAT('Nombre: ', NEW.nombre, ' ', NEW.apellido, 
                       ', Estado civil: ', NEW.estado_civil,
                       ', Estudio: ', IFNULL(NEW.estudio, 'NULL'),
                       ', Dirección: ', IFNULL(NEW.direccion, 'NULL')));
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `auditoria_paciente_delete` AFTER DELETE ON `Paciente` FOR EACH ROW BEGIN
    INSERT INTO Auditoria (tabla_afectada, accion, id_registro, usuario, datos_anteriores)
    VALUES ('Paciente', 'DELETE', OLD.id, CURRENT_USER(), 
            CONCAT('Paciente eliminado: ', OLD.nombre, ' ', OLD.apellido));
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `Telefono`
--

DROP TABLE IF EXISTS `Telefono`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Telefono` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero` varchar(20) NOT NULL,
  `paciente_id` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `paciente_id` (`paciente_id`),
  CONSTRAINT `Telefono_ibfk_1` FOREIGN KEY (`paciente_id`) REFERENCES `Paciente` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TipoInforme`
--

DROP TABLE IF EXISTS `TipoInforme`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoInforme` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TipoSangre`
--

DROP TABLE IF EXISTS `TipoSangre`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TipoSangre` (
  `id` int NOT NULL AUTO_INCREMENT,
  `tipo` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-26 23:21:48
