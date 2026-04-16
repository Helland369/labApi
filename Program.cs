using LabApi.Data;
using Microsoft.AspNetCore.HttpOverrides;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddControllers();
builder.Services.AddOpenApi();

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.Configure<ForwardedHeadersOptions>(options =>
{
    options.ForwardedHeaders = ForwardedHeaders.XForwardedFor | ForwardedHeaders.XForwardedProto;
    options.KnownIPNetworks.Clear();
    options.KnownProxies.Clear();
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseForwardedHeaders();
app.UseAuthorization();

app.MapGet("/", () => Results.Ok(new
{
    app = "LabApi",
    message = "Lab API is running",
    endpoints = new[] { "/health", "/api/products" }
}));

app.MapGet("/health", () => Results.Ok(new
{
    status = "ok",
    time = DateTimeOffset.UtcNow
}));

app.MapControllers();

app.Run();
