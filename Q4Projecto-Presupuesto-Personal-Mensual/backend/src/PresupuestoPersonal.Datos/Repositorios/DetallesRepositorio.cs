using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;    
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

/*
    DetallesRepositorio.cs
    Implementación del repositorio para gestionar las operaciones de datos relacionadas a los detalles del presupuesto.
    Utiliza procedimientos almacenados para interactuar con la base de datos.
*/

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class DetallesRepositorio : IDetallesRepositorio
    {
        private readonly ConexionBD _conexion;

        public DetallesRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }
        public List<DetallesPresupuesto> ObtenerDetallesPorPresupuesto(int idPresupuesto)
        {
            var detalles = new List<DetallesPresupuesto>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_detalles_presupuesto(?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;

            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                detalles.Add(MapearDetallePresupuesto(rdr));
            }

            return detalles;
        }

        public DetallesPresupuesto? ObtenerDetallePorId(int idDetallePresupuesto, int idPresupuesto)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_detalles_presupuesto(?,?)", conn);
            cmd.Parameters.Add("id_detalle_presupuesto", OdbcType.Int).Value = idDetallePresupuesto;
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearDetallePresupuesto(rdr);
            }

            return null;
        }

        public int CrearDetallePresupuesto(DetallesPresupuesto detallePresupuesto, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_crear_detalle_presupuesto(?, ?, ?, ?, ?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = detallePresupuesto.IdPresupuesto;
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = detallePresupuesto.IdSubcategoria;
            cmd.Parameters.Add("monto_asignado", OdbcType.Decimal).Value = detallePresupuesto.MontoAsignado;
            cmd.Parameters.Add("justificacion", OdbcType.NVarChar).Value = detallePresupuesto.Justificacion;
            cmd.Parameters.Add("usuario_creador", OdbcType.NVarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarDetallePresupuesto(DetallesPresupuesto detallePresupuesto, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_detalle_presupuesto(?, ?, ?, ?)", conn);
            cmd.Parameters.Add("id_detalle_presupuesto", OdbcType.Int).Value = detallePresupuesto.IdDetallePresupuesto;
            cmd.Parameters.Add("monto_asignado", OdbcType.Decimal).Value = detallePresupuesto.MontoAsignado;
            cmd.Parameters.Add("justificacion", OdbcType.NVarChar).Value = detallePresupuesto.Justificacion;
            cmd.Parameters.Add("usuario_modificador", OdbcType.NVarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarDetallePresupuesto(int idDetallePresupuesto)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_detalle_presupuesto(?, ?)", conn);
            cmd.Parameters.Add("id_detalle_presupuesto", OdbcType.Int).Value = idDetallePresupuesto;

            return cmd.ExecuteNonQuery() > 0;
        }
        private DetallesPresupuesto MapearDetallePresupuesto(OdbcDataReader rdr)
        {
            return new DetallesPresupuesto
            {
                IdDetallePresupuesto = rdr.GetInt32(0),
                IdPresupuesto = rdr.GetInt32(1),
                IdSubcategoria = rdr.GetInt32(2),
                MontoAsignado = rdr.GetDecimal(3),
                Justificacion = rdr.GetString(4),
                NombreSubcategoria = rdr.GetString(5),
                NombreCategoria = rdr.GetString(6),
                TipoCategoria = rdr.GetString(7)
            };
        }
    }
}