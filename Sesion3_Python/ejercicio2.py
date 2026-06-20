""" 
print("Hola Jorge")

edad = 34
edad
print("Mi edad es:", edad)
type(edad)
 """

#numpy es una biblioteca de Python que se utiliza para trabajar con arreglos y matrices multidimensionales. Proporciona funciones y herramientas para realizar operaciones matemáticas y estadísticas de manera eficiente.

import numpy as np

arr = np.array([1, 2, 3, 4, 5])
print(arr)

mi_array = np.array([10, 20, 30, 40])
print(mi_array) # Imprime el array completo

#3.1 Indexing
print(mi_array[0])  # Imprime el primer elemento del array

#3.2 Slicing




#copia es nuevo array con los mismos datos
# si hago modificacion en array base, no se modifica la copia
# en la vista, si hago modificacion en array base, se modifica la vista

np.zeros(8) # Crea un array de ceros con 5 elementos
print(np.zeros(8))
print(np.zeros((5, 3))) # Crea un array de ceros con 5 filas y 3 



print(np.zeros(5)) # Crea un array de ceros con 5 elementos
print(np.ones(5))  # Crea un array de unos con 5 elementos 
print(np.full(5, 7)) # Crea un array lleno de 7 con 5 elementos

np.ones(3)
np.ones((2,2,1))
np.full(4, 30)
np.full((2,2), 30)
np.linspace(12, 18)
np.linspace(12, 18, 10)
print(np.linspace(12, 18, 10))

#Matemáticas con arrays
a = np.array([1, 2, 3, 4])
b = np.array([5, 6, 7, 8])

print(a + b)  # Suma elemento a elemento

# Funciones estatísticas
array_base = np.array([26, 22, 35, 4, 26, 30, 27, 13, 11, 12, 18, 20, 30, 25, 31, 5])
array_base[(array_base > 15)]
array_base[(array_base == 30)]
print(array_base[(array_base > 15)])
print(array_base[(array_base == 30)])

np.mean(array_base)

#De indexacion y seleccion de datos
np.where(array_base > 20)
print(np.where(array_base > 20))

# Generacion numeros aleatorios

array_aleatorio = np.random.rand(10)
print(array_aleatorio)

np.random.binomial(n=10, p=0.5, size=100)
print(np.random.binomial(n=10, p=0.5, size=100))

np.random.normal(loc=1, scale=2, size=(100))
print(np.random.normal(loc=1, scale=2, size=(100)))

# py -m pip install matplotlib
import matplotlib.pyplot as plt
plt.plot(np.random.rand(250))
plt.show()

n = 10 # número de trials
data = np.random.binomial(n=n, p=0.5, size=500)
plt.hist(data, bins=np.arange(-0.5, n + 1.5, 1), density=True, edgecolor='black')
plt.xlabel('Número de éxitos')
plt.ylabel('Frecuencia')
plt.title('Distribución Binomial (n=10, p=0.5)')
plt.show()