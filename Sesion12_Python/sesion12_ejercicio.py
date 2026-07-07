# =====================================
# dataset_pronabec = pd.read_csv('/content/drive/MyDrive/data_curso_python/notas-de-prensa-del-pronabec.csv')
# =====================================
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


print("=" * 60)
print("Primeras 5 filas NUEVO  DATASET TEXTO_SIN_STOPWORDS")
print("=" * 60)
print(dataset_pronabec.head())





# =====================================
# Vectorización - Bag of Words  06/07/2026 
# =====================================

# CountVectorizer es una clase de la biblioteca scikit-learn que se utiliza para convertir una colección de documentos de texto en una matriz de características numéricas, conocida como matriz Bag of Words (BoW). Esta técnica es fundamental en el procesamiento del lenguaje natural (NLP) y en la minería de texto, ya que permite representar el texto de manera que los algoritmos de aprendizaje automático puedan trabajar con él.
from sklearn.feature_extraction.text import CountVectorizer

# Crear el vectorizador
vectorizer = CountVectorizer()

# Corpus (texto ya preprocesado y sin stopwords)
corpus = dataset_pronabec["TEXTO_SIN_STOPWORDS"]

# Ajustar el vocabulario y transformar el texto
X = vectorizer.fit_transform(corpus)

print("=" * 60)
print("Matriz Bag of Words")
print("=" * 60)
print(X)

print("\nCantidad de documentos:", X.shape[0])
print("Cantidad de palabras (vocabulario):", X.shape[1])

# =====================================
# Vocabulario generado
# =====================================

print("\n" + "=" * 60)
print("Primeras 20 palabras del vocabulario")
print("=" * 60)

vocabulario = vectorizer.get_feature_names_out()

print(vocabulario[:20])

# =====================================
# Convertir la matriz a DataFrame
# =====================================

matriz_bow = pd.DataFrame(
    X.toarray(),
    columns=vocabulario
)

print("\n" + "=" * 60)
print("Primeras 5 filas de la matriz Bag of Words")
print("=" * 60)

print(matriz_bow.head())



# =====================================
# Word Embeddings - Word2Vec   06/07/2026
# =====================================

from gensim.models import Word2Vec

# Tokenizar el texto
tokenized_text = [
    texto.split()
    for texto in dataset_pronabec["TEXTO_SIN_STOPWORDS"]
]

# Entrenar el modelo Word2Vec
modelo_w2v = Word2Vec(
    sentences=tokenized_text,
    vector_size=100,
    window=5,
    min_count=1,
    workers=4,
    sg=0  # 0 = CBOW | 1 = Skip-Gram
)

print("=" * 60)
print("Modelo Word2Vec entrenado")
print("=" * 60)

print("Cantidad de palabras:", len(modelo_w2v.wv))

# =====================================
# Obtener el vector de una palabra
# =====================================

palabra = "beca"

if palabra in modelo_w2v.wv:
    vector = modelo_w2v.wv[palabra]

    print("\n" + "=" * 60)
    print(f"Vector de la palabra '{palabra}'")
    print("=" * 60)

    print(vector)
else:
    print(f"La palabra '{palabra}' no existe en el vocabulario.")

# =====================================
# Palabras más similares
# =====================================

print("\n" + "=" * 60)
print("Palabras similares a 'beca'")
print("=" * 60)

print(modelo_w2v.wv.most_similar("beca", topn=10))

# =====================================
# Similitud entre dos palabras
# =====================================

print("\n" + "=" * 60)
print("Similitud entre palabras")
print("=" * 60)

similitud = modelo_w2v.wv.similarity("beca", "pronabec")

print(f"Similitud entre 'beca' y 'pronabec': {similitud:.4f}")

# =====================================
# Tamaño del vocabulario
# =====================================

print("\n" + "=" * 60)
print("Primeras 20 palabras del vocabulario")
print("=" * 60)

print(modelo_w2v.wv.index_to_key[:20])






# =====================================
# Modelos de Lenguaje - N-Gramas  06/07/2026
# =====================================

import nltk
from nltk.util import trigrams
from collections import defaultdict

# Descargar recursos (solo la primera vez)
nltk.download("punkt")

# =====================================
# Preparar el corpus
# =====================================

corpus = dataset_pronabec["TEXTO_SIN_STOPWORDS"]

# Tokenizar cada documento
corpus_tokenizado = [
    nltk.word_tokenize(texto, language="spanish")
    for texto in corpus
]

# =====================================
# Construcción del modelo de trigramas
# =====================================

modelo = defaultdict(lambda: defaultdict(int))

for documento in corpus_tokenizado:
    for w1, w2, w3 in trigrams(
        documento,
        pad_left=True,
        pad_right=True
    ):
        modelo[(w1, w2)][w3] += 1

# =====================================
# Convertir frecuencias en probabilidades
# =====================================

for contexto in modelo:

    total = float(sum(modelo[contexto].values()))

    for palabra in modelo[contexto]:
        modelo[contexto][palabra] /= total

print("=" * 60)
print("Modelo de lenguaje creado")
print("=" * 60)

print("Cantidad de contextos:", len(modelo))