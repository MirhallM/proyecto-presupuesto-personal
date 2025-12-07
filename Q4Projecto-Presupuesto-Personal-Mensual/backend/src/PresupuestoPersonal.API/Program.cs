using PresupuestoPersonal.Datos.Conexion;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Repositorios;
using System.Reflection;


var builder = WebApplication.CreateBuilder(args);

// ================== CONFIGURAR CADENA PARA AZURE ==================
var connectionString =
    "DRIVER=SQL Anywhere 17;" +
    "UID=admin;" +
    "PWD=contra;" +
    "ENG=ProyectoPresupuesto;" +
    "DBN=BD_Proyecto Personal;" +
    "LINKS=tcpip(HOST=20.46.232.81:2638)";


// Inyección de dependencias
builder.Services.AddSingleton(new ConexionBD(connectionString));
builder.Services.AddScoped<IUsuarioRepositorio, UsuarioRepositorio>();

// Servicios del API
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
    var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
    c.IncludeXmlComments(xmlPath);
});

var app = builder.Build();

// Configurar el pipeline de la aplicación
app.UseSwagger();
app.UseSwaggerUI();

app.UseAuthorization();

app.MapControllers();

app.Run();