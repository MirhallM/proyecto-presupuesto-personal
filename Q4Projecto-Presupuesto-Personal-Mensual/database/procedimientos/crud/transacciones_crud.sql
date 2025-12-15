-- 1) Insertar una nueva transaccion
CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
    IN p_id_usuario integer,
    IN p_id_presupuesto integer,
    IN p_anio integer,
    IN p_mes integer,
    IN p_id_subcategoria integer,
    IN p_id_obligacion integer,
    IN p_tipo varchar(50),
    IN p_descripcion varchar(255),
    IN p_monto decimal(10,2),
    IN p_fecha date,
    IN p_metodo_pago varchar(50),
    IN p_num_factura varchar(100),
    IN p_comentarios_extra varchar(100),
    IN p_creado_por varchar(50)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISERROR 50001 'El usuario no existe';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM presupuestos
        WHERE id_presupuesto = p_id_presupuesto
          AND id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50002 'El presupuesto no existe o no pertenece al usuario';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM presupuestos
        WHERE id_presupuesto = p_id_presupuesto
          AND (
               (anio_incio < p_anio OR (anio_incio = p_anio AND mes_inicio <= p_mes))
               AND
               (anio_final > p_anio OR (anio_final = p_anio AND mes_final >= p_mes))
              )
    ) THEN
        RAISERROR 50003 'La transacción no pertenece al período del presupuesto';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM subcategorias
        WHERE id_subcategoria = p_id_subcategoria
          AND id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50004 'La subcategoría no existe o no pertenece al usuario';
    END IF;

    IF p_id_obligacion IS NOT NULL THEN
        IF NOT EXISTS (
            SELECT 1 FROM obligaciones
            WHERE id_obligacion = p_id_obligacion
              AND id_usuario = p_id_usuario
        ) THEN
            RAISERROR 50005 'La obligación no existe o no pertenece al usuario';
        END IF;
    END IF;

    IF p_monto <= 0 THEN
        RAISERROR 50006 'El monto debe ser mayor que cero';
    END IF;

    INSERT INTO transacciones(
        id_usuario,
        id_presupuesto,
        anio_transaccion,
        mes_transaccion,
        id_subcategoria,
        id_obligacion,
        tipo_transaccion,
        descripcion,
        monto,
        fecha_transaccion,
        metodo_pago,
        num_factura,
        comentarios_extra,
        fecha_hora_registro,
        creado_por,
        modificado_por
    ) VALUES (
        p_id_usuario,
        p_id_presupuesto,
        p_anio,
        p_mes,
        p_id_subcategoria,
        p_id_obligacion,
        p_tipo,
        p_descripcion,
        p_monto,
        p_fecha,
        p_metodo_pago,
        p_num_factura,
        p_comentarios_extra,
        CURRENT TIMESTAMP,
        p_creado_por,
        p_creado_por
    );
END;



-- 2) Actualizar una transaccion existente
CREATE OR REPLACE PROCEDURE sp_actualizar_transaccion(
    IN p_id_transaccion     integer,
    IN p_id_usuario         integer,
    IN p_id_presupuesto     integer,
    IN p_anio               integer,
    IN p_mes                integer,
    IN p_id_subcategoria    integer,
    IN p_id_obligacion      integer,
    IN p_tipo               varchar(50),
    IN p_descripcion        varchar(255),
    IN p_monto              decimal(10,2),
    IN p_fecha              date,
    IN p_metodo_pago        varchar(50),
    IN p_num_factura        varchar(100),
    IN p_comentarios_extra  varchar(100),
    IN p_modificado_por     varchar(50)
)
BEGIN
    -- Validar que exista
    IF NOT EXISTS (
        SELECT 1 FROM transacciones 
        WHERE id_transaccion = p_id_transaccion
    ) THEN
        RAISERROR 50000 'No existe una transacción con esta ID';
    END IF;

    -- Validar que pertenece al presupuesto
    IF NOT EXISTS (
        SELECT 1 
        FROM transacciones
        WHERE id_transaccion = p_id_transaccion
          AND id_presupuesto = p_id_presupuesto
    ) THEN
        RAISERROR 50001 'La transacción no pertenece a este presupuesto';
    END IF;

    -- Actualizar datos
    UPDATE transacciones
    SET
        id_usuario        = p_id_usuario,
        id_presupuesto    = p_id_presupuesto,
        anio_transaccion  = p_anio,
        mes_transaccion   = p_mes,
        id_subcategoria   = p_id_subcategoria,
        id_obligacion     = p_id_obligacion,
        tipo_transaccion  = p_tipo,
        descripcion       = p_descripcion,
        monto             = p_monto,
        fecha_transaccion = p_fecha,
        metodo_pago       = p_metodo_pago,
        num_factura       = p_num_factura,
        comentarios_extra = p_comentarios_extra,
        modificado_por    = p_modificado_por,
        modificado_en     = CURRENT TIMESTAMP
    WHERE id_transaccion = p_id_transaccion;
END;



-- 3) Eliminar una transaccion
CREATE OR REPLACE PROCEDURE sp_eliminar_transaccion(
	IN p_id_transaccion integer
)
BEGIN
	DELETE FROM transacciones
	WHERE id_transaccion = p_id_transaccion;
	
END;


-- 4) Consultar una transaccion por ID
CREATE OR REPLACE PROCEDURE sp_consultar_transaccion(
    IN p_id_transaccion integer,
    IN p_id_presupuesto integer
)
BEGIN
    -- Verificar que la transacción exista
    IF NOT EXISTS (
        SELECT 1
        FROM transacciones
        WHERE id_transaccion = p_id_transaccion
    ) THEN
        RAISERROR 50000 'No existe una transaccion con esta ID';
    END IF;

    -- Verificar que la transacción pertenece al presupuesto
    IF NOT EXISTS (
        SELECT 1
        FROM transacciones
        WHERE id_transaccion = p_id_transaccion
          AND id_presupuesto = p_id_presupuesto
    ) THEN
        RAISERROR 50001 'La transaccion no pertenece a este presupuesto';
    END IF;

    -- Retornar detalles de la transacción
    SELECT *
    FROM transacciones
    WHERE id_transaccion = p_id_transaccion
      AND id_presupuesto = p_id_presupuesto;
END;



-- 5) Listar transacciones de un presupuesto con filtros opcionales
CREATE OR REPLACE PROCEDURE sp_listar_transacciones_presupuesto(
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	IN p_tipo varchar(50)
)
BEGIN
	SELECT *
	FROM transacciones
	WHERE id_presupuesto = p_id_presupuesto
	AND (p_anio IS NULL OR anio_transaccion = p_anio)
	AND (p_mes IS NULL OR mes_transaccion = p_mes)
	AND (p_tipo IS NULL OR tipo_transaccion = p_tipo)
	ORDER BY fecha_transaccion DESC;
END;