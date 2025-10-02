---
description: Parallel full-stack feature implementation with specialized agents
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob]
argument-hint: feature name and requirements (e.g., "user notifications with real-time updates")
---

# 🚀 Parallel Full-Stack Feature: $ARGUMENTS

**For complex features or unfamiliar domains, enable extended thinking for comprehensive architecture design.**

## Phase 1: Parallel Architecture & Design

### 🏗️ Tech Lead - Architecture Design
@Task(
  description="Design feature architecture",
  prompt="Design architecture for '$ARGUMENTS':
  DELIVER: Domain model, service contracts, API design, database schema
  OUTPUT: Entity properties, API endpoints (REST), service signatures, DTOs
  Keep it MVP - simplest thing that works.",
  subagent_type="tech-lead-engineer"
)

### 🔒 Security Reviewer - Security Requirements
@Task(
  description="Define security requirements",
  prompt="Define security for '$ARGUMENTS':
  ANALYZE: Multi-tenant isolation, authorization, validation, audit needs
  OUTPUT: Required auth attributes, org scoping approach, sensitive data handling
  Focus on preventing actual exploits.",
  subagent_type="security-vulnerability-scanner"
)

### 🎨 UX Reviewer - UI/UX Requirements
@Task(
  description="Define UX requirements",
  prompt="Design UX for '$ARGUMENTS':
  MAP: User workflows, error handling, loading states, mobile needs
  OUTPUT: Component hierarchy, key interactions, validations, feedback patterns
  Simple and intuitive wins.",
  subagent_type="ux-design-expert"
)

## Phase 2: Parallel Implementation

### 💻 Backend Developer - API Implementation
@Task(
  description="Implement backend API",
  prompt="Implement backend for '$ARGUMENTS' using C# 13/.NET 9:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob to find 2-3 similar files:
     - Entities: **/*Domain*/Models/Entities/*.cs or **/Models/Entities/*.cs
     - Services: **/*Service.cs
  2. Read those files and detect:
     - Constructor patterns
     - Property patterns
     - Collection types
     - Date naming conventions
     - Error handling approach
     - Validation style
  3. Apply the patterns you observed

  If no code files found, examine project configuration:
  1. Read .csproj files to check installed packages:
     - FluentValidation installed? Use for validation
     - LanguageExt.Core installed? Use Result<T> patterns
     - AutoMapper installed? Use for mapping
     - MediatR installed? Use for CQRS pattern
  2. Check CLAUDE.md for specified patterns
  3. If still unclear, ask user:
     - "No existing backend code found. What patterns to use?"
     - "Options: Exceptions vs Result<T>, FluentValidation vs DataAnnotations"
  4. Use user's explicit choice

  CREATE:
  1. Entity class (following detected patterns)
  2. Repository interface + implementation
  3. Service class (following detected error handling)
  4. RESTful controller with [Authorize]
  5. Integration tests

  USE: Primary constructors, collection expressions, modern C# 13
  VALIDATE: Build compiles, tests pass

  Generate complete working code.",
  subagent_type="tech-lead-engineer"
)

### 🎯 Frontend Developer - UI Implementation
@Task(
  description="Implement frontend components",
  prompt="Implement Angular frontend for '$ARGUMENTS':

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob to find 2-3 similar files:
     - Components: **/src/app/**/*.component.ts
     - Services: **/src/app/**/*.service.ts
  2. Read those files and detect:
     - Signal usage vs observables
     - Change detection strategy
     - Template syntax (*ngIf vs @if)
     - Service patterns
     - Error handling approach
     - State management pattern
  3. Apply the patterns you observed

  If no code files found, examine project configuration:
  1. Read package.json to check Angular version:
     - @angular/core version 18+? Use signals and @if/@for
     - @angular/core version <18? Use observables and *ngIf
     - ngrx or akita installed? Use that state management
  2. Check angular.json for project defaults
  3. Check CLAUDE.md for specified patterns
  4. If still unclear, ask user:
     - "No existing frontend code found. What patterns to use?"
     - "Options: Signals vs Observables, OnPush vs Default"
  5. Use user's explicit choice

  CREATE:
  1. Service(s) with appropriate state management
  2. Component(s) with proper change detection
  3. Template(s) with responsive design
  4. Component tests

  USE: Modern Angular features, TypeScript
  VALIDATE: Builds successfully, tests pass

  Generate complete working Angular code.",
  subagent_type="frontend-implementation-expert"
)

### 🧪 Test Engineer - Test Suite
@Task(
  description="Create test coverage",
  prompt="Create tests for '$ARGUMENTS':

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob to find test files:
     - Backend: **/*Tests/*.cs or **/*Test/*.cs
     - Frontend: **/*.spec.ts or **/*.test.ts
  2. Read 1-2 test files and detect:
     - Test framework and assertion style
     - Mocking approach
     - Test naming patterns

  If no test files found, examine project configuration:
  1. Backend: Read test .csproj files for frameworks:
     - xunit? Use xUnit patterns
     - nunit? Use NUnit patterns
     - Moq? Use Moq for mocking
     - NSubstitute? Use NSubstitute
  2. Frontend: Read package.json for test frameworks:
     - jest? Use Jest patterns
     - jasmine-core? Use Jasmine patterns
  3. Check CLAUDE.md for specified test patterns
  4. If still unclear, ask user:
     - "No existing tests found. What test frameworks to use?"
     - "Options: xUnit+Moq, NUnit+NSubstitute, Jest, Jasmine"
  5. Use user's explicit choice

  BACKEND: Service unit test, integration test, auth test
  FRONTEND: Service test with mocked API, component test
  E2E: Happy path workflow, error handling

  FOCUS: Business logic, not framework testing

  Generate executable test code.",
  subagent_type="test-quality-analyzer"
)

### 🚀 Integration Validator
@Task(
  description="Validate full integration",
  prompt="Validate '$ARGUMENTS' integration:
  
  CHECK:
  1. Backend builds and tests pass
  2. Frontend builds without errors
  3. API contract matches frontend
  4. Database migrations valid
  5. Security requirements met
  
  PREPARE:
  1. Migration script if needed
  2. Environment config updates
  3. Feature flag setup
  
  Report issues and deployment readiness.",
  subagent_type="infrastructure-architect"
)

## Phase 3: Parallel Final Checks

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

### Build Verification
@Bash(command="dotnet build", description="Backend build")
@Bash(command="npm run build", description="Frontend build")
@Bash(command="dotnet test --filter Category!=Integration", description="Quick tests")

## Summary Output

```markdown
# ✅ Feature Implemented: $ARGUMENTS

## Components Created
**Backend**: Entity, Repository, Service, Controller, DTOs
**Frontend**: Service (signals), List/Form components  
**Tests**: Unit, Integration, Component tests
**Security**: Organization scoping, authorization

## Next Steps
1. Run full test suite
2. Review in staging
3. Create PR

**Approach**: Parallel execution across all layers
```

## 🎯 Why This Works
- **Multiple parallel agents** working simultaneously
- **No waiting** - all phases execute together
- **Specialized expertise** - each agent owns their domain
- **Validated output** - built-in quality checks

Remember: MVP that works > perfect that takes forever

**Remember to update CHANGELOG.md under "### Added" section.**