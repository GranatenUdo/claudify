---
description: Update backend feature with parallel analysis and compatibility
allowed-tools: [Task, Bash, Grep, Read, Edit, MultiEdit]
estimated-time: 2 minutes (parallel)
complexity: moderate
category: development
---

# 🔄 Update Backend Feature: $ARGUMENTS

## Phase 1: Parallel Assessment & Implementation (90 seconds)

@Task(
  description="Impact analysis",
  prompt="Analyze impact of updating '$ARGUMENTS':
  
  FIND:
  1. All dependencies and consumers
  2. Database schema changes needed
  3. API endpoint usage patterns
  4. Breaking change risks
  
  OUTPUT: Dependencies map and compatibility requirements",
  subagent_type="legacy-codebase-analyzer"
)

@Task(
  description="Feature update",
  prompt="Update '$ARGUMENTS' backend:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and maintain cached conventions:
  - Constructors: Keep {{patterns.entityConstructors}}
  - Properties: Keep {{naming.properties}}
  - Collections: Keep {{patterns.collectionProperties}}
  - Date fields: Keep {{naming.dateFields}}
  - Error handling: Keep {{patterns.errorHandling}}
  - Validation: Keep {{patterns.validation}}

  ### IF NOT EXISTS (Adaptive Mode):
  Examine the files being updated:
  1. Use Read to examine the target files
  2. Detect existing patterns:
     - Constructor style in current code
     - Property patterns used
     - Collection types used
     - Error handling approach
     - Validation patterns
  3. Maintain consistency with detected patterns

  ### IF NO PATTERNS DETECTED:
  Preserve existing code style exactly as found

  IMPLEMENT:
  1. Core functionality updates requested
  2. Maintain backward compatibility
  3. Apply modern C# 13 patterns safely
  4. Preserve existing error handling and patterns

  COMPATIBILITY:
  - Keep existing signatures
  - Add optional params/overloads
  - Version endpoints if breaking

  OUTPUT: Updated implementation",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Test updates",
  prompt="Update tests for '$ARGUMENTS':
  
  FIX: Broken tests from changes
  ADD: Tests for new functionality
  VERIFY: Backward compatibility
  ENSURE: Organization scoping intact
  
  OUTPUT: Updated test suite",
  subagent_type="test-quality-analyzer"
)

@Task(
  description="Migration & deployment",
  prompt="Handle deployment for '$ARGUMENTS':
  
  CREATE IF NEEDED:
  1. Database migrations
  2. Configuration updates
  3. Rollback procedures
  
  ENSURE: Zero-downtime deployment
  OUTPUT: Migration scripts if required",
  subagent_type="infrastructure-architect"
)

## Phase 2: Parallel Validation (30 seconds)

@Bash(command="dotnet build --configuration Release", description="Build")
@Bash(command="dotnet test --no-build --filter FullyQualifiedName~$ARGUMENTS", description="Tests")
@Bash(command="cd src/{{WebProject}} && npm run update:api", description="Update client")

## ✅ Complete
Feature updated with backward compatibility maintained. Update CHANGELOG.md.