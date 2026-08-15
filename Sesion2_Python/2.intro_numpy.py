import numpy as np

# 1) indexing 
# indexing significa acceder a un elemento específico del array, 
arr = np.array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])
print("Listado del array:", arr)
print("Indexing:", arr[0])

# 2) slicing 
# slicing significa acceder a un rango de elementos del array.
# [inicio:fin] -> el inicio es inclusivo y el fin es exclusivo (uno antes)
# slicing es [inicio:fin] y el fin es exclusivo, por lo que no incluye el elemento en la última posicion.

print("Sliced 1 a 5:", arr[1:5])  # Slicing from index 1 to 4, 
print("Sliced 0 a 3:", arr[0:3])  # Slicing from index 0 to 2
print("Sliced 5 a 10:", arr[5:10])  # Slicing from index 5 to 9

# 3) Iterating
# Iterating significa recorrer cada elemento del array,
print("Iterating over the array:")
for i in arr:
    print(i)    



#################### 

"""Ejemplos de indexación, copias y vistas con NumPy."""

import numpy as np


def main():
    """Ejecuta los ejemplos y muestra sus resultados."""
    # 3.4. Array utilizado en los ejemplos
    array_base = np.array(
        [26, 22, 35, 4, 26, 30, 27, 13, 11, 12, 18, 20, 30, 25, 31, 5]
    )

    print("3.4. TRUCOS DE INDEXACIÓN")
    print("Array base:", array_base)

    # 3.4.1. Indexación booleana
    print("\n3.4.1. INDEXACIÓN BOOLEANA")
    print("Elementos mayores que 15:", array_base[array_base > 15])
    print("Elementos iguales a 30:", array_base[array_base == 30])

    # 3.4.2. Indexación mediante posiciones enteras
    print("\n3.4.2. INDEXACIÓN CON ARREGLOS DE ENTEROS")
    indices = [0, 11, 13]
    print(f"Elementos en las posiciones {indices}:", array_base[indices])

    # 3.5. Copia y vista
    print("\n3.5. FUNCIONES Y MÉTODOS")
    x = array_base.copy()  # Copia independiente
    y = array_base.view()  # Vista que comparte los datos

    print("Array base original:", array_base)
    print("Copia x:", x)
    print("Vista y:", y)

    # Al modificar array_base, la copia x no cambia, pero la vista y sí cambia.
    array_base[-1] = 8

    print("\nDespués de ejecutar array_base[-1] = 8:")
    print("Array base modificado:", array_base)
    print("Copia x (no cambia):", x)
    print("Vista y (sí cambia):", y)
    print("Forma del array:", array_base.shape)


if __name__ == "__main__":
    main()