import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
import warnings

warnings.filterwarnings("ignore")

SEED = 42
rng = np.random.default_rng(SEED)

NAVY, BLUE, MAG, GREEN = "#0A2559", "#1A56E8", "#E6115E", "#12B886"
plt.rcParams.update({
    "figure.figsize": (9, 4.2), "figure.dpi": 110,
    "axes.grid": True, "grid.alpha": 0.25,
    "axes.spines.top": False, "axes.spines.right": False, "font.size": 11,
})
pd.set_option("display.width", 140)

# ── URL del dataset ──────────────────────────────────────────────────────
URL = ("https://github.com/josefrodrim/Estad-stica-Descriptiva-E-Inferencial/"
       "blob/main/Taller_7/Data/enaho_taller.csv.gz")


def a_raw(url):
    """GitHub sirve HTML en /blob/. Lo convierte al enlace de descarga directa."""
    if "github.com" in url and "/blob/" in url:
        url = (url.replace("github.com", "raw.githubusercontent.com")
                  .replace("/blob/", "/"))
    return url


def cargar():
    try:
        d = pd.read_csv(a_raw(URL))
        print("Datos cargados desde el repo del curso.")
        return d
    except Exception as e:
        print(f"No se pudo descargar ({type(e).__name__}).")
        print("Sube el archivo enaho_taller.csv.gz con el botón de archivos de Colab,")
        print("o ejecuta: from google.colab import files; files.upload()")
        try:
            return pd.read_csv("enaho_taller.csv.gz")
        except Exception:
            raise SystemExit("Carga el archivo y vuelve a ejecutar esta celda.")


df = cargar()
print(f"\n{len(df):,} hogares · {len(df.columns)} variables · años {sorted(df['anio'].unique())}")


# ── Verificador ──────────────────────────────────────────────────────────
def check(nombre, obtenido, esperado, tol=1e-4):
    if obtenido is None:
        print(f"[ ] {nombre}: todavia no calculaste nada (None)")
        return False
    ok = abs(float(obtenido) - float(esperado)) <= tol
    print(f"{'[OK]' if ok else '[X ]'} {nombre}: obtenido = {float(obtenido):,.4f} | "
          f"esperado = {float(esperado):,.4f}")
    if not ok:
        print("      -> revisa este paso antes de continuar.")
    return ok


def check_bool(nombre, cond, pista=""):
    print(f"{'[OK]' if cond else '[X ]'} {nombre}")
    if not cond and pista:
        print(f"      -> {pista}")
    return bool(cond)


# ── Mediana ponderada: numpy no la trae ──────────────────────────────────
def mediana_ponderada(x, w):
    """Mediana de x ponderada por w, para estimar cuantiles poblacionales."""
    x = np.asarray(x, dtype=float)
    w = np.asarray(w, dtype=float)
    o = np.argsort(x)
    x, w = x[o], w[o]
    return float(np.interp(0.5, np.cumsum(w) / w.sum(), x))


# ── DEMOSTRACIÓN ─────────────────────────────────────────────────────────
d24 = df[df.anio == 2024].copy()
d23 = df[df.anio == 2023].copy()

print(f"2024: {len(d24):,} hogares    2023: {len(d23):,} hogares")
print()
print("Distribución de la muestra 2024 por dominio:")
t = (d24.groupby("dominio_nom")
        .agg(hogares=("pobre", "size"), pobres_muestra=("pobre", "mean"))
        .assign(pobres_muestra=lambda x: (100*x.pobres_muestra).round(1))
        .sort_values("hogares", ascending=False))
print(t.to_string())
print()
print("Un primer intento ingenuo de la tasa de pobreza:")
print(f"  hogares pobres / hogares totales = {100*d24['pobre'].mean():.2f} %")
print()
print("Pero el titular dice 27.6 %. Y ese numero es de PERSONAS, no de hogares,")
print("y esta EXPANDIDO a la poblacion. Esas dos cosas son el bloque 1.")