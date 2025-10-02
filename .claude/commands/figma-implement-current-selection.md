---
description: Convert Figma design to Angular component with parallel generation
allowed-tools: [Task, Read, Write, Bash]
estimated-time: 90 seconds (parallel)
complexity: simple
category: development
---

# 🎨 Figma to Code: $ARGUMENTS

## Parallel Design Implementation (90 seconds)

@Task(
  description="Extract design",
  prompt="Extract Figma design for '$ARGUMENTS':
  
  ANALYZE:
  1. Visual hierarchy and layout
  2. Colors, typography, spacing
  3. Component structure
  4. Responsive breakpoints
  5. Interaction states
  
  OUTPUT: Design specifications",
  subagent_type="visual-design-expert"
)

@Task(
  description="Generate component",
  prompt="Create Angular component for '$ARGUMENTS':

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Component naming: Use {{naming.classes}}
  - Method naming: Use {{naming.methods}}
  - State management: Use detected approach

  ### IF NOT EXISTS (Adaptive Mode):
  Actively examine 2-3 similar files:
  1. Use Glob to find relevant files:
     - Components: **/src/app/**/*.component.ts
  2. Read those files and detect:
     - Signal usage vs observables
     - Template syntax (*ngIf vs @if)
     - Change detection strategy
  3. Apply the patterns you observed

  ### IF NO FILES FOUND (Empty Project):
  Use simple production-ready defaults:
  - Angular 19 with signals
  - OnPush change detection
  - Modern @if/@for syntax

  GENERATE:
  1. Component following detected patterns
  2. Template with detected syntax
  3. Styles matching Figma exactly
  4. Responsive layout
  5. Accessibility attributes

  WRITE TO: src/app/components/$ARGUMENTS/
  OUTPUT: Working Angular component",
  subagent_type="frontend-implementation-expert"
)

@Task(
  description="Create tests",
  prompt="Generate tests for '$ARGUMENTS':
  
  CREATE:
  1. Component unit tests
  2. Visual regression test setup
  3. Interaction tests
  4. Responsive behavior tests
  
  OUTPUT: Complete test coverage",
  subagent_type="test-quality-analyzer"
)

@Bash(command="npm run build", description="Verify build")

## ✅ Complete
Figma design implemented as Angular component.