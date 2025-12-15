using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Obligacion
    {
        /// <example>1</example>
        public int IdObligacion { get; set; }

        /// <example>1</example>
        public int IdUsuario { get; set; }

        /// <example>5</example>
        public int IdSubcategoria { get; set; }

        /// <example>"Alquiler"</example>
        public string Nombre { get; set; } = string.Empty;

        /// <example>"Pago mensual del alquiler"</example>
        public string Descripcion { get; set; } = string.Empty;

        /// <example>750.00</example>
        public decimal MontoFijo { get; set; }

        /// <example>15</example>
        public int DiaVencimiento { get; set; }

        /// <example>true</example>
        public bool EsVigente { get; set; }

        /// <example>"2024-01-01"</example>
        public DateTime FechaInicio { get; set; }

        /// <example>"2024-12-31"</example>
        public DateTime? FechaFin { get; set; }

        // ===== Campos informativos (JOINs) =====

        /// <example>"Servicios"</example>
        public string? NombreSubcategoria { get; set; }

        /// <example>"Gastos Fijos"</example>
        public string? NombreCategoria { get; set; }

        // ===== Campos de auditoría =====
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }
    }
}
