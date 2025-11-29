 CREATE OR REPLACE PROCEDURE "sp_crear_presupuesto_completo"(
    IN p_id_usuario integer,
    IN p_nombre varchar(100), --Nombre del presupuesto
    IN p_descripcion varchar(255),  --Descripcion del presupuesto
    IN p_periodo_inicio date,   -- Fecha inicio del presupuesto
    IN p_periodo_fin date, -- Fecha fin del presupuesto
    IN p_lista_subcategorias_json LONG VARCHAR -- JSON array de {id_subcategoria, monto_mensual}   
)
BEGIN
    --Varibales para sostener los valores iniciales de mes/año y las otras variables requeridas
    DECLARE v_anio_inicio integer;
    DECLARE v_mes_inicio integer;
    DECLARE v_anio_final integer;
    DECLARE v_mes_final integer;
    DECLARE v_total_ingresos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_total_gastos DECIMAL(10,2) DEFAULT 0;
    DECLARE v_id_presupuesto integer;

    --Variables del archivo JSON para el id_subcategoria y monto mensual
    DECLARE v_subcategoria integer;
    DECLARE v_monto integer; 

    --Conseguir el mes/año de las fechas ingresadas
    SET v_anio_inicio = YEAR(p_periodo_inicio);
    SET v_mes_inicio = MONTH(p_periodo_inicio);
    SET v_anio_final = YEAR(p_periodo_fin);
    SET v_mes_final = MONTH(p_periodo_fin);

    --Verificar que las fechas cumplan las reglas de negocio
    --El año final debe ser mayor o igual al año inicial
    IF v_anio_inicio < v_anio_final THEN 
        RAISERROR 20000 'El año final no puede ser menor que el año inicial'
    END IF;
    
    --En el caso de que los años sean iguales, entonces el mes final tiene que ser mayor o igual al mes inicial
    IF v_anio_final = v_anio_inicio AND v_mes_final < v_mes_inicio THEN
        RAISERROR 20000 'El mes final no puede ser menor que el mes de inicio dentro del mismo año'
    END IF;
    
    -- Agregar revision de que no exista un presupuesto activo dentro del periodo establecido
    IF EXISTS (
        SELECT 1 FROM presupuestos
        WHERE estado = 'activo' -- Only active budgets
          AND id_usuario = p_id_usuario
          AND (
              (anio_incio < v_anio_fin OR (anio_incio = v_anio_fin AND mes_inicio <= v_mes_fin))
              AND
              (anio_final > v_anio_inicio OR (anio_final = v_anio_inicio AND mes_final >= v_mes_inicio))
          )
    ) THEN
       RAISERROR 20000 'Ya existe un presupuesto activo en el periodo';
    END IF;

    BEGIN
        -- 1) Insertar registro en presupuestos
        INSERT INTO presupuestos (
            id_usuario,
            nombre_presupuesto,
            descripcion,
            anio_incio,
            mes_inicio,
            anio_final,
            mes_final,
            total_ingresos,
            total_gastos,
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
            v_total_ingresos,
            0.00,
            'activo',
            p_nombre,
            p_nombre
        );

    --Conseguir el id del presupuesto generado al hacer el nuevo presupuesto
    SET v_id_presupuesto = @@IDENTITY;
   
   -- Leer tabla JSON de las subcategorias a una tabla temporal
    DROP VARIABLE IF EXISTS json_array;
    CALL sp_parse_json('json_array', p_lista_subcategorias_json, 2);

    -- Insertar registros a detalles_presupuesto usando los valores del archivo JSON
    -- https://help.sap.com/docs/SAP_SQL_Anywhere/93079d4ba8e44920ae63ffb4def91f5b/81793e416ce210148f98935c8ef5e212.html?q=JSON
    INSERT INTO detalles_presupuesto(
        monto_asignado, id_subcategoria, id_presupuesto, justificacion, creado_por, modificado_por)
    SELECT 
        json_array[[row_num]].monto_mensual,
        json_array[[row_num]].id_subcategoria,
        v_id_presupuesto,
        NULL,
        p_nombre,
        p_nombre
    FROM sa_rowgenerator(1, CARDINALITY(json_array));

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
END;

/* DATOS DE PRUEBA para esta funcion
CALL sp_crear_presupuesto_completo(
    1,
    'Presupuesto de prueba',
    'Descripcion prueba',
    '2025-11-01',
    '2025-11-30',
    '[{"id_subcategoria":101,"monto_mensual":200.00},{"id_subcategoria":102,"monto_mensual":150.00}]',
    );
*/