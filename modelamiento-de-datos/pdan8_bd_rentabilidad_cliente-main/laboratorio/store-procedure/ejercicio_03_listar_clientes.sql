/*
Laboratorio de funciones y procedimientos
Ejercicio 3 — Primer procedimiento almacenado

Crear dbo.sp_listar_clientes para mostrar:
- Código del cliente.
- Tipo de cliente (N: natural, J: jurídica).
- Estado.
- Fecha de alta.
- Nombre del segmento.

Orden: código del cliente de menor a mayor (ASC).
El procedimiento no recibe parámetros y solo consulta datos.

INNER JOIN relaciona clientes.segmento_id con segmentos.id.
En el modelo, cada cliente tiene un segmento obligatorio con clave foránea.
SET NOCOUNT ON evita los mensajes adicionales de cantidad de filas afectadas.
GO separa los lotes para definir el procedimiento y luego ejecutarlo.

Uso: ejecutar el archivo completo con F5 en SSMS para crear o actualizar
el procedimiento y mostrar los clientes. Después puede utilizarse EXEC
sin volver a ejecutar su definición.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER PROCEDURE dbo.sp_listar_clientes
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        c.codigo AS CodigoCliente,
        c.tipo_cliente AS TipoCliente,
        c.estado AS Estado,
        c.fecha_alta AS FechaAlta,
        s.nombre AS Segmento
    FROM dbo.clientes AS c
    INNER JOIN dbo.segmentos AS s
        ON s.id = c.segmento_id
    ORDER BY c.codigo ASC;
END;
GO

-- Ejecutar el procedimiento para consultar el listado.
EXEC dbo.sp_listar_clientes;
