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
  
  GENERATE:
  1. Component with signals and OnPush
  2. Template with *ngIf/*ngFor
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

@Bash(command="cd src/{{WebProject}} && npm run build", description="Verify build")

## ✅ Complete
Figma design implemented as Angular component.