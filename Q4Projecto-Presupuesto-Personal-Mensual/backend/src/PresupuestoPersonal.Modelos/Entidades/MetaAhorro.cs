using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class MetaAhorro
    {
        public int IdMeta { get; set; }
        public int IdUsuario { get; set; }
        public int IdSubcategoria { get; set; }

        public string Nombre { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;

        public decimal MontoMeta { get; set; }
        public decimal MontoAhorrado { get; set; }

        public DateTime FechaInicio { get; set; }
        public DateTime FechaObjetivo { get; set; }

        /// <summary>
        /// Alta | Media | Baja
        /// </summary>
        public string Prioridad { get; set; } = string.Empty;

        /// <summary>
        /// en_progreso | completada | cancelada | pausada
        /// </summary>
        public string Estado { get; set; } = string.Empty;

        // Campos de auditoría (no se exponen en JSON)
        [JsonIgnore]
        public string CreadoPor { get; set; } = string.Empty;

        [JsonIgnore]
        public string ModificadoPor { get; set; } = string.Empty;

        [JsonIgnore]
        public DateTime CreadoEn { get; set; }

        [JsonIgnore]
        public DateTime ModificadoEn { get; set; }
    }
}
