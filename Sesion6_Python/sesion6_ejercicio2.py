import pandas as pd
import matplotlib.pyplot as plt

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

print("\n--- Último periodo máximo ---")
print(dataset_onp_202512['ultimo_periodo'].max())

# ==========================
# Filtrar afiliados activos
# ==========================
dataset_onp_202512_activos = dataset_onp_202512.loc[
    dataset_onp_202512['ultimo_periodo'] == 202512
].copy()

print("\n--- Afiliados activos ---")
print(dataset_onp_202512_activos.head())

# ==========================
# Crear nuevas columnas
# ==========================
dataset_onp_202512_activos['estcivil_den'] = (
    dataset_onp_202512_activos['estcivil']
    .apply(convertir_est_civil)
)

dataset_onp_202512_activos['sexo_den'] = (
    dataset_onp_202512_activos['sexoact']
    .apply(convertir_sexo)
)

print("\n--- Resultado ---")
print(
    dataset_onp_202512_activos[
        ['id_persona', 'sexoact', 'sexo_den',
         'estcivil', 'estcivil_den']
    ].head()
)

print("\nCantidad de registros:")
print(dataset_onp_202512_activos.shape)


# ==========================
#  Matplotlib
#  Contar registros por estado civil
# ==========================

## Visualización de gráficos con la librería matplotlib 

# Conteos
print(
    dataset_onp_202512_activos['estcivil_den']
    .value_counts(dropna=False)
)

# Resumen
resumen_estcivil = (
    dataset_onp_202512_activos
    .groupby(
        by='estcivil_den',
        as_index=False
    )
    .agg(
        nro_registros=('estcivil_den', 'count')
    )
)

print(resumen_estcivil)

# 1. Gráfico de barras
plt.figure(figsize=(8, 5))
plt.bar(
    resumen_estcivil['estcivil_den'],
    resumen_estcivil['nro_registros']
)
plt.title('Afiliados por Estado Civil')
plt.xlabel('Estado Civil')
plt.ylabel('Cantidad')

plt.show()





# 2. Histograma de edades
fig, ax = plt.subplots(figsize=(8, 4))

ax.hist(
    dataset_onp_202512_activos['edadact'].dropna(),
    bins=40
)

ax.set_xlabel('Edad')
ax.set_ylabel('Frecuencia')
ax.set_title('Distribución de afiliados por edad')

plt.show()