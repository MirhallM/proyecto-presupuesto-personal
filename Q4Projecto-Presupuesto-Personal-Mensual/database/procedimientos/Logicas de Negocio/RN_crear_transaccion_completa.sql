CREATE OR REPLACE PROCEDURE sp_crear_transaccion_completa(
	IN p_id_usuario integer,
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	IN p_id_subcategoria integer,
	IN p_tipo varchar(18),
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_fecha date,
	IN p_metodo_pago varchar(30)
)


BEGIN
	/* Registra una transacción y valida que esté dentro del período 
	del presupuesto y que el año/mes sean válidos. Para validar que el registro
	de la transaccion esta dentro de un periodo valido, primero tiene que 
	verificar que el usuario exista, luego verificar si la transaccion esta 
	entre las fechas de un presupuesto activo. Luego tiene que verificar que 
	la id_subcategoria exista para el usuario que estamos revisando. Luego 
	hace la insercion de los datos a la tabla de transacciones una vez que 
	todos estos chequeos esten validados
	*/

	--Declaraciones de variables--
	DECLARE v_mes_inicio int;
	DECLARE v_anio_inicio int;
	DECLARE v_mes_final int;
	DECLARE v_anio_final int;
    DECLARE creador varchar (50);

	-- 1. Validar que el usuario exista
	SELECT nombres 
    INTO creador
    FROM usuarios
    WHERE id_usuario = p_id_usuario;

    IF creador IS NULL THEN
        RAISERROR 50002 'El usuario no existe'
    END IF;

	-- 2. Validar que el presupuesto existe y que este la transaccion este dentro de un periodo valido
    SELECT mes_inicio, mes_final, anio_inicio, anio_final
    INTO v_mes_inicio, v_mes_final, v_anio_inicio, v_anio_final
    FROM presupuestos p
    WHERE p.id_presupuesto = p_id_presupuesto 
    AND p_id_usuario = p.id_usuario 
    AND p.estado = 'activo';

    IF v_mes_inicio IS NULL THEN
        RAISERROR 50003 'El presupuesto no existe, no pertenece al usuario o no está activo.';
    END IF;

    -- 3. Verificar que fecha de la transaccion pertenezca a un presupuesto activo
    IF (p_anio < v_anio_inicio)
        OR (p_anio > v_anio_fin)
        OR (p_anoi = v_anio_inicio AND p_mes < v_mes_inicio)
        OR (p_anoi = v_anio_inicio AND p_mes > v_mes_final)
    THEN RAISERROR 50000 'La transaccion esta fuera del periodo activo del presupuesto'
    END IF;

    -- 4. Verificar que la subcategoria pertenece a este presupuesto
    IF NOT EXISTS (
        SELECT 1 
        FROM subcategorias
        WHERE id_subcategoria = p_id_subcategoria
        AND id_presupuesto = p_id_id_presupuesto
    ) THEN RAISERROR 50001 'La subcategoria no pertenece a este presupuesto'
    END IF;

    --5. Insertar la transaccion
    INSERT INTO transacciones ( 
        id_presupuesto,
        id_usuario,
        id_subcategoria,
        id_obligacion,
        anio_transaccion,
        mes_transaccion,
        tipo_transaccion,
        descripcion,
        monto,
        metodo_pago,
        numero_factura,
        comentarios_extra,
        fecha_hora_registro,
        creado_por,
        modificado_por 
    ) VALUES (
        p_id_presupuesto,
        p_id_usuario,
        p_id_subcategoria,
        NULL,
        p_anio,
        p_mes,
        p_tipo,
        p_descripcion,
        p_monto,
        p_metodo_pago,
        NULL,
        NULL,
        p_fecha,
        creador,
        creador
    );
END;