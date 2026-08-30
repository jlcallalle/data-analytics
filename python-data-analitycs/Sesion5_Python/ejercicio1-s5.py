# Sesión 5 - Exploración básica de datos

import pandas as pd
# Leer el archivo CSV ubicado dentro de la carpeta "dataset"
# sep=';' indica que las columnas están separadas por punto y coma
# on_bad_lines='skip' omite filas con errores de formato
# low_memory=False evita advertencias por tipos de datos mixtos

# Cargar archivo CSV
dataset_arbitrios_jm = pd.read_csv(
    'dataset/dataset vf_3.csv',
    sep=';',
    low_memory=False
)

# Primeras filas #Clase
print("\n--- Primeras 5 filas ---")
print(dataset_arbitrios_jm.head())

# Columnas
print("\n--- Columnas ---")
print(dataset_arbitrios_jm.columns)

# Dimensiones
print("\n--- Filas y columnas ---")
print(dataset_arbitrios_jm.shape)

# Información general
print("\n--- Información ---")
dataset_arbitrios_jm.info()

# Estadísticas
print("\n--- Estadísticas ---")
print(dataset_arbitrios_jm.describe())