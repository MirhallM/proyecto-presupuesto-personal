using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.Datos.Interfaces
{
    public interface ITransaccionesRepositorio
    {
        List<Transaccion> ObtenerTransacciones(
            int idPresupuesto,
            int? anio = null,
            int? mes = null,
            string? tipo = null 
        );  
        Transaccion? ObtenerTransaccionPorId(int idTransaccion, int idPresupuesto);
        int CrearTransaccion(Transaccion transaccion, string usuarioCreador);
        bool ActualizarTransaccion(int idTransaccion, Transaccion transaccion, string usuarioModificador);
        bool EliminarTransaccion(int idTransaccion);
    }
}