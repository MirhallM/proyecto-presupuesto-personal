using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IDetallesRepositorio
    {
        List<DetallesPresupuesto> ObtenerDetallesPorPresupuesto(int idPresupuesto);
        DetallesPresupuesto? ObtenerDetallePorId(int idDetallePresupuesto, int idPresupuesto);
        int CrearDetallePresupuesto(DetallesPresupuesto detallePresupuesto, string usuarioCreador);
        bool ActualizarDetallePresupuesto(DetallesPresupuesto detallePresupuesto, string usuarioModificador);
        bool EliminarDetallePresupuesto(int idDetallePresupuesto);
    }
}