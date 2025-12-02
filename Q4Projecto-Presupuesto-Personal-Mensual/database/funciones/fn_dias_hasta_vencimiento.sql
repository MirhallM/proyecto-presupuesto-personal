CREATE OR REPLACE FUNCTION fn_dias_hasta_vencimiento(
	p_id_obligacion integer
)
RETURNS integer
BEGIN
	DECLARE v_dia_vencimiento integer;
	DECLARE v_fecha_vencimiento date;
	DECLARE v_dias_restantes integer;
	
	-- obtener dia de vencimiento de la obligacion
	SELECT dia_vencimiento INTO v_dia_vencimiento
	FROM obligaciones
	WHERE id_obligacion = p_id_obligacion;
	
	-- construir fecha de vencimiento del mes actual
	SET v_fecha_vencimiento = DATEADD(day, v_dia_vencimiento - 1, 
		DATEADD(month, DATEDIFF(month, '1900-01-01', CURRENT DATE), '1900-01-01'));
	
	-- si la fecha ya paso, calcular para el proximo mes
	IF v_fecha_vencimiento < CURRENT DATE THEN
		SET v_fecha_vencimiento = DATEADD(month, 1, v_fecha_vencimiento);
	END IF;
	
	-- calcular dias restantes
	SET v_dias_restantes = DATEDIFF(day, CURRENT DATE, v_fecha_vencimiento);
	
	RETURN v_dias_restantes;
END;