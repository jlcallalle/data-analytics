/*
Laboratorio de funciones y procedimientos
Ejercicio 2 — Función escalar para clasificar la rentabilidad

Reglas:
- Rentabilidad >= 10000: Alta.
- Rentabilidad >= 5000 y < 10000: Media.
- Rentabilidad >= 0 y < 5000: Baja.
- Rentabilidad < 0: Pérdida.

CASE evalúa las condiciones en orden y devuelve la primera coincidencia.
Por eso los límites se comprueban de mayor a menor.
Si el parámetro es NULL, devuelve NULL: no hay un importe que clasificar.
NVARCHAR conserva la tilde de Pérdida; N indica una cadena Unicode.
DECIMAL(19,2) admite el retorno de la función del ejercicio 1.

Ejecutar completo con F5 en SSMS. Crea o actualiza la función y después
ejecuta ejemplos de consulta. No modifica datos de las tablas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER FUNCTION dbo.fn_clasificar_rentabilidad
(
    @Rentabilidad DECIMAL(19,2)
)
RETURNS NVARCHAR(10)
AS
BEGIN
    RETURN CASE
        WHEN @Rentabilidad IS NULL THEN NULL
        WHEN @Rentabilidad >= 10000 THEN N'Alta'
        WHEN @Rentabilidad >= 5000 THEN N'Media'
        WHEN @Rentabilidad >= 0 THEN N'Baja'
        ELSE N'Pérdida'
    END;
END;
GO

-- Ejemplo del enunciado: devuelve Alta.
SELECT dbo.fn_clasificar_rentabilidad(12000) AS Clasificacion;

-- Comprobación de categorías, límites y NULL.
SELECT
    c.rentabilidad,
    c.esperado,
    r.clasificacion AS resultado,
    CASE
        WHEN r.clasificacion = c.esperado
          OR (r.clasificacion IS NULL AND c.esperado IS NULL)
        THEN N'Correcto'
        ELSE N'Revisar'
    END AS comprobacion
FROM (VALUES
    (12000.00, N'Alta'),
    (10000.00, N'Alta'),
    (9999.99, N'Media'),
    (5000.00, N'Media'),
    (4999.99, N'Baja'),
    (0.00, N'Baja'),
    (-0.01, N'Pérdida'),
    (-500.00, N'Pérdida'),
    (NULL, NULL)
) AS c(rentabilidad, esperado)
CROSS APPLY (
    SELECT dbo.fn_clasificar_rentabilidad(c.rentabilidad) AS clasificacion
) AS r;
