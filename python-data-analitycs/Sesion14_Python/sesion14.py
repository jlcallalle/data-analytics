# =====================================
# Importación de librerías
# =====================================

import pandas as pd


# =====================================
# 1. Configuración de la ruta
# =====================================

# Ruta local del archivo CSV.
# El archivo debe encontrarse dentro de la carpeta "dataset".
RUTA_DATASET = (
    "dataset/Datos_abiertos_matriculas_2024_2_2025_1_0.csv"
)


# =====================================
# 2. Importación y lectura del dataset
# =====================================

# Se carga el archivo CSV con la información de las matrículas.
#
# Cada fila representa la matrícula de un estudiante
# en un periodo académico determinado.
dataset_alumnos_uni = pd.read_csv(
    RUTA_DATASET
)


# =====================================
# 3. Exploración inicial del dataset
# =====================================

# Mostrar las primeras cinco filas para revisar
# la estructura general de los datos.
print("=" * 70)
print("Primeras 5 filas del dataset")
print("=" * 70)
print(dataset_alumnos_uni.head())


# Mostrar la cantidad de filas y columnas.
print("\n" + "=" * 70)
print("Dimensiones del dataset")
print("=" * 70)

cantidad_filas, cantidad_columnas = dataset_alumnos_uni.shape

print(f"Cantidad de filas: {cantidad_filas}")
print(f"Cantidad de columnas: {cantidad_columnas}")


# Mostrar información general del dataset:
# nombres de columnas, valores no nulos y tipos de datos.
print("\n" + "=" * 70)
print("Información general del dataset")
print("=" * 70)
dataset_alumnos_uni.info()


# Mostrar los nombres de las columnas disponibles.
print("\n" + "=" * 70)
print("Columnas disponibles")
print("=" * 70)

for numero, columna in enumerate(
    dataset_alumnos_uni.columns,
    start=1
):
    print(f"{numero}. {columna}")


# =====================================
# 4. Conteo de matrículas por estudiante
# =====================================

# Se agrupan los registros por IDHASH.
#
# IDHASH es el identificador anónimo de cada estudiante.
#
# Para cada estudiante se cuenta cuántos registros
# de matrícula aparecen en el dataset.
#
# El resultado se almacena en la columna NRO_MATRICULAS.
df_tmp = (
    dataset_alumnos_uni
    .groupby(
        by="IDHASH", # Agrupación por estudiante
        as_index=False # Evita que IDHASH se convierta en índice del DataFrame resultante
    )
    .agg(
        NRO_MATRICULAS=("IDHASH", "count") # Conteo de registros de matrícula por estudiante
    )
)


# Mostrar una muestra del conteo de matrículas.
print("\n" + "=" * 70)
print("Cantidad de matrículas por estudiante 123")
print("=" * 70)
print(df_tmp.head())


# =====================================
# 5. Unión del conteo de matrículas
#    con el dataset original
# =====================================

# Se agrega al dataset original la columna NRO_MATRICULAS.
#
# Esta columna permitirá diferenciar:
#
# - Estudiantes con una matrícula:
#   podrían ser posibles desertores.
#
# - Estudiantes con dos matrículas:
#   continuaron matriculados entre los periodos analizados.
#
# La unión se realiza mediante IDHASH.
#
# Se utiliza how="left" para conservar todos los registros
# que existen en el dataset original.
dataset_alumnos_uni_mod = dataset_alumnos_uni.merge(
    df_tmp,
    on="IDHASH",
    how="left"
)


# =====================================
# 6. Identificación de estudiantes
#    desertores
# =====================================

# Se consideran desertores a los estudiantes que cumplen
# las siguientes condiciones:
#
# 1. Tienen solamente una matrícula en el dataset.
#
# 2. No están matriculados en el periodo 2025-1.
#
# 3. No pertenecen al ciclo relativo 10 en 2024-2,
#    porque podrían haber culminado regularmente su carrera.
#
# 4. No pertenecen al ciclo relativo 11 en 2024-2,
#    porque también podrían encontrarse en una etapa final
#    o adicional de sus estudios.
#
# El símbolo ~ representa una negación.
#
# Por ejemplo:
#
# ~(
#     (ANIO == 2025)
#     &
#     (PERIODO == 1)
# )
#
# significa excluir los registros del periodo 2025-1.
#loc es un método de pandas que permite filtrar filas y columnas de un DataFrame según condiciones específicas.
dataset_alumnos_desertaron = dataset_alumnos_uni_mod.loc[ 
    (
        dataset_alumnos_uni_mod["NRO_MATRICULAS"] == 1
    )
    &
    ~(
        (dataset_alumnos_uni_mod["ANIO"] == 2025)
        &
        (dataset_alumnos_uni_mod["PERIODO"] == 1)
    )
    &
    ~(
        (dataset_alumnos_uni_mod["CICLO_RELATIVO"] == 10)
        &
        (dataset_alumnos_uni_mod["ANIO"] == 2024)
        &
        (dataset_alumnos_uni_mod["PERIODO"] == 2)
    )
    &
    ~(
        (dataset_alumnos_uni_mod["CICLO_RELATIVO"] == 11)
        &
        (dataset_alumnos_uni_mod["ANIO"] == 2024)
        &
        (dataset_alumnos_uni_mod["PERIODO"] == 2)
    )
].copy()


# =====================================
# 7. Creación de la variable objetivo
#    para estudiantes desertores
# =====================================

# Se asigna el valor 1 a los estudiantes que fueron
# identificados como desertores.
#
# DESERCION = 1 significa que el estudiante desertó.
dataset_alumnos_desertaron["DESERCION"] = 1


# =====================================
# 8. Identificación de estudiantes
#    que no desertaron
# =====================================

# Se consideran no desertores a los estudiantes que:
#
# 1. Tienen dos registros de matrícula en el dataset.
#
# 2. Estuvieron matriculados durante el periodo 2024-2.
#
# Tener dos matrículas indica que el estudiante aparece
# en ambos periodos académicos analizados y, por lo tanto,
# continuó estudiando.
dataset_alumnos_no_desertaron = dataset_alumnos_uni_mod.loc[
    (
        dataset_alumnos_uni_mod["NRO_MATRICULAS"] == 2
    )
    &
    (
        dataset_alumnos_uni_mod["ANIO"] == 2024
    )
    &
    (
        dataset_alumnos_uni_mod["PERIODO"] == 2
    )
].copy()


# =====================================
# 9. Creación de la variable objetivo
#    para estudiantes no desertores
# =====================================

# Se asigna el valor 0 a los estudiantes que continuaron
# matriculados.
#
# DESERCION = 0 significa que el estudiante no desertó.
dataset_alumnos_no_desertaron["DESERCION"] = 0


# =====================================
# 10. Consolidación de los resultados
# =====================================

# Se unen los dos grupos:
#
# - Estudiantes desertores.
# - Estudiantes no desertores.
#
# ignore_index=True crea un nuevo índice consecutivo.
data_consolidado = pd.concat(
    [
        dataset_alumnos_desertaron,
        dataset_alumnos_no_desertaron
    ],
    ignore_index=True
)


# =====================================
# 11. Eliminación de columnas
# =====================================

# Las columnas ANIO y PERIODO se utilizaron para determinar
# si el estudiante continuó o no matriculado.
#
# Después de crear la variable DESERCION, estas columnas
# pueden eliminarse del dataset consolidado.
data_consolidado = data_consolidado.drop(
    columns=[
        "ANIO",
        "PERIODO"
    ]
)


# =====================================
# 12. Eliminación de registros duplicados
# =====================================

# Se eliminan registros completamente duplicados
# para evitar que un mismo estudiante aparezca repetido
# con exactamente la misma información.
data_consolidado = data_consolidado.drop_duplicates()


# =====================================
# 13. Conversión del año de nacimiento
# =====================================

# Se convierte ANIO_NACIMIENTO a formato numérico.
#
# errors="coerce" transforma los valores no válidos en NaN.
# Esto evita errores si existen textos, espacios o valores
# incorrectos en la columna.
data_consolidado["ANIO_NACIMIENTO"] = pd.to_numeric(
    data_consolidado["ANIO_NACIMIENTO"],
    errors="coerce"
)


# =====================================
# 14. Creación de la variable EDAD
# =====================================

# Se calcula una edad aproximada tomando como referencia
# el año 2025.
#
# EDAD = 2025 - ANIO_NACIMIENTO
data_consolidado["EDAD"] = (
    2025 - data_consolidado["ANIO_NACIMIENTO"]
)


# =====================================
# 15. Validación de edades
# =====================================

# Las edades menores que 0 o mayores que 100
# se consideran valores poco razonables.
#
# Estos valores se reemplazan por NA.
data_consolidado.loc[
    (
        data_consolidado["EDAD"] < 0
    )
    |
    (
        data_consolidado["EDAD"] > 100
    ),
    "EDAD"
] = pd.NA


# =====================================
# 16. Exploración del dataset consolidado
# =====================================

print("\n" + "=" * 70)
print("Primeras 5 filas del dataset consolidado")
print("=" * 70)
print(data_consolidado.head())


# Mostrar las dimensiones finales.
print("\n" + "=" * 70)
print("Dimensiones del dataset consolidado")
print("=" * 70)

filas_consolidadas, columnas_consolidadas = (
    data_consolidado.shape
)

print(f"Cantidad de filas: {filas_consolidadas}")
print(f"Cantidad de columnas: {columnas_consolidadas}")


# Mostrar la información general del dataset final.
print("\n" + "=" * 70)
print("Información del dataset consolidado")
print("=" * 70)
data_consolidado.info()


# =====================================
# 17. Distribución de la variable objetivo
# =====================================

# Se cuenta cuántos estudiantes fueron clasificados
# como desertores y cuántos como no desertores.
#
# DESERCION = 0: no desertó.
# DESERCION = 1: desertó.
print("\n" + "=" * 70)
print("Distribución de la variable DESERCION")
print("=" * 70)

distribucion_desercion = (
    data_consolidado["DESERCION"]
    .value_counts()
    .sort_index()
)

print(distribucion_desercion)


# =====================================
# 18. Porcentaje de deserción
# =====================================

# Se calcula el porcentaje de estudiantes perteneciente
# a cada categoría de la variable objetivo.
print("\n" + "=" * 70)
print("Porcentaje de la variable DESERCION")
print("=" * 70)

porcentaje_desercion = (
    data_consolidado["DESERCION"]
    .value_counts(normalize=True)
    .sort_index()
    .mul(100)
    .round(2)
)

print(porcentaje_desercion)


# =====================================
# 19. Validación de estudiantes
#     desertores
# =====================================

print("\n" + "=" * 70)
print("Ejemplo de estudiantes desertores")
print("=" * 70)

columnas_validacion = [
    "IDHASH",
    "CICLO_RELATIVO",
    "NRO_MATRICULAS",
    "ANIO_NACIMIENTO",
    "EDAD",
    "DESERCION"
]

print(
    dataset_alumnos_desertaron[
        [
            "IDHASH",
            "ANIO",
            "PERIODO",
            "CICLO_RELATIVO",
            "NRO_MATRICULAS",
            "DESERCION"
        ]
    ].head()
)


# =====================================
# 20. Validación de estudiantes
#     no desertores
# =====================================

print("\n" + "=" * 70)
print("Ejemplo de estudiantes no desertores")
print("=" * 70)

print(
    dataset_alumnos_no_desertaron[
        [
            "IDHASH",
            "ANIO",
            "PERIODO",
            "CICLO_RELATIVO",
            "NRO_MATRICULAS",
            "DESERCION"
        ]
    ].head()
)


# =====================================
# 21. Valores nulos del dataset final
# =====================================

# Se muestra la cantidad de valores nulos por columna.
print("\n" + "=" * 70)
print("Valores nulos por columna")
print("=" * 70)

valores_nulos = (
    data_consolidado
    .isnull()
    .sum()
    .sort_values(ascending=False)
)

print(valores_nulos)


# =====================================
# 22. Guardado del dataset consolidado
# =====================================

# Se guarda el resultado en un nuevo archivo CSV.
#
# index=False evita guardar el índice de pandas
# como una columna adicional.
RUTA_SALIDA = "dataset/dataset_alumnos_consolidado.csv"

data_consolidado.to_csv(
    RUTA_SALIDA,
    index=False,
    encoding="utf-8-sig"
)


print("\n" + "=" * 70)
print("Proceso finalizado correctamente")
print("=" * 70)
print(f"Archivo generado: {RUTA_SALIDA}")