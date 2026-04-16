using LabApi.Configuration;
using LabApi.Endpoints;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddApplicationServices(builder.Configuration);

var app = builder.Build();

app.ConfigureHttpPipeline();
app.MapSystemEndpoints();
app.MapControllers();

app.Run();
