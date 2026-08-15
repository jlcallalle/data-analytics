import pandas as pd

try:
    import matplotlib.pyplot as plt
except ModuleNotFoundError:
    plt = None

# Ruta del archivo CSV
ruta_csv = "recursos/DataSet_Estadistica_Agricola_2023_2024_2025.csv"

# Leer el archivo
df_data_agro = pd.read_csv(ruta_csv, sep=';', encoding='latin1') 

# Mostrar las primeras cinco filas
print(df_data_agro.head())

# Mostrar dimensiones
print("\nCantidad de filas:", df_data_agro.shape) # (3672, 15)

# Mostrar nombres de las columnas
print("\nColumnas:")
print(df_data_agro.columns.tolist())
#['Departamento', 'Provincia', 'Cod_Ubigeo', 'Distrito', 'Cod_Cultivo', 'Cultivo_Agricola', 'Campania_Agricola', 'Superficie_Verde', 'Sembrada', 'Cosechada', 'Produccion', 'Rendimiento', 'Precio_en_Chacra', 'Superficie_Perdida', 'Fecha_Corte'] 


# Mostrar info
print("\nInformacion:")
df_data_agro.info()

df_diccionario = pd.read_excel(
    "recursos/Diccionario_Estadística_agrícola_2024_2025.xlsx",
    header=3,
    engine="openpyxl"
)

print("\nDiccionario de datos:")
print(df_diccionario.head())


# Mayor producción agrícola
print("\nMayor producción agrícola:")
print(df_data_agro.Produccion.max())

# Mayor cultivo agrícola
print("\nMayor cultivo agrícola:")
print(df_data_agro.Cultivo_Agricola.max())


# Unique para obtener los valores únicos de la columna "Fecha_Corte"
print("\nValores únicos de Fecha_Corte:")
print(df_data_agro.Fecha_Corte.unique())


# ============================================================
# ANALISIS UNIVARIADO DE DATOS
# ============================================================

print("\n" + "=" * 60)
print("ANALISIS UNIVARIADO DE DATOS")
print("=" * 60)

# Variables categoricas: describen grupos, codigos o etiquetas.
variables_categoricas = [
    "Departamento",
    "Provincia",
    "Cod_Ubigeo",
    "Distrito",
    "Cod_Cultivo",
    "Cultivo_Agricola",
    "Campania_Agricola",
    "Fecha_Corte",
]

# Variables numericas: representan cantidades medibles.
variables_numericas = [
    "Superficie_Verde",
    "Sembrada",
    "Cosechada",
    "Produccion",
    "Rendimiento",
    "Precio_en_Chacra",
    "Superficie_Perdida",
]

print("\nVariables categoricas:")
print(variables_categoricas)

print("\nVariables numericas:")
print(variables_numericas)


# ------------------------------------------------------------
# Analisis univariado de variables categoricas
# ------------------------------------------------------------
print("\n" + "-" * 60)
print("VARIABLES CATEGORICAS")
print("-" * 60)

for columna in variables_categoricas:
    print(f"\nColumna: {columna}")
    print("Cantidad de valores unicos:", df_data_agro[columna].nunique())
    print("Frecuencia de valores:")
    print(df_data_agro[columna].value_counts().head(10))


# ------------------------------------------------------------
# Analisis univariado de variables numericas
# ------------------------------------------------------------
print("\n" + "-" * 60)
print("VARIABLES NUMERICAS")
print("-" * 60)

print("\nEstadisticas descriptivas:")
print(df_data_agro[variables_numericas].describe())

print("\nValores nulos por variable numerica:")
print(df_data_agro[variables_numericas].isnull().sum())

print("\nCantidad de valores cero por variable numerica:")
print((df_data_agro[variables_numericas] == 0).sum())

print("\nValores minimos por variable numerica:")
print(df_data_agro[variables_numericas].min())

print("\nValores maximos por variable numerica:")
print(df_data_agro[variables_numericas].max())


# ============================================================
# GRAFICOS DE VARIABLES CATEGORICAS CON MATPLOTLIB
# ============================================================

print("\n" + "=" * 60)
print("GRAFICOS DE VARIABLES CATEGORICAS")
print("=" * 60)

if plt is None:
    print("No se encontro matplotlib. Instala la libreria con: pip install matplotlib")
else:
    # Para el analisis principal se filtra la campania mas reciente.
    df_data_agro_2024_2025 = df_data_agro.loc[
        df_data_agro["Campania_Agricola"] == "2024-2025"
    ].copy()

    # Limpieza basica para mejorar etiquetas en los graficos.
    df_data_agro_2024_2025["Provincia"] = df_data_agro_2024_2025["Provincia"].str.strip()
    df_data_agro_2024_2025["Distrito"] = df_data_agro_2024_2025["Distrito"].str.strip()
    df_data_agro_2024_2025["Cultivo_Agricola"] = (
        df_data_agro_2024_2025["Cultivo_Agricola"].astype(str).str.strip()
    )

    def graficar_frecuencia_categorica(dataframe, columna, titulo, top_n=10):
        """Grafica las frecuencias de una variable categorica."""
        frecuencias = dataframe[columna].value_counts(dropna=False).head(top_n)
        frecuencias = frecuencias.sort_values()

        plt.figure(figsize=(10, 6))
        plt.barh(frecuencias.index.astype(str), frecuencias.values, color="#2E86AB")
        plt.title(titulo)
        plt.xlabel("Numero de registros")
        plt.ylabel(columna)

        for indice, valor in enumerate(frecuencias.values):
            plt.text(valor, indice, f" {valor}", va="center")

        plt.tight_layout()
        plt.show()

    # Graficos categoricos generales del dataset completo.
    graficar_frecuencia_categorica(
        df_data_agro,
        "Campania_Agricola",
        "Cantidad de registros por campania agricola",
        top_n=10,
    )

    graficar_frecuencia_categorica(
        df_data_agro,
        "Fecha_Corte",
        "Cantidad de registros por fecha de corte",
        top_n=10,
    )

    # Graficos categoricos para la campania 2024-2025.
    graficar_frecuencia_categorica(
        df_data_agro_2024_2025,
        "Provincia",
        "Top 10 provincias con mas registros - Campania 2024-2025",
        top_n=10,
    )

    graficar_frecuencia_categorica(
        df_data_agro_2024_2025,
        "Cultivo_Agricola",
        "Top 10 cultivos agricolas con mas registros - Campania 2024-2025",
        top_n=10,
    )

    graficar_frecuencia_categorica(
        df_data_agro_2024_2025,
        "Distrito",
        "Top 10 distritos con mas registros - Campania 2024-2025",
        top_n=10,
    )

    graficar_frecuencia_categorica(
        df_data_agro_2024_2025,
        "Cod_Cultivo",
        "Top 10 codigos de cultivo con mas registros - Campania 2024-2025",
        top_n=10,
    )



print(df_data_agro["Departamento"].value_counts())
print(df_data_agro["Provincia"].value_counts())
print(df_data_agro["Cultivo_Agricola"].value_counts())
print(df_data_agro["Campania_Agricola"].value_counts())
print(df_data_agro["Fecha_Corte"].value_counts())

print("\nDepartamentos:")
print(df_data_agro["Departamento"].value_counts())

print("\nProvincias:")
print(df_data_agro["Provincia"].value_counts())

print ("\nCultivos agrícolas:")
print(df_data_agro["Cultivo_Agricola"].value_counts())
print ("\nCampañas agrícolas:")
print(df_data_agro["Campania_Agricola"].value_counts())
print ("\nFechas de corte:")
print(df_data_agro["Fecha_Corte"].value_counts())
