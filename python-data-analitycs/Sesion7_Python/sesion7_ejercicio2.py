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



# ==========================
# Histograma y Boxplot de monto_aportes
# ==========================

# Crear una figura con 1 fila y 2 columnas de gráficos
# figsize=(14,6) indica 14 pulgadas de ancho y 6 de alto.
# fig representa la figura completa y ax es un arreglo con los dos gráficos.
fig, ax = plt.subplots(1, 2, figsize=(14, 6))

# --------------------------
# Gráfico 1: Histograma
# --------------------------
sns.histplot(
    # Filtrar únicamente registros con monto_aportes menor a 200,000
    # para evitar que los valores extremos (outliers) distorsionen el gráfico.
    data=dataset_onp_202512_activos_mod.loc[
        dataset_onp_202512_activos_mod['monto_aportes'] < 200000
    ],

    # Variable a graficar en el eje X
    x='monto_aportes',

    # Dividir los datos en 40 intervalos (barras)
    bins=40,

    # Dibujar el gráfico en la primera posición (izquierda)
    ax=ax[0]
)

# Agregar título al primer gráfico
ax[0].set_title('Histograma de monto_aportes')

# --------------------------
# Gráfico 2: Boxplot
# --------------------------
sns.boxplot(
    # Filtrar registros con monto_aportes menor a 500,000
    # para visualizar mejor la distribución y los valores atípicos.
    data=dataset_onp_202512_activos_mod.loc[
        dataset_onp_202512_activos_mod['monto_aportes'] < 500000
    ],

    # Variable a analizar
    x='monto_aportes',

    # Dibujar el gráfico en la segunda posición (derecha)
    ax=ax[1]
)

# Agregar título al segundo gráfico
ax[1].set_title('Boxplot de monto_aportes')

# Ajustar automáticamente los espacios entre gráficos
plt.tight_layout()

# Mostrar ambos gráficos
plt.show()




# ==========================
# Gráfico de líneas:
# Evolución de nuevos afiliados por periodo
# ==========================

# Crear una figura de 12 pulgadas de ancho y 4 de alto
plt.figure(figsize=(12, 4))

# Crear un gráfico de líneas
sns.lineplot(
    data=df_tmp2,                     # DataFrame que contiene los datos
    x='primer_periodo_datetime',      # Variable del eje X (fecha)
    y='nro_registros'                 # Variable del eje Y (cantidad de registros)
)

# Agregar título al gráfico
plt.title('Cantidad de nuevos afiliados por mes')

# Etiqueta del eje X
plt.xlabel('Periodo')

# Etiqueta del eje Y
plt.ylabel('Número de afiliados')

# Rotar las fechas para mejorar la lectura
plt.xticks(rotation=45)

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()



# ==========================
# Boxplot de edad por tipo de dependencia
# ==========================

# Crear una figura de 8 pulgadas de ancho y 4 de alto
plt.figure(figsize=(8, 4))

# Crear un diagrama de caja (boxplot)
sns.boxplot(
    data=dataset_onp_202512_activos_mod,  # DataFrame que contiene los datos

    # Variable categórica del eje X
    x='tipo_dep_des',

    # Variable numérica del eje Y
    y='edadact'
)

# Agregar título al gráfico
plt.title('Distribución de edades por tipo de dependencia')

# Etiqueta del eje X
plt.xlabel('Tipo de dependencia')

# Etiqueta del eje Y
plt.ylabel('Edad')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()


# ==========================
# Boxplot de remuneración por departamento
# ==========================

# Crear una figura de 10 pulgadas de ancho y 6 de alto
plt.figure(figsize=(10, 6))

# Crear un diagrama de caja (boxplot)
sns.boxplot(
    # Filtrar únicamente los registros cuya remuneración es menor a 10,000
    # para evitar que los valores extremos (outliers) distorsionen el gráfico.
    data=dataset_onp_202512_activos_mod.loc[
        dataset_onp_202512_activos_mod['remuneracion'] < 10000
    ],

    # Variable categórica del eje Y (departamentos)
    y='dpto_des',

    # Variable numérica del eje X (remuneración)
    x='remuneracion'
)

# Agregar título al gráfico
plt.title('Distribución de remuneraciones por departamento')

# Etiqueta del eje X
plt.xlabel('Remuneración')

# Etiqueta del eje Y
plt.ylabel('Departamento')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()



# ==========================
# Gráfico de dispersión (Scatter Plot)
# Relación entre monto de aportes y número de aportes
# ==========================

# Crear una figura de 8 pulgadas de ancho y 5 de alto
plt.figure(figsize=(8, 5))

# Crear un gráfico de dispersión
sns.scatterplot(
    data=dataset_onp_202512_activos_mod,  # DataFrame que contiene los datos

    # Variable numérica del eje X
    x='monto_aportes',

    # Variable numérica del eje Y
    y='nro_aportes'
)

# Agregar título al gráfico
plt.title('Relación entre monto de aportes y número de aportes')

# Etiqueta del eje X
plt.xlabel('Monto de aportes')

# Etiqueta del eje Y
plt.ylabel('Número de aportes')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()



# ==========================
# Boxplot de edad por tipo de dependencia y sexo
# ==========================

# Crear una figura de 10 pulgadas de ancho y 5 de alto
plt.figure(figsize=(10, 5))

# Crear un diagrama de caja (boxplot)
sns.boxplot(
    data=dataset_onp_202512_activos_mod,  # DataFrame que contiene los datos

    # Variable categórica del eje X
    x='tipo_dep_des',

    # Variable numérica del eje Y
    y='edadact',

    # Crear una caja adicional por cada categoría de sexo
    hue='sexo_des'
)

# Agregar título al gráfico
plt.title('Distribución de edades por tipo de dependencia y sexo')

# Etiqueta del eje X
plt.xlabel('Tipo de dependencia')

# Etiqueta del eje Y
plt.ylabel('Edad')

# Mostrar la leyenda
plt.legend(title='Sexo')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()



# ==========================
# Gráfico de dispersión por sexo
# Relación entre monto de aportes y número de aportes
# ==========================

# Crear una figura de 12 pulgadas de ancho y 10 de alto
fig, ax = plt.subplots(figsize=(12, 10))

# Crear un gráfico de dispersión (scatter plot)
sns.scatterplot(
    # Tomar únicamente los primeros 20,000 registros
    # para que el gráfico sea más rápido y legible.
    data=dataset_onp_202512_activos_mod.iloc[:20000],

    # Variable numérica del eje X
    x='monto_aportes',

    # Variable numérica del eje Y
    y='nro_aportes',

    # Colorear los puntos según el sexo
    hue='sexo_des'
)

# Agregar título al gráfico
plt.title('Relación entre monto de aportes y número de aportes por sexo')

# Etiqueta del eje X
plt.xlabel('Monto de aportes')

# Etiqueta del eje Y
plt.ylabel('Número de aportes')

# Ajustar automáticamente los márgenes
plt.tight_layout()

# Mostrar el gráfico
plt.show()