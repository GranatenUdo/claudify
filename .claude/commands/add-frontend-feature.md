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
  
  CREATE:
  1. Angular 19 components with signals
  2. Services extending BaseApiService
  3. Templates with *ngIf/*ngFor (NOT @if/@for)
  4. OnPush change detection
  5. Result<T> error handling
  
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
  
  CREATE:
  1. Component tests with signals
  2. Service tests with mocked HTTP
  3. User interaction tests
  4. Test factories from mock-data-helpers
  
  OUTPUT: Comprehensive test suite",
  subagent_type="test-quality-analyzer"
)

## Phase 2: Parallel Validation (30 seconds)

@Bash(command="cd src/PTA.VineyardManagement.Web && npm run update:api", description="Sync API")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build", description="Build")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --watch=false", description="Test")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run lint && npm run typecheck", description="Validate")

## ✅ Complete
Frontend feature with UX, implementation, and tests.