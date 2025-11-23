/*Se botan las tablas desde mas dependiente hasta las tablas base o independientes, asi que si se quiere iniciar la base de datos desde 0 se puede hacer
sin tener que borrar el archivo en el que se estan creando las tablas */

DROP TABLE IF EXISTS transacciones;
DROP TABLE IF EXISTS detalles_presupuesto;
DROP TABLE IF EXISTS presupuestos;
DROP TABLE IF EXISTS metas_ahorro;
DROP TABLE IF EXISTS obligaciones;
DROP TABLE IF EXISTS subcategorias
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios;

create table "usuarios"(
  "id_usuario" integer not null,
  "nombres" varchar(50) not null,
  "apellidos" varchar(50) not null,
  "correo_electronico" varchar(50) not null,
  "fecha_registro" date not null default current date,
  "salario_base" decimal(10,2) not null,
  

  --CAMPOS DE AUDITORIA
  "creado_por" varchar(50) not null,
  "modificado_por" varchar(50) not null,
  "creado_en" timestamp not null default current server timestamp,
  "modificado_en" timestamp not null default current server timestamp,

  --Restricciones llave de la llave primaria/valores unicos
  unique("id_usuario"),
  unique("correo_electronico"),
  primary key("id_usuario" asc))

create table "presupuestos"(
  "id_presupuesto" integer not null,
  "id_usuario" integer not null,
  "nombre_presupuesto" varchar(100) not null,
  "anio_incio" integer not null,
  "mes_inicio" integer not null,
  "anio_final" integer not null,
  "mes_final" integer not null,
  "total_ingresos" decimal(10,2) not null,
  "total_gastos" decimal(10,2) not null,
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

create table "categorias"(
  "id_categoria" integer not null,
  "nombre" varchar(50) not null,
  "descripcion" varchar(100) not null,
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

create table "subcategorias"(
  "id_subcategoria" integer not null,
  "id_categoria" integer not null,
  "nombre" varchar(50) not null,
  "descripcion" varchar(100) not null,
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

create table "detalles_presupuesto"(
  "id_detalle" integer not null,
  "monto_asignado" decimal(10,2) not null,
  "justificacion" varchar(50) not null,
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

create table "obligaciones"(
  "id_obligacion" integer not null,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null, 
  "nombre" varchar(50) not null,
  "descripcion" varchar(50) not null,
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

create table "transacciones"(
  "id_transaccion" integer not null,
  "id_presupuesto" integer not null,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null,
  "id_obligacion" integer null,
  "anio_transaccion" integer not null,
  "mes_transaccion" integer not null,
  "tipo_transaccion" varchar(18) not null,
  "descripcion" varchar(100) not null,
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

create table "metas_ahorro"(
  "id_meta" integer not null,
  "id_usuario" integer not null,
  "id_subcategoria" integer not null,
  "nombre" varchar(50) not null,
  "descripcion" varchar(100) not null,
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