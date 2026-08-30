"""Ejemplos de operaciones matemáticas con NumPy."""

import numpy as np


def main():
    """Ejecuta las operaciones y muestra sus resultados."""
    a = np.array([1, 2, 3, 4])
    b = np.array([5, 6, 7, 8])

    print("3.5.3. OPERACIONES MATEMÁTICAS CON NUMPY")
    print("Arreglo a:", a)
    print("Arreglo b:", b)

    # Suma: ambas formas producen el mismo resultado.
    print("\nSUMA")
    print("np.add(a, b):", np.add(a, b))
    print("a + b:", a + b)

    # Resta: ambas formas producen el mismo resultado.
    print("\nRESTA")
    print("np.subtract(b, a):", np.subtract(b, a))
    print("b - a:", b - a)

    # Multiplicación elemento por elemento.
    print("\nMULTIPLICACIÓN")
    print("np.multiply(a, b):", np.multiply(a, b))

    # División elemento por elemento.
    print("\nDIVISIÓN")
    print("np.divide(b, a):", np.divide(b, a))

    # Funciones exponencial y raíz cuadrada.
    print("\nEXPONENCIAL Y RAÍZ CUADRADA")
    print("np.exp(a):", np.exp(a))
    print("np.sqrt(a):", np.sqrt(a))

    # Potencia al cuadrado elemento por elemento.
    print("\nPOTENCIA")
    print("a ** 2:", a**2)


if __name__ == "__main__":
    main()