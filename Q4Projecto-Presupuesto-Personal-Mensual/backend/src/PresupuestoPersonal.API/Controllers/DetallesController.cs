using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

/* 
    DetallesController.cs
    Controlador API para gestionar las operaciones relacionadas con los detalles del presupuesto.
    Proporciona endpoints para crear, leer, actualizar y eliminar detalles del presupuesto.
*/  

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/presupuesto/{idPresupuesto}/detalles")]
    public class DetallesController : ControllerBase
    {
        private readonly IDetallesRepositorio _repo;

        public DetallesController(IDetallesRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene la lista de detalles para un presupuesto específico.
        /// </summary>
        /// <param name="idPresupuesto"></param>
        /// <returns>Lista de Detalles del Presupuesto</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/presupuesto/1/detalles
        /// </remarks>
        [HttpGet]
        public IActionResult GetDetallesPorPresupuesto(int idPresupuesto) => Ok(_repo.ObtenerDetallesPorPresupuesto(idPresupuesto));

        /// <summary>
        /// Obtiene un detalle del presupuesto por su ID.
        /// </summary>
        /// <param name="idDetalle"></param>
        /// <param name="idPresupuesto"></param>
        /// <returns>Detalle del Presupuesto</returns>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// GET /api/presupuesto/2/detalles/19
        /// </remarks>  
        [HttpGet("{idDetalle}")]
        public IActionResult GetDetallePorId(int idDetalle, int idPresupuesto)
        {
            try
            {
                var detalle = _repo.ObtenerDetallePorId(idDetalle, idPresupuesto);
                if (detalle == null)
                    return NotFound();

                return Ok(detalle);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener el detalle del presupuesto: {ex.Message}");
            }
        }

        /// <summary>
        /// Crea un nuevo detalle del presupuesto.
        /// </summary>
        /// <param name="idPresupuesto"></param>
        /// <param name="detallePresupuesto"></param>
        /// <param name="usuarioCreador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// POST /api/presupuesto/1/detalles
        /// </remarks>
        [HttpPost]
        public IActionResult CrearDetallePresupuesto(int idPresupuesto, [FromBody] DetallesPresupuesto detallePresupuesto, [FromQuery] string usuarioCreador)
        {
            try
            {
                detallePresupuesto.IdPresupuesto = idPresupuesto;
                var nuevoId = _repo.CrearDetallePresupuesto(detallePresupuesto, usuarioCreador);
                return CreatedAtAction(nameof(GetDetallePorId), new { idPresupuesto = idPresupuesto, idDetalle = nuevoId }, nuevoId);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al crear el detalle del presupuesto: {ex.Message}");
            }
        }

        /// <summary>
        /// Actualiza un detalle del presupuesto existente.
        /// </summary>
        /// <param name="idPresupuesto"></param>
        /// <param name="idDetalle"></param>
        /// <param name="detallePresupuesto"></param>
        /// <param name="usuarioModificador"></param>
        /// <remarks>   
        /// Ejemplo de solicitud:
        /// PUT /api/presupuesto/1/detalles/1
        /// </remarks>
        [HttpPut("{idDetalle}")]
        public IActionResult ActualizarDetallePresupuesto(int idPresupuesto, int idDetalle, [FromBody] DetallesPresupuesto detallePresupuesto, [FromQuery] string usuarioModificador)
        {
            try
            {
                if (idDetalle != detallePresupuesto.IdDetallePresupuesto || idPresupuesto != detallePresupuesto.IdPresupuesto)
                    return BadRequest("El ID del detalle o del presupuesto no coincide.");

                var actualizado = _repo.ActualizarDetallePresupuesto(detallePresupuesto, usuarioModificador);
                if (!actualizado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al actualizar el detalle del presupuesto: {ex.Message}");
            }
        }

        /// <summary>
        /// Elimina un detalle del presupuesto por su ID.
        /// </summary>
        /// <param name="idPresupuesto"></param>
        /// <param name="idDetalle"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// DELETE /api/presupuesto/1/detalles/1
        /// </remarks>
        [HttpDelete("{idDetalle}")]
        public IActionResult EliminarDetallePresupuesto(int idPresupuesto, int idDetalle)
        {
            try
            {
                var eliminado = _repo.EliminarDetallePresupuesto(idDetalle);
                if (!eliminado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar el detalle del presupuesto: {ex.Message}");
            }
        }
    }
}