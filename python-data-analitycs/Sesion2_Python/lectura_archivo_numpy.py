import numpy as np

pollutant_data = np.genfromtxt(
    r"Recursos\city_day.csv",
    delimiter=",",
    usecols=range(2, 9),
    filling_values=np.nan
)

print("Dimensiones:", pollutant_data.shape)
print("Columna de índice 2:")
print(pollutant_data[:, 2])