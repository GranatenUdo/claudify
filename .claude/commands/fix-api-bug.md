# FIX API BUG - DEEP ROOT CAUSE ANALYSIS

<think harder about the symptoms and potential root causes>

## ACTIVATION
You are debugging a backend API issue. Use extended thinking to analyze the root cause systematically and implement a robust fix.

**Bug Report**: "$ARGUMENTS"

## Phase 1: Reproduction & Data Collection

<gather all relevant information about the bug>

### 1.1 Reproduce the Issue
- Can you reproduce it consistently?
- What are the exact steps?
- What environment does it occur in?
- What are the error messages?

### 1.2 Collect Diagnostics
```bash
# Check logs
tail -f logs/application.log | grep ERROR

# Monitor database queries
-- Enable query logging temporarily

# Check system resources
top
df -h
free -m
```

### 1.3 Identify Pattern
- When did it start occurring?
- Is it affecting all users or specific ones?
- Is it related to specific data patterns?
- Does it happen at specific times?

## Phase 2: Multi-Layer Investigation

<systematically check each layer of the application>

### 2.1 Controller Layer
```csharp
// Check authorization
[Authorize]
[HttpGet("{id}")]
public async Task<IActionResult> GetResource(Guid id)
{
    // Is authorization working?
    // Are route parameters correct?
    // Is model binding working?
}
```

### 2.2 Service Layer
```csharp
// Check business logic
public async Task<Result<Resource>> GetResourceAsync(Guid id)
{
    // Is organization context correct?
    if (_userContext.OrganizationId == Guid.Empty)
        return Result<Resource>.Failure("No organization context");
    
    // Are we using Result<T> pattern correctly?
    // Is caching causing stale data?
    // Are there race conditions?
}
```

### 2.3 Repository Layer
```csharp
// Check data access
public async Task<Resource?> GetByIdAsync(Guid id)
{
    // Is the query filtering by organization?
    return await _context.Resources
        .Where(r => r.OrganizationId == _userContext.OrganizationId)
        .Where(r => r.Id == id)
        .FirstOrDefaultAsync();
    
    // Are we hitting the right database?
    // Is the connection string correct?
    // Are there deadlocks?
}
```

### 2.4 Domain Layer
```csharp
// Check domain logic
public class Resource
{
    // Are invariants being violated?
    // Is validation working correctly?
    // Are domain events firing?
}
```

## Phase 3: Common Bug Patterns

<check for these common issues>

### 3.1 Multi-Tenant Bugs
```csharp
// ❌ Missing organization filter
var items = await _context.Items.ToListAsync();

// ✅ Correct organization scoping
var items = await _context.Items
    .Where(i => i.OrganizationId == _userContext.OrganizationId)
    .ToListAsync();
```

### 3.2 N+1 Query Problems
```csharp
// ❌ N+1 queries
foreach (var order in orders)
{
    order.Customer = await _context.Customers
        .FirstOrDefaultAsync(c => c.Id == order.CustomerId);
}

// ✅ Eager loading
var orders = await _context.Orders
    .Include(o => o.Customer)
    .ToListAsync();
```

### 3.3 Concurrency Issues
```csharp
// ❌ Race condition
var count = await GetCountAsync();
count++;
await SaveCountAsync(count);

// ✅ Atomic operation
await _context.Database.ExecuteSqlRawAsync(
    "UPDATE Counters SET Value = Value + 1 WHERE Id = {0}", 
    counterId);
```

### 3.4 Async Deadlocks
```csharp
// ❌ Deadlock risk
var result = SomeAsyncMethod().Result;

// ✅ Proper async
var result = await SomeAsyncMethod();
```

## Phase 4: Root Cause Analysis

<think deeply about why this bug exists>

### 4.1 Five Whys Analysis
1. Why did the error occur?
   → Because the query returned null
2. Why did the query return null?
   → Because it filtered by wrong organization
3. Why did it filter by wrong organization?
   → Because user context was not set
4. Why was user context not set?
   → Because middleware ordering was wrong
5. Why was middleware ordering wrong?
   → Because of recent refactoring

### 4.2 Impact Assessment
- How many users affected?
- What's the data integrity impact?
- Are there security implications?
- What's the performance impact?

## Phase 5: Implement Fix

### 5.1 Fix the Root Cause
```csharp
// Fix at the source, not symptoms
public class Startup
{
    public void Configure(IApplicationBuilder app)
    {
        // Correct middleware order
        app.UseAuthentication();
        app.UseUserContext(); // Must be after auth
        app.UseAuthorization();
        app.UseEndpoints(...);
    }
}
```

### 5.2 Add Defensive Coding
```csharp
public async Task<Result<T>> SafeExecute<T>(Func<Task<T>> operation)
{
    // Validate context
    if (_userContext?.OrganizationId == null)
        return Result<T>.Failure("Invalid user context");
    
    try
    {
        var result = await operation();
        return Result<T>.Success(result);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Operation failed");
        return Result<T>.Failure("An error occurred");
    }
}
```

### 5.3 Improve Error Handling
```csharp
// Specific error types
public class OrganizationContextMissingException : DomainException
{
    public OrganizationContextMissingException() 
        : base("Organization context is required for this operation") { }
}

// Better error responses
return BadRequest(new ProblemDetails
{
    Title = "Invalid Request",
    Detail = "Organization context is missing",
    Type = "https://api.example.com/errors/missing-context",
    Status = 400
});
```

## Phase 6: Testing & Verification

### 6.1 Unit Tests
```csharp
[Fact]
public async Task GetResource_WithoutOrgContext_ReturnsFailure()
{
    // Arrange
    var service = CreateService(orgId: null);
    
    // Act
    var result = await service.GetResourceAsync(Guid.NewGuid());
    
    // Assert
    result.IsSuccess.Should().BeFalse();
    result.Error.Should().Contain("organization");
}
```

### 6.2 Integration Tests
```csharp
[Fact]
public async Task GetResource_WithDifferentOrg_Returns404()
{
    // Arrange
    var resource = await CreateResource(org1Id);
    AuthenticateAs(org2Id);
    
    // Act
    var response = await Client.GetAsync($"/api/resources/{resource.Id}");
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.NotFound);
}
```

### 6.3 Load Testing
```bash
# Verify fix under load
k6 run load-test.js --vus 100 --duration 5m
```

## Phase 7: Prevention & Monitoring

### 7.1 Add Monitoring
```csharp
// Add metrics
_metrics.Measure.Counter.Increment("api.errors", 
    new MetricTags("type", "missing_context"));

// Add detailed logging
_logger.LogWarning("Request {RequestId} missing organization context. User: {UserId}", 
    requestId, userId);
```

### 7.2 Add Alerts
```yaml
# Alert configuration
- alert: HighErrorRate
  expr: rate(api_errors_total[5m]) > 0.05
  annotations:
    summary: "High API error rate"
    description: "Error rate is {{ $value }} errors/sec"
```

### 7.3 Documentation
```markdown
## Known Issues

### Missing Organization Context
**Symptoms**: 403 errors, empty results
**Cause**: Middleware ordering issue
**Fix**: Ensure UseUserContext() comes after UseAuthentication()
**Prevention**: Integration test covers this scenario
```

## Checklist
- [ ] Bug reproduced consistently
- [ ] Root cause identified (not just symptoms)
- [ ] Fix implemented at source
- [ ] Defensive coding added
- [ ] Unit tests added
- [ ] Integration tests added
- [ ] Load tested if performance-related
- [ ] Monitoring added
- [ ] Documentation updated
- [ ] Similar code patterns reviewed

## Remember
- Fix the cause, not symptoms
- Test the fix thoroughly
- Prevent recurrence
- Document for future
- Consider system-wide impact