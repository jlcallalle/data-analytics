# 1. Creación de series y dataframes
# py -m pip install pandas


import pandas as pd

# crear serie a partir de una lista
a = [34, 78, 22, 13]

type(a)
print(type(a))

mi_serie = pd.Series(a)
print(mi_serie)


data = {
    "calorias": [420, 380, 390],
    "duracion": [50, 40, 45]
}
print(data)
print(type(data))

mi_dataframe = pd.DataFrame(data)
print(mi_dataframe)

df_prueba = pd.DataFrame()
df_prueba['edad'] = [12, 20, 14, 18]
df_prueba
print(df_prueba)

df_prueba["peso"] = [56, 62, 74, 58]
df_prueba
print(df_prueba)