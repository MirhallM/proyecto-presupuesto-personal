-- 1) Insertar una nueva categoria
CREATE PROCEDURE sp_insertar_categoria(
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_tipo VARCHAR(50),
    IN p_id_usuario INT,
    IN p_creado_por VARCHAR(100)
)
BEGIN
    INSERT INTO categorias (
        nombre,
        descripcion,
        tipo,
        id_usuario,
        creado_por,
        fecha_creacion
    )
    VALUES (
        p_nombre,
        p_descripcion,
        p_tipo,
        p_id_usuario,
        p_creado_por,
        NOW()
    );
    
    SELECT @@IDENTITY AS id_categoria;
END;


-- 2) Actualizar una categoria existente
CREATE PROCEDURE sp_actualizar_categoria(
    IN p_id_categoria INT,
    IN p_nombre VARCHAR(100),
    IN p_descripcion VARCHAR(255),
    IN p_modificado_por VARCHAR(100)
)
BEGIN
    DECLARE filas_afectadas INT;
   
    UPDATE categorias
    SET nombre = p_nombre,
        descripcion = p_descripcion,
        modificado_por = p_modificado_por,
        fecha_modificacion = NOW()
    WHERE id_categoria = p_id_categoria;
    
    SET filas_afectadas = ROWCOUNT;
    
    IF filas_afectadas > 0 THEN
        SELECT 1 AS resultado, 'Categoría actualizada correctamente' AS mensaje;
    ELSE
        SELECT 0 AS resultado, 'No se encontró la categoría' AS mensaje;
    END IF;
END;


-- 3) Eliminar una categoria
CREATE PROCEDURE sp_eliminar_categoria(
    IN p_id_categoria INT
)
BEGIN
    DECLARE v_tiene_subcategorias INT;
    DECLARE filas_afectadas INT;
    
    SELECT COUNT(*) INTO v_tiene_subcategorias
    FROM categorias
    WHERE id_categoria_padre = p_id_categoria
    AND estado = 'activo';
    
    IF v_tiene_subcategorias > 0 THEN
        SELECT 0 AS resultado, 'No se puede eliminar, tiene subcategorías activas' AS mensaje;
        RETURN;
    END IF;
    
    DELETE FROM categorias
    WHERE id_categoria = p_id_categoria;
    
    SET filas_afectadas = ROWCOUNT;
    
    IF filas_afectadas > 0 THEN
        SELECT 1 AS resultado, 'Categoría eliminada correctamente' AS mensaje;
    ELSE
        SELECT 0 AS resultado, 'No se encontró la categoría' AS mensaje;
    END IF;
END;


-- 4) Consultar una categoria por su ID
CREATE PROCEDURE sp_consultar_categoria(
    IN p_id_categoria INT
)
BEGIN
    SELECT 
        id_categoria,
        nombre,
        descripcion,
        tipo,
        id_usuario,
        id_categoria_padre,
        estado,
        creado_por,
        fecha_creacion,
        modificado_por,
        fecha_modificacion
    FROM categorias
    WHERE id_categoria = p_id_categoria;
END;


-- 5) Listar todas las categorias de un usuario
CREATE PROCEDURE sp_listar_categorias(
    IN p_id_usuario INT,
    IN p_tipo VARCHAR(50) DEFAULT NULL
)
BEGIN
    SELECT 
        id_categoria,
        nombre,
        descripcion,
        tipo,
        id_categoria_padre,
        estado,
        fecha_creacion
    FROM categorias
    WHERE id_usuario = p_id_usuario
    AND (p_tipo IS NULL OR tipo = p_tipo)
    ORDER BY fecha_creacion DESC;
END;
