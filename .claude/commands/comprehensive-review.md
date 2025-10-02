---
description: Multi-agent code review for security, performance, and quality issues
allowed-tools: [Task, Read, Grep, Glob]
argument-hint: what to review (e.g., "FieldService" or "api/controllers")
complexity: simple
estimated-time: 1-2 minutes
category: quality
model: opus
---

# Comprehensive Review: $ARGUMENTS

**For complex codebases or architecture analysis, enable extended thinking for comprehensive review.**

## Parallel Multi-Agent Analysis

### Security Review Agent
@Task(
  description="Security vulnerability scan",
  prompt="Review '$ARGUMENTS' for CRITICAL security issues:
  
  TOP 3 SECURITY CHECKS:
  1. Missing OrganizationId filters (multi-tenant breach risk)
  2. userId accepted in URLs (should be from JWT only)
  3. Hardcoded secrets/credentials
  
  Use Grep to find:
  - ToListAsync without OrganizationId
  - userId in controller routes
  - password= or apiKey= patterns
  
  Return ONLY critical exploitable issues with file:line references.
  Provide exact fix code for each issue found.
  
  Skip theoretical risks - focus on actual vulnerabilities.",
  subagent_type="security-vulnerability-scanner"
)

### Performance Review Agent
@Task(
  description="Performance bottleneck scan",
  prompt="Review '$ARGUMENTS' for PERFORMANCE KILLERS:
  
  TOP 3 PERFORMANCE ISSUES:
  1. N+1 queries (foreach with await inside)
  2. Missing AsNoTracking() on read operations
  3. Multiple enumerations of same collection
  
  Use Grep to find:
  - 'foreach.*await' patterns
  - Multiple .Include() chains
  - ToList() called multiple times
  
  Return ONLY issues that impact user experience.
  Show before/after code for each fix.
  
  Ignore micro-optimizations.",
  subagent_type="technical-debt-analyzer"
)

### Code Quality Agent  
@Task(
  description="Code complexity scan",
  prompt="Review '$ARGUMENTS' for MAINTAINABILITY ISSUES:
  
  TOP 3 QUALITY PROBLEMS:
  1. Deeply nested if statements (>3 levels)
  2. Swallowed exceptions (catch Exception with no handling)
  3. Code duplication patterns
  
  Use Grep to find:
  - Nested if/else chains
  - 'catch.*Exception' with empty blocks
  - TODO/HACK/FIXME comments
  
  Return ONLY issues that slow down development.
  Provide refactored code for complex sections.
  
  Skip style preferences.",
  subagent_type="code-review-expert"
)

### Architecture Review Agent
@Task(
  description="Architecture pattern violations",
  prompt="Review '$ARGUMENTS' for ARCHITECTURE VIOLATIONS:

  FIRST: Check if .claude/config/project-knowledge.json exists to understand THIS project's conventions.

  IF project-knowledge.json EXISTS (cached conventions):
  - Load and respect the project's established patterns
  - Check for INCONSISTENCIES with project's OWN conventions
  - Flag deviations from the project's chosen approaches
  - Ensure new code follows established patterns

  IF project-knowledge.json NOT EXISTS (no cached conventions):
  - Analyze the codebase to detect EXISTING patterns
  - Check for INTERNAL consistency within observed patterns
  - Flag mixing of different approaches without clear reason
  - Base recommendations on what's already predominant in the code

  Common checks:
  1. Layer violations (e.g., Infrastructure depending on Application)
  2. Inconsistent error handling within the codebase
  3. Mixed patterns without clear boundaries
  4. Abstraction leaks across boundaries

  Use Grep to analyze:
  - Pattern consistency across similar components
  - Layer boundary violations
  - Deviation from established conventions

  Return ONLY violations that:
  - Break the project's own consistency
  - Violate clear architectural boundaries
  - Create maintenance problems

  Do NOT impose external 'best practices' - respect the project's choices.
  Focus on CONSISTENCY within the project's chosen patterns.",
  subagent_type="tech-lead-engineer"
)

### Test Quality Agent
@Task(
  description="Test coverage and quality scan",
  prompt="Review tests for '$ARGUMENTS' checking:
  
  TOP 3 TEST ISSUES:
  1. Missing critical path tests
  2. Tests that don't assert anything
  3. Flaky tests with timing dependencies
  
  Use Grep to find:
  - Test files for the component
  - Assert statements
  - Task.Delay or Thread.Sleep in tests
  
  Return ONLY missing critical test scenarios.
  Provide test code for uncovered paths.
  
  Skip test style issues.",
  subagent_type="test-quality-analyzer"
)

## Consolidated Report Format

After parallel analysis completes, consolidate findings:

```markdown
# Review Summary for $ARGUMENTS

## CRITICAL (Must Fix Now)
1. [Security Issue with proof and fix]
2. [Performance killer with solution]
3. [Architecture violation with correction]

## IMPORTANT (Fix This Sprint)  
1. [Quality issue affecting maintenance]
2. [Missing critical test]
3. [Technical debt item]

## MINOR (Track for Later)
1. [Style improvements]
2. [Documentation needs]
3. [Optimization opportunities]

## Metrics
- Security Score: X/10
- Performance Score: X/10
- Quality Score: X/10
- Overall Health: X/10
```

## Parallel Execution
- All agents run simultaneously
- Each agent focuses on their specific expertise
- Results are consolidated into actionable findings
- Provides concrete fixes, not just problem identification

## Convention Awareness

This command is aware of the dual-mode convention system:
- **With cached conventions** (`.claude/config/project-knowledge.json` exists): Reviews align with established project patterns
- **Without cached conventions**: Reviews based on observed patterns in the codebase

All recommendations respect the project's chosen approaches rather than imposing external standards.

## What We SKIP
- Perfect code style
- 100% test coverage
- Theoretical improvements
- Academic best practices
- Minor optimizations
- Imposing external patterns over project conventions

Focus: Identify the most impactful issues that affect system quality while respecting project conventions.