/*
    Usuario.cs
    Modelo de entidad para representar un usuario en el sistema de presupuesto personal.

    Usaremos PascalCase para los nombres de las clases y propiedades, siguiendo las convenciones de C#.
    Las propiedades de la clase reflejan los campos típicos asociados con un usuario.
*/

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Usuario
    {
        public int IdUsuario { get; set; }
        public string Nombres { get; set; } = string.Empty;
        public string Apellidos { get; set; } = string.Empty;
        public string CorreoElectronico { get; set; } = string.Empty;
        public DateTime FechaRegistro { get; set; }
        public decimal SalarioBase { get; set; }
        public bool EsActivo { get; set; }

        //Campos de Auditoria
        public string CreadoPor { get; set; } = string.Empty;
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime CreadoEn { get; set; }
        public DateTime ModificadoEn { get; set; }  
    }
}