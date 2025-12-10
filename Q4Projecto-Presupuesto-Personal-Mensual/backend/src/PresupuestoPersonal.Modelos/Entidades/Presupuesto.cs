using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Presupuesto
    {
        /// <example>"1"</example>
        public int IdPresupuesto { get; set; }
        /// <example>"1"</example>
        public int IdUsuario { get; set; }
        /// <example>"Enero 2024"</example>
        public string Nombre { get; set; } = string.Empty;
        /// <example>"Presupuesto para el mes de enero 2024"</example>
        public string Descripcion { get; set; } = string.Empty;
        /// <example>"2024"</example>
        public int AnioInicio { get; set; }
        /// <example>"1"</example>
        public int MesInicio { get; set; }
        /// <example>"2024"</example>
        public int AnioFinal { get; set; }
        /// <example>"1"</example>
        public int MesFinal { get; set; }
        /// <example>"15000.00"</example>
        public decimal TotalIngresos { get; set; }
        /// <example>"12000.00"</example>
        public decimal TotalGastos { get; set; }
        /// <example> "4500.00"</example>
        public decimal TotalAhorros { get; set; }
        /// <example>"2024-01-31T23:59:59"</example>
        public DateTime FechaRegistro { get; set; }
        /// <example>"activo", "inactivo", "borrador"</example>
        public string Estado { get; set; } = string.Empty;

        //Campos de Auditoria
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }
    }
}