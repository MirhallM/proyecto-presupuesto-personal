using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IMetaAhorroRepositorio
    {
        List<MetaAhorro> ObtenerMetasPorUsuario(int idUsuario);

        MetaAhorro? ObtenerMetaPorId(int idMeta);

        int CrearMeta(MetaAhorro meta, string usuarioCreador);

        bool ActualizarMeta(MetaAhorro meta, string usuarioModificador);

        bool EliminarMeta(int idMeta);
    }
}
