# =====================================
# Importación y lectura del dataset
# =====================================

import pandas as pd

# Ruta del dataset
RUTA_DATASET = "dataset/caracteristicas_afiliados.csv"

# Cargar dataset
dataset_afiliados_chile = pd.read_csv(
    RUTA_DATASET,
    sep=";"
)

# =====================================
# Exploración inicial
# =====================================

print("=" * 60)
print("Primeras 5 filas")
print("=" * 60)
print(dataset_afiliados_chile.head())

print("\n" + "=" * 60)
print("Dimensiones del dataset") 
print("=" * 60)
print(dataset_afiliados_chile.shape)

print("\n" + "=" * 60)
print("Información del dataset")
print("=" * 60)
print(dataset_afiliados_chile.info())


# =====================================
# Importación del dataset de remuneraciones
# =====================================

import pandas as pd

# Ruta del dataset
RUTA_REMUNERACIONES = "dataset/remuneraciones_muestra_afiliados_202312.csv"

# Cargar dataset
dataset_remuneraciones = pd.read_csv(
    RUTA_REMUNERACIONES,
    sep=","
)

# =====================================
# Exploración inicial
# =====================================

print("=" * 60)
print("Primeras 5 filas")
print("=" * 60)
print(dataset_remuneraciones.head())

print("\n" + "=" * 60)
print("Dimensiones del dataset")
print("=" * 60)
print(dataset_remuneraciones.shape)

# =====================================
# Consolidación de datasets
# =====================================

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
# Conteo de la variable saldoA_pesos_cero_flag
# =====================================

print("\n" + "=" * 60)
print("Conteo de saldoA_pesos_cero_flag")
print("=" * 60)
print(dataset_afiliados_consolidado_chile["saldoA_pesos_cero_flag"].value_counts())


# =====================================
# Filtrar registros donde saldoA_pesos_cero_flag == 1
# =====================================

print("=" * 60)
print("Afiliados con saldoA_pesos_cero_flag = 1")
print("=" * 60)

print(
    dataset_afiliados_consolidado_chile.loc[
        dataset_afiliados_consolidado_chile["saldoA_pesos_cero_flag"] == 1
    ]
)





# =====================================
# Limpieza de datos - Análisis de nulos
# =====================================

import pandas as pd

# Cantidad de valores nulos por columna
null_counts = dataset_afiliados_consolidado_chile.isnull().sum()

# Porcentaje de valores nulos
null_percentages = (
    dataset_afiliados_consolidado_chile.isnull().sum()
    / len(dataset_afiliados_consolidado_chile)
) * 100

# Consolidar información
null_info = pd.DataFrame({
    "Null Count": null_counts,
    "Null Percentage": null_percentages
})

# Ordenar de mayor a menor porcentaje de nulos
null_info_sorted = null_info.sort_values(
    by="Null Percentage",
    ascending=False
)

print("=" * 60)
print("Análisis de valores nulos")
print("=" * 60)
print(null_info_sorted)





# =====================================
# Ingeniería de características (Feature Engineering)
# =====================================

from datetime import datetime

# Obtener el año actual
current_year = datetime.now().year

# Crear la variable edad
dataset_afiliados_consolidado_chile["edad"] = (
    current_year
    - dataset_afiliados_consolidado_chile["fecha_nac"]
)

print("=" * 60)
print("Nueva variable: edad")
print("=" * 60)
print(
    dataset_afiliados_consolidado_chile[
        ["fecha_nac", "edad"]
    ].head()
)


# Tipo de cambio aproximado (CLP -> PEN)
exchange_rate_clp_to_pen = 0.004

# Crear la variable remuneración en soles
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
# EDA - Exploración de Datos
# =====================================

print("=" * 60)
print("Columnas del dataset")
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
# EDA - Análisis Univariado
# Distribución de la edad
# =====================================

import matplotlib.pyplot as plt
import seaborn as sns

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