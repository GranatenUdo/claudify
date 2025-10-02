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

### Step 3: Choose Convention Mode

When prompted, select your convention detection mode:

```
Choose detection mode:
  [1] SMART MODE (Recommended)
      • Analyzes your project once (~60 seconds)
      • Commands generate matching code instantly
      • 95-100% accuracy, best for teams

  [2] ADAPTIVE MODE (Lightweight)
      • Skips analysis, commands examine code on-demand
      • 90% accuracy, always reflects current code
      • Best for rapidly changing codebases

Select mode [1/2] (default: 1):
```

**Smart Mode**: Recommended for established projects with consistent conventions
**Adaptive Mode**: Best for rapidly evolving codebases or when Node.js unavailable

### Step 4: Setup Completes

```
✓ Claudify components installed!

🎯 Mode: smart
📁 Location: .claude

Next steps:
  1. Navigate to your project directory:
     cd src/YourProject.Web
  2. Launch Claude Code:
     claude
  3. Try a command:
     /add-frontend-feature "My Feature"

Commands will automatically work in your current directory context.
```

## What Gets Installed

```
your-project/
├── .claude/
│   ├── commands/          # 40+ specialized commands
│   ├── agents/            # 30+ expert agents
│   └── config/
│       ├── project-knowledge.json # Convention cache (Smart Mode only)
│       └── claudify.json          # Mode configuration
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

## Refreshing Convention Analysis

If your codebase conventions change (e.g., you refactor from exceptions to Result<T>):

```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

This re-runs the analyzer without reinstalling commands/agents.

## Switching Between Modes

**Adaptive → Smart**:
```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

**Smart → Adaptive**:
```bash
rm .claude/config/project-knowledge.json
```

Commands automatically fall back to Adaptive Mode when cache is missing.

## Troubleshooting

### Node.js Not Found

**During setup**:
- Choose Adaptive Mode (option 2)
- Or install Node.js 18+ and re-run setup

**After setup**:
- Commands work fine in Adaptive Mode
- To use Smart Mode: Install Node.js, then run `-RefreshAnalysis`

### Analyzer Fails

Commands automatically fall back to Adaptive Mode. Check:
```bash
node --version  # Should be 18+
```

### Commands Generate Wrong Patterns

**Cause**: Stale convention cache
**Solution**:
```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

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
