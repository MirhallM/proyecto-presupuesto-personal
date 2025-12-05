CREATE OR REPLACE PROCEDURE sp_obtener_resumen_categoria_mes(
    IN p_id_categoria integer,
    IN p_id_presupuesto integer,
    IN p_anio integer,
    IN p_mes integer,
    OUT p_monto_presupuestado decimal(10,2),
    OUT p_monto_ejecutado decimal(10,2),
    OUT p_porcentaje decimal(10,2)
)
BEGIN
    DECLARE v_monto_presupuestado decimal(10,2) DEFAULT 0;
    DECLARE v_monto_ejecutado decimal(10,2) DEFAULT 0;

    -- 1. Obtener monto presupuestado usando la función helper
    SELECT fn_obtener_total_categoria_mes(
        p_id_categoria,
        p_id_presupuesto,
        p_anio,
        p_mes
    ) INTO v_monto_presupuestado;

    -- 2. Sumar monto ejecutado de todas las subcategorías de la categoría
    SELECT COALESCE(SUM(
        fn_calcular_monto_ejecutado(sc.id_subcategoria, p_anio, p_mes)
    ), 0)
    INTO v_monto_ejecutado
    FROM subcategorias sc
    INNER JOIN detalles_presupuesto dp 
        ON dp.id_subcategoria = sc.id_subcategoria
    WHERE sc.id_categoria = p_id_categoria
      AND dp.id_presupuesto = p_id_presupuesto;

    -- 3. Calcular porcentaje
    IF v_monto_presupuestado = 0 THEN
        SET p_porcentaje = 0;
    ELSE
        SET p_porcentaje = (v_monto_ejecutado / v_monto_presupuestado) * 100;
    END IF;

    -- 4. Mandar resultados a los OUT parameters
    SET p_monto_presupuestado = v_monto_presupuestado;
    SET p_monto_ejecutado = v_monto_ejecutado;
END;
