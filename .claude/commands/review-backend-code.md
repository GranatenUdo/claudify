---
description: Perform comprehensive API code review using extended thinking for security, performance, and architectural analysis
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, TodoWrite]
argument-hint: file path, PR number, or feature name to review
agent-dependencies: [Tech Lead, Security Reviewer, Code Reviewer, Test Quality Analyst, Technical Debt Analyst]
complexity: complex
estimated-time: 25-35 minutes (with parallel agent execution)
category: quality
---

# Review API Code: $ARGUMENTS

Internalize CLAUDE.md and FEATURES.md, then use extended thinking to perform a comprehensive code review of **$ARGUMENTS**, focusing on security, performance, multi-tenant isolation, and architectural consistency.

## 🧠 Extended Thinking for Code Analysis

Before reviewing, think deeply about:
- **Security Vulnerabilities**: OWASP API Security Top 10 risks
- **Multi-Tenant Isolation**: Every query must filter by OrganizationId
- **Performance Impact**: Database queries, caching strategy, async patterns
- **Architectural Adherence**: Domain-driven design, Result pattern, clean architecture
- **Production Readiness**: Error handling, logging, monitoring, scalability

## 🔍 Systematic Review Process

### Phase 1: Context Gathering

Use interleaved thinking to understand the code:

1. **Scope Analysis**
   ```bash
   # Check what files were changed
   git diff --name-only main..HEAD | grep -E '\.(cs|csproj)$'
   
   # Review commit history
   git log --oneline -10
   ```

2. **Architecture Verification**
   - Does it follow the established layer structure?
   - Are dependencies flowing correctly (API → Service → Repository → Domain)?
   - Is the feature properly isolated in its domain?

3. **Feature Context**
   - Review FEATURES.md for related functionality
   - Check if this aligns with existing patterns
   - Verify API design consistency

### Phase 2: Parallel Multi-Agent Analysis

<think harder about optimal agent utilization for backend code review>

Now I'll invoke specialized agents in parallel for comprehensive backend code analysis:

#### 🚀 Launching Parallel Agent Review

@Task(description="Architecture review", prompt="Perform architectural review of backend code in $ARGUMENTS:
1. System Architecture: Domain-driven design, clean architecture, SOLID principles
2. API Design: RESTful conventions, versioning, response consistency
3. Scalability: Database efficiency, caching, async patterns
4. Code Organization: Project structure, namespace organization, class responsibilities
Rate architectural fitness 1-10 with specific improvements", subagent_type="general-purpose")

@Task(description="Security assessment", prompt="Conduct security review of $ARGUMENTS:
1. OWASP API Top 10: Authorization, authentication, data exposure, rate limiting
2. Multi-Tenant Security: OrganizationId filtering, cross-tenant prevention
3. Data Protection: PII handling, encryption, secret management, input validation
Classify findings: Critical/High/Medium/Low", subagent_type="general-purpose")

@Task(description="Code quality review", prompt="Review code quality in $ARGUMENTS:
1. Coding Standards: C# conventions, comments, method length, class cohesion
2. Error Handling: Result<T> pattern, exceptions, logging, validation
3. Design Patterns: Repository, Unit of Work, dependency injection
4. Performance: LINQ efficiency, query optimization, memory management
Provide top 10 improvements with examples", subagent_type="general-purpose")

@Task(description="Test analysis", prompt="Analyze test quality for $ARGUMENTS:
1. Test Coverage: Unit tests, integration tests, edge cases, error scenarios
2. Test Quality: Independence, mocking, assertions, naming
3. Missing Tests: Untested methods, uncovered branches, security gaps
4. Recommendations: Priority additions, refactoring needs, performance tests
Generate test examples for critical gaps", subagent_type="general-purpose")

@Task(description="Debt assessment", prompt="Analyze technical debt in $ARGUMENTS:
1. Code Debt: Duplication, complexity, god classes, dead code
2. Design Debt: Coupling, missing abstractions, violated principles
3. Infrastructure Debt: Outdated dependencies, missing monitoring, bottlenecks
4. Documentation Debt: Missing API docs, outdated comments, no diagrams
Calculate debt score and remediation effort", subagent_type="Technical Debt Analyst")

### Phase 3: Security Review (OWASP API Top 10)

#### 1. Broken Object Level Authorization
```csharp
// ❌ BAD: No organization check
public async Task<IActionResult> GetField(Guid id)
{
    var field = await _repository.GetByIdAsync(id);
    return Ok(field);
}

// ✅ GOOD: Proper authorization
public async Task<IActionResult> GetField(Guid id)
{
    var field = await _repository.GetByIdAsync(id);
    if (field?.OrganizationId != _userContext.OrganizationId)
        return NotFound();
    return Ok(field);
}
```

#### 2. Broken Authentication
```csharp
// Check for:
- [Authorize] attribute on all endpoints
- Proper JWT validation configuration
- No hardcoded credentials
- Secure token storage
```

#### 3. Excessive Data Exposure
```csharp
// ❌ BAD: Returning entire entity
return Ok(await _context.Users.ToListAsync());

// ✅ GOOD: Using DTOs with specific fields
return Ok(await _context.Users
    .Select(u => new UserDto 
    { 
        Id = u.Id, 
        Name = u.Name,
        Email = u.Email
        // Exclude sensitive fields like PasswordHash
    })
    .ToListAsync());
```

#### 4. Lack of Resources & Rate Limiting
```csharp
// Check for rate limiting attributes
[HttpGet]
[RateLimit("GetFields", PerMinute = 100)]
public async Task<IActionResult> GetFields()
```

#### 5. Broken Function Level Authorization
```csharp
// Verify role-based access
[Authorize(Roles = "Admin,Manager")]
[HttpDelete("{id}")]
public async Task<IActionResult> Delete(Guid id)
```

### Phase 3: Performance Analysis

#### Database Query Optimization
```csharp
// ❌ BAD: N+1 query problem
var fields = await _context.Fields.ToListAsync();
foreach (var field in fields)
{
    field.PlotCount = field.Plots.Count(); // Triggers query
}

// ✅ GOOD: Eager loading
var fields = await _context.Fields
    .Include(f => f.Plots)
    .Select(f => new FieldDto
    {
        Id = f.Id,
        Name = f.Name,
        PlotCount = f.Plots.Count()
    })
    .ToListAsync();
```

#### Async/Await Patterns
```csharp
// ❌ BAD: Blocking async code
var result = _service.GetDataAsync().Result;

// ✅ GOOD: Proper async all the way
var result = await _service.GetDataAsync();
```

#### Caching Strategy
```csharp
// Review caching implementation
- Is data cacheable?
- Proper cache keys with organization scope?
- Cache invalidation after writes?
- Appropriate TTL (1-5 minutes)?
```

### Phase 4: Code Quality & Patterns

#### Result Pattern Usage
```csharp
// ✅ GOOD: Consistent Result<T> pattern
public async Task<Result<Field>> CreateFieldAsync(CreateFieldDto dto)
{
    if (!IsValid(dto))
        return Result<Field>.Failure("Validation failed");
    
    var field = Field.Create(dto.OrganizationId, dto.Name);
    await _repository.AddAsync(field);
    
    return Result<Field>.Success(field);
}
```

#### Domain Logic Placement
```csharp
// ❌ BAD: Business logic in service
public class FieldService
{
    public decimal CalculateYield(Field field)
    {
        return field.HarvestedAmount / field.Area;
    }
}

// ✅ GOOD: Business logic in domain
public class Field
{
    public Result<decimal> CalculateYield()
    {
        if (Area == 0)
            return Result<decimal>.Failure("Area cannot be zero");
        
        return Result<decimal>.Success(HarvestedAmount / Area);
    }
}
```

#### Error Handling
```csharp
// ✅ GOOD: Proper error responses
[HttpPost]
public async Task<IActionResult> Create([FromBody] CreateFieldDto request)
{
    var result = await _service.CreateAsync(request);
    
    if (!result.IsSuccess)
        return BadRequest(new ProblemDetails
        {
            Title = "Validation Error",
            Detail = result.Error,
            Status = StatusCodes.Status400BadRequest
        });
    
    return CreatedAtAction(nameof(GetById), 
        new { id = result.Value.Id }, result.Value);
}
```

### Phase 5: Testing Coverage

#### Unit Test Review
```csharp
// Check for:
- Business logic coverage (80% target)
- Edge cases handled
- Proper mocking of dependencies
- Clear test names following convention
```

#### Integration Test Review
```csharp
// Verify:
- API endpoint testing
- Multi-tenant isolation tests
- Error response validation
- Performance under load
```

## 🏗️ Architecture Review Checklist

### Domain Layer
- [ ] Entities have factory methods
- [ ] Business logic in domain models
- [ ] Proper value objects used
- [ ] Audit fields implemented
- [ ] IOrganizationScoped interface

### Repository Layer
- [ ] Organization filtering applied
- [ ] Soft delete respected
- [ ] Includes prevent N+1
- [ ] Async methods throughout
- [ ] Proper transaction handling

### Service Layer
- [ ] Result<T> pattern used
- [ ] Caching strategy implemented
- [ ] SignalR notifications sent
- [ ] Proper logging added
- [ ] Transaction boundaries correct

### API Layer
- [ ] RESTful conventions followed
- [ ] Proper HTTP status codes
- [ ] ProblemDetails for errors
- [ ] OpenAPI documentation
- [ ] Request/response DTOs

## 📊 Performance Review Criteria

### Database Performance
```sql
-- Check for missing indexes
SELECT 
    s.avg_total_user_cost * s.avg_user_impact * (s.user_seeks + s.user_scans) AS Impact,
    d.statement AS TableName,
    d.equality_columns,
    d.inequality_columns,
    d.included_columns
FROM sys.dm_db_missing_index_group_stats s
JOIN sys.dm_db_missing_index_groups g ON s.group_handle = g.index_group_handle
JOIN sys.dm_db_missing_index_details d ON g.index_handle = d.index_handle
ORDER BY Impact DESC;
```

### Memory & Resource Usage
- [ ] No memory leaks (proper disposal)
- [ ] Efficient collection usage
- [ ] Avoiding large object allocations
- [ ] Proper async enumeration
- [ ] Connection pooling utilized

## 🔐 Security Deep Dive

### Input Validation
```csharp
// Verify all inputs are validated
- Data annotations on DTOs
- Custom validation attributes
- Business rule validation
- SQL injection prevention
```

### Authentication & Authorization
```csharp
// Check configuration
- JWT settings secure
- Token expiration appropriate
- Refresh token implementation
- Auth0 integration correct
```

### Sensitive Data Handling
```csharp
// Ensure:
- No secrets in code
- Proper encryption for PII
- Audit logging for access
- GDPR compliance
```

### Phase 6: Final Comprehensive Review

I'll invoke the Tech Lead agent for this analysis.

@Task(description="Tech Lead analysis", prompt="Provide final assessment of $ARGUMENTS:
1. Production readiness evaluation
2. Deployment risk assessment
3. Performance impact analysis
4. Scalability verification
5. Technical debt evaluation
6. Integration testing requirements
7. Monitoring and alerting needs
Generate production deployment checklist
", subagent_type="Tech Lead")

## 📝 Multi-Agent Review Output

### Consolidated Agent Findings

The review synthesizes insights from all agents:

1. **Code Reviewer Results**
   - Code quality metrics
   - Pattern compliance score
   - Test coverage analysis
   - Refactoring suggestions

2. **Security Reviewer Results**
   - OWASP compliance status
   - Vulnerabilities identified
   - Risk assessment
   - Remediation requirements

3. **Tech Lead Results**
   - Architecture alignment
   - Scalability projections
   - Performance benchmarks
   - Production readiness

4. **Code Simplifier Results**
   - Complexity reduction opportunities
   - Maintainability improvements
   - Technical debt assessment

### Summary Report Format
```markdown
## Code Review Summary: [Feature/File Name]

**Overall Assessment**: [Approved/Needs Changes/Major Issues]
**Agent Consensus**: [Unanimous/Majority/Split Decision]

### Strengths (Identified by Agents)
- Well-structured domain logic (Code Reviewer)
- Proper multi-tenant isolation (Security Reviewer)
- Good test coverage (Code Reviewer)
- Scalable architecture (Tech Lead)

### Critical Issues (By Severity)
1. **CRITICAL - Security**: Missing organization filter in GetById endpoint (Security Reviewer)
2. **HIGH - Performance**: N+1 query in field listing (Tech Lead)
3. **MEDIUM - Architecture**: Business logic in service layer (Code Reviewer)
4. **LOW - Complexity**: Method exceeds 20 lines (Code Simplifier)

### Agent-Specific Recommendations
**Code Reviewer**: Consider adding integration tests for edge cases
**Security Reviewer**: Implement rate limiting on all endpoints
**Tech Lead**: Add database indexes for common query patterns
**Code Simplifier**: Extract complex validation logic to separate methods
```

### Detailed Findings
For each issue found:
```markdown
**Issue**: [Brief description]
**Severity**: [Critical/High/Medium/Low]
**Location**: `FieldService.cs:45`
**Current Code**:
```csharp
// problematic code
```
**Suggested Fix**:
```csharp
// improved code
```
**Rationale**: [Why this is important]
```

## 🚀 Improvement Recommendations

Think about:
1. **Scalability**: Will this handle 1000+ organizations?
2. **Maintainability**: Is the code self-documenting?
3. **Monitoring**: Are there enough metrics/logs?
4. **Documentation**: Is the API well-documented?
5. **Future-Proofing**: Does it allow for extension?

## Final Review Checklist

- [ ] Security vulnerabilities addressed
- [ ] Performance optimizations identified
- [ ] Architecture patterns followed
- [ ] Multi-tenant isolation verified
- [ ] Error handling comprehensive
- [ ] Testing adequate
- [ ] Documentation complete
- [ ] Production ready

Remember: **This review impacts a production agricultural system. Focus on reliability, security, and maintainability while ensuring the code meets the high standards required for real-world vineyard operations.**