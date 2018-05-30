#-------------------------------------------------------------
-- FILENAME :
-- 		main-db.sql
-- DESCRIPTION :
-- 		* Insert the main database and copy structures
-- NOTES :
-- 		* Don't manipulate tables
-- 		* Only set tables
#-------------------------------------------------------------

-- Criando banco de dados e definindo suas regras.
CREATE DATABASE IF NOT EXISTS `main-db`
DEFAULT CHARSET utf8
DEFAULT COLLATE utf8_general_ci;

USE `main-db`;