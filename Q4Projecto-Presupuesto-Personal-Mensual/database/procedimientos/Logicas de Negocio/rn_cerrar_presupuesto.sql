CREATE OR REPLACE PROCEDURE sp_cerrar_presupuesto (
	IN p_id_presupuesto integer,
	IN p_modificador varchar (50)
)
BEGIN 
	DECLARE v_anio_final     INTEGER;
    DECLARE v_mes_final      INTEGER;
    DECLARE v_ahora_anio     INTEGER;
    DECLARE v_ahora_mes      INTEGER;
    DECLARE v_estado         VARCHAR(16);

    -- Validar si el presupuesto existe
    IF NOT EXISTS (
        SELECT 1
        FROM presupuestos
        WHERE id_presupuesto = p_id_presupuesto
    ) THEN
        RAISERROR 45612 'El presupuesto con ese ID no existe';
    END IF;

    -- Validar el estado actual
    SELECT estado
    INTO v_estado
    FROM presupuestos
    WHERE id_presupuesto = p_id_presupuesto;

    IF v_estado = 'cerrado' THEN
        RAISERROR 50465 'El presupuesto ya esta cerrado';
    END IF;

    -- Fecha de fin del presupuesto
    SELECT anio_final, mes_final
    INTO v_anio_final, v_mes_final
    FROM presupuestos
    WHERE id_presupuesto = p_id_presupuesto;

    -- Conseguir fecha actual
    SET v_ahora_anio = YEAR(CURRENT DATE);
    SET v_ahora_mes  = MONTH(CURRENT DATE);

    -- Verificar que el presupuesto ha pasado su fecha final 
    IF v_ahora_anio < v_anio_final
        OR (v_ahora_anio = v_anio_final AND v_ahora_mes < v_mes_final)
    THEN
        RAISERROR 50500 'No se puede cerrar: la fecha de fin aún no ha pasado.';
    END IF;

    -- Marcar el presupuesto como cerrado usando el CRUD de presupuesto
    CALL sp_eliminar_presupuesto(p_id_presupuesto);

    -- Resumen 
     SELECT 
        d.id_detalle,
        d.id_subcategoria,
        s.nombre AS nombre_subcategoria,
        d.monto_asignado,
        COALESCE((
            SELECT SUM(monto)
            FROM transacciones t
            WHERE t.id_subcategoria = d.id_subcategoria
              AND t.id_presupuesto = p_id_presupuesto
        ), 0) AS monto_gastado,
        (COALESCE((
            SELECT SUM(monto)
            FROM transacciones t
            WHERE t.id_subcategoria = d.id_subcategoria
              AND t.id_presupuesto = p_id_presupuesto
        ), 0) - d.monto_asignado) AS diferencia
    FROM detalles_presupuesto d
    JOIN subcategorias s ON s.id_subcategoria = d.id_subcategoria
    WHERE d.id_presupuesto = p_id_presupuesto
    ORDER BY s.nombre;
END;