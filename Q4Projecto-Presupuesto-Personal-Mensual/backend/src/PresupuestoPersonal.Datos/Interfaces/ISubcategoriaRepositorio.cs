using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface ISubcategoriaRepositorio
    {
        List<Subcategoria> ObtenerSubcategoriasPorCategoria(int idCategoria);
        Subcategoria? ObtenerPorId(int idSubcategoria);
        int CrearSubcategoria(Subcategoria subcategoria, string usuarioCreador);
        bool ActualizarSubcategoria(Subcategoria subcategoria, string usuarioModificador);
        bool EliminarSubcategoria(int idSubcategoria, string usuarioModificador);
    }
}