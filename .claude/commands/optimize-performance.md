---
description: Analyze and optimize code performance, focusing on database queries, caching, and resource usage
allowed-tools: [Task, Bash, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite]
argument-hint: specific area or --full-analysis (e.g., "api/fields" or "--full-analysis --focus=database")
agent-dependencies: [Tech Lead, Code Reviewer, Researcher, Infrastructure Architect, Technical Debt Analyst]
complexity: complex
estimated-time: 20-45 minutes (with parallel agent execution)
category: devops
---

# ⚡ Optimize Performance: $ARGUMENTS

## Quick Context
Use this command to identify and fix performance bottlenecks in your application, from database queries to API response times.

## Execution Flow
1. **Profiling** - Measure current performance metrics
2. **Analysis** - Identify bottlenecks and optimization opportunities
3. **Implementation** - Apply targeted performance improvements
4. **Validation** - Confirm improvements without breaking functionality

## Interactive Options
```yaml
focus: database|api|memory|cpu|all (default: all)
threshold: minimum performance gain to consider (default: 10%)
aggressive: apply more aggressive optimizations
benchmark: run before/after benchmarks
```

## Phase 1: Performance Baseline

<think harder about performance measurement and bottleneck identification>

### Initial Metrics Collection
I'll establish baseline performance metrics for comparison.

```bash
# Check current resource usage
@Bash(command="dotnet build --configuration Release", description="Build in release mode")

# Run performance tests if available
@Bash(command="dotnet test --filter Category=Performance --configuration Release", description="Run performance tests")
```

### Database Performance Analysis
```sql
-- Identify slow queries (would be run via appropriate tooling)
SELECT TOP 10
    qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time,
    qs.total_logical_reads / qs.execution_count AS avg_logical_reads,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) + 1) AS query_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY avg_elapsed_time DESC
```

## Phase 2: Multi-Agent Performance Analysis

<think concurrently about different performance aspects>

### Technical Architecture Assessment
I'll invoke the Tech Lead agent for high-level performance architecture review.

@Task(description="Performance architecture analysis", prompt="Analyze $ARGUMENTS for performance issues:
1. Database query patterns (N+1, missing indexes, unnecessary joins)
2. Caching strategy effectiveness
3. Async/await usage and potential deadlocks
4. Memory allocation patterns
5. API response time bottlenecks
6. Dependency injection lifecycle issues
7. Third-party service call optimization
Provide specific optimization recommendations with expected impact", subagent_type="Tech Lead")

### Code-Level Performance Review
Next, I'll get detailed code-level performance insights.

@Task(description="Code performance analysis", prompt="Review $ARGUMENTS for performance anti-patterns:
1. Inefficient LINQ queries (multiple enumerations, etc.)
2. Unnecessary object allocations in hot paths
3. String concatenation in loops
4. Synchronous I/O in async methods
5. Missing disposal of resources
6. Inefficient collection usage
7. Reflection or dynamic usage in critical paths
Prioritize by performance impact", subagent_type="Code Reviewer")

### Research Performance Best Practices
I'll research latest performance optimization techniques.

@Task(description="Performance research", prompt="Research performance optimizations for:
1. Latest EF Core performance features and patterns
2. High-performance caching strategies for multi-tenant systems
3. Database indexing strategies for the queries found
4. Memory pooling and span usage in .NET
5. HTTP/2 and gRPC optimization techniques
6. Container and cloud-native performance patterns
Provide actionable recommendations", subagent_type="Researcher")

### Infrastructure Performance Assessment
I'll analyze system-level performance considerations.

@Task(description="Infrastructure performance analysis", prompt="Analyze $ARGUMENTS for infrastructure-level performance:
1. Database connection pooling and configuration
2. Container resource limits and scaling
3. Network latency and API gateway optimization
4. Load balancing strategies
5. CDN and static asset delivery
6. Service mesh performance impact
7. Observability overhead assessment
Provide infrastructure optimization recommendations with expected impact", subagent_type="Infrastructure Architect")

### Technical Debt Performance Impact
I'll identify technical debt affecting performance.

@Task(description="Performance debt analysis", prompt="Identify technical debt impacting performance in $ARGUMENTS:
1. Legacy patterns causing performance bottlenecks
2. Outdated libraries affecting efficiency
3. Architectural decisions limiting scalability
4. Missing abstractions causing repeated inefficiencies
5. Accumulated workarounds degrading performance
6. Deferred optimizations now critical
Prioritize by performance impact and refactoring effort", subagent_type="Technical Debt Analyst")

## Phase 3: Optimization Implementation

<think step-by-step about applying optimizations safely>

### Database Optimizations

#### 1. Add Missing Indexes
```csharp
// Migration to add performance-critical indexes
public partial class AddPerformanceIndexes : Migration
{
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        // Composite index for common query pattern
        migrationBuilder.CreateIndex(
            name: "IX_Fields_OrganizationId_IsDeleted_CreatedAt",
            table: "Fields",
            columns: new[] { "OrganizationId", "IsDeleted", "CreatedAt" },
            descending: new[] { false, false, true });
            
        // Covering index for field summary queries
        migrationBuilder.CreateIndex(
            name: "IX_Fields_OrganizationId_Include_Name_Area",
            table: "Fields",
            columns: new[] { "OrganizationId" })
            .Include(new[] { "Name", "AreaHectares" });
    }
}
```

#### 2. Optimize Queries
```csharp
// Before: N+1 query problem
public async Task<IEnumerable<FieldDto>> GetFieldsAsync(Guid organizationId)
{
    var fields = await _context.Fields
        .Where(f => f.OrganizationId == organizationId)
        .ToListAsync();
        
    return fields.Select(f => new FieldDto
    {
        Id = f.Id,
        Name = f.Name,
        CurrentCrop = f.FieldUsages.FirstOrDefault()?.Crop.Name // N+1!
    });
}

// After: Optimized with projection
public async Task<IEnumerable<FieldDto>> GetFieldsAsync(Guid organizationId)
{
    return await _context.Fields
        .Where(f => f.OrganizationId == organizationId)
        .Select(f => new FieldDto
        {
            Id = f.Id,
            Name = f.Name,
            CurrentCrop = f.FieldUsages
                .Where(fu => fu.EndDate == null)
                .Select(fu => fu.Crop.Name)
                .FirstOrDefault()
        })
        .ToListAsync();
}
```

### Caching Implementation

#### 1. Implement Distributed Caching
```csharp
public class CachedFieldService : IFieldService
{
    private readonly IFieldService _innerService;
    private readonly IDistributedCache _cache;
    private readonly ILogger<CachedFieldService> _logger;
    
    public async Task<Result<IEnumerable<Field>>> GetFieldsAsync(Guid organizationId)
    {
        var cacheKey = $"fields:{organizationId}";
        
        // Try to get from cache
        var cached = await _cache.GetAsync<IEnumerable<Field>>(cacheKey);
        if (cached != null)
        {
            _logger.LogDebug("Cache hit for {CacheKey}", cacheKey);
            return Result<IEnumerable<Field>>.Success(cached);
        }
        
        // Get from database
        var result = await _innerService.GetFieldsAsync(organizationId);
        if (result.IsSuccess)
        {
            // Cache with sliding expiration
            await _cache.SetAsync(cacheKey, result.Value, new DistributedCacheEntryOptions
            {
                SlidingExpiration = TimeSpan.FromMinutes(5),
                AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(15)
            });
        }
        
        return result;
    }
}
```

### Memory Optimization

#### 1. Use ArrayPool for Large Operations
```csharp
public class BulkFieldProcessor
{
    private readonly ArrayPool<Field> _fieldPool = ArrayPool<Field>.Shared;
    
    public async Task ProcessFieldsInBatchesAsync(IEnumerable<Field> fields)
    {
        const int batchSize = 1000;
        Field[] buffer = null;
        
        try
        {
            buffer = _fieldPool.Rent(batchSize);
            
            // Process in batches to reduce memory pressure
            await foreach (var batch in fields.Chunk(batchSize))
            {
                batch.CopyTo(buffer, 0);
                await ProcessBatch(buffer, batch.Length);
            }
        }
        finally
        {
            if (buffer != null)
                _fieldPool.Return(buffer, clearArray: true);
        }
    }
}
```

## Phase 4: Performance Validation

<think about measuring improvements and ensuring stability>

### Benchmark Comparison
```bash
# Run performance benchmarks
@Bash(command="dotnet run -c Release --project benchmarks/PTA.VineyardManagement.Benchmarks", description="Run performance benchmarks")
```

### Load Testing
```yaml
# Example k6 load test script
import http from 'k6/http';
import { check } from 'k6';

export let options = {
  vus: 50,
  duration: '5m',
  thresholds: {
    http_req_duration: ['p(95)<500'], // 95% of requests under 500ms
    http_req_failed: ['rate<0.01'],   // Error rate under 1%
  },
};

export default function() {
  let response = http.get('https://api.vineyard.com/fields');
  check(response, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
}
```

### Interactive Performance Report
```markdown
## Performance Optimization Results

### Summary
- **Overall Improvement**: [X]% faster response times
- **Database**: [Y]% reduction in query time
- **Memory**: [Z]% less allocation
- **Cache Hit Rate**: [N]% (was 0%)

### Detailed Improvements

#### Database Performance
| Query | Before (ms) | After (ms) | Improvement |
|-------|-------------|------------|-------------|
| GetFields | 450 | 125 | 72% |
| GetFieldDetails | 280 | 45 | 84% |
| SearchFields | 890 | 210 | 76% |

#### API Response Times (p95)
| Endpoint | Before | After | Target Met |
|----------|--------|-------|------------|
| GET /fields | 650ms | 180ms | ✅ |
| POST /fields | 450ms | 220ms | ✅ |
| PUT /fields/{id} | 380ms | 150ms | ✅ |

### Applied Optimizations
1. ✅ Added 5 database indexes
2. ✅ Implemented distributed caching
3. ✅ Optimized 12 LINQ queries
4. ✅ Reduced memory allocations by 45%
5. ✅ Implemented connection pooling

### Recommendations for Further Improvement
1. Consider read replicas for heavy read operations
2. Implement response compression
3. Add CDN for static assets
4. Consider GraphQL for reducing over-fetching
```

## Success Criteria
- ✅ API response time p95 < 500ms
- ✅ Database query time reduced by >50%
- ✅ Memory allocation reduced by >30%
- ✅ No functionality regressions
- ✅ All tests still pass

## Error Handling

### Performance Regression Detection
If performance degrades after optimization:
1. Revert the specific optimization
2. Analyze why it caused regression
3. Try alternative approach
4. Document in ADR

### Common Pitfalls
- **Over-caching**: Can lead to stale data issues
- **Too Aggressive Indexing**: Slows down writes
- **Premature Optimization**: Profile first, optimize second
- **Thread Pool Starvation**: Monitor async operations

## Next Steps

After optimization:
1. Set up continuous performance monitoring
2. Add performance tests to CI/CD pipeline
3. Document performance SLAs
4. Schedule regular performance reviews