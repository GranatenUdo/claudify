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

@Bash(command="dotnet build --configuration Release", description="Verify build")
@Bash(command="cd src/{{WebProject}} && npm run update:api", description="Update client")

## ✅ Complete
Breaking changes implemented. Update all consumers before deployment.