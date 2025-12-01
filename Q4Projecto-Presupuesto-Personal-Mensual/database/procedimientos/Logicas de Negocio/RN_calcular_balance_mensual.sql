CREATE OR REPLACE PROCEDURE RN_calcular_balance_mensual (
	 IN p_id_usuario integer,
	 IN p_id_presupuesto integer,
	 IN p_anio integer,
	 IN p_mes integer,

	 OUT p_total_ingresos decimal(10,2),
	 OUT p_total_gastos decimal(10,2),
	 OUT p_total_ahorros decimal(10,2),
	 OUT p_balance_final decimal(10,2)
)
BEGIN
	DECLARE v_mes_inicio int;
	DECLARE v_anio_inicio int;
	DECLARE v_mes_final int;
	DECLARE v_anio_final int;

    -- 1. Validar que el usuario exista
    IF NOT EXISTS (
        SELECT 1
        FROM usuarios
        WHERE id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;
    
	-- 2. Validar que el presupuesto existe y que este la fecha este dentro de un periodo valido
	SELECT mes_inicio, mes_	final, anio_inicio, anio_final
	INTO v_mes_inicio, v_mes_final, v_anio_inicio, v_anio_final
	FROM presupuestos p
	WHERE p.id_presupuesto = p_id_presupuesto 
	AND p_id_usuario = p.id_usuario 
	AND p.estado = 'activo';
	
	IF v_mes_inicio IS NULL THEN
        RAISERROR 50003 'El presupuesto no existe, no pertenece al usuario o no está activo.';
    END IF;
	
	-- 3. Verificar que fecha del balance pertenezca a un presupuesto activo
	IF (p_anio < v_anio_inicio)
	    OR (p_anio > v_anio_fin)
    	OR (p_anoi = v_anio_inicio AND p_mes < v_mes_inicio)
    	OR (p_anoi = v_anio_inicio AND p_mes > v_mes_final)
		THEN RAISERROR 50000 'La fecha elegida para el balance esta fuera del periodo activo del presupuesto'
	END IF;
	
	-- 4. Calcular ingresos, gastos y ahorros
	-- Usamos COALESCE porque si no se encuentra ningun resultado en SUM() retornaria NULL, y si ponemos cualquier numero +/- 
	-- NULL siempre va a dar NULL, COALESCE garantiza que si el resultado es NULL, simplemente va a insertar 0 enves de NULL
	
	SELECT 	
		COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'ingreso' THEN monto END), 0),
		COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'gasto' THEN monto END), 0),
		COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'ahorro' THEN monto END), 0)
	INTO	p_total_ingresos, p_total_gastos, p_total_ahorros
	FROM 	transacciones t
	WHERE	id_presupuesto = p_id_presupuesto
	AND 	anio_transaccion = p_anio
	AND		mes_transaccion = p_mes;
	
	SET p_balance_final = p_total_ingresos - p_total_gastos - p_total_ahorros;
	
/* Se puede hacer en un solo query porque todo eso se repite
	-- Ingresos
	SELECT 	COALESCE(SUM(monto), 0)
	INTO	p_total_ingresos
	FROM 	transacciones
	WHERE	id_presupuesto = p_id_presupuesto
	AND 	anio_transaccion = p_anio
	AND		mes_transaccion = p_mes
	AND 	tipo_transaccion = 'ingreso';
	
	-- Gastos
	SELECT 	COALESCE(SUM(monto), 0)
	INTO	p_total_gastos
	FROM 	transacciones
	WHERE	id_presupuesto = p_id_presupuesto
	AND 	anio_transaccion = p_anio
	AND		mes_transaccion = p_mes
	AND 	tipo_transaccion = 'gasto';
	
	-- Ahorros
	SELECT 	COALESCE(SUM(monto), 0)
	INTO	p_total_ahorros
	FROM 	transacciones
	WHERE	id_presupuesto = p_id_presupuesto
	AND 	anio_transaccion = p_anio
	AND		mes_transaccion = p_mes
	AND 	tipo_transaccion = 'ahorro';*/
END;