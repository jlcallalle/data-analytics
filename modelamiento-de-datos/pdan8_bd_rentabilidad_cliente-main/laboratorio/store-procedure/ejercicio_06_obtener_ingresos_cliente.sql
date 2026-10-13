/*
Laboratorio de funciones y procedimientos
Ejercicio 6 — Función para obtener los ingresos de un cliente

Crear dbo.fn_obtener_ingresos_cliente(@ClienteId INT).
Devuelve la suma de los importes registrados para ese cliente,
considerando todos los productos y períodos.

Reglas de este ejercicio:
- Cliente con ingresos: devuelve SUM(importe).
- Cliente sin ingresos: devuelve 0.00.
- Identificador inexistente o NULL: devuelve también 0.00.
  Esta decisión simplifica la función, pero no permite distinguir
  un cliente inexistente de uno que no tiene ingresos.
- El resultado es DECIMAL(38,2), el tipo que devuelve SUM sobre
  el importe DECIMAL(12,2) de la tabla ingresos.

Ejecutar completo en SSMS para crear o actualizar la función.
Los ejemplos solo consultan datos; no modifican las tablas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER FUNCTION dbo.fn_obtener_ingresos_cliente
(
    @ClienteId INT
)
RETURNS DECIMAL(38,2)
AS
BEGIN
    DECLARE @TotalIngresos DECIMAL(38,2);

    SELECT @TotalIngresos = ISNULL(SUM(i.importe), 0)
    FROM dbo.ingresos AS i
    WHERE i.cliente_id = @ClienteId;

    RETURN @TotalIngresos;
END;
GO

-- Ejemplo solicitado: el resultado depende de los datos del cliente 10.
SELECT dbo.fn_obtener_ingresos_cliente(10) AS Ingresos;

-- Comprobación manual: debe coincidir con el resultado anterior.
SELECT ISNULL(SUM(importe), 0) AS IngresosEsperados
FROM dbo.ingresos
WHERE cliente_id = 10;

-- Parámetro NULL: devuelve 0.00 según la regla documentada.
SELECT dbo.fn_obtener_ingresos_cliente(NULL) AS IngresosConIdNull;
