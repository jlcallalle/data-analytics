# 🏦 Laboratorio SQL Server — Rentabilidad por Cliente

## 📚 Descripción

Este laboratorio tiene como objetivo desarrollar progresivamente las habilidades de consulta y análisis de datos utilizando **SQL Server**, partiendo desde conceptos fundamentales hasta problemas de análisis propios de un perfil **Senior**.

Los ejercicios utilizan una base de datos bancaria orientada al análisis de **rentabilidad por cliente**.

La métrica principal del laboratorio será:

```text
RENTABILIDAD = INGRESOS - COSTOS
```

El objetivo no es solamente aprender a escribir consultas SQL, sino aprender a utilizar SQL para **resolver preguntas reales de negocio**.

---

# 🗄️ Modelo de datos

La base de datos está compuesta por las siguientes tablas:

```text
segmentos
canales
categoria_productos
productos
clientes
personas_naturales
personas_juridicas
periodos
contrataciones
operaciones
ingresos
costos
```

## Principales relaciones

```text
segmentos
    │
    └── clientes
          │
          ├── personas_naturales
          ├── personas_juridicas
          │
          └── contrataciones
                  │
                  └── productos
                        │
                        └── categoria_productos

clientes ───────── operaciones ───── canales

clientes ───────── ingresos ──────── productos
                    │
                    └── periodos

clientes ───────── costos ────────── productos
                    │
                    └── periodos
```

---

# 🎯 Objetivos de aprendizaje

Al finalizar el laboratorio, el estudiante será capaz de:

- Consultar y filtrar información utilizando SQL.
- Utilizar funciones de agregación.
- Relacionar múltiples tablas mediante `JOIN`.
- Construir indicadores de negocio.
- Utilizar `CASE`.
- Utilizar subconsultas y CTE.
- Aplicar funciones de ventana.
- Realizar análisis temporales.
- Construir rankings.
- Analizar rentabilidad por cliente, segmento y producto.
- Identificar patrones y problemas de negocio.
- Construir consultas orientadas a la toma de decisiones.

---

# 🟢 NIVEL 1 — PRINCIPIANTE

## Ejercicio 1 — Conociendo los clientes

Mostrar:

- ID
- Código
- Tipo de cliente
- Estado
- Segmento

Ordenar los resultados por código de cliente.

### Conceptos

```sql
SELECT
FROM
ORDER BY
```

---

## Ejercicio 2 — Clientes activos

Mostrar todos los clientes cuyo estado sea:

```text
activo
```

### Conceptos

```sql
WHERE
```

---

## Ejercicio 3 — Productos activos

Mostrar:

- Código
- Nombre
- Tipo de producto
- Moneda
- Estado

Únicamente para productos activos.

---

## Ejercicio 4 — Operaciones mayores a S/ 5,000

Mostrar las operaciones cuyo importe sea mayor a:

```text
S/ 5,000
```

Ordenarlas de mayor a menor importe.

### Conceptos

```sql
WHERE
ORDER BY
```

---

## Ejercicio 5 — ¿Cuántos clientes tenemos?

Obtener:

- Cantidad total de clientes.
- Cantidad de clientes activos.
- Cantidad de clientes bloqueados.

### Conceptos

```sql
COUNT()
```

---

## Ejercicio 6 — Importe de las operaciones

Calcular:

- Operación mínima.
- Operación máxima.
- Importe promedio.
- Importe total.

### Conceptos

```sql
MIN()
MAX()
AVG()
SUM()
```

---

# 🟡 NIVEL 2 — BÁSICO / INTERMEDIO

En este nivel comenzaremos a relacionar diferentes entidades del modelo.

## Ejercicio 7 — Clientes y sus segmentos

Mostrar:

```text
Cliente
Código
Segmento
Estado
```

Relacionar:

```text
clientes → segmentos
```

### Conceptos

```sql
INNER JOIN
```

---

## Ejercicio 8 — Productos y categorías

Mostrar:

```text
Producto
Código
Categoría
Tipo de producto
Moneda
Estado
```

Relacionar:

```text
productos → categoria_productos
```

---

## Ejercicio 9 — Clientes por segmento

Determinar cuántos clientes pertenecen a cada segmento.

Resultado esperado:

```text
Segmento       CantidadClientes
-------------- ---------------
Básico         ...
Masivo         ...
Preferente     ...
Premium        ...
...
```

Ordenar de mayor a menor cantidad de clientes.

### Conceptos

```sql
GROUP BY
COUNT()
ORDER BY
```

---

## Ejercicio 10 — Operaciones por canal

Determinar cuántas operaciones se realizan por cada canal.

Mostrar:

```text
Canal
CantidadOperaciones
ImporteTotal
```

---

## Ejercicio 11 — Productos más contratados

Determinar qué productos tienen mayor cantidad de contrataciones.

Mostrar:

```text
Producto
CantidadContrataciones
```

Ordenar de mayor a menor.

---

## Ejercicio 12 — Clientes sin contrataciones

Encontrar clientes que **nunca hayan contratado un producto**.

### Pista

Analizar cuándo resulta conveniente utilizar:

```sql
LEFT JOIN
```

en lugar de:

```sql
INNER JOIN
```

---

# 🟠 NIVEL 3 — INTERMEDIO

En este nivel empezamos a responder preguntas relacionadas directamente con el negocio.

## Ejercicio 13 — Ingresos por segmento

Calcular cuánto ingreso genera cada segmento.

Resultado esperado:

```text
Segmento       Ingresos
-------------- ----------
Básico         S/ ...
Masivo         S/ ...
Premium        S/ ...
...
```

---

## Ejercicio 14 — Costos por segmento

Calcular cuánto costo genera cada segmento.

Mostrar:

```text
Segmento
Costos
```

---

## Ejercicio 15 — Rentabilidad por segmento ⭐

Calcular:

```text
RENTABILIDAD = INGRESOS - COSTOS
```

Mostrar:

```text
Segmento
Ingresos
Costos
Rentabilidad
```

---

## Ejercicio 16 — Rentabilidad por cliente ⭐

Determinar cuánto gana o pierde el banco con cada cliente.

Mostrar:

```text
Cliente
Ingresos
Costos
Rentabilidad
```

Ordenar de mayor a menor rentabilidad.

---

## Ejercicio 17 — Top 10 clientes más rentables

Mostrar los 10 clientes con mayor rentabilidad.

### Concepto sugerido

```sql
TOP
```

---

## Ejercicio 18 — Clientes que generan pérdidas

Encontrar clientes cuya rentabilidad sea menor que cero.

```text
Rentabilidad < 0
```

Mostrar:

```text
Cliente
Ingresos
Costos
Rentabilidad
```

---

# 🔵 NIVEL 4 — INTERMEDIO / AVANZADO

Ahora introducimos herramientas más potentes de SQL Server.

## Ejercicio 19 — Clasificación de clientes por rentabilidad

Crear una clasificación utilizando `CASE`:

| Condición | Clasificación |
|---|---|
| Rentabilidad >= 10,000 | Alta |
| Rentabilidad >= 5,000 | Media |
| Rentabilidad >= 0 | Baja |
| Rentabilidad < 0 | Pérdida |

### Concepto

```sql
CASE
```

---

## Ejercicio 20 — Participación de cada cliente

Calcular qué porcentaje de los ingresos totales representa cada cliente.

Resultado esperado:

```text
Cliente    Ingresos    Participación
---------  ----------  ------------
C00001     50,000      2.35%
C00002     30,000      1.41%
...
```

---

## Ejercicio 21 — Ranking de clientes ⭐

Rankear los clientes según su rentabilidad.

Resultado esperado:

```text
Cliente    Rentabilidad    Ranking
---------  -------------   -------
C00123     45,000          1
C00456     39,000          2
...
```

### Investigar

¿Cuál es la diferencia entre:

```sql
RANK()
DENSE_RANK()
ROW_NUMBER()
```

---

## Ejercicio 22 — Ranking dentro de cada segmento

Determinar quiénes son los clientes más rentables **dentro de cada segmento**.

### Conceptos

```sql
PARTITION BY
RANK()
ROW_NUMBER()
```

---

## Ejercicio 23 — Rentabilidad mensual

Calcular por cada mes:

```text
Año
Mes
Ingresos
Costos
Rentabilidad
```

---

## Ejercicio 24 — Evolución mensual de la rentabilidad

Determinar cuánto aumentó o disminuyó la rentabilidad respecto al mes anterior.

Resultado esperado:

```text
Mes       Rentabilidad    MesAnterior    Variación
--------  -------------   ------------   ---------
Enero     100,000         NULL           NULL
Febrero   120,000         100,000        20,000
Marzo     90,000          120,000        -30,000
```

### Concepto sugerido

```sql
LAG()
```

---

# 🔴 NIVEL 5 — AVANZADO

Los ejercicios empiezan a combinar varias técnicas SQL para responder preguntas más complejas.

## Ejercicio 25 — Producto más rentable

Determinar qué productos generan mayor rentabilidad para el banco.

Mostrar:

```text
Producto
Ingresos
Costos
Rentabilidad
Margen %
```

Calcular:

```text
Margen % = Rentabilidad / Ingresos × 100
```

---

## Ejercicio 26 — Rentabilidad por tipo de cliente

Comparar:

```text
Persona Natural
Persona Jurídica
```

Analizar:

- Cantidad de clientes.
- Ingresos.
- Costos.
- Rentabilidad.
- Rentabilidad promedio por cliente.

---

## Ejercicio 27 — Clientes con alta rentabilidad pero bajo volumen

Buscar clientes que cumplan simultáneamente:

```text
Rentabilidad > promedio general
```

y:

```text
Número de operaciones < promedio general
```

El ejercicio debe resolverse utilizando una combinación de:

- Agregaciones.
- Subconsultas.
- CTE.

---

## Ejercicio 28 — Producto principal de cada cliente

Determinar cuál es el producto que representa la mayor cantidad de operaciones para cada cliente.

### Concepto sugerido

```sql
ROW_NUMBER()
OVER(
    PARTITION BY ...
    ORDER BY ...
)
```

---

## Ejercicio 29 — Segmento más rentable por mes

Para cada mes determinar cuál fue el segmento que generó mayor rentabilidad.

Resultado esperado:

```text
Año  Mes  Segmento      Rentabilidad
---  ---  ------------  ------------
2025 01   Premium       ...
2025 02   Corporativo   ...
2025 03   Premium       ...
```

### Conceptos sugeridos

```sql
CTE
Window Functions
PARTITION BY
ROW_NUMBER()
```

---

# 🟣 NIVEL 6 — SENIOR

En este nivel cambia la naturaleza de los ejercicios.

Ya no se busca simplemente:

> "Escribe una consulta SQL."

Ahora se plantea:

> **"Resuelve un problema de negocio utilizando SQL."**

---

# Ejercicio 30 — Detectar clientes potencialmente problemáticos ⭐⭐⭐

El banco quiere identificar clientes que:

- Generan altos ingresos.
- También generan altos costos.
- Presentan una disminución de rentabilidad.

Definir criterios apropiados y construir una consulta que identifique estos clientes.

El resultado debería contener:

```text
Cliente
Segmento
Ingresos actuales
Costos actuales
Rentabilidad actual
Rentabilidad periodo anterior
Variación
Nivel de riesgo
```

---

# Ejercicio 31 — Rentabilidad acumulada

Calcular la rentabilidad acumulada de cada cliente a través del tiempo.

Ejemplo:

```text
Cliente  Mes       Rentabilidad  Acumulada
-------  --------  ------------  ----------
C001     Ene       1,000         1,000
C001     Feb       1,500         2,500
C001     Mar       -500          2,000
```

### Conceptos sugeridos

```sql
SUM() OVER()
ORDER BY
ROWS BETWEEN
```

---

# Ejercicio 32 — Cambio de comportamiento

Identificar clientes cuya rentabilidad:

```text
2025 → positiva
2026 → negativa
```

El objetivo es detectar cambios significativos en el comportamiento de los clientes.

### Conceptos sugeridos

- Agregaciones.
- CTE.
- Comparación entre períodos.
- `CASE`.

---

# Ejercicio 33 — Concentración de la rentabilidad

Responder:

> **¿Qué porcentaje de la rentabilidad total del banco proviene del 10% de clientes más rentables?**

El análisis debe considerar:

- Ranking de clientes.
- Segmentación del conjunto.
- Rentabilidad acumulada.
- Porcentaje sobre el total.

### Conceptos sugeridos

```sql
ROW_NUMBER()
NTILE()
SUM() OVER()
CTE
```

---

# 🏆 NIVEL 7 — CHALLENGE FINAL

# 🚨 Caso: "El banco está perdiendo rentabilidad"

La gerencia informa:

> **"La rentabilidad de nuestros clientes ha disminuido durante 2026. Necesitamos saber qué está ocurriendo."**

Los estudiantes **NO recibirán la consulta SQL**.

Deberán investigar el problema utilizando la base de datos.

---

## Pregunta 1 — ¿La rentabilidad realmente disminuyó?

Comparar los períodos correspondientes y determinar si existe una disminución.

---

## Pregunta 2 — ¿Qué segmentos explican la disminución?

Identificar los segmentos que presentan cambios relevantes en rentabilidad.

---

## Pregunta 3 — ¿Qué productos explican la disminución?

Determinar qué productos están asociados con la variación de rentabilidad.

---

## Pregunta 4 — ¿Qué clientes explican la disminución?

Identificar los clientes que contribuyen significativamente a la caída.

---

## Pregunta 5 — ¿La caída proviene de menores ingresos o mayores costos?

Separar el problema en:

```text
Ingresos
Costos
```

y determinar cuál de los dos componentes explica principalmente la variación.

---

## Pregunta 6 — ¿En qué meses ocurrió?

Analizar la evolución mensual para identificar cuándo comenzó la disminución y en qué períodos fue más significativa.

---

## Pregunta 7 — ¿Qué canal está asociado a los clientes afectados?

Analizar las operaciones de los clientes afectados y determinar qué canales concentran su actividad.

---

## Pregunta 8 — ¿Existe concentración?

Determinar si una cantidad relativamente pequeña de clientes explica una proporción importante de la disminución.

---

# 🧠 Entregable del Challenge

Los estudiantes no deben entregar solamente una consulta SQL.

La solución debe seguir este flujo:

```text
1. Pregunta de negocio
        ↓
2. Hipótesis
        ↓
3. Datos necesarios
        ↓
4. SQL
        ↓
5. Resultado
        ↓
6. Interpretación
        ↓
7. Conclusión
        ↓
8. Recomendación
```

---

# 🎓 Competencias desarrolladas

Al completar el laboratorio, el estudiante habrá trabajado progresivamente:

```text
SELECT
   ↓
WHERE
   ↓
ORDER BY
   ↓
GROUP BY
   ↓
JOIN
   ↓
CASE
   ↓
Subconsultas
   ↓
CTE
   ↓
Window Functions
   ↓
Análisis temporal
   ↓
Rankings
   ↓
Análisis de comportamiento
   ↓
Análisis de rentabilidad
   ↓
Resolución de problemas de negocio
```

---

# 📊 Mapa de dificultad

| Nivel | Ejercicios | Principales habilidades |
|---|---:|---|
| 🟢 Principiante | 1–6 | `SELECT`, `WHERE`, funciones básicas |
| 🟡 Básico | 7–12 | `JOIN`, `GROUP BY` |
| 🟠 Intermedio | 13–18 | Agregaciones + métricas de negocio |
| 🔵 Intermedio / Avanzado | 19–24 | `CASE`, CTE, Window Functions |
| 🔴 Avanzado | 25–29 | Análisis multidimensional |
| 🟣 Senior | 30–33 | Análisis temporal y comportamiento |
| 🏆 Challenge | Final | Resolución integral de problemas de negocio |

---

# 💡 Filosofía del laboratorio

> **El objetivo no es aprender SQL de memoria.**

El objetivo es aprender a transformar:

```text
PROBLEMA DE NEGOCIO
        ↓
PREGUNTA
        ↓
DATOS NECESARIOS
        ↓
LÓGICA DE ANÁLISIS
        ↓
CONSULTA SQL
        ↓
RESULTADO
        ↓
INSIGHT
```

Un profesional de datos no se limita a preguntar:

> "¿Cómo escribo esta consulta?"

También debe preguntarse:

> **"¿Qué problema estoy tratando de resolver y cómo puedo demostrar que mi resultado es correcto?"**

---

## 🏦 Caso de negocio

**Modelo de Rentabilidad por Cliente**

```text
RENTABILIDAD = INGRESOS - COSTOS
```

Este modelo permitirá practicar SQL utilizando un escenario cercano a un entorno real de banca y análisis financiero.