# =====================================
# Sesión 10 - Métodos de selección de variables
# =====================================

import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

from sklearn.feature_selection import VarianceThreshold, RFE
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import MinMaxScaler
from sklearn.datasets import load_digits


# =====================================
# Importación del dataset
# =====================================

dataset_onp_202512 = pd.read_csv(
    'dataset/Afiliados_SNP_Diciembre2025.csv',
    sep=',',
    low_memory=False,
    on_bad_lines='skip'
)


# =====================================
# 1. Correlación
# =====================================

print("\n===================================")
print("1. CORRELACIÓN")
print("===================================")

correlacion = (
    dataset_onp_202512[
        ['edadact', 'aporte', 'remuneracion', 'nro_aportes', 'monto_aportes']
    ]
    .corr()
    .round(2)
)

print(correlacion)

plt.figure(figsize=(8,6))
sns.heatmap(
    correlacion,
    annot=True,
    cmap='coolwarm',
    vmin=-1,
    vmax=1
)

plt.title("Matriz de Correlación")
plt.show()


# =====================================
# 2. Variance Threshold
# =====================================

print("\n===================================")
print("2. VARIANCE THRESHOLD")
print("===================================")

selector = VarianceThreshold(threshold=0.5e-04)

dataset_numerico = dataset_onp_202512.select_dtypes(include='number')

selector.fit(dataset_numerico)

print("\nVariables seleccionadas:")

print(
    dataset_numerico.columns[
        selector.get_support()
    ].tolist()
)


print("\nVariable 'aportante'")
print(dataset_onp_202512['aportante'].value_counts())


#tenian hipotesis que la variable si era influenciada por la variable aportante, pero al hacer el analisis de correlacion y variance threshold se puede observar que no tiene una gran influencia en las demas variables, por lo que se decide eliminarla del dataset.

# =====================================
# 3. RFE - Recursive Feature Elimination
# =====================================

from sklearn.feature_selection import RFE
from sklearn.linear_model import LogisticRegression
from sklearn.preprocessing import MinMaxScaler

print("\n===================================")
print("3. RFE - RECURSIVE FEATURE ELIMINATION")
print("===================================")

# Dataset de ejemplo usado por el profesor
from sklearn.datasets import load_digits

digits = load_digits()

X = digits.images.reshape((len(digits.images), -1))
y = digits.target

scaler = MinMaxScaler()
X_scaled = scaler.fit_transform(X)

estimator = LogisticRegression(max_iter=5000)

selector = RFE(
    estimator=estimator,
    n_features_to_select=5,
    step=1
)

selector = selector.fit(X_scaled, y)

ranking = selector.ranking_.reshape(digits.images[0].shape)

plt.figure(figsize=(8, 6))
plt.matshow(ranking, cmap=plt.cm.Blues, fignum=1)

for i in range(ranking.shape[0]):
    for j in range(ranking.shape[1]):
        plt.text(
            j,
            i,
            str(ranking[i, j]),
            ha="center",
            va="center",
            color="black"
        )

plt.colorbar()
plt.title("Ranking of pixels with RFE\n(Logistic Regression)")
plt.show()