---
description: Fix frontend bugs with parallel diagnosis and UX validation
allowed-tools: [Task, Bash, Grep, Read, Edit, MultiEdit]
estimated-time: 1-2 minutes (parallel)
complexity: moderate
category: quality
---

# 🔧 Fix Frontend Bug: $ARGUMENTS

## Phase 1: Parallel Diagnosis (45 seconds)

@Task(
  description="Root cause analysis",
  prompt="Diagnose frontend '$ARGUMENTS':
  
  LOCATE:
  1. Error in browser console/build output
  2. Component/service affected
  3. Recent commits introducing issue
  
  ANALYZE:
  - Signal update issues (.set() vs .update())
  - Observable/signal mixing (forbidden)
  - Missing trackBy functions
  - OnPush change detection problems
  - Type mismatches with backend DTOs
  - Angular 19 syntax violations (*ngIf vs @if)
  
  OUTPUT: Root cause with file:line",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="UX impact",
  prompt="Assess UX impact of '$ARGUMENTS':
  
  CHECK:
  1. Visual glitches or layout breaks
  2. User workflow disruption
  3. Responsive design issues
  4. Accessibility regressions
  5. Performance degradation
  
  OUTPUT: User impact severity and affected flows",
  subagent_type="ux-design-expert"
)

@Task(
  description="Security & type safety",
  prompt="Security check for '$ARGUMENTS':
  
  VERIFY:
  1. No XSS vulnerabilities
  2. No unsafe innerHTML usage
  3. Proper input sanitization
  4. TypeScript strict compliance
  5. No 'as any' type casting
  
  OUTPUT: Security/type safety assessment",
  subagent_type="security-vulnerability-scanner"
)

## Phase 2: Fix Implementation (45 seconds)

@Task(
  description="Implement fix with tests",
  prompt="Fix '$ARGUMENTS' based on diagnosis:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Error handling: Match {{patterns.errorHandling}}
  - Component naming: Use {{naming.classes}}
  - Testing: Use {{testing.framework}} with {{testing.pattern}}

  ### IF NOT EXISTS (Adaptive Mode):
  Examine the file being fixed:
  1. Use Read to examine the buggy file
  2. Detect existing patterns:
     - Signal vs observable usage
     - Template syntax (*ngIf vs @if)
     - Error handling approach
     - Change detection strategy
  3. Maintain consistency with detected patterns

  ### IF NO PATTERNS DETECTED:
  Use simple, safe defaults (try/catch, OnPush)

  IMPLEMENT:
  1. Root cause fix following project conventions
  2. Maintain consistency with existing components
  3. Error handling matching project pattern

  CREATE TESTS:
  1. Regression test for original bug
  2. Component behavior verification
  3. User interaction tests
  4. Use project's testing approach

  OUTPUT: Fixed code + tests",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Visual polish",
  prompt="Ensure visual integrity after fix:
  
  VERIFY:
  1. Layouts not broken
  2. Animations still smooth
  3. Consistent styling
  4. All breakpoints working
  
  OUTPUT: Visual confirmation or adjustments",
  subagent_type="visual-design-expert"
)

## Phase 3: Parallel Validation

@Bash(command="npm run build", description="Build")
@Bash(command="npm test -- --watch=false", description="Test")
@Bash(command="npm run lint && npm run typecheck", description="Validate")

## ✅ Complete
Bug fixed with tests. Update CHANGELOG.md under "### Fixed".