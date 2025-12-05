CREATE OR REPLACE FUNCTION fn_calcular_porcentaje_ejecutado(
    IN  p_id_subcategoria  integer,
    IN  p_id_presupuesto integer,
    IN  p_anio integer,
    IN  p_mes integer
)
RETURNS decimal(10,2)
BEGIN
    DECLARE v_monto_asignado decimal(10,2);
    DECLARE v_monto_ejecutado decimal(10,2);
    DECLARE v_porcentaje decimal(10,2);

    -- 1. Obtener el monto mensual asignado (detalles_subcategorias es la tabla que contiene la asignación)
    SELECT monto_mensual
    INTO v_monto_asignado
    FROM detalles_subcategorias
    WHERE id_subcategoria = p_id_subcategoria
      AND id_presupuesto  = p_id_presupuesto;

    -- Si no existe detalle, devolvemos NULL para indicar "sin asignación"
    IF v_monto_asignado IS NULL THEN
        RETURN NULL;
    END IF;

    -- 2. Obtener monto ejecutado (transacciones) para ese presupuesto/subcategoria/mes-año
    SELECT COALESCE(SUM(monto), 0.00)
    INTO v_monto_ejecutado
    FROM transacciones
    WHERE id_subcategoria  = p_id_subcategoria
      AND id_presupuesto   = p_id_presupuesto
      AND anio_transaccion = p_anio
      AND mes_transaccion  = p_mes;

    -- 3. Calcular porcentaje (según regla de negocio, v_monto_asignado > 0 siempre)
    SET v_porcentaje = (v_monto_ejecutado / v_monto_asignado) * 100;

    RETURN v_porcentaje;
END;
