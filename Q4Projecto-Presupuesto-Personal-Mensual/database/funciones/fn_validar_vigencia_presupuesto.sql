CREATE OR REPLACE FUNCTION fn_validar_vigencia_presupuesto(
    p_fecha DATE,
    p_id_presupuesto integer
)
RETURNS BIT
BEGIN
    DECLARE v_anio_inicio integer;
    DECLARE v_mes_inicio integer;
    DECLARE v_anio_fin integer;
    DECLARE v_mes_fin integer;
    DECLARE v_anio_fecha integer;
    DECLARE v_mes_fecha integer;

    -- Obtener vigencia del presupuesto
    SELECT anio_inicio, mes_inicio, anio_final, mes_final
    INTO v_anio_inicio, v_mes_inicio, v_anio_fin, v_mes_fin
    FROM presupuestos
    WHERE id_presupuesto = p_id_presupuesto;

    -- Extraer año y mes de la fecha de entrada
    SET v_anio_fecha = YEAR(p_fecha);
    SET v_mes_fecha = MONTH(p_fecha);

    -- Validar que esté dentro del rango
    IF (v_anio_fecha < v_anio_inicio)
       OR (v_anio_fecha > v_anio_fin)
       OR (v_anio_fecha = v_anio_inicio AND v_mes_fecha < v_mes_inicio)
       OR (v_anio_fecha = v_anio_fin AND v_mes_fecha > v_mes_fin) THEN
        RETURN 0; -- fuera de vigencia
    ELSE
        RETURN 1; -- válido
    END IF;
END;
