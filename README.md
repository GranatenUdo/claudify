# Claudify - Claude Code Intelligent Setup

**Minimal Setup, Maximum Intelligence**

Claudify provides an intelligent, minimal-footprint setup process for initializing Claude Code in any repository. Instead of copying dozens of files, it uses a streamlined two-step approach that lets Claude Code analyze your project and install only what you need.

## 🚀 Quick Start

### Windows
```powershell
# From claudify directory:
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"
```

### Linux/macOS  
```bash
# From claudify directory:
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

Then in your repository:
```bash
claude code
```

In Claude Code:
```
/init-claudify "your project domain description"
```

That's it! Claude Code will analyze your repository and set up everything you need.

## 📁 What This Repository Contains

```
claudify/
├── setup.ps1                     # Minimal setup script (~50 lines)
├── components-manifest.json      # Available components catalog
├── README.md                     # This file
├── SETUP-GUIDE.md                # Complete documentation
├── .claude/                      # Template components
│   ├── commands/                 # All available commands (40+)
│   ├── agents/                   # All available agents (15+)
│   ├── hooks/                    # Validation and automation hooks
│   └── COMMAND-AGENT-DESIGN-GUIDELINES.md  # Best practices guide
├── templates/                    # Template resources
│   ├── generators/               # Scripts to create new components
│   └── META-GENERATOR-README.md  # How to use generators
└── scripts/                      # Analysis and utility scripts
```

## 🎯 How It Works

### Step 1: Minimal Setup (setup.ps1)
- Creates `.claude/commands` directory in your repository
- Copies only the `init-claudify` command
- ~50 lines of PowerShell - focused on minimal setup

### Step 2: Intelligent Initialization (init-claudify)
When you run the command in Claude Code, it:

1. **Analyzes Your Repository**
   - Detects backend technology (ASP.NET, Node.js, Python, etc.)
   - Detects frontend framework (Angular, React, Vue, etc.)
   - Identifies architectural patterns (Repository, DDD, Multi-tenancy)
   - Extracts domain models and business logic

2. **Confirms Findings**
   - Shows detected configuration
   - Allows corrections and customizations
   - Asks about specific requirements

3. **Installs Components**
   - Selects appropriate agents based on tech stack
   - Installs relevant commands for your project type
   - Adds generators for creating custom components
   - Sets up validation hooks if needed

4. **Generates Documentation**
   - Creates customized CLAUDE.md with your patterns
   - Generates FEATURES.md template
   - Sets up project-specific configuration

## 📋 Available Components

### Commands
- **Development**: `add-backend-feature`, `add-frontend-feature`, `fix-*-bug`
- **Analysis**: `analyze-technical-debt`, `analyze-test-quality`
- **Review**: `review-backend-code`, `comprehensive-review`
- **Research**: `do-extensive-research`, `quick-research`
- **Meta**: `create-command-and-or-agent`, `sync-to-templates`

### Agents
- **Code Reviewer**: Quality and pattern compliance
- **Security Reviewer**: Multi-tenant isolation and security
- **Tech Lead**: Architecture and scalability
- **Test Quality Analyst**: Coverage and test patterns
- **Legacy System Analyzer**: Modernization strategies

### Generators
Create new components easily:
```powershell
# After setup, use generators to create custom components
.\.claude\generators\command-generator.ps1
.\.claude\generators\agent-generator.ps1
```

## 🔄 Sync Components Back

The `sync-to-templates` command helps maintain this template repository:

```bash
# After creating new commands/agents in your project
/sync-to-templates

# This ensures future projects benefit from your improvements
```

## 📖 Documentation

- **[COMMAND-AGENT-DESIGN-GUIDELINES.md](.claude/COMMAND-AGENT-DESIGN-GUIDELINES.md)** - Best practices for Opus 4
- **[SETUP-GUIDE.md](SETUP-GUIDE.md)** - Complete setup documentation
- **[META-GENERATOR-README.md](templates/META-GENERATOR-README.md)** - Create new generators

## ❓ Common Questions

**Q: Why the two-step process?**  
A: This keeps the initial footprint minimal while allowing Claude Code to do intelligent analysis in its native environment.

**Q: What if I already have a Claude setup?**  
A: The init command will detect existing components and only add what's missing.

**Q: Can I choose specific components?**  
A: Yes! The init command is interactive and lets you customize the selection.

**Q: How do I contribute improvements?**  
A: Create components in your project and use `/sync-to-templates` to share them back.

## 🏗️ Component Selection Modes

The init command offers three modes:

### Minimal Mode
Core essentials only (~5-10 components):
- Code Reviewer agent
- Essential commands (research, review)
- Basic documentation

### Standard Mode (Recommended)
Based on your tech stack (~15-25 components):
- Relevant agents for your stack
- Backend/Frontend specific commands
- Quality and testing tools
- Generators for customization

### Comprehensive Mode
Everything available (~40+ components):
- All agents and commands
- Specialized tools
- Advanced generators
- Complete hook system

## 📝 Changelog Integration

Claudify includes automatic changelog management:
- **/update-changelog** command for structured updates
- **check-changelog-updates** hook reminds you after significant changes
- Commands automatically update changelog when appropriate
- Follows [Keep a Changelog](https://keepachangelog.com/) format

## 🛠️ Requirements

### Windows
- PowerShell 5.1 or higher (pre-installed)
- Claude Code CLI installed

### Linux/macOS
- PowerShell Core (pwsh) 7.0 or higher
  - Install: https://github.com/PowerShell/PowerShell#get-powershell
- Claude Code CLI installed

### All Platforms
- Write permissions to target directory

---

**Remember**: Minimal setup, maximum intelligence. Let Claude Code do what it does best!