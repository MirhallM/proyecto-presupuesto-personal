using PresupuestoPersonal.Datos.Conexion;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Repositorios;

var builder = WebApplication.CreateBuilder(args);

// ================== CONFIGURAR CADENA PARA AZURE ==================
var connectionString =
    "DRIVER=SQL Anywhere 17;" +
    "UID=admin;" +
    "PWD=contra;" +
    "ENG=ProyectoPresupuesto;" +
    "DBN=BD_Proyecto Personal;" +
    "LINKS=tcpip(HOST=20.46.232.81:2638)";


// ================== INYECCIÓN DE DEPENDENCIAS =====================
builder.Services.AddSingleton(new ConexionBD(connectionString));
builder.Services.AddScoped<IUsuarioRepositorio, UsuarioRepositorio>();

// ================== SERVICIOS DEL API ============================
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// ================== PIPELINE HTTP ================================
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Por ahora HTTPS redirection desactivado para facilitar pruebas externas
// app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();