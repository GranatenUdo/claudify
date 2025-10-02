---
description: Breaking frontend update with clean rebuild
allowed-tools: [Task, Read, Edit, MultiEdit, Bash]
estimated-time: 2 minutes (parallel)
complexity: moderate
category: development
---

# 🔨 Breaking Frontend Update: $ARGUMENTS

## Parallel Breaking Changes (2 minutes)

@Task(
  description="Impact analysis",
  prompt="Analyze breaking changes for '$ARGUMENTS':
  
  FIND:
  1. Component dependencies
  2. Service consumers
  3. Deprecated patterns to remove
  4. Signal flow impacts
  
  OUTPUT: Complete impact map",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Clean rebuild",
  prompt="Rebuild '$ARGUMENTS' frontend cleanly:

  ## PATTERN DETECTION (REQUIRED)

  Examine existing code to detect conventions:

  1. Use Glob to find 2-3 similar files:
     - Components: **/src/app/**/*.component.ts
     - Services: **/src/app/**/*.service.ts
  2. Read those files and detect patterns
  3. Apply the patterns you observed

  If no code files found, examine project configuration:
  1. Read package.json to check Angular version:
     - @angular/core version 18+? Use signals and @if/@for
     - @angular/core version <18? Use observables and *ngIf
     - State management libraries installed?
  2. Check angular.json for project defaults
  3. Check CLAUDE.md for specified patterns
  4. If still unclear, ask user:
     - "No existing code found. What patterns to use?"
     - "Options: Signals vs Observables, template syntax"
  5. Use user's explicit choice

  REMOVE:
  1. Legacy Observable code
  2. Backward compatibility logic
  3. Deprecated components
  4. Old routing patterns

  IMPLEMENT:
  1. Pure signal architecture
  2. Modern Angular 19 patterns only
  3. Simplified component tree
  4. Optimized bundle size

  OUTPUT: Clean, modern implementation",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="UX redesign",
  prompt="Redesign UX for '$ARGUMENTS':
  
  IMPROVE:
  1. User flows without legacy constraints
  2. Modern UI patterns
  3. Mobile-first approach
  4. Performance optimizations
  
  OUTPUT: Enhanced UX implementation",
  subagent_type="ux-design-expert"
)

@Bash(command="npm run build", description="Build")
@Bash(command="npm test -- --watch=false", description="Test")

## ✅ Complete
Breaking changes implemented. Coordinate with backend updates.

**Remember to update CHANGELOG.md:**
- Add entry under "### Changed" section
- Add entry under "### Breaking Changes" section (describe what breaks)