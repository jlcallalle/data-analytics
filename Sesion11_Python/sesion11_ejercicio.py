# =====================================
# Importación de datos
# =====================================

import pandas as pd

# Ruta del dataset
RUTA_DATASET = "dataset/notas-de-prensa-del-pronabec.csv"

# Cargar dataset
dataset_pronabec = pd.read_csv(RUTA_DATASET)

# =====================================
# Exploración inicial
# =====================================

print("=" * 60)
print("Primeras 5 filas")
print("=" * 60)
print(dataset_pronabec.head())

print("\n" + "=" * 60)
print("Información del dataset")
print("=" * 60)
print(dataset_pronabec.info())

# =====================================
# Limpieza de datos
# =====================================

# Eliminar registros donde el resumen sea nulo
dataset_pronabec.dropna(subset=["SUMARIO"], inplace=True)

# Crear columna TEXTO
dataset_pronabec["TEXTO"] = (
    dataset_pronabec["TITULO"] + ". " + dataset_pronabec["SUMARIO"]
)

# Convertir a texto
dataset_pronabec["TEXTO"] = dataset_pronabec["TEXTO"].astype(str)

print("\nCantidad de registros:", len(dataset_pronabec))

print("\nEjemplo de TEXTO:")
print(dataset_pronabec["TEXTO"].head())

print("\nEjemplo de .TEXTO[0]")
print(dataset_pronabec.TEXTO[0])


# =====================================
# Preprocesamiento de texto
# =====================================

import re

def procesamiento_texto(texto):
    # Convertir a minúsculas
    texto = texto.lower()

    # Eliminar guiones
    texto = re.sub(r'[-]', '', texto)

    # Reemplazar vocales con tilde
    texto = re.sub(r'á', 'a', texto)
    texto = re.sub(r'é', 'e', texto)
    texto = re.sub(r'í', 'i', texto)
    texto = re.sub(r'ó', 'o', texto)
    texto = re.sub(r'ú', 'u', texto)

    # Reemplazar diéresis
    texto = re.sub(r'ü', 'u', texto)

    return texto

# Aplicar procesamiento
dataset_pronabec["TEXTO_PROCESADO"] = (
    dataset_pronabec["TEXTO"].apply(procesamiento_texto)
)

# =====================================
# Visualización
# =====================================

print("=" * 60)
print("Texto original")
print("=" * 60)
print(dataset_pronabec["TEXTO"].iloc[0])

print("\n" + "=" * 60)
print("Texto procesado")
print("=" * 60)
print(dataset_pronabec["TEXTO_PROCESADO"].iloc[0])