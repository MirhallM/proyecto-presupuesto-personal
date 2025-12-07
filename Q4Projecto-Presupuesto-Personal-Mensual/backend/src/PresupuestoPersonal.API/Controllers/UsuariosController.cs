using Microsoft.AspNetCore.Mvc;
using PresupuestoPersonal.Datos.Repositorios;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Modelos.Entidades;

/*
    UsuariosController.cs
    Controlador API para gestionar las operaciones relacionadas con los usuarios.
    Proporciona endpoints para crear, leer, actualizar y eliminar usuarios (utilizando desactivación).
*/

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

        /// <summary>
        /// Obtiene la lista de todos los usuarios.
        /// </summary>
        /// <returns>Lista de Usuarios</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/usuarios
        /// </remarks>
        [HttpGet]
        public IActionResult GetUsuarios() => Ok(_repo.ObtenerUsuarios());

        /// <summary>
        /// Obtiene un usuario por su ID.   
        /// </summary>
        /// <param name="id"></param>
        /// <returns>Usuario</returns>
        /// <remarks> 
        /// Ejemplo de solicitud:
        /// GET /api/usuarios/1
        /// </remarks>
        [HttpGet("{id}")]
        public IActionResult GetUsuarioPorId(int id)
        {
            var usuario = _repo.ObtenerPorId(id);
            if (usuario == null)
                return NotFound();

            return Ok(usuario);
        }

        /// <summary>
        /// Obtiene la lista de usuarios inactivos.
        /// </summary>
        /// <returns>Lista de Usuarios Inactivos</returns>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// GET /api/usuarios/inactivos
        /// </remarks>
        [HttpGet("inactivos")]
        public IActionResult GetUsuariosInactivos()
        {
            var lista = _repo.ObtenerUsuariosInactivos();
            return Ok(lista);
        }

        /// <summary>
        /// Crea un nuevo usuario. 
        /// </summary>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// 
        ///   POST /api/usuarios
        /// 
        ///     {  
        ///     "Nombres": "Ana",
        ///     "Apellidos": "Gómez",
        ///     "CorreoElectronico":" "ana@test.com",
        ///     "SalarioBase": 60000.00,
        ///     "CreadoPor": "admin"
        ///     }
        /// </remarks>
        /// <param name="usuario"></param>
        /// <returns>ID del usuario creado</returns>
        [HttpPost]
        public IActionResult CrearUsuario([FromBody] Usuario usuario)
        {
            var idGenerado = _repo.CrearUsuario(usuario);

            if (idGenerado > 0)
                return Ok(new { mensaje = "Usuario creado correctamente", id = idGenerado });

            return BadRequest("No se pudo crear el usuario");
        }

        /// <summary>
        /// Actualiza un usuario existente.
        /// </summary>
        /// <param name="idUsuario"></param>
        /// <param name="usuario"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// 
        ///  PUT /api/usuarios/1
        /// 
        ///     {
        ///     "IdUsuario": 1,
        ///     "Nombres": "Ana María",
        ///     "Apellidos": "Gómez López",
        ///     "SalarioBase": 65000.00,
        ///     "ModificadoPor": "editor"
        ///     }    
        /// </remarks>
        [HttpPut("{idUsuario}")]
        public IActionResult ActualizarUsuario(int idUsuario, [FromBody] Usuario usuario)
        {
            if (idUsuario != usuario.IdUsuario)
            return BadRequest("El ID del usuario no coincide.");

            var actualizado = _repo.ActualizarUsuario(usuario);
            if (!actualizado)
            return NotFound();

            return NoContent();
        }

        /// <summary>
        /// Elimina un usuario por su ID, osea lo desactiva.
        /// </summary>
        /// <param name="id"></param>
        /// <remarks>
        /// Ejemplo de solicitud:
        /// DELETE /api/usuarios/1
        /// </remarks>
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
