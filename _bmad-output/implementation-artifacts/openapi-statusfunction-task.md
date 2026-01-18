# Implementation Task: Add OpenAPI Support to StatusFunction

**Created:** 2026-01-18
**Epic:** Epic 1 - Join & Trust (Infrastructure Support)
**Priority:** Medium
**Estimated Complexity:** Low

## Context

The architecture specifies that all Azure Functions HTTP endpoints must have OpenAPI specification generation enabled using `Microsoft.Azure.Functions.Worker.Extensions.OpenApi`. Currently, the `StatusFunction` has excellent XML documentation but lacks OpenAPI attributes and configuration.

**Reference:** `_bmad-output/planning-artifacts/architecture/core-architectural-decisions.md` (lines 89-95)

## Current State

**StatusFunction (`apps/api/src/Functions/StatusFunction.cs`):**
- ✅ Has comprehensive XML documentation on all methods and DTOs
- ✅ Returns well-structured JSON response (`StatusResponse` DTO)
- ❌ Missing OpenAPI attributes (`[OpenApiOperation]`, `[OpenApiResponseWithBody]`)
- ❌ No OpenAPI metadata for endpoint discoverability

**Project Configuration (`apps/api/src/Collabolatte.Api.csproj`):**
- ✅ Has `<GenerateDocumentationFile>true</GenerateDocumentationFile>`
- ❌ Missing `Microsoft.Azure.Functions.Worker.Extensions.OpenApi` package reference
- ❌ Missing `<_FunctionsSkipCleanOutput>true</_FunctionsSkipCleanOutput>` property (required to prevent DLL removal during publishing)

**Host Configuration (`apps/api/src/Program.cs`):**
- ❌ Missing OpenAPI service registration (`.ConfigureOpenApi()`)

## Implementation Tasks

### Task 1: Update Project File
**File:** `apps/api/src/Collabolatte.Api.csproj`

1. Add package reference:
   ```xml
   <PackageReference Include="Microsoft.Azure.Functions.Worker.Extensions.OpenApi" Version="1.6.0" />
   ```

2. Add property to prevent DLL removal during deployment:
   ```xml
   <_FunctionsSkipCleanOutput>true</_FunctionsSkipCleanOutput>
   ```
   (Add this inside the `<PropertyGroup>` section)

### Task 2: Configure OpenAPI in Program.cs
**File:** `apps/api/src/Program.cs`

~~Add OpenAPI configuration after `ConfigureFunctionsWebApplication()`:~~
~~```csharp
builder.ConfigureFunctionsWebApplication();
builder.ConfigureOpenApi(); // Add this line
```~~

**LESSON LEARNED:** No explicit configuration needed in Program.cs when using `FunctionsApplication.CreateBuilder()` pattern. The OpenAPI extension auto-registers when the package is referenced and attributes are applied to functions.

Optionally add a clarifying comment:
```csharp
// Note: OpenAPI is enabled via Microsoft.Azure.Functions.Worker.Extensions.OpenApi package
// and [OpenApiOperation] attributes on functions - no explicit Program.cs configuration needed
```

### Task 3: Add OpenAPI Attributes to StatusFunction
**File:** `apps/api/src/Functions/StatusFunction.cs`

Add the following using statement at the top:
```csharp
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Enums;
```

**Note:** Despite the package name being `Functions.Worker.Extensions.OpenApi`, the namespace remains `WebJobs.Extensions.OpenApi.Core.Attributes` (Microsoft preserved the namespace during migration).

Decorate the `Run` method with OpenAPI attributes (add before the `[Function("Status")]` attribute):
```csharp
[OpenApiOperation(operationId: "GetStatus", tags: new[] { "Health" },
    Summary = "Service health and configuration status",
    Description = "Returns service status including environment, authentication state, and connectivity checks for dependent services.")]
[OpenApiResponseWithBody(statusCode: HttpStatusCode.OK,
    contentType: "application/json",
    bodyType: typeof(StatusResponse),
    Description = "Status information including timestamp, environment, authentication, and connection test results")]
```

## Expected Outcomes

1. **OpenAPI Specification Available:** When running the API locally (`func start`), the console output should show:
   - OpenAPI spec endpoint: `http://localhost:7071/api/swagger.json`
   - Swagger UI endpoint: `http://localhost:7071/api/swagger/ui`

2. **Swagger UI Accessible:** Navigating to the Swagger UI endpoint in a browser should display:
   - The `GET /api/status` endpoint under the "Health" tag
   - Complete request/response documentation
   - "Try it out" functionality

3. **OpenAPI Spec Validation:** The generated `/api/swagger.json` should include:
   - Proper operation metadata (operationId: "GetStatus", tags: ["Health"])
   - Complete schema for `StatusResponse` and nested DTOs
   - Response definitions with status codes and content types

## Acceptance Criteria

- [ ] Package `Microsoft.Azure.Functions.Worker.Extensions.OpenApi` v1.6.0+ added to `.csproj`
- [ ] `<_FunctionsSkipCleanOutput>true</_FunctionsSkipCleanOutput>` added to `.csproj`
- [ ] `.ConfigureOpenApi()` called in `Program.cs`
- [ ] `StatusFunction.Run()` method decorated with `[OpenApiOperation]` and `[OpenApiResponseWithBody]` attributes
- [ ] API builds successfully with no warnings (`dotnet build`)
- [ ] Swagger UI accessible at `/api/swagger/ui` when running locally
- [ ] OpenAPI spec at `/api/swagger.json` includes correct schema for `StatusResponse`
- [ ] All existing tests pass (`dotnet test`)

## Testing Plan

### Manual Verification
1. Run `dotnet build` from `apps/api/src` - verify no errors
2. Run `func start` from `apps/api/src` - verify OpenAPI endpoints logged to console
3. Navigate to `http://localhost:7071/api/swagger/ui` - verify UI loads
4. Verify endpoint documentation shows:
   - Summary: "Service health and configuration status"
   - Response schema includes all DTO properties
5. Click "Try it out" and execute - verify 200 OK response
6. Navigate to `http://localhost:7071/api/swagger.json` - verify JSON schema is valid

### Automated Verification
1. Run existing unit tests: `dotnet test` from `apps/api/tests`
2. Verify build succeeds in CI/CD pipeline

## Architecture Compliance

This task implements the architectural decision specified in:
- **Document:** `core-architectural-decisions.md`
- **Section:** "API & Communication Patterns"
- **Requirement:** "API Documentation: OpenAPI specification generated via Azure Functions OpenAPI extension"

All OpenAPI attributes align with existing XML documentation to maintain consistency.

## Notes

- The XML documentation comments are already excellent and should remain unchanged
- The OpenAPI attributes complement (not replace) the XML docs
- The namespace `Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes` is correct despite the package name difference
- This pattern should be applied to all future HTTP trigger functions as they're created

## Related Files

- Architecture Decision: `_bmad-output/planning-artifacts/architecture/core-architectural-decisions.md` (lines 89-95)
- Implementation Pattern: `_bmad-output/planning-artifacts/architecture/implementation-patterns-consistency-rules.md` (lines 72-76, 110)
- Current Function: `apps/api/src/Functions/StatusFunction.cs`
- Project File: `apps/api/src/Collabolatte.Api.csproj`
- Host Configuration: `apps/api/src/Program.cs`

---

## ✅ Implementation Complete (2026-01-18)

### Lessons Learned

**1. No Explicit Program.cs Configuration Required**
- Initial research suggested calling `.ConfigureOpenApi()` in Program.cs
- **Reality:** When using `FunctionsApplication.CreateBuilder()` pattern (modern .NET 9 approach), the OpenAPI extension auto-registers
- **Evidence:** Build succeeded without explicit configuration call; endpoints registered automatically
- **Conclusion:** Documentation for older `HostBuilder()` pattern does not apply to newer `FunctionsApplication.CreateBuilder()` pattern

**2. Package Auto-Discovery Works Perfectly**
- Simply adding the NuGet package reference triggers OpenAPI endpoint registration
- No services.AddOpenApi() or middleware configuration needed
- Functions runtime automatically exposes:
  - `/api/swagger/ui` - Swagger UI interface
  - `/api/swagger.json` - Swagger 2.0 specification
  - `/api/openapi/{version}.{extension}` - OpenAPI specification

**3. Namespace Quirk is Intentional**
- Package: `Microsoft.Azure.Functions.Worker.Extensions.OpenApi`
- Namespace: `Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes`
- This is Microsoft's deliberate choice to preserve namespace compatibility during isolated worker migration
- Not a mistake; don't try to "fix" it

**4. Attribute-Based Documentation Works Well**
- OpenAPI attributes complement (not replace) XML documentation comments
- XML docs provide IntelliSense for developers
- OpenAPI attributes provide runtime API documentation for consumers
- Both should be maintained for complete coverage

**5. Schema Generation is Automatic and Accurate**
- DTOs automatically generate OpenAPI schemas
- Record types work perfectly
- Nested DTOs are properly referenced via `$ref`
- CamelCase naming is correctly applied in generated JSON schema

### Verification Results

**Build Output:**
```
Build succeeded.
    0 Warning(s)
    0 Error(s)
```

**Registered Functions:**
```
Functions:
    RenderOAuth2Redirect: [GET] http://localhost:7071/api/oauth2-redirect.html
    RenderOpenApiDocument: [GET] http://localhost:7071/api/openapi/{version}.{extension}
    RenderSwaggerDocument: [GET] http://localhost:7071/api/swagger.{extension}
    RenderSwaggerUI: [GET] http://localhost:7071/api/swagger/ui
    Status: [GET] http://localhost:7071/api/status
```

**OpenAPI Spec Quality:**
- ✅ Operation ID: `GetStatus`
- ✅ Tags: `["Health"]`
- ✅ Complete schema for `StatusResponse` with all nested DTOs
- ✅ Proper camelCase naming throughout
- ✅ Summary and description from attributes present

**Endpoint Functionality:**
- ✅ Status endpoint returns correct JSON structure
- ✅ All existing functionality preserved
- ✅ No breaking changes

### Pattern for Future Functions

Apply this exact pattern to all future HTTP trigger Functions:

1. **Add OpenAPI attributes** to the Function method:
   ```csharp
   [OpenApiOperation(operationId: "...", tags: new[] { "..." },
       Summary = "...",
       Description = "...")]
   [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK,
       contentType: "application/json",
       bodyType: typeof(ResponseDto),
       Description = "...")]
   [Function("FunctionName")]
   public async Task<HttpResponseData> Run(...)
   ```

2. **Maintain XML documentation** for IntelliSense:
   ```csharp
   /// <summary>Description</summary>
   /// <param name="req">Request parameter</param>
   /// <returns>Response description</returns>
   ```

3. **No Program.cs changes needed** - OpenAPI auto-registers

### References

- [Azure Functions OpenAPI Extension GitHub](https://github.com/Azure/azure-functions-openapi-extension)
- [Using OpenAPI on Azure Function .NET 8 isolated](https://anthonygiretti.com/2024/11/04/net-from-net-6-to-net-8-my-migration-experience-using-openapi-on-azure-function-on-net-8-isolated/)
- [General Availability of Azure Functions OpenAPI Extension](https://techcommunity.microsoft.com/blog/appsonazureblog/general-availability-of-azure-functions-openapi-extension/2931231)
