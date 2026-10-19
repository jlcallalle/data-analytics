
# 🏦 Laboratorio SQL Server: Funciones y Procedimientos Almacenados

## 1. Descripción del laboratorio

Este laboratorio tiene como objetivo desarrollar habilidades para crear, utilizar, validar y optimizar funciones y procedimientos almacenados en SQL Server.

Los ejercicios utilizan la base de datos bancaria `pdan_8_rentabilidad_cliente`, orientada al análisis de rentabilidad por cliente.

La dificultad aumenta progresivamente desde la creación de objetos básicos hasta el diseño de soluciones reutilizables para procesos de negocio.

**Métrica principal del caso:**

```sql
RENTABILIDAD = INGRESOS - COSTOS
```

## 2. Tablas disponibles

El laboratorio utiliza las siguientes tablas:

- `segmentos`
- `canales`
- `categoria_productos`
- `productos`
- `clientes`
- `personas_naturales`
- `personas_juridicas`
- `periodos`
- `contrataciones`
- `operaciones`
- `ingresos`
- `costos`

Relaciones importantes:

```text
segmentos
    └── clientes
          ├── personas_naturales
          ├── personas_juridicas
          └── contrataciones
                  └── productos
                        └── categoria_productos

clientes ─── ingresos ─── productos
                 └─────── periodos

clientes ─── costos ───── productos
                 └─────── periodos

clientes ─── operaciones ─── canales
```

---

# 🟢 NIVEL 1 — PRINCIPIANTE

Objetivo: comprender la sintaxis y el uso básico de funciones definidas por el usuario y procedimientos almacenados.

## Ejercicio 1. Crear una función para calcular la rentabilidad

Crear una función escalar llamada `fn_calcular_rentabilidad`.

La función debe recibir dos parámetros:

- `@Ingresos DECIMAL(18,2)`
- `@Costos DECIMAL(18,2)`

Debe devolver la diferencia entre ambos valores.

### Reglas

- Si ambos parámetros tienen valores, calcular ingresos menos costos.
- Si alguno es `NULL`, definir y documentar cómo debe comportarse la función.
- El resultado debe admitir valores positivos, negativos y cero.

### Ejemplo de uso esperado

```sql
SELECT dbo.fn_calcular_rentabilidad(15000, 9000) AS Rentabilidad;
```

Resultado esperado:

```text
Rentabilidad
------------
6000.00
```

**Conceptos:** `CREATE FUNCTION`, parámetros, `RETURNS`, `RETURN`, `NULL`.

---

## Ejercicio 2. Función para clasificar la rentabilidad

Crear una función escalar llamada `fn_clasificar_rentabilidad`.

Debe recibir una rentabilidad y devolver una clasificación textual:

| Condición | Clasificación |
|---|---|
| Rentabilidad >= 10000 | Alta |
| Rentabilidad >= 5000 | Media |
| Rentabilidad >= 0 | Baja |
| Rentabilidad < 0 | Pérdida |

### Ejemplo de uso esperado

```sql
SELECT dbo.fn_clasificar_rentabilidad(12000) AS Clasificacion;
```

Resultado esperado:

```text
Clasificacion
-------------
Alta
```

**Conceptos:** `CASE`, funciones escalares y lógica condicional.

---

## Ejercicio 3. Primer procedimiento almacenado

Crear el procedimiento `sp_listar_clientes`.

Debe mostrar:

- Código del cliente.
- Tipo de cliente.
- Estado.
- Fecha de alta.
- Nombre del segmento.

Los resultados deben ordenarse por código de cliente.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_listar_clientes;
```

**Conceptos:** `CREATE PROCEDURE`, `SELECT`, `JOIN`, `EXEC`.

---

## Ejercicio 4. Procedimiento para consultar un cliente

Crear el procedimiento `sp_obtener_cliente`.

Debe recibir el identificador del cliente y mostrar su información junto con su segmento.

### Parámetro

```sql
@ClienteId INT
```

### Ejemplo de ejecución

```sql
EXEC dbo.sp_obtener_cliente @ClienteId = 10;
```

### Reglas

- Si el cliente existe, mostrar sus datos.
- Si no existe, informar que no se encontró.
- Evitar devolver información de otros clientes.

**Conceptos:** parámetros de entrada, filtros y validación de existencia.

---

## Ejercicio 5. Procedimiento para consultar productos activos

Crear `sp_listar_productos_activos`.

Debe mostrar los productos cuyo estado sea `activo`, incluyendo el nombre de su categoría.

Agregar un parámetro opcional para filtrar por moneda (`PEN`, `USD` o `EUR`).

Si el parámetro no se proporciona, deben mostrarse todos los productos activos, independientemente de la moneda.

### Ejemplos de ejecución

```sql
EXEC dbo.sp_listar_productos_activos;

EXEC dbo.sp_listar_productos_activos
    @Moneda = 'PEN';
```

**Conceptos:** parámetros opcionales y filtros dinámicos mediante condiciones.

---

# 🟡 NIVEL 2 — BÁSICO / INTERMEDIO

Objetivo: trabajar con agregaciones, parámetros y resultados de negocio.

## Ejercicio 6. Función para obtener los ingresos de un cliente

Crear `fn_obtener_ingresos_cliente`.

Debe recibir el identificador de un cliente y devolver la suma de sus ingresos registrados.

### Ejemplo de uso

```sql
SELECT dbo.fn_obtener_ingresos_cliente(10) AS Ingresos;
```

### Reglas

- Si el cliente no tiene ingresos, devolver cero.
- Si el identificador no corresponde a un cliente válido, definir el comportamiento esperado.
- La función debe devolver un valor numérico.

**Conceptos:** `SUM`, agregaciones, `ISNULL` o `COALESCE`.

---

## Ejercicio 7. Función para obtener los costos de un cliente

Crear `fn_obtener_costos_cliente`.

Debe recibir el identificador del cliente y devolver el importe total de sus costos.

Debe contemplar clientes sin registros de costos.

### Ejemplo de uso

```sql
SELECT dbo.fn_obtener_costos_cliente(10) AS Costos;
```

---

## Ejercicio 8. Procedimiento para calcular la rentabilidad de un cliente

Crear `sp_rentabilidad_cliente`.

Debe recibir el identificador del cliente y mostrar:

- Código del cliente.
- Segmento.
- Ingresos totales.
- Costos totales.
- Rentabilidad.
- Clasificación de rentabilidad.

La clasificación debe utilizar la función del ejercicio 2.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_rentabilidad_cliente
    @ClienteId = 10;
```

### Condiciones

- Un cliente sin ingresos debe mostrar ingresos iguales a cero.
- Un cliente sin costos debe mostrar costos iguales a cero.
- La ausencia de registros no debe provocar que la rentabilidad aparezca como `NULL`.

**Conceptos:** procedimientos, agregaciones, reutilización de funciones y tratamiento de valores nulos.

---

## Ejercicio 9. Procedimiento para consultar la rentabilidad por segmento

Crear `sp_rentabilidad_segmento`.

Debe recibir el identificador de un segmento y mostrar:

- Nombre del segmento.
- Cantidad de clientes.
- Ingresos totales.
- Costos totales.
- Rentabilidad total.
- Rentabilidad promedio por cliente.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_rentabilidad_segmento
    @SegmentoId = 3;
```

### Pregunta de análisis

¿Qué diferencia existe entre la rentabilidad total del segmento y la rentabilidad promedio por cliente?

---

## Ejercicio 10. Procedimiento para consultar operaciones por fechas

Crear `sp_operaciones_por_periodo`.

Debe recibir:

- Fecha inicial.
- Fecha final.
- Canal opcional.

Debe mostrar:

- Cantidad de operaciones.
- Importe total.
- Importe promedio.
- Cantidad de operaciones procesadas.
- Cantidad de operaciones anuladas.
- Cantidad de operaciones pendientes.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_operaciones_por_periodo
    @FechaInicio = '2026-01-01',
    @FechaFin = '2026-01-31',
    @CanalId = NULL;
```

### Reglas

- Validar que la fecha inicial no sea posterior a la fecha final.
- Considerar ambas fechas completas, incluyendo todas las operaciones del último día.
- Definir el comportamiento cuando no existan operaciones.
- El canal debe ser opcional.

**Conceptos:** parámetros, `SUM`, `AVG`, `COUNT`, agregación condicional y filtros temporales.

---

# 🟠 NIVEL 3 — INTERMEDIO

Objetivo: trabajar con funciones que devuelven tablas y procedimientos reutilizables.

## Ejercicio 11. Función tabular para rentabilidad por cliente

Crear una función con valor de tabla llamada `fn_rentabilidad_clientes`.

Debe devolver una tabla con:

- ID del cliente.
- Código del cliente.
- Segmento.
- Ingresos.
- Costos.
- Rentabilidad.

Debe incluir todos los clientes, incluso aquellos que no tengan ingresos o costos registrados.

### Ejemplo de uso

```sql
SELECT *
FROM dbo.fn_rentabilidad_clientes();
```

### Reglas

- Los importes inexistentes deben tratarse como cero.
- La función debe poder utilizarse en una consulta con filtros adicionales.
- No incluir una clasificación fija de rentabilidad si puede calcularse posteriormente en la consulta consumidora.

**Conceptos:** funciones tabulares en línea (*inline table-valued functions*), `LEFT JOIN`, agregación y reutilización.

---

## Ejercicio 12. Función tabular para clientes de un segmento

Crear `fn_clientes_por_segmento`.

Debe recibir el ID de un segmento y devolver sus clientes con:

- Código.
- Estado.
- Tipo de cliente.
- Fecha de alta.

### Ejemplo de uso

```sql
SELECT *
FROM dbo.fn_clientes_por_segmento(3);
```

### Reto adicional

Consultar únicamente los clientes activos de ese segmento sin modificar la función.

---

## Ejercicio 13. Procedimiento para obtener el Top N de clientes más rentables

Crear `sp_top_clientes_rentables`.

Debe recibir la cantidad de clientes que se desea consultar.

### Parámetros

```sql
@Cantidad INT
```

Debe devolver:

- Código del cliente.
- Segmento.
- Ingresos.
- Costos.
- Rentabilidad.
- Posición en el ranking.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_top_clientes_rentables
    @Cantidad = 10;
```

### Reglas

- Validar que la cantidad sea mayor que cero.
- Ordenar por rentabilidad descendente.
- Definir cómo resolver los empates.
- No confundir `TOP` con una función de ventana.

**Conceptos:** `TOP`, `ROW_NUMBER`, ranking y validación de parámetros.

---

## Ejercicio 14. Procedimiento para comparar dos períodos

Crear `sp_comparar_rentabilidad_periodos`.

Debe recibir dos rangos de fechas:

- Período inicial.
- Período de comparación.

Debe calcular para cada período los ingresos, costos y rentabilidad.

Debe devolver:

- Rentabilidad del primer período.
- Rentabilidad del segundo período.
- Variación absoluta.
- Variación porcentual.

### Fórmulas

```text
Variación absoluta =
    Rentabilidad actual - Rentabilidad anterior

Variación porcentual =
    Variación absoluta / Rentabilidad anterior * 100
```

### Consideraciones

- Evitar la división entre cero.
- Validar las fechas.
- Dejar explícita la interpretación de una variación porcentual cuando la rentabilidad anterior sea cero o negativa.
- No comparar períodos de distinta duración sin advertir esa limitación.

**Conceptos:** agregación condicional, variables, CTE, validaciones y división segura.

---

## Ejercicio 15. Función para calcular el margen de rentabilidad

Crear `fn_calcular_margen`.

Debe recibir ingresos y costos y devolver el margen porcentual:

```text
Margen (%) = (Ingresos - Costos) / Ingresos * 100
```

### Ejemplo

```sql
SELECT dbo.fn_calcular_margen(10000, 7500) AS Margen;
```

Resultado esperado:

```text
Margen
------
25.00
```

### Reglas

- Evitar la división entre cero.
- Definir qué devolver cuando los ingresos sean cero.
- Utilizar un tipo decimal apropiado para evitar divisiones enteras.
- Documentar el significado de un margen negativo.

---

# 🔵 NIVEL 4 — INTERMEDIO / AVANZADO

Objetivo: incorporar validaciones robustas, manejo de errores y control de operaciones.

## Ejercicio 16. Procedimiento para registrar un ingreso

Crear `sp_registrar_ingreso`.

Debe insertar un registro en `ingresos`.

### Parámetros

- ID del cliente.
- ID del producto.
- ID del período.
- Importe.

### Reglas de validación

- El cliente debe existir.
- El producto debe existir.
- El período debe existir.
- El importe debe ser mayor o igual a cero, de acuerdo con la restricción de la tabla.
- Si alguna validación falla, no insertar el registro.
- Informar los errores de manera comprensible.

### Ejemplo de ejecución

```sql
EXEC dbo.sp_registrar_ingreso
    @ClienteId = 10,
    @ProductoId = 2,
    @PeriodoId = 12,
    @Importe = 1500.00;
```

### Reto adicional

Devolver el ID generado para el nuevo registro sin especificarlo manualmente.

**Conceptos:** `INSERT`, `IDENTITY`, `SCOPE_IDENTITY`, `THROW` y validaciones.

---

## Ejercicio 17. Procedimiento para registrar un costo

Crear `sp_registrar_costo`.

Debe insertar un registro en `costos`, recibiendo:

- ID del cliente.
- ID del producto.
- ID del período.
- Tipo de costo.
- Importe.

### Reglas

- Validar las referencias.
- Aceptar solamente los tipos permitidos por la tabla.
- Validar el importe.
- Manejar errores de forma controlada.
- Devolver el ID generado cuando el registro se complete correctamente.

### Pregunta de análisis

¿Es necesario repetir todas las validaciones de integridad referencial que ya realizan las claves foráneas? ¿Qué validaciones adicionales sí conviene realizar?

---

## Ejercicio 18. Procedimiento con transacción y manejo de errores

Crear `sp_registrar_movimiento_financiero`.

El procedimiento debe registrar un ingreso y un costo como parte de una misma operación lógica.

### Reglas

- Recibir los datos necesarios para ambos registros.
- Validar las referencias antes de insertar.
- Utilizar una transacción explícita.
- Si ambos registros se insertan correctamente, confirmar la transacción.
- Si alguno falla, revertir todos los cambios.
- Utilizar `TRY...CATCH`.
- No ocultar el error original.

### Estructura de referencia

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    -- Validaciones e inserciones.

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;
```

### Pregunta de negocio

¿Por qué sería incorrecto dejar registrado el ingreso si el registro del costo asociado falla?

**Importante:** para este ejercicio, asumir que ambos registros deben confirmarse o revertirse juntos. En un sistema real, primero se debe verificar que esta regla corresponda al proceso de negocio.

---

# 🔴 NIVEL 5 — AVANZADO

Objetivo: diseñar objetos reutilizables y evaluar su rendimiento.

## Ejercicio 19. Comparar una función escalar y una consulta directa

Implementar dos soluciones para obtener la rentabilidad de los clientes:

1. Una consulta que calcule directamente los ingresos, costos y rentabilidad.
2. Una consulta que utilice las funciones escalares de ingresos, costos y rentabilidad creadas anteriormente.

### Actividades

- Ejecutar ambas alternativas sobre el mismo conjunto de clientes.
- Verificar que los resultados sean equivalentes.
- Medir tiempo de CPU y tiempo transcurrido.
- Revisar las lecturas lógicas.
- Examinar el plan de ejecución real.
- Investigar si SQL Server inserta la lógica de la función escalar en la consulta o si genera operaciones adicionales.

### Herramientas

```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
```

### Pregunta de análisis

¿Por qué una función escalar invocada para muchos clientes puede resultar más costosa que una consulta basada en agregaciones?

**No se debe asumir que toda función escalar es lenta:** el comportamiento depende de la versión de SQL Server, la posibilidad de inlining y la forma de la consulta.

---

## Ejercicio 20. Optimizar la función de rentabilidad por cliente

Tomar como punto de partida la función del ejercicio 11.

Proponer una versión optimizada que:

- Evite cálculos redundantes.
- Agregue ingresos y costos por separado antes de combinarlos.
- Evite multiplicar registros al relacionar ambas tablas.
- Devuelva todos los clientes.
- Permita filtrar por segmento en la consulta consumidora.

### Actividades

1. Analizar el plan de ejecución.
2. Revisar los índices existentes.
3. Medir lecturas lógicas y CPU.
4. Comparar la función tabular con una consulta equivalente escrita directamente.
5. Documentar las diferencias observadas.

### Entregable

Una breve justificación técnica de la solución elegida, con métricas de antes y después.

---

# 🟣 NIVEL 6 — SENIOR

En este nivel los estudiantes reciben un problema de negocio y deben diseñar los objetos necesarios para resolverlo.

## Ejercicio 21. Detección de clientes cuya rentabilidad disminuye

La gerencia quiere identificar clientes que han empeorado su rentabilidad entre dos períodos.

Crear un procedimiento llamado `sp_detectar_caida_rentabilidad`.

### Parámetros

- Período inicial.
- Período final.
- Variación mínima porcentual opcional.

### Resultado esperado

- Código del cliente.
- Segmento.
- Rentabilidad inicial.
- Rentabilidad final.
- Variación absoluta.
- Variación porcentual.
- Clasificación de la caída.

### Requisitos

- No dividir entre cero.
- Diferenciar una rentabilidad negativa de una caída porcentual.
- Considerar clientes que no registraron ingresos o costos en alguno de los períodos.
- Explicar qué ocurre cuando la rentabilidad pasa de positiva a negativa.
- Evitar recorrer los clientes uno por uno mediante cursores si puede resolverse de forma set-based.

---

## Ejercicio 22. Reporte mensual de rentabilidad

Crear una función tabular o un procedimiento que permita obtener un reporte mensual entre dos fechas.

El reporte debe incluir:

- Año y mes.
- Ingresos.
- Costos.
- Rentabilidad.
- Rentabilidad del mes anterior.
- Variación mensual.
- Variación porcentual.

### Requisitos

- Los meses sin movimientos deben aparecer con importes cero.
- La comparación debe respetar el orden cronológico.
- El resultado debe poder utilizarse como fuente de Power BI.
- La solución debe evitar que la ausencia de registros distorsione el análisis.

### Conceptos sugeridos

- Funciones tabulares.
- Procedimientos almacenados.
- Tabla de períodos.
- `LEFT JOIN`.
- `LAG`.
- Agregaciones.
- Tratamiento de valores nulos.

---

## Ejercicio 23. Procedimiento de cierre mensual

Diseñar `sp_cierre_rentabilidad_mensual`.

El procedimiento debe consolidar los ingresos y costos de un mes y presentar un resumen de rentabilidad.

### Requisitos

- Recibir año y mes.
- Validar los parámetros.
- Verificar que el período exista.
- Calcular ingresos, costos y rentabilidad.
- Informar la cantidad de clientes con rentabilidad positiva, negativa y cero.
- Permitir identificar si no existen movimientos en el período.
- Evitar modificar las tablas originales de ingresos y costos.

### Reto adicional

Proponer cómo registrar el resultado del cierre para mantener un historial de ejecuciones y evitar duplicar cierres del mismo período.

**Nota:** la tabla de auditoría o consolidación no existe en el modelo actual; si se implementa, debe diseñarse explícitamente.

---

## Ejercicio 24. Diseñar una API de datos mediante procedimientos

El equipo de desarrollo necesita consumir la información de rentabilidad desde una aplicación.

Diseñar los siguientes procedimientos:

- `sp_api_rentabilidad_cliente`: devuelve la rentabilidad de un cliente.
- `sp_api_rentabilidad_segmento`: devuelve la rentabilidad agregada por segmento.
- `sp_api_rentabilidad_periodo`: devuelve la evolución mensual.
- `sp_api_top_clientes`: devuelve los clientes más rentables.

### Requisitos

- Definir parámetros de entrada.
- Establecer un esquema de salida consistente.
- Validar parámetros.
- Documentar los posibles errores.
- Evitar devolver columnas innecesarias.
- Considerar permisos mínimos para la cuenta de aplicación.
- No construir SQL dinámico cuando una consulta parametrizada sea suficiente.

### Entregable

Un contrato técnico para cada procedimiento que documente entradas, salidas, reglas y errores.

---

# 🏆 NIVEL 7 — CHALLENGE FINAL

## Caso: automatización del análisis de rentabilidad bancaria

La gerencia solicita una solución reutilizable que permita identificar clientes con rentabilidad negativa, medir la evolución mensual y comparar segmentos.

Los estudiantes deben diseñar una pequeña capa de lógica de negocio utilizando funciones y procedimientos almacenados.

### Requerimientos

1. Crear una función para calcular la rentabilidad.
2. Crear una función para clasificar el resultado.
3. Crear una función tabular para consultar la rentabilidad por cliente.
4. Crear un procedimiento para obtener el Top N de clientes.
5. Crear un procedimiento para comparar períodos.
6. Crear un procedimiento para generar el reporte mensual.
7. Incorporar validaciones y manejo de errores.
8. Medir el rendimiento de al menos dos implementaciones.
9. Documentar los objetos y sus dependencias.
10. Presentar una recomendación basada en los resultados.

### Entregables

- Scripts de creación de los objetos.
- Scripts de pruebas.
- Casos de prueba positivos y negativos.
- Evidencia de resultados.
- Métricas de rendimiento.
- Documentación técnica.
- Conclusiones de negocio.

---

# 📊 Matriz de dificultad

| Nivel | Ejercicios | Competencias |
|---|---:|---|
| Principiante | 1–5 | Sintaxis, parámetros y consultas |
| Básico / Intermedio | 6–10 | Agregaciones y procedimientos parametrizados |
| Intermedio | 11–15 | Funciones tabulares y análisis de negocio |
| Intermedio / Avanzado | 16–18 | Validaciones, errores y transacciones |
| Avanzado | 19–20 | Rendimiento y optimización |
| Senior | 21–24 | Diseño de soluciones reutilizables |
| Challenge final | Integrador | Arquitectura, calidad y rendimiento |

---

# 📚 Conceptos que deben dominar

## Funciones

- `CREATE FUNCTION`
- Funciones escalares.
- Funciones tabulares en línea.
- Funciones tabulares de múltiples instrucciones.
- Parámetros y tipos de retorno.
- `CASE`.
- `NULL`, `ISNULL` y `COALESCE`.
- Uso de funciones en consultas.
- Limitaciones de las funciones definidas por el usuario.
- Rendimiento e inlining de funciones escalares.

## Procedimientos almacenados

- `CREATE PROCEDURE`
- Parámetros de entrada.
- Parámetros de salida.
- `EXEC`.
- `INSERT`, `UPDATE` y `DELETE`.
- Validación de parámetros.
- `TRY...CATCH`.
- `THROW`.
- `BEGIN TRANSACTION`, `COMMIT` y `ROLLBACK`.
- `SCOPE_IDENTITY`.
- Seguridad y permisos.
- Rendimiento y planes de ejecución.

---

# 🎓 Criterios de evaluación

Cada ejercicio puede evaluarse con los siguientes criterios:

| Criterio | Peso sugerido |
|---|---:|
| Corrección funcional | 30 % |
| Calidad y legibilidad del SQL | 20 % |
| Validaciones y manejo de errores | 15 % |
| Rendimiento y eficiencia | 20 % |
| Pruebas y documentación | 15 % |

Para los ejercicios de nivel principiante, puede priorizarse la corrección funcional. En los ejercicios avanzados y Senior, se debe exigir evidencia de pruebas, justificación técnica y mediciones de rendimiento.

---

# 💡 Filosofía del laboratorio

El objetivo no es crear funciones y procedimientos por crear objetos.

El objetivo es aprender a decidir **cuándo conviene encapsular lógica en una función, cuándo utilizar un procedimiento almacenado y cómo garantizar que la solución sea correcta, mantenible y eficiente**.

Un buen profesional de datos debe poder responder tres preguntas:

1. ¿La solución funciona correctamente?
2. ¿Se puede reutilizar y mantener con facilidad?
3. ¿Cómo demuestra que su rendimiento y comportamiento son adecuados?

**La sintaxis es el comienzo; el diseño, la validación y la optimización son las competencias que buscamos desarrollar.**
