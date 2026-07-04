# dataset_onp_202512 = pd.read_csv('/content/drive/MyDrive/DataAnalytics/Afiliados_SNP_Diciembre2025.csv')

# =====================================
# Sesión 9 - Python para Data Analytics
# =====================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.preprocessing import MinMaxScaler, StandardScaler
import pingouin as pg


# =====================================
# Configuración
# =====================================
RUTA_DATASET = 'dataset/Afiliados_SNP_Diciembre2025.csv'


# =====================================
# Funciones de transformación
# =====================================
def convertir_sexoact(registro):
    if registro == 2:
        return 'Mujer'
    elif registro == 1:
        return 'Hombre'
    else:
        return registro


def convertir_tipo_dep(registro):
    if registro == 1:
        return 'Dependiente'
    elif registro == 2:
        return 'Independiente'
    else:
        return registro


def convertir_dpto(registro):
    if registro == 15:
        return 'Lima'
    elif registro == 2:
        return 'Ancash'
    elif registro == 4:
        return 'Arequipa'
    elif registro == 13:
        return 'La Libertad'
    elif registro == 20:
        return 'Piura'
    elif registro == 25:
        return 'Extranjero'
    elif registro == 12:
        return 'Junín'
    elif registro == 14:
        return 'Lambayeque'
    else:
        return 'Otra provincia'


# =====================================
# Lectura del dataset
# =====================================
dataset_onp_202512 = pd.read_csv(
    RUTA_DATASET,
    sep=',',
    low_memory=False,
    on_bad_lines='skip'
)

print('\n--- Información Dataset ---')
dataset_onp_202512.info()

print('\n--- Primeras filas ---')
print(dataset_onp_202512.head())


# =====================================
# Filtrar afiliados activos
# =====================================
dataset_onp_202512_activos_tmp = (
    dataset_onp_202512.loc[
        dataset_onp_202512['ultimo_periodo'] == 202512
    ]
)

dataset_onp_202512_activos = (
    dataset_onp_202512_activos_tmp.copy()
)


# =====================================
# Variables descriptivas
# =====================================
dataset_onp_202512_activos['sexo_des'] = (
    dataset_onp_202512_activos['sexoact']
    .apply(convertir_sexoact)
)

dataset_onp_202512_activos['tipo_dep_des'] = (
    dataset_onp_202512_activos['tipo_dep']
    .apply(convertir_tipo_dep)
)

dataset_onp_202512_activos['dpto_des'] = (
    dataset_onp_202512_activos['dpto']
    .apply(convertir_dpto)
)


print('\nCantidad de registros:')
print(len(dataset_onp_202512_activos))

print('\nPrimeras filas:')
print(dataset_onp_202512_activos.head())


# =====================================
# Escalamiento de datos
# =====================================
print('\nEdad mínima:')
print(dataset_onp_202512_activos['edadact'].min())

print('\nEdad máxima:')
print(dataset_onp_202512_activos['edadact'].max())


# =====================================
# Histograma de edad
# =====================================
plt.figure(figsize=(10, 6))

sns.histplot(
    dataset_onp_202512_activos['edadact'],
    kde=True,
    bins=20
)

plt.title('Distribución de edad')
plt.show()


# =====================================
# Normalización
# =====================================
scaler = MinMaxScaler()

dataset_onp_202512_activos['edad_norm'] = (
    scaler.fit_transform(
        dataset_onp_202512_activos[['edadact']]
    )
)

print('\nEdad normalizada mínima:')
print(dataset_onp_202512_activos['edad_norm'].min())

print('\nEdad normalizada máxima:')
print(dataset_onp_202512_activos['edad_norm'].max())


# =====================================
# Histograma de edad normalizada
# =====================================
plt.figure(figsize=(10, 6))

sns.histplot(
    dataset_onp_202512_activos['edad_norm'],
    kde=True,
    bins=20
)

plt.title('Distribución de edad normalizada')
plt.show()


# =====================================
# Estandarización
# =====================================
scaler_std = StandardScaler()

dataset_onp_202512_activos['edad_std'] = (
    scaler_std.fit_transform(
        dataset_onp_202512_activos[['edadact']]
    )
)

print('\nMedia edad_std:')
print(
    dataset_onp_202512_activos['edad_std'].mean()
)

print('\nDesviación estándar edad_std:')
print(
    dataset_onp_202512_activos['edad_std'].std()
)


# =====================================
# QQ Plot
# =====================================
""" plt.figure(figsize=(8, 6))

pg.qqplot(
    dataset_onp_202512_activos['edadact'],
    dist='norm'
)

plt.title('QQ Plot Edad')
plt.show() """