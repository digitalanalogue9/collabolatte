using Microsoft.Azure.Functions.Worker.Builder;
using Microsoft.Extensions.Hosting;

var builder = FunctionsApplication.CreateBuilder(args);

builder.ConfigureFunctionsWebApplication();

// Note: Application Insights is not used in MVP (per architecture decision)
// Add services here as needed

builder.Build().Run();
