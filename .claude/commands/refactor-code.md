---
description: Refactor code with parallel analysis and fixes
allowed-tools: [Task, Read, Edit, MultiEdit, Grep]
estimated-time: 2 minutes (parallel)
complexity: simple
category: quality
---

# 🔧 Refactor Code: $ARGUMENTS

## Parallel Analysis & Refactoring (2 minutes)

@Task(
  description="Complexity analysis",
  prompt="Analyze '$ARGUMENTS' for complexity:
  
  FIND:
  1. Methods over 20 lines
  2. Nested conditionals (>2 levels)
  3. Duplicate code patterns
  4. Complex LINQ chains
  5. God classes/methods
  
  OUTPUT: Top 3 complexity issues with locations",
  subagent_type="technical-debt-analyzer"
)

@Task(
  description="Simplify code",
  prompt="Refactor '$ARGUMENTS' complexity:
  
  FIX:
  1. Extract methods from long functions
  2. Use early returns for nested ifs
  3. Apply guard clauses
  4. Simplify boolean logic
  5. Use C# 13 features (primary constructors, collection expressions)
  
  OUTPUT: Simplified code implementations",
  subagent_type="code-simplifier"
)

@Task(
  description="Extract patterns",
  prompt="Extract common patterns in '$ARGUMENTS':
  
  IDENTIFY:
  1. Duplicate mapping logic
  2. Repeated repository patterns
  3. Common validation logic
  4. Similar error handling
  
  CREATE:
  1. Generic base classes
  2. Shared utility methods
  3. Common interfaces
  
  OUTPUT: Extracted reusable components",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Optimize performance",
  prompt="Optimize '$ARGUMENTS' performance:
  
  FIX:
  1. Multiple enumeration of collections
  2. Inefficient LINQ queries
  3. Missing AsNoTracking()
  4. Unnecessary async/await
  5. String concatenation in loops
  
  OUTPUT: Performance-optimized code",
  subagent_type="technical-debt-analyzer"
)

## ✅ Complete
Code refactored for simplicity, reusability, and performance.