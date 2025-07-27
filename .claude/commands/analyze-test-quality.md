# /analyze-test-quality

Performs comprehensive test quality analysis across the entire codebase, identifying gaps, redundancies, and improvement opportunities.

## Usage
```
/analyze-test-quality [options]
```

## Options
- `--scope <backend|frontend|all>` - Analysis scope (default: all)
- `--focus <coverage|quality|performance|all>` - Analysis focus area (default: all)
- `--depth <shallow|standard|deep>` - Analysis depth (default: standard)
- `--format <summary|detailed|actionable>` - Output format (default: actionable)

## Examples
```
/analyze-test-quality
/analyze-test-quality --scope backend --focus coverage
/analyze-test-quality --depth deep --format detailed
```

## Process

### 1. Coverage Analysis
- Line coverage metrics
- Branch coverage analysis
- Uncovered critical paths
- Coverage trends over time

### 2. Test Quality Assessment
- Test naming conventions
- Assertion quality
- Mock usage patterns
- Test isolation
- Flakiness detection

### 3. Test Distribution Analysis
- Unit vs Integration vs E2E ratio
- Test execution time distribution
- Resource consumption patterns
- Parallelization opportunities

### 4. Gap Identification
- Untested business logic
- Missing edge cases
- Insufficient error scenarios
- Security test gaps
- Performance test coverage

### 5. Anti-Pattern Detection
- Over-mocking
- Brittle assertions
- Test interdependencies
- Inadequate setup/teardown
- Magic numbers/strings

### 6. Prioritized Recommendations
- Critical gaps to address
- Quick wins for coverage
- Test refactoring opportunities
- Performance optimizations
- Maintenance improvements

## Output Format

### Summary Format
```
TEST QUALITY REPORT
==================
Overall Score: B+ (82/100)

Coverage: 78% (Target: 80%)
Quality: Good (Minor issues)
Performance: 2.3 minutes (Acceptable)

Top 3 Actions:
1. Add tests for FieldImportService validation logic
2. Refactor flaky DashboardHub integration tests
3. Increase branch coverage in CropClassification domain

Full report: 15 issues found, 8 critical
```

### Detailed Format
Includes:
- File-by-file analysis
- Specific test recommendations
- Code examples for improvements
- Metrics breakdown by module
- Historical trend analysis

### Actionable Format
Provides:
- Prioritized task list
- Effort estimates
- Implementation templates
- Success metrics
- Progress tracking

## Integration Points
- Works with coverage reports (lcov, cobertura)
- Analyzes test execution logs
- Reviews test file patterns
- Examines assertion libraries usage
- Checks CI/CD test configurations

## Quality Dimensions

### Coverage Quality
- Not just percentage, but meaningful coverage
- Business logic priority
- Error path coverage
- Edge case handling

### Test Maintainability
- Readability scores
- DRY principle adherence
- Helper/utility usage
- Documentation quality

### Execution Efficiency
- Test run time analysis
- Resource usage patterns
- Parallelization effectiveness
- Startup/teardown optimization

### Reliability Metrics
- Flakiness frequency
- False positive rate
- Environmental dependencies
- Deterministic behavior

## Best Practices Enforcement
- AAA pattern (Arrange-Act-Assert)
- Single assertion principle (where appropriate)
- Descriptive test names
- Proper isolation
- Meaningful test data

## Multi-Agent Collaboration
When --depth deep is specified:
- Test Quality Analyst: Leads the analysis
- Technical Debt Analyst: Reviews test debt accumulation
- Code Reviewer: Assesses test code quality
- Performance Analyst: Analyzes test execution efficiency

## Success Metrics
- Coverage improvement rate
- Test execution time reduction
- Flaky test elimination
- Critical path coverage
- Maintenance effort reduction