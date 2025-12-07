using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface ICategoriaRepositorio
    {
        List<Categoria> ObtenerCategorias();
        Categoria? ObtenerPorId(int idCategoria);
        int CrearCategoria(Categoria categoria, string usarioCreador);
        bool ActualizarCategoria(Categoria categoria, string usuarioModificador);
        bool EliminarCategoria(int idCategoria, string usuarioModificador);
    }
}