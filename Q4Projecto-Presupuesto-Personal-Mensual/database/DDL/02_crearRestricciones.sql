--Restricciones y llaves foraneas de presupuestos
alter table "presupuestos" add
  "usuarios" not null foreign key("id_usuario" asc) references "usuarios"("id_usuario")

alter table "presupuestos" alter "mes_inicio" add constraint "check_mes_inicio" check("presupuestos"."mes_inicio" between 1 and 12)

alter table "presupuestos" alter "mes_final" add constraint "check_mes_final" check("presupuestos"."mes_final" between 1 and 12)

alter table "presupuestos" alter "estado" add constraint "check_estado_presupuesto" check("presupuestos"."estado" in( 'activo','cerrado','borrador' ) )


--Restricciones y llaves foraneas de categorias
alter table "categorias" alter "tipo_categoria" add constraint "check_tipo_categoria" check("categorias"."tipo_categoria" in( 'ingreso','gasto','ahorro' ) )

alter table "categorias" alter "color" add constraint "check_color_categoria" check("categorias"."color" like '#[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f]') 

--Restricciones y llaves foraneas de subcategorias
alter table "subcategorias" add
  "categorias" not null foreign key("id_categoria" asc) references "categorias"("id_categoria")

alter table "subcategorias" alter "es_activo" add constraint "check_activo_subc" check("subcategorias"."es_activo" in( 0,1 ) ) 


--Restricciones y llaves foraneas de detalles_presupuesto
alter table "detalles_presupuesto" add
  "subcategorias" not null foreign key("id_subcategoria" asc) references "subcategorias"("id_subcategoria") 

alter table "detalles_presupuesto" add
  "presupuestos" not null foreign key("id_presupuesto" asc) references "presupuestos"("id_presupuesto") 


--Restricciones y llaves foraneas de obligaciones
alter table "obligaciones" add
  "usuarios" not null foreign key("id_usuario" asc) references "usuarios"("id_usuario")

alter table "obligaciones" add
  "subcategorias" not null foreign key("id_subcategoria" asc) references "subcategorias"("id_subcategoria") 

alter table "obligaciones" alter "dia_vencimiento" add constraint "check_dia_vencimiento" check("obligaciones"."dia_vencimiento" between 1 and 31) 

alter table "obligaciones" alter "es_vigente" add constraint "check_vigente" check("obligaciones"."es_vigente" in( 0,1 ) )


--Restricciones y llaves foraneas de transacciones
alter table "transacciones" add
  "presupuestos" not null foreign key("id_presupuesto" asc) references "presupuestos"("id_presupuesto")

alter table "transacciones" add
  "usuarios" not null foreign key("id_usuario" asc) references "usuarios"("id_usuario") 

alter table "transacciones" add
  "subcategorias" not null foreign key("id_subcategoria" asc) references "subcategorias"("id_subcategoria")

alter table "transacciones" add
  "obligaciones" foreign key("id_obligacion" asc) references "obligaciones"("id_obligacion")

alter table "transacciones" alter "mes_transaccion" add constraint "check_mes_transaccion" check("transacciones"."mes_transaccion" between 1 and 12)

alter table "transacciones" alter "tipo_transaccion" add constraint "check_tipo_transaccion" check("transacciones"."tipo_transaccion" in( 'ingreso','ahorro','gasto' ) )

alter table "transacciones" alter "metodo_pago" add constraint "check_metodo_pago" check("transacciones"."metodo_pago" in( 'efectivo','tarjeta_debito','tarjeta_credito','transferencia' ) )


--Restricciones y llaves foraneas de metas_ahorro
alter table "metas_ahorro" add
  "usuarios" not null foreign key("id_usuario" asc) references "usuarios"("id_usuario")

alter table "metas_ahorro" add
  "subcategorias" not null foreign key("id_subcategoria" asc) references "subcategorias"("id_subcategoria")

alter table "metas_ahorro" alter "prioridad" add constraint "check_prioridad" check("metas_ahorro"."prioridad" in( 'Alta','Media','Baja' ) )

alter table "metas_ahorro" alter "estado" add constraint "check_estado_meta" check("metas_ahorro"."estado" in( 'en_progreso','completada','cancelada','pausada' ) )