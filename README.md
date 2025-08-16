# Claudify - Enterprise Claude Code Setup System

![Version](https://img.shields.io/badge/version-4.0.0-blue)
![Released](https://img.shields.io/badge/released-2025--08--05-green)
![Opus 4](https://img.shields.io/badge/agents-Opus%204%20Optimized-purple)

**Automated Project Configuration for Claude Code**

Claudify provides automated Claude Code setup for .NET/Angular applications. It detects your project namespace and configures commands and agents accordingly.

## ✨ Core Capabilities

### 🎯 Intelligent Project Detection
- **Automatic Namespace Discovery** - Detects your project namespace from .csproj files
- **Dynamic Path Configuration** - All commands adapt to your project structure
- **Convention-Based Setup** - Works with standard .NET/Angular project layouts
- **Zero Manual Configuration** - Fully automated for compliant architectures
- **Multi-Project Support** - Handles complex solution structures

### 🤖 Agent Suite
- **Specialized Agents** - Each optimized for specific development tasks
- **Security-First Design** - Role-based tool access with principle of least privilege
- **Parallel Execution** - Multiple agents can work simultaneously
- **Architecture Support** - Helps maintain consistency across your codebase

### 📝 Automation Features
- **Project-Specific Configuration** - Adapts commands to your namespace and structure
- **Documentation Generation** - Creates CLAUDE.md tailored to your project
- **Test Support** - Includes test generators and quality analyzers
- **CI/CD Support** - Azure DevOps pipeline templates included

## 🚀 Setup Process

### Prerequisites
- PowerShell 7+ (cross-platform)
- Claude Code CLI installed
- .NET/Angular project following standard conventions

### Installation

#### Windows
```powershell
# From claudify directory:
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"
```

#### Linux/macOS  
```bash
# From claudify directory:
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

### What Happens During Setup

1. **Project Analysis** - Automatically detects:
   - Project namespace from .csproj files
   - Angular application structure
   - Test project organization
   - Database and infrastructure patterns

2. **Component Selection** - Choose your installation:
   - **[S] Standard** - Essential components (~15-25 files)
   - **[C] Comprehensive** - Full suite (~40+ files) **[RECOMMENDED]**
   - **[N] None** - Manual configuration

3. **Automatic Configuration** - Claudify will:
   - Apply your project namespace throughout
   - Install appropriate commands and agents
   - Configure security policies
   - Generate project documentation

4. **Immediate Productivity** - Start using Claude Code:
   ```bash
   claude code
   /comprehensive-review
   ```

## 📊 What It Does

Claudify configures Claude Code for your specific project by:
- Detecting your project namespace from .csproj files
- Applying that namespace to all commands
- Installing agents and commands based on your project type
- Setting up hooks for automated workflows

## 🏗️ Architecture Support

Claudify is optimized for enterprise architectures featuring:
- **.NET 8/9** backend with Domain-Driven Design
- **Angular 19** frontend with signals architecture
- **Entity Framework Core** with repository pattern
- **Multi-tenant** data isolation
- **Azure DevOps** CI/CD pipelines
- **Docker** containerization
- **SQL Server** database

## 📁 Repository Structure

```
claudify/
├── setup.ps1                     # Setup orchestrator
├── components-manifest.json      # Component registry
├── .claude/
│   ├── commands/                 # Optimized commands
│   ├── agents/                   # Specialized agents
│   ├── hooks/                    # Automation workflows
│   └── generators/               # Code scaffolding tools
├── docs/                         # Documentation
└── VERSION                       # Current version (4.0.0)
```

## 🔒 Security & Compliance

- **Least Privilege Access** - Each agent has minimal required permissions
- **No Hardcoded Secrets** - All configuration externalized
- **Audit Trail Support** - Full command history and tracking
- **Enterprise SSO Ready** - Works with your authentication

## 🤝 Support & Resources

- **Documentation**: See `/docs` folder for detailed guides
- **Issues**: Report via your internal support channel
- **Updates**: Automatic version checking on setup
- **Training**: Available for enterprise teams

## 📈 Version History

**4.0.0** (Current) - Interactive Configuration Release
- Interactive project detection with user confirmation
- Full project names with suffixes preserved
- Multi-project support with selection
- New template variables for each project type

**3.0.0** - Template System
- Automatic namespace detection
- Opus 4 agent optimization
- Enterprise security policies
- Comprehensive documentation automation

## 🚦 Getting Started

1. **Download** Claudify to your local machine
2. **Run** setup.ps1 pointing to your repository
3. **Choose** Comprehensive installation
4. **Start** developing with Claude Code immediately

---

**Claudify** - Automated Claude Code configuration for .NET/Angular projects.