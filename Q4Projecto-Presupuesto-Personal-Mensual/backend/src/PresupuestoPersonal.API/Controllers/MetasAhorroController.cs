using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class MetasAhorroController : ControllerBase
    {
        private readonly IMetaAhorroRepositorio _repo;

        public MetasAhorroController(IMetaAhorroRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene todas las metas de ahorro de un usuario.
        /// </summary>
        /// <param name="idUsuario">ID del usuario</param>
        /// <returns>Lista de metas de ahorro</returns>
        /// <remarks>
        /// Ejemplo:
        /// GET /api/metasahorro/usuario/1
        /// </remarks>
        [HttpGet("usuario/{idUsuario}")]
        public IActionResult GetMetasPorUsuario(int idUsuario)
        {
            try
            {
                var metas = _repo.ObtenerMetasPorUsuario(idUsuario);
                return Ok(metas);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener metas: {ex.Message}");
            }
        }

        /// <summary>
        /// Obtiene una meta de ahorro por su ID.
        /// </summary>
        /// <param name="id">ID de la meta</param>
        /// <returns>Meta de ahorro</returns>
        /// <remarks>
        /// Ejemplo:
        /// GET /api/metasahorro/5
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetMetaPorId(int id)
        {
            try
            {
                var meta = _repo.ObtenerMetaPorId(id);
                if (meta == null)
                    return NotFound();

                return Ok(meta);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener la meta: {ex.Message}");
            }
        }

        /// <summary>
        /// Crea una nueva meta de ahorro.
        /// </summary>
        /// <param name="meta">Datos de la meta</param>
        /// <param name="usuarioCreador">Usuario creador</param>
        /// <remarks>
        /// Ejemplo:
        /// POST /api/metasahorro
        /// {
        ///   "idUsuario": 1,
        ///   "idSubcategoria": 3,
        ///   "nombre": "Viaje a Europa",
        ///   "descripcion": "Ahorro para viaje",
        ///   "montoMeta": 5000,
        ///   "fechaInicio": "2024-01-01",
        ///   "fechaObjetivo": "2024-12-31",
        ///   "prioridad": "Alta"
        /// }
        /// </remarks>
        [HttpPost]
        public IActionResult CrearMeta(
            [FromBody] MetaAhorro meta,
            [FromHeader] string usuarioCreador)
        {
            try
            {
                var resultado = _repo.CrearMeta(meta, usuarioCreador);
                return StatusCode(201);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al crear la meta: {ex.Message}");
            }
        }

        /// <summary>
        /// Actualiza una meta de ahorro existente.
        /// </summary>
        /// <param name="id">ID de la meta</param>
        /// <param name="meta">Datos actualizados</param>
        /// <param name="usuarioModificador">Usuario modificador</param>
        /// <returns>NoContent si es exitoso</returns>
        [HttpPut("{id}")]
        public IActionResult ActualizarMeta(
            int id,
            [FromBody] MetaAhorro meta,
            [FromHeader] string usuarioModificador)
        {
            try
            {
                meta.IdMeta = id;

                var actualizado = _repo.ActualizarMeta(meta, usuarioModificador);
                if (!actualizado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al actualizar la meta: {ex.Message}");
            }
        }

        /// <summary>
        /// Elimina una meta de ahorro (la marca como cancelada).
        /// </summary>
        /// <param name="id">ID de la meta</param>
        /// <returns>NoContent si es exitoso</returns>
        [HttpDelete("{id}")]
        public IActionResult EliminarMeta(int id)
        {
            try
            {
                var eliminado = _repo.EliminarMeta(id);
                if (!eliminado)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar la meta: {ex.Message}");
            }
        }
    }
}
