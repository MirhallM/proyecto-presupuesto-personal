namespace PresupuestoPersonal.Modelos.Entidades
{
    public class Categoria  
    {
        public int IdCategoria { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Descripcion { get; set; } = string.Empty;
        public string TipoCategoria { get; set; } = string.Empty; // 'ingreso'  | 'gasto' | 'ahorro'
        public string? NombreIcono { get; set; }
        public string? Color { get; set; }
        public int OrdenInterfaz { get; set; }

        //Campos de Auditoria
        public string CreadoPor { get; set; } = string.Empty;
        public string ModificadoPor { get; set; } = string.Empty;
        public DateTime CreadoEn { get; set; }
        public DateTime ModificadoEn { get; set; }
    }
}   