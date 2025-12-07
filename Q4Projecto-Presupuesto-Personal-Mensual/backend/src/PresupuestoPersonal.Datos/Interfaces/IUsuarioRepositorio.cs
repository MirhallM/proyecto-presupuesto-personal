using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IUsuarioRepositorio
    {
        List<Usuario> ObtenerUsuarios();
        Usuario? ObtenerPorId(int idUsuario);
        int CrearUsuario(Usuario usuario);
        bool ActualizarUsuario(Usuario usuario);
        bool EliminarUsuario(int idUsuario);
        List<Usuario> ObtenerUsuariosInactivos();
    }
}
