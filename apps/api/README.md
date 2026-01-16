# Collabolatte API

Azure Functions API for the Collabolatte platform.

## Project Structure

```
apps/api/
├── Collabolatte.Api.sln      # Solution file
├── src/                       # API source code
│   ├── Collabolatte.Api.csproj
│   ├── Program.cs
│   ├── host.json
│   ├── local.settings.json
│   ├── Functions/            # HTTP triggered functions
│   ├── Models/               # Data models
│   ├── Services/             # Business logic
│   └── Repositories/         # Data access
└── tests/                     # Test project
    ├── Collabolatte.Api.Tests.csproj
    ├── Unit/                 # Unit tests
    └── Integration/          # Integration tests
```

## Technology Stack

- **.NET 10** - Latest .NET runtime
- **Azure Functions v4** - Serverless compute
- **Azure Cosmos DB** - NoSQL database
- **TUnit** - Modern testing framework
- **FluentAssertions** - Readable assertions
- **Moq** - Mocking framework

## Getting Started

### Prerequisites

- .NET 10 SDK
- Azure Functions Core Tools v4
- Azure Storage Emulator or Azurite

### Installation

```bash
# Install dependencies (from root)
dotnet restore apps/api/Collabolatte.Api.sln
```

### Development

```bash
# Build the API
dotnet build apps/api/Collabolatte.Api.sln

# Run the API locally
cd apps/api/src
func start

# Or use VS Code task: "build (functions)" then "func: host start"
```

The API will be available at `http://localhost:7071`

### Testing

```bash
# Run all tests
dotnet test apps/api/Collabolatte.Api.sln

# Run tests with detailed output
dotnet test apps/api/Collabolatte.Api.sln --logger "console;verbosity=detailed"

# Run tests in watch mode
dotnet watch test --project apps/api/tests/Collabolatte.Api.Tests.csproj

# From root
pnpm test:api
pnpm test:api:watch
```

## Configuration

### Local Settings

Create or update `src/local.settings.json`:

```json
{
  "IsEncrypted": false,
  "Values": {
    "AzureWebJobsStorage": "UseDevelopmentStorage=true",
    "FUNCTIONS_WORKER_RUNTIME": "dotnet-isolated",
    "CosmosDb__AccountEndpoint": "https://localhost:8081",
    "CosmosDb__AccountKey": "<emulator-key>",
    "CosmosDb__DatabaseName": "collabolatte-dev"
  }
}
```

### Environment Variables

- `CosmosDb__AccountEndpoint` - Cosmos DB endpoint
- `CosmosDb__AccountKey` - Cosmos DB key
- `CosmosDb__DatabaseName` - Database name

## API Endpoints

### Health Check

- `GET /api/health` - Returns API health status

### Users

- `GET /api/users` - Get all users
- `GET /api/users/{id}` - Get user by ID
- `POST /api/users` - Create new user
- `PUT /api/users/{id}` - Update user
- `DELETE /api/users/{id}` - Delete user

### Workspaces

- `GET /api/workspaces` - Get all workspaces
- `GET /api/workspaces/{id}` - Get workspace by ID
- `POST /api/workspaces` - Create new workspace
- `PUT /api/workspaces/{id}` - Update workspace
- `DELETE /api/workspaces/{id}` - Delete workspace

## Development Guidelines

### Code Organization

- **Functions/** - HTTP triggers and function entry points
- **Services/** - Business logic and orchestration
- **Repositories/** - Data access layer (Cosmos DB interactions)
- **Models/** - DTOs, entities, and domain models
- **Extensions/** - Extension methods and utilities

### Testing Strategy

- **Unit Tests** - Test individual components in isolation
- **Integration Tests** - Test with real Azure services
- **Contract Tests** - Verify API contracts remain stable

### Best Practices

1. **Use dependency injection** - Register services in `Program.cs`
2. **Keep functions thin** - Move logic to services
3. **Log diagnostics** - Use Cosmos DB diagnostics for monitoring
4. **Handle errors gracefully** - Return appropriate HTTP status codes
5. **Use partition keys wisely** - Follow Cosmos DB best practices
6. **Validate input** - Use FluentValidation for request validation

## Deployment

### Local Testing with SWA CLI

```bash
# From root directory
swa start apps/web/dist --api-location apps/api/src
```

### Azure Deployment

Deployed via GitHub Actions to Azure Static Web App with integrated Functions.

See `.github/workflows/swa-app.yml` for deployment configuration.

## Troubleshooting

### Functions not starting

1. Ensure Azure Storage Emulator or Azurite is running
2. Check `local.settings.json` configuration
3. Verify .NET 10 SDK is installed
4. Run `dotnet clean` then `dotnet build`

### Tests failing

1. Ensure Cosmos DB emulator is running for integration tests
2. Check test configuration in `Collabolatte.Api.Tests.csproj`
3. Run `dotnet restore` to update packages

### VS Code debugging not working

1. Check `.vscode/tasks.json` paths are correct
2. Ensure `azureFunctions.projectSubpath` in settings points to `apps/api/src`
3. Rebuild the solution before debugging

## Resources

- [Azure Functions .NET Isolated Documentation](https://learn.microsoft.com/azure/azure-functions/dotnet-isolated-process-guide)
- [Cosmos DB Best Practices](https://learn.microsoft.com/azure/cosmos-db/nosql/best-practice-dotnet)
- [TUnit Documentation](https://thomhurst.github.io/TUnit/)
