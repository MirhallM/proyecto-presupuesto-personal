CREATE OR REPLACE PROCEDURE sp_actualizar_todas_metas_ahorro(
    IN p_id_usuario INTEGER
)
BEGIN
    DECLARE v_id_meta INTEGER;
    DECLARE v_id_subcategoria INTEGER;
    DECLARE v_monto_ahorrado DECIMAL(10,2);

    -- Cursor para recorrer todas las metas de ahorro del usuario
    DECLARE cur_metas CURSOR FOR
        SELECT id_meta, id_subcategoria
        FROM metas_ahorro
        WHERE id_usuario = p_id_usuario;

    OPEN cur_metas;

    -- Loop para recorrer el cursor
    meta_loop:
    LOOP
        FETCH cur_metas INTO v_id_meta, v_id_subcategoria;
        
        -- Si no hay más filas, salir del loop
        IF SQLSTATE = '02000' THEN
            LEAVE meta_loop;
        END IF;

        -- Calcular el monto ahorrado usando la función
        SET v_monto_ahorrado = fn_calcular_monto_ejecutado(
            v_id_subcategoria,
            YEAR(CURRENT DATE),
            MONTH(CURRENT DATE)
        );

        -- Actualizar la meta de ahorro con el monto calculado
        UPDATE metas_ahorro
        SET monto_ahorrado = v_monto_ahorrado,
            modificado_en = CURRENT TIMESTAMP
        WHERE id_meta = v_id_meta;
    END LOOP meta_loop;

    CLOSE cur_metas;
END;
