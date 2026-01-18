using System.Net;
using System.Text.Json;
using Azure.Data.Tables;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
using Microsoft.Extensions.Logging;

namespace Collabolatte.Api.Functions;

/// <summary>
/// Provides a status endpoint for service health and configuration checks.
/// </summary>
public class StatusFunction
{
    private readonly ILogger<StatusFunction> _logger;

    /// <summary>
    /// Initializes a new instance of the <see cref="StatusFunction"/> class.
    /// </summary>
    /// <param name="logger">Logger for request-scoped diagnostics.</param>
    public StatusFunction(ILogger<StatusFunction> logger)
    {
        _logger = logger;
    }

    /// <summary>
    /// Returns a JSON payload describing service status and configuration checks.
    /// </summary>
    /// <param name="req">The incoming HTTP request.</param>
    /// <returns>An HTTP 200 response containing the status payload.</returns>
    [OpenApiOperation(operationId: "GetStatus", tags: new[] { "Health" },
        Summary = "Service health and configuration status",
        Description = "Returns service status including environment, authentication state, and connectivity checks for dependent services.")]
    [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK,
        contentType: "application/json",
        bodyType: typeof(StatusResponse),
        Description = "Status information including timestamp, environment, authentication, and connection test results")]
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

/// <summary>
/// DTO describing the current service status snapshot.
/// </summary>
public record StatusResponse
{
    /// <summary>
    /// UTC timestamp when the status was generated.
    /// </summary>
    public DateTime Timestamp { get; init; }
    /// <summary>
    /// The runtime environment name as reported by the Functions host.
    /// </summary>
    public string Environment { get; init; } = string.Empty;
    /// <summary>
    /// Authentication status derived from SWA EasyAuth headers.
    /// </summary>
    public AuthenticationStatus Authentication { get; init; } = new();
    /// <summary>
    /// Connectivity checks for dependent services.
    /// </summary>
    public ConnectionTests Connections { get; init; } = new();
}

/// <summary>
/// DTO describing authentication state inferred from platform headers.
/// </summary>
public record AuthenticationStatus
{
    /// <summary>
    /// Indicates whether the request is authenticated via EasyAuth.
    /// </summary>
    public bool IsAuthenticated { get; init; }
    /// <summary>
    /// The authenticated user ID when available.
    /// </summary>
    public string? UserId { get; init; }
    /// <summary>
    /// The authenticated user display name when available.
    /// </summary>
    public string? UserName { get; init; }
    /// <summary>
    /// Human-readable authentication status message.
    /// </summary>
    public string Message { get; init; } = string.Empty;
}

/// <summary>
/// DTO containing connectivity test results.
/// </summary>
public record ConnectionTests
{
    /// <summary>
    /// Table Storage connection test result.
    /// </summary>
    public ConnectionTest TableStorage { get; set; } = new();
    /// <summary>
    /// Azure Communication Services configuration test result.
    /// </summary>
    public ConnectionTest AzureCommunicationServices { get; set; } = new();
}

/// <summary>
/// DTO representing a single connection test outcome.
/// </summary>
public record ConnectionTest
{
    /// <summary>
    /// Status identifier (e.g., ok, warning, error).
    /// </summary>
    public string Status { get; set; } = "unknown";
    /// <summary>
    /// Human-readable detail about the test outcome.
    /// </summary>
    public string Message { get; set; } = string.Empty;
}
