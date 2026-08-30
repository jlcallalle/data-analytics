# Variables
edad = 35
temperatura = 18.2
mensaje = "Hola a todos, bienvenidos"
lista_alumnos = ["Luis", "Ana", "Maria"]

# Imprimir valores
print("Edad:", edad)
print("Temperatura:", temperatura)
print("Mensaje:", mensaje)
print("Lista de alumnos:", lista_alumnos)

# Imprimir tipos de datos
print("\nTipos de datos:")
print("Tipo de edad:", type(edad))
print("Tipo de temperatura:", type(temperatura))
print("Tipo de mensaje:", type(mensaje))
print("Tipo de lista_alumnos:", type(lista_alumnos))

# Imprimir cada alumno
print("\nAlumnos:")
for alumno in lista_alumnos:
    print(alumno)


###################################


"""Ejemplos básicos de operadores en Python."""


def main():
    """Ejecuta y muestra los ejemplos de operadores."""
    x = 28
    y = 10

    print("2. OPERADORES EN PYTHON")
    print(f"Valores utilizados: x = {x}, y = {y}")

    # 2.1. Operadores aritméticos
    print("\n2.1. OPERADORES ARITMÉTICOS")
    print(f"Suma: {x} + {y} = {x + y}")
    print(f"Resta: {x} - {y} = {x - y}")
    print(f"División: {x} / {y} = {x / y}")
    print(f"Potencia: {x} ** 2 = {x ** 2}")

    # 2.2. Operadores de comparación
    print("\n2.2. OPERADORES DE COMPARACIÓN")
    print(f"¿{x} es mayor que {y}? {x > y}")
    print(f"¿{x} es menor que {y}? {x < y}")
    print(f"¿{x} es igual a {y}? {x == y}")
    print(f"Tipo del resultado de x == y: {type(x == y).__name__}")

    # 2.3. Operadores lógicos
    print("\n2.3. OPERADORES LÓGICOS")
    print(f"(x > y) and (x > 20): {(x > y) and (x > 20)}")
    print(f"(x > y) and (x < 25): {(x > y) and (x < 25)}")
    print(f"(x > y) or (x < 25): {(x > y) or (x < 25)}")


if __name__ == "__main__":
    main()