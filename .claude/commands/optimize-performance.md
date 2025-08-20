---
description: Fix performance bottlenecks with parallel analysis
allowed-tools: [Task, Read, Edit, MultiEdit, Bash, Grep]
estimated-time: 2 minutes (parallel)
complexity: moderate
category: optimization
---

# ⚡ Optimize Performance: $ARGUMENTS

## Parallel Performance Analysis & Fixes (2 minutes)

@Task(
  description="Database optimization",
  prompt="Optimize database for '$ARGUMENTS':
  
  FIND & FIX:
  1. N+1 queries - Add Include() statements
  2. Missing indexes - Generate CREATE INDEX
  3. Tracking issues - Add AsNoTracking()
  4. Slow LINQ - Optimize to SQL projections
  5. Large result sets - Add pagination
  
  OUTPUT: Optimized queries and index scripts",
  subagent_type="technical-debt-analyzer"
)

@Task(
  description="API optimization",
  prompt="Optimize API for '$ARGUMENTS':
  
  FIX:
  1. Blocking calls - Convert to async/await
  2. Missing caching - Add response cache
  3. Large payloads - Implement pagination
  4. Slow serialization - Optimize DTOs
  5. Memory leaks - Fix IDisposable
  
  OUTPUT: Optimized endpoint code",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Frontend optimization",
  prompt="Optimize frontend for '$ARGUMENTS':
  
  FIX:
  1. Bundle size - Remove unused imports
  2. Change detection - Ensure OnPush
  3. Signal efficiency - Optimize computed()
  4. Network calls - Batch requests
  5. Rendering - Add virtual scrolling
  
  OUTPUT: Optimized components",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Measure improvements",
  prompt="Assess performance improvements:
  
  BASELINE & VALIDATE:
  1. Response times before/after
  2. Memory usage comparison
  3. Bundle size reduction
  4. Query execution time
  
  OUTPUT: Performance metrics report",
  subagent_type="test-quality-analyzer"
)

## ✅ Complete
Performance optimization complete. Review the metrics report to verify improvements.