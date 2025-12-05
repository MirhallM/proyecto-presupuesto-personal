CREATE OR REPLACE TRIGGER tr_categoria_insert_subcategoria_default
AFTER INSERT
ON categorias
REFERENCING NEW AS nueva_cat
FOR EACH ROW
BEGIN
    -- Crear subcategoría por defecto
    INSERT INTO subcategorias (
        id_categoria,
        nombre,
        descripcion,
        es_activo,
        es_predeterminado,
        creado_por,
        modificado_por
    )
    VALUES (
        nueva_cat.id_categoria,
        'General',
        'Subcategoria por defecto de ' || nueva_cat.nombre,  -- Aquí se usa || en lugar de CONCAT
        1,  -- es_activo
        1,  -- es_predeterminado
        nueva_cat.creado_por,
        nueva_cat.creado_por
    );
END;
