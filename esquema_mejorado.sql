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
  KEY `nadador_id` (`nadador_id`),
  KEY `competencia_id` (`competencia_id`),
  KEY `serie_id` (`serie_id`),
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-26 18:20:48
