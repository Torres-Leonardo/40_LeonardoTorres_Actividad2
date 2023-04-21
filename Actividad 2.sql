CREATE DATABASE db_SalesClothes
GO

USE db_SalesClothes
GO

SET LANGUAGE Español
GO
SELECT @@language AS 'Idioma'
GO

SET DATEFORMAT dmy
GO

CREATE TABLE client (
    id int identity(1,1),
    type_document char(3)  NOT NULL CHECK(type_document ='DNI' OR type_document ='CNE'),
    number_document char(15)  NOT NULL CHECK(number_document like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][^A-Z]'),
    name varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    email varchar(80)  NULL CHECK(email LIKE '%@%._%'),
    cell_phone char(9)  NULL CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    birthdate date  NOT NULL,
    activate bit DEFAULT (1)NOT NULL,
    CONSTRAINT CLIENTE_pk PRIMARY KEY  (id)
);

SELECT
	id as 'ITEM',
	CONCAT(UPPER(last_name), ',', name) as 'CLIENTE',
	email as 'EMAIL',
	FORMAT(birthdate, 'dd-MMM', 'es-ES') as 'CUMPLEAÑOS',
	type_document as 'TIPO DE DOCUMENTO',
	number_document as 'NÚMERO DE DOCUMENTO',
	cell_phone as 'CELULAR',
	activate as 'ACTIVIDAD'
FROM
	client
GO

INSERT INTO client 
(type_document, number_document, name, last_name, email, cell_phone, birthdate)
VALUES
('DNI', '78451233', 'Fabiola', 'Perales Campos', 'fabiolaperales@gmail.com', '991692597', '19/01/2005'),
('DNI', '14782536', 'Marcos', 'Palomino Davila', 'marcospalomino@gmail.com', '965874123', '03/03/1990'),
('DNI', '78451236', 'Luis Alberto', 'Paredes Barrios', 'luisparedes@outlook.com', '965326587', '03/10/1995'),
('CNE', '352514789', 'Claudia María', 'Rodriguez Martinez', 'claudiarodriguez@yahoo.com', '963258741', '23/09/1992'),
('CNE', '142536792', 'Mario Tadeo', 'Castillo Farfán', 'mariocastillo@outlook.com', '912345678', '25/11/1997'),
('DNI', '58251433', 'Ana Lucrecia', 'Prada Chumpitaz', 'anaprada@gmail.com', '986547122', '17/10/1992'),
('DNI', '15223369', 'Humberto', 'Tadeo Cabrera', 'humbertotadeo@yahoo.com', '996356987', '27/05/1990'),
('CNE', '442233698', 'Rosario', 'Velasquez Prada', 'rosariovelasquez@outlook.com', '999665823', '05/11/1990')

CREATE TABLE seller (
    id int identity(1,1),
    type_document char(3)  NOT NULL CHECK(type_document ='DNI' OR type_document ='CNE'),
	number_document char(15)  NOT NULL,
    name varchar(60)  NOT NULL,
    last_name varchar(90)  NOT NULL,
    cell_phone Char(9)  NULL CHECK (cell_phone like '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]'),
    email varchar(80)  NULL CHECK(email LIKE '%@%._%'),
    salary decimal(8,2)  NOT NULL DEFAULT (1025),
    activate bit DEFAULT (1)NOT NULL,
    CONSTRAINT VENDEDOR_pk PRIMARY KEY  (id)
);

SELECT
	id as 'ITEM',
	type_document as 'TIPO DE DOCUMENTO',
	number_document as 'NÚMERO DE DOCUMENTO',
	CONCAT(UPPER(last_name), ',', name) as 'CLIENTE',
	cell_phone as 'CELULAR',
	email as 'EMAIL',
	salary as 'SALARIO',
	activate as 'ACTIVIDAD'
	
FROM
	seller
GO

INSERT INTO seller 
(type_document, number_document, name, last_name, cell_phone, email)
VALUES
('DNI', '11224578', 'Oscar', 'Flores Paredes', '985621456', 'oflores@miempresa.com' ),
('CNE', '8899223365', 'Azucena', 'Alcazar Valle', '976431269', 'aalcazar@miempresa.com' ),
('DNI', '44771123', 'Rosario', 'Tarazona Huarca', '963236125','rtarazona@miempresa.com')
GO

CREATE TABLE clothes (
    id int identity(1,1),
    description varchar(90)  NOT NULL,
    brand varchar(60)  NOT NULL,
    amount int  NOT NULL,
    size varchar(10)  NOT NULL,
    price decimal(8,2)  NOT NULL,
    active bit  DEFAULT (1)NOT NULL,
    CONSTRAINT PRENDA_pk PRIMARY KEY  (id)
);

SELECT
id as 'ITEM',
description as 'DESCIPCIÓN',
brand as 'MARCA',
amount as 'CANTIDAD',
size as 'TAMAÑO',
price as 'PRECIO',
active as 'ACTIVIDAD'
FROM clothes
GO

INSERT INTO clothes
(description, brand, amount, size, price)
VALUES
('Polo camisero', 'Adidas', '20', 'Medium', '40.50'),
('Short playero', 'Nike', '30', 'Medium', '55.50' ),
('Camisa sport', 'Adams', '60', 'Large', '60.80'),
('Camisa sport', 'Adams', '70', 'Medium', '58.75'),
('Buzo de verano', 'Reebok', '45', 'Small', '62.90'),
('Pantalón Jean', 'Lewis', '35', 'Large', '73.60')
GO