---
description: Update backend feature with comprehensive testing and backward compatibility
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: backend feature update description (e.g., "update payment processing to support new gateway")
agent-dependencies: [Tech Lead, Security Reviewer, Code Reviewer, Test Quality Analyst]
complexity: moderate
estimated-time: 20-30 minutes
category: development
---

# 🔧 Update Backend Feature: $ARGUMENTS

## 🧠 OPUS 4 BACKEND OPTIMIZATION MODE
<think harder about backend-specific concerns: data integrity, transaction management, API contracts, and achieving 100% test success>

### Backend Excellence Principles
- **Data Integrity First**: ACID compliance, transaction boundaries
- **API Contract Preservation**: Backward compatible changes
- **Domain Logic Enhancement**: Business rule improvements
- **Cloud-Native Design**: Stateless, scalable, no monitoring overhead
- **Test-Driven Updates**: 100% test success before completion

## Phase 0: Backend Discovery & Planning

<think step-by-step about understanding the current backend implementation>

### Backend Component Discovery
```bash
# Parallel backend discovery
@Glob(pattern="**/Controllers/*$FEATURE*.*")
@Glob(pattern="**/Services/*$FEATURE*.*")
@Glob(pattern="**/Repositories/*$FEATURE*.*")
@Glob(pattern="**/Models/*$FEATURE*.*")
@Grep(pattern="class.*$FEATURE|interface.*$FEATURE", output_mode="files_with_matches")
```

### Backend Update Task List
@TodoWrite(todos=[
  {id: "1", content: "Analyze current backend implementation", status: "pending", priority: "high"},
  {id: "2", content: "Identify API contract requirements", status: "pending", priority: "high"},
  {id: "3", content: "Update domain models", status: "pending", priority: "high"},
  {id: "4", content: "Update repository layer", status: "pending", priority: "high"},
  {id: "5", content: "Update service layer", status: "pending", priority: "high"},
  {id: "6", content: "Update API controllers", status: "pending", priority: "high"},
  {id: "7", content: "Update database schema (backward compatible)", status: "pending", priority: "high"},
  {id: "8", content: "Generate comprehensive unit tests", status: "pending", priority: "high"},
  {id: "9", content: "Generate integration tests", status: "pending", priority: "high"},
  {id: "10", content: "Achieve 100% test success", status: "pending", priority: "high"}
])

## Phase 1: Parallel Backend Analysis

<think harder about backend architectural concerns and patterns>

### Specialized Backend Analysis

@Task(description="Backend architecture analysis", prompt="Analyze backend architecture for updating $ARGUMENTS:
1. Current design patterns used (Repository, UoW, CQRS)
2. Transaction boundary analysis
3. Database schema impacts
4. Caching layer implications
5. Message queue/event impacts
6. API versioning strategy
7. Performance implications
8. Scalability considerations
9. Data migration requirements
10. Rollback procedures
Provide technical implementation plan with risk assessment", subagent_type="general-purpose")

@Task(description="Security impact analysis", prompt="Analyze security implications of updating $ARGUMENTS:
1. Authentication/authorization changes
2. Input validation requirements
3. SQL injection prevention
4. Data encryption needs
5. Audit logging requirements
6. Rate limiting adjustments
7. CORS policy updates
8. Token management changes
9. Session handling impacts
10. Multi-tenant isolation verification
Provide security checklist with validation steps", subagent_type="general-purpose")

@Task(description="Code quality assessment", prompt="Review backend code quality for $ARGUMENTS:
1. SOLID principle adherence
2. Design pattern correctness
3. Error handling completeness
4. Logging strategy
5. Configuration management
6. Dependency injection usage
7. Code duplication analysis
8. Method complexity metrics
9. Class cohesion assessment
10. Documentation coverage
Provide refactoring recommendations", subagent_type="general-purpose")

@Task(description="Test strategy planning", prompt="Design backend test strategy for $ARGUMENTS:
1. Unit test coverage analysis
2. Repository test patterns
3. Service layer test scenarios
4. Controller test requirements
5. Integration test design
6. Database test strategies
7. Mock/stub requirements
8. Test data management
9. Performance test scenarios
10. Contract test requirements
Provide test implementation plan for 100% coverage", subagent_type="general-purpose")

## Phase 2: Domain Model Updates

<think step-by-step about updating domain models while preserving integrity>

### Domain Model Enhancement

#### Entity Updates with Backward Compatibility
```csharp
public class Feature
{
    // Existing properties maintained
    public Guid Id { get; private set; }
    public string Name { get; private set; }
    
    // New properties with defaults
    public string? NewProperty { get; private set; }
    public DateTime? UpdatedAt { get; private set; }
    
    // Backward compatible constructor overloads
    public Feature(string name) : this(name, null) { }
    
    public Feature(string name, string? newProperty)
    {
        Id = Guid.NewGuid();
        Name = name;
        NewProperty = newProperty;
        UpdatedAt = DateTime.UtcNow;
    }
    
    // New business logic methods
    public Result<Feature> UpdateWithNewLogic(UpdateCommand command)
    {
        // Validation
        if (!IsValid(command))
            return Result<Feature>.Failure("Validation failed");
            
        // Apply changes
        Name = command.Name;
        NewProperty = command.NewProperty;
        UpdatedAt = DateTime.UtcNow;
        
        // Raise domain event
        AddDomainEvent(new FeatureUpdatedEvent(this));
        
        return Result<Feature>.Success(this);
    }
}
```

## Phase 3: Repository Layer Updates

<think harder about data access patterns and optimization>

### Repository Enhancement

```csharp
public interface IFeatureRepository
{
    // Existing methods preserved
    Task<Feature?> GetByIdAsync(Guid id);
    Task<IEnumerable<Feature>> GetAllAsync();
    
    // New methods added
    Task<IEnumerable<Feature>> GetByNewCriteriaAsync(SearchCriteria criteria);
    Task<Result<Feature>> UpdateWithOptimisticLockingAsync(Feature feature);
}

public class FeatureRepository : IFeatureRepository
{
    private readonly DbContext _context;
    
    // Optimized query with includes
    public async Task<Feature?> GetByIdAsync(Guid id)
    {
        return await _context.Features
            .Include(f => f.RelatedData)  // New eager loading
            .AsSplitQuery()                // Optimization
            .FirstOrDefaultAsync(f => f.Id == id);
    }
    
    // New search with pagination
    public async Task<IEnumerable<Feature>> GetByNewCriteriaAsync(SearchCriteria criteria)
    {
        var query = _context.Features.AsQueryable();
        
        // Dynamic filtering
        if (!string.IsNullOrEmpty(criteria.Name))
            query = query.Where(f => f.Name.Contains(criteria.Name));
            
        if (criteria.NewProperty != null)
            query = query.Where(f => f.NewProperty == criteria.NewProperty);
            
        // Pagination
        return await query
            .OrderBy(f => f.Name)
            .Skip(criteria.Skip)
            .Take(criteria.Take)
            .ToListAsync();
    }
}
```

## Phase 4: Service Layer Updates

<think step-by-step about business logic enhancements>

### Service Enhancement with New Logic

```csharp
public class FeatureService : IFeatureService
{
    private readonly IFeatureRepository _repository;
    private readonly IValidator<Feature> _validator;
    private readonly IEventBus _eventBus;
    
    // Updated method with new logic
    public async Task<Result<FeatureDto>> UpdateFeatureAsync(UpdateFeatureCommand command)
    {
        // Start transaction
        using var transaction = await _repository.BeginTransactionAsync();
        
        try
        {
            // Get existing
            var feature = await _repository.GetByIdAsync(command.Id);
            if (feature == null)
                return Result<FeatureDto>.Failure("Feature not found");
            
            // Apply business rules
            var updateResult = feature.UpdateWithNewLogic(command);
            if (!updateResult.IsSuccess)
                return Result<FeatureDto>.Failure(updateResult.Error);
            
            // Validate
            var validationResult = await _validator.ValidateAsync(feature);
            if (!validationResult.IsValid)
                return Result<FeatureDto>.Failure(validationResult.ToString());
            
            // Save with optimistic locking
            var saveResult = await _repository.UpdateWithOptimisticLockingAsync(feature);
            if (!saveResult.IsSuccess)
                return Result<FeatureDto>.Failure("Concurrent update detected");
            
            // Publish events
            await _eventBus.PublishAsync(feature.DomainEvents);
            
            // Commit transaction
            await transaction.CommitAsync();
            
            return Result<FeatureDto>.Success(FeatureDto.From(feature));
        }
        catch (Exception ex)
        {
            await transaction.RollbackAsync();
            throw;
        }
    }
}
```

## Phase 5: API Controller Updates

<think harder about API design and versioning>

### API Enhancement with Versioning

```csharp
[ApiController]
[Route("api/v{version:apiVersion}/features")]
[ApiVersion("1.0")]
[ApiVersion("2.0")]
public class FeatureController : ControllerBase
{
    private readonly IFeatureService _service;
    
    // Backward compatible v1 endpoint
    [HttpPut("{id}")]
    [MapToApiVersion("1.0")]
    public async Task<IActionResult> UpdateV1(Guid id, [FromBody] UpdateFeatureV1Dto dto)
    {
        // Map v1 DTO to command
        var command = MapToCommand(dto);
        var result = await _service.UpdateFeatureAsync(command);
        
        if (!result.IsSuccess)
            return BadRequest(result.Error);
            
        return Ok(MapToV1Response(result.Value));
    }
    
    // Enhanced v2 endpoint
    [HttpPut("{id}")]
    [MapToApiVersion("2.0")]
    public async Task<IActionResult> UpdateV2(Guid id, [FromBody] UpdateFeatureV2Dto dto)
    {
        // Enhanced validation
        if (!ModelState.IsValid)
            return ValidationProblem();
        
        var command = new UpdateFeatureCommand(id, dto);
        var result = await _service.UpdateFeatureAsync(command);
        
        if (!result.IsSuccess)
            return Problem(result.Error);
            
        // Return enhanced response
        return Ok(new ApiResponse<FeatureDto>
        {
            Data = result.Value,
            Metadata = new { version = "2.0", timestamp = DateTime.UtcNow }
        });
    }
}
```

## Phase 6: Database Migration (Backward Compatible)

<think step-by-step about safe database changes>

### Safe Database Updates

```sql
-- Add new columns as nullable
ALTER TABLE Features 
ADD COLUMN new_property VARCHAR(255) NULL,
ADD COLUMN updated_at TIMESTAMP NULL;

-- Add indexes for new queries
CREATE INDEX idx_features_new_property ON Features(new_property) 
WHERE new_property IS NOT NULL;

-- Update existing data safely
UPDATE Features 
SET updated_at = COALESCE(modified_date, created_date, NOW())
WHERE updated_at IS NULL;

-- Add new stored procedure (keep old ones)
CREATE OR REPLACE PROCEDURE sp_search_features_v2(
    IN p_name VARCHAR(255),
    IN p_new_property VARCHAR(255)
)
AS $$
BEGIN
    -- Enhanced search logic
END;
$$ LANGUAGE plpgsql;
```

## Phase 7: Comprehensive Test Generation

<think harder about achieving 100% test success>

### Backend Test Suite

#### Unit Tests
```csharp
[TestFixture]
public class FeatureServiceTests
{
    private Mock<IFeatureRepository> _repositoryMock;
    private Mock<IValidator<Feature>> _validatorMock;
    private FeatureService _service;
    
    [SetUp]
    public void Setup()
    {
        _repositoryMock = new Mock<IFeatureRepository>();
        _validatorMock = new Mock<IValidator<Feature>>();
        _service = new FeatureService(_repositoryMock.Object, _validatorMock.Object);
    }
    
    [Test]
    public async Task UpdateFeature_WithValidData_ShouldSucceed()
    {
        // Arrange
        var feature = new Feature("test");
        _repositoryMock.Setup(r => r.GetByIdAsync(It.IsAny<Guid>()))
            .ReturnsAsync(feature);
        _validatorMock.Setup(v => v.ValidateAsync(It.IsAny<Feature>()))
            .ReturnsAsync(new ValidationResult());
            
        // Act
        var result = await _service.UpdateFeatureAsync(new UpdateFeatureCommand());
        
        // Assert
        Assert.That(result.IsSuccess, Is.True);
        _repositoryMock.Verify(r => r.UpdateWithOptimisticLockingAsync(It.IsAny<Feature>()), Times.Once);
    }
    
    // Test all edge cases
    [TestCase(null, "Null input")]
    [TestCase("", "Empty string")]
    [TestCase("very_long_string...", "Max length")]
    public async Task UpdateFeature_WithEdgeCases_ShouldHandleGracefully(string input, string scenario)
    {
        // Test implementation
    }
    
    // Test concurrency
    [Test]
    public async Task UpdateFeature_WithConcurrentUpdate_ShouldRetryOrFail()
    {
        // Simulate optimistic locking failure
    }
}
```

#### Integration Tests
```csharp
[TestFixture]
public class FeatureIntegrationTests
{
    private IServiceProvider _serviceProvider;
    private IFeatureService _service;
    
    [OneTimeSetUp]
    public async Task Setup()
    {
        // Use test database
        var services = new ServiceCollection();
        services.AddDbContext<AppDbContext>(options =>
            options.UseInMemoryDatabase("TestDb"));
        services.AddScoped<IFeatureService, FeatureService>();
        
        _serviceProvider = services.BuildServiceProvider();
        _service = _serviceProvider.GetRequiredService<IFeatureService>();
    }
    
    [Test]
    public async Task FullFeatureUpdateFlow_ShouldWork()
    {
        // Create feature
        var createResult = await _service.CreateFeatureAsync(new CreateCommand());
        Assert.That(createResult.IsSuccess, Is.True);
        
        // Update feature
        var updateResult = await _service.UpdateFeatureAsync(
            new UpdateFeatureCommand { Id = createResult.Value.Id });
        Assert.That(updateResult.IsSuccess, Is.True);
        
        // Verify changes persisted
        var getResult = await _service.GetFeatureAsync(createResult.Value.Id);
        Assert.That(getResult.Value.NewProperty, Is.Not.Null);
    }
}
```

## Phase 8: Validation Loop Until Success

<think step-by-step about ensuring 100% success>

### Continuous Backend Validation

```csharp
public async Task<ValidationResult> ValidateUntilSuccess()
{
    var maxAttempts = 50;
    var attempt = 0;
    
    while (attempt < maxAttempts)
    {
        attempt++;
        
        // Run all backend tests
        var testResult = await RunAllBackendTests();
        
        if (testResult.SuccessRate < 100)
        {
            // Analyze failures
            var failures = AnalyzeTestFailures(testResult);
            
            // Fix issues
            foreach (var failure in failures)
            {
                await FixBackendIssue(failure);
            }
            
            // Regenerate affected tests
            await RegenerateFailedTests(failures);
            
            continue;
        }
        
        // Validate API contracts
        var contractResult = await ValidateApiContracts();
        if (!contractResult.IsValid)
        {
            await FixContractIssues(contractResult);
            continue;
        }
        
        // Performance validation
        var perfResult = await ValidatePerformance();
        if (!perfResult.MeetsSLA)
        {
            await OptimizePerformance(perfResult);
            continue;
        }
        
        // All validations passed
        return new ValidationResult
        {
            Success = true,
            Confidence = 99.5,
            TestCoverage = 100,
            Attempts = attempt
        };
    }
    
    throw new Exception("Unable to achieve 100% success after maximum attempts");
}
```

## Completion Guarantee

### Success Criteria
```yaml
Backend Update Checklist:
  ✓ All backend components updated
  ✓ Backward compatibility maintained
  ✓ API contracts preserved
  ✓ Database migrations safe
  ✓ Unit tests: 100% passing
  ✓ Integration tests: 100% passing
  ✓ Performance validated
  ✓ Security validated
  ✓ No monitoring overhead
  ✓ Cloud-ready implementation
```

### Final Validation
```markdown
## Confidence Score: ≥99%

Backend Validation:
- Components updated: 100%
- Test success rate: 100%
- API compatibility: Verified
- Database integrity: Maintained
- Performance: Within SLA
- Security: Validated

✅ Backend feature successfully updated
```

This command will NOT terminate until:
1. All backend components are updated
2. 100% test success achieved
3. Backward compatibility verified
4. Performance meets requirements
5. Confidence ≥99%