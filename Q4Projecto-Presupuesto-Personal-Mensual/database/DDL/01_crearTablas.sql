create or replace table "usuarios"(
  "id_usuario" integer not null identity,
  "nombres" varchar(50) not null,
  "apellidos" varchar(50) not null,
  "correo_electronico" varchar(50) not null,
  "fecha_registro" date not null default current date,
  "salario_base" decimal(10,2) not null,
  es_activo tinyint not null default 1;

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_usuario"),
  unique("correo_electronico"),
  primary key("id_usuario" asc)
)

create or replace table "presupuestos"(
  "id_presupuesto" integer not null identity,
  "id_usuario" integer not null,
  "nombre_presupuesto" varchar(100) not null,
  "descripcion" varchar(255) not null,
  "anio_incio" integer not null,
  "mes_inicio" integer not null,
  "anio_final" integer not null,
  "mes_final" integer not null,
  "total_ingresos" decimal(10,2) not null,
  "total_gastos" decimal(10,2) not null,
  "total_ahorros" decimal(10,2) not null default 0,
  "fecha_creacion" date not null default current date,
  "estado" varchar(16) not null default 'borrador',

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_presupuesto"),
  constraint "id_presupuesto" primary key("id_presupuesto" asc),
  )

create or replace table "categorias"(
  "id_categoria" integer not null identity,
  "nombre" varchar(50) not null,
  "descripcion" varchar(255) not null,
  "tipo_categoria" varchar(16) not null,
  "nombre_icono" varchar(50) null,
  "color" varchar(8) null,
  "orden_interfaz" integer not null,

    --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_categoria"),
  primary key("id_categoria" asc),
  )

create or replace table "subcategorias"(
  "id_subcategoria" integer not null identity,
  "id_categoria" integer not null,
  "nombre" varchar(50) not null,
  "descripcion" varchar(255) not null,
  "es_activo" tinyint not null default 1,
  "es_predeterminado" tinyint not null,


  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_subcategoria"),
  primary key("id_subcategoria" asc),
  )

create or replace table "detalles_presupuesto"(
  "id_detalle" integer not null identity,
  "monto_asignado" decimal(10,2) not null,
  "justificacion" varchar(100) null,
  "id_subcategoria" integer not null,
  "id_presupuesto" integer not null,

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_detalle"),
  primary key("id_detalle" asc),
  )

create or replace table "obligaciones"(
  "id_obligacion" integer not null identity,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null, 
  "nombre" varchar(50) not null,
  "descripcion" varchar(255) not null,
  "monto_fijo" decimal(10,2) not null,
  "dia_vencimiento" integer not null,
  "es_vigente" tinyint not null,
  "fecha_inicio" date not null,
  "fecha_final" date null,

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_obligacion"),
  primary key("id_obligacion" asc),
  )

create or replace table "transacciones"(
  "id_transaccion" integer not null identity,
  "id_presupuesto" integer not null,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null,
  "id_obligacion" integer null,
  "anio_transaccion" integer not null,
  "mes_transaccion" integer not null,
  "tipo_transaccion" varchar(18) not null,
  "descripcion" varchar(255) not null,
  "monto" decimal(10,2) not null,
  "fecha_transaccion" date not null,
  "metodo_pago" varchar(30) not null,
  "numero_factura" integer null,
  "comentarios_extra" varchar(100) null,
  "fecha_hora_registro" timestamp not null,

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

 --Restricciones llave de la llave primaria/valores unicos
  unique("id_transaccion"),
  primary key("id_transaccion" asc),
  )

create or replace table "metas_ahorro"(
  "id_meta" integer not null identity,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null,
  "nombre" varchar(50) not null,
  "descripcion" varchar(255) not null,
  "monto_meta" decimal(10,2) not null,
  "monto_ahorrado" decimal(10,2) not null,
  "fecha_inicio" date not null,
  "fecha_objetivo" date not null,
  "prioridad" varchar(10) not null,
  "estado" varchar(20) not null,

    --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_meta"),
  primary key("id_meta" asc),
  )