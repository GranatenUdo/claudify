---
description: Parallel health analysis with intelligent scoring and actionable recommendations
allowed-tools: [Task, Bash, Grep, Read]
argument-hint: area to check (e.g., "security", "performance", "all")
---

# 🏥 Project Health Check: $ARGUMENTS

**For comprehensive health analysis or risk assessment, enable extended thinking for detailed evaluation.**

## Phase 1: Parallel Health Analysis (60 seconds)

### 🔒 Security Health Analyzer
@Task(
  description="Analyze security health",
  prompt="Analyze security health for '$ARGUMENTS':
  
  CHECK:
  1. Dependency vulnerabilities (dotnet/npm)
  2. Hardcoded secrets/credentials
  3. Multi-tenant isolation violations
  4. Auth/authorization issues
  
  SCORE (0-35):
  - No vulnerabilities: 15 pts
  - No secrets: 10 pts
  - Proper isolation: 10 pts
  
  Return: Score, issues found, top action needed",
  subagent_type="security-vulnerability-scanner"
)

### 📊 Code Quality Analyzer
@Task(
  description="Analyze code quality",
  prompt="Analyze code quality for '$ARGUMENTS':
  
  CHECK:
  1. Files over 500 lines
  2. TODO/FIXME/HACK count
  3. Test coverage percentage
  4. Cyclomatic complexity
  
  SCORE (0-35):
  - Small files: 10 pts
  - Low tech debt: 10 pts
  - >80% coverage: 15 pts
  
  Return: Score, issues found, top action needed",
  subagent_type="code-review-expert"
)

### ⚡ Performance Analyzer
@Task(
  description="Analyze performance health",
  prompt="Analyze performance for '$ARGUMENTS':
  
  CHECK:
  1. N+1 query patterns
  2. Missing database indexes
  3. Build time
  4. Bundle sizes
  
  SCORE (0-30):
  - No N+1: 10 pts
  - Fast build: 10 pts
  - Optimized: 10 pts
  
  Return: Score, issues found, top action needed",
  subagent_type="technical-debt-analyzer"
)

## Phase 2: Scoring & Recommendations (30 seconds)

### 🎯 Health Scorer
@Task(
  description="Calculate health score",
  prompt="Calculate overall health score for '$ARGUMENTS':
  
  COMBINE:
  - Security score (0-35)
  - Quality score (0-35)
  - Performance score (0-30)
  - Total (0-100)
  
  DETERMINE:
  - Overall health status (Critical/Poor/Fair/Good/Excellent)
  - Trend vs last check
  - Risk areas
  
  Return: Final score and health status",
  subagent_type="tech-lead-engineer"
)

### 📋 Action Recommender
@Task(
  description="Generate action plan",
  prompt="Generate prioritized actions for '$ARGUMENTS':
  
  Based on all findings, create:
  1. TOP 3 critical actions (immediate)
  2. Quick wins (< 1 hour)
  3. Sprint priorities
  4. Specific fix commands
  
  Prioritize by:
  - Security > Performance > Quality
  - Impact vs effort
  - User-facing issues first
  
  Return: Actionable recommendations",
  subagent_type="tech-lead-engineer"
)

## Quick Health Commands

### Manual Spot Checks
@Bash(command="dotnet list package --vulnerable | grep -c High || echo '0'", description="High vulnerabilities")
@Bash(command="dotnet test --no-build 2>&1 | grep -E 'Passed|Failed' | tail -1", description="Test status")
@Bash(command="find . -name '*.cs' -o -name '*.ts' | xargs wc -l | sort -rn | head -5", description="Largest files")

## Health Report Format

```markdown
# Health Report: $ARGUMENTS

## 🏥 Overall Health: [SCORE]/100 - [STATUS]

### Breakdown
🔒 Security: X/35
📊 Quality: Y/35
⚡ Performance: Z/30

### Top 3 Actions
1. [Critical security fix]
2. [Performance improvement]
3. [Quality enhancement]

### Quick Wins
- Run: `command to fix issue`
- Fix: [specific file:line]
- Update: [dependency]
```

## ✅ Success Criteria
- [ ] All health aspects analyzed
- [ ] Actual scores calculated
- [ ] Specific issues identified
- [ ] Actionable fixes provided
- [ ] Trends tracked

## Convention Awareness

Health checks adapt to observed codebase patterns. Health scoring respects your project's architecture and conventions.

## 🎯 Why This Works
- **Parallel analysis** - All health checks simultaneously
- **Real scoring** - Actual calculations, not templates
- **Prioritized actions** - Focus on what matters
- **Fast feedback** - 90 seconds to full report
- **Pattern-aware** - Respects your conventions

Remember: Fix security first, then performance, then quality!