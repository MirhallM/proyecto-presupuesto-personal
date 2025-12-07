using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

/*
    CategoriaRepositorio.cs
    Implementación del repositorio para gestionar las operaciones de datos relacionadas a las categorías.
    Utiliza procedimientos almacenados para interactuar con la base de datos.
*/

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class CategoriaRepositorio : ICategoriaRepositorio
    {
        private readonly ConexionBD _conexion;

        public CategoriaRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }
        public List<Categoria> ObtenerCategorias()
        {
            var categorias = new List<Categoria>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_categorias()", conn);
            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                categorias.Add(MapearCategoria(rdr));
            }

            return categorias;
        }

        public Categoria? ObtenerPorId(int idCategoria)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_categoria(?)", conn);
            cmd.Parameters.Add("id_categoria", OdbcType.Int).Value = idCategoria;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearCategoria(rdr);
            }

            return null;
        }

        public int CrearCategoria(Categoria categoria, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_categoria(?, ?, ?, ?)", conn);
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = categoria.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = categoria.Descripcion;
            cmd.Parameters.Add("tipo", OdbcType.VarChar).Value = categoria.TipoCategoria;
            cmd.Parameters.Add("Creado Por", OdbcType.VarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }

        public bool ActualizarCategoria(Categoria categoria, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_categoria(?, ?, ?, ?)", conn);
            cmd.Parameters.Add("id_categoria", OdbcType.Int).Value = categoria.IdCategoria;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = categoria.Nombre;
            cmd.Parameters.Add("tipo", OdbcType.VarChar).Value = categoria.TipoCategoria;
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        public bool EliminarCategoria(int idCategoria, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_categoria(?, ?)", conn);
            cmd.Parameters.Add("id_categoria", OdbcType.Int).Value = idCategoria;
            cmd.Parameters.Add("id_usuario", OdbcType.Int).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }

        private static Categoria MapearCategoria(OdbcDataReader rdr)
        {
            return new Categoria
            {
                IdCategoria = rdr.GetInt32(0),
                Nombre = rdr.GetString(1),
                Descripcion = rdr.GetString(2),
                TipoCategoria = rdr.GetString(3),
                NombreIcono = rdr.IsDBNull(4) ? null : rdr.GetString(4),
                Color = rdr.IsDBNull(5) ? null : rdr.GetString(5),
                OrdenInterfaz = rdr.GetInt32(6)
            };
        }
    }
}