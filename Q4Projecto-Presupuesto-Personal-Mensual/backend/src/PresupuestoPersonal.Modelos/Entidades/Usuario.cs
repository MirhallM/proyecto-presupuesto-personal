/*
    Usuario.cs
    Modelo de entidad para representar un usuario en el sistema de presupuesto personal.

    Usaremos PascalCase para los nombres de las clases y propiedades, siguiendo las convenciones de C#.
    Las propiedades de la clase reflejan los campos típicos asociados con un usuario.
*/
using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Usuario
    {
        /// <example>"1"</example>
        public int IdUsuario { get; set; }

        /// <example>"Juan"</example>
        public string Nombres { get; set; } = string.Empty;
        /// <example>"Pérez"</example>
        public string Apellidos { get; set; } = string.Empty;
        /// <example>"juan@test.com"</example>
        public string CorreoElectronico { get; set; } = string.Empty;
        /// <example>2024-01-15T10:30:00</example>
        public DateTime FechaRegistro { get; set; }
        /// <example>50000.00</example>
        public decimal SalarioBase { get; set; }
        /// <example>true</example>
        public bool EsActivo { get; set; }

        //Campos de Auditoria
        public string CreadoPor { get; set; } = string.Empty;
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime CreadoEn { get; set; }
        public DateTime ModificadoEn { get; set; }  
    }
}