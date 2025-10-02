---
description: Smart changelog update with git analysis and semantic versioning
allowed-tools: [Task, WebSearch, WebFetch, Read, Edit, Write, Bash]
argument-hint: change description (e.g., "Added user authentication" or "release:1.2.0")
---

# 📝 Update Changelog: $ARGUMENTS

**For release changelog or version bumping, enable extended thinking for comprehensive analysis.**

## Phase 1: Analyze Change Type (Parallel)

@Task(
  description="Analyze and categorize",
  prompt="Analyze '$ARGUMENTS' for changelog entry following Keep a Changelog format:

  IF starts with 'release:' or 'version:':
    - Extract version number (e.g., 'release:1.2.0' → '1.2.0')
    - Prepare to convert [Unreleased] to versioned release
    - Get today's date in YYYY-MM-DD format
    - Return: {type: 'release', version: 'X.Y.Z', date: 'YYYY-MM-DD'}

  ELSE (regular entry):
    CATEGORIZE into:
    - **Added** - New features
    - **Changed** - Changes in existing functionality
    - **Deprecated** - Soon-to-be removed features
    - **Removed** - Removed features
    - **Fixed** - Bug fixes
    - **Security** - Vulnerability fixes

    DETERMINE impact:
    - MAJOR: Breaking changes
    - MINOR: New features (backward compatible)
    - PATCH: Bug fixes

    REFORMAT entry:
    - Use verb-first (Added, Fixed, Changed, etc.)
    - Be concise (1-2 lines)
    - Include technical details if relevant

    Return: {type: 'entry', category: 'Fixed', description: 'Fixed authentication bug in JWT validation', impact: 'PATCH'}

  OUTPUT: JSON with type, category/version, description/date, impact",
  subagent_type="technical-documentation-writer"
)

@Bash(command="git diff --name-status HEAD~5..HEAD | head -20", description="Recent file changes")
@Bash(command="git log --oneline --pretty=format:'%s' -10", description="Recent commit messages")
@Read(file_path="CHANGELOG.md", limit=100)

## Phase 2: Smart Update

After analysis, update CHANGELOG.md:

**For Release** (if $ARGUMENTS starts with "release:"):
1. Read current [Unreleased] content
2. Convert to versioned release with today's date
3. Create new empty [Unreleased] section
4. Follow semantic versioning (X.Y.Z)

**For Regular Entry**:
1. Find or create category section under [Unreleased]
2. Add entry in proper format
3. Maintain Keep a Changelog structure

## Expected Format

```markdown
## [Unreleased]

### Added
- New feature description

### Fixed
- Bug fix description

## [1.2.0] - 2025-10-01

### Added
- Feature that was released
```

## ✅ Success Criteria
- Entry added to correct category
- Follows Keep a Changelog format
- Verb-first, concise description
- Release entries include date (YYYY-MM-DD)
- Semantic versioning maintained

## Examples

### Regular Entry:
```bash
/update-changelog Fixed authentication bug in JWT validation
```

### Release:
```bash
/update-changelog release:1.3.0
```

## Convention Awareness

Changelog updates follow patterns observed in the existing CHANGELOG.md file.

---

**Note**: Always specify category or use descriptive verbs (Added, Fixed, Changed) for auto-categorization.