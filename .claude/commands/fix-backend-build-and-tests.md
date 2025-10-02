---
description: Fix backend build and test failures with parallel diagnosis
allowed-tools: [Task, Bash, Grep, Read, Edit, MultiEdit]
argument-hint: error message or test failure description
complexity: simple
estimated-time: 2.5 minutes
category: quality
---

# 🔧 Fix Backend Build & Tests: $ARGUMENTS

## Phase 1: Parallel Diagnosis (30 seconds)

### 🔨 Build Error Analyzer
@Task(
  description="Analyze build errors",
  prompt="Analyze build errors for '$ARGUMENTS':
  
  CHECK:
  1. Compilation errors: Nullable refs, syntax, missing usings
  2. Package issues: Missing, version conflicts, restore needed
  3. Project references: Broken refs, circular deps
  4. C# 13 issues: Primary constructors, collection expressions
  
  Return: Specific build issues found",
  subagent_type="tech-lead-engineer"
)

### 🧪 Test Failure Analyzer
@Task(
  description="Analyze test failures",
  prompt="Analyze test failures for '$ARGUMENTS':
  
  CHECK:
  1. Mock setup: Missing mocks, incorrect returns
  2. Async issues: Missing await, deadlocks
  3. Organization scoping: Test org context
  4. Database: In-memory DB setup, migrations
  
  Return: Test failure patterns found",
  subagent_type="test-quality-analyzer"
)

### 🗄️ Migration Checker
@Task(
  description="Check EF migrations",
  prompt="Check migration status for '$ARGUMENTS':
  
  CHECK:
  1. Pending migrations
  2. Model changes without migrations
  3. Migration conflicts
  4. Database connection issues
  
  Run: dotnet ef migrations list
  Return: Migration issues if any",
  subagent_type="infrastructure-architect"
)

## Phase 2: Parallel Fix Implementation (90 seconds)

### 🛠️ Compilation Fixer
@Task(
  description="Fix compilation errors",
  prompt="Fix compilation issues found:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Read to check the compilation error files
  2. Maintain existing code style and patterns

  If no patterns detected, examine project configuration:
  1. Read .csproj files to check dependencies
  2. Check CLAUDE.md for specified patterns
  3. If still unclear, ask user:
     - "What coding patterns should I follow for this fix?"
  4. Use user's explicit choice or minimal safe fixes

  COMMON FIXES:
  1. Nullable: Add ? or ! operators, null checks
  2. C# 13: Fix primary constructors, use [...] for collections
  3. Packages: Run dotnet restore, update versions
  4. Usings: Add missing using statements

  Apply minimal fixes for compilation.
  Generate working code changes.",
  subagent_type="tech-lead-engineer"
)

### ✅ Test Fixer
@Task(
  description="Fix test failures",
  prompt="Fix test failures found:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob: **/*Tests/*.cs
  2. Read a working test to detect patterns
  3. Apply same patterns to fix

  If no patterns detected, examine project configuration:
  1. Read test .csproj files to check test frameworks:
     - xunit installed? Use xUnit patterns
     - nunit installed? Use NUnit patterns
     - MSTest.TestFramework? Use MSTest patterns
     - Moq installed? Use Moq for mocking
     - NSubstitute installed? Use NSubstitute
     - FluentAssertions installed? Use for assertions
  2. Check CLAUDE.md for specified test patterns
  3. If still unclear, ask user:
     - "What test framework and mocking library?"
     - "Options: xUnit+Moq, NUnit+NSubstitute, etc."
  4. Use user's explicit choice

  COMMON FIXES:
  1. Mocks: Setup all required mocks with returns
  2. Async: Add async/await, ConfigureAwait(false)
  3. Org context: Set test OrganizationId
  4. Database: Use in-memory database for tests

  Fix failing tests with minimal changes.
  Generate working test fixes.",
  subagent_type="test-quality-analyzer"
)

### 🐳 Docker Fixer
@Task(
  description="Fix Docker build",
  prompt="Fix Docker build issues:
  
  CHECK & FIX:
  1. Base image: Use mcr.microsoft.com/dotnet/sdk:9.0
  2. File copying: Ensure all files copied
  3. Restore: Run before build
  4. Multi-stage: Optimize for size
  
  Generate working Dockerfile if needed.",
  subagent_type="infrastructure-architect"
)

## Phase 3: Parallel Validation (30 seconds)

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

### Full Validation Suite
@Bash(command="dotnet restore --no-cache", description="Package restore")
@Bash(command="dotnet build", description="Build verification")
@Bash(command="dotnet test --filter Category!=Integration", description="Unit tests")
@Bash(command="docker build -t test-backend . 2>&1 | tail -10", description="Docker build")

## Quick Reference

```markdown
## Fix Priority
1. Restore packages → Build → Test → Docker
2. Fix compilation before tests
3. Fix nullable refs with ? or !
4. Mock all dependencies in tests

## Common Commands
dotnet restore
dotnet clean && dotnet build
dotnet ef database update
dotnet nuget locals all --clear
```

## ✅ Success Criteria
- [ ] Build passes without warnings
- [ ] All unit tests pass
- [ ] Docker builds successfully
- [ ] Migrations up to date
- [ ] No nullable warnings

## 🎯 Why This Works
- **Parallel diagnosis** - 3 analyzers work simultaneously
- **Targeted fixes** - Each agent fixes specific issues
- **Fast validation** - All checks run in parallel
- **No guesswork** - Agents identify patterns

Remember: Most build failures are package or nullable issues!