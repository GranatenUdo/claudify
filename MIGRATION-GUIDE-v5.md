# Migration Guide: Upgrading to Claudify v5.0.0

**Last Updated**: 2025-10-02
**Target Audience**: Existing Claudify users upgrading from v4.x to v5.0.0

---

## ⚠️ BREAKING CHANGES

v5.0.0 is a **major breaking release** that removes the template system and aligns with official Claude Code best practices.

### What Changed

1. **Template System Removed**: No more `{{WebProject}}`, `{{ApiProject}}`, etc.
2. **No Project Detection**: Setup no longer scans for or configures projects
3. **Pure Commands**: Commands are path-agnostic and work in current directory
4. **No "Primary" Project**: Concept removed entirely
5. **Context-Driven**: Commands work where Claude Code is launched from

### Why This Change?

Research into official Anthropic Claude Code best practices revealed:
- Commands should be **"intentionally low-level and unopinionated"**
- No hardcoded paths or project-specific configuration
- Work in directory context provided by Claude Code
- Commands describe actions, not paths

v5.0.0 implements this philosophy correctly.

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

### Step 3: Delete Obsolete Config

```bash
# If this file exists, delete it:
rm .claude/config/projects.json
```

This file is no longer used in v5.0.0.

### Step 4: Update Your Workflow

**OLD workflow (v4.x)**:
```bash
cd your-project-root
claude
> /add-frontend-feature "Dashboard"
# Worked because {{WebProject}} was hardcoded
```

**NEW workflow (v5.0.0)**:
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

**Before (v4.x)**:
- Run `claude` from anywhere in repo
- Commands used hardcoded paths

**After (v5.0.0)**:
- Navigate to project directory: `cd src/YourProject.Web`
- Run `claude` from that directory
- Commands work in current context

### Multi-Project Development

**Before (v4.x)**:
- Select "primary" project during setup
- Other projects unusable
- Had to re-run setup to switch

**After (v5.0.0)**:
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

### Setup.ps1
- ❌ `Get-ProjectNamesInteractive` function (541 lines)
- ❌ `Apply-ProjectTemplates` function (92 lines)
- ❌ `Resolve-DuplicateNames` function (15 lines)
- ❌ Interactive project selection prompts
- ❌ Template replacement logic
- ✅ Simplified from 1089 to 256 lines

### Commands
- ❌ All `cd {{WebProject}} &&` prefixes
- ❌ All `{{ApiProject}}`, `{{ArchitectureTestProject}}` templates
- ❌ Hardcoded paths

### Configuration
- ❌ `.claude/config/projects.json` (no longer generated)
- ❌ `.claude/templates/` folder (was unused)
- ❌ "Primary project" concept

---

## What Stayed the Same

### Convention Detection
- ✅ Smart Mode still works (analyzes project, caches conventions)
- ✅ Adaptive Mode still works (on-demand examination)
- ✅ `.\setup.ps1 -RefreshAnalysis` still works
- ✅ `.claude/config/project-knowledge.json` cache format unchanged
- ✅ All 18+ pattern categories still detected

### Commands & Agents
- ✅ All 40+ commands still available
- ✅ All 30+ agents still available
- ✅ Command functionality unchanged (just path-agnostic now)
- ✅ Agent tool restrictions unchanged

---

## Common Issues

### "Command doesn't find my files"

**Cause**: Claude Code not launched from correct directory

**Solution**:
```bash
cd src/YourProject.Web  # Navigate to project
pwd                      # Verify you're in the right place
claude                   # Launch from here
```

### "Want to work on multiple projects"

**Use git worktrees**:
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

This overwrites old command files with new v5.0.0 versions.

---

## Comparison: v4.0.0 vs v5.0.0

| Aspect | v4.0.0 | v5.0.0 |
|--------|--------|--------|
| Setup Complexity | 1089 lines, project detection | 256 lines, pure copy |
| Project Selection | "Primary" selection required | No selection needed |
| Command Paths | Hardcoded via templates | Pure, context-aware |
| Multi-Project | One primary only | All projects via `cd` |
| Configuration | `projects.json` required | No project config |
| Philosophy | Custom template system | Aligned with Claude Code |

---

## Benefits of v5.0.0

✅ **Simpler**: Setup is just file copy
✅ **Flexible**: All projects equally accessible
✅ **Portable**: Commands work in any directory
✅ **Aligned**: Follows official Claude Code best practices
✅ **Maintainable**: No template logic to maintain
✅ **Scalable**: Works with 1 project or 100 projects

---

## Rollback to v4.0.0

If you need to rollback:

```bash
cd claudify
git checkout tags/v4.0.0
cd ../your-project
..\claudify\setup.ps1 -TargetRepository "."
```

However, v5.0.0 is recommended for better alignment with Claude Code.

---

**Questions?** Open an issue: https://github.com/GranatenUdo/claudify/issues
