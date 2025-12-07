using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades

{
    public class Categoria  
    {
        /// <example>"1"</example>
        public int IdCategoria { get; set; }
        /// <example>"Salario"</example>
        public string Nombre { get; set; } = string.Empty;
        /// <example>"Ingresos por salario mensual"</example>
        public string Descripcion { get; set; } = string.Empty;
        /// <example>"ingreso"</example>
        public string TipoCategoria { get; set; } = string.Empty; // 'ingreso'  | 'gasto' | 'ahorro'
        /// <example>"fa-solid fa-wallet"</example>
        public string? NombreIcono { get; set; }
        /// <example>"#FF5733"</example>
        public string? Color { get; set; }
        /// <example>"1"</example>
        public int OrdenInterfaz { get; set; }

        //Campos de Auditoria
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }  
    }
}   