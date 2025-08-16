---
description: Generate documentation with parallel analysis
allowed-tools: [Task, Read, Write, Grep, Glob]
estimated-time: 90 seconds (parallel)
complexity: simple
category: documentation
---

# 📚 Generate Docs: $ARGUMENTS

## Parallel Documentation Generation (90 seconds)

@Task(
  description="API documentation",
  prompt="Generate API docs for '$ARGUMENTS':
  
  ANALYZE:
  1. Controller endpoints
  2. DTOs and models
  3. Authentication requirements
  4. Response codes
  
  GENERATE: Complete API reference
  WRITE TO: docs/API.md",
  subagent_type="tech-docs-specialist"
)

@Task(
  description="Architecture docs",
  prompt="Generate architecture docs for '$ARGUMENTS':
  
  DOCUMENT:
  1. System architecture
  2. Component relationships
  3. Data flow diagrams
  4. Technology stack
  
  GENERATE: Architecture guide
  WRITE TO: docs/ARCHITECTURE.md",
  subagent_type="technical-documentation-writer"
)

@Task(
  description="Setup guide",
  prompt="Generate setup docs for '$ARGUMENTS':
  
  CREATE:
  1. Prerequisites
  2. Installation steps
  3. Configuration guide
  4. Troubleshooting
  
  GENERATE: Complete setup guide
  WRITE TO: docs/SETUP.md",
  subagent_type="tech-docs-specialist"
)

@Task(
  description="Developer guide",
  prompt="Generate developer docs for '$ARGUMENTS':
  
  INCLUDE:
  1. Development workflow
  2. Coding standards
  3. Testing approach
  4. Contribution guide
  
  GENERATE: Developer handbook
  WRITE TO: docs/DEVELOPER.md",
  subagent_type="technical-documentation-writer"
)

## ✅ Complete
Documentation generated in docs/ directory.