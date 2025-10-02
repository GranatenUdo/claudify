---
description: Fix backend bugs with parallel root cause analysis
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Bash]
estimated-time: 1-2 minutes (parallel)
complexity: moderate
category: quality
---

# 🔧 Fix Backend Bug: $ARGUMENTS

## Phase 1: Parallel Diagnosis

@Task(
  description="Root cause analysis",
  prompt="Diagnose '$ARGUMENTS':
  
  LOCATE:
  1. Error location, stack trace, logs
  2. Recent commits that may have introduced issue
  3. Code flow and dependencies
  
  ANALYZE:
  - Missing OrganizationId filters (common issue)
  - Null references and defensive programming gaps
  - Async/await deadlocks or .Result usage
  - EF tracking issues or Include() problems
  - Inconsistent error handling (check project conventions)
  
  OUTPUT: Root cause with file:line and confidence level",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Impact analysis",
  prompt="Analyze impact of '$ARGUMENTS':
  
  FIND:
  1. Similar code patterns that may have same bug
  2. Dependent components affected
  3. Data corruption risks
  4. Performance implications
  
  OUTPUT: Blast radius and related issues",
  subagent_type="technical-debt-analyzer"
)

@Task(
  description="Security check",
  prompt="Security implications of '$ARGUMENTS':
  
  VERIFY:
  1. No cross-tenant data exposure
  2. No authentication bypass
  3. No sensitive data in errors/logs
  4. Input validation intact
  
  OUTPUT: Security assessment and required fixes",
  subagent_type="security-vulnerability-scanner"
)

## Phase 2: Fix Implementation

@Task(
  description="Implement fix with tests",
  prompt="Fix '$ARGUMENTS' based on diagnosis:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Error handling: Use {{patterns.errorHandling}}
  - Validation: Use {{patterns.validation}}
  - Constructor pattern: Match {{patterns.entityConstructors}}
  - Testing: Use {{testing.framework}} with {{testing.pattern}}

  ### IF NOT EXISTS (Adaptive Mode):
  Examine the file being fixed:
  1. Use Read to examine the buggy file
  2. Detect existing patterns:
     - Error handling approach in this file
     - Validation patterns used
     - Code style and conventions
  3. Maintain consistency with detected patterns

  ### IF NO PATTERNS DETECTED:
  Use simple, safe defaults (exceptions, guard clauses)

  IMPLEMENT:
  1. Root cause fix following project conventions
  2. Defensive programming additions
  3. Error handling consistent with project pattern

  CREATE TESTS:
  1. Regression test reproducing original bug
  2. Edge case tests around the fix
  3. Multi-tenant isolation test if applicable

  OUTPUT: Fixed code + comprehensive tests",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Code simplification",
  prompt="Simplify fix for '$ARGUMENTS':
  
  REVIEW: The implemented fix
  SIMPLIFY: Remove unnecessary complexity
  REFACTOR: Apply clean code principles
  
  OUTPUT: Cleaner, more maintainable solution",
  subagent_type="code-simplifier"
)

## Phase 3: Parallel Validation

## IMPORTANT: dotnet Command Usage

**NEVER use '--no-build' flag with dotnet commands.**

Always run:
- `dotnet build` - Ensures latest code is compiled
- `dotnet test` - Builds then tests (do NOT use --no-build)
- `dotnet run` - Builds then runs

The '--no-build' flag skips compilation and can cause:
- Tests running against stale code
- Missing compilation errors
- False test results

CORRECT: `dotnet test`
WRONG: `dotnet test --no-build`

@Bash(command="dotnet build --configuration Release", description="Build")
@Bash(command="dotnet test --filter Category!=Integration", description="Unit tests")
@Bash(command="dotnet test tests/{{ArchitectureTestProject}}", description="Architecture")

## ✅ Complete
Bug fixed with regression test. Update CHANGELOG.md under "### Fixed".