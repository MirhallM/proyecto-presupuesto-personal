CREATE OR REPLACE FUNCTION fn_obtener_promedio_gasto_subcategoria(
	p_id_usuario integer,
	p_id_subcategoria integer,
	p_cantidad_meses integer
)
RETURNS decimal(10,2)
BEGIN
	DECLARE v_promedio decimal(10,2);
	
	SELECT COALESCE(AVG(total_mes), 0.00) INTO v_promedio
	FROM (
		SELECT SUM(monto) AS total_mes
		FROM transacciones
		WHERE id_usuario = p_id_usuario
		AND id_subcategoria = p_id_subcategoria
		GROUP BY anio, mes
		ORDER BY anio DESC, mes DESC
		LIMIT p_cantidad_meses
	) AS promedios;
	
	RETURN v_promedio;
END;
