# Claudify - Claude Code Intelligent Setup

![Version](https://img.shields.io/badge/version-3.0.0-blue)
![Released](https://img.shields.io/badge/released-2025--08--05-green)
![Opus 4](https://img.shields.io/badge/agents-Opus%204%20Optimized-purple)

**Template Repository for Claude Code - Commands, Agents, and Tools**

Claudify is a comprehensive template repository that provides production-ready commands, agents, and tools for Claude Code. It uses intelligent tech stack detection to install only the components relevant to your project. Version 3.0.0 features Opus 4 optimized agents, proper security restrictions, and official Claude Code YAML format compliance.

## ✨ What's New in 3.0.0

### 🔒 Security & Best Practices
- **Agent Tool Restrictions** - Implemented Claude Code security best practices with principle of least privilege
- **Role-Based Access** - Each agent only has tools necessary for its function (reduced from 10-12 to 4-6 tools)
- **Tool Justifications** - Every granted permission documented with its purpose
- **Automated Compliance** - PowerShell script enforces security policies across all agents

### 🤖 Agent Management
- **New /agents Command** - Comprehensive agent management (list, create, edit, test, share)
- **Interactive Creation** - Wizard-based agent creation with security-first design
- **Best Practices Gap Analysis** - Identified and fixed 15 critical gaps in Claude Code implementation

### 📝 Documentation & Setup
- **🚀 Integrated Intelligent Setup** - Choose installation mode during setup (Standard/Comprehensive)
- **🔍 Enhanced Tech Detection** - Finds Angular/React/Vue in subdirectories like `ClientApp/`, `frontend/`
- **🧹 Clean Install Option** - Recommended for major version upgrades
- **📝 Auto-Generated Config** - Creates CLAUDE.md and FEATURES.md tailored to your stack (preserves existing)
- **🎯 Fixed Agent Mappings** - All commands now use available Claude agents
- **📁 Better Organization** - Documentation moved to docs/ folder
- **🛡️ File Preservation** - CLAUDE.md and FEATURES.md are now preserved during clean install
- **🔧 Path Fix** - Fixed documentation copying error for nested directories
- **📉 Simplified Setup** - Removed minimal mode, now only Standard and Comprehensive
- **🤖 Claude CLI Integration** - Simplified automatic initialization with optional domain context
- **📝 Documentation Automation** - All commands and agents include documentation update instructions
- **🧹 Clean Codebase** - Removed 14+ temporary test files for production readiness

## 🚀 Quick Start

### Step 1: Run Setup Script

#### Windows
```powershell
# From the claudify directory you downloaded/cloned:
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"
```

#### Linux/macOS  
```bash
# From the claudify directory you downloaded/cloned:
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

### Step 2: Initialize in Claude Code
```bash
# In your repository:
claude code

# Then run:
/init-claudify

# Or for standard mode:
/init-claudify --standard
```

### What Happens During Setup

The setup process has two distinct phases:

#### Phase 1: setup.ps1 (Run from Terminal)
1. **Checks existing installation** and version
2. **Creates minimal structure**:
   - `.claude/commands/init-claudify.md` (the only command installed)
   - `.claudify/` directory with ALL template resources (hidden cache)
3. **Updates .gitignore** to exclude `.claudify`
4. **Optionally launches Claude** to run init-claudify

#### Phase 2: /init-claudify (Run in Claude Code)
1. **Analyzes your repository**:
   - Detects backend (.NET, Go, Java, Python, Node.js)
   - Detects frontend (Angular, React, Vue, Svelte)
   - Searches subdirectories like `ClientApp/`, `frontend/`
   - Identifies patterns (multi-tenancy, DDD, async)

2. **Selects components intelligently**:
   - **Standard Mode**: ~15-25 core files
   - **Comprehensive Mode**: ~40+ files (recommended)
   - Copies from `.claudify/` to `.claude/` based on your stack

3. **Creates documentation**:
   - CLAUDE.md - Your project rules (preserved if exists)
   - FEATURES.md - Feature tracking (preserved if exists)

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

Claudify is a template repository that provides commands, agents, and tools for Claude Code. It works in two phases:

### Phase 1: Setup Script (setup.ps1)
The PowerShell setup script prepares your repository:

1. **Minimal Installation**
   - Creates `.claude/commands/` directory
   - Copies only the `init-claudify` command
   - Creates `.claudify/` directory with ALL template resources (for later use)
   - Adds `.claudify` to `.gitignore` (these are temporary resources)

2. **Version Tracking**
   - Detects existing installations
   - Recommends clean install for major updates
   - Creates metadata files for tracking

### Phase 2: Component Installation (/init-claudify)
The init-claudify command (run inside Claude Code) performs intelligent setup:

1. **Repository Analysis**
   - Detects your tech stack (backend, frontend, database)
   - Identifies patterns (DDD, multi-tenancy, repository pattern)
   - Analyzes architecture and project structure

2. **Intelligent Component Selection**
   - Based on detected stack, selects appropriate commands
   - Installs relevant agents for your technologies
   - Adds hooks and generators as needed
   - All components are copied from `.claudify/` to `.claude/`

3. **Documentation Generation**
   - Creates or preserves CLAUDE.md (project rules)
   - Creates or preserves FEATURES.md (feature tracking)
   - These files are where YOU define your project-specific requirements

### How Components Guide Claude

Commands and agents are **templates with instructions** that:
- Provide structured approaches to tasks
- Include prompts that guide Claude's analysis
- Suggest tool usage patterns
- Reference YOUR documentation (CLAUDE.md) for context

They don't automatically enforce patterns - they guide Claude to follow the patterns YOU define in CLAUDE.md.

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

Project-specific slash commands that provide structured approaches to common development tasks.

#### Command Categories

**Feature Development**
- `/add-backend-feature` - DDD-based API features with multi-tenant security
- `/add-frontend-feature` - UI features with accessibility and performance focus
- `/add-integration` - Third-party service integrations

**Code Quality & Maintenance**  
- `/fix-backend-bug`, `/fix-frontend-bug` - Systematic debugging with root cause analysis
- `/fix-backend-build-and-tests`, `/fix-frontend-build-and-tests` - Iterative build/test fixes
- `/review-backend-code`, `/review-frontend-code` - Security, performance, architecture review
- `/comprehensive-review` - Multi-agent holistic analysis
- `/refactor-code` - Intelligent code simplification
- `/optimize-performance` - Performance bottleneck analysis

**Analysis & Research**
- `/analyze-technical-debt` - Debt impact modeling and prioritization
- `/analyze-legacy-system` - Migration strategy planning
- `/analyze-domain-use-cases` - Business domain extraction
- `/do-extensive-research` - Deep multi-dimensional research with Opus 4
- `/quick-research` - Focused technical research

**Documentation & Updates**
- `/generate-documentation` - Technical documentation generation
- `/update-changelog` - Structured changelog management
- `/generate-marketing-material` - Value proposition creation

**Meta & Utilities**
- `/create-command-and-or-agent` - Generate new components
- `/sync-to-templates` - Share improvements back to Claudify
- `/init-claudify` - Advanced domain-specific configuration

#### Key Command Features
- **Extended Thinking**: Deep analysis using Opus 4 reasoning
- **Parallel Operations**: Multiple analyses run simultaneously
- **Domain Awareness**: Commands understand your project context
- **Security First**: Multi-tenant isolation enforced automatically
- **Test Intelligence**: Focus on requirements, not just passing tests

#### Example Command Usage
```bash
# Add a new feature with DDD and multi-tenant security
/add-backend-feature user permission management

# Fix a bug with systematic root cause analysis
/fix-backend-bug API returns 500 on user update

# Comprehensive code review with multiple perspectives
/comprehensive-review PR #42

# Deep research with evidence-based recommendations
/do-extensive-research microservices migration strategy
```

### Agents (Opus 4 Optimized)

All agents use the official Claude Code format with proper tool restrictions for security.

#### Agent Categories

**Technical Excellence**
- **Code Reviewer**: Multi-tenant SaaS security, DDD, production systems, 80% test coverage target
- **Code Simplifier**: Refactoring complex code, reducing cyclomatic complexity, applying DRY
- **Tech Lead**: Scalable architecture, technology trade-offs, 1K→100K+ org scaling

**Security & Compliance**
- **Security Reviewer**: OWASP Top 10, multi-tenant isolation, JWT/Auth0, GDPR compliance
- **Technical Debt Analyst**: Debt impact modeling, refactoring priorities, economic analysis
- **Legacy System Analyzer**: Migration strategies, modernization roadmaps

**Frontend & UX**
- **Frontend Developer**: AI component generation, modern framework patterns
- **UX Reviewer**: WCAG 2.1 AA compliance, mobile-first, offline-capable interfaces
- **Visual Designer**: Award-winning digital experiences, design systems

**Business & Strategy**
- **Business Domain Analyst**: Domain modeling, business rules extraction
- **Customer Value Translator**: Feature→benefit→value translation, ROI quantification
- **Marketing Strategist**: B2B SaaS positioning, competitive differentiation
- **Feature Analyzer**: Competitive intelligence, market positioning

**Research & Quality**
- **Researcher**: Multi-dimensional analysis, evidence-based recommendations
- **Test Quality Analyst**: Coverage intelligence, test pyramid optimization, flakiness detection
- **Technical Documentation Expert**: API docs, architecture guides, developer onboarding

#### How Agents Work
1. **Independent Context**: Each agent maintains its own context window
2. **Parallel Execution**: Up to 10 agents can work simultaneously  
3. **Tool Restrictions**: Each agent only has tools necessary for their role (security best practice)
4. **Extended Thinking**: Configure MAX_THINKING_TOKENS in .claude/settings.json (see docs/EXTENDED-THINKING-SETUP.md)

#### Agent Usage Examples
```
# Claude automatically delegates to appropriate agents:

"Review the security of this new API endpoint"
→ Security Reviewer agent activated

"This component is too complex, help me simplify it"  
→ Code Simplifier agent activated

"What's the best architecture for handling 50K concurrent users?"
→ Tech Lead agent activated

"Review this PR for production readiness"
→ Code Reviewer agent activated

# Agents collaborate on complex tasks:
"Review this new feature end-to-end"
→ Tech Lead: Architecture review
→ Security Reviewer: Security audit  
→ Code Reviewer: Code quality check
→ UX Reviewer: Interface assessment
→ Combined report with all perspectives
```

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

- **[SETUP-GUIDE.md](SETUP-GUIDE.md)** - Complete setup documentation
- **[EXTENDED-THINKING-SETUP.md](docs/EXTENDED-THINKING-SETUP.md)** - Configure extended thinking for agents (replaces max_thinking_tokens)
- **[AGENT-COLLABORATION-GUIDE.md](docs/AGENT-COLLABORATION-GUIDE.md)** - How to use Opus 4 agents effectively
- **[AGENT-COLLABORATION-EXAMPLES.md](docs/AGENT-COLLABORATION-EXAMPLES.md)** - Real-world usage examples
- **[DOCUMENTATION-BEST-PRACTICES.md](docs/DOCUMENTATION-BEST-PRACTICES.md)** - Documentation standards and guidelines
- **[DOCUMENTATION-UPDATE-IMPLEMENTATION-REPORT.md](docs/DOCUMENTATION-UPDATE-IMPLEMENTATION-REPORT.md)** - Implementation case study
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