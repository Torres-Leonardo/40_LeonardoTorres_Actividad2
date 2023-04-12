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
-- End of file.