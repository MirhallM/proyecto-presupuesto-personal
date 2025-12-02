-- 1) Insertar una nueva subcategoría
CREATE OR REPLACE PROCEDURE sp_insertar_subcategoria(
	IN p_id_categoria integer,
	IN p_nombre varchar(100),
	IN p_descripcion varchar(255),
	IN p_es_defecto integer,
	IN p_creado_por varchar(100)
)
BEGIN
	INSERT INTO subcategorias(
		id_categoria,
		nombre,
		descripcion,
		es_defecto,
		creado_por,
		modificado_por
	) VALUES (
		p_id_categoria,
		p_nombre,
		p_descripcion,
		p_es_defecto,
		p_creado_por,
		p_creado_por
	);
END;


-- 2) Actualizar una subcategoria existente
CREATE OR REPLACE PROCEDURE sp_actualizar_subcategoria(
	IN p_id_subcategoria integer,
	IN p_nombre varchar(100),
	IN p_descripcion varchar(255),
	IN p_modificado_por varchar(100)
)
BEGIN
	UPDATE subcategorias SET
		nombre = p_nombre,
		descripcion = p_descripcion,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_subcategoria = p_id_subcategoria;
END;


-- 3) Eliminar una subcategoria
CREATE OR REPLACE PROCEDURE sp_eliminar_subcategoria(
	IN p_id_subcategoria integer
)
BEGIN
	DECLARE v_en_uso integer;
	
	SELECT COUNT(*) INTO v_en_uso
	FROM presupuestos_detalle
	WHERE id_subcategoria = p_id_subcategoria;
	
	IF v_en_uso > 0 THEN
		RAISERROR 50001 'No se puede eliminar, subcategoría en uso en presupuestos';
	END IF;
	
	SELECT COUNT(*) INTO v_en_uso
	FROM transacciones
	WHERE id_subcategoria = p_id_subcategoria;
	
	IF v_en_uso > 0 THEN
		RAISERROR 50002 'No se puede eliminar, subcategoría en uso en transacciones';
	END IF;
	
	DELETE FROM subcategorias
	WHERE id_subcategoria = p_id_subcategoria;
END;


-- 4) Consultar una subcategoria por ID
CREATE OR REPLACE PROCEDURE sp_consultar_subcategoria(
	IN p_id_subcategoria integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM subcategorias
		WHERE id_subcategoria = p_id_subcategoria
	) THEN
		RAISERROR 50000 'No hay subcategoría con esta ID';
	END IF;
	SELECT 
		s.*,
		c.nombre AS nombre_categoria,
		c.tipo AS tipo_categoria
	FROM subcategorias s
	INNER JOIN categorias c ON s.id_categoria = c.id_categoria
	WHERE s.id_subcategoria = p_id_subcategoria;
END;


-- 5) Listar subcategorias de una categoria
CREATE OR REPLACE PROCEDURE sp_listar_subcategorias_por_categoria(
	IN p_id_categoria integer
)
BEGIN
	SELECT *
	FROM subcategorias
	WHERE id_categoria = p_id_categoria
	ORDER BY es_defecto DESC, nombre ASC;
END;