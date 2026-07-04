# =====================================
# Importación de datos
# =====================================

import pandas as pd

# Ruta del dataset
RUTA_DATASET = "dataset/notas-de-prensa-del-pronabec.csv"

# Cargar dataset
dataset_pronabec = pd.read_csv(RUTA_DATASET)

# =====================================
# Exploración inicial
# =====================================

print("=" * 60)
print("Primeras 5 filas")
print("=" * 60)
print(dataset_pronabec.head())

print("\n" + "=" * 60)
print("Información del dataset")
print("=" * 60)
print(dataset_pronabec.info())

# =====================================
# Limpieza de datos
# =====================================

# Eliminar registros donde el resumen sea nulo
dataset_pronabec.dropna(subset=["SUMARIO"], inplace=True)

# Crear columna TEXTO
dataset_pronabec["TEXTO"] = (
    dataset_pronabec["TITULO"] + ". " + dataset_pronabec["SUMARIO"]
)

# Convertir a texto
dataset_pronabec["TEXTO"] = dataset_pronabec["TEXTO"].astype(str)

print("\nCantidad de registros:", len(dataset_pronabec))

print("\nEjemplo de TEXTO:")
print(dataset_pronabec["TEXTO"].head())

print("\nEjemplo de .TEXTO[0]")
print(dataset_pronabec.TEXTO[0])


# =====================================
# Preprocesamiento de texto
# =====================================

import re

def procesamiento_texto(texto):
    texto = str(texto)
    texto = texto.lower()

    # Eliminar guiones
    texto = re.sub(r'[-]', '', texto)

    # Reemplazar vocales con tilde
    texto = re.sub(r'á', 'a', texto)
    texto = re.sub(r'é', 'e', texto)
    texto = re.sub(r'í', 'i', texto)
    texto = re.sub(r'ó', 'o', texto)
    texto = re.sub(r'ú', 'u', texto)

    # Reemplazar diéresis
    texto = re.sub(r'ü', 'u', texto)

    return texto

# Aplicar procesamiento
dataset_pronabec["TEXTO_PROCESADO"] = (
    dataset_pronabec["TEXTO"].apply(procesamiento_texto)
)

# =====================================
# Visualización
# =====================================

print("=" * 60)
print("Texto original")
print("=" * 60)
print(dataset_pronabec["TEXTO"].iloc[0])

print("\n" + "=" * 60)
print("Texto procesado")
print("=" * 60)
print(dataset_pronabec["TEXTO_PROCESADO"].iloc[0])




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


# =====================================
# Normalización - Lematización
# =====================================

import stanza

# Descargar el modelo de español (solo la primera vez)
stanza.download("es")

# Crear el lematizador
lematizador = stanza.Pipeline(
    lang="es",
    processors="tokenize,lemma"
)

# Texto de ejemplo
texto = lematizador(
    "gatos estudioso estudiar estudiosa estudiosos estudia"
)

print("=" * 60)
print("Ejemplo de lematización")
print("=" * 60)

for sentencia in texto.sentences:
    for palabra in sentencia.words:
        print(
            f"Palabra: {palabra.text:<12} -> Lema: {palabra.lemma}"
        )


# =====================================
# POS Tagging
# =====================================

print("\n" + "=" * 60)
print("POS Tagging")
print("=" * 60)

# Crear el pipeline para POS Tagging
pos_tagger = stanza.Pipeline(
    lang="es",
    processors="tokenize,pos"
)

# Analizar el primer texto del dataset
texto = pos_tagger(dataset_pronabec.loc[0, "TEXTO_PROCESADO"])

# Mostrar palabra y categoría gramatical
for sentencia in texto.sentences:
    for palabra in sentencia.words:
        print(
            f"Palabra: {palabra.text:<20} POS: {palabra.upos}"
        )

# =====================================
# Eliminación de Stopwords
# =====================================

import nltk
from nltk.corpus import stopwords

# Descargar stopwords (solo la primera vez)
nltk.download("stopwords")

# Lista de stopwords en español
stopwords_es = stopwords.words("spanish")

print("\n" + "=" * 60)
print("Primeras 10 stopwords")
print("=" * 60)
print(stopwords_es[:10])

print("\n" + "=" * 60)
print("Palabras sin stopwords")
print("=" * 60)

for sentencia in texto.sentences:
    for palabra in sentencia.words:
        if palabra.text.lower() not in stopwords_es:
            print(
                f"Palabra: {palabra.text:<20} POS: {palabra.upos}"
            )


# =====================================
# Guardar palabras sin stopwords
# =====================================

palabras_filtradas = []

for sentencia in texto.sentences:
    for palabra in sentencia.words:
        if palabra.text.lower() not in stopwords_es:
            palabras_filtradas.append(palabra.text)

print("\nPalabras filtradas:")
print(palabras_filtradas)


# =====================================
# Función para eliminar stopwords
# =====================================

def eliminar_stopwords(texto):
    palabras = texto.split()

    palabras_filtradas = [
        palabra
        for palabra in palabras
        if palabra.lower() not in stopwords_es
    ]

    return " ".join(palabras_filtradas)

# Crear nueva columna
dataset_pronabec["TEXTO_SIN_STOPWORDS"] = (
    dataset_pronabec["TEXTO_PROCESADO"].apply(eliminar_stopwords)
)

print("\n" + "=" * 60)
print("Texto sin Stopwords")
print("=" * 60)
print(dataset_pronabec.loc[0, "TEXTO_SIN_STOPWORDS"])