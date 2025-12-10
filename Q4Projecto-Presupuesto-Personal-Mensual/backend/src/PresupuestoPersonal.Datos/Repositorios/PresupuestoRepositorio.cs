using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

/*
    PresupuestoRepositorio.cs
    Implementación del repositorio para gestionar las operaciones de datos relacionadas a los presupuestos.
    Utiliza procedimientos almacenados para interactuar con la base de datos.
*/

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class PresupuestoRepositorio : IPresupuestoRepositorio
    {
        private readonly ConexionBD _conexion;

        public PresupuestoRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }
        public List<Presupuesto> ObtenerPresupuestosPorUsuario(int idUsuario, string Estado)
        {
            var presupuestos = new List<Presupuesto>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_presupuestos_usuario(?,?)", conn);
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = idUsuario;
            cmd.Parameters.Add("estado", OdbcType.VarChar).Value = Estado;

            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                presupuestos.Add(MapearPresupuesto(rdr));
            }

            return presupuestos;
        }

        public Presupuesto? ObtenerPorId(int idPresupuesto)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_presupuesto(?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearPresupuesto(rdr);
            }

            return null;
        }

        public int CrearPresupuesto(Presupuesto presupuesto, DateTime PeriodoInicio, DateTime PeriodoFin,  decimal TotalAhorros)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_presupuesto(?,?.?,?,?,?)", conn);
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = presupuesto.IdUsuario;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = presupuesto.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = presupuesto.Descripcion;
            cmd.Parameters.Add("periodo_inicio", OdbcType.Date).Value = PeriodoInicio.Date;
            cmd.Parameters.Add("periodo_fin", OdbcType.Date).Value = PeriodoFin.Date;
            cmd.Parameters.Add("total_ahorros", OdbcType.Decimal).Value = TotalAhorros;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarPresupuesto(
            Presupuesto presupuesto, 
            string usuarioModificador, 
            DateTime PeriodoInicio, 
            DateTime PeriodoFin, 
            decimal TotalAhorros)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_presupuesto(?,?,?,?,?,?,?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = presupuesto.IdPresupuesto;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = presupuesto.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = presupuesto.Descripcion;
            cmd.Parameters.Add("periodo_inicio", OdbcType.Date).Value = PeriodoInicio.Date;
            cmd.Parameters.Add("periodo_fin", OdbcType.Date).Value = PeriodoFin.Date;
            cmd.Parameters.Add("total_ahorros", OdbcType.Decimal).Value = TotalAhorros;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarPresupuesto(int idPresupuesto)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_presupuesto(?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;

            return cmd.ExecuteNonQuery() > 0;
        }
        private Presupuesto MapearPresupuesto(OdbcDataReader rdr)
        {
            return new Presupuesto
            {
                IdPresupuesto = rdr.GetInt32(0),
                IdUsuario = rdr.GetInt32(1),
                Nombre = rdr.GetString(2),
                Descripcion = rdr.GetString(3),
                AnioInicio = rdr.GetInt32(4),
                MesInicio = rdr.GetInt32(5),
                AnioFinal = rdr.GetInt32(6),
                MesFinal = rdr.GetInt32(7),
                TotalIngresos = rdr.GetDecimal(8),
                TotalGastos = rdr.GetDecimal(9),
                TotalAhorros = rdr.GetDecimal(10),
                FechaRegistro = rdr.GetDateTime(11),
                Estado = rdr.GetString(12)
            };
        }
    }
}