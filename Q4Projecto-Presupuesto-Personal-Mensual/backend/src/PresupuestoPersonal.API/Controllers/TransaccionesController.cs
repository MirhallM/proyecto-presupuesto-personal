using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/presupuestos/{idPresupuesto}/transacciones")]
    public class TransaccionesController : ControllerBase
    {
        private readonly ITransaccionesRepositorio _repo;

        public TransaccionesController(ITransaccionesRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene la lista de todas las transacciones.
        /// </summary>
        /// <returns>Lista de Transacciones</returns>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// GET /api/transacciones
        /// </remarks>
        /// <param name="idPresupuesto"></param>
        /// <param name="anio"></param>
        /// <param name="mes"></param>
        /// <param name="tipo"></param>
        [HttpGet]
        public IActionResult GetTransacciones(
            int idPresupuesto,
            int? anio = null,
            int? mes = null,
            string? tipo = null 
        ) => Ok(_repo.ObtenerTransacciones(idPresupuesto, anio, mes, tipo));

        /// <summary>
        /// Obtiene una transacción por su ID.
        /// </summary>
        /// <param name="idPresupuesto">ID del presupuesto</param>
        /// <param name="idTransaccion">ID de la transacción</param>
        /// <returns>Transacción encontrada</returns>
        [HttpGet("{id}")]
        public IActionResult GetTransaccionPorId(int idPresupuesto, int idTransaccion)
        {
            try
            {
                var transaccion = _repo.ObtenerTransaccionPorId(idTransaccion, idPresupuesto);
                if (transaccion == null)
                    return NotFound();
                    
            return Ok(transaccion);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener la transaccion: {ex.Message}");
            }
        }

        /// <summary>
        /// Crea una nueva transacción.
        /// </summary>
        /// <param name="usuarioCreador"></param>
        /// <param name="transaccion">Datos de la transacción</param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// POST /api/transacciones
        ///     {
        ///    "nombre": "Transporte",
        ///    "descripcion": "Gastos relacionados con transporte",
        ///    "tipoCategoria": "Gasto",
        ///    "nombreIcono": "car",
        ///    "color": "#FF5733"
        ///    }
        /// </remarks>
        [HttpPost]
        public IActionResult CrearTransaccion([FromBody] Transaccion transaccion, [FromHeader] string usuarioCreador)
        {
            try
            {
                var nuevaTransaccionId = _repo.CrearTransaccion(transaccion, usuarioCreador);
                return CreatedAtAction(nameof(GetTransaccionPorId), new {id = nuevaTransaccionId }, null);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al crear la transaccion: {ex.Message}");
            }
        }

        /// <summary>
        /// Actualiza una transacción existente.
        /// </summary>
        /// <param name="id">ID de la transacción</param>
        /// <param name="transaccion">Datos actualizados</param>
        /// <param name="usuarioModificador"></param>
        /// <returns>NoContent si es exitoso</returns>
        [HttpPut("{id}")]
        public IActionResult ActualizarTransaccion(int id,[FromBody] Transaccion transaccion,[FromHeader] string usuarioModificador)
        {
            try
            {
                var ok = _repo.ActualizarTransaccion(id, transaccion, usuarioModificador);

                if (!ok)
                    return StatusCode(500, "No se pudo actualizar la transacción");

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error: {ex.Message}");
            }
        }

        /// <summary>
        /// Elimina una transacción.
        /// </summary>
        /// <param name="id">ID de la transacción</param>
        /// <returns>NoContent si es exitoso</returns>
        [HttpDelete("{id}")]
        public IActionResult EliminarTransaccion(int id)
        {
            try
            {
                var eliminado = _repo.EliminarTransaccion(id);

                if (!eliminado)
                    return NotFound($"No existe una transacción con ID {id}");

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar la transacción: {ex.Message}");
            }
        }
    }
}