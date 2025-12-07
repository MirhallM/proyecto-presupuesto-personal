using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class UsuarioRepositorio : IUsuarioRepositorio
    {
        private readonly ConexionBD _conexion;

        public UsuarioRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }

        public List<Usuario> ObtenerUsuarios()
        {
            var usuarios = new List<Usuario>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_usuarios()", conn);
            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                usuarios.Add(MapearUsuario(rdr));
            }

            return usuarios;
        }

        public Usuario? ObtenerPorId(int idUsuario)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_usuario(?)", conn);
            cmd.Parameters.Add("id", OdbcType.Int).Value = idUsuario;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearUsuario(rdr);
            }

            return null;
        }

        public int CrearUsuario(Usuario usuario)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_usuario(?,?,?,?,?)", conn);
            cmd.Parameters.Add("nombres", OdbcType.VarChar).Value = usuario.Nombres;
            cmd.Parameters.Add("apellidos", OdbcType.VarChar).Value = usuario.Apellidos;
            cmd.Parameters.Add("correo", OdbcType.VarChar).Value = usuario.CorreoElectronico;
            cmd.Parameters.Add("salario", OdbcType.Decimal).Value = usuario.SalarioBase;
            cmd.Parameters.Add("creado_por", OdbcType.VarChar).Value = usuario.Nombres;

            return Convert.ToInt32(cmd.ExecuteScalar());
        }

        public bool ActualizarUsuario(Usuario usuario)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_usuario(?,?,?,?,?)", conn);

            cmd.Parameters.Add("id", OdbcType.Int).Value = usuario.IdUsuario;
            cmd.Parameters.Add("nombres", OdbcType.VarChar).Value = usuario.Nombres;
            cmd.Parameters.Add("apellidos", OdbcType.VarChar).Value = usuario.Apellidos;
            cmd.Parameters.Add("salario", OdbcType.Decimal).Value = usuario.SalarioBase;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuario.ModificadoPor;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarUsuario(int idUsuario)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_usuario(?)", conn);
            cmd.Parameters.Add("id", OdbcType.Int).Value = idUsuario;

            return cmd.ExecuteNonQuery() > 0;
        }

        private static Usuario MapearUsuario(OdbcDataReader rdr)
        {
            /* No queria escribir esto dos veces :) , ademas se mira mejor asi*/
            return new Usuario
            {
                IdUsuario = rdr.GetInt32(0),
                Nombres = rdr.GetString(1),
                Apellidos = rdr.GetString(2),
                CorreoElectronico = rdr.GetString(3),
                FechaRegistro = rdr.GetDateTime(4),
                SalarioBase = rdr.GetDecimal(5),
                EsActivo = rdr.GetInt32(6) == 1,
                CreadoPor = rdr.GetString(7),
                ModificadoPor = rdr.GetString(8),
                CreadoEn = rdr.GetDateTime(9),
                ModificadoEn = rdr.GetDateTime(10)
            };
        }

        public List<Usuario> ObtenerUsuariosInactivos()
        {
            var usuarios = new List<Usuario>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_usuarios_inactivos()", conn);
            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                usuarios.Add(MapearUsuario(rdr));
            }

            return usuarios;
        }
    }
}
