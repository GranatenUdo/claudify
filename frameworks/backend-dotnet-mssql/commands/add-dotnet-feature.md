---
description: Create backend API feature with domain-driven design and comprehensive agent analysis
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature description (e.g., "harvest scheduling with weather integration")
agent-dependencies: [Tech Lead, Researcher, Security Reviewer, Code Reviewer]
complexity: moderate
estimated-time: 15-20 minutes (reduced from 30 with parallel execution)
category: development
---

# 🏗️ Add Backend Feature: $ARGUMENTS

## Quick Context
Create a new backend feature with proper domain modeling, security validation, and test coverage following DDD principles and production standards.

## Execution Flow
1. **Security & Architecture Planning** - Early validation with specialized agents
2. **Domain Analysis** - Research and model the business domain
3. **Implementation** - Build layers systematically (Entity → Repository → Service → API)
4. **Quality Assurance** - Testing, review, and documentation

## Phase 0: Task Management Setup

### 📋 TodoWrite Task Management
<think step-by-step about organizing the backend feature development>

@TodoWrite(todos=[
  {id: "1", content: "Security and architecture planning", status: "in_progress", priority: "high"},
  {id: "2", content: "Domain research and modeling", status: "pending", priority: "high"},
  {id: "3", content: "Implement entity layer", status: "pending", priority: "high"},
  {id: "4", content: "Implement repository layer", status: "pending", priority: "high"},
  {id: "5", content: "Implement service layer", status: "pending", priority: "high"},
  {id: "6", content: "Implement API endpoints", status: "pending", priority: "high"},
  {id: "7", content: "Generate comprehensive tests", status: "pending", priority: "high"},
  {id: "8", content: "Quality assurance and review", status: "pending", priority: "high"}
])

### 📊 Agent Specialization Matrix

| Task Type | Primary Agent | Secondary Agents | Parallel? |
|-----------|---------------|------------------|----------|
| Architecture | Tech Lead | Security Reviewer | ✅ Yes |
| Domain Analysis | Researcher | Tech Lead | ✅ Yes |
| Implementation | - | Code Reviewer | ❌ No |
| Testing | Code Reviewer | Security Reviewer | ✅ Yes |

## Interactive Options
```yaml
include-tests: true|false (default: true)
api-versioning: v1|v2 (default: v1)
caching-strategy: none|read-through|write-behind (default: read-through)
real-time-updates: true|false (default: true)
```

## Phase 1: Security & Architecture Planning (OPTIMIZED)

<think harder about security implications and architectural fit>
<think step-by-step about parallel analysis opportunities>

### 🚀 Parallel Execution Pattern (40-60% Performance Gain)
```bash
# ✅ OPTIMAL: All discovery operations run in parallel
@Grep(pattern="Repository|Service|Controller", path="src/", output_mode="files_with_matches")
@Glob(pattern="**/Models/*.cs")
@Glob(pattern="**/DTOs/*.cs")
@Read(file_path="appsettings.json")
@Bash(command="dotnet list package", description="Check current dependencies")
```

### Combined Security & Architecture Analysis
I'll have multiple agents analyze in parallel for comprehensive coverage.

@Task(description="Security and architecture planning", prompt="As Tech Lead with security expertise, analyze requirements for $ARGUMENTS:

SECURITY REQUIREMENTS:
1. Identify sensitive data requiring protection
2. Define authorization model (role vs resource-based)
3. Specify multi-tenant isolation requirements
4. Review OWASP API Security Top 10 implications
5. Define audit trail requirements
6. Identify compliance needs (GDPR, agricultural regulations)
7. Specify data retention policies
8. Assess potential attack vectors

ARCHITECTURE PLANNING:
1. Assess fit within existing bounded contexts
2. Define aggregate boundaries
3. Review scalability for 10K+ organizations
4. Identify integration points
5. Evaluate caching strategies
6. Define transaction boundaries
7. Assess performance implications
8. Consider future extensibility

Provide integrated security and architecture blueprint with risk assessment and mitigation strategies.", subagent_type="general-purpose")
@Task(description="Security-specific analysis", prompt="Perform deep security analysis for $ARGUMENTS:
1. OWASP API Security Top 10 assessment
2. Multi-tenant isolation verification
3. Authentication/authorization requirements
4. Data encryption needs
5. Audit logging requirements
6. Input validation strategy
7. Rate limiting requirements
8. Security headers configuration
Provide security implementation checklist", subagent_type="general-purpose")

### Interactive Checkpoint
```markdown
## Architecture & Security Review Complete

**Security Classification**: [Low|Medium|High|Critical]
**Architectural Complexity**: [Simple|Moderate|Complex]
**Integration Points**: [Count] systems affected

Key Decisions:
1. [Decision 1]
2. [Decision 2]
3. [Decision 3]

Proceed with implementation? (yes/no/modify)
```

## Phase 2: Domain Research & Modeling

<think step-by-step about the agricultural domain and business invariants>
<think harder about domain complexity and edge cases>

### Task Progress Update
@TodoWrite(todos=[/* Update task 1 to completed, task 2 to in_progress */])

### Parallel Domain Research
@Task(description="Domain analysis", prompt="Research domain requirements for $ARGUMENTS:
1. Analyze similar features in codebase
2. Identify domain patterns and business rules
3. Study temporal patterns (seasonality, historical tracking)
4. Research agricultural best practices
5. Identify regulatory requirements
6. Analyze performance patterns in similar features
Provide domain model with relationships and invariants", subagent_type="general-purpose")

### Domain Model Design
Based on agent analysis, I'll design the domain model with:
- Factory methods for entity creation
- Business logic encapsulated in entities
- Value objects for complex types
- Domain events for integration

## Phase 3: Implementation

<think about building layers systematically with quality gates>
<think harder about implementation patterns and best practices>

### Task Progress Update
@TodoWrite(todos=[/* Update task 2 to completed, tasks 3-6 to track implementation */])

### Implementation Strategy

#### Parallel File Operations
```csharp
// ✅ Create all layer files in parallel
@Write(file_path="src/Domain/Entities/$FEATURE.cs", content="...")
@Write(file_path="src/Infrastructure/Repositories/$FEATURE_Repository.cs", content="...")
@Write(file_path="src/Application/Services/$FEATURE_Service.cs", content="...")
@Write(file_path="src/API/Controllers/$FEATURE_Controller.cs", content="...")
@Write(file_path="tests/UnitTests/$FEATURE_Tests.cs", content="...")
```

### Implementation Checklist
- [ ] **Entity Layer**: Domain model with factory methods
- [ ] **Database**: EF configuration and migrations  
- [ ] **Repository**: Interface and implementation
- [ ] **Service**: Business logic with Result<T> pattern
- [ ] **API**: RESTful controller with proper responses
- [ ] **DTOs**: Request/response models with validation
- [ ] **Caching**: Strategy implementation (cloud-native, no custom monitoring)
- [ ] **Real-time**: SignalR notifications (if enabled)
- [ ] **Tests**: Unit and integration coverage (100% success target)

### Progress Tracking
```markdown
## Implementation Progress

- [x] Phase 1: Security & Architecture - Complete
- [x] Phase 2: Domain Modeling - Complete
- [ ] Phase 3: Implementation - In Progress
  - [ ] Entity: 0%
  - [ ] Repository: 0%
  - [ ] Service: 0%
  - [ ] API: 0%
  - [ ] Tests: 0%
- [ ] Phase 4: Quality Assurance - Pending
```

### Key Implementation Patterns

#### Entity with Factory Method
```csharp
// Example structure - actual implementation based on domain analysis
public static Result<Entity> Create(Guid organizationId, /* parameters */)
{
    // Validation based on business rules from domain analysis
    // Return Result<Entity> with success or failure
}
```

#### Service with Result Pattern
```csharp
// Consistent error handling without exceptions
public async Task<Result<T>> OperationAsync(/* parameters */)
{
    // Transaction boundary
    // Business logic
    // Cache invalidation after success (cloud-native)
    // No performance monitoring - let cloud handle it
    // Return Result<T>
}
```

## Phase 4: Quality Assurance

<think harder about comprehensive testing and validation>

### Task Progress Update  
@TodoWrite(todos=[/* Update implementation tasks to completed, QA to in_progress */])

### Parallel Quality Checks
```bash
# Run all quality checks simultaneously
@Bash(command="dotnet test", description="Run all tests")
@Bash(command="dotnet build --no-restore", description="Verify build")
@Task(description="Code review", prompt="Review the implementation for best practices", subagent_type="general-purpose")
```

### Success Criteria
- ✅ All tests passing (100% success)
- ✅ Security validated
- ✅ Performance optimized (cloud-native)
- ✅ Documentation complete

### Final Task Completion
@TodoWrite(todos=[/* Mark all tasks as completed */])

## Phase 4: Quality Assurance

<think about comprehensive quality validation>

### Documentation Updates
1. **Update FEATURES.md** with the new feature details
2. **Update CHANGELOG.md** under [Unreleased] -> Added section:
   ```markdown
   ### Added
   - $ARGUMENTS feature implementation
     - Key technical details
     - API endpoints created
     - Database changes if any
   ```
3. Use `/update-changelog` command for automated changelog updates

### Automated Quality Checks
1. **Code Coverage**: Minimum 80% for business logic
2. **Security Scan**: No vulnerabilities detected
3. **Performance Test**: Response time < 200ms
4. **Integration Test**: All endpoints tested

### Comprehensive Code & Security Review (OPTIMIZED)
I'll have the Security Reviewer perform integrated code quality and security review.

@Task(description="Code quality and security review", prompt="As Security Reviewer with code quality expertise, comprehensively review $ARGUMENTS implementation:

CODE QUALITY ASSESSMENT:
1. DDD principles adherence
2. Result<T> pattern consistency
3. Repository pattern correctness
4. Transaction boundary management
5. Error handling completeness
6. Test coverage adequacy
7. Code clarity and maintainability
8. Performance optimization applied

SECURITY AUDIT:
1. Organization isolation in every query
2. Authorization implementation completeness
3. Input validation and sanitization
4. Audit trail coverage
5. Sensitive data handling
6. Secure error responses (no info leakage)
7. OWASP compliance verification
8. Rate limiting and abuse prevention

Provide integrated assessment with:
- Code quality score (0-100)
- Security risk rating (Low/Medium/High/Critical)
- Actionable improvements prioritized by impact
- Security certification status", subagent_type="general-purpose")

## Success Criteria

### Functional Requirements
- ✅ All user stories implemented
- ✅ Business rules enforced
- ✅ API endpoints functional
- ✅ Data persistence working

### Non-Functional Requirements
- ✅ Response time < 200ms (p95)
- ✅ 80%+ test coverage
- ✅ Zero security vulnerabilities
- ✅ Multi-tenant isolation verified
- ✅ Audit trail complete

### Code Quality
- ✅ Follows CLAUDE.md standards
- ✅ Result<T> pattern throughout
- ✅ Repository pattern for data access
- ✅ Proper transaction management
- ✅ Comprehensive error handling

### Documentation
- ✅ FEATURES.md updated
- ✅ CHANGELOG.md updated with new feature entry
- ✅ API documentation complete
- ✅ Test scenarios documented
- ✅ Runbook for operations

## Error Handling

### Common Issues & Solutions

| Issue | Solution | Prevention |
|-------|----------|------------|
| Missing OrganizationId | Add to all queries | Code analyzer rule |
| N+1 Queries | Use Include() | Performance tests |
| Cache Inconsistency | Invalidate after write | Transaction pattern |
| Security Vulnerability | Follow OWASP | Security review |

## Final Checklist

### Pre-Deployment
- [ ] All tests passing
- [ ] Security review approved
- [ ] Performance benchmarks met
- [ ] Documentation complete
- [ ] Code review addressed
- [ ] Feature flag configured (if needed)

### Post-Deployment
- [ ] Monitor error rates
- [ ] Check performance metrics
- [ ] Verify multi-tenant isolation
- [ ] Review audit logs
- [ ] Gather user feedback

## Summary Report

Upon completion, you'll receive:
- Implementation summary with key decisions
- Test coverage report
- Performance benchmark results
- Security audit findings
- Documentation links
- Next steps and recommendations