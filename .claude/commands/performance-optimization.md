---
description: Parallel performance optimization across all layers - 5 agents find and fix bottlenecks
allowed-tools: [Task, Read, Grep, Glob, Bash, Edit, MultiEdit]
argument-hint: area to optimize (e.g., "database", "api", "frontend", "all")
---

# ⚡ Parallel Performance Optimization: $ARGUMENTS

**For complex performance optimization or system-wide bottlenecks, enable extended thinking for comprehensive analysis.**

## Phase 1: Parallel Analysis & Fix

### 🗄️ Database Performance Agent
@Task(
  description="Database optimization",
  prompt="Optimize database performance for '$ARGUMENTS':
  
  FIND & FIX:
  1. N+1 queries: Add Include() statements
  2. Missing indexes: Generate CREATE INDEX scripts
  3. Tracking issues: Add AsNoTracking() to reads
  4. Slow queries: Optimize LINQ/SQL
  
  DELIVER:
  - Problems found with file:line
  - Optimized code implementations
  - Index creation scripts
  - Optimization opportunities
  
  Focus on queries taking >100ms.",
  subagent_type="technical-debt-analyzer"
)

### 🚀 API Performance Agent
@Task(
  description="API optimization",
  prompt="Optimize API performance for '$ARGUMENTS':
  
  FIND & FIX:
  1. Blocking calls: Fix .Result/.Wait() with async/await
  2. Missing caching: Add response cache attributes
  3. Large payloads: Implement pagination
  4. Memory leaks: Fix IDisposable issues
  
  DELIVER:
  - Bottlenecks with measurements
  - Optimized endpoint code
  - Caching strategies implemented
  - Memory optimizations
  
  Target sub-200ms response times.",
  subagent_type="tech-lead-engineer"
)

### 🎨 Frontend Performance Agent
@Task(
  description="Frontend optimization",
  prompt="Optimize frontend performance for '$ARGUMENTS':
  
  FIND & FIX:
  1. Bundle size: Remove unused imports, add lazy loading
  2. Change detection: Ensure OnPush everywhere
  3. Signal efficiency: Optimize computed() usage
  4. Network calls: Batch/parallelize requests
  
  DELIVER:
  - Bundle size reductions
  - Component optimizations
  - Network improvements
  - Rendering optimizations
  
  Target <3s load time, <100ms interactions.",
  subagent_type="frontend-implementation-expert"
)

### 🏗️ Infrastructure Performance Agent
@Task(
  description="Infrastructure optimization",
  prompt="Optimize infrastructure for '$ARGUMENTS':
  
  FIND & FIX:
  1. Docker: Reduce image size, optimize layers
  2. Resources: Tune CPU/memory limits
  3. Caching: Add Redis/CDN where needed
  4. Scaling: Configure auto-scaling
  
  DELIVER:
  - Dockerfile optimizations
  - Resource configurations
  - Caching implementations
  - Cost reduction opportunities
  
  Look for resource optimization opportunities.",
  subagent_type="infrastructure-architect"
)

### 📊 Metrics & Validation Agent
@Task(
  description="Measure improvements",
  prompt="Measure performance for '$ARGUMENTS':
  
  BASELINE & VALIDATE:
  1. Current metrics: Response times, memory, throughput
  2. Bottlenecks: Identify top 3 slowest operations
  3. Improvements: Measure actual vs expected gains
  4. User impact: Load time, interactivity metrics
  
  DELIVER:
  - Before/after metrics
  - Bottleneck heatmap
  - Validation results
  - ROI calculation
  
  Provide hard numbers only.",
  subagent_type="test-quality-analyzer"
)

## Phase 2: Parallel Validation

### Build & Benchmark
@Bash(command="dotnet build --configuration Release", description="Release build")
@Bash(command="dotnet test --configuration Release --filter Category=Performance", description="Performance tests")
@Bash(command="npm run build:prod", description="Production build")
@Bash(command="npm run analyze", description="Bundle analysis")

## 📈 Optimization Report

```markdown
# Performance Results: $ARGUMENTS

## 🎯 Top 3 Wins
1. **[Biggest Win]**: Description of improvement
2. **[Second Win]**: Description of improvement  
3. **[Third Win]**: Description of improvement

## 📊 Metrics
| Layer | Before | After | Gain |
|-------|--------|-------|------|
| Database | Before | After | Change |
| API | Before | After | Change |
| Frontend | Before | After | Change |
| Memory | Before | After | Change |

## ✅ Optimizations Applied
- Database: [List of fixes]
- API: [List of fixes]
- Frontend: [List of fixes]
- Infrastructure: [List of fixes]

## Impact
- User Experience: Improved response times
- Cloud Costs: Potential savings identified
- Capacity: Additional headroom available
```

## Convention Awareness

This command respects existing patterns observed in the codebase. All optimizations work within your architecture, maintaining consistency.

## 🎯 Why This Works
- **5 parallel agents** - All layers optimized simultaneously
- **Integrated fixes** - Analysis and implementation together
- **Measurable results** - Concrete before/after metrics
- **Parallel execution** - Multiple agents work simultaneously
- **Pattern-respecting** - Maintains architectural consistency

Remember: Fix the bottlenecks users actually feel.