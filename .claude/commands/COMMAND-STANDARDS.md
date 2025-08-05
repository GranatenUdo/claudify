# Claude Code Command Standards

## Command Metadata Structure

All commands should use this enhanced metadata structure:

```yaml
---
description: Clear, action-oriented description (max 100 chars)
allowed-tools: [Minimal set of required tools]
argument-hint: Specific examples of valid arguments
agent-dependencies: [List of agents this command will invoke]
complexity: [simple|moderate|complex]
estimated-time: [5-30 minutes]
category: [development|quality|research|design|devops|utility]
---
```

## Tool Permission Guidelines

### Minimal Tool Sets by Category

**Development Commands**
- Core: [Task, Read, Write, Edit, MultiEdit, Glob, Grep, LS, TodoWrite]
- With Build: Add [Bash]
- With Research: Add [WebSearch]

**Quality/Review Commands**
- Core: [Task, Read, Grep, Glob, LS, TodoWrite]
- With Fixes: Add [Edit, MultiEdit, Write]
- With Testing: Add [Bash]

**Research Commands**
- Core: [Task, Read, WebSearch, TodoWrite]
- With Documentation: Add [Write]
- With Code Analysis: Add [Grep, Glob, LS]

**Design Commands**
- Core: [Task, Read, Write, Edit, MultiEdit, TodoWrite]
- With Build: Add [Bash, Glob, Grep, LS]

**DevOps Commands**
- Core: [Task, Bash, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite]
- With Diagnostics: Add [WebSearch]

## Extended Thinking Patterns

Use these standardized thinking triggers:

### 1. Deep Analysis
```xml
<think harder about [specific topic]>
```
Use for: Complex problem solving, architectural decisions, security analysis

### 2. Sequential Thinking
```xml
<think step-by-step about [process or workflow]>
```
Use for: Multi-step processes, debugging, implementation planning

### 3. Parallel Analysis
```xml
<think concurrently about [multiple aspects]>
```
Use for: Multi-agent coordination, parallel investigations

### 4. Domain Thinking
```xml
<think about domain requirements and business logic>
```
Use for: Business rule implementation, domain modeling

### 5. Security Thinking
```xml
<think about security implications and multi-tenant isolation>
```
Use for: Security reviews, authorization checks, data isolation

## Command Structure Template

```markdown
---
[metadata]
---

# [Icon] Command Title: $ARGUMENTS

## Quick Context
[1-2 sentences about when to use this command]

## Execution Flow
1. **[Phase Name]** - [Brief description]
2. **[Phase Name]** - [Brief description]
3. **[Phase Name]** - [Brief description]

## Interactive Options
```yaml
dry-run: Run analysis without making changes
verbose: Show detailed progress
confirm: Require confirmation for destructive operations
```

## Phase 1: [Phase Name]

<think [appropriate pattern] about [topic]>

[Implementation details]

## Success Criteria
- ✅ [Specific measurable outcome]
- ✅ [Specific measurable outcome]
- ✅ [Specific measurable outcome]

## Error Handling
[How errors are handled and reported]
```

## Agent Integration Patterns

### Single Agent Pattern
```markdown
I'll invoke the [Agent Name] agent for this analysis.

@Task(description="[Clear task description]", prompt="[Detailed prompt]", subagent_type="[Agent Name]")
```

### Multi-Agent Pattern
```markdown
### Multi-Agent Analysis

I'll coordinate multiple specialized agents for comprehensive analysis.

#### [Domain] Analysis
@Task(description="[Task]", prompt="[Prompt]", subagent_type="[Agent]")

#### [Domain] Analysis
@Task(description="[Task]", prompt="[Prompt]", subagent_type="[Agent]")
```

## Interactive Elements

### Progress Indicators
```markdown
## Progress Tracking

- [ ] Phase 1: [Name] - Starting...
- [ ] Phase 2: [Name] - Pending
- [ ] Phase 3: [Name] - Pending

[Update as phases complete]
```

### Confirmation Prompts
```markdown
## Confirmation Required

**Action**: [Description of what will happen]
**Impact**: [What will be affected]
**Reversible**: [Yes/No]

Proceed? (Type 'yes' to continue, 'no' to abort)
```

### Dry Run Mode
```markdown
## Dry Run Analysis

Running in dry-run mode. The following changes would be made:

1. [Change description]
2. [Change description]
3. [Change description]

No actual changes will be applied.
```

## Command Categories

### Development
- add-backend-feature
- add-frontend-feature
- add-integration
- refactor-code

### Quality
- review-backend-code
- review-frontend-code
- fix-backend-bug
- fix-frontend-bug
- comprehensive-review

### Research
- do-extensive-research
- quick-research
- analyze-architecture

### Design
- figma-implement-current-selection
- create-ui-component

### DevOps
- fix-backend-build-and-tests
- fix-frontend-build-and-tests
- optimize-performance
- migrate-data

### Utility
- generate-documentation
- update-dependencies
- security-audit


## Documentation Updates

<think about what documentation needs updating based on the changes made>

### Update Checklist
Based on the changes made, update these files:

1. **CHANGELOG.md** (Confidence: 95%)
   - Add entry under `[Unreleased]` section
   - Use appropriate section: Added/Changed/Fixed/Removed
   - Include technical details and user impact

2. **FEATURES.md** (If capabilities changed)
   - Document new or modified features
   - Update technical implementation details
   - Include usage examples

3. **CLAUDE.md** (If patterns/conventions introduced)
   - Document new code patterns
   - Update architectural decisions
   - Add domain-specific rules

### Quick Update Commands
```bash
# Automated changelog update
/update-changelog "$ARGUMENTS"

# Manual update template
### [Section]
- Description of change
  - Technical implementation details
  - User-facing impact
  - Breaking changes (if any)
```

### Parallel Documentation Check
Check all documentation files simultaneously for existing references:
```bash
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```