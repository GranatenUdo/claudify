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

### Full Validation Suite
@Bash(command="dotnet restore --no-cache", description="Package restore")
@Bash(command="dotnet build --no-restore", description="Build verification")
@Bash(command="dotnet test --no-build --filter Category!=Integration", description="Unit tests")
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