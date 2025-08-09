# Claude Code Command Categories

Commands are organized into logical categories for easier discovery and use. Each category represents a different aspect of the development workflow.

## 🛠️ Development Commands
Commands for creating new features and functionality.

### `/add-backend-feature` 
**Complexity**: Moderate | **Time**: 20-30 min | **Agents**: Researcher, Code Reviewer, Tech Lead
Create new backend features following domain-driven design principles with proper architecture.

### `/add-frontend-feature`
**Complexity**: Moderate | **Time**: 20-30 min | **Agents**: UX Reviewer, Code Reviewer
Create new frontend features following backend-first workflow with accessibility focus.

### `/add-integration`
**Complexity**: Complex | **Time**: 30-45 min | **Agents**: Tech Lead, Security Reviewer, Researcher
Integrate third-party services with proper authentication, error handling, and testing.

## 🔍 Quality Commands
Commands for code review, testing, and quality improvement.

### `/review-backend-code`
**Complexity**: Moderate | **Time**: 15-20 min | **Agents**: Code Reviewer, Security Reviewer, Tech Lead
Perform comprehensive API code review focusing on security, performance, and architecture.

### `/review-frontend-code` 
**Complexity**: Moderate | **Time**: 15-20 min | **Agents**: UX Reviewer, Code Reviewer
Review frontend code for accessibility, UX patterns, and performance optimization.

### `/comprehensive-review` ⭐
**Complexity**: Complex | **Time**: 30-60 min | **Agents**: ALL AGENTS
Perform holistic analysis using all specialized agents for maximum insight and quality.

### `/refactor-code`
**Complexity**: Moderate | **Time**: 15-30 min | **Agents**: Code Simplifier, Code Reviewer, Tech Lead
Refactor and simplify code to improve quality, readability, and maintainability.

### `/fix-backend-bug`
**Complexity**: Moderate | **Time**: 15-30 min | **Agents**: Code Reviewer, Researcher
Debug and fix backend issues with systematic analysis and multi-agent support.

### `/fix-frontend-bug`
**Complexity**: Moderate | **Time**: 15-30 min | **Agents**: UX Reviewer, Code Reviewer
Fix frontend issues systematically with focus on user experience preservation.

## 📚 Research Commands
Commands for investigation, learning, and analysis.

### `/do-extensive-research`
**Complexity**: Complex | **Time**: 20-40 min | **Agents**: Researcher, Tech Lead, general-purpose
Perform comprehensive multi-agent research with synthesis and actionable insights.

## 🎨 Design Commands
Commands for UI/UX implementation and design system work.

### `/figma-implement-current-selection`
**Complexity**: Complex | **Time**: 30-45 min | **Agents**: UX Reviewer, Tech Lead, Researcher
Transform Figma designs into production-ready, accessible code with multi-agent analysis.

## ⚙️ DevOps Commands
Commands for build, deployment, and infrastructure tasks.

### `/fix-backend-build-and-tests`
**Complexity**: Complex | **Time**: 20-45 min | **Agents**: Code Reviewer, Security Reviewer, Tech Lead
Fix backend build and test failures using iterative analysis and parallel operations.

### `/fix-frontend-build-and-tests`
**Complexity**: Complex | **Time**: 20-45 min | **Agents**: UX Reviewer, Code Reviewer, Security Reviewer
Fix frontend build and test failures with focus on maintaining UX quality.

### `/optimize-performance` ⚡
**Complexity**: Complex | **Time**: 20-45 min | **Agents**: Tech Lead, Code Reviewer, Researcher
Analyze and optimize performance from database queries to API response times.

### `/migrate-data`
**Complexity**: Complex | **Time**: 45-90 min | **Agents**: Tech Lead, Researcher, Code Reviewer
Plan and implement data migrations with validation, rollback, and monitoring.

## 🚀 Quick Access Commands

### Most Used Commands
1. **`/add-backend-feature`** - Start new backend work
2. **`/add-frontend-feature`** - Start new frontend work
3. **`/fix-backend-bug`** - Debug backend issues
4. **`/fix-frontend-bug`** - Debug frontend issues
5. **`/comprehensive-review`** - Full analysis

### By Time Available
- **5-15 minutes**: `/review-backend-code`, `/review-frontend-code`
- **15-30 minutes**: `/add-backend-feature`, `/refactor-code`, `/fix-*-bug`
- **30-60 minutes**: `/comprehensive-review`, `/add-integration`, `/optimize-performance`
- **60+ minutes**: `/migrate-data`

### By Situation
- **Starting new work**: `/add-backend-feature`, `/add-frontend-feature`
- **Having issues**: `/fix-backend-bug`, `/fix-frontend-bug`, `/fix-*-build-and-tests`
- **Improving code**: `/refactor-code`, `/optimize-performance`
- **Major review**: `/comprehensive-review`
- **Learning**: `/do-extensive-research`

## 📊 Command Matrix

| Command | Development | Quality | Testing | Security | Performance |
|---------|:-----------:|:-------:|:-------:|:--------:|:-----------:|
| add-backend-feature | ✅ | ✅ | ✅ | ✅ | - |
| add-frontend-feature | ✅ | ✅ | ✅ | - | - |
| review-backend-code | - | ✅ | - | ✅ | ✅ |
| review-frontend-code | - | ✅ | - | - | ✅ |
| comprehensive-review | ✅ | ✅ | ✅ | ✅ | ✅ |
| refactor-code | ✅ | ✅ | ✅ | - | ✅ |
| fix-backend-bug | ✅ | ✅ | ✅ | - | - |
| fix-frontend-bug | ✅ | ✅ | ✅ | - | - |
| optimize-performance | - | ✅ | - | - | ✅ |
| add-integration | ✅ | ✅ | ✅ | ✅ | - |
| migrate-data | - | ✅ | ✅ | ✅ | ✅ |

## 🎯 Command Selection Guide

### If you need to...

**Create something new:**
- Backend API endpoint → `/add-backend-feature`
- Frontend component → `/add-frontend-feature`
- External service → `/add-integration`

**Fix something broken:**
- Backend runtime error → `/fix-backend-bug`
- Frontend display issue → `/fix-frontend-bug`
- Build failure → `/fix-*-build-and-tests`
- Performance issue → `/optimize-performance`

**Improve existing code:**
- Simplify complexity → `/refactor-code`
- Full quality review → `/comprehensive-review`
- Security audit → `/review-backend-code`
- UX improvements → `/review-frontend-code`

**Handle data:**
- Schema changes → `/migrate-data`
- Import/export → `/add-integration`

**Research or learn:**
- Deep investigation → `/do-extensive-research`
- Design implementation → `/figma-implement-current-selection`

## 💡 Pro Tips

1. **Start with `/comprehensive-review`** for critical features or major PRs
2. **Use `/refactor-code` regularly** to prevent technical debt accumulation
3. **Run `/optimize-performance` before major releases**
4. **Always `/review-*-code` after significant changes**
5. **Use complexity and time estimates** to plan your work session

## 🔄 Command Workflows

### New Feature Workflow
```
1. /do-extensive-research → Understand requirements
2. /add-backend-feature → Create API
3. /add-frontend-feature → Create UI
4. /comprehensive-review → Final quality check
```

### Bug Fix Workflow
```
1. /fix-*-bug → Fix the issue
2. /refactor-code → Improve surrounding code
3. /review-*-code → Ensure quality
```

### Performance Workflow
```
1. /optimize-performance → Identify bottlenecks
2. /refactor-code → Implement optimizations
3. /comprehensive-review → Validate improvements
```

### Integration Workflow
```
1. /do-extensive-research → Research service
2. /add-integration → Implement integration
3. /review-backend-code → Security review
4. /optimize-performance → Ensure no regression
```


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
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
```