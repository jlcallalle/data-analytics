# Laboratorio TherapyFlex

Equivalente temático al laboratorio del profesor, adaptado al esquema real.

Ejecutar objetos_demo.sql únicamente después de DDL/create_database_Pdan8_Academico.sql y DML/insert_data_Pdan8_Academico.sql. Crea una función de total pagado, una vista agregada por paciente y un procedimiento de pagos por período. Ejecutar luego ../validacion/pruebas_demo.sql.

Ejercicios: listar pacientes; contar altas web; clasificar citas por estado y profesional; ordenar pagos por paciente; obtener evolución mensual; calcular saldo de facturas; detectar inconsistencias. Las once soluciones de lectura están en ../Consultas de Negocio.

Los resultados de ejemplo dependen del DML ficticio: 3 pacientes, pagos por 350, facturas no canceladas por 500 y saldo positivo de 150. Estos valores no describen la base real. Los objetos programables se instalan solo en Pdan8_Academico.
## Estado actual: datos reales

Se sustituyó la demostración de Pdan8_Academico por una copia local de las nueve tablas de therapyflex_crm. Se verificaron conteos iguales durante la transacción: 238 pacientes, 873 citas, 162 pagos, 5 sesiones, 1 archivo, 70 reseñas, 3 usuarios, 0 facturas y 0 detalles. El origen no se modificó. La copia es puntual, no una sincronización automática.

El script utilizado es DML/copiar_datos_reales_Pdan8_Academico.sql. No incluye registros personales literales: lee del servidor local. Solo acepta un destino vacío o la demostración inicial; no sirve para sobrescribir libremente datos reales.

Para trabajar ahora, ejecutar las consultas de negocio o laboratorio/consultas_demo.sql, que ya apuntan a Pdan8_Academico. El nombre demo del archivo no determina los datos consultados. No ejecutar el DML ficticio ni validacion/pruebas_demo.sql: sus valores esperados corresponden exclusivamente a la demostración anterior. Las consultas de facturas y servicios seguirán vacías porque tampoco hay esas filas en el origen. session_files copia metadatos y rutas, no el contenido de los archivos.
