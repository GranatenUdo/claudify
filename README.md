# Claudify - Claude Code Configuration for .NET/Angular Projects

![Version](https://img.shields.io/badge/version-4.0.0-blue)
![Released](https://img.shields.io/badge/released-2025--08--20-green)

Claudify is a setup tool that configures Claude Code for .NET/Angular projects. It detects your project structure and applies project-specific configurations to commands and agents.

## Features

### Project Detection
- Detects Angular projects by finding `angular.json` files
- Detects .NET API projects by checking for `Microsoft.NET.Sdk.Web` in .csproj files
- Detects test projects by looking for `Microsoft.NET.Sdk` with "Test" in the project name
- Handles duplicate project names by prepending the parent folder name
- Provides interactive prompts for confirmation or manual entry when detection is uncertain

### Configuration
- Replaces template variables in commands with your actual project names
- Supports multiple projects (you can enter them comma-separated)
- Saves configuration to `.claude/config/projects.json`
- Preserves existing CLAUDE.md and FEATURES.md files (these are user-managed)

## Setup

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

1. **Project Detection**:
   - Scans for angular.json files
   - Scans for .csproj files with SDK type detection
   - Groups projects by type (Web, API, Test)

2. **Installation Mode**:
   - Minimal - Core components (typically 15-25 files)
   - Comprehensive - All available components (40 or more files)

3. **Configuration**:
   - Applies project names to command templates
   - Installs selected commands and agents
   - Preserves existing CLAUDE.md and FEATURES.md files

4. **Usage**:
   ```bash
   claude code
   /comprehensive-review
   ```

## How It Works

1. Scans your repository for project files (angular.json, .csproj)
2. Identifies project types based on SDK references and naming patterns
3. Replaces template placeholders in commands with your actual project names
4. Copies the configured commands and agents to your `.claude` directory
5. Optionally sets up hooks for workflow automation

## Supported Project Types

- .NET 8/9 Web APIs
- Angular 17-19 applications
- .NET test projects
- Multi-project solutions

## Repository Structure

```
claudify/
├── setup.ps1                     # Setup orchestrator
├── components-manifest.json      # Component registry
├── .claude/
│   ├── commands/                 # Command definitions
│   ├── agents/                   # Agent configurations
│   ├── hooks/                    # Automation workflows
│   └── generators/               # Code scaffolding tools
├── docs/                         # Documentation
└── VERSION                       # Current version (4.0.0)
```

## Security Considerations

- Each agent is restricted to specific tools based on its role
- No hardcoded paths or secrets in the configuration
- All configuration is stored locally in `.claude/config/`

## Documentation

- Configuration files are documented inline with comments
- For issues or questions, please use your organization's support channel
- The setup script checks for updates when run
- Additional documentation will be created in `.claude/docs/` after setup

## Version History

**4.0.0** - Current Release
- Project detection based on SDK types and file markers
- Automatic handling of duplicate project names
- Documentation files (CLAUDE.md, FEATURES.md) are preserved and user-managed
- Simplified installation with two clear options (Minimal/Comprehensive)

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

## Getting Started

1. Clone or download this repository
2. Run `setup.ps1 -TargetRepository "path/to/your/repo"`
3. Choose installation mode (Minimal or Comprehensive)
4. Review the detected projects and confirm or correct them
5. Begin using Claude Code with your configured commands