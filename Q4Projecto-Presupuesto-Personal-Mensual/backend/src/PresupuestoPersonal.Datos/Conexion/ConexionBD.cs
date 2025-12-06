using System.Data.Odbc;

namespace PresupuestoPersonal.Datos.Conexion
{
    public class ConexionBD
    {
        private readonly string _cadena = "DSN=PresupuestoDSN;UID=admin;PWD=contra;";

        public OdbcConnection CrearConexion()
        {
            return new OdbcConnection(_cadena);
        }
    }
}
