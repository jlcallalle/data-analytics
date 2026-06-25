import pandas as pd
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
    elif registro == 11:
        return 'Ica'
    elif registro == 21:
        return 'Puno'
    elif registro == 6:
        return 'Cajamarca'
    elif registro == 7:
        return 'Callao'
    elif registro == 8:
        return 'Cusco'
    else:
        return 'Otro departamento'


# ==========================
# Lectura del CSV
# ==========================
dataset_onp_202512 = pd.read_csv(
    'dataset/Afiliados_SNP_Diciembre2025.csv',
    sep=',',
    low_memory=False
)

# ==========================
# Filtrar afiliados activos
# ==========================
dataset_onp_202512_activos = dataset_onp_202512.loc[
    dataset_onp_202512['ultimo_periodo'] == 202512
].copy()

# ==========================
# Crear una copia
# ==========================
dataset_onp_202512_activos_mod = (
    dataset_onp_202512_activos.copy()
)

# ==========================
# Crear nuevas columnas
# ==========================
dataset_onp_202512_activos_mod['sexo_des'] = (
    dataset_onp_202512_activos_mod['sexoact']
    .apply(convertir_sexoact)
)

dataset_onp_202512_activos_mod['tipo_dep_des'] = (
    dataset_onp_202512_activos_mod['tipo_dep']
    .apply(convertir_tipo_dep)
)

dataset_onp_202512_activos_mod['dpto_des'] = (
    dataset_onp_202512_activos_mod['dpto']
    .apply(convertir_dpto)
)

# ==========================
# Mostrar resultado
# ==========================
print("\n--- Primeras filas ---")
print(
    dataset_onp_202512_activos_mod[
        [
            'id_persona',
            'sexoact',
            'sexo_des',
            'tipo_dep',
            'tipo_dep_des',
            'dpto',
            'dpto_des'
        ]
    ].head()
)

print("\nCantidad de registros:")
print(dataset_onp_202512_activos_mod.shape)

print("\nInformación:")
print(dataset_onp_202512_activos_mod.info())

# ==========================
# Resumen por sexo
# ==========================
df_tmp = (
    dataset_onp_202512_activos_mod
    .groupby(
        by='sexo_des',
        as_index=False
    )
    .agg(
        nro_registros=('sexo_des', 'count')
    )
)

print("\n--- Cantidad de afiliados por sexo ---")
print(df_tmp)

# ==========================
# Eliminar registros con primer_periodo nulo
# ==========================
dataset_onp_202512.dropna(
    subset=['primer_periodo'],
    inplace=True
)

# Convertir a entero
dataset_onp_202512['primer_periodo'] = (
    dataset_onp_202512['primer_periodo']
    .astype(int)
)

# ==========================
# Cantidad de afiliados por primer periodo
# ==========================
df_primer_periodo = (
    dataset_onp_202512
    .groupby(
        by='primer_periodo'
    )
    .agg(
        nro_registros=('primer_periodo', 'count')
    )
)
#aag consolidar o agregar,  indica que tipo de agrupamiento, por categoria

print("\n--- Afiliados por primer periodo ---")
print(df_primer_periodo)

#Afiliado de sistema nacional de pensiones

# ==========================
# Afiliados desde 2024
# ==========================
df_tmp2 = (
    dataset_onp_202512
    .loc[
        dataset_onp_202512['primer_periodo'] > 202312
    ]
    .groupby(
        by='primer_periodo',
        as_index=False
    )
    .agg(
        nro_registros=('primer_periodo', 'count')
    )
)

df_tmp2['primer_periodo_datetime'] = pd.to_datetime(
    df_tmp2['primer_periodo'].astype(str),
    format='%Y%m'
)

print("\n--- Afiliados por primer periodo desde 2024 ---")
print(df_tmp2)


# ==========================
# Seaborn
# Gráfico de barras por sexo
# ==========================
plt.figure(figsize=(6, 4))

sns.barplot(
    data=df_tmp,
    x='sexo_des',
    y='nro_registros'
)

plt.title('Cantidad de afiliados por sexo')
plt.xlabel('Sexo')
plt.ylabel('Número de registros')

plt.tight_layout()
plt.show()

# ==========================
# Matplotlib
# Gráfico de pastel por sexo
# ==========================
plt.figure(figsize=(6, 6))

plt.pie(
    df_tmp['nro_registros'],
    labels=df_tmp['sexo_des'],
    autopct='%1.1f%%',
    startangle=140
)

plt.title('Distribución por sexo')

# Mantener el gráfico circular
plt.axis('equal')

plt.show()


# ==========================
# Distribución por tipo de dependencia
# ==========================

df_tmp3 = (
    dataset_onp_202512_activos_mod
    .groupby(
        by='tipo_dep_des',
        as_index=False
    )
    .agg(
        nro_registros=('tipo_dep_des', 'count')
    )
)

print("\n--- Distribución por tipo de dependencia ---")
print(df_tmp3)

# Gráfico de pastel
plt.figure(figsize=(6, 6))

plt.pie(
    df_tmp3['nro_registros'],
    labels=df_tmp3['tipo_dep_des'],
    autopct='%1.1f%%',
    startangle=140
)

plt.title('Distribución por tipo de dependencia')

# Mantener el gráfico como un círculo
plt.axis('equal')

plt.show()


# ==========================
# Cantidad de afiliados por departamento
# ==========================
plt.figure(figsize=(12, 6))

sns.countplot(
    data=dataset_onp_202512_activos_mod,
    x='dpto'
)

plt.title('Cantidad de afiliados por departamento')
plt.xlabel('Código de departamento')
plt.ylabel('Número de afiliados')

plt.tight_layout()
plt.show()



# ==========================

plt.figure(figsize=(12, 6))

sns.countplot(
    data=dataset_onp_202512_activos_mod,
    x='dpto_des'
)

plt.title('Cantidad de afiliados por departamento')
plt.xlabel('Departamento')
plt.ylabel('Número de afiliados')

plt.xticks(rotation=45)

plt.tight_layout()
plt.show()

# ==========================
# Cantidad de afiliados por departamento
# (gráfico horizontal)
# ==========================
plt.figure(figsize=(8, 4))

sns.countplot(
    data=dataset_onp_202512_activos_mod,
    y='dpto_des',
    order=dataset_onp_202512_activos_mod[
        'dpto_des'
    ].value_counts().index
)

plt.title('Cantidad de afiliados por departamento')
plt.xlabel('Número de afiliados')
plt.ylabel('Departamento')

plt.tight_layout()
plt.show()


# ==========================
# Histograma de edades con Seaborn
# ==========================

# Crear una figura de 8 pulgadas de ancho y 4 de alto
plt.figure(figsize=(8, 4))

# Crear un histograma de la variable edadact
sns.histplot(
    data=dataset_onp_202512_activos_mod,  # DataFrame que contiene los datos
    x='edadact',                          # Columna que se graficará en el eje X
    bins=40,                             # Dividir las edades en 40 intervalos (barras)
    kde=True                             # Agregar la curva de densidad (Kernel Density Estimation)
)

# Agregar título al gráfico
plt.title('Distribución de afiliados por edad')

# Etiqueta del eje X
plt.xlabel('Edad')

# Etiqueta del eje Y
plt.ylabel('Frecuencia')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()



# ==========================
# Histograma de remuneraciones menores a 10,000
# ==========================

# Crear una figura de 8 pulgadas de ancho y 4 de alto
plt.figure(figsize=(8, 4))

# Crear un histograma únicamente con los afiliados
# cuya remuneración es menor a 10,000
sns.histplot(
    data=dataset_onp_202512_activos_mod.loc[
        dataset_onp_202512_activos_mod['remuneracion'] < 10000
    ],
    x='remuneracion',  # Variable a graficar en el eje X
    bins=40            # Dividir las remuneraciones en 40 intervalos
)

# Agregar título y etiquetas
plt.title('Distribución de remuneraciones menores a 10,000')
plt.xlabel('Remuneración')
plt.ylabel('Frecuencia')

# Ajustar márgenes automáticamente
plt.tight_layout()

# Mostrar el gráfico
plt.show()