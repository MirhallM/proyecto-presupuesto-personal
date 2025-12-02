CREATE OR REPLACE PROCEDURE sp_insertar_usuario(
	IN p_nombre varchar(50),
	IN p_apellido varchar(50),
	IN p_email varchar(50),
	IN p_salario_mensual decimal(10,2), 
	IN p_creado_por varchar(50)
)
BEGIN
INSERT INTO usuarios(
	nombres,
	apellidos,
	correo_electronico,
	salario_base,
	creado_por,
	modificado_por
) VALUES (
	p_nombre,
	p_apellido,
	p_email,
	p_salario_mensual,
	p_creado_por,
	p_creado_por
);
END;

CREATE OR REPLACE PROCEDURE sp_actualizar_usuario(
	p_id_usuario integer,
	p_nombre varchar(50),
	p_apellido varchar(50),
	p_salario_mensual decimal(10,2),
	p_modificado_por varchar(50)
)
BEGIN 
	UPDATE usuarios set 
	nombres			= p_nombre,
	apellidos		= p_apellido,
	salario_base	= p_salario_mensual,
	modificado_por	= p_modificado_por,
	modificado_en	= current server timestamp
	WHERE id_usuario= p_id_usuario;
END;
		
CREATE OR REPLACE PROCEDURE sp_eliminar_usuario(p_id_usuario integer)
BEGIN 
	UPDATE usuarios 
	SET es_activo = 0
	WHERE id_usuario= p_id_usuario;

END;

CREATE OR REPLACE PROCEDURE sp_consultar_usuario(p_id_usuario integer)
BEGIN 
IF NOT EXISTS (
    SELECT 1
    FROM usuarios
    WHERE id_usuario = p_id_usuario
) THEN
    RAISERROR 50001 'No hay usuario con esta ID';
END IF;

	SELECT * 
	FROM usuarios 
	WHERE id_usuario = p_id_usuario;
END;

CREATE OR REPLACE PROCEDURE sp_listar_usuarios()
BEGIN
    SELECT *
    FROM usuarios
    ORDER BY id_usuario DESC;
END;