using System.Data.Odbc;
using PresupuestoPersonal.Modelos.Entidades;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Conexion;

/*
    SubcategoriaRepositorio.cs
    Implementación del repositorio para gestionar las operaciones de datos relacionadas a las subcategorías.
    Utiliza procedimientos almacenados para interactuar con la base de datos.
*/

namespace PresupuestoPersonal.Datos.Repositorios
{
    public class SubcategoriaRepositorio : ISubcategoriaRepositorio
    {
        private readonly ConexionBD _conexion;

        public SubcategoriaRepositorio(ConexionBD conexion)
        {
            _conexion = conexion;
        }
        public List<Subcategoria> ObtenerSubcategoriasPorCategoria(int idCategoria)
        {
            var subcategorias = new List<Subcategoria>();

            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_listar_subcategorias_por_categoria(?)", conn);
            cmd.Parameters.Add("id_categoria", OdbcType.Int).Value = idCategoria;

            using var rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                subcategorias.Add(MapearSubcategoria(rdr));
            }

            return subcategorias;
        }
        public Subcategoria? ObtenerPorId(int idSubcategoria)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_consultar_subcategoria(?)", conn);
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = idSubcategoria;

            using var rdr = cmd.ExecuteReader();

            if (rdr.Read())
            {
                return MapearSubcategoria(rdr);
            }

            return null;
        }
        public int CrearSubcategoria(Subcategoria subcategoria, string usuarioCreador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_insertar_subcategoria(?,?,?,?,?)", conn);
            cmd.Parameters.Add("id_categoria", OdbcType.Int).Value = subcategoria.IdCategoria;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = subcategoria.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = subcategoria.Descripcion;
            cmd.Parameters.Add("es_predeterminado", OdbcType.Bit).Value = subcategoria.EsPredeterminado;
            cmd.Parameters.Add("creado_por", OdbcType.VarChar).Value = usuarioCreador;

            return cmd.ExecuteNonQuery();
        }
        public bool ActualizarSubcategoria(Subcategoria subcategoria, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_actualizar_subcategoria(?,?,?,?)", conn);
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = subcategoria.IdSubcategoria;
            cmd.Parameters.Add("nombre", OdbcType.VarChar).Value = subcategoria.Nombre;
            cmd.Parameters.Add("descripcion", OdbcType.VarChar).Value = subcategoria.Descripcion;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }
        public bool EliminarSubcategoria(int idSubcategoria, string usuarioModificador)
        {
            using var conn = _conexion.CrearConexion();
            conn.Open();

            using var cmd = new OdbcCommand("CALL sp_eliminar_subcategoria(?,?)", conn);
            cmd.Parameters.Add("id_subcategoria", OdbcType.Int).Value = idSubcategoria;
            cmd.Parameters.Add("modificado_por", OdbcType.VarChar).Value = usuarioModificador;

            return cmd.ExecuteNonQuery() > 0;
        }
        private Subcategoria MapearSubcategoria(OdbcDataReader rdr)
        {
            return new Subcategoria
            {
                IdSubcategoria = rdr.GetInt32(rdr.GetOrdinal("id_subcategoria")),
                IdCategoria = rdr.GetInt32(rdr.GetOrdinal("id_categoria")),
                Nombre = rdr.GetString(rdr.GetOrdinal("nombre")),
                Descripcion = rdr.GetString(rdr.GetOrdinal("descripcion")),
                EsActivo = rdr.GetBoolean(rdr.GetOrdinal("es_activo")),
                EsPredeterminado = rdr.GetBoolean(rdr.GetOrdinal("es_predeterminado")),
            };
        }
    }
}