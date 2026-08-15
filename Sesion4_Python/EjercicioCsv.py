import pandas as pd

# Ruta del archivo CSV
ruta_csv = "recursos/Datos_abiertos_matriculas_2024_2_2025_1_0.csv"

# Leer el archivo
df_alumnos_uni = pd.read_csv(ruta_csv, sep=",")

# Mostrar las primeras cinco filas
print(df_alumnos_uni.head())

# Mostrar dimensiones
print("\nCantidad de filas:", df_alumnos_uni.shape[0])
print("Cantidad de columnas:", df_alumnos_uni.shape[1])

# Mostrar nombres de las columnas
print("\nColumnas:")
print(df_alumnos_uni.columns.tolist())