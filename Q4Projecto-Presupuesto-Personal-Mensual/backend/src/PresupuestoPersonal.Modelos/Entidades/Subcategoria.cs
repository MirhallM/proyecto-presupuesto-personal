namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Subcategoria
    {
        public int IdSubcategoria { get; set; }
        public int IdCategoria { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public bool EsActivo { get; set; }
        public bool EsPredeterminado { get; set; }

        //Campos de Auditoria
        public string CreadoPor { get; set; } = string.Empty;
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime CreadoEn { get; set; }
        public DateTime ModificadoEn { get; set; }
    }
}