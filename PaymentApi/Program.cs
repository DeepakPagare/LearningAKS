using Azure.Monitor.OpenTelemetry.AspNetCore;

var builder = WebApplication.CreateBuilder(args);


builder.Services.AddOpenTelemetry()
    .UseAzureMonitor();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        Service = "Payment API",
        Status = "Running",
        Version = "2.0"
    });
});

app.MapGet("/health", () =>
{
    return Results.Ok(new
    {
        Status = "Healthy",
        Time = DateTime.UtcNow
    });
});

app.MapGet("/payments", () =>
{
    return Results.Ok(new
    {
        PaymentId = 101,
        Status = "Paid",
        Amount = 500,
        Currency = "INR"
    });
});

app.Run();