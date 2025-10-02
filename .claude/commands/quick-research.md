---
description: Fast parallel research with actionable answers
allowed-tools: [Task, Grep, Read, WebSearch, Glob]
---

# ⚡ Quick Research: $ARGUMENTS

**For complex questions despite being quick research, enable extended thinking for comprehensive answers.**

## Parallel Smart Discovery (90 seconds)

@Task(
  description="Codebase research",
  prompt="Research '$ARGUMENTS' in codebase:

  FIND:
  1. Implementations and patterns (respect existing)
  2. Current usage examples
  3. Known issues (TODOs, FIXMEs)
  4. Related documentation

  FOCUS: Actual code and project patterns, not theory
  OUTPUT: Findings with file:line references",
  subagent_type="best-practices-researcher"
)

@Task(
  description="External research",
  prompt="Research '$ARGUMENTS' best practices:
  
  SEARCH:
  1. Production implementations
  2. Common pitfalls
  3. Performance considerations
  4. Security implications
  
  SOURCES: Stack Overflow, GitHub, official docs
  OUTPUT: Proven patterns and anti-patterns",
  subagent_type="best-practices-researcher"
)

@Task(
  description="Solution synthesis",
  prompt="Synthesize research for '$ARGUMENTS':

  DELIVER:
  1. Direct answer (1 paragraph)
  2. Our codebase approach (based on observed patterns)
  3. Common practices (contextual, not prescriptive)
  4. Specific recommendation for THIS project
  5. Code example matching project patterns

  FORMAT: Actionable, not academic
  OUTPUT: Clear next steps aligned with project",
  subagent_type="tech-lead-engineer"
)

## Convention Awareness
Adapts to your project's patterns observed in the codebase.

## ✅ Answer Ready
Research complete with actionable recommendations.