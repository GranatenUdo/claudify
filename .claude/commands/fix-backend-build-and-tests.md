---
description: Fix backend build and test failures using Opus 4 extended thinking with iterative reflection and parallel operations
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "dependency injection errors in services" or leave empty for full diagnosis)
---

# 🧠 Fix Backend Build & Tests: $ARGUMENTS

## OPUS 4 ACTIVATION - ITERATIVE THINKING MODE
<think harder about C# compilation errors, test failures, and architectural issues. Focus on understanding domain requirements and business logic before implementing solutions>

**Directive**: Fix backend build and test failures through iterative analysis, parallel operations, and deep understanding of problem requirements. Tests verify correctness—they don't define the solution. Think deeply about the correct algorithm, domain logic, and architectural patterns.

## Phase 0: Multi-Agent Initial Analysis

### Code Architecture Assessment
I'll invoke the Code Reviewer agent for this analysis.

@Task(description="Code Reviewer analysis", prompt="Analyze backend build/test failures for "$ARGUMENTS":
1. Review compilation error patterns
2. Identify architectural violations
3. Check DDD pattern compliance
4. Analyze dependency issues
5. Review test failure patterns
6. Identify code quality issues
7. Assess technical debt impact
Provide categorized error analysis and fix priorities
", subagent_type="Code Reviewer")

### Security & Multi-Tenancy Check
I'll invoke the Security Reviewer agent for this analysis.

@Task(description="Security Reviewer analysis", prompt="Assess security implications of build/test failures:
1. Check for multi-tenant isolation violations
2. Review organization filtering issues
3. Identify authentication/authorization problems
4. Assess data leakage risks
5. Check for SQL injection vulnerabilities
6. Review secret management issues
7. Evaluate compliance impacts
Provide security-critical fixes that must be prioritized
", subagent_type="Security Reviewer")

## Phase 1: Initial Assessment & Parallel Discovery

<think step-by-step about what information we need to gather for .NET backend>

### Parallel Information Gathering
Execute these operations simultaneously for maximum efficiency:

```parallel
1. Check current build status:
   - dotnet build (capture full output)
   - Analyze compiler errors and warnings
   
2. Examine project configuration:
   - *.csproj files structure
   - Directory.Build.props settings
   - nuget.config dependencies
   
3. Test infrastructure check:
   - dotnet test (capture output)
   - xunit configuration
   - test project references
   
4. Recent changes analysis:
   - git log --oneline -20
   - git diff HEAD~5 (focus on .cs files)
   
5. Architecture verification:
   - Solution structure analysis
   - Project dependencies graph
```

### Initial Error Classification
<think about .NET/C# specific error categories>
- **Compilation Errors**: Syntax, types, namespaces, missing references
- **Dependency Issues**: NuGet conflicts, version mismatches, missing packages
- **DI Container**: Service registration, lifecycle mismatches, circular dependencies
- **EF Core Issues**: Migration conflicts, model changes, query problems
- **Test Failures**: Business logic, mocking issues, integration test database
- **Multi-tenant Violations**: Missing OrganizationId filters, data leaks

## Phase 2: Build Analysis & Iterative Fixing

### Step 1: Run Build & Deep Analysis
```bash
# Clean build with detailed verbosity
dotnet clean
dotnet build --verbosity detailed 2>&1 | tee build-output.log

# Parallel project builds if solution is large
dotnet build src/PTA.VineyardManagement.Api --no-dependencies &
dotnet build src/PTA.VineyardManagement.Domain --no-dependencies &
dotnet build src/PTA.VineyardManagement.Infrastructure --no-dependencies &
wait
```

<think harder about the build results and architectural implications>

### Step 1.5: Research Build Error Patterns
I'll invoke the Researcher agent for this analysis.

@Task(description="Researcher analysis", prompt="Research .NET build error patterns:
1. Analyze common C# 12/.NET 9 compilation issues
2. Research dependency conflict resolution strategies
3. Study EF Core 9 migration problems
4. Investigate multi-project solution issues
5. Research async/await pitfalls
6. Study DI container registration patterns
7. Find proven solutions for similar errors
Provide research-backed fix strategies
", subagent_type="Researcher")

### Step 2: Reflect on Build Results
After receiving build output, carefully analyze:
1. **Error Hierarchy**: Which errors are root causes vs. cascading?
2. **Architectural Violations**: DDD boundaries, clean architecture layers?
3. **Pattern Compliance**: Result<T>, Repository, Factory methods?
4. **Multi-tenant Security**: OrganizationId scoping present?

### Step 3: Confidence Check
**If confidence < 99% on any architectural decision:**
```csharp
// PAUSE: Need architectural clarification
throw new ArchitecturalClarificationNeeded($@"
⚠️ ARCHITECTURAL DECISION NEEDED:
I'm {confidence}% confident about: {assumption}

The error suggests: {errorContext}

Possible approaches:
1. {approach1} - Follows DDD pattern but {tradeoff1}
2. {approach2} - Simpler but violates {principle2}

Given the agricultural domain and multi-tenant requirements, which approach aligns with the system architecture?
");
```

### Step 3.5: Tech Lead Architecture Validation
I'll invoke the Tech Lead agent for this analysis.

@Task(description="Tech Lead analysis", prompt="Validate architectural approach for fixes:
1. Review DDD boundary adherence
2. Assess clean architecture compliance
3. Evaluate scalability implications
4. Check performance impact
5. Review technical debt introduced
6. Validate microservice boundaries
7. Assess deployment complexity
Provide architectural guidance and approval
", subagent_type="Tech Lead")

### Step 4: Implement Domain-Driven Fixes
<think about correct domain modeling and business logic, not just compilation fixes>

#### Domain Model Fix Pattern
```csharp
// ❌ WRONG: Fixing just to compile
public class Field
{
    public string Name { get; set; } = ""; // Just to avoid null warning
    
    public decimal CalculateYield()
    {
        return 0; // Makes test pass but meaningless
    }
}

// ✅ CORRECT: Understanding domain requirements first
public class Field : AggregateRoot, IOrganizationScoped
{
    <think: What are the business invariants for a field?>
    
    private Field() { } // EF Core constructor
    
    // Factory method enforces invariants
    public static Result<Field> Create(
        Guid organizationId,
        string name,
        decimal areaHectares,
        Geometry boundaries)
    {
        // Domain validation based on agricultural requirements
        if (string.IsNullOrWhiteSpace(name))
            return Result<Field>.Failure("Field must have a name");
            
        if (areaHectares <= 0)
            return Result<Field>.Failure("Field area must be positive");
            
        if (areaHectares > 10000) // Business constraint
            return Result<Field>.Failure("Single field cannot exceed 10,000 hectares");
            
        if (!IsValidFieldBoundary(boundaries))
            return Result<Field>.Failure("Field boundaries must be a valid polygon");
            
        return Result<Field>.Success(new Field
        {
            Id = Guid.NewGuid(),
            OrganizationId = organizationId,
            Name = name.Trim(),
            AreaHectares = areaHectares,
            Boundaries = boundaries,
            CreatedAt = DateTime.UtcNow
        });
    }
    
    // Business logic based on agricultural science
    public Result<decimal> CalculateExpectedYield(
        CropType cropType,
        SoilQuality soilQuality,
        WeatherData historicalWeather)
    {
        <think: What factors truly affect crop yield?>
        
        if (!IsPlantable)
            return Result<decimal>.Failure("Field is not in plantable state");
            
        var baseYield = cropType.GetBaseYieldPerHectare(soilQuality);
        var weatherAdjustment = CalculateWeatherImpact(historicalWeather);
        var sizeEfficiency = CalculateSizeEfficiency(AreaHectares);
        
        var expectedYield = baseYield * AreaHectares * weatherAdjustment * sizeEfficiency;
        
        return Result<decimal>.Success(Math.Round(expectedYield, 2));
    }
}
```

### Step 5: Parallel Fix Implementation
```parallel
Fix Group A: Domain Layer
- Fix entity invariants
- Implement value objects
- Resolve aggregate boundaries

Fix Group B: Application Layer
- Fix service interfaces
- Implement Result<T> pattern
- Add validation logic

Fix Group C: Infrastructure Layer
- Fix repository implementations
- Resolve EF Core mappings
- Update database migrations

Fix Group D: API Layer
- Fix controller actions
- Update DTOs and mappings
- Resolve DI registrations
```

### Step 6: Multi-Tenant Security Verification
<think harder about organization isolation>

```csharp
// Every repository query MUST filter by OrganizationId
public async Task<IEnumerable<Field>> GetFieldsAsync(Guid organizationId)
{
    <think: Is this query properly scoped? Can it leak data?>
    
    return await _context.Fields
        .Where(f => f.OrganizationId == organizationId) // CRITICAL
        .Where(f => !f.IsDeleted)
        .OrderBy(f => f.Name)
        .ToListAsync();
}
```

## Phase 3: Test Analysis & Iterative Fixing

### Step 1: Run Tests with Detailed Output
```bash
# Run all tests with detailed output
dotnet test --verbosity detailed --logger "console;verbosity=detailed" 2>&1 | tee test-output.log

# Run test categories in parallel for faster feedback
dotnet test --filter "Category=Unit" &
dotnet test --filter "Category=Integration" &
wait
```

### Step 1.5: Domain Logic Analysis
I'll invoke the Researcher agent for this analysis.

@Task(description="Researcher analysis", prompt="Analyze domain logic in failing tests:
1. Research agricultural business rules
2. Study vineyard management best practices
3. Understand crop lifecycle requirements
4. Research yield calculation formulas
5. Study irrigation science principles
6. Analyze harvest optimization strategies
7. Research compliance requirements
Provide domain-correct implementations
", subagent_type="Researcher")

### Step 2: Deep Test Failure Analysis
<think harder about why tests fail in agricultural domain context>

#### Test Failure Categories
1. **Business Logic Errors**: Domain rules not correctly implemented
2. **Multi-Tenant Violations**: Tests not respecting organization boundaries
3. **Transaction Failures**: Unit of work pattern issues
4. **Caching Issues**: Stale data after mutations
5. **Async/Await Problems**: Deadlocks, race conditions
6. **Mock Inadequacies**: Mocks don't reflect production behavior

### Step 3: Understanding Business Requirements
```csharp
[Fact]
public async Task Field_Should_Calculate_Irrigation_Needs_Based_On_Crop_And_Weather()
{
    <think: This isn't just about making test pass - it's about agricultural science>
    
    // Arrange - Understand the domain
    var field = Field.Create(orgId, "North Field", 50m, validGeometry).Value;
    var crop = CropType.Grapes; // Different water needs than wheat
    var currentMoisture = 0.3m; // 30% soil moisture
    var weatherForecast = new WeatherData 
    { 
        ExpectedRainfall = 5m, // mm in next week
        EvapotranspirationRate = 4.5m // mm/day
    };
    
    // Act - Implement based on agricultural knowledge
    var irrigationNeeds = field.CalculateIrrigationNeeds(
        crop, 
        currentMoisture, 
        weatherForecast);
    
    // Assert - Verify against agricultural standards
    irrigationNeeds.Value.Should().BeApproximately(
        expectedBasedOnFAOGuidelines, 
        precision: 0.1m);
}
```

### Step 4: Fix Architectural Test Issues
<think about clean architecture and DDD principles>

```csharp
// Common architectural test failures and fixes

// ❌ WRONG: Service depending on infrastructure
public class FieldService
{
    private readonly ApplicationDbContext _context; // Direct DB dependency
}

// ✅ CORRECT: Service depends on abstraction
public class FieldService : IFieldService
{
    private readonly IFieldRepository _repository;
    private readonly IUnitOfWork _unitOfWork;
    
    // Service orchestrates domain logic, doesn't know about DB
}

// ❌ WRONG: Anemic domain model
public class Field
{
    public decimal Area { get; set; }
    // Logic in service instead of entity
}

// ✅ CORRECT: Rich domain model
public class Field : AggregateRoot
{
    public Result<FieldUsage> PlantCrop(CropType crop, DateTime plantingDate)
    {
        // Business logic in entity where it belongs
        if (!CanPlantCrop(crop, plantingDate))
            return Result<FieldUsage>.Failure(GetPlantingFailureReason(crop, plantingDate));
            
        var usage = FieldUsage.Create(this, crop, plantingDate);
        _usages.Add(usage);
        
        AddDomainEvent(new CropPlantedEvent(Id, crop, plantingDate));
        return Result<FieldUsage>.Success(usage);
    }
}
```

### Step 5: Integration Test Database Issues
```bash
# Ensure test database is properly initialized
dotnet ef database update --project src/PTA.VineyardManagement.Infrastructure --startup-project src/PTA.VineyardManagement.Api --context ApplicationDbContext

# Run integration tests with fresh database
dotnet test tests/PTA.VineyardManagement.IntegrationTests
```

## Phase 4: Comprehensive Verification

### Parallel Final Validation
```parallel
1. Clean rebuild:
   dotnet clean
   dotnet build --configuration Release

2. All tests with coverage:
   dotnet test --collect:"XPlat Code Coverage" --results-directory ./TestResults

3. Code analysis:
   dotnet build --no-incremental /p:RunAnalyzers=true

4. Architecture tests:
   dotnet test tests/PTA.VineyardManagement.ArchitectureTests
```

### Performance & Security Validation
<think about production implications>

```csharp
// Verify no N+1 queries
[Fact]
public async Task Repository_Should_Not_Have_N_Plus_One_Queries()
{
    // Arrange
    using var context = CreateContext();
    var repository = new FieldRepository(context);
    
    // Act
    var fields = await repository.GetFieldsWithCropsAsync(organizationId);
    
    // Assert - Should be 1 query, not 1 + N
    context.QueryLog.Count.Should().Be(1);
}

// Verify multi-tenant isolation
[Fact]
public async Task Service_Should_Never_Return_Data_From_Other_Organizations()
{
    // This test MUST pass or we have a critical security issue
}
```

## Phase 5: Documentation & Prevention

### Code Simplification Review
I'll invoke the Code Simplifier agent for this analysis.

@Task(description="Code Simplifier analysis", prompt="Identify simplification opportunities in fixes:
1. Over-engineered solutions
2. Complex dependency graphs
3. Redundant abstractions
4. Unnecessary async complexity
5. Over-complicated test setups
6. Pattern misapplications
7. Consolidation opportunities
Provide simpler alternatives where appropriate
", subagent_type="Code Simplifier")

### Document Root Causes & Solutions
```markdown
## Backend Build/Test Fix Summary

### Agent Analysis Summary

#### Code Reviewer Findings
- **Error Categories**: [List main categories]
- **Pattern Violations**: [DDD/Clean Architecture issues]
- **Technical Debt**: [Amount addressed/added]

#### Security Reviewer Assessment
- **Critical Issues**: [Multi-tenant violations found]
- **Risk Level**: [Low/Medium/High/Critical]
- **Compliance Impact**: [Any compliance issues]

#### Tech Lead Evaluation
- **Architecture Alignment**: [Score]
- **Scalability Impact**: [Assessment]
- **Performance Delta**: [Metrics]

#### Researcher Insights
- **Domain Logic Corrections**: [Agricultural rules applied]
- **Best Practices**: [Industry standards implemented]
- **Similar Issues**: [Count] found in research

### Root Cause Analysis
1. **Primary Issue**: [Core architectural or domain logic problem]
2. **Security Implications**: [Any multi-tenant isolation issues found]
3. **Performance Impact**: [Query optimization needs identified]

### Solutions Applied
1. **Domain Fixes**: [How domain model was corrected]
2. **Architecture Fixes**: [Layer separation improvements]
3. **Security Fixes**: [Organization scoping enforcement]

### Prevention Measures
- [ ] Architecture tests to enforce layer dependencies
- [ ] Code analyzers for Result<T> pattern usage
- [ ] Multi-tenant security analyzer rule
- [ ] Domain model validation tests
```

## Phase 6: Final Confidence Validation

### Architectural Confidence Check
<think: Am I 99% certain these fixes maintain architectural integrity?>

If confidence < 99% on any architectural decision:
```csharp
throw new ArchitecturalValidationRequired($@"
🏗️ ARCHITECTURAL VALIDATION NEEDED:

I've fixed {issueCount} issues, but I'm only {confidence}% confident about:

Area: {uncertainArea}
Current Implementation: {currentApproach}
Concern: {architecturalConcern}

This could impact:
- Domain model integrity: {domainImpact}
- Multi-tenant security: {securityImpact}
- Performance at scale: {performanceImpact}

Should I proceed or would you like to review the architectural approach?
");
```

## Success Criteria

### Build Success Indicators
- ✅ `dotnet build` succeeds with 0 errors, 0 warnings
- ✅ All projects in solution build successfully
- ✅ No compiler warnings about nullability
- ✅ Code analysis passes without violations

### Test Success Indicators
- ✅ All unit tests pass (100% success)
- ✅ All integration tests pass
- ✅ Architecture tests verify layer dependencies
- ✅ Code coverage ≥ 80% for business logic
- ✅ No flaky tests (run 3x successfully)

### Domain & Security Validation
- ✅ All entities use factory methods
- ✅ All services return Result<T>
- ✅ All queries filter by OrganizationId
- ✅ No direct database access outside repositories
- ✅ Rich domain model (logic in entities)

## Phase 6: Final Multi-Agent Validation

I'll invoke the general-purpose agent for this analysis.

@Task(description="general-purpose analysis", prompt="Perform final validation of all fixes:
1. Consolidate all agent findings
2. Verify all critical issues addressed
3. Confirm architectural integrity
4. Validate security compliance
5. Check performance benchmarks
6. Review test coverage
7. Generate deployment readiness report
Provide go/no-go recommendation
", subagent_type="general-purpose")

## Opus 4 Thinking Patterns with Multi-Agent Enhancement

Throughout this process:
1. **Understand Domain First**: Agricultural requirements drive implementation (validated by Researcher)
2. **Parallel Everything Possible**: Maximize efficiency with concurrent operations
3. **Iterate Based on Compiler/Test Feedback**: Each result refines approach
4. **Verify Architectural Decisions**: When <99% confident, seek validation (Tech Lead confirms)
5. **Solve Business Problems**: Implement correct algorithms, not test-satisfying hacks
6. **Security is Non-Negotiable**: Multi-tenant isolation must be perfect (Security Reviewer validates)
7. **Multi-Agent Validation**: Each fix reviewed by specialized agents for comprehensive quality

## Benefits of Multi-Agent Backend Fix Approach

1. **Comprehensive Analysis**: Code, security, architecture, and domain perspectives
2. **Faster Resolution**: Parallel agent investigation speeds diagnosis
3. **Higher Quality**: Multiple specialized reviews ensure robust fixes
4. **Domain Accuracy**: Researcher ensures agricultural correctness
5. **Security Assurance**: Security Reviewer catches critical vulnerabilities
6. **Architectural Integrity**: Tech Lead maintains system design principles
7. **Simplified Solutions**: Code Simplifier prevents over-engineering

Remember: In agricultural SaaS, downtime during harvest season is catastrophic. Every fix must maintain production stability while solving the root cause. Tests verify our domain logic is correct—they don't define what correct means in agriculture. Multi-agent collaboration ensures we achieve both technical excellence and domain correctness.


## Documentation Updates

<think about what documentation needs updating based on the changes made>

### Update Checklist
Based on the changes made, update these files:

1. **CHANGELOG.md** (Confidence: 95%)
   - Add entry under `[Unreleased]` section
   - Use appropriate section: Added/Changed/Fixed/Removed
   - Include technical details and user impact

2. **FEATURES.md** (If capabilities changed)
   - Document new or modified features
   - Update technical implementation details
   - Include usage examples

3. **CLAUDE.md** (If patterns/conventions introduced)
   - Document new code patterns
   - Update architectural decisions
   - Add domain-specific rules

### Quick Update Commands
```bash
# Automated changelog update
/update-changelog "$ARGUMENTS"

# Manual update template
### [Section]
- Description of change
  - Technical implementation details
  - User-facing impact
  - Breaking changes (if any)
```

### Parallel Documentation Check
Check all documentation files simultaneously for existing references:
```bash
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```