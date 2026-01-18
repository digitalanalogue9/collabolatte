# API Tests

Unit and integration tests for the Collabolatte API using TUnit.

## Structure

```text
tests/
├── Unit/              # Unit tests for individual components
├── Integration/       # Integration tests with external dependencies
└── GlobalUsings.cs    # Global using statements
```

## Running Tests

```bash
# From api directory
dotnet test

# Run with detailed output
dotnet test --logger "console;verbosity=detailed"

# Run specific test
dotnet test --filter "FullyQualifiedName~SampleTests"

# Run with code coverage
dotnet test --collect:"XPlat Code Coverage" --results-directory ../../test-results/coverage-raw

# From root
pnpm test:api
```

## Code Coverage

The project uses **Coverlet** for code coverage collection and **ReportGenerator** to produce HTML
reports.

### Quick Start

```bash
# From repository root - runs tests with coverage and generates reports
.\scripts\code-coverage\Update-CodeCoverageArtifacts.ps1

# View the HTML report
start test-results/coverage-report/index.html
```

### Coverage Scripts

Located in [`scripts/code-coverage/`](../../scripts/code-coverage/):

- **`Update-CodeCoverageArtifacts.ps1`** - Runs tests with coverage, generates HTML/JSON reports
- **`New-CoverageSummary.ps1`** - Generates AI-friendly markdown summaries of coverage gaps
- **`New-CoveragePromptBuilder.ps1`** - Creates detailed prompts for improving specific low-coverage
  files
- **`CrapReport.psm1`** - Analyses CRAP (Change Risk Anti-Patterns) scores to identify complex,
  poorly tested code

### Coverage Output

All coverage artifacts are written to `test-results/`:

```text
test-results/
├── coverage-raw/          # Raw coverlet output (cobertura XML)
├── coverage-report/       # HTML reports + AI summaries
│   ├── index.html         # Main coverage report
│   ├── AI-SUMMARY.md      # AI-friendly coverage analysis
│   └── Summary.json       # JSON summary data
└── ai-prompts/            # Generated prompts for coverage improvements
```

### Coverage Configuration

Coverage is configured in [`Collabolatte.runsettings`](../../Collabolatte.runsettings):

- Format: Cobertura XML
- Excludes: Test assemblies, generated code, compiler-generated code
- Skips: Auto-properties

### CI Integration

Run coverage as part of CI/CD to track coverage trends and enforce minimum thresholds (target: 80%).

```bash
# Example CI step
dotnet test --settings Collabolatte.runsettings --collect:"XPlat Code Coverage"
```

## Writing Tests

### Unit Tests (TUnit)

```csharp
using TUnit.Core;

public class MyServiceTests
{
    [Test]
    public async Task MyMethod_Should_ReturnExpectedResult()
    {
        // Arrange
        var service = new MyService();

        // Act
        var result = await service.MyMethod();

        // Assert
        await Assert.That(result).IsNotNull();
    }
}
```

### Using FluentAssertions

```csharp
[Test]
public async Task MyMethod_Should_ReturnValidData()
{
    // Arrange
    var service = new MyService();

    // Act
    var result = await service.GetData();

    // Assert
    result.Should().NotBeNull();
    result.Items.Should().HaveCount(3);
    result.Status.Should().Be("Success");

    await Task.CompletedTask;
}
```

### Mocking with Moq

```csharp
[Test]
public async Task MyService_Should_CallRepository()
{
    // Arrange
    var mockRepo = new Mock<IRepository>();
    mockRepo.Setup(r => r.GetData()).ReturnsAsync(new Data());

    var service = new MyService(mockRepo.Object);

    // Act
    await service.ProcessData();

    // Assert
    mockRepo.Verify(r => r.GetData(), Times.Once);
}
```

## Test Conventions

- **Name tests clearly:** `MethodName_Scenario_ExpectedBehavior`
- **Use Arrange-Act-Assert** pattern
- **One assertion per test** (when possible)
- **Mock external dependencies** in unit tests
- **Use FluentAssertions** for readable assertions
- **Test public APIs** only, not implementation details

## Integration Tests

Integration tests should:

- Use real Azure services (Storage, etc.) with test accounts
- Clean up test data after each run
- Be isolated from each other
- Run in CI/CD pipeline with proper credentials

## Resources

- [TUnit Documentation](https://thomhurst.github.io/TUnit/)
- [FluentAssertions Documentation](https://fluentassertions.com/)
- [Moq Documentation](https://github.com/moq/moq4)
- [Coverlet Documentation](https://github.com/coverlet-coverage/coverlet)
- [ReportGenerator Documentation](https://github.com/danielpalme/ReportGenerator)
