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

        [HttpGet("inactivos")]
        public IActionResult GetUsuariosInactivos()
        {
            var lista = _repo.ObtenerUsuariosInactivos();
            return Ok(lista);
        }

        [HttpPost]
        public IActionResult CrearUsuario([FromBody] Usuario usuario)
        {
            var idGenerado = _repo.CrearUsuario(usuario);

            if (idGenerado > 0)
                return Ok(new { mensaje = "Usuario creado correctamente", id = idGenerado });

            return BadRequest("No se pudo crear el usuario");
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
