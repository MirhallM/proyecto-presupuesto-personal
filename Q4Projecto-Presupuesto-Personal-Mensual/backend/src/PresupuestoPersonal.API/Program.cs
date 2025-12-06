using PresupuestoPersonal.Datos.Conexion;
using PresupuestoPersonal.Datos.Interfaces;
using PresupuestoPersonal.Datos.Repositorios;

var builder = WebApplication.CreateBuilder(args);

// ==== Servicios de la aplicación ====

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Inyección de dependencias
builder.Services.AddSingleton<ConexionBD>(); // sin parámetros porque usamos DSN
builder.Services.AddScoped<IUsuarioRepositorio, UsuarioRepositorio>();

var app = builder.Build();

// ==== Configuración del pipeline HTTP ====

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// Si marca problemas de HTTPS deshabilitamos redirección por ahora
// app.UseHttpsRedirection(); <-- Se puede activar luego

app.UseAuthorization();

app.MapControllers();

app.Run();
