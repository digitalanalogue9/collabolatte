namespace Collabolatte.Api.Tests.Unit;

/// <summary>
/// Example unit test using TUnit
/// </summary>
public class SampleTests
{
    [Test]
    public async Task Example_Test_Should_Pass()
    {
        // Arrange
        var expected = 42;

        // Act
        var actual = 42;

        // Assert
        await Assert.That(actual).IsEqualTo(expected);
    }

    [Test]
    public async Task Example_FluentAssertions_Test()
    {
        // Arrange
        var list = new List<int> { 1, 2, 3 };

        // Act & Assert
        list.Should().HaveCount(3);
        list.Should().Contain(2);
        
        await Task.CompletedTask;
    }
}
