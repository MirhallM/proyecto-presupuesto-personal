-- INSERTAR PRESUPUESTO
CREATE OR REPLACE PROCEDURE sp_insertar_presupuesto(
    IN p_id_usuario integer,
    IN p_nombre varchar(100),
    IN p_descripcion varchar(255),
    IN p_periodo_inicio date,
    IN p_periodo_fin date,
    IN p_total_ahorros decimal(10,2) -- Total de ahorros esperados
)
BEGIN
    DECLARE v_anio_inicio integer;
    DECLARE v_mes_inicio integer;
    DECLARE v_anio_final integer;
    DECLARE v_mes_final integer;
    DECLARE v_total_ingresos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total_gastos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_creador varchar(50);

    SET v_anio_inicio = YEAR(p_periodo_inicio);
    SET v_mes_inicio = MONTH(p_periodo_inicio);
    SET v_anio_final = YEAR(p_periodo_fin);
    SET v_mes_final = MONTH(p_periodo_fin);

    SELECT nombres 
    INTO v_creador
    FROM usuarios
    WHERE id_usuario = p_id_usuario;

    IF v_creador IS NULL THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;

    IF v_anio_final < v_anio_inicio THEN
        RAISERROR 20000 'El año final no puede ser menor que el año inicial';
    END IF;

    IF v_anio_final = v_anio_inicio AND v_mes_final < v_mes_inicio THEN
        RAISERROR 20000 'El mes final no puede ser menor que el mes de inicio dentro del mismo año';
    END IF;

    IF EXISTS (
        SELECT 1 FROM presupuestos
        WHERE estado = 'activo'
          AND id_usuario = p_id_usuario
          AND (
              (anio_incio < v_anio_final OR (anio_incio = v_anio_final AND mes_inicio <= v_mes_final))
              AND
              (anio_final > v_anio_inicio OR (anio_final = v_anio_inicio AND mes_final >= v_mes_inicio))
          )
    ) THEN
       RAISERROR 20000 'Ya existe un presupuesto activo en el periodo';
    END IF;

    INSERT INTO presupuestos (
        id_usuario,
        nombre_presupuesto,
        descripcion,
        anio_incio,
        mes_inicio,
        anio_final,
        mes_final,
        total_ahorros,
        estado,
        creado_por,
        modificado_por
    ) VALUES (
        p_id_usuario,
        p_nombre,
        p_descripcion,
        v_anio_inicio,
        v_mes_inicio,
        v_anio_final,
        v_mes_final,
        p_total_ahorros,
        'activo',
        v_creador,
        v_creador
    );

        -- Calcular total_gastos
    SELECT SUM(json_array[[row_num]].monto_mensual) INTO v_total_gastos
    FROM sa_rowgenerator(1, CARDINALITY(json_array));

    -- Calcular total_ingresos del salario_base del usuario
    SELECT salario_base INTO v_total_ingresos
    FROM usuarios
    WHERE id_usuario = p_id_usuario;

    -- Actualizar totales de presupuesto
    UPDATE presupuestos
    SET total_gastos = v_total_gastos,
        total_ingresos = v_total_ingresos
    WHERE id_presupuesto = v_id_presupuesto;
END;

-- ACTUALIZAR PRESUPUESTO
CREATE OR REPLACE PROCEDURE sp_actualizar_presupuesto(
    IN p_id_presupuesto integer,
    IN p_nombre varchar(100),
    IN p_descripcion varchar(255),
    IN p_periodo_inicio date,
    IN p_periodo_fin date,
    IN p_total_ahorros decimal(10,2), -- Total de ahorros esperados
    IN p_modificado_por varchar(50)
)
BEGIN
    DECLARE v_anio_inicio integer;
    DECLARE v_mes_inicio integer;
    DECLARE v_anio_final integer;
    DECLARE v_mes_final integer;

    -- Validar que el presupuesto exista
    IF NOT EXISTS (SELECT 1 FROM presupuestos WHERE id_presupuesto = p_id_presupuesto) THEN
        RAISERROR 50003 'El presupuesto no existe';
    END IF;

    SET v_anio_inicio = YEAR(p_periodo_inicio);
    SET v_mes_inicio = MONTH(p_periodo_inicio);
    SET v_anio_final = YEAR(p_periodo_fin);
    SET v_mes_final = MONTH(p_periodo_fin);

    IF v_anio_final < v_anio_inicio THEN
        RAISERROR 20000 'El año final no puede ser menor que el año inicial';
    END IF;

    IF v_anio_final = v_anio_inicio AND v_mes_final < v_mes_inicio THEN
        RAISERROR 20000 'El mes final no puede ser menor que el mes de inicio dentro del mismo año';
    END IF;

    -- Verificar que no exista otro presupuesto activo que choque con estas fechas
    IF EXISTS (
        SELECT 1 FROM presupuestos
        WHERE estado = 'activo'
          AND id_presupuesto <> p_id_presupuesto
          AND id_usuario = (SELECT id_usuario FROM presupuestos WHERE id_presupuesto = p_id_presupuesto)
          AND (
              (anio_incio < v_anio_final OR (anio_incio = v_anio_final AND mes_inicio <= v_mes_final))
              AND
              (anio_final > v_anio_inicio OR (anio_final = v_anio_inicio AND mes_final >= v_mes_inicio))
          )
    ) THEN
       RAISERROR 20000 'Ya existe un presupuesto activo en el periodo';
    END IF;

    UPDATE presupuestos
    SET nombre_presupuesto = p_nombre,
        descripcion = p_descripcion,
        anio_incio = v_anio_inicio,
        mes_inicio = v_mes_inicio,
        anio_final = v_anio_final,
        mes_final = v_mes_final,
        total_ahorros = p_total_ahorros,
        modificado_por = p_modificado_por,
        fecha_modificacion = CURRENT DATE
    WHERE id_presupuesto = p_id_presupuesto;

        -- Calcular total_gastos
    SELECT SUM(json_array[[row_num]].monto_mensual) INTO v_total_gastos
    FROM sa_rowgenerator(1, CARDINALITY(json_array));

    -- Calcular total_ingresos del salario_base del usuario
    SELECT salario_base INTO v_total_ingresos
    FROM usuarios
    WHERE id_usuario = p_id_usuario;

    -- Actualizar totales de presupuesto
    UPDATE presupuestos
    SET total_gastos = v_total_gastos,
        total_ingresos = v_total_ingresos
    WHERE id_presupuesto = v_id_presupuesto;
END;


CREATE OR REPLACE PROCEDURE sp_eliminar_presupuesto(
    IN p_id_presupuesto integer
)
BEGIN
    -- Validar que el presupuesto exista
    IF NOT EXISTS (SELECT 1 FROM presupuestos WHERE id_presupuesto = p_id_presupuesto) THEN
        RAISERROR 50003 'El presupuesto no existe';
    END IF;

    -- Marcar como cerrado
    UPDATE presupuestos
    SET estado = 'cerrado',
        fecha_modificacion = CURRENT DATE
    WHERE id_presupuesto = p_id_presupuesto;
END;


CREATE OR REPLACE PROCEDURE sp_consultar_presupuesto(
    IN p_id_presupuesto integer
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM presupuestos WHERE id_presupuesto = p_id_presupuesto) THEN
        RAISERROR 50003 'El presupuesto no existe';
    END IF;

    SELECT * 
    FROM presupuestos
    WHERE id_presupuesto = p_id_presupuesto;
END;


CREATE OR REPLACE PROCEDURE sp_listar_presupuestos_usuario(
    IN p_id_usuario integer,
    IN p_estado varchar(16)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM usuarios WHERE id_usuario = p_id_usuario) THEN
        RAISERROR 50002 'El usuario no existe';
    END IF;

    SELECT *
    FROM presupuestos
    WHERE id_usuario = p_id_usuario
      AND estado = p_estado
    ORDER BY anio_incio, mes_inicio;
END;
