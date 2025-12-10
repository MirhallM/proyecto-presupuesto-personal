
-- 1) Insertar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_insertar_detalles_presupuesto(
	IN p_id_presupuesto integer,
	IN p_id_subcategoria integer,
	IN p_monto_asignado decimal(10,2),
	IN p_justificacion varchar(100),
	IN p_creado_por varchar(100)
)
BEGIN
	INSERT INTO detalles_presupuesto(
		id_presupuesto,
		id_subcategoria,
		monto_asignado,
		justificacion,
		creado_por,
		modificado_por
	) VALUES (
		p_id_presupuesto,
		p_id_subcategoria,
		p_monto_asignado,
		p_justificacion,
		p_creado_por,
		p_creado_por
	);
END;


-- 2) Actualizar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_actualizar_detalles_presupuesto(
	IN p_id_detalle integer,
	IN p_monto_asignado decimal(10,2),
	IN p_justificacion varchar(100),
	IN p_modificado_por varchar(100)
)
BEGIN
	UPDATE detalles_presupuesto SET
		monto_asignado = p_monto_asignado,
		justificacion = p_justificacion,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_detalle = p_id_detalle;
END;


-- 3) Eliminar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_eliminar_detalles_presupuesto(
	IN p_id_detalle integer
)
BEGIN
	DELETE FROM detalles_presupuesto
	WHERE id_detalle = p_id_detalle;
END;


-- 4) Consultar un detalle de presupuesto por ID
CREATE OR REPLACE PROCEDURE sp_consultar_detalles_presupuesto(
	IN p_id_detalle integer,
	IN p_id_presupuesto integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM detalles_presupuesto
		WHERE id_detalle = p_id_detalle
	) THEN
		RAISERROR 50000 'No hay detalle de presupuesto con esta ID';
	END IF;

	IF NOT EXISTS (
		SELECT 1
		FROM detalles_presupuesto
		WHERE id_detalle = p_id_detalle
		AND id_presupuesto = p_id_presupuesto
	) THEN
		RAISERROR 50001 'El detalle de presupuesto no pertenece al presupuesto especificado';
	END IF;

	SELECT 
		pd.id_detalle,
		pd.id_presupuesto,
		pd.id_subcategoria,
		pd.monto_asignado,
		pd.justificacion,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria,
		c.tipo_categoria AS tipo_categoria
	FROM detalles_presupuesto pd
	INNER JOIN subcategorias s ON pd.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE pd.id_detalle = p_id_detalle;
END;


-- 5) Listar detalles de un presupuesto
CREATE OR REPLACE PROCEDURE sp_listar_detalles_presupuesto(
	IN p_id_presupuesto integer
)
BEGIN
	SELECT 
		pd.id_detalle,
		pd.id_presupuesto,
		pd.id_subcategoria,
		pd.monto_asignado,
		pd.justificacion,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria,
		c.tipo_categoria AS tipo_categoria
	FROM detalles_presupuesto pd
	INNER JOIN subcategorias s ON pd.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE pd.id_presupuesto = p_id_presupuesto
	ORDER BY c.tipo_categoria, c.nombre, s.nombre;
END;