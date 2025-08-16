---
description: Generate documentation by analyzing actual code
allowed-tools: [Task, Read, Write, Grep, Glob]
estimated-time: 90 seconds (parallel)
complexity: simple
category: documentation
---

# 📚 Generate Documentation: $ARGUMENTS

## Parallel Analysis & Generation (90 seconds)

@Task(
  description="Code analysis",
  prompt="Analyze code for '$ARGUMENTS':
  
  FIND:
  1. Main classes and components
  2. API endpoints and DTOs
  3. Configuration requirements
  4. Usage patterns in tests
  
  OUTPUT: Structured analysis for documentation",
  subagent_type="legacy-codebase-analyzer"
)

@Task(
  description="API documentation",
  prompt="Generate API docs for '$ARGUMENTS':
  
  CREATE:
  1. Endpoint reference with routes
  2. Request/response examples
  3. Auth requirements
  4. Error codes
  
  FORMAT: Markdown with curl examples
  WRITE TO: docs/api-$ARGUMENTS.md",
  subagent_type="tech-docs-specialist"
)

@Task(
  description="Setup guide",
  prompt="Generate setup for '$ARGUMENTS':
  
  CREATE:
  1. Prerequisites
  2. Installation steps
  3. Configuration guide
  4. Verification steps
  
  FORMAT: Step-by-step markdown
  WRITE TO: docs/setup-$ARGUMENTS.md",
  subagent_type="technical-documentation-writer"
)

@Task(
  description="Usage examples",
  prompt="Generate examples for '$ARGUMENTS':
  
  CREATE:
  1. Basic usage from tests
  2. Common scenarios
  3. Error handling
  4. Best practices
  
  FORMAT: Working code samples
  WRITE TO: docs/examples-$ARGUMENTS.md",
  subagent_type="tech-docs-specialist"
)

@Task(
  description="Documentation index",
  prompt="Create index for '$ARGUMENTS':
  
  CREATE README with:
  - Overview
  - Links to all docs
  - Quick navigation
  
  WRITE TO: docs/README-$ARGUMENTS.md",
  subagent_type="technical-documentation-writer"
)

## ✅ Complete
Documentation generated in docs/ directory.