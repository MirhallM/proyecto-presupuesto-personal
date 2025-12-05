-- MASTER SCRIPT PARA CONSTRUIR TODA LA BASE DE DATOS
-- Proyecto de Presupuestos SQL Anywhere

-- IMPORTANTE:
-- Este archivo asume que la base de datos YA EXISTE,
-- porque SQL Anywhere no permite CREATE DATABASE dentro de scripts.

-- 1. CREACIÓN DE TABLAS

READ 'DDL/01_crearTablas.sql';

-- 2. CREACIÓN DE RESTRICCIONES (FK, UNIQUE, CHECK)

READ 'DDL/02_crearRestricciones.sql';

-- 3. CREACIÓN DE FUNCIONES

-- Funciones principales
READ 'funciones/fn_calcular_monto_ejecutado.sql';
READ 'funciones/fn_calcular_porcentaje_ejecutado.sql';
READ 'funciones/fn_calcular_proyeccion_gasto_mensual.sql';
READ 'funciones/fn_dias_hasta_vencimiento.sql';
READ 'funciones/fn_obtener_balance_subcategoria.sql';
READ 'funciones/fn_obtener_categoria_por_subcategoria.sql';
READ 'funciones/fn_obtener_promedio_gasto_subcategoria.sql';
READ 'funciones/fn_obtener_total_categoria_mes.sql';
READ 'funciones/fn_obtener_total_ejecutado_categoria_mes.sql';
READ 'funciones/fn_validar_vigencia_presupuesto.sql';

-- 4. CRUD (PROCEDIMIENTOS DE OPERACIONES BÁSICAS)

READ 'procedimientos/crud/categoria_crud.sql';
READ 'procedimientos/crud/detalles_presupuesto_crud.sql';
READ 'procedimientos/crud/metas_ahorro_crud.sql';
READ 'procedimientos/crud/obligaciones_crud.sql';
READ 'procedimientos/crud/presupuestos_crud.sql';
READ 'procedimientos/crud/subcategorias_crud.sql';
READ 'procedimientos/crud/transacciones_crud.sql';
READ 'procedimientos/crud/usuarios_crud.sql';

-- 5. PROCEDIMIENTOS DE LÓGICA DE NEGOCIO

READ 'procedimientos/Logicas de Negocio/RN_actualizar_todas_metas_ahorro.sql';
READ 'procedimientos/Logicas de Negocio/RN_calcular_balance_mensual.sql';
READ 'procedimientos/Logicas de Negocio/RN_calcular_monto_ejecutado_mes.sql';
READ 'procedimientos/Logicas de Negocio/RN_calcular_porcentaje_ejecucion_mes.sql';
READ 'procedimientos/Logicas de Negocio/rn_cerrar_presupuesto.sql';
READ 'procedimientos/Logicas de Negocio/RN_crear_presupuesto_completo.sql';
READ 'procedimientos/Logicas de Negocio/RN_crear_transaccion_completa.sql';
READ 'procedimientos/Logicas de Negocio/RN_obtener_resumen_categoria_mes.sql';

-- 6. TRIGGERS

READ 'triggers/tr_actualizar_meta_ahorro.sql';
READ 'triggers/tr_categoria_insert_subcategoria_default.sql';

-- 7. CARGA DE DATOS DE PRUEBA 

READ 'datos_prueba/datos_prueba.sql';

-- FIN DEL MASTER SCRIPT
