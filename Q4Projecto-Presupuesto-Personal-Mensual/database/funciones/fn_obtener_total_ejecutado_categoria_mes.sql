CREATE OR REPLACE FUNCTION fn_obtener_total_ejecutado_categoria_mes(
    p_id_categoria integer,
    p_anio integer,
    p_mes integer
)
RETURNS decimal(10,2)
BEGIN
    DECLARE v_total decimal(10,2);

    SELECT COALESCE(SUM(t.monto), 0.00)
    INTO v_total
    FROM transacciones t
    INNER JOIN subcategorias s ON t.id_subcategoria = s.id_subcategoria
    WHERE s.id_categoria = p_id_categoria
    AND t.anio = p_anio
    AND t.mes = p_mes;

    RETURN v_total;
END;
