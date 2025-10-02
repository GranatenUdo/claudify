---
description: Performance research for optimization opportunities and bottlenecks
allowed-tools: [Task, WebSearch, Grep, Read, Bash]
argument-hint: performance issue or optimization target (e.g., "database queries", "bundle size", "API latency")
---

# ⚡ Performance Research: $ARGUMENTS

**For complex performance issues or system-wide optimizations, enable extended thinking for comprehensive analysis.**

## Phase 1: Parallel Performance Investigation (2 minutes)

### 📊 Benchmark Research Agent
@Task(
  description="Performance benchmarks and standards",
  prompt="Research performance benchmarks for '$ARGUMENTS':
  
  FIND:
  1. Industry performance standards for this
  2. Real-world performance numbers from production systems
  3. User experience impact thresholds
  
  Search for:
  - Performance studies with actual metrics
  - Google/Microsoft performance guidelines
  - Core Web Vitals if frontend-related
  
  Provide:
  - Target metrics we should hit
  - Current industry best practices
  - Cost of poor performance (user impact)
  
  Focus on measurable, achievable targets.",
  subagent_type="best-practices-researcher"
)

### 🔧 Optimization Patterns Agent
@Task(
  description="Find optimization techniques",
  prompt="Research optimization techniques for '$ARGUMENTS':
  
  FIND:
  1. Proven optimization patterns for our stack (.NET 9/Angular 19)
  2. Quick wins vs. major refactoring
  3. Common mistakes to avoid
  
  Look for:
  - Microsoft performance documentation
  - Real GitHub examples (not tutorials)
  - Stack Overflow solutions that actually worked
  
  Prioritize:
  - Low-effort, high-impact fixes
  - Patterns that fit our architecture
  - Solutions with measured improvements
  
  Include specific code examples.",
  subagent_type="tech-lead-engineer"
)

### 🐌 Bottleneck Detection Agent
@Task(
  description="Find bottlenecks in our code",
  prompt="Scan for '$ARGUMENTS' performance issues in our codebase:
  
  DETECT:
  1. Anti-patterns known to cause performance issues
  2. Missing optimizations (caching, pagination, etc.)
  3. Resource-intensive operations
  
  Use Grep to find:
  - N+1 query patterns
  - Missing async/await
  - Large data operations without pagination
  - Missing indexes or caching
  
  For each finding:
  - Estimated performance impact
  - File:line location
  - Specific optimization needed
  
  Focus on the worst offenders.",
  subagent_type="technical-debt-analyzer"
)

## Phase 2: Measurement & Validation (1 minute)

### Quick Performance Check
@Bash(command="dotnet build --configuration Release /p:AnalysisMode=AllEnabledByDefault", description="Static performance analysis")

## Synthesis

```markdown
# Performance Research: $ARGUMENTS

## 📈 Current vs. Target Performance

| Metric | Current | Target | Gap | Impact |
|--------|---------|--------|-----|--------|
| [Metric] | X ms/MB | Y ms/MB | Z% | User experience |

## 🎯 Top 3 Optimization Opportunities

### 1. [Highest Impact Fix]
**Current**: [Problem description]
**Fix**: 
```code
// Optimized implementation
```
**Expected Improvement**: X% faster
**Effort**: Y hours

### 2. [Second Impact Fix]
[Similar structure]

### 3. [Third Impact Fix]
[Similar structure]

## 🔍 Bottlenecks Found in Our Code

| Location | Issue | Impact | Fix Complexity |
|----------|-------|--------|----------------|
| File:line | N+1 query | High | Simple |
| File:line | No caching | Medium | Moderate |

## 📊 Performance Budget

Based on research, our targets should be:
- **API Response**: < 200ms (p95)
- **Page Load**: < 3s (mobile 3G)
- **Bundle Size**: < 500KB initial
- **Memory Usage**: < 100MB idle

## ✅ Implementation Plan

### Quick Wins (Today)
```bash
# Commands to apply immediate optimizations
```

### Systematic Improvements (This Sprint)
1. [Optimization 1 with steps]
2. [Optimization 2 with steps]

### Monitoring Setup
```csharp
// Add performance tracking
services.AddApplicationInsightsTelemetry();
```

## 💰 ROI Calculation
- **Implementation Time**: X hours
- **Performance Gain**: Y% improvement
- **User Impact**: Z% better experience
- **Cost Savings**: $X/month in infrastructure
```

## Convention Awareness

Performance improvements are based on observed codebase patterns and respect your architectural choices.

## Why This Works

1. **Metrics-driven** - Everything measurable
2. **Practical patterns** - Solutions for our stack
3. **Prioritized** - Biggest wins first
4. **Validated** - With actual measurements
5. **ROI-focused** - Time vs. benefit clear
6. **Pattern-aligned** - Works within your architecture

Remember: Optimize what matters to users, not what's interesting to developers.