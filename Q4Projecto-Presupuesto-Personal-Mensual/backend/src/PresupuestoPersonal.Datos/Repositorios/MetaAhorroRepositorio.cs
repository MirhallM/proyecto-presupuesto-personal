using System.Data.Odbc;
using PresupuestoPersonal.Datos.Conexion;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class MetaAhorroRepositorio : IMetaAhorroRepositorio
    {
        private readonly ConexionBD _conexion;

        public MetaAhorroRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }

        public List<MetaAhorro> ObtenerMetasPorUsuario(int idUsuario)
        {
            var metas = new List<MetaAhorro>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_metas_usuario(?)", conn);
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = idUsuario;

            using var rdr = cmd.ExecuteReader();
            while (rdr.Read())
            {
                metas.Add(MapearMeta(rdr));
            }

            return metas;
        }

        public MetaAhorro? ObtenerMetaPorId(int idMeta)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_meta(?)", conn);
            cmd.Parameters.Add("id_meta", OdbcType.Int).Value = idMeta;

            using var rdr = cmd.ExecuteReader();
            if (rdr.Read())
            {
                return MapearMeta(rdr);
            }

            return null;
        }

        public int CrearMeta(MetaAhorro meta, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_meta(?,?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = meta.IdUsuario;
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = meta.IdSubcategoria;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = meta.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = meta.Descripcion;
            cmd.Parameters.Add("monto_meta", OdbcType.Decimal).Value = meta.MontoMeta;
            cmd.Parameters.Add("fecha_inicio", OdbcType.Date).Value = meta.FechaInicio;
            cmd.Parameters.Add("fecha_objetivo", OdbcType.Date).Value = meta.FechaObjetivo;
            cmd.Parameters.Add("prioridad", OdbcType.VarChar).Value = meta.Prioridad;
            cmd.Parameters.Add("creado_por", OdbcType.VarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarMeta(MetaAhorro meta, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_meta(?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_meta", OdbcType.Int).Value = meta.IdMeta;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = meta.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = meta.Descripcion;
            cmd.Parameters.Add("monto_meta", OdbcType.Decimal).Value = meta.MontoMeta;
            cmd.Parameters.Add("fecha_objetivo", OdbcType.Date).Value = meta.FechaObjetivo;
            cmd.Parameters.Add("prioridad", OdbcType.VarChar).Value = meta.Prioridad;
            cmd.Parameters.Add("estado", OdbcType.VarChar).Value = meta.Estado;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarMeta(int idMeta)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_meta(?)", conn);
            cmd.Parameters.Add("id_meta", OdbcType.Int).Value = idMeta;

            return cmd.ExecuteNonQuery() > 0;
        }

        private MetaAhorro MapearMeta(OdbcDataReader rdr)
        {
            return new MetaAhorro
            {
                IdMeta = rdr.GetInt32(0),
                IdUsuario = rdr.GetInt32(1),
                IdSubcategoria = rdr.GetInt32(2),
                Nombre = rdr.GetString(3),
                Descripcion = rdr.GetString(4),
                MontoMeta = rdr.GetDecimal(5),
                MontoAhorrado = rdr.GetDecimal(6),
                FechaInicio = rdr.GetDateTime(7),
                FechaObjetivo = rdr.GetDateTime(8),
                Prioridad = rdr.GetString(9),
                Estado = rdr.GetString(10)
            };
        }
    }
}
