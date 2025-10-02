---
description: Review backend code for high-impact issues with C# 13, RESTful, and T-SQL focus
allowed-tools: [Task, Read, Grep, Glob, TodoWrite]
argument-hint: controller, service, or directory to review
agent-dependencies: [Tech Lead, Security Reviewer]
complexity: simple
estimated-time: 5-8 minutes
category: quality
---

# 🎯 Review Backend Code: $ARGUMENTS

<think harder about the TOP 3 issues that could cause real problems in production>

## Phase 1: Smart Discovery (1 min)

### Find Target Files
@Glob(pattern="**/*$ARGUMENTS*")
@Grep(pattern="class.*Controller|class.*Service|class.*Repository", path="$ARGUMENTS", output_mode="files_with_matches", head_limit=10)

### Read Critical Files
<!-- Read 2-3 most important files only -->

## Phase 2: Value-Focused Review (5 min)

### Tech Lead - C# 13 & Architecture Review
@Task(description="Backend code review", prompt="Review backend code in '$ARGUMENTS' for HIGH-IMPACT issues:

FOCUS ON TOP 3 ISSUES:
1. BREAKS in production (null refs, deadlocks, memory leaks)
2. SECURITY vulnerabilities (missing org scoping, SQL injection, exposed data)
3. PERFORMANCE problems (N+1 queries, missing indexes, synchronous I/O)

C# 13/.NET 9 CHECKS:
✓ Primary constructors used correctly
✓ Collection expressions [...] utilized
✓ Nullable reference types enabled
✓ System.Threading.Lock for synchronization
✓ params with ReadOnlySpan<T>

RESTful API CHECKS:
✓ Proper HTTP verbs (GET, POST, PUT, DELETE)
✓ Status codes correct (200, 201, 400, 404, 409)
✓ Resource naming (plural, lowercase)
✓ Idempotency for PUT/DELETE
✓ HATEOAS principles (if applicable)

T-SQL/EF CORE CHECKS:
✓ Organization scoping in EVERY query
✓ AsNoTracking() for read operations
✓ Include() vs lazy loading (N+1)
✓ Parameterized queries (no SQL injection)
✓ Index usage for WHERE clauses

DOCKER/DEPLOYMENT CHECKS:
✓ Configuration from environment
✓ Health checks defined
✓ Graceful shutdown handling
✓ Resource limits appropriate

FOR EACH ISSUE:
- Problem: [Specific description]
- Impact: [Production consequence]
- Fix: [Exact code to implement]
- Priority: [Critical/High/Medium]

Skip style preferences. Focus on production issues.", subagent_type="tech-lead-engineer")

### Security Reviewer - Critical Validation
@Task(description="Security review", prompt="Security review for '$ARGUMENTS' backend:

CRITICAL CHECKS ONLY:
1. Organization scoping (EVERY query must filter)
2. SQL injection (parameterized queries only)
3. Authorization ([Authorize] attributes)
4. Sensitive data (no passwords/keys in logs)
5. Error messages (no internal details exposed to clients)

If SECURE: Say 'Security ✓'
If ISSUES: Provide exact fix with code

Focus on exploitable vulnerabilities.", subagent_type="security-vulnerability-scanner")

## Phase 3: Actionable Output (2 min)

### Review Summary

#### 🔴 Critical Issues (Fix Before Deploy)
<!-- Issues that will break in production -->

#### 🟡 Important Issues (Fix This Sprint)
<!-- Issues that hurt performance/maintainability -->

#### 🟢 Nice to Have (Backlog)
<!-- Minor improvements -->

### Code Quality Metrics
- Organization Scoping: [✓/✗]
- RESTful Design: [✓/✗]
- C# 13 Patterns: [✓/✗]
- T-SQL Optimization: [✓/✗]
- Docker Ready: [✓/✗]
- Security: [✓/✗]

### Top 3 Actions
1. [Most critical fix]
2. [Second priority]
3. [Third priority]

## Convention Awareness

This command reviews based on observed codebase patterns. Recommendations align with YOUR project's choices, not external "best practices".

## Code Examples

### Pattern Consistency Example
```csharp
// IF project uses Result<T> pattern (observed in codebase):
public async Task<Result<User>> GetAsync(Guid id, string orgId)
{
    var user = await repository.GetByIdAsync(id, orgId);
    return user ?? Result<User>.Failure("Not found");
}

// IF project uses exception pattern (observed in codebase):
public async Task<User> GetAsync(Guid id, string orgId)
{
    var user = await repository.GetByIdAsync(id, orgId)
        ?? throw new NotFoundException($"User {id} not found");
    return user;
}
```

Both are valid - consistency with observed project patterns matters most.

## Value Principles
1. **Production Focus**: Find what will actually break
2. **Security First**: Organization isolation is mandatory
3. **Performance Matters**: T-SQL efficiency prevents scaling issues
4. **Modern Patterns**: C# 13 features reduce code complexity
5. **Quick Insights**: 5-8 minutes to actionable feedback

Remember: Find the few issues that matter in production, not every possible improvement.