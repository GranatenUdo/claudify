---
description: Parallel full-stack feature implementation with specialized agents
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Bash, Grep, Glob]
argument-hint: feature name and requirements (e.g., "user notifications with real-time updates")
complexity: moderate
estimated-time: 2 minutes (parallel execution)
category: development
---

# 🚀 Parallel Full-Stack Feature: $ARGUMENTS

## Phase 1: Parallel Architecture & Design (30 seconds)

### 🏗️ Tech Lead - Architecture Design
@Task(
  description="Design feature architecture",
  prompt="Design architecture for '$ARGUMENTS':
  DELIVER: Domain model, service contracts, API design, database schema
  OUTPUT: Entity properties, API endpoints (REST), service signatures, DTOs
  Keep it MVP - simplest thing that works.",
  subagent_type="tech-lead"
)

### 🔒 Security Reviewer - Security Requirements
@Task(
  description="Define security requirements",
  prompt="Define security for '$ARGUMENTS':
  ANALYZE: Multi-tenant isolation, authorization, validation, audit needs
  OUTPUT: Required auth attributes, org scoping approach, sensitive data handling
  Focus on preventing actual exploits.",
  subagent_type="security-reviewer"
)

### 🎨 UX Reviewer - UI/UX Requirements
@Task(
  description="Define UX requirements",
  prompt="Design UX for '$ARGUMENTS':
  MAP: User workflows, error handling, loading states, mobile needs
  OUTPUT: Component hierarchy, key interactions, validations, feedback patterns
  Simple and intuitive wins.",
  subagent_type="ux-reviewer"
)

## Phase 2: Parallel Implementation (60 seconds)

### 💻 Backend Developer - API Implementation
@Task(
  description="Implement backend API",
  prompt="Implement backend for '$ARGUMENTS' using C# 13/.NET 9:
  
  CREATE:
  1. Entity with factory method and IOrganizationScoped
  2. Repository with organization filtering
  3. Service with Result<T> pattern
  4. RESTful controller with proper HTTP semantics
  5. Integration test for multi-tenant isolation
  
  USE: Primary constructors, collection expressions, modern C# 13
  VALIDATE: Build compiles, tests pass, security enforced
  
  Generate complete working code with organization scoping.",
  subagent_type="tech-lead"
)

### 🎯 Frontend Developer - UI Implementation  
@Task(
  description="Implement frontend components",
  prompt="Implement Angular 19 frontend for '$ARGUMENTS':
  
  CREATE:
  1. Service with signals (NO Observables)
  2. List component with OnPush change detection
  3. Form component with reactive forms
  4. Templates with *ngIf/*ngFor (NOT @if/@for)
  5. Component tests with signal verification
  
  USE: signal(), computed(), async/await, Result<T>
  VALIDATE: Builds successfully, tests pass, responsive design
  
  Generate complete working Angular 19 code.",
  subagent_type="frontend-developer"
)

### 🧪 Test Engineer - Test Suite
@Task(
  description="Create test coverage",
  prompt="Create tests for '$ARGUMENTS':
  
  BACKEND: Service unit test, multi-tenant integration test, auth test
  FRONTEND: Service test with mocked API, component test, signal reactivity
  E2E: Happy path workflow, error handling
  
  USE: xUnit for .NET, Jasmine/Karma for Angular
  FOCUS: Business logic, not framework testing
  
  Generate executable test code.",
  subagent_type="test-quality-analyst"
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

## Phase 3: Parallel Final Checks (30 seconds)

### Build Verification
@Bash(command="dotnet build --no-restore", description="Backend build")
@Bash(command="cd src/{{WebProject}} && npm run build", description="Frontend build")
@Bash(command="dotnet test --no-build --filter Category!=Integration", description="Quick tests")

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

**Time**: 2 minutes (vs 15-20 sequential)
```

## 🎯 Why This Works
- **7 parallel agents** working simultaneously
- **No waiting** - all phases execute together
- **Specialized expertise** - each agent owns their domain
- **Validated output** - built-in quality checks

Remember: MVP that works > perfect that takes forever