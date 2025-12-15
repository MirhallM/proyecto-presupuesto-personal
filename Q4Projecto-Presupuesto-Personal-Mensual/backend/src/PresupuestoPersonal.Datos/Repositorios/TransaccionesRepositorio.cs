using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

/*
    TransaccionRepositorio.cs
    Implementación del repositorio para gestionar las operaciones de datos relacionadas a las transacciones.
    Utiliza procedimientos almacenados para interactuar con la base de datos.
*/

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class TransaccionesRepositorio : ITransaccionesRepositorio
    {
        private readonly ConexionBD _conexion;

        public TransaccionesRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }

        public List<Transaccion> ObtenerTransacciones(int idPresupuesto, int? anio = null, int? mes = null, string? tipo = null)
        {
            var transacciones = new List<Transaccion>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_transacciones_presupuesto(?, ?, ?, ?)", conn);
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;
            cmd.Parameters.Add("anio", OdbcType.Int).Value = (object?)anio ?? DBNull.Value;
            cmd.Parameters.Add("mes", OdbcType.Int).Value = (object?)mes ?? DBNull.Value;
            cmd.Parameters.Add("tipo", OdbcType.VarChar).Value = 
                string.IsNullOrWhiteSpace(tipo) ? DBNull.Value : tipo;

            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                transacciones.Add(MapearTransaccion(rdr));
            }

            return transacciones;
        }

        public Transaccion? ObtenerTransaccionPorId(int idTransaccion, int idPresupuesto)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_transaccion(?, ?)", conn);
            cmd.Parameters.Add("id_transaccion", OdbcType.Int).Value = idTransaccion;
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = idPresupuesto;   
            
            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearTransaccion(rdr);
            }
            return null;
        }

        public int CrearTransaccion(Transaccion transaccion, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_transaccion(?,?,?,?,?,?,?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = transaccion.IdUsuario;
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = transaccion.IdPresupuesto;
            cmd.Parameters.Add("anio", OdbcType.Int).Value = transaccion.Anio;
            cmd.Parameters.Add("mes", OdbcType.Int).Value = transaccion.Mes;
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = transaccion.IdSubcategoria;

            // id_obligacion puede ser NULL, en ese caso mandar DBNull cuando no venga nada
            cmd.Parameters.Add("id_obligacion", OdbcType.Int).Value =
                transaccion.IdObligacion == 0 ? DBNull.Value : transaccion.IdObligacion;

            cmd.Parameters.Add("tipo", OdbcType.VarChar).Value = transaccion.TipoTransaccion;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = transaccion.Descripcion;
            cmd.Parameters.Add("monto", OdbcType.Decimal).Value = transaccion.Monto;
            cmd.Parameters.Add("fecha_transaccion", OdbcType.Date).Value = transaccion.FechaTransaccion;
            cmd.Parameters.Add("metodo_pago", OdbcType.VarChar).Value = transaccion.MetodoPago;
            cmd.Parameters.Add("num_factura", OdbcType.VarChar).Value = transaccion.NumeroFactura;
            cmd.Parameters.Add("comentarios_extra", OdbcType.VarChar).Value = transaccion.Notas;

            cmd.Parameters.Add("creado_por", OdbcType.VarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarTransaccion(int idTransaccion, Transaccion transaccion, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_transaccion(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", conn);

            cmd.Parameters.Add("id_transaccion", OdbcType.Int).Value = idTransaccion;
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = transaccion.IdUsuario;
            cmd.Parameters.Add("id_presupuesto", OdbcType.Int).Value = transaccion.IdPresupuesto;
            cmd.Parameters.Add("anio", OdbcType.Int).Value = transaccion.Anio;
            cmd.Parameters.Add("mes", OdbcType.Int).Value = transaccion.Mes;
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = transaccion.IdSubcategoria;

            cmd.Parameters.Add("id_obligacion", OdbcType.Int).Value =
                transaccion.IdObligacion == 0 ? DBNull.Value : transaccion.IdObligacion;

            cmd.Parameters.Add("tipo", OdbcType.VarChar).Value = transaccion.TipoTransaccion;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = transaccion.Descripcion;
            cmd.Parameters.Add("monto", OdbcType.Decimal).Value = transaccion.Monto;
            cmd.Parameters.Add("fecha_transaccion", OdbcType.Date).Value = transaccion.FechaTransaccion;
            cmd.Parameters.Add("metodo_pago", OdbcType.VarChar).Value = transaccion.MetodoPago;
            cmd.Parameters.Add("num_factura", OdbcType.VarChar).Value = transaccion.NumeroFactura;
            cmd.Parameters.Add("comentarios_extra", OdbcType.VarChar).Value =
                string.IsNullOrWhiteSpace(transaccion.Notas) ? DBNull.Value : transaccion.Notas;

            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }


        public bool EliminarTransaccion(int idTransaccion)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_transaccion(?)", conn);
            cmd.Parameters.Add("id_transaccion", OdbcType.Int).Value = idTransaccion;

            return cmd.ExecuteNonQuery() > 0;
        }

        private Transaccion MapearTransaccion(OdbcDataReader rdr)
        {
            return new Transaccion
            {
                IdTransaccion = rdr.GetInt32(0),
                IdUsuario = rdr.GetInt32(2),
                IdPresupuesto = rdr.GetInt32(1),
                Anio = rdr.GetInt32(5),
                Mes = rdr.GetInt32(6),
                IdSubcategoria = rdr.GetInt32(3),
                IdObligacion = rdr.IsDBNull(4) ? 0 : rdr.GetInt32(4),
                TipoTransaccion = rdr.GetString(7),
                Descripcion = rdr.GetString(8),
                Monto = rdr.GetDecimal(9),
                FechaTransaccion = rdr.GetDateTime(10),
                MetodoPago = rdr.GetString(11),
                NumeroFactura = rdr.GetString(12),
                Notas = rdr.IsDBNull(13) ? null : rdr.GetString(13)
            };
        }        
    }
}


