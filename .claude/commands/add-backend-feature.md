---
description: Create backend API with parallel implementation
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Bash]
estimated-time: 2-3 minutes (parallel)
complexity: moderate
category: development
---

# 🚀 Backend Feature: $ARGUMENTS

## Phase 1: Parallel Design & Implementation (90 seconds)

@Task(
  description="Requirements & architecture",
  prompt="Analyze and design '$ARGUMENTS':
  
  DELIVER:
  1. Refined functional requirements
  2. Domain model design
  3. API contract specification
  4. Edge cases and validation rules
  
  OUTPUT: Complete technical specification",
  subagent_type="feature-scope-architect"
)

@Task(
  description="Implementation",
  prompt="Implement backend for '$ARGUMENTS':

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob to find 2-3 similar files:
     - Backend entities: **/*Domain*/Models/Entities/*.cs or **/Models/Entities/*.cs
     - Backend services: **/*Service.cs
  2. Read those files and detect:
     - Constructor patterns (parameterless vs parameterized)
     - Property patterns (public set vs private set)
     - Collection types (List<T> vs IReadOnlyList<T>)
     - Date naming conventions (CreatedAt vs CreatedDate)
     - Error handling approach (exceptions vs Result<T>)
     - Validation style (constructor vs FluentValidation)
  3. Apply the patterns you observed

  If no code files found, examine project configuration:
  1. Read .csproj files to check NuGet packages:
     - FluentValidation installed? Use FluentValidation pattern
     - LanguageExt.Core installed? Use Result<T> pattern
     - Otherwise: Exception-based error handling
  2. Check CLAUDE.md for specified patterns
  3. If still unclear, ask user:
     - "No existing code found. What patterns do you prefer?"
     - "Constructor style? [Parameterless/Parameterized/Factory]"
     - "Error handling? [Exceptions/Result<T>]"
     - "Validation? [Constructor/FluentValidation/DataAnnotations]"
  4. Use user's explicit choices

  ## Step 2: Generate Code

  CREATE:
  1. Entity class (following detected or default patterns)
  2. Repository interface + EF Core implementation
  3. Service class (following detected error handling pattern)
  4. REST API controller with [Authorize]
  5. Request/Response DTOs
  6. EF Core migration

  USE: C# 13 features, CLAUDE.md patterns
  OUTPUT: Complete working code",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Tests",
  prompt="Test coverage for '$ARGUMENTS':

  ## PATTERN DETECTION (REQUIRED)

  Examine existing test files:
  1. Use Glob: **/*Tests/*.cs or **/*Test/*.cs
  2. Read 1-2 test files and detect:
     - Test framework (xUnit vs NUnit vs MSTest)
     - Assertion style (xUnit Assert vs FluentAssertions)
     - Mocking library (Moq vs NSubstitute)
     - Test naming pattern
  3. Apply observed patterns

  If no test files found, examine project configuration:
  1. Read test .csproj files to check NuGet packages:
     - xunit.core installed? Use xUnit
     - NUnit installed? Use NUnit
     - MSTest installed? Use MSTest
     - FluentAssertions installed? Use FluentAssertions
     - Moq installed? Use Moq
     - NSubstitute installed? Use NSubstitute
  2. If no test packages installed, ask user:
     - "No test framework detected. Which do you want to use?"
     - "[1] xUnit with Moq [2] NUnit [3] MSTest [4] Other"
  3. Use user's choice

  CREATE:
  1. Unit tests (services, domain logic)
  2. Integration tests (repositories, API)
  3. Edge cases and error scenarios

  OUTPUT: 80%+ test coverage",
  subagent_type="test-quality-analyzer"
)

@Task(
  description="Security",
  prompt="Security audit '$ARGUMENTS':
  
  VERIFY:
  1. Organization scoping enforced
  2. No unauthorized data access
  3. Input validation complete
  4. No sensitive data exposure
  
  FIX: Any issues immediately
  OUTPUT: Security confirmation",
  subagent_type="security-vulnerability-scanner"
)

## Phase 2: Parallel Validation (30 seconds)

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
@Bash(command="dotnet test", description="Test")
@Bash(command="npm run update:api", description="Update client")

## ✅ Complete
Feature implemented with tests and security validation.

**Remember to update CHANGELOG.md under "### Added" section.**