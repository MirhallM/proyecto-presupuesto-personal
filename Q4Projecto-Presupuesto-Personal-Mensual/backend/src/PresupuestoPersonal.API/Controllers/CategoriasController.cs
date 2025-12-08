using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

/*
    CategoriasController.cs
    Controlador API para gestionar las operaciones relacionadas con las categorías.
    Proporciona endpoints para crear, leer, actualizar y eliminar categorías.
*/

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class CategoriasController : ControllerBase
    {
        private readonly ICategoriaRepositorio _repo;

        public CategoriasController(ICategoriaRepositorio repo)
        {
            _repo = repo;
        }

        /// <summary>
        /// Obtiene la lista de todas las categorías.
        /// </summary>
        /// <returns>Lista de Categorías</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/categorias
        /// </remarks>
        [HttpGet]
        public IActionResult GetCategorias() => Ok(_repo.ObtenerCategorias());

        /// <summary>
        /// Obtiene una categoría por su ID.   
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Categoría</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/categorias/1
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetCategoriaPorId(int id)
        {
            var categoria = _repo.ObtenerPorId(id);
            if (categoria == null)
                return NotFound();

            return Ok(categoria);
        }

        /// <summary>
        /// Crea una nueva categoría.
        /// </summary>
        /// <param name="categoria"></param>
        /// <param name="usuarioCreador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// POST /api/categorias
        ///     {
        ///    "nombre": "Transporte",
        ///    "descripcion": "Gastos relacionados con transporte",
        ///    "tipoCategoria": "Gasto",
        ///    "nombreIcono": "car",
        ///    "color": "#FF5733"
        ///    }
        /// </remarks>
        [HttpPost]
        public IActionResult CrearCategoria([FromBody] Categoria categoria, [FromHeader] string usuarioCreador)
        {
            var nuevaCategoriaId = _repo.CrearCategoria(categoria, usuarioCreador);
            return CreatedAtAction(nameof(GetCategoriaPorId), new { id = nuevaCategoriaId }, nuevaCategoriaId);
        }

        /// <summary>
        /// Actualiza una categoría existente.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="categoria"></param>
        /// <param name="usuarioModificador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// PUT /api/categorias/1
        ///    {
        ///   "nombre": "Transporte Actualizado",
        ///   "descripcion": "Gastos relacionados con transporte actualizado",
        ///   "tipoCategoria": "Gasto",
        ///   "nombreIcono": "bus",
        ///   "color": "#33FF57"
        ///    }
        /// </remarks>
        [HttpPut("{id}")]
        public IActionResult ActualizarCategoria(int id, [FromBody] Categoria categoria, [FromHeader] string usuarioModificador)
        {
            var categoriaExistente = _repo.ObtenerPorId(id);
            if (categoriaExistente == null)
                return NotFound();

            categoria.IdCategoria = id;
            var actualizado = _repo.ActualizarCategoria(categoria, usuarioModificador);
            if (!actualizado)
                return StatusCode(500, "Error al actualizar la categoría.");

            return NoContent();
        }

        /// <summary>
        /// Elimina una categoría por su ID.
        /// </summary>
        /// <param name="id"></param>
        /// <param name="usuarioModificador"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// DELETE /api/categorias/1
        /// </remarks>
        [HttpDelete("{id}")]
        public IActionResult EliminarCategoria(int id, [FromHeader] string usuarioModificador)
        {
            var categoriaExistente = _repo.ObtenerPorId(id);
            if (categoriaExistente == null)
                return NotFound();

            var eliminado = _repo.EliminarCategoria(id, usuarioModificador);
            if (!eliminado)
                return StatusCode(500, "Error al eliminar la categoría.");

            return NoContent();
        }
    }
}