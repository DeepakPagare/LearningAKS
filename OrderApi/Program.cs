var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddHttpClient();

var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/", () =>
{
    return Results.Ok(new
    {
        Service = "Order API",
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

app.MapGet("/orders", async (IHttpClientFactory httpClientFactory, IConfiguration configuration) =>
{
    var client = httpClientFactory.CreateClient();

    // Read from Kubernetes ConfigMap
    var baseUrl = configuration["PAYMENT_API_URL"] ?? configuration["PaymentApi:BaseUrl"];
    var payment = await client.GetFromJsonAsync<object>($"{baseUrl}/payments");



    // We'll replace this URL with the Kubernetes service name later.
    //var payment = await client.GetFromJsonAsync<object>("http://localhost:5260/payments");

    return Results.Ok(new
    {  
        OrderId = 1001,
        Product = "Laptop",
        Amount = 500,
        Payment = payment
    });
});

app.Run();