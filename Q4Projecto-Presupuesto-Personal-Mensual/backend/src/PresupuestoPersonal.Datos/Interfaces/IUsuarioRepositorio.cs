using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IUsuarioRepositorio
    {
        List<Usuario> ObtenerUsuarios();
    }
}
