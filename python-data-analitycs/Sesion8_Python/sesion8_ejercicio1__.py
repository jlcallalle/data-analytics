import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# ==========================
# Funciones de transformación
# ==========================
def convertir_est_civil(registro):
    if registro == 1:
        return 'Soltero'
    elif registro == 2:
        return 'Casado'
    elif registro == 3:
        return 'Viudo'
    elif registro == 4:
        return 'Divorciado'
    else:
        return registro


def convertir_sexo(registro):
    if registro == 2:
        return 'Mujer'
    elif registro == 1:
        return 'Hombre'
    else:
        return registro


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
print("\n--- Información ---")
dataset_onp_202512.info()

print("\n--- Primeras 5 filas ---")
print(dataset_onp_202512.head())

