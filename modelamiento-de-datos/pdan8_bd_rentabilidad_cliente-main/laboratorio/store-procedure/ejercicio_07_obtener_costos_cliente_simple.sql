/*
Ejercicio 7 — Versión simple
Devuelve el total de costos de un cliente.
Si no tiene costos, el identificador no existe o es NULL, devuelve cero.
*/
USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER FUNCTION dbo.fn_obtener_costos_cliente (@ClienteId INT)
RETURNS DECIMAL(38,2)
AS
BEGIN
    RETURN (
        SELECT ISNULL(SUM(importe), 0)
        FROM dbo.costos
        WHERE cliente_id = @ClienteId
    );
END;
GO

SELECT dbo.fn_obtener_costos_cliente(10) AS Costos;
