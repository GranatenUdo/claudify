---
description: Breaking backend update with migration strategy
allowed-tools: [Task, Read, Edit, MultiEdit, Bash]
estimated-time: 2 minutes (parallel)
complexity: moderate
category: development
---

# 🔨 Breaking Backend Update: $ARGUMENTS

## Parallel Breaking Changes (2 minutes)

@Task(
  description="Impact analysis",
  prompt="Analyze breaking changes for '$ARGUMENTS':
  
  FIND:
  1. All consumers and dependencies
  2. Obsolete/deprecated code to remove
  3. Database schema changes needed
  4. API contracts to break
  
  OUTPUT: Complete impact assessment",
  subagent_type="legacy-codebase-analyzer"
)

@Task(
  description="Clean implementation",
  prompt="Rebuild '$ARGUMENTS' without compatibility:

  ## PATTERN DETECTION (REQUIRED)

  Check if .claude/config/project-knowledge.json exists:

  ### IF EXISTS (Smart Mode):
  Read and apply cached conventions:
  - Constructors: Follow {{patterns.entityConstructors}}
  - Properties: Use {{naming.properties}}
  - Collections: Use {{patterns.collectionProperties}}
  - Date fields: Use {{naming.dateFields}}
  - Error handling: Use {{patterns.errorHandling}}
  - Validation: Use {{patterns.validation}}

  ### IF NOT EXISTS (Adaptive Mode):
  Actively examine 2-3 similar files:
  1. Use Glob to find relevant files:
     - Entities: **/*Domain*/Models/Entities/*.cs or **/Models/Entities/*.cs
     - Services: **/*Service.cs
  2. Read those files and detect patterns
  3. Apply the patterns you observed

  ### IF NO FILES FOUND (Empty Project):
  Use simple production-ready defaults

  REMOVE:
  1. Legacy parameters and overloads
  2. Backward compatibility code
  3. Deprecated endpoints
  4. Old database columns

  IMPLEMENT:
  1. Clean service interfaces
  2. Modern C# 13 patterns only
  3. Simplified API surface
  4. Optimized data model

  OUTPUT: Clean, modern implementation",
  subagent_type="tech-lead-engineer"
)

@Task(
  description="Migration plan",
  prompt="Create migration for '$ARGUMENTS':
  
  GENERATE:
  1. Database migration scripts
  2. Data transformation logic
  3. Client update guide
  4. Rollback procedures
  
  OUTPUT: Complete migration package",
  subagent_type="infrastructure-architect"
)

## IMPORTANT: dotnet Command Usage

**NEVER use '--no-build' flag with dotnet commands.**

Always run:
- `dotnet build` - Ensures latest code is compiled
- `dotnet test` - Builds then tests (do NOT use --no-build)
- `dotnet run` - Builds then runs

The '--no-build' flag skips compilation and can cause:
- Tests running against stale code
- Missing compilation errors
- False test results

CORRECT: `dotnet test`
WRONG: `dotnet test --no-build`

@Bash(command="dotnet build --configuration Release", description="Verify build")
@Bash(command="dotnet test", description="Run tests")
@Bash(command="cd {{WebProject}} && npm run update:api", description="Update client")

## ✅ Complete
Breaking changes implemented. Update all consumers before deployment.

**Remember to update CHANGELOG.md:**
- Add entry under "### Changed" section
- Add entry under "### Breaking Changes" section (describe what breaks)