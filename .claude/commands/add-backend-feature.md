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
  
  CREATE:
  1. Entity with factory method, IOrganizationScoped, ISoftDeletable
  2. Repository interface + EF Core implementation
  3. Service with Result<T> pattern + caching
  4. REST controller with [Authorize]
  5. DTOs and migrations
  
  USE: C# 13 features, CLAUDE.md patterns
  OUTPUT: Complete working code",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Tests",
  prompt="Test coverage for '$ARGUMENTS':
  
  CREATE:
  1. Unit tests (services, domain logic)
  2. Integration tests (repositories, API)
  3. Multi-tenant isolation tests
  4. Edge cases and error scenarios
  
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
@Bash(command="dotnet test", description="Test")
@Bash(command="cd src/{{WebProject}} && npm run update:api", description="Update client")

## ✅ Complete
Feature implemented with tests and security validation.