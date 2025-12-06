using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class UsuarioRepositorio : IUsuarioRepositorio
    {
        private readonly ConexionBD _conexion;

        public UsuarioRepositorio()
        {
            _conexion = new ConexionBD();
        }

        public List<Usuario> ObtenerUsuarios()
        {
            var usuarios = new List<Usuario>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("SELECT * FROM usuarios", conn);
            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                usuarios.Add(new Usuario
                {
                    IdUsuario = rdr.GetInt32(0),
                    Nombres = rdr.GetString(1),
                    Apellidos = rdr.GetString(2),
                    CorreoElectronico = rdr.GetString(3),
                    SalarioBase = rdr.GetDecimal(5)
                });
            }

            return usuarios;
        }
    }
}
