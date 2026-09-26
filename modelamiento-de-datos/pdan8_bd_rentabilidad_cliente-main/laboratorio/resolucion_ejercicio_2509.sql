/*
Ejercicio 20 - Participación de cada cliente
Calcular qué porcentaje de los ingresos totales representa cada cliente.

Resultado esperado:

Cliente    Ingresos    Participación
-------    --------    -------------
C00001     50,000      2.35%
C00002     30,000      1.41%
...
*/


USE pdan_8_rentabilidad_cliente_v2;
GO

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
    CAST(
        ingreso_cliente / NULLIF(ingreso_total, 0) * 100.0
        AS DECIMAL(10, 2)
    ) AS Participacion_Porcentaje
FROM ingresos_con_total
ORDER BY ingreso_cliente DESC, codigo;