USE pdan_8_rentabilidad_cliente;

--- Laboratorio Funciones y procedimientos
/*

Ejercicio 1. Crear una función para calcular la rentabilidad
Crear una función escalar llamada fn_calcular_rentabilidad.

La función debe recibir dos parámetros:

@Ingresos DECIMAL(18,2)
@Costos DECIMAL(18,2)
Debe devolver la diferencia entre ambos valores.

Reglas
Si ambos parámetros tienen valores, calcular ingresos menos costos.
Si alguno es NULL, definir y documentar cómo debe comportarse la función.
El resultado debe admitir valores positivos, negativos y cero.
Ejemplo de uso esperado
*/


CREATE FUNCTION dbo.fn_calcular_rentabilidad (@Ingresos DECIMAL(18,2),
@Costos DECIMAL(18,2))
RETURNS DECIMAL(18,2)
AS 
BEGIN
DECLARE @rentabilidad DECIMAL(18,2);

SET @rentabilidad = @Ingresos-@Costos;

RETURN @rentabilidad;

END;

SELECT dbo.fn_calcular_rentabilidad(15000, 9000) AS Rentabilidad;

/*
Ejercicio 2. Función para clasificar la rentabilidad
Crear una función escalar llamada fn_clasificar_rentabilidad.

Debe recibir una rentabilidad y devolver una clasificación textual:

Condición	Clasificación
Rentabilidad >= 10000	Alta
Rentabilidad >= 5000	Media
Rentabilidad >= 0	Baja
Rentabilidad < 0	Pérdida
Ejemplo de uso esperado
SELECT dbo.fn_clasificar_rentabilidad(12000) AS Clasificacion;
Resultado esperado:

Clasificacion
-------------
Alta
Conceptos: CASE, funciones escalares y lógica condicional.

*/

CREATE FUNCTION fn_clasificar_rentabilidad (@rentabilidad DECIMAL(18,2))
RETURNS VARCHAR(55)
AS
BEGIN 

DECLARE @clasificacion VARCHAR(55)

SET @clasificacion = (SELECT CASE WHEN @rentabilidad >= 10000 THEN 'Alta'
								  WHEN @rentabilidad >= 5000 THEN 'Media'
								  WHEN @rentabilidad >= 0 THEN 'baja'
								  WHEN @rentabilidad < 0 THEN 'Pérdida'
								END)

RETURN @clasificacion

END;

SELECT dbo.fn_clasificar_rentabilidad(5005) AS Clasificacion


/*Ejercicio 3. Primer procedimiento almacenado
Crear el procedimiento sp_listar_clientes.

Debe mostrar:

Código del cliente.
Tipo de cliente.
Estado.
Fecha de alta.
Nombre del segmento.
Los resultados deben ordenarse por código de cliente.

Ejemplo de ejecución
EXEC dbo.sp_listar_clientes;
Conceptos: CREATE PROCEDURE, SELECT, JOIN, EXEC.

*/
SELECT
	cl.codigo,
	cl.tipo_cliente,
	cl.estado,
	cl.fecha_alta,
	s.nombre
FROM clientes cl
INNER JOIN segmentos s ON s.id=cl.segmento_id
ORDER BY cl.codigo 

CREATE PROCEDURE sp_listar_clientes
AS 
BEGIN
	SET NOCOUNT ON;

	SELECT
		cl.codigo,
		cl.tipo_cliente,
		cl.estado,
		cl.fecha_alta,
		s.nombre
	FROM clientes cl
	INNER JOIN segmentos s ON s.id=cl.segmento_id
	ORDER BY cl.codigo;
END;

EXEC sp_listar_clientes;

/*
Ejercicio 4. Procedimiento para consultar un cliente
Crear el procedimiento sp_obtener_cliente.

Debe recibir el identificador del cliente y mostrar su información junto con su segmento.

Parámetro
@ClienteId INT
Ejemplo de ejecución
EXEC dbo.sp_obtener_cliente @ClienteId = 10;
Reglas
Si el cliente existe, mostrar sus datos.
Si no existe, informar que no se encontró.
Evitar devolver información de otros clientes.
Conceptos: parámetros de entrada, filtros y validación de existencia.
*/



CREATE PROCEDURE dbo.sp_obtener_cliente
    @ClienteId INT
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (
        SELECT 1
        FROM dbo.clientes
        WHERE id = @ClienteId
    )
    BEGIN
        SELECT
            c.id AS ClienteId,
            c.codigo AS Codigo,
            c.tipo_cliente AS TipoCliente,
            c.fecha_alta AS FechaRegistro,
            c.estado AS Estado,
            s.nombre AS Segmento
        FROM dbo.clientes AS c
        INNER JOIN dbo.segmentos AS s
            ON s.id = c.segmento_id
        WHERE c.id = @ClienteId;
    END
    ELSE
    BEGIN
        PRINT 'No se encontró un cliente con el ID especificado.';
    END
END;

EXEC dbo.sp_obtener_cliente 25

/*
Ejercicio 5. Procedimiento para consultar productos activos
Crear sp_listar_productos_activos.

Debe mostrar los productos cuyo estado sea activo, incluyendo el nombre de su categoría.

Agregar un parámetro opcional para filtrar por moneda (PEN, USD o EUR).

Si el parámetro no se proporciona, deben mostrarse todos los productos activos, independientemente de la moneda.

Ejemplos de ejecución
EXEC dbo.sp_listar_productos_activos;

EXEC dbo.sp_listar_productos_activos
    @Moneda = 'PEN';
Conceptos: parámetros opcionales y filtros dinámicos mediante condiciones.
*/

CREATE PROCEDURE dbo.sp_listar_productos_activos
    @Moneda VARCHAR(3) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SELECT
        p.id AS ProductoId,
        p.codigo AS Codigo,
        p.nombre AS Producto,
        cp.nombre AS Categoria,
        p.tipo_producto AS TipoProducto,
        p.moneda AS Moneda,
        p.estado AS Estado
    FROM dbo.productos AS p
    INNER JOIN dbo.categoria_productos AS cp
        ON p.categoria_id = cp.id
    WHERE p.estado = 'activo'
      AND (@Moneda IS NULL OR p.moneda = @Moneda)
    ORDER BY p.nombre;
END;

EXEC sp_listar_productos_activos 'USD'; 

/*
Ejercicio 6. Función para obtener los ingresos de un cliente
Crear fn_obtener_ingresos_cliente.

Debe recibir el identificador de un cliente y devolver la suma de sus ingresos registrados.

Ejemplo de uso
SELECT dbo.fn_obtener_ingresos_cliente(10) AS Ingresos;
Reglas
Si el cliente no tiene ingresos, devolver cero.
Si el identificador no corresponde a un cliente válido, definir el comportamiento esperado.
La función debe devolver un valor numérico.
Conceptos: SUM, agregaciones, ISNULL o COALESCE.
*/

CREATE FUNCTION fn_obtener_ingresos_cliente
(
    @ClienteId INT
)
RETURNS DECIMAL(18, 2)
AS
BEGIN
    DECLARE @Ingresos DECIMAL(18, 2);
    IF NOT EXISTS (
        SELECT 1
        FROM dbo.clientes
        WHERE id = @ClienteId
    )
    BEGIN
        RETURN NULL;
    END;
    SELECT
        @Ingresos = ISNULL(SUM(importe), 0)
    FROM dbo.ingresos
    WHERE cliente_id = @ClienteId;
    RETURN @Ingresos;
END;

SELECT dbo.fn_obtener_ingresos_cliente (5)


SELECT codigo , dbo.fn_obtener_ingresos_cliente (id) AS 'Ingresos_clientes' FROM clientes;
