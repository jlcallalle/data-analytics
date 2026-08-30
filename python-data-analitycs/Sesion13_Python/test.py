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
print(dataset_afiliados_consolidado_chile["edad"].describe())


# =====================================
# 6. Análisis de variable saldoA_pesos_cero_flag
# =====================================

# Se cuenta la cantidad de registros por cada valor de la variable.
# Esto ayuda a saber cuántos afiliados tienen saldo A igual a cero.
print("\n" + "=" * 60)
print("Conteo de saldoA_pesos_cero_flag")
print("=" * 60)
print(dataset_afiliados_consolidado_chile["saldoA_pesos_cero_flag"].value_counts())

