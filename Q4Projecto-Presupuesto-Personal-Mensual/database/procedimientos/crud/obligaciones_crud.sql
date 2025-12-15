CREATE OR REPLACE PROCEDURE sp_insertar_obligacion(
    IN p_id_usuario integer,
    IN p_id_subcategoria integer,
    IN p_nombre varchar(50),
    IN p_descripcion varchar(255),
    IN p_monto decimal(10,2),
    IN p_dia_vencimiento integer,
    IN p_fecha_inicio date,
    IN p_fecha_final date,
    IN p_creado_por varchar(100)
)
BEGIN
    -- Validar que el usuario exista
    IF NOT EXISTS (
        SELECT 1 FROM usuarios
        WHERE id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50001 'El usuario no existe';
    END IF;

    -- Validar que la subcategoría pertenezca al usuario
    IF NOT EXISTS (
        SELECT 1 FROM subcategorias
        WHERE id_subcategoria = p_id_subcategoria
          AND id_usuario = p_id_usuario
    ) THEN
        RAISERROR 50002 'La subcategoría no existe o no pertenece al usuario';
    END IF;

    -- Validar monto
    IF p_monto <= 0 THEN
        RAISERROR 50003 'El monto debe ser mayor que cero';
    END IF;

    -- Validar día de vencimiento
    IF p_dia_vencimiento < 1 OR p_dia_vencimiento > 31 THEN
        RAISERROR 50004 'El día de vencimiento debe estar entre 1 y 31';
    END IF;

    -- Validar fechas
    IF p_fecha_fin IS NOT NULL AND p_fecha_fin < p_fecha_inicio THEN
        RAISERROR 50005 'La fecha final no puede ser menor a la fecha de inicio';
    END IF;

    -- Insertar obligación
    INSERT INTO obligaciones(
        id_usuario,
        id_subcategoria,
        nombre,
        descripcion,
        monto_fijo,
        dia_vencimiento,
        fecha_inicio,
        fecha_final,
        es_vigente,
        creado_por,
        modificado_por
    ) VALUES (
        p_id_usuario,
        p_id_subcategoria,
        p_nombre,
        p_descripcion,
        p_monto,
        p_dia_vencimiento,
        p_fecha_inicio,
        p_fecha_final,
        1,
        p_creado_por,
        p_creado_por
    );
END;


CREATE OR REPLACE PROCEDURE sp_actualizar_obligacion(
	IN p_id_obligacion integer,
	IN p_nombre varchar(50),
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_dia_vencimiento integer,
	IN p_fecha_final date,
	IN p_activo tinyint,
	IN p_modificado_por varchar(100)
)
BEGIN
	UPDATE obligaciones SET
		nombre = p_nombre,
		descripcion = p_descripcion,
		monto_fijo = p_monto,
		dia_vencimiento = p_dia_vencimiento,
		fecha_final = p_fecha_final,
		es_vigente = p_activo,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_obligacion = p_id_obligacion;
END;

CREATE OR REPLACE PROCEDURE sp_eliminar_obligacion(
	IN p_id_obligacion integer
)
BEGIN
	UPDATE obligaciones
	SET es_vigente = 0,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_obligacion = p_id_obligacion;
END;

CREATE OR REPLACE PROCEDURE sp_consultar_obligacion(
	IN p_id_obligacion integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM obligaciones
		WHERE id_obligacion = p_id_obligacion AND es_vigente = 1
	) THEN
		RAISERROR 50000 'No hay obligacion con esta ID';
	END IF;
	
	SELECT 
		o.*,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria
	FROM obligaciones o
	INNER JOIN subcategorias s ON o.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE o.id_obligacion = p_id_obligacion;
END;

CREATE OR REPLACE PROCEDURE sp_listar_obligaciones_usuario(
	IN p_id_usuario integer,
	IN p_activo integer
)
BEGIN
	SELECT 
		o.id_obligacion,
		o.id_usuario,
		o.id_subcategoria,
		o.nombre,
		o.descripcion,
		o.monto_fijo,
		o.dia_vencimiento,
		o.fecha_inicio,
		o.fecha_final,
		o.es_vigente,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria
	FROM obligaciones o
	INNER JOIN subcategorias s ON o.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE o.id_usuario = p_id_usuario
	AND (p_activo IS NULL OR o.es_vigente = p_activo)
	ORDER BY o.dia_vencimiento, o.nombre;
END; 