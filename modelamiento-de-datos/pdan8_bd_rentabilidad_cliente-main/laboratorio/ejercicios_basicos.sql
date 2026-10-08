/*
PRÁCTICA DE SQL DESDE CERO
Base de datos: pdan_8_rentabilidad_cliente_v2

Cómo practicar en SQL Server Management Studio (SSMS):
1. Ejecuta primero USE y GO para seleccionar la base de datos.
2. Lee un ejercicio y escribe tu consulta en el espacio indicado.
3. Selecciona únicamente esa consulta y presiona F5.
4. Compara tu respuesta con las soluciones al final del archivo.
5. Guarda tus cambios con Ctrl+S.

Los comentarios entre /* y */ o después de -- no se ejecutan.
Estos ejercicios solo consultan datos; no los modifican.
*/

USE pdan_8_rentabilidad_cliente_v2;
GO

/* EJEMPLO A — Saber qué tablas existen
sys.tables contiene información sobre las tablas de la base actual.
AS cambia el título de la columna del resultado.
ORDER BY ordena las filas.
*/
SELECT name AS nombre_tabla
FROM sys.tables
ORDER BY name;

/* 
canales
categoria_productos
clientes
contrataciones
costos
ingresos
operaciones
periodos
personas_juridicas
personas_naturales
productos
segmentos
sysdiagrams */



/* EJEMPLO B — Explorar una tabla
SELECT indica qué columnas mostrar; * significa todas las columnas.
FROM indica la tabla que consultamos.
TOP (10) limita la salida a 10 filas.
ORDER BY id permite elegirlas siguiendo el orden del identificador.
dbo es el esquema al que pertenece la tabla.
*/
SELECT TOP (10) *
FROM dbo.clientes
ORDER BY id;




/* EJERCICIO 1 — Elegir columnas
Muestra codigo, tipo_cliente y estado de la tabla clientes.
Pista: escribe las columnas separadas por comas después de SELECT.
*/
-- Escribe tu consulta aquí:

select codigo, tipo_cliente, estado from dbo.clientes;

/* codigo tipo_cliente estado
------ ------------ -------------------------
C00234 N            inactivo
C01066 N            activo
C00231 N            activo
 */




/* EJERCICIO 2 — Ordenar clientes
Muestra codigo y estado de clientes, ordenados por codigo de menor
a mayor. Pista: ORDER BY codigo ASC.
Después prueba DESC y observa la diferencia.
*/
-- Escribe tu consulta aquí:

select codigo, estado from dbo.clientes order by codigo asc;

/* EJERCICIO 3 — Mostrar clientes activos
Muestra codigo y estado solo cuando estado sea 'activo'.
Pista: WHERE filtra filas. Los textos se escriben entre comillas simples.
*/
-- Escribe tu consulta aquí:
select codigo, estado from dbo.clientes where estado = 'activo';

/* EJERCICIO 4 — Filtrar por tipo de cliente
Muestra codigo y tipo_cliente de las personas jurídicas.
En esta base: 'N' = persona natural; 'J' = persona jurídica.
*/
-- Escribe tu consulta aquí:
select codigo, tipo_cliente from dbo.clientes where tipo_cliente = 'J';

/* EJERCICIO 5 — Combinar dos condiciones
Muestra codigo, tipo_cliente y estado de personas naturales activas.
Pista: usa WHERE y AND para exigir ambas condiciones.
*/
-- Escribe tu consulta aquí:
select codigo, tipo_cliente, estado from dbo.clientes where tipo_cliente = 'N' and estado = 'activo';

/* EJERCICIO 6 — Explorar productos
Muestra codigo, nombre, moneda y estado de productos.
Ordena alfabéticamente por nombre.
*/
-- Escribe tu consulta aquí:
select codigo, nombre, moneda, estado from dbo.productos order by nombre;


/* EJERCICIO 7 — Filtrar importes
Muestra id, cliente_id e importe de ingresos cuyo importe sea mayor
que 500. Ordena de mayor a menor importe.
Pista: WHERE importe > 500. Los números no necesitan comillas.
*/
-- Escribe tu consulta aquí:
select id, cliente_id, importe from dbo.ingresos where importe > 500 order by importe desc;


/* EJERCICIO 8 — Contar clientes
Obtén la cantidad total de filas de clientes.
Pista: COUNT(*) cuenta filas. Nombra el resultado cantidad_clientes.
*/
-- Escribe tu consulta aquí:
select count(*) as cantidad_clientes from dbo.clientes;


/* EJERCICIO 9 — Contar clientes activos
Combina COUNT(*) con WHERE para contar solo los clientes activos.
*/
-- Escribe tu consulta aquí:
select count(*) as cantidad_clientes_activos from dbo.clientes where estado = 'activo';

/* EJERCICIO 10 — Sumar ingresos
Obtén el total de la columna importe de ingresos.
Pista: SUM(importe). Nombra el resultado total_ingresos.
*/
-- Escribe tu consulta aquí:


/* EJERCICIO 11 — Ingreso mínimo, máximo y promedio
Sobre la columna importe de ingresos, calcula MIN, MAX y AVG.
Estas medidas corresponden a los registros de ingresos, no al total
acumulado por cliente.
*/
-- Escribe tu consulta aquí:


/* EJERCICIO 12 — Primer paso con GROUP BY
Cuenta cuántos clientes hay en cada estado.
Muestra estado y cantidad_clientes.
Pista: GROUP BY estado forma un grupo para cada estado;
COUNT(*) cuenta las filas de cada grupo.
*/
-- Escribe tu consulta aquí:


/* EJERCICIO 13 — Ingreso por cliente, sin JOIN todavía
En ingresos, muestra cliente_id y la suma de importe por cliente.
Ordena de mayor a menor ingreso total.
Pista: GROUP BY cliente_id.
Solo aparecerán clientes que tengan registros en ingresos.
*/
-- Escribe tu consulta aquí:


/*
SOLUCIONES DE REFERENCIA
Intenta resolver cada ejercicio antes de mirar su respuesta.
Las soluciones están comentadas para que no se ejecuten todas juntas.
Para probar una, copia la consulta fuera de este comentario y ejecútala.

-- Ejercicio 1
SELECT codigo, tipo_cliente, estado
FROM dbo.clientes;

-- Ejercicio 2
SELECT codigo, estado
FROM dbo.clientes
ORDER BY codigo ASC;

-- Ejercicio 3
SELECT codigo, estado
FROM dbo.clientes
WHERE estado = 'activo';

-- Ejercicio 4
SELECT codigo, tipo_cliente
FROM dbo.clientes
WHERE tipo_cliente = 'J';

-- Ejercicio 5
SELECT codigo, tipo_cliente, estado
FROM dbo.clientes
WHERE tipo_cliente = 'N' AND estado = 'activo';

-- Ejercicio 6
SELECT codigo, nombre, moneda, estado
FROM dbo.productos
ORDER BY nombre;

-- Ejercicio 7
SELECT id, cliente_id, importe
FROM dbo.ingresos
WHERE importe > 500
ORDER BY importe DESC, id;

-- Ejercicio 8
SELECT COUNT(*) AS cantidad_clientes
FROM dbo.clientes;

-- Ejercicio 9
SELECT COUNT(*) AS cantidad_clientes_activos
FROM dbo.clientes
WHERE estado = 'activo';

-- Ejercicio 10
SELECT SUM(importe) AS total_ingresos
FROM dbo.ingresos;

-- Ejercicio 11
SELECT MIN(importe) AS ingreso_minimo,
       MAX(importe) AS ingreso_maximo,
       AVG(importe) AS ingreso_promedio
FROM dbo.ingresos;

-- Ejercicio 12
SELECT estado, COUNT(*) AS cantidad_clientes
FROM dbo.clientes
GROUP BY estado
ORDER BY estado;

-- Ejercicio 13
SELECT cliente_id, SUM(importe) AS ingreso_cliente
FROM dbo.ingresos
GROUP BY cliente_id
ORDER BY ingreso_cliente DESC, cliente_id;
*/
