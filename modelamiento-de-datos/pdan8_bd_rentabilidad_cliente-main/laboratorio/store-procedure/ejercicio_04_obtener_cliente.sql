/*
Laboratorio de funciones y procedimientos
Ejercicio 4 — Procedimiento para consultar un cliente

Parámetro: @ClienteId INT (clientes.id, no clientes.codigo).
Si existe, muestra su información y el nombre de su segmento.
Si no existe o el parámetro es NULL, muestra un mensaje y termina.
La consulta filtra por el ID solicitado para no devolver otros clientes.

Conceptos:
- IF NOT EXISTS comprueba si falta el cliente.
- PRINT muestra un aviso en la pestaña Mensajes de SSMS.
- RETURN termina el procedimiento sin ejecutar el SELECT posterior.
- INNER JOIN obtiene el segmento; WHERE selecciona un único cliente.

Ejecutar el archivo completo con F5 para crear o actualizar el procedimiento
y probar el ID 10. Solo consulta datos, no modifica las tablas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER PROCEDURE dbo.sp_obtener_cliente
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;

    IF NOT EXISTS (
        SELECT 1
        FROM dbo.clientes
        WHERE id = @ClienteId
    )
    BEGIN
        PRINT N'No se encontró un cliente con el identificador indicado.';
        RETURN;
    END;

    SELECT
        c.id AS ClienteId,
        c.codigo AS CodigoCliente,
        c.tipo_cliente AS TipoCliente,
        c.estado AS Estado,
        c.fecha_alta AS FechaAlta,
        c.segmento_id AS SegmentoId,
        s.nombre AS Segmento
    FROM dbo.clientes AS c
    INNER JOIN dbo.segmentos AS s
        ON s.id = c.segmento_id
    WHERE c.id = @ClienteId;
END;
GO

-- Ejemplo del enunciado. Si existe el ID 10, devuelve sus datos.
EXEC dbo.sp_obtener_cliente @ClienteId = 10;

-- Prueba opcional: NULL no identifica a ningún cliente.
-- Ejecutar esta línea sin los dos guiones y revisar la pestaña Mensajes.
-- EXEC dbo.sp_obtener_cliente @ClienteId = NULL;
