"""Gráficos de números aleatorios con NumPy y Matplotlib."""

import matplotlib.pyplot as plt
import numpy as np


def grafico_uniforme():
    """Grafica 250 valores aleatorios uniformes entre 0 y 1."""
    datos = np.random.rand(250)

    plt.figure(figsize=(9, 5))
    plt.plot(datos, color="tab:blue", linewidth=1.3)
    plt.title("250 números aleatorios uniformes")
    plt.xlabel("Posición")
    plt.ylabel("Valor")
    plt.grid(alpha=0.3)
    plt.tight_layout()
    plt.show()


def histograma_binomial():
    """Grafica una muestra de una distribución binomial."""
    n = 10  # Número de intentos
    p = 0.5  # Probabilidad de éxito
    datos = np.random.binomial(n=n, p=p, size=500)

    plt.figure(figsize=(9, 5))
    plt.hist(
        datos,
        bins=np.arange(-0.5, n + 1.5, 1),
        density=True,
        edgecolor="black",
        color="tab:blue",
    )
    plt.title("Distribución binomial: n=10, p=0.5")
    plt.xlabel("Número de éxitos")
    plt.ylabel("Frecuencia relativa")
    plt.xticks(range(n + 1))
    plt.grid(axis="y", alpha=0.3)
    plt.tight_layout()
    plt.show()


def main():
    """Genera y muestra ambos gráficos."""
    np.random.seed(42)
    grafico_uniforme()
    histograma_binomial()


if __name__ == "__main__":
    main()