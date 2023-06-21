-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 20, 2023 at 02:46 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `folha_salario`
--
CREATE DATABASE IF NOT EXISTS `folha_salario` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `folha_salario`;

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `obterDiasLaborais`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `obterDiasLaborais` (IN `inicio` DATE, IN `fim` DATE)   BEGIN   

DECLARE startDate DATE;
DECLARE endDate DATE;
DECLARE currentDate DATE;

-- Set the values for the start and end dates
SET startDate = inicio, endDate = fim;

SET currentDate = startDate;

DROP TEMPORARY TABLE IF EXISTS calendar; 
-- Create a temporary table to hold the calendar data
CREATE TEMPORARY TABLE data_laboral (dt DATE);

-- Loop through all the dates between the start and end dates
WHILE currentDate <= endDate
DO
    INSERT INTO data_laboral (dt)
    SELECT currentDate where NOT EXISTS(SELECT 1 FROM feriado WHERE date_format(currentDate, "%m-%d") = date_format(dia, "%m-%d")) AND weekday(currentDate) NOT IN (6) AND NOT EXISTS(SELECT 1 FROM feriado WHERE date_format(currentDate, "%m-%d") = date_format(dia, "%m-%d"));
    
    -- Increment the current date by one day
    SET currentDate = DATE_ADD(currentDate, interval 1 day);
END WHILE;

END$$

DROP PROCEDURE IF EXISTS `sp_test`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_test` (IN `inicio` DATE, IN `fim` DATE)   BEGIN   

DECLARE startDate DATE;
DECLARE endDate DATE;
DECLARE currentDate DATE;

-- Set the values for the start and end dates
SET startDate = inicio, endDate = fim;

SET currentDate = startDate;

DROP TEMPORARY TABLE IF EXISTS calendar; 
-- Create a temporary table to hold the calendar data
CREATE TEMPORARY TABLE Calendar (dt DATE, indicador enum('D','F'));

-- Loop through all the dates between the start and end dates
WHILE currentDate <= endDate
DO
    INSERT INTO calendar (dt, indicador)
    SELECT currentDate,'D' as Indicador where NOT EXISTS(SELECT 1 FROM feriado WHERE date_format(currentDate, "%m-%d") = date_format(dia, "%m-%d")) AND weekday(currentDate) IN (6);
  
	INSERT INTO calendar (dt, indicador)
    SELECT currentDate,'F' as Indicador where EXISTS(SELECT 1 FROM feriado WHERE date_format(currentDate, "%m-%d") = date_format(dia, "%m-%d"));
    
    -- Increment the current date by one day
    SET currentDate = DATE_ADD(currentDate, interval 1 day);
END WHILE;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
CREATE TABLE `area` (
  `cod_area` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  `cod_centro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `area`
--

INSERT INTO `area` (`cod_area`, `nome`, `cod_centro`) VALUES
(1, 'Informática', 1),
(2, 'Mêcanica', 2),
(3, 'Vendas', 2),
(4, 'Marketing', 2),
(5, 'Produção', 3);

-- --------------------------------------------------------

--
-- Table structure for table `assiduidade`
--

DROP TABLE IF EXISTS `assiduidade`;
CREATE TABLE `assiduidade` (
  `cod_assiduidade` int(11) NOT NULL,
  `data_presenca` date NOT NULL,
  `entrada` time NOT NULL,
  `saida` time NOT NULL,
  `cod_obreiro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `assiduidade`
--

INSERT INTO `assiduidade` (`cod_assiduidade`, `data_presenca`, `entrada`, `saida`, `cod_obreiro`) VALUES
(3, '2023-06-13', '08:00:00', '16:00:00', 2),
(4, '2023-06-14', '08:00:00', '16:00:00', 2),
(6, '2023-06-15', '08:00:00', '20:00:00', 2),
(5, '2023-06-15', '16:00:00', '03:00:00', 1),
(1, '2023-06-13', '16:15:00', '23:00:00', 1),
(2, '2023-06-14', '16:30:00', '23:30:00', 1);

-- --------------------------------------------------------

--
-- Table structure for table `banco`
--

DROP TABLE IF EXISTS `banco`;
CREATE TABLE `banco` (
  `cod_banco` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `banco`
--

INSERT INTO `banco` (`cod_banco`, `nome`) VALUES
(1, 'BAI'),
(3, 'BFA'),
(2, 'BIC'),
(4, 'SOL');

-- --------------------------------------------------------

--
-- Table structure for table `centro_custo`
--

DROP TABLE IF EXISTS `centro_custo`;
CREATE TABLE `centro_custo` (
  `cod_centro` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `centro_custo`
--

INSERT INTO `centro_custo` (`cod_centro`, `nome`) VALUES
(1, 'centro 1'),
(2, 'centro 2'),
(3, 'centro 3');

-- --------------------------------------------------------

--
-- Table structure for table `conta_bancaria`
--

DROP TABLE IF EXISTS `conta_bancaria`;
CREATE TABLE `conta_bancaria` (
  `num_conta` int(11) NOT NULL,
  `cod_banco` int(11) NOT NULL,
  `cod_obreiro` int(11) NOT NULL,
  `quantia` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `conta_bancaria`
--

INSERT INTO `conta_bancaria` (`num_conta`, `cod_banco`, `cod_obreiro`, `quantia`) VALUES
(20201219, 1, 1, 0.00),
(20211219, 4, 2, 300.00);

-- --------------------------------------------------------

--
-- Table structure for table `feriado`
--

DROP TABLE IF EXISTS `feriado`;
CREATE TABLE `feriado` (
  `cod_feriado` int(11) NOT NULL,
  `dia` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `feriado`
--

INSERT INTO `feriado` (`cod_feriado`, `dia`) VALUES
(1, '2023-01-01'),
(2, '2023-02-04'),
(3, '2023-02-21'),
(4, '2023-03-08'),
(5, '2023-03-23'),
(6, '2023-04-04'),
(7, '2023-04-07'),
(8, '2023-05-01'),
(9, '2023-09-17'),
(10, '2023-11-02'),
(11, '2023-11-11'),
(12, '2023-12-25');

-- --------------------------------------------------------

--
-- Table structure for table `historico_pagamento`
--

DROP TABLE IF EXISTS `historico_pagamento`;
CREATE TABLE `historico_pagamento` (
  `cod_pagamento` int(11) NOT NULL,
  `data` date NOT NULL,
  `quantia` decimal(10,2) NOT NULL,
  `cod_obreiro` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `historico_pagamento`
--

INSERT INTO `historico_pagamento` (`cod_pagamento`, `data`, `quantia`, `cod_obreiro`) VALUES
(2, '2023-06-16', 300.00, 2);

--
-- Triggers `historico_pagamento`
--
DROP TRIGGER IF EXISTS `transferir`;
DELIMITER $$
CREATE TRIGGER `transferir` BEFORE INSERT ON `historico_pagamento` FOR EACH ROW BEGIN
	UPDATE conta_bancaria cb SET cb.quantia = cb.quantia + NEW.quantia WHERE cb.cod_obreiro = NEW.cod_obreiro;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `obreiro`
--

DROP TABLE IF EXISTS `obreiro`;
CREATE TABLE `obreiro` (
  `cod_obreiro` int(11) NOT NULL,
  `nome` varchar(15) NOT NULL,
  `apelidos` varchar(45) NOT NULL,
  `data_nasc` date NOT NULL,
  `cod_area` int(11) NOT NULL,
  `cod_turno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `obreiro`
--

INSERT INTO `obreiro` (`cod_obreiro`, `nome`, `apelidos`, `data_nasc`, `cod_area`, `cod_turno`) VALUES
(1, 'Kuenda', 'João Mayeye', '2001-10-08', 1, 2),
(2, 'Joana', 'da Costa', '2003-11-11', 2, 1);

-- --------------------------------------------------------

--
-- Table structure for table `turno`
--

DROP TABLE IF EXISTS `turno`;
CREATE TABLE `turno` (
  `cod_turno` int(11) NOT NULL,
  `horario` time NOT NULL,
  `custo` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Dumping data for table `turno`
--

INSERT INTO `turno` (`cod_turno`, `horario`, `custo`) VALUES
(1, '08:00:00', 300.00),
(2, '15:00:00', 500.00),
(3, '23:00:00', 700.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `area`
--
ALTER TABLE `area`
  ADD PRIMARY KEY (`cod_area`),
  ADD UNIQUE KEY `nome` (`nome`),
  ADD KEY `fk_area_centro` (`cod_centro`);

--
-- Indexes for table `assiduidade`
--
ALTER TABLE `assiduidade`
  ADD PRIMARY KEY (`cod_assiduidade`),
  ADD UNIQUE KEY `ui_assiduidade` (`entrada`,`saida`,`cod_obreiro`,`data_presenca`) USING BTREE,
  ADD KEY `fk_assiduidade_obreiro` (`cod_obreiro`);

--
-- Indexes for table `banco`
--
ALTER TABLE `banco`
  ADD PRIMARY KEY (`cod_banco`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indexes for table `centro_custo`
--
ALTER TABLE `centro_custo`
  ADD PRIMARY KEY (`cod_centro`),
  ADD UNIQUE KEY `nome` (`nome`);

--
-- Indexes for table `conta_bancaria`
--
ALTER TABLE `conta_bancaria`
  ADD PRIMARY KEY (`num_conta`),
  ADD KEY `fk_conta_banco` (`cod_banco`),
  ADD KEY `fk_conta_obreiro` (`cod_obreiro`);

--
-- Indexes for table `feriado`
--
ALTER TABLE `feriado`
  ADD PRIMARY KEY (`cod_feriado`);

--
-- Indexes for table `historico_pagamento`
--
ALTER TABLE `historico_pagamento`
  ADD PRIMARY KEY (`cod_pagamento`),
  ADD KEY `fk_pagamento_obreiro` (`cod_obreiro`);

--
-- Indexes for table `obreiro`
--
ALTER TABLE `obreiro`
  ADD PRIMARY KEY (`cod_obreiro`),
  ADD UNIQUE KEY `nome` (`nome`,`apelidos`),
  ADD KEY `fk_area_obreiro` (`cod_area`),
  ADD KEY `fk_turno_obreiro` (`cod_turno`);

--
-- Indexes for table `turno`
--
ALTER TABLE `turno`
  ADD PRIMARY KEY (`cod_turno`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `area`
--
ALTER TABLE `area`
  MODIFY `cod_area` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `assiduidade`
--
ALTER TABLE `assiduidade`
  MODIFY `cod_assiduidade` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `banco`
--
ALTER TABLE `banco`
  MODIFY `cod_banco` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `centro_custo`
--
ALTER TABLE `centro_custo`
  MODIFY `cod_centro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `feriado`
--
ALTER TABLE `feriado`
  MODIFY `cod_feriado` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `historico_pagamento`
--
ALTER TABLE `historico_pagamento`
  MODIFY `cod_pagamento` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `obreiro`
--
ALTER TABLE `obreiro`
  MODIFY `cod_obreiro` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `turno`
--
ALTER TABLE `turno`
  MODIFY `cod_turno` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `area`
--
ALTER TABLE `area`
  ADD CONSTRAINT `fk_area_centro` FOREIGN KEY (`cod_centro`) REFERENCES `centro_custo` (`cod_centro`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `assiduidade`
--
ALTER TABLE `assiduidade`
  ADD CONSTRAINT `fk_assiduidade_obreiro` FOREIGN KEY (`cod_obreiro`) REFERENCES `obreiro` (`cod_obreiro`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `conta_bancaria`
--
ALTER TABLE `conta_bancaria`
  ADD CONSTRAINT `fk_conta_banco` FOREIGN KEY (`cod_banco`) REFERENCES `banco` (`cod_banco`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_conta_obreiro` FOREIGN KEY (`cod_obreiro`) REFERENCES `obreiro` (`cod_obreiro`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `historico_pagamento`
--
ALTER TABLE `historico_pagamento`
  ADD CONSTRAINT `fk_pagamento_obreiro` FOREIGN KEY (`cod_obreiro`) REFERENCES `obreiro` (`cod_obreiro`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `obreiro`
--
ALTER TABLE `obreiro`
  ADD CONSTRAINT `fk_area_obreiro` FOREIGN KEY (`cod_area`) REFERENCES `area` (`cod_area`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_turno_obreiro` FOREIGN KEY (`cod_turno`) REFERENCES `turno` (`cod_turno`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
