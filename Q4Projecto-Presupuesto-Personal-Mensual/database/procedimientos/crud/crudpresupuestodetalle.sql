
-- 1) Insertar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_insertar_presupuesto_detalle(
	IN p_id_presupuesto integer,
	IN p_id_subcategoria integer,
	IN p_monto_mensual decimal(10,2),
	IN p_observaciones text,
	IN p_creado_por varchar(100)
)
BEGIN
	INSERT INTO presupuestos_detalle(
		id_presupuesto,
		id_subcategoria,
		monto_mensual,
		observaciones,
		creado_por,
		modificado_por
	) VALUES (
		p_id_presupuesto,
		p_id_subcategoria,
		p_monto_mensual,
		p_observaciones,
		p_creado_por,
		p_creado_por
	);
END;


-- 2) Actualizar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_actualizar_presupuesto_detalle(
	IN p_id_detalle integer,
	IN p_monto_mensual decimal(10,2),
	IN p_observaciones text,
	IN p_modificado_por varchar(100)
)
BEGIN
	UPDATE presupuestos_detalle SET
		monto_mensual = p_monto_mensual,
		observaciones = p_observaciones,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_detalle = p_id_detalle;
END;


-- 3) Eliminar un detalle de presupuesto
CREATE OR REPLACE PROCEDURE sp_eliminar_presupuesto_detalle(
	IN p_id_detalle integer
)
BEGIN
	DELETE FROM presupuestos_detalle
	WHERE id_detalle = p_id_detalle;
END;


-- 4) Consultar un detalle de presupuesto por ID
CREATE OR REPLACE PROCEDURE sp_consultar_presupuesto_detalle(
	IN p_id_detalle integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM presupuestos_detalle
		WHERE id_detalle = p_id_detalle
	) THEN
		RAISERROR 50000 'No hay detalle de presupuesto con esta ID';
	END IF;

	SELECT 
		pd.*,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria,
		c.tipo AS tipo_categoria
	FROM presupuestos_detalle pd
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
		pd.monto_mensual,
		pd.observaciones,
		s.nombre AS nombre_subcategoria,
		c.nombre AS nombre_categoria,
		c.tipo AS tipo_categoria
	FROM presupuestos_detalle pd
	INNER JOIN subcategorias s ON pd.id_subcategoria = s.id_subcategoria
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE pd.id_presupuesto = p_id_presupuesto
	ORDER BY c.tipo, c.nombre, s.nombre;
END;