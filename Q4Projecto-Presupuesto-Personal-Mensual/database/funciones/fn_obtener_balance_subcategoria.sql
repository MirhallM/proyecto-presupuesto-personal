CREATE OR REPLACE FUNCTION fn_obtener_balance_subcategoria(
	p_id_presupuesto integer,
	p_id_subcategoria integer,
	p_anio integer,
	p_mes integer
)
RETURNS decimal(10,2)
BEGIN
	DECLARE v_presupuestado decimal(10,2);
	DECLARE v_ejecutado decimal(10,2);
	DECLARE v_balance decimal(10,2);
	
	SELECT COALESCE(monto_mensual, 0.00) INTO v_presupuestado
	FROM presupuestos_detalle
	WHERE id_presupuesto = p_id_presupuesto
	AND id_subcategoria = p_id_subcategoria;
	
	SELECT COALESCE(SUM(monto), 0.00) INTO v_ejecutado
	FROM transacciones
	WHERE id_presupuesto = p_id_presupuesto
	AND id_subcategoria = p_id_subcategoria
	AND anio = p_anio
	AND mes = p_mes;
	
	SET v_balance = v_presupuestado - v_ejecutado;
	
	RETURN v_balance;
END;