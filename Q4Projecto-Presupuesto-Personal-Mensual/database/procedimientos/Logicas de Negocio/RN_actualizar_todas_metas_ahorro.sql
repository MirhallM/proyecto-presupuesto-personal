CREATE OR REPLACE PROCEDURE sp_actualizar_todas_metas_ahorro(
    IN p_id_usuario integer
)
BEGIN
    DECLARE v_id_meta integer;
    DECLARE v_id_subcategoria integer;
    DECLARE v_monto_ahorrado decimal(10,2);

    -- Cursor para recorrer todas las metas de ahorro del usuario
    DECLARE cur_metas CURSOR FOR
        SELECT id_meta, id_subcategoria
        FROM metas_ahorro
        WHERE id_usuario = p_id_usuario;

    -- Cursor para recorrer las metas
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_id_meta = NULL;

    OPEN cur_metas;

    meta_loop: meta_loop
        FETCH cur_metas INTO v_id_meta, v_id_subcategoria;

        IF v_id_meta IS NULL THEN
            LEAVE meta_loop;
        END IF;

        --Calcular el monto ahorrado usando la función fn_calcular_monto_ejecutado
        SET v_monto_ahorrado = fn_calcular_monto_ejecutado(v_id_subcategoria, YEAR(CURRENT DATE), MONTH(CURRENT DATE));

        -- Actualizar la meta de ahorro con el monto ahorrado calculado
        UPDATE metas_ahorro SET
            monto_ahorrado = v_monto_ahorrado,
            modificado_en = CURRENT TIMESTAMP
        WHERE id_meta = v_id_meta;  
    END LOOP meta_loop;

    CLOSE cur_metas;
END;