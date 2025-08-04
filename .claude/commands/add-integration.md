---
description: Add third-party service integration with proper authentication, error handling, and testing
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, WebSearch, TodoWrite]
argument-hint: service name and purpose (e.g., "weather-api for irrigation planning" or "payment-gateway stripe")
agent-dependencies: [Tech Lead, Security Reviewer, Researcher]
complexity: complex
estimated-time: 30-45 minutes
category: development
---

# 🔌 Add Integration: $ARGUMENTS

## Quick Context
Use this command to integrate third-party services into the vineyard management system with proper architecture, security, and error handling.

## Execution Flow
1. **Research** - Understand the service and best practices
2. **Architecture** - Design integration following system patterns
3. **Implementation** - Build with security and resilience
4. **Testing** - Comprehensive integration and unit tests

## Interactive Options
```yaml
auth-type: api-key|oauth2|jwt|custom (will prompt if not specified)
resilience: basic|advanced (circuit breaker, retry policies)
mock-service: true|false (create mock for testing)
```

## Phase 1: Integration Research & Planning

<think harder about integration requirements and architectural fit>

### Service Analysis
First, I'll research the service we're integrating and its requirements.

@Task(description="Research integration requirements", prompt="Research $ARGUMENTS integration:
1. API documentation and capabilities
2. Authentication methods and best practices
3. Rate limits and quotas
4. Pricing tiers and cost implications
5. Common integration patterns
6. Known issues or limitations
7. Alternative services comparison
8. Data formats and protocols
Provide comprehensive integration guide", subagent_type="general-purpose")

### Architectural Planning
@Task(description="Design integration architecture", prompt="Design architecture for $ARGUMENTS integration:
1. Where in clean architecture should this live
2. Abstraction strategy (interfaces, adapters)
3. Configuration management approach
4. Caching strategy for API responses
5. Error handling and resilience patterns
6. Multi-tenant considerations
7. Performance impact assessment
8. Monitoring and observability needs
Provide architectural blueprint with diagrams", subagent_type="general-purpose")

## Phase 2: Security & Compliance Design

<think about security implications and multi-tenant isolation>

### Security Assessment
@Task(description="Security analysis for integration", prompt="Analyze security for $ARGUMENTS integration:
1. Authentication security (key storage, rotation)
2. Data transmission security (TLS, encryption)
3. Input validation requirements
4. Output sanitization needs
5. Multi-tenant data isolation
6. Audit logging requirements
7. Compliance implications (GDPR, etc.)
8. Secret management strategy
Provide security implementation checklist", subagent_type="general-purpose")

### Integration Planning
Based on the analysis, I'll create the integration structure:

```
src/
├── PTA.VineyardManagement.Domain/
│   └── ExternalServices/
│       └── I{Service}Service.cs
├── PTA.VineyardManagement.Infrastructure/
│   └── ExternalServices/
│       ├── {Service}/
│       │   ├── {Service}Service.cs
│       │   ├── {Service}Configuration.cs
│       │   ├── Models/
│       │   └── Exceptions/
│       └── DependencyInjection.cs
└── PTA.VineyardManagement.Api/
    └── Controllers/
        └── {Feature}Controller.cs (updated)
```

## Phase 3: Implementation

<think step-by-step about building a robust integration>

### 1. Define Service Interface
```csharp
namespace PTA.VineyardManagement.Domain.ExternalServices;

public interface IWeatherService
{
    Task<Result<WeatherData>> GetCurrentWeatherAsync(
        Coordinates location, 
        CancellationToken cancellationToken = default);
    
    Task<Result<WeatherForecast>> GetForecastAsync(
        Coordinates location, 
        int days, 
        CancellationToken cancellationToken = default);
    
    Task<Result<HistoricalWeather>> GetHistoricalDataAsync(
        Coordinates location, 
        DateRange period, 
        CancellationToken cancellationToken = default);
}

public record WeatherData(
    decimal Temperature,
    decimal Humidity,
    decimal Precipitation,
    decimal WindSpeed,
    string Conditions,
    DateTime Timestamp);
```

### 2. Configuration Model
```csharp
namespace PTA.VineyardManagement.Infrastructure.ExternalServices.Weather;

public class WeatherServiceConfiguration
{
    public const string SectionName = "WeatherService";
    
    public string ApiKey { get; set; }
    public string BaseUrl { get; set; }
    public int TimeoutSeconds { get; set; } = 30;
    public int MaxRetries { get; set; } = 3;
    public bool EnableCaching { get; set; } = true;
    public int CacheDurationMinutes { get; set; } = 15;
    
    public void Validate()
    {
        if (string.IsNullOrWhiteSpace(ApiKey))
            throw new InvalidOperationException("Weather API key is required");
            
        if (string.IsNullOrWhiteSpace(BaseUrl))
            throw new InvalidOperationException("Weather API base URL is required");
    }
}
```

### 3. Service Implementation with Resilience
```csharp
namespace PTA.VineyardManagement.Infrastructure.ExternalServices.Weather;

public class WeatherService : IWeatherService
{
    private readonly HttpClient _httpClient;
    private readonly IOptions<WeatherServiceConfiguration> _options;
    private readonly IDistributedCache _cache;
    private readonly ILogger<WeatherService> _logger;
    private readonly IResiliencePipeline _resiliencePipeline;
    
    public WeatherService(
        HttpClient httpClient,
        IOptions<WeatherServiceConfiguration> options,
        IDistributedCache cache,
        ILogger<WeatherService> logger)
    {
        _httpClient = httpClient;
        _options = options;
        _cache = cache;
        _logger = logger;
        
        // Configure resilience pipeline
        _resiliencePipeline = new ResiliencePipelineBuilder()
            .AddRetry(new RetryStrategyOptions
            {
                MaxRetryAttempts = _options.Value.MaxRetries,
                Delay = TimeSpan.FromSeconds(1),
                BackoffType = DelayBackoffType.Exponential
            })
            .AddCircuitBreaker(new CircuitBreakerStrategyOptions
            {
                FailureRatio = 0.5,
                SamplingDuration = TimeSpan.FromSeconds(30),
                MinimumThroughput = 10,
                BreakDuration = TimeSpan.FromSeconds(30)
            })
            .AddTimeout(TimeSpan.FromSeconds(_options.Value.TimeoutSeconds))
            .Build();
    }
    
    public async Task<Result<WeatherData>> GetCurrentWeatherAsync(
        Coordinates location, 
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Check cache first
            var cacheKey = $"weather:current:{location.Latitude}:{location.Longitude}";
            if (_options.Value.EnableCaching)
            {
                var cached = await _cache.GetAsync<WeatherData>(cacheKey, cancellationToken);
                if (cached != null)
                {
                    _logger.LogDebug("Weather data retrieved from cache for {Location}", location);
                    return Result<WeatherData>.Success(cached);
                }
            }
            
            // Call external API with resilience
            var response = await _resiliencePipeline.ExecuteAsync(async ct =>
            {
                var url = $"current?lat={location.Latitude}&lon={location.Longitude}";
                return await _httpClient.GetAsync(url, ct);
            }, cancellationToken);
            
            if (!response.IsSuccessStatusCode)
            {
                _logger.LogWarning(
                    "Weather API returned {StatusCode} for location {Location}",
                    response.StatusCode, location);
                    
                return Result<WeatherData>.Failure(
                    $"Weather service unavailable: {response.StatusCode}");
            }
            
            var content = await response.Content.ReadAsStringAsync(cancellationToken);
            var apiResponse = JsonSerializer.Deserialize<WeatherApiResponse>(content);
            
            var weatherData = MapToWeatherData(apiResponse);
            
            // Cache the result
            if (_options.Value.EnableCaching)
            {
                await _cache.SetAsync(
                    cacheKey, 
                    weatherData,
                    new DistributedCacheEntryOptions
                    {
                        AbsoluteExpirationRelativeToNow = 
                            TimeSpan.FromMinutes(_options.Value.CacheDurationMinutes)
                    },
                    cancellationToken);
            }
            
            return Result<WeatherData>.Success(weatherData);
        }
        catch (TaskCanceledException)
        {
            _logger.LogWarning("Weather API request timed out for {Location}", location);
            return Result<WeatherData>.Failure("Weather service request timed out");
        }
        catch (BrokenCircuitException)
        {
            _logger.LogError("Weather API circuit breaker is open");
            return Result<WeatherData>.Failure("Weather service temporarily unavailable");
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error retrieving weather data for {Location}", location);
            return Result<WeatherData>.Failure("Failed to retrieve weather data");
        }
    }
    
    private WeatherData MapToWeatherData(WeatherApiResponse response)
    {
        return new WeatherData(
            Temperature: response.Main.Temp,
            Humidity: response.Main.Humidity,
            Precipitation: response.Rain?.OneHour ?? 0,
            WindSpeed: response.Wind.Speed,
            Conditions: response.Weather.FirstOrDefault()?.Description ?? "Unknown",
            Timestamp: DateTime.UtcNow);
    }
}
```

### 4. Dependency Injection Setup
```csharp
public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddWeatherService(
        this IServiceCollection services,
        IConfiguration configuration)
    {
        // Bind configuration
        services.Configure<WeatherServiceConfiguration>(
            configuration.GetSection(WeatherServiceConfiguration.SectionName));
            
        // Validate configuration at startup
        services.AddSingleton<IValidateOptions<WeatherServiceConfiguration>,
            WeatherServiceConfigurationValidator>();
        
        // Register HttpClient with base configuration
        services.AddHttpClient<IWeatherService, WeatherService>((sp, client) =>
        {
            var config = sp.GetRequiredService<IOptions<WeatherServiceConfiguration>>();
            client.BaseAddress = new Uri(config.Value.BaseUrl);
            client.DefaultRequestHeaders.Add("X-API-Key", config.Value.ApiKey);
            client.DefaultRequestHeaders.Add("Accept", "application/json");
        });
        
        // Add Polly for resilience
        services.AddResiliencePipeline("weather-service", builder =>
        {
            builder.AddRetry(new RetryStrategyOptions
            {
                MaxRetryAttempts = 3,
                Delay = TimeSpan.FromSeconds(1),
                BackoffType = DelayBackoffType.Exponential
            });
        });
        
        return services;
    }
}
```

### 5. Mock Service for Testing
```csharp
public class MockWeatherService : IWeatherService
{
    private readonly ILogger<MockWeatherService> _logger;
    
    public MockWeatherService(ILogger<MockWeatherService> logger)
    {
        _logger = logger;
    }
    
    public Task<Result<WeatherData>> GetCurrentWeatherAsync(
        Coordinates location,
        CancellationToken cancellationToken = default)
    {
        _logger.LogInformation("Mock weather service called for {Location}", location);
        
        // Return realistic test data
        var mockData = new WeatherData(
            Temperature: 22.5m + Random.Shared.Next(-5, 5),
            Humidity: 65m + Random.Shared.Next(-10, 10),
            Precipitation: Random.Shared.Next(0, 10),
            WindSpeed: 15m + Random.Shared.Next(-5, 5),
            Conditions: "Partly cloudy",
            Timestamp: DateTime.UtcNow);
            
        return Task.FromResult(Result<WeatherData>.Success(mockData));
    }
}
```

## Phase 4: Testing Strategy

<think about comprehensive testing for external integrations>

### Unit Tests
```csharp
public class WeatherServiceTests
{
    private readonly Mock<HttpMessageHandler> _httpHandlerMock;
    private readonly Mock<IDistributedCache> _cacheMock;
    private readonly ILogger<WeatherService> _logger;
    private readonly WeatherService _service;
    
    [Fact]
    public async Task GetCurrentWeather_WithValidLocation_ReturnsWeatherData()
    {
        // Arrange
        var location = new Coordinates(48.8566m, 2.3522m); // Paris
        var expectedResponse = new WeatherApiResponse { /* ... */ };
        
        _httpHandlerMock
            .Setup(/* ... */)
            .ReturnsAsync(new HttpResponseMessage
            {
                StatusCode = HttpStatusCode.OK,
                Content = new StringContent(JsonSerializer.Serialize(expectedResponse))
            });
        
        // Act
        var result = await _service.GetCurrentWeatherAsync(location);
        
        // Assert
        result.IsSuccess.Should().BeTrue();
        result.Value.Should().NotBeNull();
        result.Value.Temperature.Should().BeInRange(-50, 50);
    }
    
    [Fact]
    public async Task GetCurrentWeather_WhenApiUnavailable_ReturnsFailure()
    {
        // Test resilience and error handling
    }
    
    [Fact]
    public async Task GetCurrentWeather_UsesCache_WhenEnabled()
    {
        // Test caching behavior
    }
}
```

### Integration Tests
```csharp
public class WeatherServiceIntegrationTests : IClassFixture<WebApplicationFactory<Program>>
{
    [Fact]
    public async Task WeatherEndpoint_ReturnsCurrentWeather_ForField()
    {
        // Test full integration through API endpoint
    }
}
```

## Phase 5: API Integration

<think about exposing the integration through the API layer>

### Update Controller
```csharp
[ApiController]
[Route("api/v1/fields")]
[Authorize]
public class FieldsController : ControllerBase
{
    private readonly IWeatherService _weatherService;
    
    [HttpGet("{id}/weather/current")]
    [ProducesResponseType(typeof(WeatherDataDto), StatusCodes.Status200OK)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status404NotFound)]
    [ProducesResponseType(typeof(ProblemDetails), StatusCodes.Status503ServiceUnavailable)]
    public async Task<IActionResult> GetFieldWeather(Guid id)
    {
        var field = await _fieldService.GetByIdAsync(id, _userContext.OrganizationId);
        if (!field.IsSuccess)
            return NotFound();
            
        var weather = await _weatherService.GetCurrentWeatherAsync(
            field.Value.CenterPoint.ToCoordinates());
            
        if (!weather.IsSuccess)
        {
            return StatusCode(
                StatusCodes.Status503ServiceUnavailable,
                new ProblemDetails
                {
                    Title = "Weather Service Unavailable",
                    Detail = weather.Error,
                    Status = StatusCodes.Status503ServiceUnavailable
                });
        }
        
        return Ok(_mapper.Map<WeatherDataDto>(weather.Value));
    }
}
```

## Phase 6: Monitoring & Documentation

### Health Check
```csharp
public class WeatherServiceHealthCheck : IHealthCheck
{
    private readonly IWeatherService _weatherService;
    
    public async Task<HealthCheckResult> CheckHealthAsync(
        HealthCheckContext context,
        CancellationToken cancellationToken = default)
    {
        try
        {
            // Use a known location for health check
            var testLocation = new Coordinates(48.8566m, 2.3522m);
            var result = await _weatherService.GetCurrentWeatherAsync(
                testLocation, 
                cancellationToken);
                
            return result.IsSuccess
                ? HealthCheckResult.Healthy("Weather service is responsive")
                : HealthCheckResult.Unhealthy($"Weather service error: {result.Error}");
        }
        catch (Exception ex)
        {
            return HealthCheckResult.Unhealthy(
                "Weather service health check failed",
                ex);
        }
    }
}
```

### Configuration Documentation
```json
{
  "WeatherService": {
    "ApiKey": "your-api-key-here",
    "BaseUrl": "https://api.weather-provider.com/v1/",
    "TimeoutSeconds": 30,
    "MaxRetries": 3,
    "EnableCaching": true,
    "CacheDurationMinutes": 15
  }
}
```

## Success Criteria
- ✅ Service interface follows domain patterns
- ✅ Resilience patterns implemented (retry, circuit breaker)
- ✅ Proper error handling and logging
- ✅ Multi-tenant data isolation maintained
- ✅ Comprehensive test coverage (>80%)
- ✅ API documentation updated
- ✅ Health checks implemented
- ✅ Configuration validated at startup

## Error Handling Matrix

| Scenario | Response | User Message | Retry? |
|----------|----------|--------------|--------|
| API Key Invalid | 401 | "Configuration error" | No |
| Rate Limited | 429 | "Service busy, try later" | Yes |
| Network Error | 503 | "Service unavailable" | Yes |
| Invalid Response | 502 | "Service error" | No |
| Timeout | 504 | "Request timed out" | Yes |

## Final Checklist
- [ ] Service interface in Domain layer
- [ ] Implementation in Infrastructure layer
- [ ] Configuration with validation
- [ ] Resilience patterns (Polly)
- [ ] Caching strategy
- [ ] Comprehensive error handling
- [ ] Unit tests with mocks
- [ ] Integration tests
- [ ] API endpoint updated
- [ ] Health check added
- [ ] Documentation complete
- [ ] Secrets in configuration (not code)
- [ ] Monitoring/logging in place
- [ ] Feature flag for rollout (if needed)