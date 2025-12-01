CREATE OR REPLACE PROCEDURE sp_calcular_monto_ejecutado_mes(
	IN p_id_subcategoria integer,
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	
	OUT p_monto_ejecutado DECIMAL(10,2)
)
BEGIN   
    -- Verificar que la subcategoria pertenece a este presupuesto
    IF NOT EXISTS (
        SELECT 1 
        FROM subcategorias
        WHERE id_subcategoria = p_id_subcategoria
        AND id_presupuesto = p_id_presupuesto
    ) THEN RAISERROR 50001 'La subcategoria no pertenece a este presupuesto';
    END IF;
	
	--Realizar calculo del monto ejecutado
	SELECT 	COALESCE(SUM(monto), 0)
	INTO 	p_monto_ejecutado
	FROM 	transacciones
	WHERE 	id_subcategoria = p_id_subcategoria
	AND 	id_presupuesto = p_id_presupuesto
	AND 	anio_transaccion = p_anio
	AND		mes_transaccion = p_mes;
END;