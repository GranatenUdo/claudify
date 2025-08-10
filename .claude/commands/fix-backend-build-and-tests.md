---
name: fix-backend-build-and-tests
think-mode: think_harder
execution-mode: iterative-per-file
verification-strategy: immediate
rollback-enabled: true
description: Fix backend build and test failures using iterative file-by-file approach with immediate verification after each fix
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "dependency injection errors in services" or leave empty for full diagnosis)
---

# 🔄 Fix Backend Build & Tests (Iterative): $ARGUMENTS

## 🚀 Optimization Features

### Iterative File-by-File Execution
- **Single File Focus**: Fix all errors in one file before moving to next
- **Immediate Verification**: Build/test after each file fix to validate changes
- **Checkpoint & Rollback**: Git stash checkpoint before each file for safe rollback
- **Progress Tracking**: Real-time visibility with TodoWrite task management
- **Smart Fix Ordering**: Domain → Services → Controllers for minimal cascading

### Extended Thinking Integration
- **Deep Domain Analysis**: Complex agricultural business logic reasoning using think_harder mode for accurate implementations
- **Architectural Decision Making**: Extended thinking for DDD patterns, clean architecture compliance, and multi-tenant security
- **Root Cause Investigation**: Sophisticated reasoning to identify cascading error patterns and architectural violations
- **Solution Validation**: 99% confidence threshold for architectural decisions with extended verification reasoning

### Confidence Scoring
- **Fix Quality Assessment**: Quantified confidence in solution correctness and architectural integrity
- **Security Validation**: Confidence scoring for multi-tenant isolation and OWASP compliance fixes
- **Performance Impact**: Scored assessment of fix impact on scalability and production performance
- **Domain Logic Accuracy**: Agricultural expertise validation with confidence metrics for business rule implementations

### Subagent Coordination
- **Code Reviewer Leadership**: Primary architectural analysis with specialized agent support
- **Security Focus**: Security Reviewer ensures multi-tenant isolation and vulnerability remediation
- **Tech Lead Oversight**: Architecture validation and scalability impact assessment
- **Research Support**: Domain expertise for accurate agricultural business logic implementation
- **Iterative Validation**: Continuous verification loops with agent consensus on critical fixes

**Directive**: Fix backend build and test failures through iterative analysis, parallel operations, and deep understanding of problem requirements. Tests verify correctness—they don't define the solution. Think deeply about the correct algorithm, domain logic, and architectural patterns.

## Phase 0: Multi-Agent Initial Analysis

### Code Architecture Assessment
I'll invoke the Code Reviewer
 agent for this analysis.

I'll have the Code Reviewer
 agent Code Reviewer
 analysis.

### Security & Multi-Tenancy Check
I'll invoke the Security Reviewer
 agent for this analysis.

I'll have the Security Reviewer
 agent Security Reviewer
 analysis.

## Phase 1: Initial Assessment & Error Grouping

### Step 1: Collect All Build Errors
Running command: `dotnet build --no-incremental 2>&1 | tee initial-build.log`

### Step 2: Group Errors by File

<think_harder about error dependencies and optimal fix order>

Analyzing errors and grouping by file:
```bash
# Extract files with error counts
grep -E "\.cs\([0-9]+,[0-9]+\):" initial-build.log | 
  sed -E 's/^([^(]+)\([0-9]+,[0-9]+\):.*/\1/' | 
  sort | uniq -c | sort -rn
```

### Step 3: Determine Fix Order
```yaml
Fix Priority:
1. Domain models (no dependencies)
2. Value objects  
3. Services (depend on domain)
4. Controllers (depend on services)

Within each tier:
- Fewer errors first (quick wins)
- Core abstractions before implementations
```

### Step 4: Create Task List
Using TodoWrite to track each file fix:
```markdown
Build Fix Tasks:
1. [ ] Analyze and group all errors
2. [ ] Fix [Domain/File1.cs] ({X} errors)
3. [ ] Fix [Domain/File2.cs] ({Y} errors)
4. [ ] Fix [Services/File3.cs] ({Z} errors)
5. [ ] Final build verification
6. [ ] Fix failing tests iteratively
```

### Initial Error Classification
<think about .NET/C# specific error categories>
- **Compilation Errors**: Syntax, types, namespaces, missing references
- **Dependency Issues**: NuGet conflicts, version mismatches, missing packages
- **DI Container**: Service registration, lifecycle mismatches, circular dependencies
- **EF Core Issues**: Migration conflicts, model changes, query problems
- **Test Failures**: Business logic, mocking issues, integration test database
- **Multi-tenant Violations**: Missing OrganizationId filters, data leaks

## Phase 2: Iterative File-by-File Build Fixing

### 📊 Progress Dashboard
```
╔════════════════════════════════════════════════════╗
║ Build Fix Progress                                 ║
╠════════════════════════════════════════════════════╣
║ Total Errors: {initial} → {current}               ║
║ Files Fixed: 0/{total} (0%)                       ║
║ Current Status: Starting...                        ║
╚════════════════════════════════════════════════════╝
```

### 🔄 File Fix Loop

For each file in the prioritized fix order:

#### 📁 File {N}/{Total}: {filename}

##### Step 1: Create Checkpoint
```bash
echo "📍 Creating checkpoint before fixing {filename}"
git add -A && git stash push -m "checkpoint-{filename}" --quiet
```

##### Step 2: Read File and Extract Errors
Reading file: {filepath}

Extracting errors for this file:
```bash
grep "{filename}" initial-build.log | head -20
```

##### Step 3: Apply Fixes to This File Only

<think_hard about correct fixes maintaining architectural integrity>

Using MultiEdit to fix all errors in {filename}:
```csharp
// Apply domain-appropriate fixes
// Maintain DDD patterns
// Ensure multi-tenant security
```

##### Step 4: Immediate Build Verification

**🔄 CRITICAL VERIFICATION GATE**

```bash
echo "🔨 Verifying fixes for {filename}..."
dotnet build --no-incremental 2>&1 | tee current-build.log

# Check if this file still has errors
ERRORS_IN_FILE=$(grep -c "{filename}" current-build.log || echo 0)
PREV_TOTAL=$(grep -c ": error" initial-build.log || echo 0)
CURR_TOTAL=$(grep -c ": error" current-build.log || echo 0)

if [ $ERRORS_IN_FILE -eq 0 ] && [ $CURR_TOTAL -le $PREV_TOTAL ]; then
  echo "✅ Successfully fixed {filename}"
  STATUS="SUCCESS"
elif [ $CURR_TOTAL -gt $PREV_TOTAL ]; then
  echo "❌ Fix caused NEW errors ($CURR_TOTAL > $PREV_TOTAL)"
  STATUS="ROLLBACK"
else
  echo "⚠️ File still has $ERRORS_IN_FILE errors"
  STATUS="RETRY"
fi
```

##### Step 5: Handle Verification Result

```yaml
if STATUS == "SUCCESS":
  - Update baseline: cp current-build.log initial-build.log
  - Drop checkpoint: git stash drop -q
  - Mark task completed in TodoWrite
  - Update progress dashboard
  - Continue to next file
  
elif STATUS == "ROLLBACK":
  - Rollback changes: git stash pop -q
  - Analyze what went wrong
  - Try alternative approach or skip file
  
elif STATUS == "RETRY":
  - Analyze remaining errors
  - Apply additional fixes
  - Verify again (max 2 retries)
```

##### Step 6: Update Progress

```
╔════════════════════════════════════════════════════╗
║ Build Fix Progress                                 ║
╠════════════════════════════════════════════════════╣
║ Total Errors: {initial} → {current}               ║
║ Files Fixed: {completed}/{total} ({percent}%)     ║
║                                                    ║
║ ✅ {file1} (3 errors fixed)                       ║
║ ✅ {file2} (2 errors fixed)                       ║
║ 🔄 {current_file} (fixing...)                     ║
║ ⏸️ {pending_file} (waiting...)                    ║
╚════════════════════════════════════════════════════╝
```

### Continue Loop Until All Files Processed

## Phase 3: Final Build Verification

After all file fixes are complete:

```bash
echo "🎯 Running final build verification..."
dotnet clean
dotnet build --configuration Release 2>&1 | tee final-build.log

if [ $? -eq 0 ]; then
  echo "✅ BUILD SUCCESS: All compilation errors resolved!"
  # Update TodoWrite: Mark build phase complete
else
  echo "⚠️ Some build errors remain:"
  grep ": error" final-build.log | head -10
fi
```



### Step 1.5: Research Build Error Patterns
I'll invoke the Researcher
 agent for this analysis.

I'll have the Researcher
 agent Researcher
 analysis.

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
I'll invoke the Tech Lead
 agent for this analysis.

I'll have the Tech Lead
 agent Tech Lead
 analysis.

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

## Phase 4: Iterative Test Fixing

### Step 1: Identify Failing Tests
```bash
echo "🧪 Running tests to identify failures..."
dotnet test --no-build 2>&1 | tee initial-test.log

# Extract failing test classes
grep -E "Failed|Error" initial-test.log | 
  grep -oE "[A-Za-z]+Tests" | 
  sort | uniq > failing-tests.txt

TEST_COUNT=$(wc -l < failing-tests.txt)
echo "Found $TEST_COUNT test classes with failures"
```

### Step 2: Create Test Fix Tasks
Using TodoWrite to track test fixes:
```markdown
Test Fix Tasks:
1. [ ] Fix [TestClass1] ({X} failures)
2. [ ] Fix [TestClass2] ({Y} failures)
3. [ ] Final test verification
```

- Root cause analysis
- Fix strategy determined

### Step 1.5: Domain Logic Analysis
I'll invoke the Researcher
 agent for this analysis.

I'll have the Researcher
 agent Researcher
 analysis.

##### Step 4: Apply Test Fixes

Using MultiEdit to fix test issues in {TestClassName}:
```csharp
// Fix test setup
// Correct assertions
// Update mocks to match production behavior
// Ensure multi-tenant isolation in tests
```

##### Step 5: Immediate Test Verification

**🔄 CRITICAL TEST VERIFICATION**

```bash
echo "🧪 Verifying test fixes for {TestClassName}..."
dotnet test --no-build --filter "FullyQualifiedName~{TestClassName}" 2>&1 | 
  tee {TestClassName}-after.log

if grep -q "Passed.*Failed: 0" {TestClassName}-after.log; then
  echo "✅ All tests in {TestClassName} now passing!"
  TEST_STATUS="SUCCESS"
  git stash drop -q
  # Update TodoWrite: Mark test class as fixed
else
  REMAINING=$(grep -c "Failed" {TestClassName}-after.log || echo 0)
  echo "⚠️ Still have $REMAINING failing tests"
  TEST_STATUS="RETRY"
  # Retry with different approach or skip for manual review
fi
```

### Continue to Next Test Class

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

## Phase 5: Final Comprehensive Verification

### Complete System Validation
```bash
echo "🏁 Running final comprehensive verification..."

# Clean rebuild
dotnet clean
dotnet build --configuration Release

# Full test suite
dotnet test --configuration Release --no-build

# Code analysis
dotnet build /p:RunAnalyzers=true /p:TreatWarningsAsErrors=true

echo "✅ All build and test issues resolved!"
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
I'll invoke the Code Simplifier
 agent for this analysis.

I'll have the Code Simplifier
 agent Code Simplifier
 analysis.

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

### Build Success
- ✅ Zero compilation errors
- ✅ All projects build successfully
- ✅ Release configuration builds
- ✅ No critical warnings

### Test Success
- ✅ 100% test pass rate
- ✅ No flaky tests
- ✅ Integration tests pass
- ✅ Reasonable execution time

### Iterative Process Success
- ✅ Each file fixed individually
- ✅ Immediate verification after each fix
- ✅ Rollback capability used when needed
- ✅ Clear progress tracking throughout

## Phase 6: Final Multi-Agent Validation

I'll invoke the general-purpose
 agent for this analysis.

I'll have the general-purpose
 agent general-purpose
 analysis.

## Opus 4 Thinking Patterns with Multi-Agent Enhancement

Throughout this process:
1. **Understand Domain First**: Agricultural requirements drive implementation (validated by Researcher)
2. **Parallel Everything Possible**: Maximize efficiency with concurrent operations
3. **Iterate Based on Compiler/Test Feedback**: Each result refines approach
4. **Verify Architectural Decisions**: When <99% confident, seek validation (Tech Lead confirms)
5. **Solve Business Problems**: Implement correct algorithms, not test-satisfying hacks
6. **Security is Non-Negotiable**: Multi-tenant isolation must be perfect (Security Reviewer validates)
7. **Multi-Agent Validation**: Each fix reviewed by specialized agents for comprehensive quality

## Benefits of Iterative File-by-File Approach

1. **Clear Causality**: Know exactly which fix caused any new issues
2. **Safe Rollback**: Can undo problematic changes immediately
3. **Progress Visibility**: See advancement file by file
4. **Early Detection**: Problems caught immediately after each fix
5. **Reduced Debugging**: Issues isolated to single file changes
6. **Higher Success Rate**: 95% vs 85% with batch approach
7. **Confidence Building**: Each successful fix builds momentum

Remember: The iterative approach may take slightly longer but is far more reliable and debuggable. Each file is fixed, verified, and confirmed before proceeding, ensuring we don't compound errors or create cascading failures.


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
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
```