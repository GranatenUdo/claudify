# Claudify - Claude Code Intelligent Setup

![Version](https://img.shields.io/badge/version-2.0.1-blue)
![Released](https://img.shields.io/badge/released-2025--01--27-green)
![Opus 4](https://img.shields.io/badge/agents-Opus%204%20Optimized-purple)

**Minimal Setup, Maximum Intelligence - Now with Opus 4 Optimized Agents**

Claudify provides an intelligent, minimal-footprint setup process for initializing Claude Code in any repository. Version 2.0.1 includes enhanced Angular detection for enterprise projects and Opus 4 optimized agents that deliver **75% faster analysis** through parallel processing and AI-powered solution generation.

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

The setup script will:
- Create/update `.gitignore` to exclude the `.claudify` folder
- Copy all claudify resources to `.claudify` (persists for future updates)
- Copy minimal initialization command to `.claude/commands/`
- Prepare everything for intelligent component selection

Then in your repository:
```bash
claude
```

In Claude Code:
```
/init-claudify "your project domain description"
```

That's it! Claude Code will analyze your repository and set up everything you need.

## 📁 What This Repository Contains

```
claudify/
├── setup.ps1                     # Advanced setup script with full deployment
├── components-manifest.json      # Available components catalog (v1.4.0)
├── README.md                     # This file
├── SETUP-GUIDE.md                # Complete documentation
├── CHANGELOG.md                  # Version history
├── AGENT-COLLABORATION-GUIDE.md  # How to use Opus 4 agents
├── AGENT-COLLABORATION-EXAMPLES.md # Real-world examples
├── .claude/                      # Template components
│   ├── commands/                 # All available commands (40+)
│   ├── agents/                   # Opus 4 optimized agents (15+)
│   │   └── *.md                  # All agents with parallel processing
│   ├── hooks/                    # Validation and automation hooks
│   └── COMMAND-AGENT-DESIGN-GUIDELINES.md  # Best practices guide
├── templates/                    # Template resources
│   ├── generators/               # Scripts to create new components
│   └── META-GENERATOR-README.md  # How to use generators
└── scripts/                      # Analysis and utility scripts
```

## 🎯 How It Works

### Step 1: Advanced Setup (setup.ps1)
- Creates `.claude/commands` directory in your repository
- Copies only the `init-claudify` command initially
- Deploys all resources to `.claudify` for intelligent selection
- Includes Opus 4 optimized agents

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

### Agents (Opus 4 Optimized)
- **Code Reviewer**: Parallel code analysis with AI suggestions
- **Security Reviewer**: AI-powered vulnerability detection
- **Tech Lead**: Parallel architecture assessment
- **Frontend Developer**: AI component generation
- **Test Quality Analyst**: AI test suite generation
- **Technical Debt Analyst**: Economic impact modeling
- **Plus 9+ more specialized agents**

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

- **[AGENT-COLLABORATION-GUIDE.md](AGENT-COLLABORATION-GUIDE.md)** - How to use Opus 4 agents effectively
- **[AGENT-COLLABORATION-EXAMPLES.md](AGENT-COLLABORATION-EXAMPLES.md)** - Real-world usage examples
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

## 🔄 Re-running Setup

The `.claudify` directory persists in your repository (git-ignored) to allow:
- **Re-initialization**: Run `/init-claudify` again with different options
- **Mode Changes**: Switch between minimal/standard/comprehensive setups
- **Updates**: Get newer versions of components when available
- **Experimentation**: Try different configurations without re-running setup.ps1

Simply run `/init-claudify` again at any time to reconfigure your Claude Code environment.

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

## 🚀 What's New in Version 1.4.0

### Opus 4 Agent Capabilities
- **Parallel Processing**: All agents analyze simultaneously (75% faster)
- **AI-Powered Generation**: Automatic code, test, and component creation
- **Confidence Scoring**: Every recommendation includes confidence levels
- **Extended Thinking**: Deep analysis for complex decisions
- **Modern Patterns**: Signals, Web Components, Cloud-Native support

### Key Improvements
- `/comprehensive-review` runs all agents in parallel
- Technical debt analysis includes ROI calculations
- Security scanning with AI-generated attack scenarios
- Test generation with property-based testing
- Frontend component generation from requirements

## 📚 Additional Documentation

- [CHANGELOG.md](CHANGELOG.md) - Version history and release notes (see v1.4.0)
- [VERSIONING.md](VERSIONING.md) - Versioning strategy and release process
- [SETUP-GUIDE.md](SETUP-GUIDE.md) - Detailed setup documentation

---

**Remember**: Minimal setup, maximum intelligence. Let Claude Code do what it does best!