/*
Laboratorio de funciones y procedimientos
Ejercicio 1 — Función escalar para calcular rentabilidad

Parámetros: @Ingresos DECIMAL(18,2), @Costos DECIMAL(18,2).
Regla: rentabilidad = ingresos - costos.
Para este ejercicio, NULL se interpreta como cero en cada parámetro.
Por tanto, si ambos parámetros son NULL, el resultado es cero.
Esta es una convención del ejercicio: un dato desconocido no siempre
equivale a cero en un sistema real.

El retorno DECIMAL(19,2) conserva el rango de la resta de dos valores
DECIMAL(18,2), incluso cuando tienen signos opuestos.
Admite resultados positivos, negativos y cero.

Ejecutar completo en SSMS. CREATE OR ALTER crea o actualiza la función.
Los ejemplos finales consultan la función y no modifican tablas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER FUNCTION dbo.fn_calcular_rentabilidad
(
    @Ingresos DECIMAL(18,2),
    @Costos DECIMAL(18,2)
)
RETURNS DECIMAL(19,2)
AS
BEGIN
    RETURN ISNULL(@Ingresos, 0) - ISNULL(@Costos, 0);
END;
GO

-- Ejemplo básico: devuelve 700.00.
SELECT dbo.fn_calcular_rentabilidad(1000, 300) AS Rentabilidad;

-- Casos de comprobación: el resultado debe coincidir con el esperado.
SELECT
    caso,
    ingresos,
    costos,
    esperado,
    dbo.fn_calcular_rentabilidad(ingresos, costos) AS resultado,
    CASE
        WHEN dbo.fn_calcular_rentabilidad(ingresos, costos) = esperado
        THEN N'Correcto'
        ELSE N'Revisar'
    END AS comprobacion
FROM (VALUES
    (N'Positivo', 1000.00, 300.00, 700.00),
    (N'Negativo', 300.00, 500.00, -200.00),
    (N'Cero', 500.00, 500.00, 0.00),
    (N'Ingreso NULL', NULL, 200.00, -200.00),
    (N'Costo NULL', 1000.00, NULL, 1000.00),
    (N'Ambos NULL', NULL, NULL, 0.00)
) AS casos(caso, ingresos, costos, esperado);
