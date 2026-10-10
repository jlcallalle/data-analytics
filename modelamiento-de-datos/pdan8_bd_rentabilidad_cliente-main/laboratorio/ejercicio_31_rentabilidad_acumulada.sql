/*
Ejercicio 31 — Rentabilidad acumulada

Objetivo:
Calcular ingresos, costos, rentabilidad mensual y rentabilidad acumulada
de cada cliente a través del tiempo.

Segunda solución: CTE separadas para ingresos y costos.

Rentabilidad mensual = Ingresos del mes - Costos del mes.
Acumulada = Suma de rentabilidades desde el primer período hasta el actual.

Pasos:
1. Sumar ingresos por cliente y período.
2. Sumar costos por cliente y período.
3. Combinar cada cliente con todos los períodos mediante CROSS JOIN.
4. Incorporar las sumas con LEFT JOIN y reemplazar ausencias por cero.
5. Acumular por cliente en orden de año y mes mediante SUM() OVER().

Consideraciones:
- Incluye todos los períodos de la tabla, incluso anteriores al alta.
- Los meses sin movimientos tienen rentabilidad cero.
- El acumulado no se reinicia al cambiar de año.
- Ejecutar todo el archivo con F5. Solo consulta datos.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

;WITH ingresos_por_cliente AS (
    SELECT
        cliente_id,
        periodo_id,
        SUM(importe) AS ingreso_cliente
    FROM dbo.ingresos
    GROUP BY cliente_id, periodo_id
),
costos_por_cliente AS (
    SELECT
        cliente_id,
        periodo_id,
        SUM(importe) AS costo_cliente
    FROM dbo.costos
    GROUP BY cliente_id, periodo_id
),
rentabilidad_mensual AS (
    SELECT
        c.id AS cliente_id,
        c.codigo,
        p.anio,
        p.mes,
        ISNULL(i.ingreso_cliente, 0) AS ingresos,
        ISNULL(co.costo_cliente, 0) AS costos,
        ISNULL(i.ingreso_cliente, 0)
            - ISNULL(co.costo_cliente, 0) AS rentabilidad
    FROM dbo.clientes AS c
    CROSS JOIN dbo.periodos AS p
    LEFT JOIN ingresos_por_cliente AS i
        ON i.cliente_id = c.id
        AND i.periodo_id = p.id
    LEFT JOIN costos_por_cliente AS co
        ON co.cliente_id = c.id
        AND co.periodo_id = p.id
)
SELECT
    codigo AS Cliente,
    anio AS Anio,
    mes AS Mes,
    ingresos AS Ingresos,
    costos AS Costos,
    rentabilidad AS Rentabilidad,
    SUM(rentabilidad) OVER (
        PARTITION BY cliente_id
        ORDER BY CAST(anio AS INT), CAST(mes AS INT)
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS Acumulada
FROM rentabilidad_mensual
ORDER BY codigo, CAST(anio AS INT), CAST(mes AS INT);
