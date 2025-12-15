CREATE OR REPLACE PROCEDURE RN_calcular_balance_mensual (
    IN  p_id_usuario       integer,
    IN  p_id_presupuesto   integer,
    IN  p_anio             integer,
    IN  p_mes              integer,

    OUT p_total_ingresos   decimal(10,2),
    OUT p_total_gastos     decimal(10,2),
    OUT p_total_ahorros    decimal(10,2),
    OUT p_balance_final    decimal(10,2)
)
BEGIN
    DECLARE v_mes_inicio   integer;
    DECLARE v_anio_inicio  integer;
    DECLARE v_mes_final    integer;
    DECLARE v_anio_final   integer;

    -- 1. Validar que el usuario exista
    IF NOT EXISTS (
        SELECT 1
        FROM usuarios
        WHERE id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;

    -- 2. Validar que el presupuesto exista, pertenezca al usuario y esté activo
    SELECT mes_inicio,
           mes_final,
           anio_inicio,
           anio_final
    INTO   v_mes_inicio,
           v_mes_final,
           v_anio_inicio,
           v_anio_final
    FROM   presupuestos
    WHERE  id_presupuesto = p_id_presupuesto
      AND  id_usuario = p_id_usuario
      AND  estado = 'activo';

    IF v_mes_inicio IS NULL THEN
        RAISERROR 50003 'El presupuesto no existe, no pertenece al usuario o no está activo';
    END IF;

    -- 3. Verificar que la fecha solicitada pertenezca al período activo del presupuesto
    IF (p_anio < v_anio_inicio)
        OR (p_anio > v_anio_final)
        OR (p_anio = v_anio_inicio AND p_mes < v_mes_inicio)
        OR (p_anio = v_anio_final  AND p_mes > v_mes_final)
    THEN
        RAISERROR 50000 'La fecha elegida para el balance está fuera del período activo del presupuesto';
    END IF;

    -- 4. Calcular ingresos, gastos y ahorros
    -- Usamos COALESCE porque si no se encuentra ningún resultado en SUM(),
    -- retornaría NULL, y cualquier operación aritmética con NULL da NULL.
    -- COALESCE garantiza que el valor sea 0 cuando no hay registros.

    SELECT
        COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'ingreso' THEN t.monto END), 0),
        COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'gasto'   THEN t.monto END), 0),
        COALESCE(SUM(CASE WHEN t.tipo_transaccion = 'ahorro'  THEN t.monto END), 0)
    INTO
        p_total_ingresos,
        p_total_gastos,
        p_total_ahorros
    FROM transacciones t
    WHERE t.id_presupuesto = p_id_presupuesto
      AND t.anio_transaccion = p_anio
      AND t.mes_transaccion  = p_mes;

    -- 5. Calcular balance final
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