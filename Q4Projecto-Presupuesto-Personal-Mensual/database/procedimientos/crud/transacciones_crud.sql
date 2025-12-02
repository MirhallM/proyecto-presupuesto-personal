-- 1) Insertar una nueva transaccion
CREATE OR REPLACE PROCEDURE sp_insertar_transaccion(
	IN p_id_usuario integer,
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	IN p_id_subcategoria integer,
	IN p_id_obligacion integer,
	IN p_tipo varchar(50),
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_fecha date,
	IN p_metodo_pago varchar(50),
	IN p_num_factura varchar(100),
	IN p_comentarios_extra varchar(100),
	IN p_creado_por varchar(50)
)
BEGIN
	INSERT INTO transacciones(
		id_usuario,
		id_presupuesto,
		anio_transaccion,
		mes_transaccion,
		id_subcategoria,
		id_obligacion,
		tipo_transaccion,
		descripcion,
		monto,
		fecha_transaccion,
		metodo_pago,
		num_factura,
		comentarios_extra,
		fecha_hora_registro,
		creado_por,
		modificado_por
	) VALUES (
		p_id_usuario,
		p_id_presupuesto,
		p_anio,
		p_mes,
		p_id_subcategoria,
		p_id_obligacion,
		p_tipo,
		p_descripcion,
		p_monto,
		p_fecha,
		p_metodo_pago,
		p_num_factura,
		p_comentarios_extra,
		CURRENT TIMESTAMP,
		p_creado_por,
		p_creado_por
	);
END;


-- 2) Actualizar una transaccion existente
CREATE OR REPLACE PROCEDURE sp_actualizar_transaccion(
	IN p_id_transaccion integer,
	IN p_anio integer,
	IN p_mes integer,
	IN p_descripcion varchar(255),
	IN p_monto decimal(10,2),
	IN p_fecha date,
	IN p_metodo_pago varchar(50),
	IN p_num_factura varchar(100),
	IN p_comentarios_extra varchar(100),
	IN p_modificado_por varchar(50)
)
BEGIN
	UPDATE transacciones SET
		anio_transaccion = p_anio,
		mes_transaccion = p_mes,
		descripcion = p_descripcion,
		monto = p_monto,
		fecha = p_fecha,
		metodo_pago = p_metodo_pago,
		num_factura = p_num_factura,
		comentarios_extra = p_comentarios_extra,
		modificado_por = p_modificado_por,
		modificado_en = CURRENT TIMESTAMP
	WHERE id_transaccion = p_id_transaccion;
END;


-- 3) Eliminar una transaccion
CREATE OR REPLACE PROCEDURE sp_eliminar_transaccion(
	IN p_id_transaccion integer
)
BEGIN
	DELETE FROM transacciones
	WHERE id_transaccion = p_id_transaccion;
	
END;


-- 4) Consultar una transaccion por ID
CREATE OR REPLACE PROCEDURE sp_consultar_transaccion(
	IN p_id_transaccion integer
)
BEGIN
	IF NOT EXISTS (
		SELECT 1
		FROM transacciones
		WHERE id_transaccion = p_id_transaccion
	) THEN
		RAISERROR 50000 'No hay transacción con esta ID';
	END IF;
	
	SELECT *
	FROM transacciones
	WHERE id_transaccion = p_id_transaccion;
END;


-- 5) Listar transacciones de un presupuesto con filtros opcionales
CREATE OR REPLACE PROCEDURE sp_listar_transacciones_presupuesto(
	IN p_id_presupuesto integer,
	IN p_anio integer,
	IN p_mes integer,
	IN p_tipo varchar(50)
)
BEGIN
	SELECT *
	FROM transacciones
	WHERE id_presupuesto = p_id_presupuesto
	AND (p_anio IS NULL OR anio_transaccion = p_anio)
	AND (p_mes IS NULL OR mes_transaccion = p_mes)
	AND (p_tipo IS NULL OR tipo_transaccion = p_tipo)
	ORDER BY fecha DESC;
END;