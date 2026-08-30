# 1. Creación de series y dataframes
# py -m pip install pandas


import pandas as pd

# crear serie a partir de una lista
a = [34, 78, 22, 13]

type(a)
print(type(a))

# pd.Series es un objeto de tipo Series, propio de la librería pandas,
# que es una estructura de datos unidimensional que puede contener cualquier tipo de datos (enteros, cadenas, números de punto flotante, objetos de Python, etc.)
mi_serie = pd.Series(a)
""" mi_serie = pd.Series(a, index=["a", "b", "c", "d"]) """
print(mi_serie)
print('tipo de dato: ', type(mi_serie))


# Este es un diccionario de listas, que es una estructura de datos que permite almacenar pares de clave-valor, donde cada clave está asociada a una lista de valores.

# Apartir de un diccionario, se puede crear un DataFrame, que es una estructura de datos bidimensional que se asemeja a una tabla, donde cada columna puede tener un tipo de dato diferente y cada fila representa una observación o registro.


data = {
    "calorias": [420, 380, 390],
    "duracion": [50, 40, 45]
}
print(data)
print(type(data))


#pd.DataFrame es un objeto de tipo DataFrame, propio de la librería pandas, que es una estructura de datos bidimensional que puede contener diferentes tipos de datos en cada columna y permite realizar operaciones de análisis y manipulación de datos.

mi_dataframe = pd.DataFrame(data)

print("Mi dataframe con Numoy: ") 
print(mi_dataframe)


df_prueba = pd.DataFrame() #este es un DataFrame vacío

# Edad, es una columna que contiene la edad de las personas en años, y se representa como una lista de enteros.
df_prueba['edad'] = [12, 20, 14, 18]
df_prueba
print(df_prueba)

df_prueba["peso"] = [56, 62, 74, 58]
df_prueba
print(df_prueba)
print('tipo de dato: ', type(df_prueba))

# DataFrame es una estructura de datos bidimensional que se asemeja a una tabla, donde cada columna puede tener un tipo de dato diferente y cada fila representa una observación o registro. En este caso, el DataFrame df_prueba tiene dos columnas: "edad" y "peso", que contienen información sobre la edad y el peso de cuatro personas.

# Es más asociado a una tabla de Excel, VEANLO COMO UNA TABLA, CON COLUMNAS Y FILAS, DONDE CADA COLUMNA REPRESENTA UNA VARIABLE Y CADA FILA REPRESENTA UNA OBSERVACIÓN.