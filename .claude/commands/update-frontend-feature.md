---
description: Update frontend feature with parallel analysis and compatibility
allowed-tools: [Task, Bash, Grep, Read, Edit, MultiEdit]
estimated-time: 2 minutes (parallel)
complexity: moderate
category: development
---

# 🔄 Update Frontend Feature: $ARGUMENTS

## Phase 1: Parallel Assessment & Implementation (90 seconds)

@Task(
  description="Impact analysis",
  prompt="Analyze impact of updating '$ARGUMENTS':
  
  FIND:
  1. Component dependencies
  2. Signal flow and computed chains
  3. Template changes needed
  4. Service consumers
  
  OUTPUT: Dependencies map and update requirements",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Feature update",
  prompt="Update '$ARGUMENTS' frontend:
  
  IMPLEMENT:
  1. Component updates with signals
  2. Templates with *ngIf/*ngFor (NOT @if/@for)
  3. Service methods with Result<T>
  4. Maintain OnPush and responsiveness
  
  COMPATIBILITY:
  - Keep existing inputs/outputs
  - Add features as optional
  - No breaking changes
  
  OUTPUT: Updated implementation",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Test updates",
  prompt="Update tests for '$ARGUMENTS':
  
  FIX: Broken tests from changes
  ADD: Tests for new features
  VERIFY: Signal reactivity
  ENSURE: Backward compatibility
  
  OUTPUT: Updated test suite",
  subagent_type="test-quality-analyzer"
)

@Task(
  description="UX validation",
  prompt="Validate UX for '$ARGUMENTS':
  
  CHECK:
  1. Visual consistency maintained
  2. User flows still intuitive
  3. Responsive design intact
  4. Performance acceptable
  
  OUTPUT: UX validation report",
  subagent_type="ux-design-expert"
)

## Phase 2: Parallel Validation (30 seconds)

@Bash(command="cd src/{{WebProject}} && npm run build", description="Build")
@Bash(command="cd src/{{WebProject}} && npm test -- --watch=false", description="Test")
@Bash(command="cd src/{{WebProject}} && npm run lint --fix", description="Lint")
@Bash(command="cd src/{{WebProject}} && npm run typecheck", description="Types")

## ✅ Complete
Feature updated with backward compatibility. Update CHANGELOG.md.