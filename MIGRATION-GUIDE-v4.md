# Migration Guide: Upgrading to Claudify v4.0.0

**Last Updated**: 2025-10-02
**Target Audience**: Existing Claudify users upgrading from v3.x to v4.0.0

---

## ⚠️ BREAKING CHANGES

v4.0.0 is a **major breaking release** that removes the template system and aligns with official Claude Code best practices.

### What Changed

1. **Template System Removed**: No more `{{WebProject}}`, `{{ApiProject}}`, `{{ArchitectureTestProject}}` variables
2. **No Project Detection**: Setup no longer scans for or configures projects
3. **Pure Commands**: Commands are path-agnostic and work in current directory context
4. **No "Primary" Project**: Concept removed entirely
5. **Context-Driven**: Commands work where Claude Code is launched from

### Why This Change?

Research into official Anthropic Claude Code best practices revealed:
- Commands should be **"intentionally low-level and unopinionated"**
- No hardcoded paths or project-specific configuration
- Work in directory context provided by Claude Code
- Commands describe actions, not paths

v4.0.0 implements this philosophy correctly.

---

## Migration Steps

### Step 1: Pull Latest Claudify

```bash
cd path/to/claudify
git pull origin main
```

### Step 2: Re-run Setup

**Important**: You must re-run setup. The old commands won't work.

```bash
cd your-project
..\claudify\setup.ps1 -TargetRepository "."
```

Choose Smart or Adaptive mode when prompted.

### Step 3: Delete Obsolete Files

```bash
# Delete old config files (if exist from v3.x):
rm .claude/config/projects.json
rm .claude/config/project-knowledge.json
rm .claude/config/claudify.json

# Delete analyzer directory (violates Claude Code best practices):
rm -rf .claudify-sdk/
```

These files and directories are no longer used in v4.0.0.

### Step 4: Update Your Workflow

**OLD workflow (v3.x)**:
```bash
cd your-project-root
claude
> /add-frontend-feature "Dashboard"
# Worked because paths were hardcoded during setup
```

**NEW workflow (v4.0.0)**:
```bash
# Navigate to specific project first
cd src/YourProject.Web
claude
> /add-frontend-feature "Dashboard"
# Works because Claude Code provides directory context
```

---

## Workflow Changes

### Single Project

**Before (v3.x)**:
- Run `claude` from anywhere in repo
- Commands used hardcoded paths from template replacement

**After (v4.0.0)**:
- Navigate to project directory: `cd src/YourProject.Web`
- Run `claude` from that directory
- Commands work in current context

### Multi-Project Development

**Before (v3.x)**:
- Setup asked for "primary" project
- Other projects unusable without re-running setup

**After (v4.0.0)**:
- Use `cd` to switch between projects
- Or use git worktrees for parallel work
- All projects equally accessible

**Example**:
```bash
# Option 1: Switch with cd
cd src/Admin.Web && claude
# Work on admin, then exit
cd ../Public.Web && claude
# Work on public

# Option 2: Git worktrees (recommended)
git worktree add ../admin-work main
git worktree add ../public-work main

# Terminal 1
cd ../admin-work/src/Admin.Web
claude

# Terminal 2
cd ../public-work/src/Public.Web
claude
```

---

## What Was Removed

### From Setup.ps1
- ❌ `Get-ProjectNamesInteractive` function
- ❌ `Apply-ProjectTemplates` function
- ❌ `Resolve-DuplicateNames` function
- ❌ Interactive project selection prompts
- ❌ Template replacement logic
- ✅ Simplified from 1089 to 255 lines (76% reduction)

### From Commands
- ❌ All `cd {{WebProject}} &&` prefixes
- ❌ All `{{ApiProject}}`, `{{ArchitectureTestProject}}` templates
- ❌ Hardcoded paths

### From Configuration
- ❌ `.claude/config/projects.json` (no longer generated)
- ❌ `.claude/templates/` folder (was unused)
- ❌ "Primary project" concept

---

## What Stayed the Same

### Convention Detection
- ✅ Smart Mode (analyzes project, caches conventions)
- ✅ Adaptive Mode (on-demand examination)
- ✅ `.\setup.ps1 -RefreshAnalysis` command
- ✅ `.claude/config/project-knowledge.json` cache format
- ✅ All 18+ pattern categories detected

### Commands & Agents
- ✅ All 40+ commands available
- ✅ All 30+ agents available
- ✅ Command functionality unchanged (just path-agnostic now)
- ✅ Agent tool restrictions unchanged

---

## Common Issues After Migration

### "Command doesn't find my files"

**Cause**: Claude Code not launched from correct directory

**Solution**:
```bash
cd src/YourProject.Web  # Navigate to project
pwd                      # Verify you're in the right place
claude                   # Launch from here
```

### "Want to work on multiple projects"

**Use git worktrees** (official Claude Code recommendation):
```bash
git worktree add ../worktree-admin main
git worktree add ../worktree-public main

# Each terminal works in its own worktree
cd ../worktree-admin/src/Admin.Web && claude
cd ../worktree-public/src/Public.Web && claude
```

### "Old commands still have {{WebProject}}"

**Cause**: You didn't re-run setup

**Solution**:
```bash
.\claudify\setup.ps1 -TargetRepository "."
```

This overwrites old command files with new v4.0.0 versions.

---

## Comparison: v3.x vs v4.0.0

| Aspect | v3.x | v4.0.0 |
|--------|------|--------|
| Setup Complexity | 1089 lines, project detection | 255 lines, pure copy |
| Project Selection | "Primary" selection required | No selection needed |
| Command Paths | Hardcoded via templates | Pure, context-aware |
| Multi-Project | One primary only | All projects via `cd` |
| Configuration | `projects.json` required | No project config |
| Philosophy | Custom template system | Aligned with Claude Code |

---

## Benefits of v4.0.0

✅ **Simpler**: Setup is just file copy + optional analyzer
✅ **Flexible**: All projects equally accessible
✅ **Portable**: Commands work in any directory
✅ **Aligned**: Follows official Claude Code best practices
✅ **Maintainable**: No template logic to maintain
✅ **Scalable**: Works with 1 project or 100 projects

---

## Rollback to v3.x

If you need to rollback:

```bash
cd claudify
git checkout tags/v3.0.0
cd ../your-project
..\claudify\setup.ps1 -TargetRepository "."
```

However, v4.0.0 is recommended for better alignment with Claude Code.

---

**Questions?** Open an issue: https://github.com/GranatenUdo/claudify/issues
