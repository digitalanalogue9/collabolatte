# API Tests

Unit and integration tests for the Collabolatte API using TUnit.

## Structure

```
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

# From root
pnpm test:api
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

- Use real Azure services (Cosmos DB, Storage, etc.) with test accounts
- Clean up test data after each run
- Be isolated from each other
- Run in CI/CD pipeline with proper credentials

## Resources

- [TUnit Documentation](https://thomhurst.github.io/TUnit/)
- [FluentAssertions Documentation](https://fluentassertions.com/)
- [Moq Documentation](https://github.com/moq/moq4)
