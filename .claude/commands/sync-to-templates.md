# /sync-to-templates

Synchronizes local Claude commands, agents, and configurations with the templating solution to ensure new projects get all available components.

## Usage
```
/sync-to-templates [options]
```

## Options
- `--scope <commands|agents|all>` - What to synchronize (default: all)
- `--mode <copy|smart|preview>` - Sync mode (default: smart)
- `--include-tools` - Also sync agent tools and configs
- `--force` - Overwrite existing files in templates

## Modes
- **copy**: Direct copy, overwrites everything
- **smart**: Merges intelligently, preserves template customizations
- **preview**: Dry run, shows what would be synchronized

## Process

<think step-by-step about what needs to be synchronized and how>

### 1. Discovery Phase
- Identify all commands in `.claude/commands/`
- Identify all agents in `.claude/agents/`
- Find associated configurations and tools
- Compare with template repository

### 2. Analysis Phase
- Detect new components not in templates
- Identify updated components (by timestamp/content)
- Find template-only components (reverse sync candidates)
- Check for naming conflicts

### 3. Smart Sync Logic
```yaml
For each component:
  If not in templates:
    → Copy to templates (NEW)
  If in both locations:
    If template has {{placeholders}}:
      → Preserve template version (TEMPLATE)
    If local is newer:
      → Update template (UPDATE)
    If template is newer:
      → Warn user (CONFLICT)
  If only in templates:
    → Report as template-exclusive (EXCLUSIVE)
```

### 4. Synchronization Actions
- Copy new commands with metadata preservation
- Update README.md in templates to reflect new components
- Maintain categorization and organization
- Generate sync report

### 5. Validation
- Ensure all references are valid
- Check agent dependencies exist
- Verify tool paths are correct
- Test template completeness

## Smart Features

### Metadata Preservation
Preserves frontmatter and configuration:
```yaml
---
description: Original description maintained
allowed-tools: [Original tools preserved]
category: Automatically categorized
template-sync: auto
---
```

### Conflict Resolution
When conflicts detected:
1. Shows diff between versions
2. Asks user to choose resolution strategy
3. Can maintain both versions with naming convention

### Category Detection
Automatically categorizes commands:
- `add-*` → feature
- `fix-*` → maintenance  
- `analyze-*` → quality
- `review-*` → quality
- `create-*` → meta

## Integration Points

### With create-command-and-or-agent
After creating new components:
```
✓ Created command: /new-amazing-command
✓ Created agent: new-amazing-agent
→ Syncing to templates automatically...
✓ Templates updated
```

### With CI/CD
```yaml
# .github/workflows/template-sync.yml
- name: Check Template Freshness
  run: |
    /sync-to-templates --mode preview
    if changes detected:
      fail with "Templates out of sync"
```

### With setup.ps1
The intelligent setup can now:
1. Check for newer versions in source project
2. Offer to pull latest commands
3. Show changelog of new components

## Example Output

```
TEMPLATE SYNCHRONIZATION REPORT
===============================

📊 Analysis Results:
- Commands in project: 23
- Commands in templates: 8
- Agents in project: 10
- Agents in templates: 9

🆕 New Components to Add:
- Commands (15):
  ✓ create-command-and-or-agent
  ✓ add-backend-feature
  ✓ figma-implement-current-selection
  ...

- Agents (1):
  ✓ performance-analyst

🔄 Components to Update:
- Commands (2):
  ! analyze-technical-debt (local newer by 3 days)
  ! fix-api-bug (template has customizations)

⚠️ Conflicts Requiring Attention:
- fix-api-bug: Template has {{placeholders}}, local has specific values

📋 Actions to be taken:
1. Copy 15 new commands to templates
2. Copy 1 new agent to templates
3. Update 1 command (analyze-technical-debt)
4. Preserve 1 template (fix-api-bug)

Proceed with synchronization? (Y/N):
```

## Best Practices

### Regular Sync Schedule
- After creating new commands/agents
- Before major template releases
- Weekly automated check in CI

### Template Hygiene
- Keep templates generic (use placeholders)
- Document template-specific customizations
- Maintain backward compatibility

### Version Control
```bash
# Good commit message after sync
git commit -m "feat(templates): Sync 15 new commands from production

- Added create-command-and-or-agent meta-generator
- Added comprehensive test quality analyzer
- Added Figma design integration command
- Updated analyze-technical-debt with new patterns"
```

## Future Enhancements

### Bidirectional Sync
- Pull improvements from templates back to project
- Merge community contributions
- Distributed command development

### Semantic Versioning
- Track component versions
- Show changelog between syncs
- Support rollback if needed

### Template Marketplace
- Publish curated command sets
- Import community commands
- Rating and review system