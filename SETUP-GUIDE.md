# Claudify Setup Guide

## Prerequisites

Before running Claudify, ensure you have:

**PowerShell 7+** installed (cross-platform)
- Windows: Pre-installed or via Microsoft Store
- macOS: `brew install powershell`
- Linux: [Installation guide](https://docs.microsoft.com/powershell/scripting/install/installing-powershell)

**Claude Code CLI** installed and configured
- Run `claude --version` to verify installation
- Ensure you're logged in with `claude login`

**.NET/Angular Project**
- .NET 8 or 9 backend
- Angular 17-19 frontend (optional)
- Any standard project structure

## Installation Steps

### Step 1: Clone Claudify

```bash
git clone https://github.com/GranatenUdo/claudify.git
```

### Step 2: Run Setup

Navigate to your project and run setup:

#### Windows
```powershell
cd C:\path\to\your\project
..\claudify\setup.ps1 -TargetRepository "."
```

#### macOS/Linux
```bash
cd /path/to/your/project
pwsh ../claudify/setup.ps1 -TargetRepository "."
```

### Step 3: Setup Completes

```
✓ Claudify installation complete!

📁 Location: .claude

Next steps:
  1. Navigate to your project directory:
     cd src/YourProject.Web
  2. Launch Claude Code:
     claude
  3. Try a command:
     /add-frontend-feature "My Feature"

Commands automatically detect your conventions by examining existing code.
```

## What Gets Installed

```
your-project/
├── .claude/
│   ├── commands/          # 40+ specialized commands
│   └── agents/            # 30+ expert agents
```

## Using Claudify Commands

### Single Project

```bash
# Navigate to your project
cd src/MyProject.Web

# Launch Claude Code
claude

# Use commands - they work in current directory
> /add-frontend-feature "User Dashboard"
> /fix-frontend-bug "Button not clicking"
> /comprehensive-review
```

### Multi-Project Monorepo

**Option 1: Switch with `cd`**
```bash
# Work on admin project
cd src/Admin.Web
claude
> /add-frontend-feature "Admin Panel"
# Exit Claude (Ctrl+D)

# Work on public project
cd ../Public.Web
claude
> /add-frontend-feature "Landing Page"
```

**Option 2: Git Worktrees (Recommended)**
```bash
# Create worktrees for parallel work
git worktree add ../repo-admin main
git worktree add ../repo-public main

# Terminal 1: Admin work
cd ../repo-admin/src/Admin.Web
claude
> /add-frontend-feature "Admin Dashboard"

# Terminal 2: Public work
cd ../repo-public/src/Public.Web
claude
> /add-frontend-feature "Home Page"
```

## Troubleshooting

### Commands Generate Wrong Patterns

**Cause**: No similar files to examine, or patterns unclear
**Solution**: Ensure you have existing code files for commands to examine. Commands detect patterns from actual code.

### Commands Don't Work

**Check**:
1. Did you navigate to the project directory? `cd src/YourProject.Web`
2. Is Claude Code running in that directory? `pwd`
3. Are command files in `.claude/commands/`? `ls .claude/commands/`

## Uninstalling

Delete the `.claude` directory:

```bash
rm -rf .claude
```

Claudify is completely self-contained in this directory.

## Next Steps

1. **Learn commands**: Run `claude` and type `/` to see available commands
2. **Read command docs**: Check `.claude/commands/README.md`
3. **Try a command**: `/add-frontend-feature "Test Feature"`
4. **Explore agents**: Run `/agents` to see specialized agents

---

**Claudify 4.0.0** - Pure, context-aware commands for Claude Code.
