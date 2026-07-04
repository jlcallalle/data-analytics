import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# ==========================
# Funciones de transformación
# ==========================
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


# ==========================
# Lectura del CSV
# ==========================
dataset_onp_202512 = pd.read_csv(
    'dataset/Afiliados_SNP_Diciembre2025.csv',
    sep=',',
    low_memory=False
)

# ==========================
# Información general
# ==========================
print("\n--- Información del dataset original ---")
dataset_onp_202512.info()

print("\n--- Primeras 5 filas ---")
print(dataset_onp_202512.head())

# ==========================
# Filtrar afiliados activos
# ==========================
dataset_onp_202512_activos = dataset_onp_202512.loc[
    dataset_onp_202512['ultimo_periodo'] == 202512
]

dataset_onp_202512_activos_mod = dataset_onp_202512_activos.copy()

# ==========================
# Transformaciones
# ==========================
dataset_onp_202512_activos_mod['sexo_des'] = (
    dataset_onp_202512_activos_mod['sexoact'].apply(convertir_sexoact)
)

dataset_onp_202512_activos_mod['tipo_dep_des'] = (
    dataset_onp_202512_activos_mod['tipo_dep'].apply(convertir_tipo_dep)
)

dataset_onp_202512_activos_mod['dpto_des'] = (
    dataset_onp_202512_activos_mod['dpto'].apply(convertir_dpto)
)

# ==========================
# Información del dataset transformado
# ==========================
print("\n--- Información del dataset transformado ---")
dataset_onp_202512_activos_mod.info()

print("\n--- Estadísticas descriptivas ---")
print(dataset_onp_202512_activos_mod.describe())

# ==========================
# Imputación de datos nulos
# 1. Identificación de datos nulos
# ==========================
print("\n--- Identificación de datos nulos ---")
print(dataset_onp_202512_activos_mod.isna().sum())


# ==========================
# Resumen de valores nulos
# ==========================

# Crear un DataFrame vacío donde se almacenará el resumen
resumen_valores_nulos = pd.DataFrame()

# Recorrer cada columna del dataset
for column in dataset_onp_202512_activos_mod.columns:

    # Crear un DataFrame temporal con:
    # 1. Nombre de la variable
    # 2. Cantidad de valores nulos
    # 3. Porcentaje de valores nulos respecto al total de registros
    df_tmp = pd.DataFrame(
        data=[[
            column,
            dataset_onp_202512_activos_mod[column].isna().sum(),
            np.round(
                100
                * dataset_onp_202512_activos_mod[column].isna().sum()
                / dataset_onp_202512_activos_mod[column].shape[0],
                2
            )
        ]]
    )

    # Agregar la fila temporal al DataFrame resumen
    resumen_valores_nulos = pd.concat(
        [resumen_valores_nulos, df_tmp],
        ignore_index=True
    )

# Asignar nombres a las columnas del resumen
resumen_valores_nulos.columns = [
    'variable',
    'valores_nulos',
    'porcentaje_nulos'
]

# Ordenar de mayor a menor porcentaje de nulos
resumen_valores_nulos.sort_values(
    by='porcentaje_nulos',
    ascending=False,
    inplace=True
)

# Reiniciar el índice después del ordenamiento
resumen_valores_nulos.reset_index(
    drop=True,
    inplace=True
)

# Mostrar el resultado final
print("\n--- Resumen de valores nulos ---")
print(resumen_valores_nulos)


# ==========================
# Eliminación de valores nulos
# ==========================

# Crear una copia del dataset transformado para no modificar el original
dataset_onp_202512_activos_filtrado = (
    dataset_onp_202512_activos_mod.copy()
)

# Reiniciar el índice (0, 1, 2, 3, ...)
# Es útil cuando anteriormente se realizaron filtros sobre el dataset.
dataset_onp_202512_activos_filtrado.reset_index(
    drop=True,
    inplace=True
)

# Eliminar las filas que tengan valores nulos en las variables indicadas.
# subset: columnas que se consideran obligatorias.
# inplace=True: aplica el cambio sobre el mismo DataFrame.
dataset_onp_202512_activos_filtrado.dropna(
    subset=[
        'edadact',
        'fnacact',
        'sexoact',
        'redadact',
        'sexo_des',
        'primer_periodo'
    ],
    inplace=True
)

# Mostrar información del dataset luego de eliminar registros
print("\n--- Información del dataset filtrado ---")
dataset_onp_202512_activos_filtrado.info()

print("\nCantidad de registros:", len(dataset_onp_202512_activos_filtrado))


# ==========================
# Imputación elemental
# Variable categórica: estcivil
# ==========================

# Mostrar algunos registros para observar los valores nulos
print("\n--- Valores originales de estcivil ---")
print(
    dataset_onp_202512_activos_filtrado['estcivil']
    .iloc[150:155]
)

# ==========================
# Método 1: Forward Fill (ffill)
# Rellena los nulos con el valor anterior.
# Ejemplo:
# [1, 2, NaN, NaN, 2] -> [1, 2, 2, 2, 2]
# ==========================
print("\n--- estcivil usando ffill() ---")
print(
    dataset_onp_202512_activos_filtrado['estcivil']
    .ffill()
    .iloc[150:155]
)

# ==========================
# Método 2: Backward Fill (bfill)
# Rellena los nulos con el siguiente valor.
# Ejemplo:
# [1, 2, NaN, NaN, 2] -> [1, 2, 2, 2, 2]
# ==========================
print("\n--- estcivil usando bfill() ---")
print(
    dataset_onp_202512_activos_filtrado['estcivil']
    .bfill()
    .iloc[150:155]
)

# ==========================
# Distribución de la variable
# ==========================
print("\n--- Frecuencia de estado civil ---")
print(
    dataset_onp_202512_activos_filtrado['estcivil']
    .value_counts(dropna=False)
)




# ==========================
# Imputación elemental
# Variable categórica: estcivil
# ==========================

# Obtener la moda (valor más frecuente)
moda_estcivil = (
    dataset_onp_202512_activos_filtrado['estcivil']
    .mode()
)

print("\nModa de estcivil:")
print(moda_estcivil)

# Mostrar algunos registros luego de imputar
# (No modifica el DataFrame original)
print("\n--- estcivil imputado con la moda ---")
print(
    dataset_onp_202512_activos_filtrado
    .fillna(value={'estcivil': moda_estcivil.values[0]})
    .estcivil
    .iloc[150:155]
)


# ==========================
# Imputación elemental
# Variable numérica: monto_aportes
# ==========================

# Mostrar algunos registros originales
print("\n--- Valores originales de monto_aportes ---")
print(
    dataset_onp_202512_activos_filtrado['monto_aportes']
    .iloc[160:165]
)

# Mostrar cómo quedaría la variable imputando los nulos con 0.
# Este comando NO modifica el DataFrame original.
print("\n--- monto_aportes imputado con 0 ---")
print(
    dataset_onp_202512_activos_filtrado
    .fillna(value={'monto_aportes': 0})
    .monto_aportes
    .iloc[160:165]
)

# ==========================
# Histograma de remuneración
# ==========================

# Crear un gráfico únicamente para personas con remuneración menor a 5000.
# Esto permite visualizar mejor la distribución, ya que valores muy altos
# pueden distorsionar el gráfico.

plt.figure(figsize=(10, 6))

sns.histplot(
    data=dataset_onp_202512_activos_filtrado.loc[
        dataset_onp_202512_activos_filtrado['remuneracion'] < 5000
    ],
    x='remuneracion',
    bins=100,
    kde=True
)

# Agregar título y etiquetas
plt.title('Distribución de la remuneración (< 5000)')
plt.xlabel('Remuneración')
plt.ylabel('Frecuencia')

# Mostrar el gráfico
plt.show()



import pingouin as pg

# ==========================
# Gráfico Q-Q de remuneración
# ==========================

plt.figure(figsize=(8, 6))

pg.qqplot(
    dataset_onp_202512_activos_filtrado['remuneracion'],
    dist='norm'
)

plt.title('Q-Q Plot de la variable remuneración')
plt.show()