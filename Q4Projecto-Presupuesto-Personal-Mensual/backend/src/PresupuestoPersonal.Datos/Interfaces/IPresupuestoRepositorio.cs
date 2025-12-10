using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface IPresupuestoRepositorio
    {
        List<Presupuesto> ObtenerPresupuestosPorUsuario(int idUsuario, string Estado);
        Presupuesto? ObtenerPorId(int idPresupuesto);
        int CrearPresupuesto(Presupuesto presupuesto, DateTime PeriodoInicio, DateTime PeriodoFin,  decimal TotalAhorros);
        bool ActualizarPresupuesto(Presupuesto presupuesto, string usuarioModificador, DateTime PeriodoInicio, DateTime PeriodoFin, decimal TotalAhorros);
        bool EliminarPresupuesto(int idPresupuesto);
    }
}