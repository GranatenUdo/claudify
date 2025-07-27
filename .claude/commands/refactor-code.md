---
description: Refactor and simplify code to improve quality, readability, and maintainability
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite]
argument-hint: file path, directory, or pattern to refactor (e.g., "src/services/FieldService.cs" or "**/*Service.cs")
agent-dependencies: [Code Simplifier, Code Reviewer, Tech Lead]
complexity: moderate
estimated-time: 15-30 minutes
category: quality
---

# 🔧 Refactor Code: $ARGUMENTS

## Quick Context
Use this command to improve existing code quality through systematic refactoring, focusing on simplification, maintainability, and adherence to best practices.

## Execution Flow
1. **Analysis** - Understand current code structure and identify issues
2. **Simplification** - Apply refactoring patterns to reduce complexity
3. **Validation** - Ensure functionality is preserved with proper testing

## Interactive Options
```yaml
dry-run: Analyze and suggest changes without applying them
preserve-tests: Ensure all existing tests still pass
extract-methods: Aggressively extract complex logic into smaller methods
```

## Phase 1: Code Analysis

<think harder about code complexity and maintainability issues>

### Initial Assessment
I'll analyze the target code to understand its current state and identify refactoring opportunities.

```bash
# Examine code structure
@Grep(pattern="class|interface|method|function", path="$ARGUMENTS", output_mode="files_with_matches")

# Check complexity indicators
@Grep(pattern="if.*else|switch|while|for", path="$ARGUMENTS", output_mode="count")
```

### Multi-Agent Analysis

#### Code Simplifier Assessment
I'll invoke the Code Simplifier agent to identify simplification opportunities.

@Task(description="Identify refactoring opportunities", prompt="Analyze $ARGUMENTS for:
1. Complex methods that should be broken down
2. Duplicate code that can be consolidated
3. Over-engineered abstractions
4. Long parameter lists
5. Deep nesting levels
6. Unclear naming conventions
7. Violation of SOLID principles
Provide specific refactoring recommendations with examples", subagent_type="Code Simplifier")

#### Code Quality Review
Next, I'll get a comprehensive code quality assessment.

@Task(description="Code quality analysis", prompt="Review $ARGUMENTS for:
1. Code smells and anti-patterns
2. Maintainability index
3. Cyclomatic complexity
4. Test coverage gaps
5. Documentation needs
6. Performance bottlenecks
Prioritize issues by impact", subagent_type="Code Reviewer")

## Phase 2: Refactoring Strategy

<think step-by-step about refactoring approach and order of operations>

### Refactoring Priorities
Based on the analysis, I'll create a prioritized refactoring plan:

1. **Critical Issues** - Breaking functionality or severe maintainability problems
2. **High Impact** - Significant complexity reduction opportunities
3. **Quick Wins** - Simple improvements with immediate benefits
4. **Nice to Have** - Minor enhancements for code aesthetics

### Common Refactoring Patterns

#### 1. Extract Method
```csharp
// Before: Complex method with multiple responsibilities
public async Task<Result<Field>> ProcessFieldData(FieldDto dto)
{
    // 50+ lines of validation, transformation, and business logic
}

// After: Clear separation of concerns
public async Task<Result<Field>> ProcessFieldData(FieldDto dto)
{
    var validationResult = ValidateFieldData(dto);
    if (!validationResult.IsSuccess) return validationResult;
    
    var field = TransformToEntity(dto);
    var businessResult = ApplyBusinessRules(field);
    if (!businessResult.IsSuccess) return businessResult;
    
    return await SaveField(field);
}
```

#### 2. Replace Conditional with Polymorphism
```csharp
// Before: Complex switch statement
public decimal CalculateYield(string cropType, decimal area)
{
    switch (cropType)
    {
        case "Grapes": // Complex grape calculation
        case "Wheat": // Complex wheat calculation
        // More cases...
    }
}

// After: Strategy pattern
public decimal CalculateYield(ICropYieldStrategy strategy, decimal area)
{
    return strategy.Calculate(area);
}
```

## Phase 3: Implementation

<think about preserving functionality while improving code structure>

### Systematic Refactoring Process

1. **Create Safety Net**
   - Ensure comprehensive test coverage exists
   - Add characterization tests if needed
   - Set up continuous test running

2. **Apply Refactorings**
   - Make one change at a time
   - Run tests after each change
   - Commit frequently for easy rollback

3. **Validate Results**
   - Confirm all tests pass
   - Check performance metrics
   - Review with team if needed

### Interactive Confirmation
```markdown
## Refactoring Plan Summary

The following refactorings will be applied to $ARGUMENTS:

1. **Extract Method**: [Count] complex methods will be broken down
2. **Rename**: [Count] unclear names will be improved
3. **Consolidate**: [Count] duplicate code blocks will be merged
4. **Simplify**: [Count] over-complex structures will be simplified

Estimated changes: [Total] modifications across [FileCount] files

Proceed with refactoring? (yes/no/dry-run)
```

## Phase 4: Validation & Documentation

<think about ensuring code quality improvements are measurable>

### Tech Lead Architecture Review
I'll have the Tech Lead validate that refactorings maintain architectural integrity.

@Task(description="Validate refactoring architecture", prompt="Review the refactored code in $ARGUMENTS to ensure:
1. Architectural patterns are preserved or improved
2. No performance regressions introduced
3. Scalability is maintained or enhanced
4. Technical debt is reduced, not shifted
5. Integration points remain stable
Provide approval or additional recommendations", subagent_type="Tech Lead")

### Documentation Updates
After refactoring, I'll update:
- Method/class documentation
- Architecture decision records (ADRs)
- README files if APIs changed
- Test documentation

## Success Criteria
- ✅ All existing tests pass without modification
- ✅ Code complexity metrics improve by at least 20%
- ✅ No performance regressions detected
- ✅ Code coverage maintained or improved
- ✅ Team review approval obtained

## Error Handling

### Rollback Strategy
If issues arise during refactoring:
1. Git stash current changes
2. Run tests on original code
3. Identify the problematic refactoring
4. Apply a different approach or defer

### Common Issues
- **Test Failures**: Usually indicates behavior change - revert and re-analyze
- **Performance Degradation**: Profile before and after, optimize hot paths
- **Integration Breaks**: Check contracts haven't changed unintentionally

## Example Usage

```bash
# Refactor a specific service
/refactor-code src/services/FieldService.cs

# Refactor all services with dry-run
/refactor-code src/services/**/*Service.cs --dry-run

# Aggressive refactoring with method extraction
/refactor-code src/domain/Field.cs --extract-methods
```

## Final Report

Upon completion, you'll receive:
- Before/after complexity metrics
- List of all refactorings applied
- Test coverage report
- Performance comparison
- Suggestions for further improvements