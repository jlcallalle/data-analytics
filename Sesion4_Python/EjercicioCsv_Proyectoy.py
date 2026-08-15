import pandas as pd

# Ruta del archivo CSV
ruta_csv = "recursos/DataSet_Estadistica_Agricola_2023_2024_2025.csv"

# Leer el archivo
df_alumnos_uni = pd.read_csv(ruta_csv, sep=';', encoding='latin1') 

# Mostrar las primeras cinco filas
print(df_alumnos_uni.head())

# Mostrar dimensiones
print("\nCantidad de filas:", df_alumnos_uni.shape[0])
print("Cantidad de columnas:", df_alumnos_uni.shape[1])

# Mostrar nombres de las columnas
print("\nColumnas:")
print(df_alumnos_uni.columns.tolist())