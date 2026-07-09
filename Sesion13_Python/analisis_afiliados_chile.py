# =====================================
# Importación de librerías
# =====================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime


# =====================================
# 1. Importación y lectura del dataset de afiliados
# =====================================

# Ruta del archivo de características de afiliados
RUTA_DATASET = "dataset/caracteristicas_afiliados.csv"

# Se carga el dataset de afiliados.
# El separador es punto y coma (;)
dataset_afiliados_chile = pd.read_csv(
    RUTA_DATASET,
    sep=";"
)


# =====================================
# 2. Exploración inicial del dataset de afiliados
# =====================================

print("=" * 60)
print("Primeras 5 filas del dataset de afiliados")
print("=" * 60)
print(dataset_afiliados_chile.head())

print("\n" + "=" * 60)
print("Dimensiones del dataset de afiliados")
print("=" * 60)
print(dataset_afiliados_chile.shape)

print("\n" + "=" * 60)
print("Información del dataset de afiliados")
print("=" * 60)
print(dataset_afiliados_chile.info())


# =====================================
# 3. Importación del dataset de remuneraciones
# =====================================

# Ruta del archivo de remuneraciones
RUTA_REMUNERACIONES = "dataset/remuneraciones_muestra_afiliados_202312.csv"

# Se carga el dataset de remuneraciones.
# El separador es coma (,)
dataset_remuneraciones = pd.read_csv(
    RUTA_REMUNERACIONES,
    sep=","
)


# =====================================
# 4. Exploración inicial del dataset de remuneraciones
# =====================================

print("\n" + "=" * 60)
print("Primeras 5 filas del dataset de remuneraciones")
print("=" * 60)
print(dataset_remuneraciones.head())

print("\n" + "=" * 60)
print("Dimensiones del dataset de remuneraciones")
print("=" * 60)
print(dataset_remuneraciones.shape)

print("\n" + "=" * 60)
print("Información del dataset de remuneraciones")
print("=" * 60)
print(dataset_remuneraciones.info())


# =====================================
# 5. Consolidación de datasets
# =====================================

# Se unen ambos datasets usando la columna común "correl".
# how="inner" conserva solo los registros que existen en ambos datasets.
dataset_afiliados_consolidado_chile = dataset_afiliados_chile.merge(
    dataset_remuneraciones,
    on="correl",
    how="inner"
)

print("\n" + "=" * 60)
print("Primeras filas del dataset consolidado")
print("=" * 60)
print(dataset_afiliados_consolidado_chile.head())

print("\n" + "=" * 60)
print("Dimensiones del dataset consolidado")
print("=" * 60)
print(dataset_afiliados_consolidado_chile.shape)


# =====================================
# 6. Análisis de variable saldoA_pesos_cero_flag
# =====================================

# Se cuenta la cantidad de registros por cada valor de la variable.
# Esto ayuda a saber cuántos afiliados tienen saldo A igual a cero.
print("\n" + "=" * 60)
print("Conteo de saldoA_pesos_cero_flag")
print("=" * 60)
print(dataset_afiliados_consolidado_chile["saldoA_pesos_cero_flag"].value_counts())


# =====================================
# 7. Filtrado de registros con saldoA_pesos_cero_flag = 1
# =====================================

# Se filtran los afiliados cuyo saldoA_pesos_cero_flag es igual a 1.
# Esto permite revisar casos específicos.
print("\n" + "=" * 60)
print("Afiliados con saldoA_pesos_cero_flag = 1")
print("=" * 60)

print(
    dataset_afiliados_consolidado_chile.loc[
        dataset_afiliados_consolidado_chile["saldoA_pesos_cero_flag"] == 1
    ]
)


# =====================================
# 8. Limpieza de datos - Análisis de valores nulos
# =====================================

# Se calcula la cantidad de valores nulos por columna.
null_counts = dataset_afiliados_consolidado_chile.isnull().sum()

# Se calcula el porcentaje de valores nulos por columna.
null_percentages = (
    dataset_afiliados_consolidado_chile.isnull().sum()
    / len(dataset_afiliados_consolidado_chile)
) * 100

# Se consolida la información en un DataFrame.
null_info = pd.DataFrame({
    "Null Count": null_counts,
    "Null Percentage": null_percentages
})

# Se ordenan las columnas de mayor a menor porcentaje de nulos.
null_info_sorted = null_info.sort_values(
    by="Null Percentage",
    ascending=False
)

print("\n" + "=" * 60)
print("Análisis de valores nulos")
print("=" * 60)
print(null_info_sorted)


# =====================================
# 9. Ingeniería de características
# =====================================

# Se obtiene el año actual.
current_year = datetime.now().year

# Se crea la variable edad.
# En este caso se asume que fecha_nac contiene el año de nacimiento.
dataset_afiliados_consolidado_chile["edad"] = (
    current_year
    - dataset_afiliados_consolidado_chile["fecha_nac"]
)

print("\n" + "=" * 60)
print("Nueva variable: edad")
print("=" * 60)
print(
    dataset_afiliados_consolidado_chile[
        ["fecha_nac", "edad"]
    ].head()
)

# Tipo de cambio aproximado de pesos chilenos a soles.
exchange_rate_clp_to_pen = 0.004

# Se crea la variable remuneración en soles.
dataset_afiliados_consolidado_chile["rem_sol"] = (
    dataset_afiliados_consolidado_chile["rem_imp"]
    * exchange_rate_clp_to_pen
)

print("\n" + "=" * 60)
print("Nueva variable: rem_sol")
print("=" * 60)
print(
    dataset_afiliados_consolidado_chile[
        ["rem_imp", "rem_sol"]
    ].head()
)


# =====================================
# 10. EDA - Exploración de datos
# =====================================

print("\n" + "=" * 60)
print("Columnas del dataset consolidado")
print("=" * 60)
print(dataset_afiliados_consolidado_chile.columns)

print("\n" + "=" * 60)
print("Estadísticas descriptivas de variables numéricas")
print("=" * 60)

estadisticas = dataset_afiliados_consolidado_chile.filter([
    "num_mes_cot",
    "saldoA_pesos",
    "saldoB_pesos",
    "saldoC_pesos",
    "saldoD_pesos",
    "saldoE_pesos",
    "edad",
    "rem_sol"
]).describe()

print(estadisticas)


# =====================================
# 11. EDA - Análisis univariado
# Distribución de la edad
# =====================================

# El análisis univariado estudia una sola variable.
# En este caso se analiza la distribución de la edad.
plt.figure(figsize=(10, 6))

sns.histplot(
    data=dataset_afiliados_consolidado_chile,
    x="edad",
    kde=True,
    bins=30
)

plt.title("Distribución de la Edad de los Afiliados")
plt.xlabel("Edad")
plt.ylabel("Frecuencia")
plt.grid(axis="y", alpha=0.75)

plt.show()


# =====================================
# 12. EDA - Análisis bivariado
# Relación entre edad y remuneración en soles
# =====================================

# El análisis bivariado estudia la relación entre dos variables.
# En este caso se analiza si existe relación entre edad y remuneración.
plt.figure(figsize=(10, 6))

sns.scatterplot(
    data=dataset_afiliados_consolidado_chile,
    x="edad",
    y="rem_sol"
)

plt.title("Relación entre Edad y Remuneración en Soles")
plt.xlabel("Edad")
plt.ylabel("Remuneración en Soles")
plt.grid(True, alpha=0.75)

plt.show()


# =====================================
# 13. EDA - Correlación entre variables numéricas
# =====================================

# Se calcula la matriz de correlación.
# Permite identificar relaciones lineales entre variables numéricas.
variables_numericas = [
    "num_mes_cot",
    "saldoA_pesos",
    "saldoB_pesos",
    "saldoC_pesos",
    "saldoD_pesos",
    "saldoE_pesos",
    "edad",
    "rem_sol"
]

matriz_correlacion = dataset_afiliados_consolidado_chile[
    variables_numericas
].corr()

print("\n" + "=" * 60)
print("Matriz de correlación")
print("=" * 60)
print(matriz_correlacion)

plt.figure(figsize=(10, 6))

sns.heatmap(
    matriz_correlacion,
    annot=True,
    cmap="coolwarm",
    fmt=".2f"
)

plt.title("Matriz de Correlación")
plt.show()