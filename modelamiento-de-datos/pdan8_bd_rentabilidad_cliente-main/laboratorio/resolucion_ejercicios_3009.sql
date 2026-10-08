/*
Ejercicio 29 — Segmento más rentable por mes

Determinar qué segmento generó mayor rentabilidad en cada mes.
Rentabilidad = Ingresos - Costos

Mostrar: Año, Mes, Segmento y Rentabilidad.
*/


USE pdan_8_rentabilidad_cliente_v2;
GO

;WITH movimientos AS (
    -- Ingresos: aportan positivamente a la rentabilidad.
    SELECT
        c.segmento_id,
        i.periodo_id,
        i.importe AS importe_neto
    FROM dbo.ingresos AS i
    INNER JOIN dbo.clientes AS c
        ON c.id = i.cliente_id

    UNION ALL

    -- Costos: se restan de la rentabilidad.
    SELECT
        c.segmento_id,
        co.periodo_id,
        -co.importe AS importe_neto
    FROM dbo.costos AS co
    INNER JOIN dbo.clientes AS c
        ON c.id = co.cliente_id
),
rentabilidad_segmento AS (
    -- Sumar ingresos y restar costos por segmento y período.
    SELECT
        segmento_id,
        periodo_id,
        SUM(importe_neto) AS rentabilidad
    FROM movimientos
    GROUP BY segmento_id, periodo_id
),
ranking_mensual AS (
    -- Ordenar los segmentos dentro de cada mes.
    SELECT
        p.anio,
        p.mes,
        s.nombre AS segmento,
        r.rentabilidad,
        ROW_NUMBER() OVER (
            PARTITION BY r.periodo_id
            ORDER BY r.rentabilidad DESC, s.id ASC
        ) AS posicion
    FROM rentabilidad_segmento AS r
    INNER JOIN dbo.periodos AS p
        ON p.id = r.periodo_id
    INNER JOIN dbo.segmentos AS s
        ON s.id = r.segmento_id
)
SELECT
    anio AS Anio,
    mes AS Mes,
    segmento AS Segmento,
    rentabilidad AS Rentabilidad
FROM ranking_mensual
WHERE posicion = 1
ORDER BY anio, mes;





/*
Ejercicio 30 — Detectar clientes potencialmente problemáticos

Objetivo:
Identificar clientes con ingresos altos, costos altos
y una disminución de rentabilidad respecto al mes anterior.

Criterios del ejercicio:
1. Ingresos actuales superiores al promedio del mes.
2. Costos actuales superiores al promedio del mes.
3. Rentabilidad actual menor que la del mes anterior.

Los promedios incluyen clientes con ingresos o costos
registrados en el mes actual.

Nivel de riesgo:
- Alto: cumple los criterios y su rentabilidad actual es negativa.
- Medio: cumple los criterios y su rentabilidad actual no es negativa.

Fórmulas:
Rentabilidad = Ingresos - Costos
Variación = Rentabilidad actual - Rentabilidad anterior

Consideraciones:
- Se utiliza el último mes con movimientos registrados.
- Se compara contra el mes calendario inmediatamente anterior.
- Solo se comparan clientes con movimientos en ambos meses.
- Se utiliza el segmento actual del cliente.
- La clasificación es una regla de práctica del ejercicio.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

;WITH movimientos AS (
    -- Separar ingresos y costos sin multiplicar registros.
    SELECT
        cliente_id,
        periodo_id,
        importe AS ingresos,
        CAST(0 AS DECIMAL(12, 2)) AS costos
    FROM dbo.ingresos

    UNION ALL

    SELECT
        cliente_id,
        periodo_id,
        CAST(0 AS DECIMAL(12, 2)) AS ingresos,
        importe AS costos
    FROM dbo.costos
),
resumen_mensual AS (
    -- Calcular ingresos, costos y rentabilidad por cliente y mes.
    SELECT
        m.cliente_id,
        DATEFROMPARTS(
            CAST(p.anio AS INT),
            CAST(p.mes AS INT),
            1
        ) AS mes,
        SUM(m.ingresos) AS ingresos,
        SUM(m.costos) AS costos,
        SUM(m.ingresos) - SUM(m.costos) AS rentabilidad
    FROM movimientos AS m
    INNER JOIN dbo.periodos AS p
        ON p.id = m.periodo_id
    GROUP BY m.cliente_id, p.anio, p.mes
),
ultimo_mes AS (
    SELECT MAX(mes) AS mes_actual
    FROM resumen_mensual
),
datos_actuales AS (
    -- Calcular los promedios antes de filtrar a los clientes.
    SELECT
        r.*,
        AVG(r.ingresos) OVER () AS promedio_ingresos,
        AVG(r.costos) OVER () AS promedio_costos
    FROM resumen_mensual AS r
    INNER JOIN ultimo_mes AS u
        ON r.mes = u.mes_actual
),
comparacion AS (
    -- Buscar el mes calendario anterior de cada cliente.
    SELECT
        a.cliente_id,
        a.mes,
        a.ingresos,
        a.costos,
        a.rentabilidad AS rentabilidad_actual,
        anterior.rentabilidad AS rentabilidad_anterior,
        a.rentabilidad - anterior.rentabilidad AS variacion,
        a.promedio_ingresos,
        a.promedio_costos
    FROM datos_actuales AS a
    INNER JOIN resumen_mensual AS anterior
        ON anterior.cliente_id = a.cliente_id
        AND anterior.mes = DATEADD(MONTH, -1, a.mes)
)
SELECT
    c.codigo AS Cliente,
    s.nombre AS Segmento,
    YEAR(co.mes) AS Anio,
    MONTH(co.mes) AS Mes,
    co.ingresos AS IngresosActuales,
    co.costos AS CostosActuales,
    co.rentabilidad_actual AS RentabilidadActual,
    co.rentabilidad_anterior AS RentabilidadPeriodoAnterior,
    co.variacion AS Variacion,
    CASE
        WHEN co.rentabilidad_actual < 0 THEN 'Alto'
        ELSE 'Medio'
    END AS NivelRiesgo
FROM comparacion AS co
INNER JOIN dbo.clientes AS c
    ON c.id = co.cliente_id
INNER JOIN dbo.segmentos AS s
    ON s.id = c.segmento_id
WHERE co.ingresos > co.promedio_ingresos
  AND co.costos > co.promedio_costos
  AND co.variacion < 0
ORDER BY co.variacion ASC, c.codigo;