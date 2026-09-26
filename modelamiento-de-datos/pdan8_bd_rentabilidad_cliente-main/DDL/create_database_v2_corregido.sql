-- Crear las tablas en una base nueva o vacia. No actualiza tablas existentes.
IF DB_ID(N'pdan_8_rentabilidad_cliente_v2') IS NULL
    EXEC(N'CREATE DATABASE pdan_8_rentabilidad_cliente_v2');
GO

USE pdan_8_rentabilidad_cliente_v2;
GO
SET XACT_ABORT ON;

IF EXISTS (
    SELECT 1 FROM sys.tables
    WHERE schema_id = SCHEMA_ID(N'dbo')
      AND name IN (
          'segmentos', 'canales', 'categoria_productos', 'productos',
          'clientes', 'personas_juridicas', 'personas_naturales',
          'periodos', 'contrataciones', 'operaciones', 'costos', 'ingresos'
      )
)
BEGIN
    ;THROW 50001, 'La base v2 ya contiene tablas del proyecto. No se modifico su estructura. Este script es para una instalacion nueva.', 1;
END;

BEGIN TRY
    BEGIN TRANSACTION;
--- Segmentos

CREATE TABLE dbo.segmentos(
id INT IDENTITY(1,1) PRIMARY KEY,
codigo CHAR(6) UNIQUE NOT NULL,
nombre VARCHAR (55) NOT NULL,
descripcion VARCHAR (255) NULL
);

---- Tabla canales

CREATE TABLE dbo.canales(
	id INT IDENTITY(1,1) PRIMARY KEY,
	codigo CHAR(6) UNIQUE NOT NULL,
	nombre VARCHAR(55) NOT NULL,
	descripcion VARCHAR (255) NULL
);


--- tabla categoria productos 

create table dbo.categoria_productos(
	id int identity(1,1) primary key,
	codigo char(6) unique not null,
	nombre varchar(55) not null,
	descripcion varchar(255) null
);


--- Productos

CREATE TABLE dbo.productos(
	id INT IDENTITY (1,1) PRIMARY KEY,
	codigo CHAR(6) UNIQUE NOT NULL,
	nombre VARCHAR(55) NOT NULL,
	categoria_id INT NOT NULL,
	tipo_producto VARCHAR(30) NULL,
	moneda VARCHAR(25) CHECK (moneda IN ('PEN','USD', 'EUR')) NOT NULL,
	estado VARCHAR(25)  NOT NULL,
	CONSTRAINT fk_categoria_productos FOREIGN KEY (categoria_id) REFERENCES dbo.categoria_productos(id)
	);

ALTER TABLE dbo.productos
ADD CONSTRAINT CK_productos_estado CHECK (estado IN ('activo', 'inactivo', 'discontinuado'));
--- clientes

CREATE TABLE dbo.clientes (
	id INT IDENTITY (1,1) PRIMARY KEY,
	codigo CHAR(6) UNIQUE NOT NULL,
	tipo_cliente VARCHAR(1) NOT NULL,
	fecha_alta DATE DEFAULT(CONVERT(DATE,GETDATE())),
	estado VARCHAR (25) NOT NULL,
	segmento_id INT NOT NULL,	
	FOREIGN KEY (segmento_id) REFERENCES dbo.segmentos(id)
);

ALTER TABLE dbo.clientes
ADD CONSTRAINT CK_clientes_tipo CHECK (tipo_cliente IN ('N','J'));

ALTER TABLE dbo.clientes
ADD CHECK (estado IN ('activo', 'inactivo', 'bloqueado'));

-- Persona Juridica
CREATE TABLE dbo.personas_juridicas (
id INT IDENTITY (1,1) PRIMARY KEY,
ruc CHAR (11) NOT NULL UNIQUE,
razon_social VARCHAR(255) NOT NULL UNIQUE,
telefono VARCHAR(20) NULL,
direccion_fiscal VARCHAR(255) NULL,
rubro VARCHAR(55) NULL,
cliente_id INT NOT NULL UNIQUE,
FOREIGN KEY (cliente_id) REFERENCES dbo.clientes (id)
);
-- Persona Natural

CREATE TABLE dbo.personas_naturales (
id INT IDENTITY (1,1) PRIMARY KEY,
dni CHAR(8) UNIQUE NOT NULL,
nombres VARCHAR(155) NOT NULL,
app VARCHAR(155) NOT NULL,	
apm VARCHAR(155) NOT NULL,
telefono VARCHAR(20) NULL,
direccion VARCHAR (200) NULL,
rubro VARCHAR (55) NULL,
cliente_id INT UNIQUE NOT NULL,
FOREIGN KEY (cliente_id) REFERENCES dbo.clientes (id)
);

--- periodos

CREATE TABLE dbo.periodos (
id INT IDENTITY (1,1) PRIMARY KEY,
anio CHAR(4) NOT NULL,
mes CHAR(2) NOT NULL,
UNIQUE (anio,mes)
);
 

--- contrataciones

CREATE TABLE dbo.contrataciones (
id INT IDENTITY (1,1) PRIMARY KEY,
cliente_id INT NOT NULL,
producto_id INT NOT NULL,
fecha_contratacion DATETIME NOT NULL,
fecha_cancelacion DATETIME NULL,
estado VARCHAR(55) CHECK(estado IN('activo','cancelado')),
FOREIGN KEY (producto_id) REFERENCES dbo.productos(id),
FOREIGN KEY (cliente_id) REFERENCES dbo.clientes(id)
);

-- operaciones
CREATE TABLE dbo.operaciones
( id INT IDENTITY(1,1) NOT NULL, 
cliente_id INT NOT NULL, 
canal_id INT NOT NULL,
contratacion_id INT NOT NULL,
fecha_operacion DATETIME NOT NULL,
tipo_operacion VARCHAR (100) NOT NULL,
importe DECIMAL(18,2) NOT NULL,
estado VARCHAR(20) NOT NULL,
CONSTRAINT PK_operaciones PRIMARY KEY (id),
CONSTRAINT FK_operaciones_contrataciones FOREIGN KEY (contratacion_id) REFERENCES dbo.contrataciones(id), 
CONSTRAINT FK_operaciones_clientes FOREIGN KEY (cliente_id) REFERENCES dbo.clientes(id),
CONSTRAINT FK_operaciones_canales FOREIGN KEY (canal_id) REFERENCES dbo.canales(id), 
CONSTRAINT CK_operaciones_importe CHECK (importe >= 0), 
CONSTRAINT CK_operaciones_estado CHECK (estado IN ('pendiente', 'procesada', 'anulada')),
CONSTRAINT CK_tipo_operacion CHECK (tipo_operacion IN ('Compra','Transferencia','Retiro','Pago')) 
);



--- Costos

CREATE TABLE dbo.costos (
    id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    tipo_costo VARCHAR(100) NOT NULL,
    periodo_id INT NOT NULL,
    importe DECIMAL(12,2) CHECK (importe >= 0) NOT NULL,
	FOREIGN KEY (cliente_id) REFERENCES dbo.clientes(id),
	FOREIGN KEY (producto_id) REFERENCES dbo.productos(id),
	FOREIGN KEY (periodo_id) REFERENCES dbo.periodos(id),
	CHECK (
    tipo_costo IN (
        'operativo',
        'procesamiento',
        'canal',
        'administrativo'
    )
)
	);
--- Ingresos
	CREATE TABLE dbo.ingresos (
    id INT IDENTITY(1,1) NOT NULL,
    cliente_id INT NOT NULL,
    producto_id INT NOT NULL,
    periodo_id INT NOT NULL,
	importe DECIMAL(12,2) CHECK (importe >= 0) NOT NULL,
    CONSTRAINT PK_ingresos PRIMARY KEY (id),
    CONSTRAINT FK_ingresos_clientes 
        FOREIGN KEY (cliente_id) REFERENCES dbo.clientes(id),
    CONSTRAINT FK_ingresos_productos 
        FOREIGN KEY (producto_id) REFERENCES dbo.productos(id),
    CONSTRAINT FK_ingresos_periodos 
        FOREIGN KEY (periodo_id) REFERENCES dbo.periodos(id)
);
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
GO
