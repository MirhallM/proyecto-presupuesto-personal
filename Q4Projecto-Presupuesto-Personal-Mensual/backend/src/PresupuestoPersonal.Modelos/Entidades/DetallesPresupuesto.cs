using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class DetallesPresupuesto
    {
        /// <example>"1"</example>
        public int IdDetallePresupuesto { get; set; }
        /// <example>"1"</example>
        public int IdPresupuesto { get; set; }
        /// <example>"1"</example>
        public int IdSubcategoria { get; set; }
        /// <example>"5000.00"</example>
        public decimal MontoAsignado { get; set; }
        /// <example>"Gastos inesperados"</example>
        public string Justificacion { get; set; } = string.Empty;  

        //Campos de unión
        [JsonIgnore] public string NombreSubcategoria { get; set; } = string.Empty;
        [JsonIgnore] public string NombreCategoria { get; set; } = string.Empty;
        [JsonIgnore] public string TipoCategoria { get; set; } = string.Empty;


        //Campos de Auditoria
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }
    }
}   