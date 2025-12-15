using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IObligacionRepositorio
    {
        List<Obligacion> ObtenerObligacionesPorUsuario(
            int idUsuario,
            int? esVigente = null
        );

        Obligacion? ObtenerPorId(int idObligacion);

        int CrearObligacion(Obligacion obligacion, string usuarioCreador);

        bool ActualizarObligacion(Obligacion obligacion, string usuarioModificador);

        bool EliminarObligacion(int idObligacion);
    }
}
