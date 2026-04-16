namespace LabApi.Endpoints;

public static class SystemEndpoints
{
    public static IEndpointRouteBuilder MapSystemEndpoints(this IEndpointRouteBuilder endpoints)
    {
        endpoints.MapGet("/", () => Results.Ok(new
        {
            app = "LabApi",
            message = "Lab API is running",
            endpoints = new[] { "/health", "/api/products" }
        }));

        endpoints.MapGet("/health", () => Results.Ok(new
        {
            status = "ok",
            time = DateTimeOffset.UtcNow
        }));

        return endpoints;
    }
}