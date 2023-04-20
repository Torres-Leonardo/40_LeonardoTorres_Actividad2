/* Si la base de datos ya existe la eliminamos */
DROP DATABASE IF EXISTS db_SalesClothes;

/* Crear base de datos Sales Clothes */
CREATE DATABASE db_SalesClothes;

/* Poner en uso la base de datos */
USE db_SalesClothes;

-- Table: client
CREATE TABLE client (
    id int  NOT NULL,
    type_document char(3)  NOT NULL,
    number_document char(15)  NOT NULL,
    name varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    email varchar(80)  NULL,
    cell_phone char(9)  NULL,
    birthdate date  NOT NULL,
    activate bit  NOT NULL,
    CONSTRAINT CLIENTE_pk PRIMARY KEY  (id)
);

-- Table: clothes
CREATE TABLE clothes (
    id int  NOT NULL,
    description varchar(90)  NOT NULL,
    brand varchar(60)  NOT NULL,
    amount int  NOT NULL,
    size varchar(10)  NOT NULL,
    price decimal(8,2)  NOT NULL,
    active bit  NOT NULL,
    CONSTRAINT PRENDA_pk PRIMARY KEY  (id)
);

-- Table: sale
CREATE TABLE sale (
    id int  NOT NULL,
    date_time datetime  NOT NULL,
    activate bit  NOT NULL,
    client_id int  NOT NULL,
    seller_id int  NOT NULL,
    CONSTRAINT VENTA_pk PRIMARY KEY  (id)
);

-- Table: sale_detail
CREATE TABLE sale_detail (
    id int  NOT NULL,
    amount int  NOT NULL,
    clothes_id int  NOT NULL,
    sale_id int  NOT NULL,
    CONSTRAINT sale_detail_pk PRIMARY KEY  (id)
);

-- Table: seller
CREATE TABLE seller (
    id int  NOT NULL,
    type_document char(3)  NOT NULL,
    number_document char(15)  NOT NULL,
    name varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    salary decimal(8,2)  NOT NULL,
    cell_phone Char(9)  NULL,
    email varchar(80)  NULL,
    activate bit  NOT NULL,
    CONSTRAINT VENDEDOR_pk PRIMARY KEY  (id)
);

-- End of file.

-- foreign keys
-- Reference: VENTA_CLIENTE (table: sale)
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

-- Reference: VENTA_VENDEDOR (table: seller)
ALTER TABLE sale
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
	REFERENCES seller (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

-- Reference: VENTA_DETALLE_ROPA (table: clothes)
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_clothes FOREIGN KEY (clothes_id)
	REFERENCES clothes (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

-- Reference: VENTA_DETALLE_VENTA (table: sale)
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES sale (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Ver relaciones creadas entre las tablas de la base de datos */
SELECT 
    fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO

/* Eliminar una relación */
ALTER TABLE sale_detail
	DROP CONSTRAINT sale_detail_seller
GO

/* Ver SQL Collate en SQL Server */
SELECT SERVERPROPERTY('collation') AS ServerCollation
GO

/* Ver idioma de SQL Server */
SELECT @@language AS 'Idioma'
GO

/* Ver idiomas disponibles en SQL Server */
EXEC sp_helplanguage
GO

/* Configurar idioma español en el servidor */
SET LANGUAGE Español
GO
SELECT @@language AS 'Idioma'
GO

/* Ver formato de fecha y hora del servidor */
SELECT sysdatetime() as 'Fecha y  hora'
GO

/* Configurar el formato de fecha */
SET DATEFORMAT dmy
GO

/* Listar tablas de la base de datos db_SalesClothes */
SELECT * FROM INFORMATION_SCHEMA.TABLES
GO

/* Ver estructura de una tabla */
EXEC sp_help 'dbo.client'
GO

/* Ver relaciones creadas entre las tablas de la base de datos */
SELECT 
    fk.name [Constraint],
    OBJECT_NAME(fk.parent_object_id) [Tabla],
    COL_NAME(fc.parent_object_id,fc.parent_column_id) [Columna FK],
    OBJECT_NAME (fk.referenced_object_id) AS [Tabla base],
    COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS [Columna PK]
FROM 
    sys.foreign_keys fk
    INNER JOIN sys.foreign_key_columns fc ON (fk.OBJECT_ID = fc.constraint_object_id)
GO

/*CLIENTE*/

/* Eliminar relación sale_client */
ALTER TABLE sale
	DROP CONSTRAINT sale_client
GO

/* Quitar Primary Key en tabla client */
ALTER TABLE client
	DROP CONSTRAINT CLIENTE_pk
GO

/* Quitar columna id en tabla cliente */
ALTER TABLE client
	DROP COLUMN id
GO

/* Agregar columna client */
ALTER TABLE client
	ADD id int identity(1,1)
GO

/* Agregar restricción primary key */
ALTER TABLE client
	ADD CONSTRAINT client_pk 
	PRIMARY KEY (id)
GO

/* Relacionar tabla sale con tabla client */
ALTER TABLE sale
	ADD CONSTRAINT sale_client FOREIGN KEY (client_id)
	REFERENCES client (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* El tipo de documento puede ser DNI ó CNE */
ALTER TABLE client
	DROP COLUMN type_document
GO

/* Agregar restricción para tipo documento */
ALTER TABLE client
	ADD type_document char(3)
	CHECK( type_document ='DNI' OR type_document ='CNE')
GO

/* Eliminar columna number_document de tabla client */
ALTER TABLE client
	DROP COLUMN number_document
GO

/* El número de documento sólo debe permitir dígitos de 0 - 9 */
ALTER TABLE client
	ADD number_document char(9)
	CONSTRAINT number_document_client
	CHECK (number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]')
GO

/* Eliminar columna email de tabla client */
ALTER TABLE client
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE client
	ADD email varchar(80)
	CONSTRAINT email_client
	CHECK(email LIKE '%@%._%')
GO

/* Eliminar columna celular */
ALTER TABLE client
	DROP COLUMN cell_phone
GO

/* Validar que el celular esté conformado por 9 números */
ALTER TABLE client
	ADD cell_phone char(9)
	CONSTRAINT cellphone_client
	CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

/* Eliminar columna fecha de nacimiento */
ALTER TABLE client
	DROP COLUMN birthdate
GO

/* Sólo debe permitir el registro de clientes mayores de edad */
ALTER TABLE client
	ADD  birthdate date
	CONSTRAINT birthdate_client
	CHECK((YEAR(GETDATE())- YEAR(birthdate )) >= 18)
GO

/* Eliminar columna active de tabla client */
ALTER TABLE client
	DROP COLUMN activate
GO

/* El valor predeterminado será activo al registrar clientes */
ALTER TABLE client
	ADD active bit DEFAULT (1)
GO

/* Listar las restricciones de la tabla client */
SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS 
WHERE TABLE_NAME = 'client'
GO

/* Insertar 6 registros */
INSERT INTO client 
(type_document, number_document, name, last_name, email, cell_phone, birthdate)
VALUES
('DNI', '78451233', 'Fabiola', 'Perales Campos', 'fabiolaperales@gmail.com', '991692597', '19/01/2005'),
('DNI', '14782536', 'Marcos', 'Dávila Palomino', 'marcosdavila@gmail.com', '982514752', '03/03/1990'),
('DNI', '78451236', 'Luis Alberto', 'Barrios Paredes', 'luisbarrios@outlook.com', '985414752', '03/10/1995'),
('CNE', '352514789', 'Claudia María', 'Martínez Rodríguez', 'claudiamartinez@yahoo.com', '995522147', '23/09/1992'),
('CNE', '142536792', 'Mario Tadeo', 'Farfán Castillo', 'mariotadeo@outlook.com', '973125478', '25/11/1997'),
('DNI', '58251433', 'Ana Lucrecia', 'Chumpitaz Prada', 'anachumpitaz@gmail.com', '982514361', '17/10/1992')
GO

/* Listar registros de tabla client */
SELECT * FROM client 
GO

/* Listar apellidos, nombres, celular y fecha de nacimiento */
SELECT
	last_name as 'APELLIDOS',
	name as 'NOMBRES',
	cell_phone as 'CELULAR',
	format(birthdate, 'd', 'es-ES') as 'FEC. NACIMIENTO'
FROM
	client
GO

/* Listar apellidos, nombres, email y celular de clientes que tienen DNI y su respectivo número*/
SELECT
	last_name as 'APELLIDOS',
	name as 'NOMBRE',
	email as 'EMAIL',
	type_document as 'DOCUMENTO',
	number_document as '# DOC.'
FROM
	client
WHERE
	type_document = 'DNI'
GO

/* Listar apellidos, nombres, edad, email y fecha de cumpleaños */
SELECT
	id as 'ITEM',
	CONCAT(UPPER(last_name), ',', name) as 'CLIENTE',
	(YEAR(GETDATE()) - YEAR(birthdate)) as 'EDAD',
	email as 'EMAIL',
	FORMAT(birthdate, 'dd-MMM', 'es-ES') as 'CUMPLEAÑOS'
FROM
	client 
GO

/* Eliminar lógicamente el cliente cuyo DNI es 58251433  */
UPDATE client
SET active = '0' 
WHERE number_document = '58251433'
GO

/* Listar clientes */
SELECT * FROM client
GO

/* La fecha de nacimiento de Marcos Dávila Palomino es el 16/06/1989 */
UPDATE client 
SET birthdate = '16/06/1989'
WHERE name = 'Marcos' and last_name = 'Dávila Palomino'
GO

/* Listar los nuevos datos de Marcos Dávila Palomino */
SELECT * FROM client 
WHERE name = 'Marcos' AND last_name = 'Dávila Palomino'
GO

UPDATE client
SET cell_phone = '977815352'
WHERE type_document = 'CNE' AND number_document = '142536792'
GO

/* Verificar que el cambio de celular se ha realizado */
SELECT 
       * 
FROM CLIENT
WHERE cell_phone = '977815352'
GO

/* El nuevo número de celular del cliente de CNE # 142536792 es 977815352 */
UPDATE client
SET cell_phone = '977815352'
WHERE type_document = 'CNE' AND number_document = '142536792'
GO

/* Verificar que el cambio de celular se ha realizado */
SELECT 
       * 
FROM CLIENT
WHERE cell_phone = '977815352'
GO

/* Eliminar físicamente los clientes nacidos en el año 1992 */
 DELETE FROM client 
 WHERE YEAR (birthdate) = '1992'
 GO

/* Listar clientes y verificar */
 SELECT * FROM client
 GO

/* Eliminar cliente de número de celular 991692597 */
DELETE FROM client
WHERE cell_phone = '991692597'
GO

/* Verificar la eliminación listando los registros */
SELECT * FROM client
GO

/* Eliminar los registros de la tabla cliente */
DELETE FROM client
GO

/* Listar los registros de la tabla cliente */
SELECT * FROM client
GO

/*SELLER*/

/* Eliminar relación sale_seller*/
ALTER TABLE sale
	DROP CONSTRAINT sale_seller
GO


/* Quitar Primary Key en tabla vendedor */
ALTER TABLE seller
	DROP CONSTRAINT VENDEDOR_pk
GO

/* Quitar columna id en tabla vendedor */
ALTER TABLE seller
	DROP COLUMN id
GO

/* Agregar columna client */
ALTER TABLE seller
	ADD id int identity(1,1)
GO

/* Agregar restricción primary key */
ALTER TABLE seller
	ADD CONSTRAINT VENDEDOR_pk 
	PRIMARY KEY (id)
GO

/* Relacionar tabla sale con tabla vendedor */
ALTER TABLE sale
	ADD CONSTRAINT sale_seller FOREIGN KEY (seller_id)
	REFERENCES seller (id)
	ON UPDATE CASCADE 
    ON DELETE CASCADE
GO

/* El tipo de documento puede ser DNI ó CNE */
ALTER TABLE seller
	DROP COLUMN type_document
GO

/* Agregar restricción para tipo documento */
ALTER TABLE seller
	ADD type_document char(3)
	CONSTRAINT type_document 
	CHECK( type_document ='DNI' OR type_document ='CNE')
GO

/* Eliminar columna number_document de tabla seller */
ALTER TABLE seller
	DROP COLUMN number_document
GO

/* El número de documento sólo debe permitir dígitos de 0 - 9 */
ALTER TABLE seller
	ADD number_document char(9)
	CHECK (number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]')
GO

/*Salario por default en tabla seller*/
ALTER TABLE seller
	ADD salary bit DEFAULT (1025)
GO

/* Eliminar columna celular */
ALTER TABLE seller
	DROP COLUMN cell_phone
GO

/* Validar que el celular esté conformado por 9 números */
ALTER TABLE seller
	ADD cell_phone char(9)
	CONSTRAINT cellphone_seller
	CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
GO

/* Eliminar columna email de tabla seller */
ALTER TABLE seller
	DROP COLUMN email
GO

/* Agregar columna email */
ALTER TABLE seller
	ADD email varchar(80)
	CONSTRAINT email_seller
	CHECK(email LIKE '%@%._%')
GO

/*Activación por default en tabla seller*/
ALTER TABLE seller
	ADD active bit DEFAULT (1)
GO

/*CLOTHES*/

/* Quitar Primary Key en tabla clothes */
ALTER TABLE clothes
	DROP CONSTRAINT PRENDAS_pk
GO

/* Quitar columna id en tabla clothes */
ALTER TABLE clothes
	DROP COLUMN id
GO

/* Agregar columna id en tabla clothes */
ALTER TABLE clothes
	ADD id int identity(1,1)
GO

/* Agregar restricción primary key */
ALTER TABLE clothes
	ADD CONSTRAINT PRENDAS_pk 
	PRIMARY KEY (id)
GO

/* Relacionar tabla sale con tabla clothes */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_clothes FOREIGN KEY (clothes_id)
	REFERENCES clothes (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/* Eliminar columna active de tabla clothes */
ALTER TABLE clothes
	DROP COLUMN active
GO

/*Default de activos en tabla clothes*/
ALTER TABLE clothes
	ADD active bit DEFAULT (1)
GO

/*SALE*/

/* Eliminar relación sale_client */
ALTER TABLE sale_detail
	DROP CONSTRAINT sale_detail_sale
GO

/* Quitar Primary Key en tabla sale */
ALTER TABLE sale
	DROP CONSTRAINT VENTA_pk
GO

/* Quitar columna id en tabla sale */
ALTER TABLE sale
	DROP COLUMN id
GO

/* Agregar columna id en tabla sale */
ALTER TABLE sale
	ADD id int identity(1,1)
GO

/* Agregar restricción primary key */
ALTER TABLE sale
	ADD CONSTRAINT VENTA_pk 
	PRIMARY KEY (id)
GO

/* Relacionar tabla sale con tabla sale */
ALTER TABLE sale_detail
	ADD CONSTRAINT sale_detail_sale FOREIGN KEY (sale_id)
	REFERENCES sale (id)
	ON UPDATE CASCADE 
      ON DELETE CASCADE
GO

/*Eliminar date_time en tabla sale*/
ALTER TABLE sale
DROP COLUMN date_time

/*Crear date_time en tabla sale*/
ALTER TABLE sale
    ADD date_time DATETIME DEFAULT GETDATE();