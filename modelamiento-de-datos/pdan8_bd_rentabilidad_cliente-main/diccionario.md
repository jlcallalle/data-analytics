# Diccionario de Datos

## Base de datos: `pdan_8_rentabilidad_cliente`

**Versión del documento:** 1.0
**Estado:** Borrador estructural
**Motor:** Microsoft SQL Server
**Dominio funcional:** Rentabilidad de clientes
**Clasificación:** Por determinar según los datos reales
**Fecha de actualización:** 2026-10-14

---

# 1. Objetivo y alcance

## 1.1 Objetivo

Documentar integralmente la estructura física y lógica de la base de datos `pdan_8_rentabilidad_cliente`, incluyendo tablas, columnas, relaciones, restricciones, reglas de negocio, dependencias técnicas, controles de calidad y criterios de mantenimiento.

## 1.2 Alcance

El diccionario comprende:

- Objetos de base de datos.
- Tablas y columnas.
- Claves primarias y foráneas.
- Restricciones de integridad.
- Índices y mecanismos de optimización.
- Reglas de negocio y definiciones métricas.
- Funciones, procedimientos almacenados, vistas y triggers, cuando existan.
- Linaje de datos.
- Controles de calidad.
- Clasificación de información y consideraciones de seguridad.
- Historial de cambios del modelo.

## 1.3 Convenciones

| Elemento      | Convención                                     |
| ------------- | ---------------------------------------------- |
| Nombre físico | Nombre exacto del objeto en SQL Server.        |
| Nombre lógico | Nombre funcional comprensible para el negocio. |
| PK            | Clave primaria.                                |
| FK            | Clave foránea.                                 |
| UK            | Restricción de unicidad.                       |
| CK            | Restricción CHECK.                             |
| DF            | Restricción DEFAULT.                           |
| IDENTITY      | Generación automática de valores numéricos.    |
| NULL          | Ausencia de valor permitido.                   |
| N/A           | No aplica.                                     |
| Por confirmar | Información pendiente de validación.           |

---

# 2. Catálogo de tablas

Una fila por cada tabla física.

| Esquema | Tabla               | Nombre lógico           | Descripción                                          | Tipo de entidad | Granularidad                                              | Tabla crítica | Observaciones |
| ------- | ------------------- | ----------------------- | ---------------------------------------------------- | --------------- | --------------------------------------------------------- | ------------- | ------------- |
| dbo     | segmentos           | Segmentos de clientes   | Clasificación comercial de clientes.                 | Maestra         | Un registro por segmento.                                 | Por confirmar |               |
| dbo     | canales             | Canales                 | Catálogo de canales de operación.                    | Maestra         | Un registro por canal.                                    | Por confirmar |               |
| dbo     | categoria_productos | Categorías de productos | Clasificación de productos.                          | Maestra         | Un registro por categoría.                                | Por confirmar |               |
| dbo     | productos           | Productos               | Catálogo de productos financieros.                   | Maestra         | Un registro por producto.                                 | Por confirmar |               |
| dbo     | clientes            | Clientes                | Entidad central de clientes.                         | Maestra         | Un registro por cliente.                                  | Por confirmar |               |
| dbo     | personas_juridicas  | Personas jurídicas      | Datos complementarios de clientes jurídicos.         | Complementaria  | Un registro por persona jurídica, sujeto a restricciones. | Por confirmar |               |
| dbo     | personas_naturales  | Personas naturales      | Datos complementarios de clientes naturales.         | Complementaria  | Un registro por persona natural, sujeto a restricciones.  | Por confirmar |               |
| dbo     | periodos            | Periodos                | Catálogo de periodos mensuales.                      | Maestra         | Un registro por mes y año.                                | Por confirmar |               |
| dbo     | contrataciones      | Contrataciones          | Productos contratados por clientes.                  | Transaccional   | Un registro por contratación.                             | Por confirmar |               |
| dbo     | operaciones         | Operaciones             | Movimientos realizados por clientes.                 | Transaccional   | Un registro por operación.                                | Por confirmar |               |
| dbo     | costos              | Costos                  | Costos asociados a clientes, productos y periodos.   | Transaccional   | Un registro por registro de costo.                        | Por confirmar |               |
| dbo     | ingresos            | Ingresos                | Ingresos asociados a clientes, productos y periodos. | Transaccional   | Un registro por registro de ingreso.                      | Por confirmar |               |

## 2.1 Ficha detallada por tabla

Repetir esta sección para cada tabla.

### Tabla: `[dbo].[nombre_tabla]`

**Nombre lógico:** Por documentar
**Descripción funcional:** Por documentar
**Objetivo:** Por documentar
**Dominio:** Por documentar
**Tipo de entidad:** Maestra / transaccional / catálogo / complementaria
**Granularidad:** Qué representa exactamente una fila.
**Sistema de origen:** Por confirmar
**Frecuencia de actualización:** Por confirmar
**Responsable funcional:** Por confirmar
**Responsable técnico:** Por confirmar
**Clasificación de información:** Por confirmar
**Retención de datos:** Por confirmar

#### Características técnicas

| Atributo                     | Valor                         |
| ---------------------------- | ----------------------------- |
| Esquema                      | `dbo` (validar en SQL Server) |
| Nombre físico                | Por documentar                |
| Filas estimadas              | Por medir                     |
| Fecha de creación            | Por consultar                 |
| Fecha de última modificación | Por consultar                 |
| Índices                      | Por documentar                |
| Compresión                   | Por confirmar                 |
| Particionamiento             | Por confirmar                 |
| Dependencias                 | Por documentar                |

#### Consideraciones funcionales

- ¿Qué representa cada registro?
- ¿Cuándo se crea un registro?
- ¿Cuándo se actualiza?
- ¿Se permite eliminar registros?
- ¿Cómo se identifican los registros duplicados?
- ¿Qué tablas dependen de esta tabla?
- ¿Qué procesos consumen sus datos?

---

# 3. Diccionario de columnas

Debe existir una fila por columna física, sin omitir campos técnicos.

| Columna     | Nombre lógico  | Descripción    | Tipo SQL    | Longitud | Precisión | Escala | Nullable    | Identity    | Default     | PK          | FK          | UK          | CK          | Ejemplo        |
| ----------- | -------------- | -------------- | ----------- | -------- | --------- | ------ | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | ----------- | -------------- |
| Por extraer | Por documentar | Por documentar | Por extraer | N/A      | N/A       | N/A    | Por extraer | Por extraer | Por extraer | Por extraer | Por extraer | Por extraer | Por extraer | Por documentar |

## 3.1 Definición funcional por columna

Para cada campo se deberá documentar:

- **Significado:** qué representa en el negocio.
- **Regla de captura:** cómo se obtiene o registra.
- **Formato:** formato válido para el valor.
- **Dominio:** valores permitidos.
- **Unidad:** soles, dólares, unidades, porcentajes, fechas u otra.
- **Nulabilidad funcional:** cuándo puede faltar el dato y por qué.
- **Validación:** condiciones que debe cumplir.
- **Origen:** usuario, proceso, sistema o cálculo.
- **Sensibilidad:** pública, interna, confidencial o categoría equivalente aprobada.
- **Observaciones:** limitaciones, excepciones y consideraciones de uso.

## 3.2 Catálogo de valores

Para columnas con dominios cerrados, documentar todos los valores permitidos.

| Tabla          | Columna | Valor físico | Significado    | ¿Vigente?     | Observaciones |
| -------------- | ------- | ------------ | -------------- | ------------- | ------------- |
| Por documentar | estado  | Por extraer  | Por documentar | Por confirmar |               |

No confundir los valores permitidos por una restricción con los valores que actualmente existen en los datos.

---

# 4. Claves, relaciones y restricciones

## 4.1 Claves primarias

| Tabla       | Restricción | Columna(s)  | Propósito                               |
| ----------- | ----------- | ----------- | --------------------------------------- |
| Por extraer | Por extraer | Por extraer | Identificar un registro de forma única. |

## 4.2 Claves foráneas

| Tabla hija  | Columna hija | Tabla padre | Columna padre | Nombre FK   | Acción DELETE | Acción UPDATE |
| ----------- | ------------ | ----------- | ------------- | ----------- | ------------- | ------------- |
| Por extraer | Por extraer  | Por extraer | Por extraer   | Por extraer | Por extraer   | Por extraer   |

## 4.3 Restricciones adicionales

| Tabla       | Restricción | Tipo                     | Columnas    | Expresión o definición | Regla funcional |
| ----------- | ----------- | ------------------------ | ----------- | ---------------------- | --------------- |
| Por extraer | Por extraer | UNIQUE / CHECK / DEFAULT | Por extraer | Por extraer            | Por documentar  |

## 4.4 Cardinalidad

Documentar las relaciones como:

- Uno a uno.
- Uno a muchos.
- Muchos a muchos.
- Opcionalidad de la relación.
- Existencia o ausencia de integridad referencial física.

Las cardinalidades deben derivarse de las restricciones y del modelo real, no solamente de los datos observados.

---

# 5. Reglas de negocio

## 5.1 Rentabilidad

**Definición conceptual:**

`Rentabilidad = Ingresos - Costos`

**Nivel de análisis:** cliente, segmento, producto y periodo, según corresponda.

**Consideraciones pendientes de definición:**

- Tratamiento de ingresos y costos nulos.
- Tratamiento de operaciones pendientes o anuladas.
- Tratamiento de clientes inactivos o bloqueados.
- Tratamiento de contrataciones canceladas.
- Moneda y conversión cambiaria.
- Redondeo y precisión decimal.
- Periodo contable al que se asigna cada importe.
- Diferencia entre rentabilidad absoluta y margen porcentual.

## 5.2 Reglas específicas por entidad

| Código | Regla                                                          | Entidades afectadas | Implementación                        | Evidencia      | Estado                  |
| ------ | -------------------------------------------------------------- | ------------------- | ------------------------------------- | -------------- | ----------------------- |
| RN-001 | La rentabilidad se calcula como ingresos menos costos.         | ingresos, costos    | Consulta o proceso analítico          | Por documentar | Pendiente de validar    |
| RN-002 | Los estados válidos deben respetar los dominios implementados. | Varias              | Restricciones CHECK u otra validación | Esquema SQL    | Pendiente de inventario |
| RN-003 | Los periodos representan combinaciones de año y mes únicas.    | periodos            | Restricción de unicidad               | Esquema SQL    | Pendiente de validar    |

---

# 6. Linaje y flujo de datos

## 6.1 Linaje por columna

| Objeto destino | Columna destino | Origen         | Columna origen | Transformación | Proceso responsable |
| -------------- | --------------- | -------------- | -------------- | -------------- | ------------------- |
| Por documentar | Por documentar  | Por documentar | Por documentar | Por documentar | Por documentar      |

## 6.2 Dependencias de objetos

Inventariar:

- Vistas.
- Funciones escalares.
- Funciones con valores de tabla.
- Procedimientos almacenados.
- Triggers.
- Jobs de SQL Server Agent.
- Paquetes ETL y procesos externos.
- Informes y modelos analíticos consumidores.

Por cada dependencia se debe indicar su propósito, objetos utilizados, parámetros, salidas, frecuencia y responsable.

---

# 7. Calidad de datos

## 7.1 Catálogo de controles

| Código | Control                    | Tabla                         | Regla de validación                                                           | Severidad | Frecuencia  | Responsable |
| ------ | -------------------------- | ----------------------------- | ----------------------------------------------------------------------------- | --------- | ----------- | ----------- |
| CD-001 | Integridad referencial     | Tablas relacionadas           | No deben existir referencias huérfanas cuando corresponda integridad física.  | Alta      | Por definir | Por definir |
| CD-002 | Importes válidos           | ingresos, costos, operaciones | Los importes deben respetar las restricciones y reglas de negocio aplicables. | Alta      | Por definir | Por definir |
| CD-003 | Unicidad de periodos       | periodos                      | No debe repetirse una combinación de año y mes.                               | Alta      | Por definir | Por definir |
| CD-004 | Coherencia de rentabilidad | ingresos, costos              | La métrica debe coincidir con los criterios funcionales aprobados.            | Alta      | Por definir | Por definir |

## 7.2 Indicadores de calidad

- Completitud.
- Unicidad.
- Validez.
- Consistencia.
- Integridad referencial.
- Oportunidad o actualidad.
- Exactitud, cuando exista una fuente de contraste.

Documentar la fórmula, el umbral esperado, el resultado observado y la acción correctiva de cada indicador.

---

# 8. Seguridad y privacidad

| Objeto o columna | Clasificación | ¿Contiene datos personales? | Acceso autorizado | Enmascaramiento | Retención   |
| ---------------- | ------------- | --------------------------- | ----------------- | --------------- | ----------- |
| Por evaluar      | Por definir   | Por evaluar                 | Por definir       | Por definir     | Por definir |

Evaluar especialmente campos como DNI, RUC, nombres, teléfonos y direcciones.

Documentar:

- Roles y permisos.
- Principio de mínimo privilegio.
- Accesos de lectura y escritura.
- Tratamiento de datos de prueba.
- Enmascaramiento en ambientes no productivos.
- Auditoría de accesos y modificaciones.
- Políticas de retención y eliminación.

La clasificación debe responder a la naturaleza real de los datos y a las políticas aplicables.

---

# 9. Índices y rendimiento

| Tabla       | Índice      | Tipo                     | Columnas clave | Columnas incluidas | Unicidad      | Propósito      |
| ----------- | ----------- | ------------------------ | -------------- | ------------------ | ------------- | -------------- |
| Por extraer | Por extraer | Clustered / Nonclustered | Por extraer    | Por extraer        | Por confirmar | Por documentar |

Documentar además:

- Consultas críticas.
- Volumen de filas y crecimiento.
- Patrones de filtrado y agrupación.
- Estadísticas y mantenimiento.
- Particionamiento, si existe.
- Planes de ejecución relevantes.
- Métricas de lecturas lógicas y tiempo de ejecución.
- Riesgos de índices redundantes.

No recomendar índices únicamente por la existencia de una clave foránea: validar el patrón de consultas y el plan de ejecución.

---

# 10. Operación y mantenimiento

| Proceso        | Frecuencia  | Responsable | Dependencias   | Entrada        | Salida         | Tratamiento de errores |
| -------------- | ----------- | ----------- | -------------- | -------------- | -------------- | ---------------------- |
| Por documentar | Por definir | Por definir | Por documentar | Por documentar | Por documentar | Por documentar         |

Incluir:

- Cargas iniciales y recurrentes.
- Estrategia de transacciones.
- Manejo de errores y reintentos.
- Copias de seguridad y recuperación.
- Retención de históricos.
- Monitoreo.
- Ventanas de mantenimiento.
- Procedimientos de despliegue y reversión.

---

# 11. Glosario de negocio

| Término      | Definición                                                        | Fórmula o criterio                             | Nivel de análisis            |
| ------------ | ----------------------------------------------------------------- | ---------------------------------------------- | ---------------------------- |
| Cliente      | Entidad registrada en la tabla de clientes.                       | Según modelo físico y reglas aprobadas.        | Cliente                      |
| Contratación | Registro de la relación contractual entre cliente y producto.     | Según reglas del proceso.                      | Contratación                 |
| Ingreso      | Importe registrado como ingreso para cliente, producto y periodo. | Según reglas contables o de negocio definidas. | Cliente / producto / periodo |
| Costo        | Importe registrado como costo para cliente, producto y periodo.   | Según reglas de negocio definidas.             | Cliente / producto / periodo |
| Rentabilidad | Diferencia entre ingresos y costos.                               | Ingresos menos costos.                         | Según dimensión analítica    |
| Periodo      | Identificación de un mes y año.                                   | Combinación de año y mes.                      | Mensual                      |

---

# 12. Gobierno, cambios y pendientes

## 12.1 Historial de versiones

| Versión | Fecha      | Autor       | Cambio                                | Aprobador   |
| ------- | ---------- | ----------- | ------------------------------------- | ----------- |
| 1.0     | 2026-10-14 | Por definir | Creación de la estructura documental. | Por definir |

## 12.2 Pendientes de documentación

| ID     | Pendiente                                                   | Prioridad | Responsable | Estado    |
| ------ | ----------------------------------------------------------- | --------- | ----------- | --------- |
| PD-001 | Extraer los tipos de datos y atributos físicos reales.      | Alta      | Por definir | Pendiente |
| PD-002 | Inventariar PK, FK, UNIQUE, CHECK y DEFAULT.                | Alta      | Por definir | Pendiente |
| PD-003 | Identificar índices y dependencias SQL.                     | Alta      | Por definir | Pendiente |
| PD-004 | Validar las reglas de negocio con el modelo y los procesos. | Alta      | Por definir | Pendiente |
| PD-005 | Documentar linaje, calidad y seguridad.                     | Media     | Por definir | Pendiente |

---

# Anexo A. Criterios de completitud

El diccionario se considerará completo cuando:

- [ ] Todas las tablas y columnas físicas estén inventariadas.
- [ ] Los tipos, longitudes, precisiones y nulabilidad coincidan con SQL Server.
- [ ] Todas las claves y restricciones estén documentadas.
- [ ] Las relaciones y cardinalidades hayan sido verificadas.
- [ ] Las reglas de negocio tengan definición y responsable.
- [ ] Los objetos programables y sus dependencias estén inventariados.
- [ ] Las reglas de calidad tengan controles verificables.
- [ ] Los datos sensibles tengan clasificación y controles documentados.
- [ ] Los índices y aspectos de rendimiento estén registrados.
- [ ] Los cambios del modelo tengan trazabilidad.
- [ ] Las dudas y excepciones estén identificadas, sin sustituirlas por supuestos.

