using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;

namespace PresupuestoPersonal.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsuariosController : ControllerBase
    {
        private readonly UsuarioRepositorio _repo = new UsuarioRepositorio();

        [HttpGet]
        public IActionResult GetUsuarios()
        {
            var lista = _repo.ObtenerUsuarios();
            return Ok(lista);
        }
    }
}
