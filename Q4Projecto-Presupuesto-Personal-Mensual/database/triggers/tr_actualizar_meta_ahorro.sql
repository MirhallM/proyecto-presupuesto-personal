CREATE OR REPLACE TRIGGER tr_actualizar_monto_meta_ahorro
AFTER INSERT ON transacciones
REFERENCING NEW AS new_trans
FOR EACH ROW
BEGIN
    DECLARE v_id_meta INTEGER;
    DECLARE v_monto_meta DECIMAL(10,2);
    DECLARE v_monto_ahorrado DECIMAL(10,2);

    -- Solo aplica para transacciones de tipo ahorro
    IF new_trans.tipo_transaccion <> 'ahorro' THEN
        RETURN;
    END IF;

    -- Obtener la meta asociada a la subcategoría (solo la primera encontrada)
    SELECT TOP 1 id_meta, monto_meta, monto_ahorrado
    INTO v_id_meta, v_monto_meta, v_monto_ahorrado
    FROM metas_ahorro
    WHERE id_subcategoria = new_trans.id_subcategoria
      AND estado = 'en_progreso'
    ORDER BY id_meta;  -- o cualquier criterio que quieras usar para elegir "la primera"

    -- Si no existe una meta activa, salir
    IF v_id_meta IS NULL THEN
        RETURN;
    END IF;

    -- Sumar el monto a la meta
    SET v_monto_ahorrado = v_monto_ahorrado + new_trans.monto;

    -- Actualizar el registro
    UPDATE metas_ahorro
    SET monto_ahorrado = v_monto_ahorrado,
        estado = CASE
                    WHEN v_monto_ahorrado >= v_monto_meta THEN 'completada'
                    ELSE 'en_progreso'
                 END
    WHERE id_meta = v_id_meta;
END;
