using System.Net;
using System.Text.Json;
using Azure.Data.Tables;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace Collabolatte.Api.Functions;

public class StatusFunction
{
    private readonly ILogger<StatusFunction> _logger;

    public StatusFunction(ILogger<StatusFunction> logger)
    {
        _logger = logger;
    }

    [Function("Status")]
    public async Task<HttpResponseData> Run(
        [HttpTrigger(AuthorizationLevel.Anonymous, "get", Route = "status")] HttpRequestData req)
    {
        _logger.LogInformation("Status endpoint called");

        var status = new StatusResponse
        {
            Timestamp = DateTime.UtcNow,
            Environment = Environment.GetEnvironmentVariable("AZURE_FUNCTIONS_ENVIRONMENT") ?? "local",
            Authentication = GetAuthenticationStatus(req),
            Connections = await TestConnectionsAsync()
        };

        var response = req.CreateResponse(HttpStatusCode.OK);
        response.Headers.Add("Content-Type", "application/json; charset=utf-8");
        await response.WriteStringAsync(JsonSerializer.Serialize(status, new JsonSerializerOptions
        {
            PropertyNamingPolicy = JsonNamingPolicy.CamelCase,
            WriteIndented = true
        }));

        return response;
    }

    private AuthenticationStatus GetAuthenticationStatus(HttpRequestData req)
    {
        // EasyAuth injects user info via headers
        var principalHeader = req.Headers.TryGetValues("x-ms-client-principal", out var principalValues)
            ? principalValues.FirstOrDefault()
            : null;
        var principalIdHeader = req.Headers.TryGetValues("x-ms-client-principal-id", out var idValues)
            ? idValues.FirstOrDefault()
            : null;
        var principalNameHeader = req.Headers.TryGetValues("x-ms-client-principal-name", out var nameValues)
            ? nameValues.FirstOrDefault()
            : null;

        var isAuthenticated = !string.IsNullOrEmpty(principalIdHeader);

        return new AuthenticationStatus
        {
            IsAuthenticated = isAuthenticated,
            UserId = isAuthenticated ? principalIdHeader : null,
            UserName = isAuthenticated ? principalNameHeader : null,
            Message = isAuthenticated
                ? "Authenticated via EasyAuth"
                : "Not authenticated (anonymous access)"
        };
    }

    private async Task<ConnectionTests> TestConnectionsAsync()
    {
        var results = new ConnectionTests();

        // Test Table Storage connection
        try
        {
            var storageConnectionString = Environment.GetEnvironmentVariable("AzureWebJobsStorage");
            if (string.IsNullOrEmpty(storageConnectionString))
            {
                results.TableStorage = new ConnectionTest
                {
                    Status = "error",
                    Message = "AzureWebJobsStorage connection string not configured"
                };
            }
            else
            {
                var tableServiceClient = new TableServiceClient(storageConnectionString);
                // Simple operation to verify connection
                await tableServiceClient.GetPropertiesAsync();

                results.TableStorage = new ConnectionTest
                {
                    Status = "ok",
                    Message = "Table Storage connection verified"
                };
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Table Storage connection test failed");
            results.TableStorage = new ConnectionTest
            {
                Status = "error",
                Message = $"Connection failed: {ex.Message}"
            };
        }

        // Test ACS configuration (not actual email sending)
        try
        {
            var acsConnectionString = Environment.GetEnvironmentVariable("ACS_CONNECTION_STRING");
            if (string.IsNullOrEmpty(acsConnectionString))
            {
                results.AzureCommunicationServices = new ConnectionTest
                {
                    Status = "warning",
                    Message = "ACS_CONNECTION_STRING not configured (optional for initial deployment)"
                };
            }
            else
            {
                // Just verify the connection string is present and formatted correctly
                // Don't actually connect or send emails in this verification
                var isValidFormat = acsConnectionString.Contains("endpoint=", StringComparison.OrdinalIgnoreCase);

                results.AzureCommunicationServices = new ConnectionTest
                {
                    Status = isValidFormat ? "ok" : "warning",
                    Message = isValidFormat
                        ? "ACS connection string configured (format verified)"
                        : "ACS connection string format may be invalid"
                };
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "ACS configuration test failed");
            results.AzureCommunicationServices = new ConnectionTest
            {
                Status = "error",
                Message = $"Configuration check failed: {ex.Message}"
            };
        }

        return results;
    }
}

public record StatusResponse
{
    public DateTime Timestamp { get; init; }
    public string Environment { get; init; } = string.Empty;
    public AuthenticationStatus Authentication { get; init; } = new();
    public ConnectionTests Connections { get; init; } = new();
}

public record AuthenticationStatus
{
    public bool IsAuthenticated { get; init; }
    public string? UserId { get; init; }
    public string? UserName { get; init; }
    public string Message { get; init; } = string.Empty;
}

public record ConnectionTests
{
    public ConnectionTest TableStorage { get; set; } = new();
    public ConnectionTest AzureCommunicationServices { get; set; } = new();
}

public record ConnectionTest
{
    public string Status { get; set; } = "unknown";
    public string Message { get; set; } = string.Empty;
}
