---
description: Create Angular 19 frontend with parallel implementation
allowed-tools: [Task, Bash, Read, Write, Edit, MultiEdit]
estimated-time: 2-3 minutes (parallel)
complexity: moderate
category: development
---

# 🎨 Frontend Feature: $ARGUMENTS

## Phase 1: Parallel Design & Implementation (90 seconds)

@Task(
  description="UX design",
  prompt="Design UX for '$ARGUMENTS':
  
  DELIVER:
  1. User flows and wireframes
  2. Component hierarchy
  3. Interaction patterns
  4. Responsive layouts
  5. Error states and loading UX
  
  OUTPUT: Complete UX specification",
  subagent_type="ux-design-expert"
)

@Task(
  description="Implementation",
  prompt="Implement '$ARGUMENTS' frontend:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Component naming: Use {{naming.classes}}
  - Method naming: Use {{naming.methods}}
  - Error handling: Match backend {{patterns.errorHandling}}
  - State management: Use detected approach
  - Testing: Use {{testing.framework}}

  ### IF NOT EXISTS (Adaptive Mode):
  Actively examine 2-3 similar files:
  1. Use Glob to find relevant files:
     - Frontend components: **/src/app/**/*.component.ts
     - Frontend services: **/src/app/**/*.service.ts
  2. Read those files and detect:
     - Signal usage vs observables
     - Change detection strategy (OnPush vs Default)
     - Template syntax (*ngIf vs @if)
     - Service patterns (BaseApiService inheritance)
     - Error handling approach
     - State management pattern
  3. Apply the patterns you observed

  ### IF NO FILES FOUND (Empty Project):
  Use simple production-ready defaults:
  - Angular 19 with signals
  - OnPush change detection
  - Modern @if/@for syntax
  - Try/catch error handling
  - BaseApiService if available

  ## Step 2: Generate Code

  CREATE:
  1. Angular component(s) following project conventions
  2. TypeScript service(s) with appropriate error handling
  3. HTML template(s) with responsive design
  4. Component styles (CSS/SCSS)

  USE: Angular 19 features, TypeScript, CLAUDE.md patterns
  OUTPUT: Working implementation",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Visual design",
  prompt="Style '$ARGUMENTS' UI:
  
  DESIGN:
  1. Color schemes and typography
  2. Icons and visual elements
  3. Animations and transitions
  4. Visual hierarchy
  
  OUTPUT: Beautiful, polished UI",
  subagent_type="visual-design-expert"
)

@Task(
  description="Tests",
  prompt="Test '$ARGUMENTS' frontend:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Use detected testing patterns:
  - Framework: {{testing.framework}}
  - Pattern: {{testing.pattern}}

  ### IF NOT EXISTS (Adaptive Mode):
  Examine existing test files:
  1. Use Glob: **/*.spec.ts or **/*.test.ts
  2. Read 1-2 test files and detect:
     - Test framework (Jasmine vs Jest)
     - Test patterns (AAA vs BDD)
     - Mock approach (spies vs jest mocks)

  ### IF NO FILES FOUND:
  Use Jasmine/Karma (Angular default).

  CREATE:
  1. Component tests (test component logic and rendering)
  2. Service tests with mocked HTTP
  3. User interaction tests
  4. Test data factories if mock-data-helpers exist

  OUTPUT: Comprehensive test suite",
  subagent_type="test-quality-analyzer"
)

## Phase 2: Parallel Validation (30 seconds)

@Bash(command="cd src/{{WebProject}} && npm run update:api", description="Sync API")
@Bash(command="cd src/{{WebProject}} && npm run build", description="Build")
@Bash(command="cd src/{{WebProject}} && npm test -- --watch=false", description="Test")
@Bash(command="cd src/{{WebProject}} && npm run lint && npm run typecheck", description="Validate")

## ✅ Complete
Frontend feature with UX, implementation, and tests.