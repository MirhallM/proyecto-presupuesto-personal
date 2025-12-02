CREATE OR REPLACE PROCEDURE sp_calcular_porcentaje_ejecucion_mes(
	IN p_id_subcategoria integer,
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	
	OUT p_porcentaje DECIMAL(10,2)
)
BEGIN   
    DECLARE v_monto_presupuestado	DECIMAL(10,2);
    DECLARE v_monto_ejecutado		DECIMAL(10,2);
    
    SELECT 	monto_asignado
    INTO 	v_monto_presupuestado
    FROM 	detalles_presupuesto
    WHERE 	id_subcategoria = p_id_subcategoria
    AND		id_presupuesto = p_id_presupuesto;
    
    if v_monto_presupuestado IS NULL THEN
    	SET p_porcentaje = NULL;
    	RETURN;
   	END IF;
   	
   	CALL sp_calcular_monto_ejecutado_mes(
 	  	p_id_subcategoria,
		p_id_presupuesto,
		p_anio,
		p_mes,
		
		v_monto_ejecutado
	);
	
	SET p_porcentaje = (v_monto_ejecutado / v_monto_presupuestado) * 100;
END;