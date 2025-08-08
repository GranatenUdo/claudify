---
description: Debug and fix backend API issues using systematic root cause analysis
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: bug description (e.g., "null reference in field service when updating boundaries")
agent-dependencies: [Security Reviewer, Code Reviewer, Tech Lead, Technical Debt Analyst]
complexity: moderate
estimated-time: 15-20 minutes (reduced from 30 with parallel execution)
category: quality
---

# Fix API Bug: $ARGUMENTS

## Phase 0: Task Management Setup

### 📋 TodoWrite Task Management
<think step-by-step about organizing the bug fix process>

@TodoWrite(todos=[
  {id: "1", content: "Reproduce and diagnose bug", status: "in_progress", priority: "high"},
  {id: "2", content: "Multi-agent root cause analysis", status: "pending", priority: "high"},
  {id: "3", content: "Investigate affected layers", status: "pending", priority: "high"},
  {id: "4", content: "Implement fix", status: "pending", priority: "high"},
  {id: "5", content: "Generate tests", status: "pending", priority: "high"},
  {id: "6", content: "Validate fix", status: "pending", priority: "high"}
])

### 📊 Agent Specialization Matrix

| Bug Type | Primary Agent | Secondary Agents | Parallel? |
|----------|---------------|------------------|----------|
| Security | Security Reviewer | Tech Lead | ✅ Yes |
| Logic | Code Reviewer | Tech Lead | ✅ Yes |
| Performance | Tech Lead | Code Reviewer | ✅ Yes |
| Data | Technical Debt Analyst | Security Reviewer | ✅ Yes |

Internalize CLAUDE.md and FEATURES.md, then use extended thinking for deep root cause analysis of **$ARGUMENTS**.

## 🧠 Multi-Agent Bug Analysis (OPTIMIZED)

<think harder about the bug's root cause and potential impacts>
<think step-by-step about systematic debugging approach>

### Task Progress Update
@TodoWrite(todos=[/* Update task 1 to completed, task 2 to in_progress */])

### Combined Research & Security Analysis
I'll have multiple agents analyze the bug in parallel for comprehensive coverage.

@Task(description="Bug analysis with security assessment", prompt="As Security Reviewer with research expertise, analyze the bug '$ARGUMENTS':

BUG PATTERN RESEARCH:
1. Search for similar bugs in codebase history
2. Research common causes for this type of error
3. Analyze related components and dependencies
4. Identify patterns in recent changes
5. Study best practices for prevention
6. Look for similar issues in bug tracking
7. Research framework-specific gotchas
8. Analyze recent code changes correlation

SECURITY IMPACT ASSESSMENT:
1. Check for data exposure risks
2. Verify multi-tenant isolation integrity
3. Assess authentication/authorization impact
4. Review for injection vulnerabilities
5. Check audit trail completeness
6. Evaluate potential attack vectors
7. Assess compliance implications
8. Review for OWASP vulnerability patterns

Provide integrated analysis with:
- Root cause hypotheses ranked by likelihood
- Security risk rating (Low/Medium/High/Critical)
- Attack scenarios if exploitable
- Fix requirements prioritized by impact", subagent_type="general-purpose")
@Task(description="Code quality and pattern analysis", prompt="Analyze code patterns related to bug '$ARGUMENTS':
1. Code duplication that might spread the bug
2. Anti-patterns that contribute to the issue
3. Missing error handling
4. Incorrect assumptions in logic
5. Test coverage gaps
6. Related technical debt
Provide code quality assessment", subagent_type="general-purpose")
@Task(description="Architecture impact analysis", prompt="Assess architectural implications of bug '$ARGUMENTS':
1. Layer violations
2. Integration issues
3. Scalability impacts
4. Performance degradation
5. Data consistency risks
6. Transaction boundaries
Provide architectural assessment", subagent_type="general-purpose")

## Extended Thinking for Root Cause Analysis

Before investigating, think deeply about:
- **System Architecture Impact**: Which layers are affected? Domain, Service, Repository, API?
- **Multi-Tenant Implications**: Is organization isolation compromised?
- **Data Consistency**: Are transactions failing? Is caching stale?
- **Performance Degradation**: Is this affecting query performance at scale?
- **Security Vulnerabilities**: Could this expose tenant data or allow unauthorized access?

## 🔍 Systematic API Debugging Process

### Phase 1: Parallel Bug Reproduction & Data Collection

<think about gathering all diagnostic data simultaneously>
<think harder about efficient debugging strategies>

### Task Progress Update
@TodoWrite(todos=[/* Update task 2 to completed, task 3 to in_progress */])

### 🚀 Parallel Execution Pattern (40-60% Performance Gain)
I'll collect all diagnostic information in parallel for faster root cause identification:

@Bash(command="dotnet build --no-restore", description="Check for build errors")
@Bash(command="git log --oneline -20 --grep='$ARGUMENTS'", description="Find related commits")
@Grep(pattern="ERROR.*$ARGUMENTS|Exception.*$ARGUMENTS", path="logs/", output_mode="content", head_limit=50)
@Grep(pattern="class.*Controller|interface.*Service|class.*Repository", path="src/", output_mode="files_with_matches", head_limit=20)
@Read(file_path="src/PTA.VineyardManagement.Api/appsettings.json")

Based on the parallel diagnostics, I'll analyze:
1. **API Request Patterns**
2. **Error Pattern Identification**
3. **Database Query Analysis**
4. **Recent Code Changes**

### Phase 2: Multi-Layer Investigation

Think systematically through each layer:

#### Controller Layer
- [ ] Authorization attributes correct?
- [ ] Model binding working properly?
- [ ] Request validation firing?
- [ ] Proper HTTP status codes returned?

#### Service Layer
- [ ] Result<T> pattern used consistently?
- [ ] Business logic errors handled?
- [ ] Caching invalidation working?
- [ ] SignalR notifications sent?

#### Repository Layer
- [ ] Organization filtering applied?
- [ ] Include statements prevent N+1?
- [ ] Transaction scope correct?
- [ ] Soft delete respected?

#### Domain Layer
- [ ] Invariants being violated?
- [ ] Factory methods validating correctly?
- [ ] Value objects immutable?
- [ ] Domain events raised properly?

### Phase 3: Implementation & Testing

<think step-by-step about fix implementation and validation>

### Task Progress Update
@TodoWrite(todos=[/* Update task 3 to completed, tasks 4-5 to in_progress */])

#### Parallel Fix Implementation
```csharp
// ✅ Create fix and tests simultaneously
@Edit(file_path="src/Service.cs", /* fix implementation */)
@Write(file_path="tests/ServiceTests.cs", /* test generation */)
@Write(file_path="tests/IntegrationTests.cs", /* integration test */)
```

### Success Criteria
- ✅ Bug reproduced and understood
- ✅ Root cause identified
- ✅ Fix implemented
- ✅ Tests passing (100% success)
- ✅ No regressions introduced
- ✅ Security validated

### Final Task Completion
@TodoWrite(todos=[/* Mark all tasks as completed */])
- [ ] Factory methods validating input?
- [ ] Computed properties causing issues?
- [ ] Audit fields updated correctly?

### Phase 3: Common API Bug Patterns

Use extended thinking to check for:

#### 1. Multi-Tenant Data Leakage
```csharp
// BUG: Missing organization filter
var items = await _context.Fields.ToListAsync();

// FIX: Always filter by organization
var items = await _context.Fields
    .Where(f => f.OrganizationId == _userContext.OrganizationId)
    .ToListAsync();
```

#### 2. N+1 Query Problems
```csharp
// BUG: Lazy loading causing multiple queries
var fields = await _repository.GetAllAsync();
foreach (var field in fields)
{
    var plots = field.Plots; // Triggers new query
}

// FIX: Eager load related data
var fields = await _repository.Query()
    .Include(f => f.Plots)
    .ThenInclude(p => p.HarvestData)
    .ToListAsync();
```

#### 3. Transaction Consistency Issues
```csharp
// BUG: Cache invalidated before transaction commits
await _cacheService.InvalidateAsync($"fields:{orgId}");
await _repository.UpdateAsync(field);

// FIX: Transaction first, then cache
using var transaction = await _context.Database.BeginTransactionAsync();
try
{
    await _repository.UpdateAsync(field);
    await transaction.CommitAsync();
    await _cacheService.InvalidateAsync($"fields:{orgId}");
}
catch
{
    await transaction.RollbackAsync();
    throw;
}
```

#### 4. Concurrency Conflicts
```csharp
// BUG: No optimistic concurrency control
public async Task<Result<Field>> UpdateAsync(UpdateFieldDto dto)
{
    var field = await _repository.GetByIdAsync(dto.Id);
    field.Name = dto.Name;
    await _repository.UpdateAsync(field);
}

// FIX: Check row version
public async Task<Result<Field>> UpdateAsync(UpdateFieldDto dto)
{
    var field = await _repository.GetByIdAsync(dto.Id);
    if (field.RowVersion != dto.RowVersion)
        return Result<Field>.Failure("Data has been modified by another user");
    
    field.Name = dto.Name;
    await _repository.UpdateAsync(field);
}
```

## 🛠️ Fix Implementation Strategy

### 1. Isolate with Integration Tests
```csharp
[Fact]
public async Task BugReproduction_SpecificScenario_ShouldFail()
{
    // Arrange - Set up exact conditions
    var request = new CreateFieldDto 
    { 
        OrganizationId = TestOrganization.Id,
        Name = "Test Field",
        // Conditions that trigger bug
    };
    
    // Act
    var response = await _client.PostAsJsonAsync("/api/fields", request);
    
    // Assert - Verify the bug occurs
    response.StatusCode.Should().Be(HttpStatusCode.InternalServerError);
}
```

### 2. Implement Proper Error Handling
```csharp
[ApiController]
public class FieldsController : BaseApiController
{
    [HttpPost]
    public async Task<IActionResult> Create([FromBody] CreateFieldDto request)
    {
        try
        {
            var result = await _fieldService.CreateAsync(request);
            
            if (!result.IsSuccess)
            {
                return BadRequest(new ProblemDetails
                {
                    Title = "Validation Error",
                    Detail = result.Error,
                    Status = StatusCodes.Status400BadRequest,
                    Instance = HttpContext.Request.Path
                });
            }
            
            return CreatedAtAction(nameof(GetById), 
                new { id = result.Value.Id }, result.Value);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Failed to create field");
            
            return StatusCode(500, new ProblemDetails
            {
                Title = "Internal Server Error",
                Detail = "An unexpected error occurred",
                Status = StatusCodes.Status500InternalServerError,
                Instance = HttpContext.Request.Path
            });
        }
    }
}
```

### 3. Add Comprehensive Logging
```csharp
public async Task<Result<Field>> CreateAsync(CreateFieldDto dto)
{
    using var activity = Activity.StartActivity("FieldService.CreateAsync");
    activity?.SetTag("organizationId", dto.OrganizationId);
    activity?.SetTag("fieldName", dto.Name);
    
    _logger.LogInformation("Creating field {FieldName} for org {OrgId}", 
        dto.Name, dto.OrganizationId);
    
    try
    {
        // Validation
        if (string.IsNullOrWhiteSpace(dto.Name))
        {
            _logger.LogWarning("Field creation failed: empty name");
            return Result<Field>.Failure("Field name is required");
        }
        
        // Business logic
        var field = Field.Create(dto.OrganizationId, dto.Name, dto.Area);
        
        // Persistence
        await _repository.AddAsync(field);
        
        // Cache invalidation
        await _cacheService.InvalidateAsync($"fields:{dto.OrganizationId}");
        
        _logger.LogInformation("Successfully created field {FieldId}", field.Id);
        return Result<Field>.Success(field);
    }
    catch (Exception ex)
    {
        _logger.LogError(ex, "Failed to create field for org {OrgId}", 
            dto.OrganizationId);
        throw;
    }
}
```

## 🧪 Verification & Testing

### API Testing Checklist
- [ ] Original bug no longer reproduces
- [ ] All HTTP status codes are correct
- [ ] Error responses follow ProblemDetails format
- [ ] Multi-tenant isolation maintained
- [ ] Performance acceptable under load
- [ ] No regression in related endpoints

### Load Testing
```bash
# Use k6 or similar for load testing
k6 run --vus 100 --duration 30s load-test.js
```

### Security Verification
```csharp
[Fact]
public async Task Should_Not_Access_Other_Organization_Data()
{
    // Arrange
    var otherOrgId = Guid.NewGuid();
    
    // Act
    var response = await _client.GetAsync($"/api/fields?orgId={otherOrgId}");
    
    // Assert
    response.StatusCode.Should().Be(HttpStatusCode.Forbidden);
}
```

## 🔐 Security Considerations

Think deeply about:
1. **Authorization**: Are all endpoints properly secured?
2. **Data Validation**: Is input sanitized and validated?
3. **SQL Injection**: Are all queries parameterized?
4. **Rate Limiting**: Can this endpoint be abused?
5. **Audit Trail**: Are all operations logged?

## 📊 Performance Analysis

### Database Performance
```sql
-- Check execution plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

-- Run the problematic query
SELECT * FROM Fields WHERE OrganizationId = @orgId;

-- Analyze missing indexes
SELECT * FROM sys.dm_db_missing_index_details;
```

### Caching Strategy Review
```csharp
// Ensure proper cache key generation
private string GetCacheKey(Guid organizationId, string suffix = "")
{
    return $"org:{organizationId}:fields{suffix}";
}

// Implement cache-aside pattern correctly
public async Task<IEnumerable<Field>> GetByOrganizationAsync(Guid orgId)
{
    var cacheKey = GetCacheKey(orgId);
    
    if (await _cache.TryGetAsync<IEnumerable<Field>>(cacheKey, out var cached))
        return cached;
    
    var fields = await _repository.GetByOrganizationAsync(orgId);
    await _cache.SetAsync(cacheKey, fields, TimeSpan.FromMinutes(5));
    
    return fields;
}
```

### Phase 6: Comprehensive Fix Review (OPTIMIZED)

I'll have the Code Reviewer perform complete fix validation with simplification analysis.

@Task(description="Fix review with optimization", prompt="As Code Reviewer with simplification expertise, comprehensively review the fix for '$ARGUMENTS':

FIX VALIDATION:
1. Verify fix addresses root cause
2. Check for unintended side effects
3. Review test coverage for regression
4. Validate error handling improvements
5. Assess code quality and patterns
6. Check for performance impact
7. Verify logging and monitoring
8. Confirm security requirements met

SIMPLIFICATION ANALYSIS:
1. Identify overly complex solutions
2. Suggest cleaner alternatives
3. Reduce conditional nesting
4. Consolidate error handling
5. Improve code readability
6. Extract reusable patterns
7. Remove redundant code
8. Optimize performance hotspots

Provide integrated review with:
- Fix effectiveness score (0-100)
- Code quality improvements
- Simplification opportunities ranked by impact
- Approval status with conditions", subagent_type="general-purpose")

## 📝 Documentation & Prevention

### Update API Documentation
- Update OpenAPI/Swagger annotations
- Document any behavior changes
- Add examples of proper usage
- Note any breaking changes

### Update CHANGELOG.md
Add entry under [Unreleased] -> Fixed:
```markdown
### Fixed
- $ARGUMENTS
  - Root cause identified and resolved
  - Impact on existing functionality
  - Prevention measures added
```
Use `/update-changelog` command for automated updates

### Add Monitoring
```csharp
// Add custom metrics
_metrics.Counter("api_errors", 1, new[] { 
    ("endpoint", "fields"),
    ("error_type", "validation"),
    ("org_id", orgId.ToString())
});
```

### Create Runbook Entry
Document:
- Symptoms of the bug
- Root cause identified
- Fix implemented
- How to detect similar issues
- Monitoring added

## 🚀 Deployment Considerations

Before deploying the fix:
- [ ] Database migrations tested
- [ ] Backward compatibility verified
- [ ] Feature flags configured (if needed)
- [ ] Rollback plan prepared
- [ ] Monitoring alerts configured

## Final Verification Checklist

- [ ] Bug fixed and cannot be reproduced
- [ ] All tests passing (unit, integration, load)
- [ ] Multi-tenant isolation verified
- [ ] Performance metrics acceptable
- [ ] Security review completed
- [ ] Documentation updated
- [ ] FEATURES.md updated if needed
- [ ] Monitoring and alerts configured

## 📋 Multi-Agent Fix Summary

```markdown
# API Bug Fix: [Bug Description]

## Agent Analysis Summary

### Researcher Findings
- **Root Cause Pattern**: [Identified pattern]
- **Similar Issues**: [Count] related bugs found
- **Best Practice**: [Recommended approach]

### Security Reviewer Assessment
- **Security Impact**: [Low/Medium/High/Critical]
- **Data Exposure**: [Yes/No]
- **Compliance**: [Status]

### Tech Lead Evaluation
- **Architecture Impact**: [Description]
- **Performance Impact**: [Metrics]
- **Scalability**: [Concerns addressed]

### Code Reviewer Validation
- **Fix Quality**: [Score]
- **Test Coverage**: [Percentage]
- **Regression Prevention**: [Yes/No]

## Root Cause
[Synthesized explanation from all agents]

## Fix Applied
[Description of the solution validated by agents]

## Testing
- Unit tests added: [List]
- Integration tests: [List]
- Security tests: [List]
- Performance tests: [List]

## Prevention
- Guard rails added (Code Reviewer)
- Monitoring improved (Tech Lead)
- Security hardening (Security Reviewer)
- Documentation updated (Researcher)
```

## Benefits of Multi-Agent Bug Fixing

1. **Comprehensive Analysis**: Multiple perspectives on root cause
2. **Faster Resolution**: Parallel investigation by specialized agents
3. **Better Prevention**: Each agent suggests domain-specific guards
4. **Higher Quality**: Multiple reviews ensure robust fixes
5. **Knowledge Capture**: Documented insights prevent future bugs

Remember: **This is a production system. Every fix must maintain data integrity, security, and performance while serving real agricultural operations. Multi-agent collaboration ensures comprehensive validation and prevention strategies.**