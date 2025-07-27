---
description: Intelligently update CHANGELOG.md based on recent changes and git history
allowed-tools: [Read, Write, Edit, MultiEdit, Bash, Grep, Glob, LS]
argument-hint: change description or --auto to analyze git history
complexity: simple
estimated-time: 2-5 minutes
category: documentation
---

# 📝 Update Changelog

## Quick Context
Update CHANGELOG.md with new entries based on recent changes. Supports manual entry or automatic detection from git history.

## Command Syntax
```bash
/update-changelog [description] [--auto] [--type=added|changed|fixed|security]
```

## Execution Flow

### Phase 1: Analyze Current State
1. Check if CHANGELOG.md exists
2. Parse existing entries to avoid duplicates
3. Determine current date (YYYY-MM-DD format)

### Phase 2: Gather Changes

#### Manual Mode (with description)
- Parse provided description
- Determine change type from keywords or --type flag
- Format entry according to Keep a Changelog standards

#### Auto Mode (--auto flag)
- Analyze recent git commits
- Look for conventional commit patterns
- Group by change type
- Filter out merge commits and changelog updates

### Phase 3: Update Changelog
1. Add entries to appropriate section under [Unreleased]
2. Maintain proper formatting and structure
3. Preserve all existing content

## Change Type Detection

### Keywords for Automatic Classification
- **Added**: feat, feature, add, implement, create
- **Changed**: update, enhance, improve, refactor
- **Fixed**: fix, bug, resolve, patch
- **Security**: security, vulnerability, CVE

### Git Commit Analysis Pattern
```bash
# Analyze commits since last release tag or last 50 commits
git log --oneline --no-merges -50 | grep -E "^[a-f0-9]+ (feat|fix|chore|docs|style|refactor|test|build|ci):"
```

## Entry Formatting

### Standard Entry Format
```markdown
### [Category]
- Brief description of change
  - Additional details if needed
  - Technical specifics when relevant
```

### Complex Feature Entry
```markdown
### Added
- **Feature Name** - Brief description
  - Technical implementation detail
  - API endpoints: `POST /api/v1/resource`
  - Database changes: New table/migration
  - Frontend components: ComponentName
```

## Examples

### Manual Entry
```bash
/update-changelog "Added crop classification system with multi-source support"
```

### Auto-detect from Git
```bash
/update-changelog --auto
```

### Specific Type
```bash
/update-changelog "Fixed null reference in stock movement repository" --type=fixed
```

### Security Update
```bash
/update-changelog "Patched XSS vulnerability in field name display" --type=security
```

## Implementation Details

### Changelog Location
- Primary: `./CHANGELOG.md`
- Fallback: Create if doesn't exist using template

### Date Format
- ISO 8601: YYYY-MM-DD
- Example: 2025-01-27

### Version Handling
- Keep entries under [Unreleased] until release
- During release, move to dated section
- Follow semantic versioning

## Quality Checks
1. Verify entry doesn't already exist
2. Ensure proper markdown formatting
3. Check category is valid
4. Validate date format if creating new section

## Integration Points
- Called by feature/bug fix commands
- Git hooks can trigger auto-update
- CI/CD can verify changelog updates
- Release process moves Unreleased to versioned

Remember: A well-maintained changelog helps users and developers understand the evolution of the project.