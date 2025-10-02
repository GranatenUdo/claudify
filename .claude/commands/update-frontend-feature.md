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

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and maintain cached conventions:
  - Component naming: Keep {{naming.classes}}
  - Method naming: Keep {{naming.methods}}
  - Error handling: Keep {{patterns.errorHandling}}
  - State management: Keep detected approach

  ### IF NOT EXISTS (Adaptive Mode):
  Examine the files being updated:
  1. Use Read to examine the target files
  2. Detect existing patterns:
     - Signal usage vs observables
     - Change detection strategy
     - Template syntax used
     - Service patterns
     - Error handling approach
  3. Maintain consistency with detected patterns

  ### IF NO PATTERNS DETECTED:
  Preserve existing code style exactly as found

  IMPLEMENT:
  1. Component updates following existing patterns
  2. Templates using existing syntax
  3. Service methods matching existing error handling
  4. Maintain existing change detection strategy

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