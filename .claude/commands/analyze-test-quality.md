---
name: analyze-test-quality
model: opus
think-mode: think_harder
description: Performs comprehensive test quality analysis across the entire codebase, identifying gaps, redundancies, and improvement opportunities
allowed-tools: [Task, Read, Grep, Glob, LS, TodoWrite, Bash, WebSearch]
argument-hint: scope (backend/frontend/all) and focus area (coverage/quality/performance)
---

# /analyze-test-quality

## Optimization Features

### Parallel Execution
- **Multi-Agent Test Analysis**: Code Reviewer, Technical Debt Analyst, Security Reviewer, and Architectural Analyst operate simultaneously
- **Concurrent Scope Coverage**: Backend and frontend test suites analyzed in parallel for comprehensive assessment
- **Distributed Quality Metrics**: Different agents focus on coverage, maintainability, security, and architectural compliance
- **Accelerated Analysis**: 50-70% reduction in analysis time through parallel agent coordination

### Extended Thinking Integration
- **Deep Pattern Recognition**: Complex anti-pattern detection across test codebases using extended reasoning
- **Quality Heuristics**: Sophisticated analysis of test maintainability and readability patterns
- **Gap Analysis**: Extended thinking for identifying critical untested business logic and edge cases
- **Best Practice Validation**: Thoughtful assessment of AAA patterns, DRY principles, and testing pyramid compliance

### Confidence Scoring
- **Coverage Assessment**: Quantified confidence in meaningful vs. superficial test coverage metrics
- **Quality Ratings**: Scored assessments of test maintainability, readability, and anti-pattern presence
- **Risk Evaluation**: Confidence-scored identification of flaky tests and reliability issues
- **Improvement Priority**: Weighted confidence scores for recommended actions and their expected impact

### Subagent Coordination
- **Test Quality Analyst Leadership**: Primary analysis coordination with specialized agent support
- **Technical Debt Focus**: Debt Analyst identifies test-related technical debt accumulation
- **Security Test Coverage**: Security Reviewer assesses test coverage for security scenarios
- **Architecture Validation**: Architectural compliance of test structure and organization patterns

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



I'll invoke specialized agents in parallel for complete test quality analysis:

#### 🚀 Launching Parallel Test Analysis

I'll have the general-purpose agent Lead test quality analysis.

Using the general-purpose agent to: Analyze test code quality in $ARGUMENTS:
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

Provide top 10 test code improvements with examples

I'll have the Technical Debt Analyst agent Assess test-related technical debt.

I'll have the general-purpose agent Security test analysis.

I'll have the general-purpose agent Architectural test assessment.

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

#
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

## Summary Format
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