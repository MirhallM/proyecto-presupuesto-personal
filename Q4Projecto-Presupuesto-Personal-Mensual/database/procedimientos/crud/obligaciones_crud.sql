CREATE OR REPLACE PROCEDURE sp_insertar_obligacion(
	IN p_id_usuario integer,
	IN p_id_subcategoria integer,
	IN p_nombre varchar(100),
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_dia_vencimiento integer,
	IN p_fecha_inicio date,
	IN p_fecha_fin date,
	IN p_creado_por varchar(100)
)
BEGIN
	INSERT INTO obligaciones(
		id_usuario,
		id_subcategoria,
		nombre,
		descripcion,
		monto,
		dia_vencimiento,
		fecha_inicio,
		fecha_fin,
		activo,
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
		p_fecha_fin,
		1,
		p_creado_por,
		p_creado_por
	);
END;

CREATE OR REPLACE PROCEDURE sp_actualizar_obligacion(
	IN p_id_obligacion integer,
	IN p_nombre varchar(100),
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_dia_vencimiento integer,
	IN p_fecha_fin date,
	IN p_activo integer,
	IN p_modificado_por varchar(100)
)
BEGIN
	UPDATE obligaciones SET
		nombre = p_nombre,
		descripcion = p_descripcion,
		monto = p_monto,
		dia_vencimiento = p_dia_vencimiento,
		fecha_fin = p_fecha_fin,
		activo = p_activo,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_obligacion = p_id_obligacion;
END;

CREATE OR REPLACE PROCEDURE sp_eliminar_obligacion(
	IN p_id_obligacion integer
)
BEGIN
	UPDATE obligaciones
	SET activo = 0,
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
		WHERE id_obligacion = p_id_obligacion
	) THEN
		RAISERROR 50000 'No hay obligación con esta ID';
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
		o.monto,
		o.dia_vencimiento,
		o.fecha_inicio,
		o.fecha_fin,
		o.activo,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria
	FROM obligaciones o
	INNER JOIN subcategorias s ON o.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE o.id_usuario = p_id_usuario
	AND (p_activo IS NULL OR o.activo = p_activo)
	ORDER BY o.dia_vencimiento, o.nombre;
END; 