/*
Laboratorio de funciones y procedimientos
Ejercicio 5 — Consultar productos activos

Crear dbo.sp_listar_productos_activos.
Mostrar productos con estado activo, incluyendo el nombre de su categoría.
Parámetro opcional: @Moneda VARCHAR(25) = NULL.
- Si se omite o se envía NULL, muestra activos de todas las monedas.
- Si se indica PEN, USD o EUR, muestra solo activos de esa moneda.
- Una moneda no permitida genera un error explicativo.

La condición (@Moneda IS NULL OR p.moneda = @Moneda) aplica el filtro
solo cuando se proporciona una moneda. El filtro de estado siempre aplica.
Se normalizan mayúsculas y espacios exteriores del parámetro.

Ejecutar completo con F5 para crear o actualizar el procedimiento y probar
las consultas. No modifica los datos de productos ni categorías.
Si no hay productos activos de la moneda indicada, devuelve cero filas.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

CREATE OR ALTER PROCEDURE dbo.sp_listar_productos_activos
    @Moneda VARCHAR(25) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SET @Moneda = UPPER(LTRIM(RTRIM(@Moneda)));

    IF @Moneda IS NOT NULL AND @Moneda NOT IN ('PEN', 'USD', 'EUR')
    BEGIN
        THROW 50001, N'Moneda no válida. Utilice PEN, USD, EUR o NULL para todas.', 1;
    END;

    SELECT
        p.codigo AS CodigoProducto,
        p.nombre AS Producto,
        c.nombre AS Categoria,
        p.tipo_producto AS TipoProducto,
        p.moneda AS Moneda,
        p.estado AS Estado
    FROM dbo.productos AS p
    INNER JOIN dbo.categoria_productos AS c
        ON c.id = p.categoria_id
    WHERE p.estado = 'activo'
      AND (@Moneda IS NULL OR p.moneda = @Moneda)
    ORDER BY p.codigo ASC;
END;
GO

-- Todos los productos activos, independientemente de su moneda.
EXEC dbo.sp_listar_productos_activos;

-- Solo los productos activos en soles.
EXEC dbo.sp_listar_productos_activos @Moneda = 'PEN';

-- Pruebas opcionales: ejecutar sin los guiones iniciales.
-- EXEC dbo.sp_listar_productos_activos @Moneda = 'USD';
-- EXEC dbo.sp_listar_productos_activos @Moneda = 'EUR';
-- EXEC dbo.sp_listar_productos_activos @Moneda = NULL;
-- EXEC dbo.sp_listar_productos_activos @Moneda = 'ABC'; -- Error esperado.
