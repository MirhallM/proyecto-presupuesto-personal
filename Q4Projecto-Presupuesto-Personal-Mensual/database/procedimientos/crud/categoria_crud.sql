CREATE OR REPLACE PROCEDURE sp_insertar_categoria(
    IN p_nombre varchar(50),
    IN p_descripcion varchar(255),
    IN p_tipo varchar(16),
    IN p_creado_por varchar(50)
)
BEGIN
    DECLARE v_id_categoria INTEGER;

    -- 1. Insertar la nueva categoría
    INSERT INTO categorias(
        nombre,
        descripcion,
        tipo_categoria,
        nombre_icono,
        color,
        creado_por,
        modificado_por
    ) VALUES (
        p_nombre,
        p_descripcion,
        p_tipo,
        NULL,
        NULL,
        p_creado_por,
        p_creado_por
    );
END;



CREATE OR REPLACE PROCEDURE sp_actualizar_categoria(
	IN p_id_categoria integer,
	IN p_nombre varchar(50),
	IN p_descripcion varchar(255),
	IN p_modificado_por varchar(50)
)
BEGIN
	UPDATE categorias SET
		nombre = p_nombre,
		descripcion = p_descripcion,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_categoria = p_id_categoria;
END;

CREATE OR REPLACE PROCEDURE sp_eliminar_categoria(
	IN p_id_categoria integer
)
BEGIN
	DECLARE v_tiene_subcategorias integer;
	
	SELECT COUNT(*) INTO v_tiene_subcategorias
	FROM subcategorias
	WHERE id_categoria = p_id_categoria
	AND es_activo = 1;
	
	IF v_tiene_subcategorias > 0 THEN
		RAISERROR 50000 'No se puede eliminar, tiene subcategor�as activas';
	END IF;
	
	DELETE FROM categorias
	WHERE id_categoria = p_id_categoria;
END;

CREATE OR REPLACE PROCEDURE sp_consultar_categoria(
	IN p_id_categoria integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM categorias
		WHERE id_categoria = p_id_categoria
	) THEN
		RAISERROR 50000 'No hay categor�a con esta ID';
	END IF;
	
	SELECT *
	FROM categorias
	WHERE id_categoria = p_id_categoria;
END;

CREATE OR REPLACE PROCEDURE sp_listar_categorias(
	IN p_id_usuario integer,
	IN p_tipo varchar(16)
)
BEGIN
	SELECT *
	FROM categorias
	WHERE id_usuario = p_id_usuario
	AND (p_tipo IS NULL OR tipo_categoria = p_tipo)
	ORDER BY fecha_creacion DESC;
END;
