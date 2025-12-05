CREATE OR REPLACE FUNCTION fn_obtener_total_categoria_mes(
    p_id_categoria integer,
    p_id_presupuesto integer
)
RETURNS decimal(10,2)
BEGIN
    DECLARE v_total decimal(10,2);

    SELECT COALESCE(SUM(dp.monto_asignado), 0.00)
    INTO v_total
    FROM detalles_presupuesto dp
    INNER JOIN subcategorias s
        ON dp.id_subcategoria = s.id_subcategoria
    WHERE s.id_categoria = p_id_categoria
    AND dp.id_presupuesto = p_id_presupuesto;

    RETURN v_total;
END;
