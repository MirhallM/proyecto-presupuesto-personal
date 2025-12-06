using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosController : ControllerBase
    {
        private readonly IUsuarioRepositorio _repo;

        public UsuariosController(IUsuarioRepositorio repo)
        {
            _repo = repo;
        }

        [HttpGet]
        public IActionResult GetUsuarios() => Ok(_repo.ObtenerUsuarios());

        [HttpGet("{id}")]
        public IActionResult GetUsuarioPorId(int id)
        {
            var usuario = _repo.ObtenerPorId(id);
            if (usuario == null)
                return NotFound();

            return Ok(usuario);
        }

        [HttpPut("{id}")]
        public IActionResult ActualizarUsuario(int id, [FromBody] Usuario usuario)
        {
            if (id != usuario.IdUsuario)
                return BadRequest("El ID del usuario no coincide.");

            var actualizado = _repo.ActualizarUsuario(usuario);
            if (!actualizado)
                return NotFound();

            return NoContent();
        }

        [HttpDelete("{id}")]
        public IActionResult EliminarUsuario(int id)
        {
            var eliminado = _repo.EliminarUsuario(id);
            if (!eliminado)
                return NotFound();

            return NoContent();
        }
    }
}
