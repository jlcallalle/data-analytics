CREATE [OR ALTER] PROCEDURE nombre_del_procedimiento
    @Parametro1 tipo_de_dato [= valor_predeterminado] [OUTPUT],
    @Parametro2 tipo_de_dato [READONLY]
AS
BEGIN
    -- Opcional para mejorar el rendimiento y evitar mensajes de filas afectadas
    SET NOCOUNT ON; 

    -- Cuerpo del procedimiento (instrucciones SQL: SELECT, INSERT, UPDATE, DELETE, etc.)
    
END;
