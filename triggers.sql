-- MySQL dump 10.13  Distrib 9.2.0, for macos15.2 (arm64)
--
-- Host: localhost    Database: swimmingProject_v1
-- ------------------------------------------------------
-- Server version	9.2.0
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
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
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-27 20:17:01
