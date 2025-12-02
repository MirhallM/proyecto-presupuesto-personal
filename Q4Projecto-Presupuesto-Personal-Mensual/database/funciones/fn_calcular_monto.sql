CREATE OR REPLACE FUNCTION fn_calcular_monto_ejecutado(
	p_id_subcategoria integer,
	p_anio integer,
	p_mes integer
)
RETURNS decimal(10,2)
BEGIN
	DECLARE v_total decimal(10,2);
	
	SELECT COALESCE(SUM(monto), 0.00) INTO v_total
	FROM transacciones
	WHERE id_subcategoria = p_id_subcategoria
	AND anio = p_anio
	AND mes = p_mes;
	
	RETURN v_total;
END;

