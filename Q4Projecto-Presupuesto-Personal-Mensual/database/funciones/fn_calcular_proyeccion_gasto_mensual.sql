CREATE OR REPLACE FUNCTION fn_calcular_proyeccion_gasto_mensual(
    p_id_subcategoria INTEGER,
    p_anio integer,
    p_mes integer
)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE v_monto_ejecutado DECIMAL(10,2);
    DECLARE v_dias_transcurridos integer;
    DECLARE v_dias_totales integer;
    DECLARE v_fecha_actual DATE;
    DECLARE v_proyeccion DECIMAL(10,2);

    SET v_fecha_actual = CURRENT DATE;

    -- Obtener el monto ejecutado usando la función existente
    SET v_monto_ejecutado = fn_calcular_monto_ejecutado(p_id_subcategoria, p_anio, p_mes);

    -- Días totales del mes
    SET v_dias_totales = DAY(LAST_DAY(DATEFROMPARTS(p_anio, p_mes, 1)));

    -- Días transcurridos
    IF YEAR(v_fecha_actual) = p_anio AND MONTH(v_fecha_actual) = p_mes THEN
        SET v_dias_transcurridos = DAY(v_fecha_actual);
    ELSE
        SET v_dias_transcurridos = v_dias_totales;
    END IF;

    -- Calcular proyección
    IF v_dias_transcurridos > 0 THEN
        SET v_proyeccion = v_monto_ejecutado / v_dias_transcurridos * v_dias_totales;
    ELSE
        SET v_proyeccion = 0;
    END IF;

    RETURN v_proyeccion;
END;
