---
description: Performs comprehensive test quality analysis across the entire codebase, identifying gaps, redundancies, and improvement opportunities
allowed-tools: [Task, Read, Grep, Glob, LS, TodoWrite, Bash, WebSearch]
argument-hint: scope (backend/frontend/all) and focus area (coverage/quality/performance)
agent-dependencies: [Test Quality Analyst, Code Reviewer, Technical Debt Analyst, Security Reviewer, Tech Lead]
complexity: complex
estimated-time: 25-35 minutes (with parallel agent execution)
category: quality
---

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

### Phase 1: Parallel Multi-Agent Test Analysis

<think harder about comprehensive test quality assessment>

I'll invoke specialized agents in parallel for complete test quality analysis:

#### 🚀 Launching Parallel Test Analysis

@Task(description="Lead test quality analysis", prompt="Perform comprehensive test quality analysis of $ARGUMENTS:
1. **Coverage Analysis**
   - Line coverage metrics and trends
   - Branch coverage assessment
   - Critical path coverage gaps
   - Coverage by feature/module
   
2. **Test Quality Assessment**
   - Test naming and organization
   - Assertion quality and specificity
   - Mock usage appropriateness
   - Test isolation and independence
   
3. **Test Distribution**
   - Unit/Integration/E2E pyramid analysis
   - Execution time distribution
   - Resource consumption patterns
   - Parallelization opportunities
   
4. **Gap Identification**
   - Untested business logic
   - Missing edge cases
   - Insufficient error scenarios
   - Security and performance test gaps

Generate specific test examples for critical gaps with confidence scores", subagent_type="general-purpose")

@Task(description="Review test code quality", prompt="Analyze test code quality in $ARGUMENTS:
1. **Test Code Standards**
   - AAA pattern adherence (Arrange-Act-Assert)
   - DRY principle in test code
   - Helper/utility function usage
   - Test data management
   
2. **Anti-Pattern Detection**
   - Over-mocking identification
   - Brittle assertion patterns
   - Test interdependencies
   - Magic numbers/strings
   
3. **Maintainability Assessment**
   - Test readability scores
   - Documentation coverage
   - Refactoring opportunities
   - Complexity metrics
   
4. **Best Practices**
   - Single assertion principle
   - Descriptive test names
   - Proper setup/teardown
   - Meaningful test data

Provide top 10 test code improvements with examples", subagent_type="general-purpose")

@Task(description="Assess test-related technical debt", prompt="Analyze test technical debt in $ARGUMENTS:
1. **Test Debt Accumulation**
   - Outdated test frameworks
   - Deprecated assertion libraries
   - Legacy test patterns
   - Unmaintained test utilities
   
2. **Test Infrastructure Debt**
   - CI/CD test configuration issues
   - Test environment problems
   - Database seeding complexity
   - External dependency mocking
   
3. **Test Performance Debt**
   - Slow test identification
   - Resource-intensive tests
   - Sequential execution bottlenecks
   - Unnecessary test repetition
   
4. **Economic Impact**
   - Developer time wasted on flaky tests
   - Build time costs
   - Bug escape rate due to poor tests
   - Maintenance overhead

Calculate test debt score and ROI of improvements", subagent_type="Technical Debt Analyst")

@Task(description="Security test analysis", prompt="Review security testing in $ARGUMENTS:
1. **Security Test Coverage**
   - Authentication test scenarios
   - Authorization boundary testing
   - Input validation testing
   - Injection vulnerability tests
   
2. **OWASP Coverage**
   - Coverage of OWASP Top 10
   - API security test scenarios
   - Multi-tenant isolation tests
   - Data protection verification
   
3. **Security Test Quality**
   - Penetration test scenarios
   - Negative test cases
   - Security regression tests
   - Compliance test coverage
   
4. **Critical Gaps**
   - Missing security scenarios
   - Untested attack vectors
   - Insufficient boundary testing
   - Compliance test gaps

Prioritize security test additions by risk level", subagent_type="general-purpose")

@Task(description="Architectural test assessment", prompt="Review architectural testing in $ARGUMENTS:
1. **Architecture Test Coverage**
   - Layer boundary tests
   - Integration point testing
   - Contract testing presence
   - Architecture fitness functions
   
2. **System Quality Tests**
   - Performance test coverage
   - Load testing scenarios
   - Resilience testing
   - Scalability verification
   
3. **Design Pattern Tests**
   - Pattern implementation tests
   - Dependency rule verification
   - Interface contract tests
   - Component isolation tests
   
4. **Strategic Recommendations**
   - Test strategy alignment
   - Testing pyramid optimization
   - Test automation priorities
   - Quality gate definitions

Rate test architecture maturity 1-10", subagent_type="general-purpose")

### 2. Coverage Analysis
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