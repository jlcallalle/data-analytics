USE pdan_8_rentabilidad_cliente;
GO

SET NOCOUNT ON;
SET XACT_ABORT ON;

DECLARE @Seed INT = 123456789;
DECLARE @NumClientes INT = 1500;
DECLARE @TargetOperaciones INT = 100000;
DECLARE @TargetIngresos INT = 40000;
DECLARE @TargetCostos INT = 30000;
DECLARE @PeriodoInicio DATE = '2025-01-01';
DECLARE @PeriodoFin DATE = '2026-12-01';
DECLARE @MaxDate DATE = '2026-12-31';

------------------------------------------------------------
-- 0. LIMPIEZA
-- Este script está preparado para cargar un escenario desde cero.
-- Si NO desea borrar datos existentes, elimine esta sección.
------------------------------------------------------------
BEGIN TRY
    BEGIN TRAN;

    DELETE FROM costos;
    DELETE FROM ingresos;
    DELETE FROM operaciones;
    DELETE FROM contrataciones;
    DELETE FROM personas_naturales;
    DELETE FROM personas_juridicas;
    DELETE FROM clientes;
    DELETE FROM productos;
    DELETE FROM periodos;
    DELETE FROM categoria_productos;
    DELETE FROM canales;
    DELETE FROM segmentos;

    DBCC CHECKIDENT ('costos', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('ingresos', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('operaciones', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('contrataciones', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('personas_naturales', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('personas_juridicas', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('clientes', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('productos', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('periodos', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('categoria_productos', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('canales', RESEED, 0) WITH NO_INFOMSGS;
    DBCC CHECKIDENT ('segmentos', RESEED, 0) WITH NO_INFOMSGS;

    COMMIT;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK;
    THROW;
END CATCH;

------------------------------------------------------------
-- 1. TABLA TALLY
-- Se crea sin GO para que #Tally y las variables sobrevivan
-- durante todo el script.
------------------------------------------------------------
;WITH E1(n) AS
(
    SELECT 1
    FROM (VALUES (1),(1),(1),(1),(1),(1),(1),(1),(1),(1)) v(n)
),
E2(n) AS
(
    SELECT 1 FROM E1 a CROSS JOIN E1 b
),
E4(n) AS
(
    SELECT 1 FROM E2 a CROSS JOIN E2 b
)
SELECT TOP (200000)
       ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
INTO #Tally
FROM E4 a
CROSS JOIN E2 b
CROSS JOIN E1 c;

CREATE UNIQUE CLUSTERED INDEX IX_Tally_n ON #Tally(n);

------------------------------------------------------------
-- 2. CATÁLOGOS
-- Los IDs son generados automáticamente por IDENTITY.
------------------------------------------------------------

INSERT INTO segmentos (codigo, nombre, descripcion)
VALUES
('SEG001','Básico','Segmento de clientes con productos básicos y bajo uso'),
('SEG002','Masivo','Clientes masivos con actividad moderada'),
('SEG003','Preferente','Clientes con mayor fidelidad y actividad'),
('SEG004','Premium','Clientes premium con alto uso y saldos'),
('SEG005','Patrimonial','Clientes patrimoniales con grandes saldos'),
('SEG006','Microempresa','Microempresas con necesidades básicas'),
('SEG007','Pequeña Empresa','Pequeñas empresas con crecimiento'),
('SEG008','Mediana Empresa','Medianas empresas con operaciones regulares'),
('SEG009','Gran Empresa','Grandes empresas con alto volumen'),
('SEG010','Corporativo','Cuentas corporativas y conglomerados');



INSERT INTO canales (codigo, nombre, descripcion)
VALUES
('CAN001','Banca Móvil','Canal móvil (app)'),
('CAN002','Banca Internet','Portal web'),
('CAN003','POS','Terminal punto de venta'),
('CAN004','Cajero Automático','ATM'),
('CAN005','Agencia','Sucursal física'),
('CAN006','Call Center','Atención telefónica'),
('CAN007','Oficina Empresas','Relación empresarial'),
('CAN008','API Partners','Integraciones y partners');



INSERT INTO categoria_productos (codigo, nombre, descripcion)
VALUES
('CAT001','Cuentas','Productos de cuentas corrientes y ahorro'),
('CAT002','Tarjetas','Tarjetas de débito y crédito'),
('CAT003','Préstamos','Préstamos personales y de consumo'),
('CAT004','Créditos','Créditos comerciales y vehiculares'),
('CAT005','Depósitos','Depósitos a plazo y certificados'),
('CAT006','Servicios','Servicios asociados'),
('CAT007','Inversiones','Fondos e instrumentos de inversión'),
('CAT008','Otros','Otros productos financieros');


------------------------------------------------------------
-- 3. PRODUCTOS
------------------------------------------------------------

INSERT INTO productos
(codigo, nombre, categoria_id, tipo_producto, moneda, estado)
VALUES
('PRD001','Cuenta Ahorros Básica',1,'Cuenta','PEN','activo'),
('PRD002','Cuenta Ahorros Premium',1,'Cuenta','PEN','activo'),
('PRD003','Cuenta Corriente Empresa',1,'Cuenta','PEN','activo'),
('PRD004','Tarjeta Clásica',2,'Tarjeta','PEN','activo'),
('PRD005','Tarjeta Oro',2,'Tarjeta','PEN','activo'),
('PRD006','Tarjeta Platinum',2,'Tarjeta','PEN','activo'),
('PRD007','Préstamo Personal',3,'Préstamo','PEN','activo'),
('PRD008','Crédito Vehicular',4,'Crédito','PEN','activo'),
('PRD009','Crédito Hipotecario',4,'Crédito','PEN','activo'),
('PRD010','Crédito Capital Trabajo',4,'Crédito','PEN','activo'),
('PRD011','Depósito a Plazo 6m',5,'Depósito','PEN','activo'),
('PRD012','Depósito a Plazo 12m',5,'Depósito','PEN','activo'),
('PRD013','Seguro Básico',6,'Servicio','PEN','activo'),
('PRD014','Seguro Premium',6,'Servicio','PEN','activo'),
('PRD015','Fondo Renta',7,'Inversión','PEN','activo'),
('PRD016','Fondo Crecimiento',7,'Inversión','PEN','activo'),
('PRD017','Cuenta Nómina',1,'Cuenta','PEN','activo'),
('PRD018','Tarjeta Empresarial',2,'Tarjeta','PEN','activo'),
('PRD019','Cobranza Factoring',8,'Otros','PEN','activo'),
('PRD020','Pago de Nómina MAS',8,'Otros','PEN','activo');


------------------------------------------------------------
-- 4. PERIODOS: enero 2025 a diciembre 2026
-- Corrección importante: el script original comenzaba en
-- septiembre 2025 por una referencia incorrecta a GETDATE().
------------------------------------------------------------

;WITH Months AS
(
    SELECT @PeriodoInicio AS dt
    UNION ALL
    SELECT DATEADD(MONTH,1,dt)
    FROM Months
    WHERE DATEADD(MONTH,1,dt) <= @PeriodoFin
)
INSERT INTO periodos (anio, mes)
SELECT
       CONVERT(CHAR(4),YEAR(dt)),
       RIGHT('0' + CONVERT(VARCHAR(2),MONTH(dt)),2)
FROM Months
OPTION (MAXRECURSION 100);


------------------------------------------------------------
-- 5. CLIENTES
------------------------------------------------------------
DECLARE @SegmentWeights TABLE
(
    segmento_id INT PRIMARY KEY,
    peso INT NOT NULL
);

INSERT INTO @SegmentWeights
VALUES
(1,18),(2,20),(3,12),(4,5),(5,4),
(6,8),(7,10),(8,9),(9,6),(10,8);


;WITH N AS
(
    SELECT TOP (@NumClientes)
           ROW_NUMBER() OVER (ORDER BY n) AS rn
    FROM #Tally
),
ClientesGen AS
(
    SELECT
        rn,
        RIGHT('C' + FORMAT(rn,'00000'),6) AS codigo,
        CASE
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-CLIENT-TYPE-',rn))) % 100 < 80
            THEN 'N' ELSE 'J'
        END AS tipo_cliente,
        DATEADD
        (
            DAY,
            ABS(CHECKSUM(CONCAT(@Seed,'-CLIENT-DATE-',rn))) % 3200,
            CONVERT(DATE,'2018-01-01')
        ) AS fecha_alta_raw,
        CASE
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-CLIENT-EST-',rn))) % 100 < 2
                THEN 'bloqueado'
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-CLIENT-EST-',rn))) % 100 < 8
                THEN 'inactivo'
            ELSE 'activo'
        END AS estado
    FROM N
)
INSERT INTO clientes
(codigo,tipo_cliente,fecha_alta,estado,segmento_id)
SELECT
    cg.codigo,
    cg.tipo_cliente,
    CASE
        WHEN cg.fecha_alta_raw > @MaxDate THEN @MaxDate
        ELSE cg.fecha_alta_raw
    END,
    cg.estado,
    sw.segmento_id
FROM ClientesGen cg
CROSS APPLY
(
    SELECT TOP (1) segmento_id
    FROM
    (
        SELECT
            segmento_id,
            SUM(peso) OVER (ORDER BY segmento_id) AS acumulado,
            SUM(peso) OVER () AS total_peso
        FROM @SegmentWeights
    ) w
    WHERE
        ABS(CHECKSUM(CONCAT(@Seed,'-CLIENT-SEG-',cg.rn))) % total_peso < acumulado
    ORDER BY segmento_id
) sw;


------------------------------------------------------------
-- 6. PERSONAS NATURALES
------------------------------------------------------------
DECLARE @Nombres TABLE (n VARCHAR(50));
INSERT INTO @Nombres
VALUES
('Carlos'),('María'),('José'),('Ana'),('Luis'),('Paola'),
('Jorge'),('Sofía'),('Diego'),('Andrea'),('Roberto'),('Valeria'),
('Fernando'),('Camila'),('Miguel'),('Laura'),('Andrés'),('Lucía'),
('Hugo'),('Rocío');

DECLARE @Apellidos TABLE (n VARCHAR(50));
INSERT INTO @Apellidos
VALUES
('García'),('Rodríguez'),('Martínez'),('López'),('Hernández'),
('Pérez'),('Gómez'),('Sánchez'),('Díaz'),('Torres'),
('Ramírez'),('Flores'),('Rivera'),('Vargas'),('Rojas'),
('Castillo'),('Medina'),('Ortiz'),('Cruz'),('Muñoz');


;WITH PN AS
(
    SELECT
        c.id AS cliente_id,
        10000000 + ((c.id * 7919) % 89999999) AS dni,
        CONCAT('9',RIGHT('00000000' +
            CONVERT(VARCHAR(8),ABS(CHECKSUM(CONCAT(@Seed,'-PHONE-',c.id))) % 100000000),8)) AS telefono,
        CONCAT('Av. Ficticia ',1 + ABS(CHECKSUM(CONCAT(@Seed,'-DIR-',c.id))) % 999) AS direccion,
        CASE
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-RUBRO-',c.id))) % 3 = 0 THEN 'Comercio'
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-RUBRO-',c.id))) % 3 = 1 THEN 'Servicios'
            ELSE 'Profesional'
        END AS rubro
    FROM clientes c
    WHERE c.tipo_cliente = 'N'
)
INSERT INTO personas_naturales
(dni,nombres,app,apm,telefono,direccion,rubro,cliente_id)
SELECT
    CONVERT(CHAR(8),pn.dni),
    n1.n,
    a1.n,
    a2.n,
    pn.telefono,
    pn.direccion,
    pn.rubro,
    pn.cliente_id
FROM PN pn
CROSS APPLY
(
    SELECT n
    FROM
    (
        SELECT n, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM @Nombres
    ) x
    WHERE rn = 1 + ABS(CHECKSUM(CONCAT(@Seed,'-PNAM-',pn.cliente_id))) % 20
) n1
CROSS APPLY
(
    SELECT n
    FROM
    (
        SELECT n, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM @Apellidos
    ) x
    WHERE rn = 1 + ABS(CHECKSUM(CONCAT(@Seed,'-PAPP-',pn.cliente_id))) % 20
) a1
CROSS APPLY
(
    SELECT n
    FROM
    (
        SELECT n, ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
        FROM @Apellidos
    ) x
    WHERE rn = 1 + ABS(CHECKSUM(CONCAT(@Seed,'-PAPM-',pn.cliente_id))) % 20
) a2;


------------------------------------------------------------
-- 7. PERSONAS JURÍDICAS
------------------------------------------------------------

INSERT INTO personas_juridicas
(ruc,razon_social,telefono,direccion_fiscal,rubro,cliente_id)
SELECT
    CONCAT('20',RIGHT('00000000' + CONVERT(VARCHAR(8),10000000 + ((c.id * 7919) % 89999999)),8)),
    CONCAT('Empresa Ficticia ',RIGHT('0000' + CONVERT(VARCHAR(4),c.id),4)),
    CONCAT('01-',RIGHT('0000000' + CONVERT(VARCHAR(7),c.id * 37 % 9999999),7)),
    CONCAT('Calle Ficticia ',1 + ABS(CHECKSUM(CONCAT(@Seed,'-ADDRJ-',c.id))) % 999),
    CASE
        WHEN ABS(CHECKSUM(CONCAT(@Seed,'-RUBJ-',c.id))) % 3 = 0 THEN 'Comercio'
        WHEN ABS(CHECKSUM(CONCAT(@Seed,'-RUBJ-',c.id))) % 3 = 1 THEN 'Industria'
        ELSE 'Servicios'
    END,
    c.id
FROM clientes c
WHERE c.tipo_cliente = 'J';


------------------------------------------------------------
-- 8. CONTRATACIONES
-- No se especifica la columna IDENTITY: SQL Server genera contrataciones.id.
------------------------------------------------------------

;WITH ClientesAll AS
(
    SELECT id AS cliente_id, segmento_id, fecha_alta
    FROM clientes
),
CWithCounts AS
(
    SELECT
        ca.*,
        CASE ca.segmento_id
            WHEN 1 THEN 1 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 2
            WHEN 2 THEN 1 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 3
            WHEN 3 THEN 2 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 3
            WHEN 4 THEN 3 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 4
            WHEN 5 THEN 3 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 5
            WHEN 6 THEN 2 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 3
            WHEN 7 THEN 2 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 4
            WHEN 8 THEN 3 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 4
            WHEN 9 THEN 4 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 4
            WHEN 10 THEN 4 + ABS(CHECKSUM(CONCAT(@Seed,'-CNT-',ca.cliente_id))) % 5
        END AS productos_count
    FROM ClientesAll ca
),
Expand AS
(
    SELECT
        ROW_NUMBER() OVER
        (
            PARTITION BY c.cliente_id
            ORDER BY t.n
        ) AS seq,
        c.cliente_id,
        c.segmento_id,
        c.fecha_alta,
        c.productos_count
    FROM CWithCounts c
    JOIN #Tally t
        ON t.n <= c.productos_count
),
ContrGen AS
(
    SELECT
        e.cliente_id,
        1 + ABS(CHECKSUM(CONCAT(@Seed,'-PRSEL-',e.cliente_id,'-',e.seq))) % 20 AS producto_id,
        DATEADD
        (
            DAY,
            CASE
                WHEN DATEDIFF(DAY,e.fecha_alta,@MaxDate) <= 0 THEN 0
                ELSE ABS(CHECKSUM(CONCAT(@Seed,'-CTDATE-',e.cliente_id,'-',e.seq)))
                     % (DATEDIFF(DAY,e.fecha_alta,@MaxDate) + 1)
            END,
            e.fecha_alta
        ) AS fecha_contratacion,
        CASE
            WHEN ABS(CHECKSUM(CONCAT(@Seed,'-CTEST-',e.cliente_id,'-',e.seq))) % 100 < 12
                THEN 'cancelado'
            ELSE 'activo'
        END AS estado
    FROM Expand e
)
INSERT INTO contrataciones
(cliente_id,producto_id,fecha_contratacion,fecha_cancelacion,estado)
SELECT
    cliente_id,
    producto_id,
    fecha_contratacion,
    CASE
        WHEN estado = 'cancelado'
        THEN DATEADD
        (
            DAY,
            1 + ABS(CHECKSUM(CONCAT(@Seed,'-CTCAN-',cliente_id,'-',producto_id,'-',fecha_contratacion))) % 365,
            fecha_contratacion
        )
        ELSE NULL
    END,
    estado
FROM ContrGen;


------------------------------------------------------------
-- 9. OPERACIONES
-- Se genera aproximadamente el volumen objetivo.
-- Las operaciones quedan asociadas a contrataciones.
------------------------------------------------------------
SELECT
    ct.id AS contratacion_id,
    ct.cliente_id,
    c.segmento_id,
    p.id AS producto_id,
    p.tipo_producto,
    ct.fecha_contratacion,
    CASE
        WHEN ct.fecha_cancelacion IS NOT NULL
             AND ct.fecha_cancelacion < @MaxDate
        THEN ct.fecha_cancelacion
        ELSE @MaxDate
    END AS fecha_fin,
    CASE c.segmento_id
        WHEN 1 THEN 5 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 15
        WHEN 2 THEN 8 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 20
        WHEN 3 THEN 15 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 30
        WHEN 4 THEN 35 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 60
        WHEN 5 THEN 45 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 70
        WHEN 6 THEN 10 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 20
        WHEN 7 THEN 18 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 30
        WHEN 8 THEN 25 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 40
        WHEN 9 THEN 70 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 100
        WHEN 10 THEN 90 + ABS(CHECKSUM(CONCAT(@Seed,'-OPC-',ct.id))) % 160
    END AS oper_count_raw
INTO #ContrContext
FROM contrataciones ct
JOIN clientes c ON c.id = ct.cliente_id
JOIN productos p ON p.id = ct.producto_id;

DECLARE @SumOps BIGINT = (SELECT SUM(oper_count_raw) FROM #ContrContext);
DECLARE @Scale FLOAT =
    CASE
        WHEN @SumOps = 0 THEN 1.0
        ELSE CAST(@TargetOperaciones AS FLOAT) / CAST(@SumOps AS FLOAT)
    END;

ALTER TABLE #ContrContext ADD oper_count INT;

UPDATE #ContrContext
SET oper_count =
    CASE
        WHEN FLOOR(oper_count_raw * @Scale) < 1 THEN 1
        ELSE CONVERT(INT,FLOOR(oper_count_raw * @Scale))
    END;

CREATE TABLE #OperTemp
(
    cliente_id INT NOT NULL,
    canal_id INT NOT NULL,
    contratacion_id INT NOT NULL,
    fecha_operacion DATETIME NOT NULL,
    tipo_operacion VARCHAR(100) NOT NULL,
    importe DECIMAL(18,2) NOT NULL,
    estado VARCHAR(20) NOT NULL
);

;WITH ExpandOps AS
(
    SELECT
        cc.*,
        t.n AS occ
    FROM #ContrContext cc
    JOIN #Tally t
        ON t.n <= cc.oper_count
),
OpsBase AS
(
    SELECT
        eo.*,
        ABS(CHECKSUM(CONCAT(@Seed,'-OPTYPE-',eo.contratacion_id,'-',eo.occ))) % 100 AS r_tipo,
        ABS(CHECKSUM(CONCAT(@Seed,'-OPDATE-',eo.contratacion_id,'-',eo.occ))) AS r_fecha,
        ABS(CHECKSUM(CONCAT(@Seed,'-OPAMT-',eo.contratacion_id,'-',eo.occ))) AS r_importe,
        ABS(CHECKSUM(CONCAT(@Seed,'-OPST-',eo.contratacion_id,'-',eo.occ))) % 100 AS r_estado,
        ABS(CHECKSUM(CONCAT(@Seed,'-CHANNEL-',eo.contratacion_id,'-',eo.occ))) % 100 AS r_canal
    FROM ExpandOps eo
)
INSERT INTO #OperTemp
(
    cliente_id,canal_id,contratacion_id,fecha_operacion,
    tipo_operacion,importe,estado
)
SELECT
    ob.cliente_id,

    CASE
        WHEN ob.segmento_id IN (9,10)
             AND ob.r_canal < 15 THEN 7 -- Oficina Empresas
        WHEN ob.segmento_id IN (9,10)
             AND ob.r_canal < 25 THEN 8 -- API Partners
        WHEN ob.r_tipo < 40 AND ob.r_canal < 65 THEN 3 -- POS
        WHEN ob.r_tipo >= 85 AND ob.r_canal < 70 THEN 4 -- ATM
        WHEN ob.r_canal < 55 THEN 1 -- Banca móvil
        WHEN ob.r_canal < 75 THEN 2 -- Internet
        WHEN ob.r_canal < 90 THEN 5 -- Agencia
        ELSE 6 -- Call Center
    END AS canal_id,

    ob.contratacion_id,

    DATEADD
    (
        SECOND,
        CASE
            WHEN DATEDIFF
            (
                SECOND,
                ob.fecha_contratacion,
                ob.fecha_fin
            ) <= 0 THEN 0
            ELSE ob.r_fecha %
                 (DATEDIFF
                 (
                     SECOND,
                     ob.fecha_contratacion,
                     ob.fecha_fin
                 ) + 1)
        END,
        ob.fecha_contratacion
    ) AS fecha_operacion,

    CASE
        WHEN ob.r_tipo < 40 THEN 'Compra'
        WHEN ob.r_tipo < 65 THEN 'Transferencia'
        WHEN ob.r_tipo < 85 THEN 'Pago'
        ELSE 'Retiro'
    END AS tipo_operacion,

    ROUND
    (
        (
            CASE ob.segmento_id
                WHEN 1 THEN 15.0
                WHEN 2 THEN 25.0
                WHEN 3 THEN 60.0
                WHEN 4 THEN 250.0
                WHEN 5 THEN 1000.0
                WHEN 6 THEN 80.0
                WHEN 7 THEN 150.0
                WHEN 8 THEN 350.0
                WHEN 9 THEN 5000.0
                WHEN 10 THEN 12000.0
            END
        )
        *
        (
            CASE
                WHEN ob.tipo_producto IN ('Cuenta','Tarjeta') THEN 1.0
                WHEN ob.tipo_producto IN ('Préstamo','Crédito') THEN 5.0
                WHEN ob.tipo_producto = 'Depósito' THEN 2.0
                ELSE 1.2
            END
        )
        *
        (0.5 + (ob.r_importe % 1000) / 1000.0),
        2
    ) AS importe,

    CASE
        WHEN ob.r_estado < 85 THEN 'procesada'
        WHEN ob.r_estado < 95 THEN 'pendiente'
        ELSE 'anulada'
    END AS estado
FROM OpsBase ob;

DELETE ot
FROM #OperTemp ot
JOIN #ContrContext cc
    ON cc.contratacion_id = ot.contratacion_id
WHERE ot.fecha_operacion > cc.fecha_fin;

INSERT INTO operaciones
(
    cliente_id,canal_id,contratacion_id,
    fecha_operacion,tipo_operacion,importe,estado
)
SELECT
    cliente_id,canal_id,contratacion_id,
    fecha_operacion,tipo_operacion,importe,estado
FROM #OperTemp;

------------------------------------------------------------
-- 10. INGRESOS
-- No se inserta la columna ID: SQL Server la genera.
------------------------------------------------------------
SELECT
    c.cliente_id,
    c.producto_id,
    p.id AS periodo_id,
    ROUND
    (
        SUM(o.importe)
        *
        (
            0.02 +
            (ABS(CHECKSUM(CONCAT(
                @Seed,'-ING-MULT-',c.cliente_id,'-',p.id
            ))) % 50) / 1000.0
        )
        +
        CASE
            WHEN cl.segmento_id IN (4,5,9,10) THEN 50
            ELSE 5
        END,
        2
    ) AS importe
INTO #IngresosGen
FROM operaciones o
JOIN contrataciones c
    ON c.id = o.contratacion_id
JOIN clientes cl
    ON cl.id = c.cliente_id
JOIN periodos p
    ON CONVERT(CHAR(4),YEAR(o.fecha_operacion)) = p.anio
   AND RIGHT('0' + CONVERT(VARCHAR(2),MONTH(o.fecha_operacion)),2) = p.mes
WHERE o.estado = 'procesada'
GROUP BY
    c.cliente_id,
    c.producto_id,
    p.id,
    cl.segmento_id;

DECLARE @CurrentIng INT = (SELECT COUNT(*) FROM #IngresosGen);

IF @CurrentIng < @TargetIngresos
BEGIN
    ;WITH Extra AS
    (
        SELECT TOP (@TargetIngresos - @CurrentIng)
            c.id AS cliente_id,
            1 + ABS(CHECKSUM(CONCAT(@Seed,'-EXTRA-PR-',c.id,p.id))) % 20 AS producto_id,
            p.id AS periodo_id,
            ROUND
            (
                (10 + ABS(CHECKSUM(CONCAT(
                    @Seed,'-EXTRA-AMT-',c.id,p.id
                ))) % 1000)
                *
                CASE
                    WHEN c.segmento_id IN (4,5,9,10) THEN 5
                    ELSE 1
                END,
                2
            ) AS importe
        FROM clientes c
        CROSS JOIN periodos p
        WHERE ABS(CHECKSUM(CONCAT(
            @Seed,'-EXTRA-SEL-',c.id,p.id
        ))) % 7 = 0
        ORDER BY c.id,p.id
    )
    INSERT INTO #IngresosGen
    (cliente_id,producto_id,periodo_id,importe)
    SELECT cliente_id,producto_id,periodo_id,importe
    FROM Extra;
END;

INSERT INTO ingresos
(cliente_id,producto_id,periodo_id,importe)
SELECT cliente_id,producto_id,periodo_id,importe
FROM #IngresosGen;

------------------------------------------------------------
-- 11. COSTOS
------------------------------------------------------------
SELECT
    ob.cliente_id,
    COALESCE
    (
        (
            SELECT TOP (1) ct.producto_id
            FROM contrataciones ct
            WHERE ct.cliente_id = ob.cliente_id
            ORDER BY ct.fecha_contratacion,ct.id
        ),
        1
    ) AS producto_id,
    CASE
        WHEN ABS(CHECKSUM(CONCAT(
            @Seed,'-COST-TYPE-',ob.cliente_id,'-',ob.periodo_id
        ))) % 4 = 0 THEN 'operativo'
        WHEN ABS(CHECKSUM(CONCAT(
            @Seed,'-COST-TYPE-',ob.cliente_id,'-',ob.periodo_id
        ))) % 4 = 1 THEN 'procesamiento'
        WHEN ABS(CHECKSUM(CONCAT(
            @Seed,'-COST-TYPE-',ob.cliente_id,'-',ob.periodo_id
        ))) % 4 = 2 THEN 'canal'
        ELSE 'administrativo'
    END AS tipo_costo,
    ob.periodo_id,
    ROUND
    (
        ob.ops_count *
        (
            CASE
                WHEN ob.ops_sum IS NULL THEN 0.01
                ELSE ob.ops_sum * 0.0005
            END
        )
        *
        CASE
            WHEN c.segmento_id IN (4,5,9,10) THEN 2.5
            ELSE 1
        END
        +
        ABS(CHECKSUM(CONCAT(
            @Seed,'-COST-AMT-',ob.cliente_id,'-',ob.periodo_id
        ))) % 200,
        2
    ) AS importe
INTO #CostosGen
FROM
(
    SELECT
        p.id AS periodo_id,
        o.cliente_id,
        COUNT(*) AS ops_count,
        SUM(o.importe) AS ops_sum
    FROM operaciones o
    JOIN periodos p
        ON CONVERT(CHAR(4),YEAR(o.fecha_operacion)) = p.anio
       AND RIGHT('0' + CONVERT(VARCHAR(2),MONTH(o.fecha_operacion)),2) = p.mes
    WHERE o.estado = 'procesada'
    GROUP BY p.id,o.cliente_id
) ob
JOIN clientes c
    ON c.id = ob.cliente_id;

DECLARE @CurrentCost INT = (SELECT COUNT(*) FROM #CostosGen);

IF @CurrentCost < @TargetCostos
BEGIN
    ;WITH ExtraC AS
    (
        SELECT TOP (@TargetCostos - @CurrentCost)
            c.id AS cliente_id,
            1 + ABS(CHECKSUM(CONCAT(
                @Seed,'-EXCOST-PR-',c.id,p.id
            ))) % 20 AS producto_id,
            CASE
                WHEN ABS(CHECKSUM(CONCAT(
                    @Seed,'-EXCOST-T-',c.id,p.id
                ))) % 4 = 0 THEN 'operativo'
                WHEN ABS(CHECKSUM(CONCAT(
                    @Seed,'-EXCOST-T-',c.id,p.id
                ))) % 4 = 1 THEN 'procesamiento'
                WHEN ABS(CHECKSUM(CONCAT(
                    @Seed,'-EXCOST-T-',c.id,p.id
                ))) % 4 = 2 THEN 'canal'
                ELSE 'administrativo'
            END AS tipo_costo,
            p.id AS periodo_id,
            ROUND
            (
                5 + ABS(CHECKSUM(CONCAT(
                    @Seed,'-EXCOST-AMT-',c.id,p.id
                ))) % 500,
                2
            ) AS importe
        FROM clientes c
        CROSS JOIN periodos p
        WHERE ABS(CHECKSUM(CONCAT(
            @Seed,'-EXCOST-SAMP-',c.id,p.id
        ))) % 37 = 0
        ORDER BY c.id,p.id
    )
    INSERT INTO #CostosGen
    (cliente_id,producto_id,tipo_costo,periodo_id,importe)
    SELECT cliente_id,producto_id,tipo_costo,periodo_id,importe
    FROM ExtraC;
END;

INSERT INTO costos
(cliente_id,producto_id,tipo_costo,periodo_id,importe)
SELECT cliente_id,producto_id,tipo_costo,periodo_id,importe
FROM #CostosGen;

------------------------------------------------------------
-- 12. VALIDACIONES
-- No se utiliza IDENTITY_INSERT en ninguna tabla.
------------------------------------------------------------

SELECT 'segmentos' tabla, COUNT(*) cantidad FROM segmentos
UNION ALL SELECT 'canales', COUNT(*) FROM canales
UNION ALL SELECT 'categoria_productos', COUNT(*) FROM categoria_productos
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'personas_naturales', COUNT(*) FROM personas_naturales
UNION ALL SELECT 'personas_juridicas', COUNT(*) FROM personas_juridicas
UNION ALL SELECT 'periodos', COUNT(*) FROM periodos
UNION ALL SELECT 'contrataciones', COUNT(*) FROM contrataciones
UNION ALL SELECT 'operaciones', COUNT(*) FROM operaciones
UNION ALL SELECT 'ingresos', COUNT(*) FROM ingresos
UNION ALL SELECT 'costos', COUNT(*) FROM costos;

SELECT tipo_cliente, COUNT(*) cantidad
FROM clientes
GROUP BY tipo_cliente;

SELECT s.nombre segmento, COUNT(*) cantidad
FROM clientes c
JOIN segmentos s ON s.id = c.segmento_id
GROUP BY s.nombre
ORDER BY cantidad DESC;

SELECT estado, COUNT(*) cantidad
FROM contrataciones
GROUP BY estado;

SELECT tipo_operacion, COUNT(*) cantidad
FROM operaciones
GROUP BY tipo_operacion
ORDER BY cantidad DESC;

SELECT estado, COUNT(*) cantidad
FROM operaciones
GROUP BY estado;

SELECT ca.nombre canal, COUNT(*) cantidad
FROM operaciones o
JOIN canales ca ON ca.id = o.canal_id
GROUP BY ca.nombre
ORDER BY cantidad DESC;

SELECT p.anio,p.mes,SUM(i.importe) ingresos
FROM ingresos i
JOIN periodos p ON p.id = i.periodo_id
GROUP BY p.anio,p.mes
ORDER BY p.anio,p.mes;

SELECT p.anio,p.mes,SUM(c.importe) costos
FROM costos c
JOIN periodos p ON p.id = c.periodo_id
GROUP BY p.anio,p.mes
ORDER BY p.anio,p.mes;

SELECT
    SUM(i.importe) ingresos_totales,
    (SELECT SUM(c.importe) FROM costos c) costos_totales,
    SUM(i.importe) - (SELECT SUM(c.importe) FROM costos c) rentabilidad_total
FROM ingresos i;

SELECT TOP 10
    c.id cliente_id,
    c.codigo,
    ISNULL(i.ingresos,0) ingresos,
    ISNULL(co.costos,0) costos,
    ISNULL(i.ingresos,0) - ISNULL(co.costos,0) rentabilidad
FROM clientes c
LEFT JOIN
(
    SELECT cliente_id,SUM(importe) ingresos
    FROM ingresos
    GROUP BY cliente_id
) i ON i.cliente_id = c.id
LEFT JOIN
(
    SELECT cliente_id,SUM(importe) costos
    FROM costos
    GROUP BY cliente_id
) co ON co.cliente_id = c.id
ORDER BY rentabilidad DESC;

SELECT
    COUNT(*) AS clientes_rentabilidad_negativa
FROM
(
    SELECT
        c.id,
        ISNULL(i.ingresos,0) - ISNULL(co.costos,0) rentabilidad
    FROM clientes c
    LEFT JOIN
    (
        SELECT cliente_id,SUM(importe) ingresos
        FROM ingresos
        GROUP BY cliente_id
    ) i ON i.cliente_id = c.id
    LEFT JOIN
    (
        SELECT cliente_id,SUM(importe) costos
        FROM costos
        GROUP BY cliente_id
    ) co ON co.cliente_id = c.id
) x
WHERE rentabilidad < 0;

------------------------------------------------------------
-- 13. LIMPIEZA DE TEMPORALES
------------------------------------------------------------
DROP TABLE IF EXISTS #Tally;
DROP TABLE IF EXISTS #ContrContext;
DROP TABLE IF EXISTS #OperTemp;
DROP TABLE IF EXISTS #IngresosGen;
DROP TABLE IF EXISTS #CostosGen;

-- FIN
