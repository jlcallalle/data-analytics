# "import X as Y" significa: trae la librería X y de ahora en adelante le digo Y (para escribir menos)
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats          # "from A import B" = de la caja A saca solo la herramienta B

# ── La semilla ────────────────────────────────────────────────────────────────
# Vamos a generar números al azar. Si no fijamos una "semilla", cada vez que ejecutes
# esto obtendrás números distintos y tus resultados no coincidirán con los míos.
# La semilla es como decirle a la computadora: "usa SIEMPRE este mismo azar".
SEED = 42                                  # 42 es una convención, podría ser cualquier número
rng = np.random.default_rng(SEED)          # rng = generador de números al azar ("random number generator")

# ── Estilo de los gráficos (puramente cosmético, no afecta los cálculos) ──────
plt.rcParams.update({
    "figure.figsize": (9, 4.5),            # ancho y alto de cada gráfico, en pulgadas
    "axes.grid": True,                     # dibuja la cuadrícula de fondo
    "grid.alpha": 0.25,                    # qué tan tenue es esa cuadrícula (0 = invisible, 1 = sólida)
    "axes.spines.top": False,              # quita el borde de arriba
    "axes.spines.right": False,            # quita el borde de la derecha
    "font.size": 11,
})

# Nuestros tres colores, guardados en variables para no repetir los códigos
AZUL, ROSA, NAVY = "#1A56E8", "#E6115E", "#0A2559"

# print() sirve para mostrar algo en pantalla
print("Todo listo. Versión de numpy:", np.__version__)