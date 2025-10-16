-- 1. CREACIÓN Y USO DE LA BASE DE DATOS

DROP DATABASE IF EXISTS `viajafacil_db`;
CREATE DATABASE `viajafacil_db` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `viajafacil_db`;

-- 2. CREACIÓN DE TABLAS PRINCIPALES (ENTIDADES)

-- Tabla de Usuarios
CREATE TABLE `usuarios` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(100) NOT NULL,
    `email` VARCHAR(150) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `telefono` VARCHAR(20),
    `rol` ENUM('cliente', 'administrador') NOT NULL DEFAULT 'cliente',
    `fecha_registro` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `activo` BOOLEAN DEFAULT TRUE
);

-- Tabla de Destinos
CREATE TABLE `destinos` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `nombre` VARCHAR(150) NOT NULL,
    `pais` VARCHAR(100) NOT NULL,
    `ciudad` VARCHAR(100) NOT NULL,
    `descripcion` TEXT,
    `latitud` DECIMAL(10, 8),
    `longitud` DECIMAL(11, 8),
    `imagen_principal` VARCHAR(500),
    `activo` BOOLEAN DEFAULT TRUE
);

-- Tabla de Paquetes Turísticos
CREATE TABLE `paquetes_turisticos` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `destino_id` INT UNSIGNED NOT NULL,
    `nombre` VARCHAR(200) NOT NULL,
    `descripcion` TEXT,
    `precio_base` DECIMAL(10, 2) NOT NULL,
    `duracion_dias` INT NOT NULL,
    `plazas_totales` INT NOT NULL,
    `plazas_disponibles` INT NOT NULL,
    `activo` BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (`destino_id`) REFERENCES `destinos`(`id`)
);

-- Tabla de Reservas
CREATE TABLE `reservas` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `usuario_id` INT UNSIGNED NOT NULL,
    `paquete_id` INT UNSIGNED NOT NULL,
    `fecha_reserva` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `fecha_viaje` DATE NOT NULL,
    `numero_viajeros` INT NOT NULL DEFAULT 1,
    `precio_total` DECIMAL(10, 2) NOT NULL,
    `estado` ENUM('pendiente', 'confirmada', 'cancelada', 'completada') DEFAULT 'pendiente',
    FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`),
    FOREIGN KEY (`paquete_id`) REFERENCES `paquetes_turisticos`(`id`)
);

-- Tabla de Ofertas Especiales
CREATE TABLE `ofertas_especiales` (
    `id` INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `paquete_id` INT UNSIGNED NOT NULL,
    `descuento_porcentaje` DECIMAL(5, 2),
    `fecha_inicio` DATETIME NOT NULL,
    `fecha_fin` DATETIME NOT NULL,
    `activo` BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (`paquete_id`) REFERENCES `paquetes_turisticos`(`id`)
);

-- 3. TABLA PIVOTE PARA FAVORITOS
CREATE TABLE `favoritos` (
    `usuario_id` INT UNSIGNED NOT NULL,
    `paquete_id` INT UNSIGNED NOT NULL,
    `fecha_agregado` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`usuario_id`, `paquete_id`),
    FOREIGN KEY (`usuario_id`) REFERENCES `usuarios`(`id`) ON DELETE CASCADE,
    FOREIGN KEY (`paquete_id`) REFERENCES `paquetes_turisticos`(`id`) ON DELETE CASCADE
);

-- 4. INSERCIÓN DE DATOS DE EJEMPLO
INSERT INTO `usuarios` (`nombre`, `email`, `password`, `rol`) VALUES
('Administrador ViajaFácil', 'admin@viajafacil.com', '$2y$10$hashed_password', 'administrador'),
('Cliente Ejemplo', 'cliente@ejemplo.com', '$2y$10$hashed_password', 'cliente');

INSERT INTO `destinos` (`nombre`, `pais`, `ciudad`, `descripcion`, `latitud`, `longitud`) VALUES
('París', 'Francia', 'París', 'La ciudad del amor con la Torre Eiffel', 48.856613, 2.352222),
('Bali', 'Indonesia', 'Denpasar', 'Isla paradisíaca con templos y playas', -8.409518, 115.188919);

INSERT INTO `paquetes_turisticos` (`destino_id`, `nombre`, `descripcion`, `precio_base`, `duracion_dias`, `plazas_totales`, `plazas_disponibles`) VALUES
(1, 'París Romántico', 'Tour completo por los lugares más románticos de París', 450.00, 5, 20, 15),
(2, 'Bali Paradise', 'Experiencia completa en la isla de los dioses', 780.00, 8, 15, 8);
