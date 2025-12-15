using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ObligacionesController : ControllerBase
    {
        private readonly IObligacionRepositorio _repo;

        public ObligacionesController(IObligacionRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Lista las obligaciones de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario</param>
        /// <param name="activo">
        /// Estado de la obligación:
        /// 1 = vigentes
        /// 0 = no vigentes
        /// null = todas
        /// </param>
        /// <remarks>
        /// Ejemplo:
        /// GET /api/obligaciones/usuario/1?activo=1
        /// </remarks>
        [HttpGet("usuario/{idUsuario}")]
        public IActionResult GetObligacionesPorUsuario(int idUsuario, [FromQuery] int? activo = null)
        {
            try
            {
                var obligaciones = _repo.ObtenerObligacionesPorUsuario(idUsuario, activo);
                return Ok(obligaciones);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al listar obligaciones: {ex.Message}");
            }
        }

        /// <summary>
        /// Obtiene una obligación por su ID.
        /// </summary>
        /// <param name="id">ID de la obligación</param>
        /// <remarks>
        /// GET /api/obligaciones/5
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetObligacionPorId(int id)
        {
            try
            {
                var obligacion = _repo.ObtenerPorId(id);
                if (obligacion == null)
                    return NotFound();

                return Ok(obligacion);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener la obligación: {ex.Message}");
            }
        }

        /// <summary>
        /// Crea una nueva obligación.
        /// </summary>
        /// <param name="obligacion">Datos de la obligación</param>
        /// <param name="usuarioCreador">Usuario que crea la obligación</param>
        /// <remarks>
        /// POST /api/obligaciones
        /// 
        /// {
        ///   "idUsuario": 1,
        ///   "idSubcategoria": 3,
        ///   "nombre": "Internet",
        ///   "descripcion": "Pago mensual de internet",
        ///   "montoFijo": 1200.00,
        ///   "diaVencimiento": 15,
        ///   "fechaInicio": "2024-01-01",
        ///   "fechaFin": null
        /// }
        /// </remarks>
        [HttpPost]
        public IActionResult CrearObligacion(
            [FromBody] Obligacion obligacion,
            [FromHeader] string usuarioCreador)
        {
            try
            {
                _repo.CrearObligacion(obligacion, usuarioCreador);
                return StatusCode(201);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al crear la obligación: {ex.Message}");
            }
        }

        /// <summary>
        /// Actualiza una obligación existente.
        /// </summary>
        /// <param name="id">ID de la obligación</param>
        /// <param name="obligacion">Datos actualizados</param>
        /// <param name="usuarioModificador">Usuario que modifica</param>
        /// <remarks>
        /// PUT /api/obligaciones/5
        /// </remarks>
        [HttpPut("{id}")]
        public IActionResult ActualizarObligacion(
            int id,
            [FromBody] Obligacion obligacion,
            [FromHeader] string usuarioModificador)
        {
            try
            {
                obligacion.IdObligacion = id;

                var actualizado = _repo.ActualizarObligacion(obligacion, usuarioModificador);
                if (!actualizado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al actualizar la obligación: {ex.Message}");
            }
        }

        /// <summary>
        /// Elimina (desactiva) una obligación.
        /// </summary>
        /// <param name="id">ID de la obligación</param>
        /// <remarks>
        /// DELETE /api/obligaciones/5
        /// </remarks>
        [HttpDelete("{id}")]
        public IActionResult EliminarObligacion(int id)
        {
            try
            {
                var eliminado = _repo.EliminarObligacion(id);
                if (!eliminado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar la obligación: {ex.Message}");
            }
        }
    }
}
