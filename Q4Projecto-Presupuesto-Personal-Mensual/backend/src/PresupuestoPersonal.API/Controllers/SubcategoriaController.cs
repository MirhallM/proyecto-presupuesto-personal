using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

/*
    SubcategoriasController.cs
    Controlador API para gestionar las operaciones relacionadas con las subcategorías.
    Proporciona endpoints para crear, leer, actualizar y eliminar subcategorías.
*/

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class SubcategoriasController : ControllerBase
    {
        private readonly ISubcategoriaRepositorio _repo;

        public SubcategoriasController(ISubcategoriaRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene la lista de subcategorías por ID de categoría.
        /// </summary>
        /// <param name="idCategoria"></param>
        /// <returns>Lista de Subcategorías</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/subcategorias/categoria/1
        /// </remarks>
        [HttpGet("categoria/{idCategoria}")]
        public IActionResult GetSubcategoriasPorCategoria(int idCategoria)
        {
            try
            {
                var subcategorias = _repo.ObtenerSubcategoriasPorCategoria(idCategoria);
                return Ok(subcategorias);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener subcategorías: {ex.Message}");
            }
        }

        /// <summary>
        /// Obtiene una subcategoría por su ID.
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Subcategoría</returns>
        /// <remarks>
        ///     Ejemplo de solicitud:
        ///     GET /api/subcategorias/1
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetSubcategoriaPorId(int id)
        {
            try
            {
                var subcategoria = _repo.ObtenerPorId(id);
                if (subcategoria == null)
                    return NotFound();

                return Ok(subcategoria);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al obtener la subcategoría: {ex.Message}");
            }
        }

        /// <summary>
        /// Crea una nueva subcategoría.
        /// </summary>
        /// <param name="subcategoria"></param>
        /// <param name="usuarioCreador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// POST /api/subcategorias
        ///     {
        ///     "idCategoria": 1,
        ///     "nombre": "Combustible",
        ///     "descripcion": "Gastos en gasolina y diésel",
        ///     "esPredeterminada": false
        ///     "creadoPor": "usuario123"
        ///     }   
        /// </remarks>
        [HttpPost]
        public IActionResult CrearSubcategoria([FromBody] Subcategoria subcategoria, [FromHeader] string usuarioCreador)
        {
            try
            {
                var nuevoId = _repo.CrearSubcategoria(subcategoria, usuarioCreador);
                return CreatedAtAction(nameof(GetSubcategoriaPorId), new { id = nuevoId }, null);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al crear la subcategoría: {ex.Message}");
            }
        }

        /// <summary>
        /// Elimina una subcategoría por su ID.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="usuarioModificador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// DELETE /api/subcategorias/1?usuarioModificador=usuario123
        /// </remarks>
        [HttpDelete("{id}")]
        public IActionResult EliminarSubcategoria(int id, [FromHeader] string usuarioModificador)
        {
            try
            {
                var exito = _repo.EliminarSubcategoria(id, usuarioModificador);
                if (!exito)
                    return NotFound();

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al eliminar la subcategoría: {ex.Message}");
            }
        }

        /// <summary>
        /// Actualiza una subcategoría existente.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="subcategoria"></param>
        /// <param name="usuarioModificador"></param>  
        /// <remarks>
        /// Ejemplo de solicitud:
        /// PUT /api/subcategorias/1
        ///    {
        ///   "idSubcategoria": 1,
        ///   "nombre": "Combustible Actualizado",
        ///   "descripcion": "Gastos en gasolina, diésel y electricidad",
        ///   "modificadoPor": "usuario123"
        ///    }
        /// </remarks>
        [HttpPut("{id}")]
        public IActionResult ActualizarSubcategoria(int id, [FromBody] Subcategoria subcategoria, [FromHeader] string usuarioModificador)
        {
            try
            {
                var subcategoriaExistente = _repo.ObtenerPorId(id);
                if (subcategoriaExistente == null)
                    return NotFound();

                subcategoria.IdSubcategoria = id;
                var actualizado = _repo.ActualizarSubcategoria(subcategoria, usuarioModificador);
                if (!actualizado)
                    return StatusCode(500, "Error al actualizar la subcategoría.");

                return NoContent();
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error al actualizar la subcategoría: {ex.Message}");
            }
        }
    }
}