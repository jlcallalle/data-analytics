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

"""### Los datos con los que vamos a trabajar

No vamos a descargar nada: los vamos a **inventar**. Y eso no es hacer trampa, es una técnica.
Vamos a simular una semana de una web:

| Columna | Qué guarda |
|---|---|
| `ingreso` | Cuánto gana al mes cada usuario, en soles |
| `convirtio` | 1 si el usuario compró, 0 si no compró |
"""

N = 567                        # N = cuántos usuarios vamos a simular
# ── Columna 1: el ingreso ────────────────────────────────────────────────────
# "lognormal" es una forma de generar números torcidos hacia la derecha:
# muchos valores medianos y unos pocos altísimos. Así se comporta casi todo el dinero del mundo.
# mean y sigma son los controles de esa forma; no hace falta entenderlos hoy.

#ingreso es un vector de N números al azar, con distribución log-normal, media log(2750) y desviación estándar 0.62
ingreso = rng.lognormal(mean=np.log(2750), sigma=0.62, size=N).round(0)

# ── Columna 2: ¿compró o no? ─────────────────────────────────────────────────
# Esto es una Bernoulli: cada usuario compra (1) o no compra (0).
P_VERDADERO = 0.12             # el 12% compra. NOSOTROS lo definimos, así que lo sabemos.
convirtio = rng.binomial(1, P_VERDADERO, size=N)   # el "1" significa: un solo intento por persona

# ── Armamos la tabla ─────────────────────────────────────────────────────────
# Un DataFrame es una tabla, igual que una hoja de Excel. Se define con { "nombre": datos }
usuarios = pd.DataFrame({"ingreso": ingreso, "convirtio": convirtio})

usuarios.head()   
print(usuarios.head())

# describe() es un método de los DataFrames que devuelve estadísticas descriptivas de cada columna
print(usuarios.describe().T)  # .T = transpuesta, para que se vea más bonito


"""
## 02 · El promedio miente
> **Analogía — el río de 1.20 m.** Un río con profundidad promedio de 1.20 m es un dato correcto,
> y te puedes ahogar cruzándolo: el promedio no te avisa del pozo de 3 metros que hay en el medio.
"""

# x es un vector que contiene solo la columna "ingreso" de la tabla usuarios

x = usuarios["ingreso"]        # los corchetes con un nombre adentro = "dame esta columna"

# Cada línea calcula una cosa y la guarda en una variable
media   = x.mean()                                  # el promedio (x̄)
mediana = x.median()                                # el valor del medio
sd      = x.std(ddof=1)                             # la desviación estándar (s)
#                ^^^^^^ ddof=1 le dice: divide entre n−1, no entre n.
#                       Es exactamente el "¿por qué entre 4 y no entre 5?" de la clase.
cv      = sd / media                                # coeficiente de variación
iqr     = x.quantile(0.75) - x.quantile(0.25)       # rango entre cuartiles

# Mostramos todo. Lo de {media:>9,.0f} solo controla la alineación y los decimales.
print(f"Promedio (x̄)        : S/ {media:>9,.0f}")
print(f"Mediana             : S/ {mediana:>9,.0f}")
print(f"Desviación est. (s) : S/ {sd:>9,.0f}")
print(f"Coef. de variación  : {cv:>12.2f}")
print(f"Rango entre cuartiles: S/ {iqr:>8,.0f}")
print()
print(f"El promedio es {100*(media/mediana - 1):.1f}% más alto que la mediana.")