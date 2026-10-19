USE [therapyflex_academico_demo];
GO
SET NOCOUNT ON;
IF DB_NAME()<>N'therapyflex_academico_demo' THROW 50001,N'Base incorrecta.',1;
IF (SELECT COUNT(*) FROM dbo.patients)<>3 THROW 50002,N'Conteo pacientes incorrecto.',1;
IF (SELECT COALESCE(SUM(amount),0) FROM dbo.payments)<>350 THROW 50003,N'Total pagos incorrecto.',1;
IF (SELECT SUM(total-paid_amount) FROM dbo.invoices WHERE status<>N'cancelada')<>150 THROW 50004,N'Saldo incorrecto.',1;
IF EXISTS(SELECT 1 FROM dbo.vw_pagos_por_paciente WHERE total_pagado<>dbo.fn_total_pagado(id)) THROW 50005,N'Función y vista difieren.',1;
IF (SELECT COUNT(*) FROM dbo.vw_pagos_por_paciente WHERE cantidad_pagos=0)<>1 THROW 50006,N'Falta paciente sin pagos.',1;
SELECT * FROM dbo.vw_pagos_por_paciente ORDER BY total_pagado DESC;
EXEC dbo.sp_pagos_por_periodo @Desde='2026-10-01',@Hasta='2026-10-31';
PRINT N'Comprobaciones de demostración satisfactorias.';