---
description: Fix frontend build and test failures with parallel diagnosis
allowed-tools: [Task, Bash, Grep, Read, Edit, MultiEdit]
argument-hint: error message or test failure description
---

# 🔧 Fix Frontend Build & Tests: $ARGUMENTS

## Phase 1: Parallel Diagnosis (30 seconds)

### 🔨 Build Error Analyzer
@Task(
  description="Analyze build errors",
  prompt="Analyze frontend build errors for '$ARGUMENTS':
  
  CHECK:
  1. TypeScript errors: Type mismatches, missing properties
  2. Import issues: Module not found, path errors
  3. Angular 19: Template syntax, signal issues
  4. Dependencies: Missing packages, version conflicts
  
  Return: Specific build issues found",
  subagent_type="frontend-implementation-expert"
)

### 🧪 Test Failure Analyzer
@Task(
  description="Analyze test failures",
  prompt="Analyze test failures for '$ARGUMENTS':
  
  CHECK:
  1. Mock setup: Missing providers, incorrect spies
  2. Async issues: Timing, fakeAsync/tick needed
  3. Signal testing: Initialization, reactivity
  4. DOM issues: detectChanges needed, element queries
  
  Return: Test failure patterns found",
  subagent_type="test-quality-analyzer"
)

### 📝 Lint/Type Checker
@Task(
  description="Check lint and types",
  prompt="Check lint/type issues for '$ARGUMENTS':
  
  CHECK:
  1. ESLint errors: Unused vars, formatting
  2. TypeScript strict: Null checks, any types
  3. Angular rules: Template errors, deprecated APIs
  4. Import order: Circular deps, barrel exports
  
  Return: Lint and type issues found",
  subagent_type="code-review-expert"
)

## Phase 2: Parallel Fix Implementation (90 seconds)

### 🛠️ TypeScript Fixer
@Task(
  description="Fix TypeScript errors",
  prompt="Fix TypeScript issues found:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Read to check the error files
  2. Detect template syntax used (*ngIf vs @if)
  3. Maintain existing patterns

  If no patterns detected, examine project configuration:
  1. Read package.json to check Angular version
  2. Check angular.json for project defaults
  3. Check CLAUDE.md for specified patterns
  4. If still unclear, ask user:
     - "What Angular patterns should I follow?"
  5. Use user's explicit choice or minimal safe fixes

  COMMON FIXES:
  1. Type errors: Add types, fix interfaces, use assertions
  2. Imports: Fix paths, add missing imports
  3. Null safety: Add ?. operator, initialize signals
  4. Template syntax: Match existing project syntax

  Apply minimal fixes for compilation.
  Generate working code changes.",
  subagent_type="frontend-implementation-expert"
)

### ✅ Test Fixer
@Task(
  description="Fix test failures",
  prompt="Fix test failures found:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob: **/*.spec.ts
  2. Read a working test to detect patterns
  3. Apply same patterns to fix

  If no patterns detected, examine project configuration:
  1. Read package.json to check test frameworks:
     - jest installed? Use Jest patterns
     - jasmine-core installed? Use Jasmine patterns
     - karma installed? Use Karma configuration
  2. Check angular.json test configuration
  3. Check CLAUDE.md for specified test patterns
  4. If still unclear, ask user:
     - "What test framework does this project use?"
     - "Options: Jest, Jasmine/Karma"
  5. Use user's explicit choice

  COMMON FIXES:
  1. Providers: Add all required mocks to TestBed
  2. Async: Use fakeAsync/tick or waitForAsync
  3. Signals: Initialize with test values
  4. DOM: Add fixture.detectChanges() calls

  Fix failing tests with minimal changes.
  Generate working test fixes.",
  subagent_type="test-quality-analyzer"
)

### ⚙️ Config Fixer
@Task(
  description="Fix configuration issues",
  prompt="Fix config/dependency issues:
  
  CHECK & FIX:
  1. Package.json: Update versions, add missing deps
  2. TSConfig: Strict mode, paths, Angular settings
  3. Angular.json: Build options, assets, styles
  4. API sync: Run update:api if OpenAPI outdated
  
  Generate config fixes if needed.",
  subagent_type="infrastructure-architect"
)

## Phase 3: Parallel Validation (30 seconds)

### Full Validation Suite
@Bash(command="npm install", description="Install dependencies")
@Bash(command="npm run build", description="Build verification")
@Bash(command="npm test -- --watch=false", description="Test execution")
@Bash(command="npm run lint --fix", description="Lint with autofix")

## Quick Reference

```markdown
## Fix Priority
1. Install deps → Build → Test → Lint
2. Fix TypeScript before tests
3. Initialize signals properly
4. Mock all dependencies

## Common Commands
npm cache clean --force
npm install
npm run update:api
rm -rf node_modules && npm install
```

## ✅ Success Criteria
- [ ] Build passes without errors
- [ ] All tests pass
- [ ] Lint passes
- [ ] No TypeScript errors
- [ ] Signals initialized

## 🎯 Why This Works
- **Parallel diagnosis** - 3 analyzers work simultaneously
- **Targeted fixes** - Each agent fixes specific issues
- **Angular 19 aware** - Signal and template fixes
- **Fast validation** - All checks run in parallel

Remember: Most frontend failures are missing imports or uninitialized signals!