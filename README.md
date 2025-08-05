# Claudify - Claude Code Intelligent Setup

![Version](https://img.shields.io/badge/version-2.0.1-blue)
![Released](https://img.shields.io/badge/released-2025--08--04-green)
![Opus 4](https://img.shields.io/badge/agents-Opus%204%20Optimized-purple)

**Intelligent Setup, Maximum Capability - Now with Opus 4 Optimized Agents**

Claudify provides an intelligent, streamlined setup process for initializing Claude Code in any repository. Version 2.0.1 includes enhanced Angular detection for enterprise projects and Opus 4 optimized agents that deliver **75% faster analysis** through parallel processing and AI-powered solution generation.

## ✨ What's New in 2.0.1

- **🚀 Integrated Intelligent Setup** - Choose installation mode during setup (Standard/Comprehensive)
- **🔍 Enhanced Tech Detection** - Finds Angular/React/Vue in subdirectories like `ClientApp/`, `frontend/`
- **🧹 Clean Install Option** - Recommended for major version upgrades
- **📝 Auto-Generated Config** - Creates CLAUDE.md and FEATURES.md tailored to your stack (preserves existing)
- **🎯 Fixed Agent Mappings** - All commands now use available Claude agents
- **📁 Better Organization** - Documentation moved to docs/ folder
- **🛡️ File Preservation** - CLAUDE.md and FEATURES.md are now preserved during clean install
- **🔧 Path Fix** - Fixed documentation copying error for nested directories
- **📉 Simplified Setup** - Removed minimal mode, now only Standard and Comprehensive
- **🤖 Claude CLI Integration** - Automatic initialization with optional domain context

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

### What Happens During Setup

The intelligent setup script will:

1. **Version Check** - Detects existing installations and recommends clean install for major updates
2. **Technology Detection** - Automatically detects your tech stack:
   - Backend: .NET/C#, Go, Java, Python, Node.js
   - Frontend: Angular, React, Vue, Svelte (including subdirectories like `ClientApp/`)
   - Multi-tenant patterns
   - Database and infrastructure

3. **Installation Mode Selection** - Choose your setup:
   - **[S] Standard** - Core components for your stack (~15-25 files)
   - **[C] Comprehensive** - Everything available (~40+ files) **[RECOMMENDED]**
   - **[N] None** - Manual setup only

4. **Automatic Installation** - Based on your selection:
   - Installs relevant commands and agents
   - Configures hooks and tools
   - Generates intelligent CLAUDE.md and FEATURES.md
   - Creates `.claudify` directory for re-running setup

5. **Claude CLI Integration** (NEW) - Simplified automatic initialization:
   - Prompts for optional domain description
   - Automatically runs `/init-claudify` with Opus model
   - Uses `--dangerously-skip-permissions` for streamlined setup
   - Requires approval for individual tool permissions

### After Installation

```bash
# Open terminal in your repository
claude code

# Try a command
/comprehensive-review
```

For advanced customization after setup:
```
/init-claudify "your specific domain requirements"
```

## 📁 What This Repository Contains

```
claudify/
├── setup.ps1                     # Advanced setup script with full deployment
├── components-manifest.json      # Available components catalog (v1.4.0)
├── README.md                     # This file
├── SETUP-GUIDE.md                # Complete documentation
├── CHANGELOG.md                  # Version history
├── docs/
│   ├── AGENT-COLLABORATION-GUIDE.md  # How to use Opus 4 agents
│   ├── AGENT-COLLABORATION-EXAMPLES.md # Real-world examples
│   └── ... # Other documentation
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

### Step 1: Intelligent Setup (setup.ps1)
The setup script provides a complete installation experience:

1. **Version Management**
   - Detects existing installations
   - Compares versions and recommends clean install for major updates
   - Tracks installation metadata

2. **Tech Stack Detection** 
   - Automatically analyzes your repository
   - Detects backend (C#, Go, Java, Python, Node.js)
   - Finds frontend frameworks in any directory (including `ClientApp/`, `frontend/`, etc.)
   - Identifies multi-tenant patterns

3. **Intelligent Component Installation**
   - Choose from Standard or Comprehensive modes
   - Installs appropriate commands and agents for your stack
   - Generates customized CLAUDE.md and FEATURES.md
   - Sets up hooks, generators, and validation tools

### Step 2: Advanced Customization (Optional)
For domain-specific configuration, run `/init-claudify` in Claude Code to:

- Fine-tune the tech stack detection
- Add domain-specific business rules
- Configure multi-tenant isolation
- Customize agent selection
- Set up specialized workflows

## 📦 Installation Modes

### Standard Mode (~15-25 files)
Recommended for most projects:
- **Commands**: Core commands + backend/frontend development commands
- **Agents**: `code-reviewer`, `tech-lead`, `researcher`, `code-simplifier`, `technical-debt-analyst`, `test-quality-analyst`, `frontend-developer`
- **Extras**: Generators for custom components, quality hooks

### Comprehensive Mode (~40+ files) **[RECOMMENDED]**
Complete Claudify experience with all features:
- **Commands**: 28+ commands covering all development scenarios
- **Agents**: 19 specialized agents with Opus 4 optimizations
- **Tools**: Agent tools, generators, hooks, validation scripts
- **Features**: Multi-tenant support, infrastructure analysis, marketing tools

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

- **[AGENT-COLLABORATION-GUIDE.md](docs/AGENT-COLLABORATION-GUIDE.md)** - How to use Opus 4 agents effectively
- **[AGENT-COLLABORATION-EXAMPLES.md](docs/AGENT-COLLABORATION-EXAMPLES.md)** - Real-world usage examples
- **[DOCUMENTATION-BEST-PRACTICES.md](docs/DOCUMENTATION-BEST-PRACTICES.md)** - Documentation standards and guidelines
- **[DOCUMENTATION-UPDATE-IMPLEMENTATION-REPORT.md](docs/DOCUMENTATION-UPDATE-IMPLEMENTATION-REPORT.md)** - Implementation case study
- **[SETUP-GUIDE.md](SETUP-GUIDE.md)** - Complete setup documentation
- **[META-GENERATOR-README.md](templates/META-GENERATOR-README.md)** - Create new generators

## ❓ Common Questions

**Q: Why streamlined setup?**  
A: Claudify provides a focused setup process, then intelligently installs components based on your actual tech stack and needs.

**Q: What if I already have a Claude setup?**  
A: Version 2.0.1 detects existing installations and offers clean install for major updates or normal update for minor versions.

**Q: Can I change my installation mode later?**  
A: Yes! Run setup.ps1 again or use `/init-claudify` in Claude Code for advanced customization.

**Q: How do I contribute improvements?**  
A: Create components in your project and use `/sync-to-templates` to share them back.

**Q: What's the difference between setup modes?**  
A: Standard = core features for your stack, Comprehensive = everything available (recommended).

## 🔄 Re-running Setup

The `.claudify` directory persists in your repository (git-ignored) to allow:
- **Re-initialization**: Run `/init-claudify` again with different options
- **Mode Changes**: Switch between standard/comprehensive setups
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

## 🔧 Troubleshooting

### Claude CLI Integration

**Q: How does the automatic Claude initialization work?**  
A: After installing components, the setup script:
1. Prompts you to optionally describe your project domain
2. Changes to your project directory
3. Runs `claude --model opus --dangerously-skip-permissions "/init-claudify [your description]"`
4. Claude will ask for permission to use various tools - approve them to complete setup

**Q: Why does Claude still ask for permissions?**  
A: Claude has two security levels:
- Initial command permission (bypassed with `--dangerously-skip-permissions`)
- Individual tool permissions (cannot be bypassed for security reasons)

**Q: What permissions will Claude ask for?**  
A: When running `/init-claudify`, Claude will request permission to:
- Use Bash to check project structure and versions
- Read files to detect your technology stack
- Write configuration files (CLAUDE.md, FEATURES.md)
- Copy components to your .claude directory

**Q: How long does the init-claudify process take?**  
A: Typically 5-10 minutes, depending on your project size and selected mode (standard vs comprehensive).

**Q: Claude CLI is not found**  
A: Ensure Claude CLI is installed and in your PATH:
- Windows: Check if `claude` works in Command Prompt
- Mac/Linux: Check if `claude` works in Terminal
- Installation guide: https://claude.ai/code

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

**Remember**: Intelligent setup, maximum capability. Let Claude Code do what it does best!