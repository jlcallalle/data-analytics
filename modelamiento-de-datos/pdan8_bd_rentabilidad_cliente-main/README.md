Caso propuesto: Banca — Modelo de Rentabilidad por Cliente
1. Contexto del negocio

El banco FinanPerú desea implementar un sistema que le permita analizar la rentabilidad generada por cada uno de sus clientes.

Actualmente, el banco dispone de información distribuida en diferentes sistemas: cuentas bancarias, tarjetas de crédito, préstamos, depósitos, operaciones realizadas por los clientes y cobros de comisiones.

La gerencia necesita responder preguntas como:

¿Cuánto dinero genera cada cliente para el banco?
¿Qué clientes son rentables y cuáles generan pérdidas?
¿Qué productos financieros generan mayor rentabilidad?
¿Qué segmento de clientes genera mayores ingresos?
¿Cuánto obtiene el banco por intereses y comisiones?
¿Cuánto le cuesta al banco mantener determinados productos?
¿Cómo evoluciona la rentabilidad de un cliente a lo largo del tiempo?

Para ello, se solicita diseñar una base de datos que permita centralizar esta información y posteriormente generar indicadores de rentabilidad.

2. Información de los clientes

El banco registra clientes personas naturales y personas jurídicas.

Para cada cliente se desea almacenar:

Código único del cliente.
Tipo de cliente.
Documento de identidad o RUC.
Nombre o razón social.
Fecha de nacimiento o constitución, según corresponda.
Sexo, cuando corresponda.
Estado del cliente.
Fecha de alta como cliente.
Segmento comercial al que pertenece.
Ubicación geográfica.
Nivel de ingresos estimado.
Canal principal utilizado por el cliente.

Un cliente puede cambiar de segmento durante su relación con el banco.

3. Productos financieros

FinanPerú ofrece diferentes productos:

Cuentas de ahorro.
Cuentas corrientes.
Tarjetas de crédito.
Préstamos personales.
Créditos vehiculares.
Créditos hipotecarios.
Depósitos a plazo.
Otros productos financieros.

Cada producto pertenece a una determinada categoría.

Para los productos se necesita registrar información como:

Código del producto.
Nombre.
Categoría.
Tipo.
Estado.
Fecha de lanzamiento.
Tasa de interés referencial.
Moneda.
Características comerciales.

Un mismo producto puede ser contratado por muchos clientes.

4. Contratación de productos

Cuando un cliente adquiere un producto financiero, el banco registra la relación entre el cliente y dicho producto.

Por ejemplo:

El cliente Juan Pérez adquiere una cuenta de ahorros y posteriormente una tarjeta de crédito y un préstamo personal.

Para cada contratación se requiere conocer:

Cliente.
Producto contratado.
Fecha de contratación.
Fecha de cancelación, si corresponde.
Estado.
Canal mediante el cual fue contratado.
Agencia relacionada, cuando corresponda.
Ejecutivo responsable, cuando corresponda.
Condiciones comerciales aplicadas.

Un cliente puede tener más de una contratación del mismo producto a lo largo del tiempo.

5. Cuentas y saldos

Los clientes pueden tener cuentas bancarias asociadas a determinados productos.

El banco necesita conocer los saldos de las cuentas y su evolución.

Para cada cuenta se debe poder identificar:

Número de cuenta.
Cliente o clientes asociados.
Producto.
Moneda.
Fecha de apertura.
Fecha de cierre.
Estado.

Una cuenta puede tener uno o varios titulares.

El banco obtiene información periódica sobre el saldo de las cuentas.

Se requiere conservar el histórico de saldos, de manera que sea posible conocer cuánto dinero tenía una cuenta en una fecha determinada.

6. Tarjetas de crédito

Un cliente puede tener una o varias tarjetas de crédito.

Para cada tarjeta se registra información como:

Número identificador de la tarjeta.
Cliente titular.
Producto asociado.
Fecha de emisión.
Fecha de vencimiento.
Estado.
Línea de crédito.
Moneda.

Las tarjetas generan diferentes tipos de movimientos, tales como:

Compras.
Disposiciones de efectivo.
Pagos.
Devoluciones.
Otros movimientos.

Cada operación debe registrar su fecha, importe y demás información necesaria para su análisis.

7. Préstamos

Los clientes pueden solicitar y obtener préstamos de diferentes tipos.

Para cada préstamo se necesita conocer:

Cliente.
Producto crediticio.
Fecha de desembolso.
Monto desembolsado.
Moneda.
Tasa de interés.
Plazo.
Estado.
Fecha de vencimiento.
Saldo pendiente.

Los préstamos generan pagos periódicos.

Cada pago puede incluir diferentes componentes, por ejemplo:

Capital.
Intereses.
Comisiones.
Penalidades.
Otros conceptos.

El banco necesita conservar el detalle de estos componentes.

8. Transacciones

Los clientes realizan operaciones a través de diferentes canales:

Agencia.
Cajero automático.
Banca móvil.
Banca por Internet.
POS.
Otros canales.

Entre las operaciones pueden encontrarse:

Depósitos.
Retiros.
Transferencias.
Pagos.
Compras.
Transferencias interbancarias.
Pagos de tarjetas.
Otros movimientos.

Cada transacción debe permitir identificar, cuando corresponda:

Cliente involucrado.
Producto o cuenta relacionada.
Fecha y hora.
Tipo de operación.
Canal.
Importe.
Moneda.
Estado de la operación.
9. Ingresos generados para el banco

Desde la perspectiva del banco, los clientes pueden generar diferentes tipos de ingresos.

Por ejemplo:

Ingresos por intereses

Provienen principalmente de:

Préstamos.
Tarjetas de crédito.
Otros productos de crédito.
Ingresos por comisiones

Pueden generarse por:

Mantenimiento de cuenta.
Transferencias.
Retiros.
Tarjetas.
Servicios adicionales.
Otros conceptos.

El banco desea registrar los ingresos generados por sus operaciones y poder relacionarlos con el cliente y producto correspondiente.

10. Costos asociados

No todos los productos generan únicamente ingresos.

El banco también incurre en costos asociados a sus clientes y productos.

Entre ellos pueden encontrarse:

Costos operativos.
Costos de procesamiento.
Costos de transacciones.
Costos asociados a canales.
Costos financieros.
Otros costos asignables.

No necesariamente todos los costos se generan directamente por una transacción específica.

Algunos costos pueden distribuirse posteriormente utilizando criterios definidos por el área financiera.

11. Rentabilidad

El área financiera desea calcular la rentabilidad de cada cliente.

Para ello considera, entre otros conceptos:

Rentabilidad = Ingresos generados − Costos asociados

Los ingresos pueden provenir de intereses, comisiones y otros conceptos.

Los costos pueden estar relacionados directamente con un cliente, producto, operación o período.

El banco desea calcular la rentabilidad:

Por cliente.
Por producto.
Por segmento.
Por canal.
Por período.

Además, necesita comparar la rentabilidad entre diferentes períodos.

12. Información temporal

La gerencia desea analizar la evolución histórica.

Por ejemplo:

El cliente tenía una rentabilidad de S/ 150 en enero, S/ 230 en febrero y S/ 80 en marzo.

Por ello, el modelo debe permitir analizar la información por diferentes períodos:

Día.
Mes.
Trimestre.
Año.

También se desea conocer la evolución de:

Clientes.
Productos contratados.
Saldos.
Transacciones.
Ingresos.
Costos.
Rentabilidad.
13. Segmentación de clientes

El banco clasifica a sus clientes en diferentes segmentos, por ejemplo:

Personas.
Preferente.
Premium.
Empresas pequeñas.
Empresas medianas.
Empresas grandes.

La clasificación puede cambiar con el tiempo debido al comportamiento y características del cliente.

La gerencia desea comparar la rentabilidad de los diferentes segmentos.

14. Requerimientos de análisis

El modelo resultante debe permitir que posteriormente se puedan responder preguntas como:

¿Cuál es la rentabilidad total generada por cada cliente?
¿Cuáles son los 10 clientes más rentables?
¿Cuáles son los 10 clientes menos rentables?
¿Qué productos generan mayor rentabilidad?
¿Qué clientes tienen muchos productos pero baja rentabilidad?
¿Qué segmento genera mayores ingresos?
¿Qué segmento genera mayor rentabilidad?
¿Cuánto ingreso por intereses genera cada cliente?
¿Cuánto ingreso por comisiones genera cada cliente?
¿Cuánto costo genera cada cliente?
¿Cómo evoluciona la rentabilidad de un cliente mes a mes?
¿Qué canal genera mayor cantidad de operaciones?
¿Qué canal genera mayor rentabilidad?
¿Qué productos generan ingresos pero también elevados costos?
¿Qué clientes pasaron de ser rentables a no rentables?
¿Qué clientes incrementaron significativamente su rentabilidad durante el último año?
15. Reglas de negocio iniciales

Los estudiantes deberán considerar, como mínimo, las siguientes reglas:

Un cliente puede contratar uno o varios productos.
Un producto puede ser contratado por muchos clientes.
Un cliente puede tener varias cuentas.
Una cuenta puede tener uno o varios titulares.
Un cliente puede tener varias tarjetas.
Una tarjeta pertenece a un único titular.
Un cliente puede tener varios préstamos.
Un préstamo corresponde a un producto crediticio.
Una operación debe estar asociada a un canal.
Una operación puede generar ingresos para el banco.
Una operación puede generar costos para el banco.
Los ingresos y costos deben poder analizarse por período.
La clasificación de un cliente puede cambiar a lo largo del tiempo.
Los saldos deben conservarse históricamente.
Un cliente puede contratar nuevamente un producto después de haberlo cancelado.
No todas las operaciones generan necesariamente ingresos.
No todos los productos generan necesariamente costos.
Algunos costos pueden ser asignados indirectamente a clientes.
La rentabilidad debe poder analizarse desde diferentes perspectivas.
La información histórica no debe perderse cuando cambien los datos actuales del cliente.
16. Reto para los estudiantes

A partir del caso presentado, los estudiantes deberán desarrollar tres niveles de modelamiento:

Fase 1 — Modelo conceptual

Identificar:

Entidades.
Relaciones.
Cardinalidades.
Atributos principales.
Reglas de negocio.

No se deben considerar todavía detalles propios del motor de base de datos.

Fase 2 — Modelo lógico

Transformar el modelo conceptual considerando:

Entidades convertidas en estructuras lógicas.
Claves primarias.
Claves foráneas.
Relaciones.
Resolución de relaciones muchos a muchos.
Normalización.
Restricciones de integridad.
Fase 3 — Modelo físico

Diseñar la implementación para un SGBD relacional.

Se deberá definir:

Tablas.
Columnas.
Tipos de datos.
PK.
FK.
Restricciones NOT NULL.
UNIQUE.
CHECK.
Índices.
Esquemas.
Otras decisiones necesarias para implementar la solución.
