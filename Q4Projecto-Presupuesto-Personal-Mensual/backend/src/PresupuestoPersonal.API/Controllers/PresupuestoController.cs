using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;
using Microsoft.AspNetCore.Mvc.ModelBinding;


/*
    PresupuestoController.cs
    Controlador API para gestionar las operaciones relacionadas con los presupuestos.
    Proporciona endpoints para crear, leer, actualizar y eliminar presupuestos.
*/

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class PresupuestoController : ControllerBase
    {
        private readonly IPresupuestoRepositorio _repo;

        public PresupuestoController(IPresupuestoRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene la lista de presupuestos para un usuario específico.
        /// </summary>
        /// <param name="idUsuario"></param>
        /// <param name="estado"></param>
        /// <returns>Lista de Presupuestos</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/presupuesto/usuario/1?estado=activo
        /// 
        /// Filtros de estado disponibles:
        /// - activo: Presupuestos actualmente activos.
        /// - borrador: Presupuestos en estado de borrador.
        /// - cerrado: Presupuestos que han sido cerrados.
        /// </remarks>
        [HttpGet("usuario/{idUsuario}")]
        public IActionResult GetPresupuestosPorUsuario(int idUsuario, [FromQuery, BindRequired] string estado)
        {
            try
            {
                var presupuestos = _repo.ObtenerPresupuestosPorUsuario(idUsuario, estado);
                return Ok(presupuestos);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }

        /// <summary>
        /// Obtiene un presupuesto por su ID.
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Presupuesto</returns>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// GET /api/presupuesto/1
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetPresupuestoPorId(int id)
        {
            try
            {
                var presupuesto = _repo.ObtenerPorId(id);
                if (presupuesto == null)
                    return NotFound();

                return Ok(presupuesto);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }

        /// <summary>
        /// Crea un nuevo presupuesto.
        /// </summary>
        /// <param name="presupuesto"></param>
        /// <param name="periodoInicio"></param>
        /// <param name="periodoFin"></param>
        /// <param name="totalAhorros"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// POST /api/presupuesto
        ///    {
        ///   "idUsuario": 1,
        ///   "nombre": "Presupuesto Mensual",
        ///   "descripcion": "Presupuesto para el mes de enero"
        ///   "periodo_inicio": "2024-01-01",
        ///   "periodo_fin": "2024-01-31",
        ///   "total_ahorros": 5000.00
        ///   }
        /// </remarks>
        [HttpPost]
        public IActionResult CrearPresupuesto([FromBody] Presupuesto presupuesto, [FromHeader] DateTime periodoInicio, [FromHeader] DateTime periodoFin, [FromHeader] decimal totalAhorros)
        {
            try
            {
                var nuevoPresupuestoId = _repo.CrearPresupuesto(presupuesto, periodoInicio, periodoFin, totalAhorros);
                return CreatedAtAction(nameof(GetPresupuestoPorId), new { id = nuevoPresupuestoId }, nuevoPresupuestoId);
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }

        /// <summary>
        /// Actualiza un presupuesto existente.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="presupuesto"></param>
        /// <param name="usuarioModificador"></param>
        /// <param name="periodoInicio"></param>
        /// <param name="periodoFin"></param>
        /// <param name="totalAhorros"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// PUT /api/presupuesto/1
        ///   {
        ///   "nombre": "Presupuesto Mensual Actualizado",
        ///   "descripcion": "Presupuesto actualizado para el mes de enero"
        ///   "periodo_inicio": "2024-01-01",
        ///   "periodo_fin": "2024-01-31",
        ///   "total_ahorros": 6000.00
        ///    }
        /// </remarks>
        [HttpPut("{id}")]
        public IActionResult ActualizarPresupuesto(int id, [FromBody] Presupuesto presupuesto, [FromHeader] string usuarioModificador, [FromHeader] DateTime periodoInicio, [FromHeader] DateTime periodoFin, [FromHeader] decimal totalAhorros)
        {
            try
            {
                var presupuestoExistente = _repo.ObtenerPorId(id);
                if (presupuestoExistente == null)
                    return NotFound();

                presupuesto.IdPresupuesto = id;
                var actualizado = _repo.ActualizarPresupuesto(presupuesto, usuarioModificador, periodoInicio, periodoFin, totalAhorros);
                if (!actualizado)
                    return StatusCode(500, "Error al actualizar el presupuesto.");

                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }

        /// <summary>
        /// Elimina un presupuesto por su ID (lo marca como cerrado).
        /// </summary>
        /// <param name="id"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// DELETE /api/presupuesto/1
        /// </remarks>
        [HttpDelete("{id}")]
        public IActionResult EliminarPresupuesto(int id)
        {
            try
            {
                var presupuestoExistente = _repo.ObtenerPorId(id);
                if (presupuestoExistente == null)
                    return NotFound();

                var eliminado = _repo.EliminarPresupuesto(id);
                if (!eliminado)
                    return StatusCode(500, "Error al eliminar el presupuesto.");

                return NoContent();
            }
            catch (Exception ex)
            {
                return BadRequest(new { mensaje = ex.Message });
            }
        }
    }
}