using Microsoft.AspNetCore.Mvc;
using Azure.Monitor.OpenTelemetry.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenTelemetry().UseAzureMonitor();

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        Service = "Auth API",
        Status = "Running",
        Version = "1.0"
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

app.MapPost("/login", ([FromBody] LoginRequest request) =>
{
    if (request.Username == "admin" && request.Password == "password")
    {
        return Results.Ok(new
        {
            Token = "Dummy-JWT-Token",
            ExpiresIn = "1 Hour"
        });
    }

    return Results.Unauthorized();
});

app.Run();

record LoginRequest(string Username, string Password);