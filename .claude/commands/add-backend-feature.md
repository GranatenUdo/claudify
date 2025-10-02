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

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Constructors: Follow detected pattern {{patterns.entityConstructors}}
  - Properties: Use detected style {{naming.properties}}
  - Collections: Use detected types {{patterns.collectionProperties}}
  - Date fields: Use detected naming {{naming.dateFields}}
  - Error handling: Use detected approach {{patterns.errorHandling}}
  - Validation: Use detected pattern {{patterns.validation}}

  ### IF NOT EXISTS (Adaptive Mode):
  Actively examine 2-3 similar files:
  1. Use Glob to find relevant files:
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

  ### IF NO FILES FOUND (Empty Project):
  Use simple production-ready defaults:
  - Public parameterless constructors
  - Public { get; set; } properties
  - List<T> collections
  - CreatedAt/UpdatedAt date fields
  - Exception-based error handling

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

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Use detected testing patterns:
  - Framework: {{testing.framework}}
  - Pattern: {{testing.pattern}}
  - Mocking: {{testing.mockingLibrary}}

  ### IF NOT EXISTS (Adaptive Mode):
  Examine existing test files:
  1. Use Glob: **/*Tests/*.cs or **/*Test/*.cs
  2. Read 1-2 test files and detect:
     - Test framework (xUnit vs NUnit vs MSTest)
     - Assertion style (xUnit Assert vs FluentAssertions)
     - Mocking library (Moq vs NSubstitute)
     - Test naming pattern

  ### IF NO FILES FOUND:
  Use xUnit with AAA pattern and Moq (common defaults).

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

@Bash(command="dotnet build --configuration Release", description="Build")
@Bash(command="dotnet test --no-build", description="Test")
@Bash(command="cd src/{{WebProject}} && npm run update:api", description="Update client")

## ✅ Complete
Feature implemented with tests and security validation.