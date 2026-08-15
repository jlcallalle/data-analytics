"""Ejemplos de generación de números aleatorios con NumPy."""

import numpy as np


def main():
    """Genera números aleatorios de distintas distribuciones."""
    # La semilla permite obtener los mismos resultados en cada ejecución.
    np.random.seed(42)

    print("3.6. GENERACIÓN DE NÚMEROS ALEATORIOS")

    # Diez números decimales con distribución uniforme entre 0 y 1.
    array_aleatorio = np.random.rand(10)
    print("\n10 números uniformes entre 0 y 1:")
    print(array_aleatorio)

    # Cien resultados de una distribución binomial.
    # Cada resultado representa el número de éxitos en 10 intentos,
    # con una probabilidad de éxito de 0.5.
    array_binomial = np.random.binomial(n=10, p=0.5, size=100)
    print("\n100 números con distribución binomial:")
    print(array_binomial)

    # Cien números de una distribución normal con media 1
    # y desviación estándar 2.
    array_normal = np.random.normal(loc=1, scale=2, size=100)
    print("\n100 números con distribución normal:")
    print(array_normal)

    # Resumen para comprobar las dimensiones.
    print("\nDIMENSIONES")
    print("Uniforme:", array_aleatorio.shape)
    print("Binomial:", array_binomial.shape)
    print("Normal:", array_normal.shape)


if __name__ == "__main__":
    main()