# Validación y pendientes de entrega

## Comprobado el 19/10/2026

Conexión de lectura a localhost/therapyflex_crm mediante autenticación integrada. Se encontraron nueve tablas de negocio, doce FK y diecisiete índices explícitos. sysdiagrams es auxiliar de SSMS. Ver estado_servidor.txt y columnas_servidor.json. No se modificó esta base ni se exportaron pacientes.

Conteos observados: 238 pacientes, 873 citas, 162 pagos, 5 sesiones, 1 archivo, 70 reseñas, 3 usuarios. Facturas y detalles: 0 filas en ambas tablas. Los conteos describen ese momento, no una garantía de actualización.

## Para cerrar la entrega

- Obtener del profesor la rúbrica: cantidad de consultas, necesidad de procedimientos, presentación, capturas, backup o repositorio remoto. No se proporcionó esa rúbrica.
- Las consultas de servicios y saldos devolverán vacío en la base actual porque no hay facturas. Usar los datos ficticios de demostración para evidenciar esas consultas; no confundirlos con operación real.
- Confirmar el significado operativo de amount/total_amount y paid_at/payment_date. Confirmar la moneda de los indicadores.
- Alinear los diagramas originales con el DDL: usuarios locales dbo.users, autoría de pacientes y sesiones, obligatoriedad y FK compuesta de archivos. Las diferencias están inventariadas en el caso. Las imágenes se conservaron, no fueron redibujadas ni verificadas visualmente.
- Capturar resultados de las consultas requeridas por el profesor y el diagrama completo de SSMS. La captura aportada muestra parte del diagrama, no todas las columnas ni reglas.
- Si se exige .bak, generar un respaldo para entrega con datos ficticios. Este paquete contiene SQL reproducible, no un backup del servidor.

## Mejoras del modelo que requieren decidir alcance

Validar paciente del pago contra paciente de la cita; definir reglas de importes y descuentos; normalizar servicios y profesionales; vincular pago-factura y sesión-cita si el negocio lo necesita; definir actualización de updated_at. Estas mejoras no se aplicaron silenciosamente al modelo existente.

El modelo actual no registra costos. Si se exige rentabilidad, será necesario ampliar el esquema y establecer cómo se atribuyen ingresos y costos. El ranking incluido mide pagos, no rentabilidad.

La presentación original permanece en Proyecto Modelado Jorge/Presentacion; no se incluyó como presentación final revisada.
## Pruebas ejecutadas

Se creó therapyflex_academico_demo y se ejecutaron satisfactoriamente DDL, DML, función, vista, procedimiento y comprobaciones de pagos/saldos/paciente sin pagos. Los resultados están en los archivos *_resultado.txt. La base académica queda disponible en SQL Server. therapyflex_crm no fue modificada.


También se ejecutaron las once consultas sobre la demostración. En la base original, el control de pagos asociados a citas de otro paciente devolvió 0; el control de detalles inconsistentes devolvió 0 porque no existen detalles. Esto no demuestra integridad de reglas que el esquema no impone. Se verificaron los enlaces locales de los documentos Markdown.

