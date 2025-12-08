using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Subcategoria
    {
        /// <example>"1"</example>
        public int IdSubcategoria { get; set; }
        /// <example> "1"</example>
        public int IdCategoria { get; set; }
        /// <example>"Comida"</example>
        public string Nombre { get; set; } = string.Empty;
        /// <example>"Gastos relacionados con alimentos y restaurantes"</example>
        public string Descripcion { get; set; } = string.Empty;
        ///<example,"true"</example>
        public bool EsActivo { get; set; }
        ///<example,"false"</example>
        public bool EsPredeterminado { get; set; }

        //Campos de Auditoria
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }  
    }
}