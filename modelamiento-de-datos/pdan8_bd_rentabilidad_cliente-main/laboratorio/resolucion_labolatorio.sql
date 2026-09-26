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