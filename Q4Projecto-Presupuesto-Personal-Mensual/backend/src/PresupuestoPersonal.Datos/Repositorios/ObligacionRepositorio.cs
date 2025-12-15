using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class ObligacionRepositorio : IObligacionRepositorio
    {
        private readonly ConexionBD _conexion;

        public ObligacionRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }

        public List<Obligacion> ObtenerObligacionesPorUsuario(int idUsuario, int? esVigente = null)
        {
            var obligaciones = new List<Obligacion>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_obligaciones_usuario(?, ?)", conn);
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = idUsuario;
            cmd.Parameters.Add("es_vigente", OdbcType.Int).Value =
                esVigente.HasValue ? esVigente.Value : DBNull.Value;

            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                obligaciones.Add(MapearObligacion(rdr));
            }

            return obligaciones;
        }

        public Obligacion? ObtenerPorId(int idObligacion)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_obligacion(?)", conn);
            cmd.Parameters.Add("id_obligacion", OdbcType.Int).Value = idObligacion;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearObligacionDetalle(rdr);
            }

            return null;
        }

        public int CrearObligacion(Obligacion obligacion, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_obligacion(?,?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = obligacion.IdUsuario;
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = obligacion.IdSubcategoria;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = obligacion.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = obligacion.Descripcion;
            cmd.Parameters.Add("monto", OdbcType.Decimal).Value = obligacion.MontoFijo;
            cmd.Parameters.Add("dia_vencimiento", OdbcType.Int).Value = obligacion.DiaVencimiento;
            cmd.Parameters.Add("fecha_inicio", OdbcType.Date).Value = obligacion.FechaInicio;
            cmd.Parameters.Add("fecha_fin", OdbcType.Date).Value =
                obligacion.FechaFin.HasValue ? obligacion.FechaFin.Value : DBNull.Value;
            cmd.Parameters.Add("creado_por", OdbcType.VarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarObligacion(Obligacion obligacion, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_obligacion(?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_obligacion", OdbcType.Int).Value = obligacion.IdObligacion;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = obligacion.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = obligacion.Descripcion;
            cmd.Parameters.Add("monto", OdbcType.Decimal).Value = obligacion.MontoFijo;
            cmd.Parameters.Add("dia_vencimiento", OdbcType.Int).Value = obligacion.DiaVencimiento;
            cmd.Parameters.Add("fecha_fin", OdbcType.Date).Value =
                obligacion.FechaFin.HasValue ? obligacion.FechaFin.Value : DBNull.Value;
            cmd.Parameters.Add("activo", OdbcType.Int).Value = obligacion.EsVigente;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarObligacion(int idObligacion)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_obligacion(?)", conn);
            cmd.Parameters.Add("id_obligacion", OdbcType.Int).Value = idObligacion;

            return cmd.ExecuteNonQuery() > 0;
        }


        private Obligacion MapearObligacion(OdbcDataReader rdr)
        {
            return new Obligacion
            {
                IdObligacion = rdr.GetInt32(0),
                IdUsuario = rdr.GetInt32(1),
                IdSubcategoria = rdr.GetInt32(2),
                Nombre = rdr.GetString(3),
                Descripcion = rdr.GetString(4),
                MontoFijo = rdr.GetDecimal(5),
                DiaVencimiento = rdr.GetInt32(6),
                FechaInicio = rdr.GetDateTime(7),
                FechaFin = rdr.IsDBNull(8) ? null : rdr.GetDateTime(8),
                EsVigente = rdr.GetInt32(9) == 1,
                NombreSubcategoria = rdr.GetString(10),
                NombreCategoria = rdr.GetString(11)
            };
        }

        private Obligacion MapearObligacionDetalle(OdbcDataReader rdr)
        {
            return new Obligacion
            {
                IdObligacion = rdr.GetInt32(0),
                IdUsuario = rdr.GetInt32(1),
                IdSubcategoria = rdr.GetInt32(2),
                Nombre = rdr.GetString(3),
                Descripcion = rdr.GetString(4),
                MontoFijo = rdr.GetDecimal(5),
                DiaVencimiento = rdr.GetInt32(6),
                EsVigente = rdr.GetInt32(7) == 1,
                FechaInicio = rdr.GetDateTime(8),
                FechaFin = rdr.IsDBNull(9) ? null : rdr.GetDateTime(9),
                NombreSubcategoria = rdr.GetString(10),
                NombreCategoria = rdr.GetString(11)
            };
        }
    }
}
