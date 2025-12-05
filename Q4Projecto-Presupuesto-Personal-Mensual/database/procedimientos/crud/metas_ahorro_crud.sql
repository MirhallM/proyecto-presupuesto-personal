CREATE OR REPLACE PROCEDURE sp_insertar_meta(
    IN p_id_usuario integer,
    IN p_id_subcategoria_ahorro integer,
    IN p_nombre varchar(100),
    IN p_descripcion varchar(255),
    IN p_monto_meta decimal(10,2),
    IN p_fecha_inicio date,
    IN p_fecha_objetivo date,
    IN p_prioridad integer,
    IN p_creado_por varchar(50)
)
BEGIN
    DECLARE v_usuario_existente varchar(50);

    -- Validar que el usuario exista
    SELECT nombres INTO v_usuario_existente
    FROM usuarios
    WHERE id_usuario = p_id_usuario;

    IF v_usuario_existente IS NULL THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;

    -- Validar que la subcategoría de ahorro exista y pertenezca al usuario
    IF NOT EXISTS (
        SELECT 1
        FROM subcategorias
        WHERE id_subcategoria = p_id_subcategoria_ahorro
          AND id_usuario = p_id_usuario
          AND tipo = 'ahorro'
    ) THEN
        RAISERROR 50004 'La subcategoría de ahorro no existe o no pertenece al usuario';
    END IF;

    -- Validar fechas
    IF p_fecha_objetivo < p_fecha_inicio THEN
        RAISERROR 20001 'La fecha objetivo no puede ser menor que la fecha de inicio';
    END IF;

    -- Insertar meta
    INSERT INTO metas_ahorro (
        id_usuario,
        id_subcategoria,
        nombre_meta,
        descripcion,
        monto_meta,
        monto_ahorrado,
        fecha_inicio,
        fecha_objetivo,
        prioridad,
        estado,
        creado_por,
        modificado_por,
        creado_en,
        modificado_en
    ) VALUES (
        p_id_usuario,
        p_id_subcategoria_ahorro,
        p_nombre,
        p_descripcion,
        p_monto_meta,
        0.00,
        p_fecha_inicio,
        p_fecha_objetivo,
        p_prioridad,
        'en_progreso',
        p_creado_por,
        p_creado_por,
        CURRENT TIMESTAMP,
        CURRENT TIMESTAMP
    );
END;

CREATE OR REPLACE PROCEDURE sp_actualizar_meta(
    IN p_id_meta integer,
    IN p_nombre varchar(100),
    IN p_descripcion varchar(255),
    IN p_monto_meta decimal(10,2),
    IN p_fecha_objetivo date,
    IN p_prioridad varchar(10),
    IN p_estado varchar(50),
    IN p_modificado_por varchar(50)
)
BEGIN
    -- Validar que la meta exista
    IF NOT EXISTS (
        SELECT 1
        FROM metas_ahorro
        WHERE id_meta = p_id_meta
    ) THEN
        RAISERROR 50003 'La meta de ahorro no existe';
    END IF;

    -- Validar fecha objetivo
    IF p_fecha_objetivo < (
        SELECT fecha_inicio
        FROM metas_ahorro
        WHERE id_meta = p_id_meta
    ) THEN
        RAISERROR 50002 'La fecha objetivo no puede ser menor que la fecha de inicio de la meta';
    END IF;

    -- Actualizar meta
    UPDATE metas_ahorro SET
        nombre_meta = p_nombre,
        descripcion = p_descripcion,
        monto_meta = p_monto_meta,
        fecha_objetivo = p_fecha_objetivo,
        prioridad = p_prioridad,
        estado = p_estado,
        modificado_por = p_modificado_por,
        modificado_en = CURRENT TIMESTAMP
    WHERE id_meta = p_id_meta;
END;

CREATE OR REPLACE PROCEDURE sp_eliminar_meta(
    IN p_id_meta integer
)
BEGIN
    -- Validar que la meta exista
    IF NOT EXISTS (
        SELECT 1
        FROM metas_ahorro
        WHERE id_meta = p_id_meta
    ) THEN
        RAISERROR 50003 'La meta de ahorro no existe';
    END IF;

    -- Eliminar meta (cambia el estado a 'cancelada')
    UPDATE metas_ahorro SET
        estado = 'cancelada',
        modificado_en = CURRENT TIMESTAMP
    WHERE id_meta = p_id_meta;
END;

CREATE OR REPLACE PROCEDURE sp_consultar_meta(
    IN p_id_meta integer
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM metas_ahorro
        WHERE id_meta = p_id_meta
    ) THEN
        RAISERROR 50003 'La meta de ahorro no existe';
    END IF;

    SELECT *
    FROM metas_ahorro
    WHERE id_meta = p_id_meta;
END;


CREATE OR REPLACE PROCEDURE sp_consultar_metas_usuario(
    IN p_id_usuario integer
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM usuarios
        WHERE id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;

    SELECT *
    FROM metas_ahorro
    WHERE id_usuario = p_id_usuario;
END;