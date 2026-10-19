USE pdan_8_rentabilidad_cliente;

/*
Mostrar:

ID
Código
Tipo de cliente
Estado
Segmento
Ordenar los resultados por código de cliente.
*/
SELECT
	cl.id,
	cl.codigo,
	cl.tipo_cliente,
	cl.estado,
	s.nombre
FROM clientes cl
	INNER JOIN segmentos s ON s.id =cl.segmento_id
ORDER BY 2 DESC;

-- Mostrar todos los clientes cuyo estado sea:

SELECT
	cl.id,
	cl.codigo,
	cl.tipo_cliente,
	cl.estado,
	s.nombre
FROM clientes cl
	INNER JOIN segmentos s ON s.id =cl.segmento_id
WHERE 
	cl.estado='activo'
ORDER BY 2 DESC;

/*
Mostrar:

Código
Nombre
Tipo de producto
Moneda
Estado
Únicamente para productos activos.
*/

SELECT 
	p.codigo,
	p.nombre,
	p.tipo_producto,
	p.moneda, 
	p.estado 
FROM productos p 
WHERE p.estado = 'activo' 
ORDER BY p.nombre;

/* 
Ejercicio 4 — Operaciones mayores a S/ 5,000
Mostrar las operaciones cuyo importe sea mayor a:

S/ 5,000
Ordenarlas de mayor a menor importe.
*/

SELECT
*FROM operaciones
WHERE importe > '5000'
ORDER BY importe DESC;


/*
Ejercicio 5 — ¿Cuántos clientes tenemos?
Obtener:

Cantidad total de clientes.
Cantidad de clientes activos.
Cantidad de clientes bloqueados.
Cantidad de clientes Inactivos.
*/


SELECT COUNT(*) FROM clientes;

SELECT COUNT(*) FROM CLIENTES WHERE estado = 'Activo';

SELECT COUNT(*)
FROM clientes
WHERE estado = 'Bloqueado';

Select count(*) from CLIENTES
Where ESTADO = 'inactivo'
/*
Ejercicio 6 — Importe de las operaciones
Calcular:

Operación mínima.
Operación máxima.
Importe promedio.
Importe total.
Conceptos
*/

SELECT
	tipo_operacion AS concepto,
	MIN (importe) AS 'Operación mínima',
	MAX (importe) AS 'Operación máxima',
	AVG (importe) AS 'Importe promedio',
	SUM (importe) AS 'Importe total'
FROM operaciones
GROUP BY tipo_operacion;

/*
Ejercicio 7 — Clientes y sus segmentos
Mostrar:

Cliente
Código
Segmento
Estado
Relacionar:

clientes → segmentos
Conceptos
INNER JOIN
*/

SELECT 
CASE WHEN c.tipo_cliente = 'N' THEN CONCAT(pn.nombres, ' ', pn.app, ' ', pn.apm) ELSE pj.razon_social END AS Cliente,
c.codigo AS Codigo,
s.nombre AS Segmento,
c.estado AS Estado 
FROM clientes AS c 
INNER JOIN segmentos AS s ON c.segmento_id = s.id 
LEFT JOIN personas_naturales AS pn ON pn.cliente_id = c.id
LEFT JOIN personas_juridicas AS pj ON pj.cliente_id = c.id ORDER BY Cliente;

SELECT
    c.id AS Cliente,
    c.codigo AS Codigo,
    CONCAT(pn.nombres, ' ', pn.app, ' ', pn.apm) AS NombreCliente,
    s.nombre AS Segmento,
    c.estado AS Estado
FROM clientes AS c
INNER JOIN segmentos AS s
    ON c.segmento_id = s.id
INNER JOIN personas_naturales AS pn
    ON c.id = pn.cliente_id;

SELECT
    c.id AS Cliente,
    c.codigo AS Codigo,
    s.nombre AS Segmento,
    c.estado AS Estado
FROM clientes AS c
INNER JOIN segmentos AS s
    ON c.segmento_id = s.id;

/*
Ejercicio 8 — Productos y categorías
Mostrar:

Producto
Código
Categoría
Tipo de producto
Moneda
Estado
Relacionar:

productos → categoria_productos
*/
SELECT
    p.nombre AS Producto,
    p.codigo AS Codigo,
    cp.nombre AS Categoria,
    p.tipo_producto AS Tipo_producto,
    p.moneda AS Moneda,
    p.estado AS Estado
FROM productos AS p
INNER JOIN categoria_productos AS cp
    ON p.categoria_id = cp.id;

	/*
	Ejercicio 9 — Clientes por segmento
Determinar cuántos clientes pertenecen a cada segmento.

Resultado esperado:

Segmento       CantidadClientes
-------------- ---------------
Básico         ...
Masivo         ...
Preferente     ...
Premium        ...
...
Ordenar de mayor a menor cantidad de clientes.
	*/


SELECT
	s.nombre AS 'segmento',
	COUNT(*) AS 'num_clientes'
FROM clientes c
INNER JOIN segmentos s ON s.id=c.segmento_id
GROUP BY s.nombre
ORDER BY 2 DESC;

/* 
Ejercicio 10 — Operaciones por canal
Determinar cuántas operaciones se realizan por cada canal.

Mostrar:

Canal
CantidadOperaciones
ImporteTotal
*/
SELECT
    c.nombre AS Canal,
    COUNT(o.id) AS CantidadOperaciones,
    SUM(o.importe) AS ImporteTotal
FROM operaciones AS o
INNER JOIN canales AS c
    ON o.canal_id = c.id
GROUP BY
    c.id,
    c.nombre
ORDER BY 2 DESC;

/* 
Ejercicio 11 — Productos más contratados
Determinar qué productos tienen mayor cantidad de contrataciones.

Mostrar:

Producto
CantidadContrataciones
Ordenar de mayor a menor.
*/

SELECT
p.nombre AS 'Producto',
COUNT(c.id) AS 'num_contrataciones'
FROM productos p
INNER JOIN contrataciones c ON c.producto_id=p.id
GROUP BY p.nombre
ORDER BY 2 DESC;

/*
Ejercicio 12 — Clientes sin contrataciones
Encontrar clientes que nunca hayan contratado un producto.

Pista
Analizar cuándo resulta conveniente utilizar:

LEFT JOIN
en lugar de:

INNER JOIN
*/

SELECT
    c.id AS Cliente,
    c.codigo AS Codigo
FROM clientes AS c
LEFT JOIN contrataciones AS co
    ON c.id = co.cliente_id
WHERE co.id IS NULL;


INSERT INTO clientes VALUES ('C71118','N','2026-09-23',	'inactivo','6')

/* 
Calcular cuánto ingreso genera cada segmento.

Resultado esperado:

Segmento       Ingresos
-------------- ----------
Básico         S/ ...
Masivo         S/ ...
Premium        S/ ...
*/ 
SELECT
    s.nombre AS Segmento,
    SUM(i.importe) AS Ingresos
FROM ingresos AS i
INNER JOIN clientes AS c
    ON i.cliente_id = c.id
INNER JOIN segmentos AS s
    ON c.segmento_id = s.id
GROUP BY
    s.id,
    s.nombre
ORDER BY 2 DESC;

/*
Ejercicio 14 — Costos por segmento
Calcular cuánto costo genera cada segmento.

Mostrar:

Segmento
Costos
*/

SELECT 
s.nombre AS Segmento, 
CONCAT('S/ ', FORMAT(ISNULL(SUM(i.importe), 0), 'N2')) AS Costos 
FROM segmentos AS s 
LEFT JOIN clientes AS c ON c.segmento_id = s.id 
LEFT JOIN costos AS i ON i.cliente_id = c.id 
GROUP BY s.nombre 
ORDER BY ISNULL(SUM(i.importe), 0) DESC;

/*
Ejercicio 15 — Rentabilidad por segmento ⭐
Calcular:

RENTABILIDAD = INGRESOS - COSTOS
Mostrar:

Segmento
Ingresos
Costos
Rentabilidad
*/

--WITH
WITH ingresos_segmento AS (
    SELECT
        c.segmento_id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.segmento_id
),
costos_segmento AS (
    SELECT
        c.segmento_id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.segmento_id
)
SELECT
    s.nombre AS Segmento,
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
FROM segmentos AS s
LEFT JOIN ingresos_segmento AS i
    ON s.id = i.segmento_id
LEFT JOIN costos_segmento AS co
    ON s.id = co.segmento_id
ORDER BY
    s.id;


--SUBCONSULTA

  SELECT
  s.nombre AS segmento,
  (SELECT SUM (importe) FROM ingresos i INNER JOIN clientes c ON c.id=i.cliente_id WHERE c.segmento_id=s.id)AS 'Ingresos',
  (SELECT SUM (importe) FROM costos i INNER JOIN clientes c ON c.id=i.cliente_id WHERE c.segmento_id=s.id)AS 'Costos',
  (SELECT SUM (importe) FROM ingresos i INNER JOIN clientes c ON c.id=i.cliente_id WHERE c.segmento_id=s.id) -
  (SELECT SUM (importe) FROM costos i INNER JOIN clientes c ON c.id=i.cliente_id WHERE c.segmento_id=s.id) AS 'rentabilidad'
  FROM segmentos s;

  -- Con tablas temporales

      SELECT
        c.segmento_id,
        SUM(i.importe) AS Ingresos
        INTO #i
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.segmento_id;

    SELECT
        c.segmento_id,
        SUM(i.importe) AS Costos
        INTO #c
    FROM costos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.segmento_id;

    SELECT
    s.nombre AS Segmento,
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
FROM segmentos AS s
LEFT JOIN #i AS i
    ON s.id = i.segmento_id
LEFT JOIN #c AS co
    ON s.id = co.segmento_id
ORDER BY
    s.id;

DROP TABLE #i;
DROP TABLE #c;

/*
Ejercicio 16 — Rentabilidad por cliente ⭐
Determinar cuánto gana o pierde el banco con cada cliente.

Mostrar:

Cliente
Ingresos
Costos
Rentabilidad
Ordenar de mayor a menor rentabilidad.

*/

WITH ingresos_segmento AS (
    SELECT
        c.id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.id
),
costos_segmento AS (
    SELECT
        c.id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.id
)
SELECT
    cl.codigo AS Cliente,
    CASE WHEN cl.tipo_cliente='N' THEN 'Persona Natural' 
     ELSE 'Persona Juridica' END AS 'Tipo cliente',
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
FROM clientes AS cl
LEFT JOIN ingresos_segmento AS i
    ON cl.id = i.id
LEFT JOIN costos_segmento AS co
    ON cl.id = co.id
ORDER BY
    2,5 DESC;

/*
Ejercicio 17 — Top 10 clientes más rentables
Mostrar los 10 clientes con mayor rentabilidad.

Concepto sugerido
TOP

*/
DROP TABLE #rtbl_cliente;

WITH ingresos_segmento AS (
    SELECT
        c.id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.id
),
costos_segmento AS (
    SELECT
        c.id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.id
)
SELECT
    cl.codigo AS Cliente,
    CASE WHEN cl.tipo_cliente='N' THEN 'Persona Natural' 
     ELSE 'Persona Juridica' END AS 'tipo_cliente',
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
INTO #rtbl_cliente
FROM clientes AS cl
LEFT JOIN ingresos_segmento AS i
    ON cl.id = i.id
LEFT JOIN costos_segmento AS co
    ON cl.id = co.id
ORDER BY  5 DESC;


SELECT 
    RANK() OVER (ORDER BY Rentabilidad DESC) AS Puesto,
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad
INTO #rtbl_cliente_ranking
FROM #rtbl_cliente

SELECT*
FROM #rtbl_cliente_ranking
WHERE Puesto<=10;


--CTE
--RANK
WITH rtlb_ranking AS (
SELECT 
    RANK() OVER (ORDER BY Rentabilidad DESC) AS Puesto,
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad
FROM #rtbl_cliente
)
SELECT * FROM rtlb_ranking;
--WHERE Puesto<=10;

--DENSE_RANK
WITH rtlb_ranking AS (
SELECT 
    DENSE_RANK() OVER (ORDER BY Rentabilidad DESC) AS Puesto,
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad
FROM #rtbl_cliente
)
SELECT * FROM rtlb_ranking
WHERE Puesto<=10;

-- ROW_NUMBER()

WITH rtlb_ranking AS (
SELECT 
    DENSE_RANK() OVER (ORDER BY Rentabilidad DESC) AS Puesto,
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad
FROM #rtbl_cliente
)
SELECT * FROM rtlb_ranking;
--WHERE Puesto<=10;

-- Consulta 1: calcular las 10 rentabilidades mas altas
-- Consultados hallo la rentabilidad y pregunto si esta en el grupo de las 10 rentabilidades mas altas


/*Ejercicio 18 — Clientes que generan pérdidas
Encontrar clientes cuya rentabilidad sea menor que cero.

Rentabilidad < 0
Mostrar:

Cliente
Ingresos
Costos
Rentabilidad*/

DROP TABLE #rtbl_cliente;

WITH ingresos_segmento AS (
    SELECT
        c.id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.id
),
costos_segmento AS (
    SELECT
        c.id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.id
)
SELECT
    cl.codigo AS Cliente,
    CASE WHEN cl.tipo_cliente='N' THEN 'Persona Natural' 
     ELSE 'Persona Juridica' END AS 'tipo_cliente',
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
INTO #rtbl_cliente
FROM clientes AS cl
LEFT JOIN ingresos_segmento AS i
    ON cl.id = i.id
LEFT JOIN costos_segmento AS co
    ON cl.id = co.id
ORDER BY  5 DESC;

SELECT 
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad
FROM #rtbl_cliente
WHERE Rentabilidad < 0
ORDER BY  5 ASC;

/*

🔵 NIVEL 4 — INTERMEDIO / AVANZADO
Ahora introducimos herramientas más potentes de SQL Server.

Ejercicio 19 — Clasificación de clientes por rentabilidad
Crear una clasificación utilizando CASE:

Condición	Clasificación
Rentabilidad >= 10,000	Alta
Rentabilidad >= 5,000	Media
Rentabilidad >= 0	Baja
Rentabilidad < 0	Pérdida

Concepto
CASE

*/

WITH ingresos_segmento AS (
    SELECT
        c.id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.id
),
costos_segmento AS (
    SELECT
        c.id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.id
)
SELECT
    cl.codigo AS Cliente,
    CASE WHEN cl.tipo_cliente='N' THEN 'Persona Natural' 
     ELSE 'Persona Juridica' END AS 'tipo_cliente',
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad,
    CASE 
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 10000 THEN 'Alta'
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 5000 THEN 'Media'
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 0 THEN 'Baja'
    ELSE 'Pérdida' END AS 'Clasificacion'
FROM clientes AS cl
LEFT JOIN ingresos_segmento AS i
    ON cl.id = i.id
LEFT JOIN costos_segmento AS co
    ON cl.id = co.id
ORDER BY  5 DESC;





/*
Ejercicio 20 — Participación de cada cliente
Calcular qué porcentaje de los ingresos totales representa cada cliente.

Resultado esperado:

Cliente    Ingresos    Participación
---------  ----------  ------------
C00001     50,000      2.35%
C00002     30,000      1.41%
...
*/

DECLARE @ingreso_total DECIMAL(18,4);
SET @ingreso_total= (SELECT SUM(importe) FROM ingresos);

SELECT
c.codigo AS Cliente, 
SUM(i.importe) AS Ingresos, 
CONCAT(CAST( SUM(i.importe) * 100.0 / @ingreso_total AS DECIMAL(5,4) ), ' %') AS Participacion_Pct 
INTO #prtcp_ingresos
FROM clientes c
LEFT JOIN ingresos i ON i.cliente_id = c.id 
GROUP BY c.codigo 
ORDER BY Participacion_Pct DESC;

--DENSE_RANK
SELECT
DENSE_RANK() OVER (ORDER BY Participacion_Pct DESC) AS Ranking,*
FROM #prtcp_ingresos

--RANK
SELECT
RANK() OVER (ORDER BY Participacion_Pct DESC) AS Ranking,*
FROM #prtcp_ingresos

--ROW_NUMBER

SELECT
ROW_NUMBER() OVER (ORDER BY Participacion_Pct DESC) AS Ranking,*
FROM #prtcp_ingresos
-----------------------------------------------------------------

WITH ingresos_por_cliente AS (
    -- 1. Sumar los ingresos de cada cliente.
    SELECT
        c.id,
        c.codigo,
        ISNULL(SUM(i.importe), 0) AS ingreso_cliente
    FROM dbo.clientes AS c
    LEFT JOIN dbo.ingresos AS i
        ON i.cliente_id = c.id
    GROUP BY c.id, c.codigo
),
ingresos_con_total AS (
    -- 2. Sumar los ingresos de todos los clientes.
    SELECT
        codigo,
        ingreso_cliente,
        SUM(ingreso_cliente) OVER () AS ingreso_total
    FROM ingresos_por_cliente
)
-- 3. Calcular la participación de cada cliente.
SELECT
    codigo AS Cliente,
    ingreso_cliente AS Ingresos,
    ingreso_total AS TotalIngresos,
    CONCAT(CAST(
        ingreso_cliente / NULLIF(ingreso_total, 0) * 100.0
        AS DECIMAL(10, 4)
    ), '%') AS Participacion_Porcentaje
FROM ingresos_con_total
ORDER BY ingreso_cliente DESC, codigo;


SELECT cl.codigo AS Cliente, 
ISNULL(ing.Ingresos, 0) AS Ingresos,
CONCAT( FORMAT( ISNULL(ing.Ingresos, 0) * 100.0 / SUM(ISNULL(ing.Ingresos, 0)) OVER (), 'N2' ), '%' ) AS Participacion 
FROM clientes AS cl
LEFT JOIN ( SELECT cliente_id, SUM(importe) AS Ingresos FROM ingresos GROUP BY cliente_id ) AS ing ON cl.id = ing.cliente_id 
ORDER BY Ingresos DESC;


--- Ejercio 22
--Determinar quiénes son los clientes más rentables dentro de cada segmento.

WITH ingresos_segmento AS (
    SELECT
        c.segmento_id,
        c.id,
        SUM(i.importe) AS Ingresos
    FROM ingresos AS i
    INNER JOIN clientes AS c
        ON i.cliente_id = c.id
    GROUP BY
        c.segmento_id,
        c.id
),
costos_segmento AS (
    SELECT
        c.segmento_id,
        c.id,
        SUM(co.importe) AS Costos
    FROM costos AS co
    INNER JOIN clientes AS c
        ON co.cliente_id = c.id
    GROUP BY
        c.segmento_id,
        c.id
)
SELECT
    s.nombre AS 'segmento',
    RANK() OVER  (PARTITION BY s.id ORDER BY (ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0)) DESC)  AS Ranking,
    cl.codigo AS Cliente,
    CASE WHEN cl.tipo_cliente='N' THEN 'Persona Natural' 
     ELSE 'Persona Juridica' END AS 'tipo_cliente',
    ISNULL(i.Ingresos, 0) AS Ingresos,
    ISNULL(co.Costos, 0) AS Costos,
    ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad,
    CASE 
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 10000 THEN 'Alta'
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 5000 THEN 'Media'
        WHEN ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) >= 0 THEN 'Baja'
    ELSE 'Pérdida' END AS 'Clasificacion'
INTO #T01
FROM clientes AS cl
INNER JOIN segmentos s ON s.id=cl.segmento_id
LEFT JOIN ingresos_segmento AS i
    ON cl.id = i.id
LEFT JOIN costos_segmento AS co
    ON cl.id = co.id
ORDER BY  1,2 ASC;

SELECT*FROM #T01
WHERE Ranking<=5;

WITH ingresos_agr AS (
    SELECT 
        cliente_id, 
        SUM(importe) AS Ingresos
    FROM ingresos
    GROUP BY cliente_id
),
costos_agr AS (
    SELECT 
        cliente_id, 
        SUM(importe) AS Costos
    FROM costos
    GROUP BY cliente_id
),
base_calculo AS (
    SELECT 
        s.id AS segmento_id,
        s.nombre AS segmento,
        cl.codigo AS Cliente,
        CASE WHEN cl.tipo_cliente = 'N' THEN 'Persona Natural' ELSE 'Persona Juridica' END AS tipo_cliente,
        ISNULL(i.Ingresos, 0) AS Ingresos,
        ISNULL(co.Costos, 0) AS Costos,
        ISNULL(i.Ingresos, 0) - ISNULL(co.Costos, 0) AS Rentabilidad
    FROM clientes AS cl
    INNER JOIN segmentos AS s 
        ON s.id = cl.segmento_id
    LEFT JOIN ingresos_agr AS i 
        ON cl.id = i.cliente_id
    LEFT JOIN costos_agr AS co 
        ON cl.id = co.cliente_id
),
ranking_segmentos AS (
    SELECT 
        segmento,
        RANK() OVER (PARTITION BY segmento_id ORDER BY Rentabilidad DESC) AS Ranking,
        Cliente,
        tipo_cliente,
        Ingresos,
        Costos,
        Rentabilidad,
        CASE 
            WHEN Rentabilidad >= 10000 THEN 'Alta'
            WHEN Rentabilidad >= 5000 THEN 'Media'
            WHEN Rentabilidad >= 0 THEN 'Baja'
            ELSE 'Pérdida' 
        END AS Clasificacion
    FROM base_calculo
)
SELECT 
    segmento,
    Ranking,
    Cliente,
    tipo_cliente,
    Ingresos,
    Costos,
    Rentabilidad,
    Clasificacion
FROM ranking_segmentos
WHERE Ranking <= 5
ORDER BY segmento, Ranking ASC;

WITH movimientos AS (
    SELECT cliente_id, importe AS Ingresos, 0 AS Costos 
    FROM ingresos
    UNION ALL
    SELECT cliente_id, 0 AS Ingresos, importe AS Costos 
    FROM costos
),
resumen_cliente AS (
    SELECT 
        cliente_id,
        SUM(Ingresos) AS Ingresos,
        SUM(Costos) AS Costos,
        SUM(Ingresos - Costos) AS Rentabilidad
    FROM movimientos
    GROUP BY cliente_id
),
ranking_segmentos AS (
    SELECT 
        s.nombre AS segmento,
        RANK() OVER (PARTITION BY s.id ORDER BY ISNULL(rc.Rentabilidad, 0) DESC) AS Ranking,
        cl.codigo AS Cliente,
        CASE WHEN cl.tipo_cliente = 'N' THEN 'Persona Natural' ELSE 'Persona Juridica' END AS tipo_cliente,
        ISNULL(rc.Ingresos, 0) AS Ingresos,
        ISNULL(rc.Costos, 0) AS Costos,
        ISNULL(rc.Rentabilidad, 0) AS Rentabilidad,
        CASE 
            WHEN ISNULL(rc.Rentabilidad, 0) >= 10000 THEN 'Alta'
            WHEN ISNULL(rc.Rentabilidad, 0) >= 5000 THEN 'Media'
            WHEN ISNULL(rc.Rentabilidad, 0) >= 0 THEN 'Baja'
            ELSE 'Pérdida' 
        END AS Clasificacion
    FROM clientes AS cl
    INNER JOIN segmentos AS s 
        ON s.id = cl.segmento_id
    LEFT JOIN resumen_cliente AS rc 
        ON cl.id = rc.cliente_id
)
SELECT *
FROM ranking_segmentos
WHERE Ranking <= 5
ORDER BY segmento, Ranking ASC;


--- 23

WITH ingresos_mes AS (
    SELECT
        periodo_id,
        SUM(importe) AS ingresos
    FROM ingresos
    GROUP BY periodo_id
),
costos_mes AS (
    SELECT
        periodo_id,
        SUM(importe) AS costos
    FROM costos
    GROUP BY periodo_id
)
SELECT
    p.anio AS Año,
    p.mes AS Mes,
    ISNULL(im.ingresos, 0) AS Ingresos,
    ISNULL(cm.costos, 0) AS Costos,
    ISNULL(im.ingresos, 0) - ISNULL(cm.costos, 0) AS Rentabilidad
FROM periodos p
LEFT JOIN ingresos_mes im
    ON p.id = im.periodo_id
LEFT JOIN costos_mes cm
    ON p.id = cm.periodo_id
ORDER BY
    p.anio,
    p.mes;

SELECT*FROM periodos;

--24

WITH ingresos_mes AS (
    SELECT
        periodo_id,
        SUM(importe) AS ingresos
    FROM ingresos
    GROUP BY periodo_id
),
costos_mes AS (
    SELECT
        periodo_id,
        SUM(importe) AS costos
    FROM costos
    GROUP BY periodo_id
),
rentabilidad_mes AS (
    SELECT
        p.anio AS Año,
        p.mes AS Mes,
        ISNULL(im.ingresos, 0) - ISNULL(cm.costos, 0) AS Rentabilidad
    FROM periodos p
    LEFT JOIN ingresos_mes im
        ON p.id = im.periodo_id
    LEFT JOIN costos_mes cm
        ON p.id = cm.periodo_id
),
evolucion AS (
    SELECT
        Año,
        Mes,
        Rentabilidad,
        LAG(Rentabilidad) OVER (
            ORDER BY Año, Mes
        ) AS MesAnterior
    FROM rentabilidad_mes
)
SELECT
    Año,
    Mes,
    Rentabilidad,
    MesAnterior,
    Rentabilidad - MesAnterior AS Variacion
FROM evolucion
ORDER BY Año, Mes;

--- 25
WITH ingresos_producto AS (
    SELECT
        producto_id,
        SUM(importe) AS ingresos
    FROM ingresos
    GROUP BY producto_id
),
costos_producto AS (
    SELECT
        producto_id,
        SUM(importe) AS costos
    FROM costos
    GROUP BY producto_id
),
rentabilidad_producto AS (
    SELECT
        p.codigo AS Producto,
        p.nombre AS NombreProducto,
        ISNULL(ip.ingresos, 0) AS Ingresos,
        ISNULL(cp.costos, 0) AS Costos,
        ISNULL(ip.ingresos, 0) - ISNULL(cp.costos, 0) AS Rentabilidad
    FROM productos p
    LEFT JOIN ingresos_producto ip
        ON p.id = ip.producto_id
    LEFT JOIN costos_producto cp
        ON p.id = cp.producto_id
)
SELECT
    Producto,
    NombreProducto,
    Ingresos,
    Costos,
    Rentabilidad,
    CASE
        WHEN Ingresos = 0 THEN 0
        ELSE (Rentabilidad / Ingresos) * 100
    END AS [Margen %]
FROM rentabilidad_producto
ORDER BY Rentabilidad DESC;

SELECT 
    pr.codigo AS Producto,
    SUM(ISNULL(ic.total_ingresos, 0))                           AS Ingresos,
    SUM(ISNULL(cc.total_costos, 0))                             AS Costos,
    SUM(ISNULL(ic.total_ingresos, 0)) - SUM(ISNULL(cc.total_costos, 0)) AS Rentabilidad,
    CAST(
        CASE 
            WHEN SUM(ISNULL(ic.total_ingresos, 0)) = 0 THEN NULL
            ELSE (SUM(ISNULL(ic.total_ingresos, 0)) - SUM(ISNULL(cc.total_costos, 0))) 
                 * 100.0 / SUM(ISNULL(ic.total_ingresos, 0))
        END 
    AS DECIMAL(5,2)) AS Margen_Pct
FROM productos pr
LEFT JOIN (
    SELECT 
        producto_id, 
        SUM(importe) AS total_ingresos
    FROM ingresos
    GROUP BY producto_id
) ic 
    ON ic.producto_id = pr.id
LEFT JOIN (
    SELECT 
        producto_id, 
        SUM(importe) AS total_costos
    FROM costos
    GROUP BY producto_id
) cc 
    ON cc.producto_id = pr.id
GROUP BY 
    pr.codigo
ORDER BY Rentabilidad DESC;

/*Ejercicio 26 — Rentabilidad por tipo de cliente
Comparar:

Persona Natural
Persona Jurídica
Analizar:

Cantidad de clientes.
Ingresos.
Costos.
Rentabilidad.
Rentabilidad promedio por cliente.
*/

WITH ingresos_por_cliente AS (
    SELECT
        c.id,
        ISNULL(SUM(i.importe), 0) AS ingreso_cliente
    FROM dbo.clientes AS c
    LEFT JOIN dbo.ingresos AS i
        ON i.cliente_id = c.id
    GROUP BY c.id
),
costos_por_cliente AS (
    SELECT
        c.id,
        ISNULL(SUM(i.importe), 0) AS costos_cliente
    FROM dbo.clientes AS c
    LEFT JOIN dbo.costos AS i
        ON i.cliente_id = c.id
    GROUP BY c.id
)
SELECT
cl.tipo_cliente,
COUNT(cl.id) AS 'cantidad_clientes',
SUM(ic.ingreso_cliente) AS 'Ingresos',
SUM(cc.costos_cliente) AS 'Costos',
SUM(ic.ingreso_cliente)-SUM(cc.costos_cliente) AS 'Rentabilidad',
AVG (ic.ingreso_cliente-cc.costos_cliente) AS 'rentabilidad_promedio_cliente'
FROM clientes cl
LEFT JOIN ingresos_por_cliente ic ON ic.id =cl.id
LEFT JOIN costos_por_cliente cc ON cc.id=cl.id
GROUP BY cl.tipo_cliente;

/*
Ejercicio 27 — Clientes con alta rentabilidad pero bajo volumen
Buscar clientes que cumplan simultáneamente:

Rentabilidad > promedio general
y:

Número de operaciones < promedio general
El ejercicio debe resolverse utilizando una combinación de:

Agregaciones.
Subconsultas.
CTE.*/


WITH RentabilidadCliente AS (
    SELECT
        c.id AS cliente_id,
        c.codigo,
        COALESCE(SUM(i.importe), 0) AS ingresos,
        COALESCE(SUM(co.importe), 0) AS costos,
        COALESCE(SUM(i.importe), 0) - COALESCE(SUM(co.importe), 0) AS rentabilidad
    FROM clientes c
    LEFT JOIN ingresos i
        ON c.id = i.cliente_id
    LEFT JOIN costos co
        ON c.id = co.cliente_id
    GROUP BY
        c.id,
        c.codigo
),OperacionesCliente AS (
    SELECT
        c.id AS cliente_id,
        COUNT(o.id) AS numero_operaciones
    FROM clientes c
    LEFT JOIN operaciones o
        ON c.id = o.cliente_id
    GROUP BY
        c.id
),PromediosGenerales AS (
    SELECT
        AVG(rc.rentabilidad) AS promedio_rentabilidad,
        AVG(oc.numero_operaciones) AS promedio_operaciones
    FROM RentabilidadCliente rc
    INNER JOIN OperacionesCliente oc
        ON rc.cliente_id = oc.cliente_id
)
SELECT
    rc.cliente_id,
    rc.codigo,
    rc.ingresos,
    rc.costos,
    rc.rentabilidad,
    oc.numero_operaciones,
    pg.promedio_rentabilidad,
    pg.promedio_operaciones
FROM RentabilidadCliente rc
INNER JOIN OperacionesCliente oc
    ON rc.cliente_id = oc.cliente_id
CROSS JOIN PromediosGenerales pg
WHERE rc.rentabilidad > pg.promedio_rentabilidad
  AND oc.numero_operaciones < pg.promedio_operaciones
ORDER BY rc.rentabilidad DESC;

/*
Ejercicio 28 — Producto principal de cada cliente
Determinar cuál es el producto que representa la mayor cantidad de operaciones para cada cliente.

Concepto sugerido
ROW_NUMBER()
OVER(
    PARTITION BY ...
    ORDER BY ...
)
*/
SELECT*FROM operaciones;

WITH operaciones_producto AS (
    SELECT
        ct.cliente_id,
        c.codigo AS Cliente,
        ct.producto_id AS producto_id,
        p.codigo AS Producto,
        p.nombre AS NombreProducto,
        COUNT(o.id) AS CantidadOperaciones
    FROM operaciones o
    INNER JOIN clientes c
        ON o.cliente_id = c.id
    INNER JOIN contrataciones ct
        ON o.contratacion_id = ct.id
    INNER JOIN productos p
        ON ct.producto_id = p.id
    GROUP BY
        ct.cliente_id,
        c.codigo,
        ct.producto_id,
        p.codigo,
        p.nombre
),
ranking_productos AS (
    SELECT
        Cliente,
        Producto,
        NombreProducto,
        CantidadOperaciones,
        ROW_NUMBER() OVER (
            PARTITION BY Cliente
            ORDER BY CantidadOperaciones DESC
        ) AS Ranking
    FROM operaciones_producto
)
SELECT
    Cliente,
    Producto,
    NombreProducto,
    Ranking,
    CantidadOperaciones
FROM ranking_productos
WHERE Ranking = 1
ORDER BY Cliente;

/*
Ejercicio 29 — Segmento más rentable por mes
Para cada mes determinar cuál fue el segmento que generó mayor rentabilidad.

Resultado esperado:

Año  Mes  Segmento      Rentabilidad
---  ---  ------------  ------------
2025 01   Premium       ...
2025 02   Corporativo   ...
2025 03   Premium       ...
Conceptos sugeridos
CTE
Window Functions
PARTITION BY
ROW_NUMBER()
*/

WITH RentabilidadSegmento AS (
    SELECT
        p.anio,
        p.mes,
        s.id AS segmento_id,
        s.nombre AS segmento,
        COALESCE(SUM(i.importe),0) AS ingresos,
        COALESCE(SUM(c.importe),0) AS costos,
        COALESCE(SUM(i.importe),0) - COALESCE(SUM(c.importe),0) AS rentabilidad
    FROM periodos p
    INNER JOIN ingresos i
        ON p.id = i.periodo_id
    RIGHT JOIN clientes cl
        ON i.cliente_id = cl.id
    INNER JOIN segmentos s
        ON cl.segmento_id = s.id
    LEFT JOIN costos c
        ON c.periodo_id = p.id
        AND c.cliente_id = cl.id
    GROUP BY
        p.anio,
        p.mes,
        s.id,
        s.nombre
),
Ranking AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY anio, mes
            ORDER BY rentabilidad DESC
        ) AS rn
    FROM RentabilidadSegmento
)
SELECT
    anio AS Año,
    mes AS Mes,
    segmento AS Segmento,
    rentabilidad AS Rentabilidad
FROM Ranking
WHERE rn = 1 AND anio IS NOT NULL
ORDER BY
    anio,
    mes;

/*
Ejercicio 30 — Detectar clientes potencialmente problemáticos ⭐⭐⭐
El banco quiere identificar clientes que:

Generan altos ingresos.
También generan altos costos.
Presentan una disminución de rentabilidad.
Definir criterios apropiados y construir una consulta que identifique estos clientes.

El resultado debería contener:

Cliente
Segmento
Ingresos actuales
Costos actuales
Rentabilidad actual
Rentabilidad periodo anterior
Variación
Nivel de riesgo
*/
SELECT YEAR(DATEADD(MONTH,-1,GETDATE())),MONTH(DATEADD(MONTH,-1,GETDATE()))

WITH Rentabilidadanterior AS(
 SELECT CONCAT(p.anio,p.mes) AS periodo,
    cl.codigo,
    s.nombre AS 'segmento',
    COALESCE(SUM(i.importe),0)-COALESCE(SUM(c.importe),0) AS rentabilidad_anterior
FROM clientes cl
    INNER JOIN segmentos s ON s.id=cl.segmento_id
    LEFT JOIN ingresos i ON i.cliente_id = cl.id
    LEFT JOIN costos c ON c.cliente_id = cl.id
    INNER JOIN periodos p ON p.id=i.periodo_id AND p.id=c.periodo_id
WHERE 
    YEAR(DATEADD(MONTH,-1,GETDATE()))= p.anio AND
    MONTH(DATEADD(MONTH,-1,GETDATE()))= p.mes
GROUP BY 
    p.anio,
    p.mes, 
    cl.codigo,
    s.nombre
)
SELECT
    CONCAT(p.anio,p.mes) AS periodo,
    cl.codigo AS 'codigo_cliente',
    s.nombre AS 'segmento',
    COALESCE(SUM(i.importe),0) AS ingresos,
    COALESCE(SUM(c.importe),0) AS costos,
    COALESCE(SUM(i.importe),0)-COALESCE(SUM(c.importe),0) AS rentabilidad,
    ra.rentabilidad_anterior,
    (COALESCE(SUM(i.importe),0)-COALESCE(SUM(c.importe),0)) - ra.rentabilidad_anterior AS variacion
INTO #T05
FROM clientes cl
    INNER JOIN segmentos s ON s.id=cl.segmento_id
    LEFT JOIN ingresos i ON i.cliente_id = cl.id
    LEFT JOIN costos c ON c.cliente_id = cl.id
    INNER JOIN periodos p ON p.id=i.periodo_id AND p.id=c.periodo_id
    INNER JOIN Rentabilidadanterior ra ON ra.codigo=cl.codigo
WHERE 
    YEAR(GETDATE())= p.anio AND
    MONTH(GETDATE())= p.mes
GROUP BY 
    p.anio,
    p.mes, 
    cl.codigo,
    s.nombre,
    ra.rentabilidad_anterior
HAVING 
    (COALESCE(SUM(i.importe),0)-COALESCE(SUM(c.importe),0)) - ra.rentabilidad_anterior <0 OR 
    (COALESCE(SUM(i.importe),0)>'10000' AND COALESCE(SUM(C.importe),0)>'10000');


SELECT
*,
CASE WHEN variacion > 0 THEN 'Moderado'
WHEN variacion <0 AND ABS(variacion) < rentabilidad THEN 'Alta'
WHEN variacion <0 AND ABS(variacion) > rentabilidad THEN 'Muy alta'
END  AS 'nivel_riesgo'
FROM #t05;


/*
Ejercicio 31 — Rentabilidad acumulada
Calcular la rentabilidad acumulada de cada cliente a través del tiempo.

Ejemplo:

Cliente  Mes       Rentabilidad  Acumulada
-------  --------  ------------  ----------
C001     Ene       1,000         1,000
C001     Feb       1,500         2,500
C001     Mar       -500          2,000
Conceptos sugeridos
SUM() OVER()
ORDER BY
ROWS BETWEEN
*/

WITH ingresos_mensuales AS (
    SELECT
        i.cliente_id,
        p.anio,
        p.mes,
        ISNULL(SUM(i.importe), 0) AS ingreso_cliente
    FROM dbo.ingresos AS i
    INNER JOIN dbo.periodos AS p
        ON i.periodo_id = p.id
    GROUP BY
        i.cliente_id,
        p.anio,
        p.mes
),
costos_mensuales AS (
    SELECT
        c.cliente_id,
        p.anio,
        p.mes,
        ISNULL(SUM(c.importe), 0) AS costo_cliente
    FROM dbo.costos AS c
    INNER JOIN dbo.periodos AS p
        ON c.periodo_id = p.id
    GROUP BY
        c.cliente_id,
        p.anio,
        p.mes
),
rentabilidad_mensual AS (
    SELECT
    cl.id AS 'cliente_id',
    cl.codigo, 
    p.anio,
    p.mes,
    ISNULL(ingreso_cliente,0) AS ingresos,
    ISNULL(costo_cliente,0) AS cosotos,
    dbo.fn_calcular_rentabilidad(ISNULL(ingreso_cliente,0) , ISNULL(costo_cliente,0)) AS rentabilidad
    FROM clientes cl
    CROSS JOIN periodos p
    LEFT JOIN ingresos_mensuales im ON im.cliente_id=cl.id AND im.anio=p.anio AND im.mes=p.mes
    LEFT JOIN costos_mensuales cm ON cm.cliente_id=cl.id AND cm.anio=p.anio AND cm.mes=p.mes
)
SELECT
    codigo AS 'cliente',
    anio,
    mes,
    rentabilidad,
    SUM(rentabilidad) OVER( PARTITION BY cliente_id ORDER BY anio, mes ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS 'rentabilidad_acumulada'
FROM rentabilidad_mensual
ORDER BY 1,2,3

