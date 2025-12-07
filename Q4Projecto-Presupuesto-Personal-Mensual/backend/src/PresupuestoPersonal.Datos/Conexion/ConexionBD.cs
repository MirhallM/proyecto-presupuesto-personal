using System.Data.Odbc;

namespace PresupuestoPersonal.Datos.Conexion
{
    public class ConexionBD
    {
        private readonly string _connectionString;

        public ConexionBD(string connectionString)
        {
        _connectionString = connectionString;
        }

        public OdbcConnection CrearConexion()
        {
        return new OdbcConnection(_connectionString);
        }
    }
}
