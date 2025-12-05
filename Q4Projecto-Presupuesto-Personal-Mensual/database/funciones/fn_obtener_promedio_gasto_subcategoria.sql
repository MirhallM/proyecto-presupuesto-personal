CREATE OR REPLACE FUNCTION fn_obtener_promedio_gasto_subcategoria(
    p_id_usuario INTEGER,
    p_id_subcategoria INTEGER,
    p_cantidad_meses INTEGER
)
RETURNS DECIMAL(10,2)
BEGIN
    DECLARE v_promedio DECIMAL(10,2);

    WITH Meses AS (
        SELECT
            anio,
            mes,
            SUM(monto) AS total_mes,
            ROW_NUMBER() OVER (ORDER BY anio DESC, mes DESC) AS rn
        FROM transacciones
        WHERE id_usuario = p_id_usuario
          AND id_subcategoria = p_id_subcategoria
        GROUP BY anio, mes
    )
    SELECT COALESCE(AVG(total_mes), 0.00)
    INTO v_promedio
    FROM Meses
    WHERE rn <= p_cantidad_meses;

    RETURN v_promedio;
END;
