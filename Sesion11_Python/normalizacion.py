# =====================================
# 3. Tokenización
# =====================================

import nltk
from nltk.tokenize import word_tokenize, sent_tokenize

# Descargar recursos (solo la primera vez)
nltk.download("punkt")
nltk.download("punkt_tab")

# =====================================
# Tokenización por palabras
# =====================================

texto = dataset_pronabec.loc[0, "TEXTO_PROCESADO"]

tokens_palabras = word_tokenize(texto, language="spanish")

print("=" * 60)
print("Tokenización por palabras")
print("=" * 60)
print(tokens_palabras)

# =====================================
# Tokenización por oraciones
# =====================================

tokens_oraciones = sent_tokenize(texto, language="spanish")

print("\n" + "=" * 60)
print("Tokenización por oraciones")
print("=" * 60)
print(tokens_oraciones)




# =====================================
# Normalización - Stemming
# =====================================

from nltk.stem.snowball import SnowballStemmer

# Mostrar los idiomas disponibles
print("=" * 60)
print("Idiomas disponibles para SnowballStemmer")
print("=" * 60)
print(", ".join(SnowballStemmer.languages))

# Crear el stemmer para español
stemmer = SnowballStemmer("spanish")

# Ejemplos
print("\n" + "=" * 60)
print("Ejemplos de Stemming")
print("=" * 60)

print(f"gatos     -> {stemmer.stem('gatos')}")
print(f"estudioso -> {stemmer.stem('estudioso')}")
print(f"estudiar  -> {stemmer.stem('estudiar')}")