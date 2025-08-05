---
description: Analyze technical debt and best practices violations in a specified codebase section
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, TodoWrite, WebSearch]
argument-hint: path to analyze (e.g., "src/PTA.VineyardManagement.Api" or "src/**/*.cs")
agent-dependencies: [Technical Debt Analyst, Code Reviewer, Security Reviewer, Tech Lead, Code Simplifier]
complexity: complex
estimated-time: 30-45 minutes (reduced from 60 with parallel execution)
category: quality
---

# 💰 Technical Debt Analysis: $ARGUMENTS

## Phase 0: Task Management Setup

### 📋 TodoWrite Task Management
<think step-by-step about organizing the technical debt analysis>

@TodoWrite(todos=[
  {id: "1", content: "Codebase discovery and technology stack analysis", status: "in_progress", priority: "high"},
  {id: "2", content: "Pattern and architecture analysis", status: "pending", priority: "high"},
  {id: "3", content: "Dependency and security audit", status: "pending", priority: "high"},
  {id: "4", content: "Code quality metrics calculation", status: "pending", priority: "high"},
  {id: "5", content: "Synthesize findings and prioritize", status: "pending", priority: "high"},
  {id: "6", content: "Generate remediation plan", status: "pending", priority: "high"}
])

### 📊 Agent Specialization Matrix

| Analysis Type | Primary Agent | Secondary Agents | Parallel? |
|--------------|---------------|------------------|----------|
| Code Patterns | Technical Debt Analyst | Code Reviewer | ✅ Yes |
| Architecture | Tech Lead | Technical Debt Analyst | ✅ Yes |
| Dependencies | Security Reviewer | Technical Debt Analyst | ✅ Yes |
| Complexity | Code Simplifier | Code Reviewer | ✅ Yes |

## OPUS 4 ACTIVATION - DEEP DEBT ANALYSIS MODE
<think harder about accumulated technical debt, pattern violations, and modernization opportunities>

**Analysis Directive**: Conduct comprehensive technical debt analysis of the codebase at "$ARGUMENTS" to identify anti-patterns, best practice violations, outdated dependencies, and provide actionable remediation recommendations with effort estimates.

## Quick Context
Analyze technical debt across code quality, architectural patterns, security vulnerabilities, and dependency obsolescence. This command excels at identifying both quick wins and long-term refactoring opportunities, providing prioritized action plans based on risk and effort.

## Execution Flow
1. **Codebase Discovery** - Understand structure, technologies, and frameworks
2. **Pattern Analysis** - Identify violations of best practices and anti-patterns
3. **Dependency Audit** - Check for outdated packages and security vulnerabilities
4. **Code Quality Metrics** - Measure complexity, duplication, and maintainability
5. **Security Assessment** - Find potential vulnerabilities and compliance issues
6. **Remediation Planning** - Create prioritized action plan with effort estimates

## Interactive Options
```yaml
analysis-depth: shallow|standard|deep (default: standard)
include-dependencies: true|false (default: true)
include-security: true|false (default: true)
check-newer-versions: true|false (default: true)
output-format: markdown|json|html (default: markdown)
```

## Phase 1: Codebase Discovery & Technology Stack

<think step-by-step about understanding the codebase structure and technology choices>

### 🚀 Parallel Execution Pattern (40-60% Performance Gain)
```bash
# ✅ OPTIMAL: All discovery operations run in parallel
@Glob(pattern="$ARGUMENTS/**/*.{cs,ts,js,py,java}")
@Grep(pattern="class|interface|service", path="$ARGUMENTS", output_mode="count")
@Bash(command="find $ARGUMENTS -type f | wc -l", description="Count total files")
@Bash(command="cloc $ARGUMENTS --json", description="Lines of code analysis")
@Read(file_path="$ARGUMENTS/package.json")
@Read(file_path="$ARGUMENTS/*.csproj")
```

### Technology Stack Analysis

#### Framework and Language Detection
@Task(description="Technology analysis", prompt="Analyze the codebase at '$ARGUMENTS':
1. Identify primary programming languages and their versions
2. Detect frameworks (.NET, Angular, React, etc.) with specific versions
3. Find build tool configurations (MSBuild, npm, yarn, etc.)
4. List all package managers in use (NuGet, npm, pip, etc.)
5. Identify testing frameworks and tools
6. Detect CI/CD configurations if present
7. Map project structure and architecture style
Provide comprehensive technology inventory with version details", subagent_type="Technical Debt Analyst")

#### Initial Code Metrics
```
Gathering initial metrics for: $ARGUMENTS
- Total files to analyze
- Lines of code by language
- Project/module structure
- Test coverage baseline
```

### Technology Inventory Checklist
- [ ] Languages identified with versions
- [ ] Frameworks cataloged with versions
- [ ] Package managers detected
- [ ] Build tools documented
- [ ] Test frameworks identified
- [ ] Architecture style determined

### Modern Pattern Detection
```typescript
// Check for modern patterns vs legacy
if (hasSignals && !hasObservables) {
  debtScore -= 10; // Modern patterns reduce debt
}
if (usesCloudNativePatterns) {
  debtScore -= 15; // Cloud-ready reduces debt
}
```

## Phase 2-3: Parallel Pattern & Dependency Analysis

<think harder about optimizing analysis through parallelization>
<think step-by-step about identifying debt patterns>

### Task Progress Update
@TodoWrite(todos=[/* Update task 1 to completed, tasks 2-3 to in_progress */])

### Parallel Architecture and Code Analysis

I'll analyze patterns, architecture, dependencies, and complexity simultaneously for maximum efficiency:

@Task(description="Pattern violation scan", prompt="Analyze code patterns in '$ARGUMENTS':
1. SOLID principle violations (SRP, OCP, LSP, ISP, DIP)
2. Design pattern misuse or absence where needed
3. Anti-patterns (God objects, spaghetti code, copy-paste)
4. Naming convention violations
5. Code organization issues (wrong layer responsibilities)
6. Missing abstractions or over-engineering
7. Coupling and cohesion problems
8. Testing pattern violations (no mocks, testing internals)
Categorize by severity and provide examples", subagent_type="Technical Debt Analyst")
@Task(description="Architecture analysis", prompt="Evaluate architectural patterns in '$ARGUMENTS':
1. Layer violation detection (UI calling data layer directly)
2. Circular dependencies between modules
3. Missing or inconsistent patterns (Repository, Service, etc.)
4. Improper separation of concerns
5. Database access anti-patterns
6. API design violations
7. Configuration management issues
8. Cross-cutting concerns implementation
Provide architectural debt assessment with diagrams", subagent_type="general-purpose")
@Task(description="Complexity analysis", prompt="Analyze code complexity in '$ARGUMENTS':
1. Cyclomatic complexity hotspots
2. Cognitive complexity issues
3. Method/class size violations
4. Nesting depth problems
5. Duplicate code detection
6. Dead code identification
7. Unused dependencies
8. Over-engineering patterns
Provide complexity metrics and simplification opportunities", subagent_type="Technical Debt Analyst")
@Task(description="Dependency audit", prompt="Audit all dependencies in '$ARGUMENTS':
1. List all direct dependencies with current versions
2. Identify transitive dependencies
3. Find deprecated or abandoned packages
4. Detect security vulnerabilities (CVEs)
5. Check for version conflicts
6. Identify unused dependencies
7. Find duplicate functionality packages
8. Assess license compatibility
Create dependency risk matrix", subagent_type="Technical Debt Analyst")
@Task(description="Version research", prompt="Research package updates for '$ARGUMENTS':
1. For each dependency, find latest stable version
2. Check breaking changes between current and latest
3. Assess upgrade complexity and risks
4. Find security patches available
5. Identify performance improvements in newer versions
6. Check for deprecated features in use
7. Estimate upgrade effort
8. Prioritize updates by risk/benefit
Provide upgrade recommendation report", subagent_type="Technical Debt Analyst")

### Common Anti-Pattern Detection
```markdown
## Anti-Patterns to Detect

### Code Level
- God Classes (>500 lines, >20 methods)
- Long Methods (>50 lines)
- Deep Nesting (>4 levels)
- Magic Numbers/Strings
- Dead Code
- Duplicate Code

### Architecture Level
- Circular Dependencies
- Layer Violations
- Missing Abstractions
- Anemic Domain Models
- Chatty Interfaces
- Inappropriate Intimacy
```

### Analysis Results Processing

Based on the parallel analyses above, I'll now process the findings:

### Dependency Health Matrix
| Package | Current | Latest | Risk | Upgrade Effort | Priority |
|---------|---------|--------|------|----------------|----------|
| - | - | - | - | - | - |

## Phase 4-5: Parallel Quality & Security Analysis

<think deeply about comprehensive quality and security assessment>

### Parallel Quality and Security Assessment

Analyzing code quality and security vulnerabilities simultaneously:

@Task(description="Quality metrics", prompt="Calculate code quality metrics for '$ARGUMENTS':
1. Cyclomatic complexity per method/class
2. Cognitive complexity scores
3. Code duplication percentage
4. Test coverage metrics
5. Documentation coverage
6. Technical debt ratio
7. Maintainability index
8. Code churn analysis
Provide detailed metrics with industry benchmarks", subagent_type="general-purpose")
@Task(description="Security audit", prompt="Perform security analysis on '$ARGUMENTS':
1. Known vulnerability scan (OWASP Top 10)
2. Dependency vulnerability check
3. Secret/credential detection
4. Authentication/authorization issues
5. Input validation gaps
6. SQL injection risks
7. XSS vulnerabilities
8. Insecure configurations
Provide security debt report with CVSS scores", subagent_type="general-purpose")

#### Testing Debt Analysis
```yaml
Testing Debt Indicators:
  - Unit test coverage: [%]
  - Integration test coverage: [%]
  - Missing test scenarios
  - Test quality issues:
    - No assertions
    - Testing implementation details
    - Fragile tests
    - No mocking/isolation
  - Test execution time
  - Flaky test detection
```

### Quality Metrics Dashboard
```markdown
## Code Quality Snapshot

### Complexity Metrics
- Average Cyclomatic Complexity: [X]
- Max Method Complexity: [Y]
- Files Above Threshold: [Z]

### Duplication Metrics
- Duplication Percentage: [%]
- Duplicate Blocks: [Count]
- Refactoring Opportunities: [Count]

### Test Metrics
- Overall Coverage: [%]
- Unit Test Count: [X]
- Integration Test Count: [Y]
- Test Execution Time: [Seconds]
```

### Quality and Security Results

Processing the parallel quality and security findings:

### Security Debt Categories
- [ ] Vulnerable dependencies identified
- [ ] Code-level vulnerabilities found
- [ ] Configuration security issues
- [ ] Missing security controls
- [ ] Compliance gaps identified

## Phase 6: Technical Debt Quantification

<think strategically about debt impact, remediation effort, and business value>

### Debt Calculation & Prioritization

#### Comprehensive Debt Assessment
@Task(description="Debt quantification", prompt="Quantify technical debt for '$ARGUMENTS':
1. Calculate debt in developer days using SQALE method
2. Categorize debt by type (design, code, test, documentation)
3. Assess business impact of each debt item
4. Estimate remediation effort
5. Calculate debt interest (ongoing maintenance cost)
6. Identify quick wins vs long-term projects
7. Create risk/effort matrix
8. Develop payback timeline
Provide prioritized remediation roadmap", subagent_type="Technical Debt Analyst")

### Technical Debt Summary
```markdown
## Debt Quantification

### By Category
| Category | Items | Effort (Days) | Risk | Priority |
|----------|-------|---------------|------|----------|
| Code Quality | - | - | - | - |
| Architecture | - | - | - | - |
| Dependencies | - | - | - | - |
| Security | - | - | - | - |
| Testing | - | - | - | - |

### Total Debt: [X] Developer Days
### Monthly Interest: [Y] Days (ongoing maintenance)
```

## Phase 7: Remediation Roadmap

<think about practical, achievable steps for debt reduction>

### Action Plan Development

#### Quick Wins (< 1 Day Each)
```markdown
1. **[Issue]**: [Description]
   - Location: `File:Line`
   - Fix: [Specific action]
   - Benefit: [Impact]

2. **[Issue]**: [Description]
   - Location: `File:Line`
   - Fix: [Specific action]
   - Benefit: [Impact]
```

#### Medium-Term Improvements (1-5 Days)
```markdown
1. **[Refactoring Task]**
   - Scope: [Files/Modules affected]
   - Approach: [Strategy]
   - Risk: [Low/Medium/High]
   - ROI: [Expected benefit]
```

#### Long-Term Projects (> 5 Days)
```markdown
1. **[Major Refactoring]**
   - Current State: [Problem description]
   - Target State: [Desired outcome]
   - Phases: [Breakdown]
   - Dependencies: [What needs to happen first]
```

## Phase 8: Deliverables Generation

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
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```

## Final Reports

#### Executive Summary
```markdown
## Technical Debt Analysis: $ARGUMENTS

### Key Findings
- **Total Technical Debt**: [X] developer days
- **Critical Issues**: [Count] requiring immediate attention
- **Security Vulnerabilities**: [Count] with [Y] critical
- **Outdated Dependencies**: [Count] with [Z] security risks

### Top Recommendations
1. [Highest priority action]
2. [Second priority action]
3. [Third priority action]

### Investment Required
- Quick Wins: [X] days (immediate ROI)
- Critical Fixes: [Y] days (risk mitigation)
- Strategic Improvements: [Z] days (long-term health)
```

#### Detailed Technical Report
- [ ] Pattern violation catalog
- [ ] Dependency upgrade matrix
- [ ] Security vulnerability report
- [ ] Code quality metrics
- [ ] Remediation roadmap
- [ ] Risk assessment
- [ ] ROI analysis

## Success Criteria

### Analysis Completeness
- ✅ All code files analyzed
- ✅ All dependencies checked
- ✅ Security vulnerabilities identified
- ✅ Metrics calculated and benchmarked
- ✅ Anti-patterns cataloged
- ✅ Remediation plan created
- ✅ Effort estimates provided
- ✅ Priorities established

### Quality Metrics
- ✅ 100% of files scanned
- ✅ All critical vulnerabilities identified
- ✅ Actionable recommendations provided
- ✅ Clear prioritization matrix
- ✅ Realistic effort estimates

## Error Handling

### Common Challenges & Solutions

| Challenge | Solution | Prevention |
|-----------|----------|------------|
| Large codebase | Focus on critical paths | Use sampling strategies |
| Missing dependencies | Check lock files | Request package restore |
| Complex patterns | Multi-agent analysis | Deep reasoning mode |
| Version conflicts | Dependency resolution | Check compatibility matrix |

## Continuous Monitoring

### Setting Up Debt Tracking
```yaml
debt_monitoring:
  metrics:
    - code_coverage
    - cyclomatic_complexity
    - dependency_age
    - security_vulnerabilities
  
  thresholds:
    coverage_minimum: 80
    complexity_maximum: 10
    dependency_age_months: 12
    
  alerts:
    - new_vulnerabilities
    - coverage_drop
    - complexity_increase
```

---

**Remember**: Technical debt is not just about code quality—it's about the ongoing cost of shortcuts, outdated decisions, and deferred maintenance. Every day of unaddressed debt adds interest in the form of slower development, more bugs, and increased security risk. This analysis helps quantify that cost and provides a clear path to a healthier, more maintainable codebase.