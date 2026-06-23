# 22/06/2026

#Colab FIX Clase 5 :
# dataset_onp_202512 = pd.read_csv('/content/drive/MyDrive/data_curso_python/Afiliados_SNP_Diciembre2025.csv', sep=';', on_bad_lines='skip')

""" Sesión 6:
Taller práctico
Visualización de gráficos con la librería matplotlib
Visualización de gráficos con la librería seaborn
Explorando la libreria Polars
EDA: Análisis univariado, bivariado y multivariado
 """

# Sesión 6 - Agrupamiento con Pandas

import pandas as pd

# Leer el archivo CSV
dataset_arbitrios_jm = pd.read_csv(
    'dataset/dataset vf_3.csv',
    sep=';',
    on_bad_lines='skip'
)

# Verificar tipos de datos
print("Tipos de datos antes de convertir:")
print(dataset_arbitrios_jm[['MONTO_SERENAZGO',
                            'MONTO_PARQUE_JARDIN']].dtypes)

# Convertir columnas a numéricas
dataset_arbitrios_jm['MONTO_SERENAZGO'] = pd.to_numeric(
    dataset_arbitrios_jm['MONTO_SERENAZGO'],
    errors='coerce'
)

dataset_arbitrios_jm['MONTO_PARQUE_JARDIN'] = pd.to_numeric(
    dataset_arbitrios_jm['MONTO_PARQUE_JARDIN'],
    errors='coerce'
)

# Verificar nuevamente los tipos
print("\nTipos de datos después de convertir:")
print(dataset_arbitrios_jm[['MONTO_SERENAZGO',
                            'MONTO_PARQUE_JARDIN']].dtypes)

# Agrupar por PERIODO
resultado = (
    dataset_arbitrios_jm
    .groupby('PERIODO', as_index=False)
    .agg({
        'MONTO_SERENAZGO': 'sum',
        'MONTO_PARQUE_JARDIN': 'mean'
    })
)

# Redondear el promedio a 2 decimales
resultado['MONTO_PARQUE_JARDIN'] = (
    resultado['MONTO_PARQUE_JARDIN'].round(2)
)

# Mostrar resultado
print("\n=== Agrupamiento por PERIODO ===")
print(resultado.to_string(index=False))