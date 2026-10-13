/*
Laboratorio de funciones y procedimientos
Ejercicio 7 — Función para obtener los costos de un cliente

Crear dbo.fn_obtener_costos_cliente(@ClienteId INT).
Devuelve la suma de los importes de costos del cliente, considerando
todos los productos, tipos de costo y períodos registrados.

Reglas:
- Si el cliente tiene costos, devuelve su suma.
- Si no tiene costos, devuelve 0.00.
- Si el identificador no existe o es NULL, devuelve también 0.00,
  siguiendo el criterio del ejercicio 6. El resultado no distingue
  un cliente inexistente de uno sin costos.
- DECIMAL(38,2) conserva el tipo de resultado de SUM(importe).

Ejecutar completo en SSMS para crear o actualizar la función y consultar
los ejemplos. No modifica los datos de las tablas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER FUNCTION dbo.fn_obtener_costos_cliente
(
    @ClienteId INT
)
RETURNS DECIMAL(38,2)
AS
BEGIN
    DECLARE @TotalCostos DECIMAL(38,2);

    SELECT @TotalCostos = ISNULL(SUM(c.importe), 0)
    FROM dbo.costos AS c
    WHERE c.cliente_id = @ClienteId;

    RETURN @TotalCostos;
END;
GO

-- Ejemplo solicitado: el resultado depende de los datos del cliente 10.
SELECT dbo.fn_obtener_costos_cliente(10) AS Costos;

-- Comprobación manual: debe coincidir con el resultado anterior.
SELECT ISNULL(SUM(importe), 0) AS CostosEsperados
FROM dbo.costos
WHERE cliente_id = 10;

-- Parámetro NULL: devuelve 0.00 según la regla documentada.
SELECT dbo.fn_obtener_costos_cliente(NULL) AS CostosConIdNull;
