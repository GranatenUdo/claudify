---
description: Fast parallel research with actionable answers
allowed-tools: [Task, Grep, Read, WebSearch, Glob]
estimated-time: 90 seconds (parallel)
complexity: simple
category: research
model: opus
---

# ⚡ Quick Research: $ARGUMENTS

**For complex questions despite being quick research, enable extended thinking for comprehensive answers.**

## Parallel Smart Discovery (90 seconds)

@Task(
  description="Codebase research",
  prompt="Research '$ARGUMENTS' in codebase:
  
  FIND:
  1. Implementations and patterns
  2. Current usage examples
  3. Known issues (TODOs, FIXMEs)
  4. Related documentation
  
  FOCUS: Actual code, not theory
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
  2. Our codebase approach
  3. Industry best practice
  4. Specific recommendation
  5. Code example if applicable
  
  FORMAT: Actionable, not academic
  OUTPUT: Clear next steps",
  subagent_type="tech-lead-engineer"
)

## ✅ Answer Ready
Research complete with actionable recommendations.