using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.Hosting;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

// Note: OpenAPI is enabled via Microsoft.Azure.Functions.Worker.Extensions.OpenApi package
// and [OpenApiOperation] attributes on functions - no explicit Program.cs configuration needed

// Note: Application Insights is not used in MVP (per architecture decision)
// Add services here as needed

builder.Build().Run();
