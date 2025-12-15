using System.Text.Json.Serialization;

namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Transaccion
    {
        /// <example>"1"</example>
        public int IdTransaccion { get; set; }
        /// <example>"1"</example>
        public int IdUsuario { get; set; }
        /// <example>"1"</example>
        public int IdPresupuesto { get; set; }
        /// <example>"1"</example>
        public int IdSubcategoria { get; set; }
        /// <example>"1"</example>
        public int? IdObligacion { get; set; }
        /// <example>"2023"</example>
        public int Anio { get; set; }
        /// <example>"10"</example>
        public int Mes { get; set; }
        /// <example>"Ingreso"</example>
        public string TipoTransaccion { get; set; } = string.Empty;
        /// <example>"Salario mensual"</example>
        public string Descripcion { get; set; } = string.Empty;
        /// <example>"1500.00"</example>
        public decimal Monto { get; set; }
        /// <example>"2023-10-15T00:00:00"</example>
        public DateTime FechaTransaccion { get; set; }
        /// <example>"Efectivo"</example>
        public string MetodoPago { get; set; } = string.Empty;
        /// <example>"FAC-2023-001"</example>
        public string NumeroFactura { get; set; } = string.Empty;
        /// <example>"Pago correspondiente al mes de octubre"</example>
        public string? Notas { get; set; } = string.Empty;

        //Campos de Auditoria
        [JsonIgnore] public string CreadoPor { get; set; } = string.Empty;
        [JsonIgnore] public string ModificadoPor { get; set; } = string.Empty;
        [JsonIgnore] public DateTime CreadoEn { get; set; }
        [JsonIgnore] public DateTime ModificadoEn { get; set; }
    }
}