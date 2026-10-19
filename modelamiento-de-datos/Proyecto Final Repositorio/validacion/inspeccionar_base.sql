-- Solo lectura. No incluye datos personales.
USE [therapyflex_crm];
GO
SELECT DB_NAME() base_actual;
SELECT t.name tabla,SUM(p.rows) filas
FROM sys.tables t JOIN sys.partitions p ON p.object_id=t.object_id AND p.index_id IN (0,1)
WHERE SCHEMA_NAME(t.schema_id)='dbo' GROUP BY t.name ORDER BY t.name;
SELECT OBJECT_NAME(parent_object_id) tabla,name,is_disabled,is_not_trusted FROM sys.foreign_keys;
SELECT OBJECT_NAME(object_id) tabla,name,is_disabled FROM sys.indexes WHERE index_id>0 AND OBJECTPROPERTY(object_id,'IsUserTable')=1;
SELECT COUNT(*) pagos_con_paciente_distinto FROM dbo.payments p JOIN dbo.appointments a ON a.id=p.appointment_id WHERE p.patient_id<>a.patient_id;
SELECT COUNT(*) detalles_inconsistentes FROM dbo.invoice_items WHERE quantity<=0 OR unit_price<0 OR total<>ROUND(quantity*unit_price,2);