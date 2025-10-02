---
description: Validate release readiness with parallel checks and intelligent risk assessment
allowed-tools: [Task, Bash, Grep, Read]
argument-hint: release version (e.g., "v1.2.3" or "next")
complexity: simple
estimated-time: 1.5 minutes
category: devops
model: opus
---

# 🚀 Validate Release: $ARGUMENTS

**For complex release validation or risk assessment, enable extended thinking for comprehensive analysis.**

## Phase 1: Parallel Validation Checks (60 seconds)

### 🧪 Test Validator
@Task(
  description="Validate all tests",
  prompt="Run and validate all test suites for release '$ARGUMENTS':
  
  RUN:
  1. Backend unit tests
  2. Frontend tests
  3. Integration tests
  
  CHECK:
  - All tests passing
  - No flaky tests
  - Coverage acceptable
  
  Return: Test status and any failures",
  subagent_type="test-quality-analyzer"
)

### 🔒 Security Scanner
@Task(
  description="Security validation",
  prompt="Scan for security issues blocking release '$ARGUMENTS':
  
  CHECK:
  1. Vulnerable packages (dotnet list package --vulnerable)
  2. Hardcoded secrets in code
  3. Auth/authorization issues
  4. OWASP top 10 compliance
  
  Return: Security status and critical issues",
  subagent_type="security-vulnerability-scanner"
)

### 🔨 Build Validator
@Task(
  description="Validate builds",
  prompt="Validate release builds for '$ARGUMENTS':
  
  BUILD:
  1. Backend Release configuration
  2. Frontend production build
  3. Docker images
  
  CHECK:
  - No build warnings
  - Optimizations enabled
  - Bundle sizes acceptable
  
  Return: Build status and any issues",
  subagent_type="infrastructure-architect"
)

### 📚 Doc & Version Checker
@Task(
  description="Check documentation",
  prompt="Validate documentation for release '$ARGUMENTS':
  
  CHECK:
  1. CHANGELOG.md updated
  2. Version numbers consistent (csproj, package.json)
  3. API documentation current
  4. Breaking changes documented
  
  Return: Documentation status",
  subagent_type="technical-documentation-writer"
)

## Phase 2: Risk Analysis & Decision (30 seconds)

### 🎯 Risk Analyzer
@Task(
  description="Analyze release risk",
  prompt="Analyze risk for releasing '$ARGUMENTS':
  
  ASSESS:
  1. Test results from validators
  2. Security findings
  3. Build status
  4. Changes since last release
  
  DETERMINE:
  - Risk level (LOW/MEDIUM/HIGH)
  - Go/No-Go recommendation
  - Blocking issues
  - Rollback strategy
  
  Return: Release decision with rationale",
  subagent_type="tech-lead-engineer"
)

### 📊 Report Generator
@Task(
  description="Generate release report",
  prompt="Generate release validation report for '$ARGUMENTS':
  
  CREATE concise report with:
  1. Go/No-Go decision
  2. Passed checks ✅
  3. Failed checks ❌
  4. Warnings ⚠️
  5. Risk assessment
  6. Next steps
  
  Format as markdown summary",
  subagent_type="tech-lead-engineer"
)

## Quick Validation Commands

### Manual Override Checks
@Bash(command="dotnet test --no-build --logger minimal | grep -E 'Passed|Failed' | tail -3", description="Quick test check")
@Bash(command="docker build -t release-test:$ARGUMENTS . 2>&1 | tail -5", description="Docker build test")

## Release Report Format

```markdown
# Release $ARGUMENTS Validation

## 🚦 Decision: [GO/NO-GO]

### Status
- Tests: [PASS/FAIL] (X/Y passing)
- Security: [CLEAN/ISSUES]
- Build: [SUCCESS/FAILED]
- Docs: [CURRENT/OUTDATED]

### Risk: [LOW/MEDIUM/HIGH]

### Next Steps
[Specific actions needed]
```

## ✅ Success Criteria
- [ ] All tests passing
- [ ] No security vulnerabilities
- [ ] Builds successful
- [ ] Documentation updated
- [ ] Risk assessed

## Convention Awareness

Release validation is based on observed patterns in the codebase. Validation criteria adapt to your project's release practices.

## 🎯 Why This Works
- **Parallel validation** - All checks run simultaneously
- **Intelligent analysis** - Risk assessment, not just pass/fail
- **Fast decision** - 90 seconds to go/no-go
- **Clear report** - Actionable next steps
- **Pattern-aware** - Respects your conventions

Remember: Fast validation catches 80% of release issues!