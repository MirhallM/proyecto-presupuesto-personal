create or replace procedure "sp_crear_presupuesto_completo"(
	p_id_usuario integer, 
	p_nombre varchar(100), 
	p_descripcion varchar(255), 
	p_periodo_inicio date, 
	p_periodo_fin date, 
	p_lista_subcategorias_json LONG VARCHAR, 
	p_creado_por varchar(50)
)
BEGIN
	DECLARE