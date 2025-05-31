
DROP TABLE IF EXISTS `Cliente`;
CREATE TABLE `Cliente`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `apellido` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_cliente_correo`(`correo`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `Mesa`;
CREATE TABLE `Mesa`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `capacidad` int(11) NOT NULL,
  `ubicacion` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `estado` enum('Disponible','Ocupada','Reservada') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Disponible',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_mesa_estado`(`estado`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `Pedido`;
CREATE TABLE `Pedido`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `total_pedido` decimal(10, 2) NOT NULL,
  `estado` enum('En proceso','Listo','cancelado') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'En proceso',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `Reserva`;
CREATE TABLE `Reserva`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cliente_id` int(11) NOT NULL,
  `mesa_id` int(11) NOT NULL,
  `fecha_reserva` datetime NOT NULL,
  `numero_personas` int(11) NOT NULL,
  `estado` enum('pendiente','confirmada','cancelada') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'pendiente',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_reserva_fecha`(`fecha_reserva`) USING BTREE,
  INDEX `fk_reserva_mesa`(`mesa_id`) USING BTREE,
  INDEX `idx_reserva_cliente_fecha`(`cliente_id`, `fecha_reserva`) USING BTREE,
  CONSTRAINT `fk_reserva_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `Cliente` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_reserva_mesa` FOREIGN KEY (`mesa_id`) REFERENCES `Mesa` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

DROP TABLE IF EXISTS `ReservaPedido`;
CREATE TABLE `ReservaPedido`  (
  `reserva_id` int(11) NOT NULL,
  `pedido_id` int(11) NOT NULL,
  `cantidad` int(11) NOT NULL,
  `observacion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`reserva_id`, `pedido_id`) USING BTREE,
  INDEX `fk_rp_pedido`(`pedido_id`) USING BTREE,
  CONSTRAINT `fk_rp_reserva` FOREIGN KEY (`reserva_id`) REFERENCES `Reserva` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_rp_pedido` FOREIGN KEY (`pedido_id`) REFERENCES `Pedido` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = Compact;

DROP TRIGGER IF EXISTS `trg_reserva_after_insert`;
delimiter ;;
CREATE TRIGGER `trg_reserva_after_insert` AFTER INSERT ON `Reserva` FOR EACH ROW BEGIN
    UPDATE Mesa
    SET estado = 'Reservada'
    WHERE id = NEW.mesa_id;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_reserva_after_update`;
delimiter ;;
CREATE TRIGGER `trg_reserva_after_update` AFTER UPDATE ON `Reserva` FOR EACH ROW BEGIN
    IF OLD.mesa_id <> NEW.mesa_id THEN
      
        UPDATE Mesa SET estado = 'Disponible' WHERE id = OLD.mesa_id;
      
        UPDATE Mesa SET estado = 'Reservada' WHERE id = NEW.mesa_id;
    END IF;
    IF OLD.estado <> NEW.estado THEN
        IF NEW.estado = 'confirmada' THEN
            UPDATE Mesa SET estado = 'Ocupada' WHERE id = NEW.mesa_id;
        ELSEIF NEW.estado = 'cancelada' THEN
            UPDATE Mesa SET estado = 'Disponible' WHERE id = NEW.mesa_id;
        END IF;
    END IF;
END
;;
delimiter ;

DROP TRIGGER IF EXISTS `trg_reserva_after_delete`;
delimiter ;;
CREATE TRIGGER `trg_reserva_after_delete` AFTER DELETE ON `Reserva` FOR EACH ROW BEGIN
    UPDATE Mesa
    SET estado = 'Disponible'
    WHERE id = OLD.mesa_id;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
