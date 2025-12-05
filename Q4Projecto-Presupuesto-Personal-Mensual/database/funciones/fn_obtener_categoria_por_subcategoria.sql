CREATE OR REPLACE FUNCTION fn_obtener_categoria_por_subcategoria(
    p_id_subcategoria integer
)
RETURNS integer
BEGIN
    DECLARE v_id_categoria integer;

    -- Obtener la categoría padre de la subcategoría
    SELECT id_categoria
    INTO v_id_categoria
    FROM subcategorias
    WHERE id_subcategoria = p_id_subcategoria;

    RETURN v_id_categoria;
END;
