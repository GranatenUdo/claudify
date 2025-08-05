# CLAUDE.md - Claudify Development Guidelines

## 🧠 CONTEXT
**System**: Claudify - Claude Code Intelligent Setup Toolkit
**Stack**: PowerShell + Claude Code CLI + Opus 4 Agents
**Version**: 3.0.0
**Purpose**: Plugin-based component system that intelligently configures Claude Code environments
**Architecture**: Three-phase system (Bootstrap → Component Selection → Runtime)

## 🏗️ HOW CLAUDIFY WORKS

### Three-Phase Architecture
1. **Bootstrap Phase** (setup.ps1)
   - Detects existing installations and versions
   - Creates `.claudify` directory with all template components
   - Runs intelligent tech stack detection (searches root and subdirs like ClientApp/)
   - Offers Standard (~15-25 files) or Comprehensive (~40+ files) installation

2. **Component Selection Phase** (init-claudify command)
   - Reads `components-manifest.json` as component registry
   - Dynamically selects components based on detected tech stack
   - Installs commands, agents, hooks, and tools to `.claude` directory
   - Generates customized CLAUDE.md and FEATURES.md (preserves existing)

3. **Runtime Phase** (Claude Code execution)
   - Components loaded from `.claude` directory
   - Each agent has restricted tool access based on security matrix
   - Commands leverage specialized Opus 4 agents for parallel analysis
   - Hooks provide automated workflows (pre-commit, add-context, etc.)

### Key Innovation: Component Intelligence
- **Tech Stack Detection**: Finds Angular/React/Vue even in subdirectories
- **Pattern Recognition**: Detects DDD, multi-tenancy, repository pattern
- **Selective Installation**: Only installs relevant components for your stack
- **Security Matrix**: Each agent gets minimal required tools (principle of least privilege)

## ⚡ CRITICAL RULES

### Repository Structure
- **setup.ps1**: Bootstrap orchestrator - version checking, clean install logic
- **.claude/**: Runtime components (populated during setup)
- **.claudify/**: Template source (created by setup, persists for updates)
- **templates/generators/**: Component factories (command, agent, hook generators)
- **scripts/**: Analysis tools (tech-stack-detector.ps1, restrict-agent-tools-v2.ps1)
- **components-manifest.json**: Component registry with metadata and dependencies

### Development Principles
- **Security First**: Every agent follows principle of least privilege via tool matrix
- **Cross-Platform**: All PowerShell must work on Windows, Mac, Linux
- **Backward Compatible**: Never break existing installations
- **User Files Sacred**: NEVER overwrite CLAUDE.md or FEATURES.md without permission
- **Clean Code**: No temporary test files in production releases
- **Modular Design**: Each component is self-contained and replaceable

### Agent Tool Access Rules (Enforced by restrict-agent-tools-v2.ps1)
- **Code Reviewer**: Read, Edit, MultiEdit, Grep, Glob, LS only
- **Security Reviewer**: Read, Grep, Glob, LS, WebSearch, Bash only
- **Tech Lead**: Read, Write, Edit, Grep, Glob, LS, TodoWrite only
- **Frontend Developer**: Read, Write, Edit, MultiEdit, Grep, Glob, LS only
- **Test Quality Analyst**: Read, Write, Grep, Glob, LS, Bash only
- **Researcher**: Read, WebSearch, WebFetch, Write, TodoWrite only
- **Infrastructure Architect**: Full access to infrastructure tools only
- **NO AGENT** should have unrestricted tool access - each has justifications

## 💻 DEVELOPMENT PATTERNS

### PowerShell Standards
```powershell
# Parameter validation required
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetRepository,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Standard", "Comprehensive", "None")]
    [string]$Mode = "Standard"
)

# Error handling
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Cross-platform paths
$path = Join-Path $PSScriptRoot "relative" "path"
```

### Component Creation Pattern
```powershell
# 1. Use generators for consistency
.\.claude\generators\command-generator.ps1
.\.claude\generators\agent-generator.ps1

# 2. Test locally first
# 3. Update components-manifest.json
# 4. Run validation scripts
# 5. Create PR with detailed description
```

### Version Management
- **Major**: Breaking changes or major feature additions
- **Minor**: New features, backward compatible
- **Patch**: Bug fixes only
- Always update VERSION file and CHANGELOG.md

## 🔒 SECURITY CHECKLIST
- [ ] Agent tool access follows least privilege
- [ ] No hardcoded paths or credentials
- [ ] PowerShell scripts validate all inputs
- [ ] File operations check permissions first
- [ ] User files preserved during updates

## 🔍 QUICK REFERENCE

### Essential Commands
- `/init-claudify` - Initialize Claude Code in a repository
- `/comprehensive-review` - Full multi-agent code analysis  
- `/create-command-and-or-agent` - Generate new components
- `/sync-to-templates` - Share improvements back
- `/agents` - Manage agents (list, create, edit, test)

### Key Files
- **components-manifest.json** - Component registry and metadata
- **SETUP-GUIDE.md** - Complete setup documentation
- **VERSIONING.md** - Release process documentation
- **restrict-agent-tools-v2.ps1** - Enforce security policies

### Testing New Features
```bash
# 1. Run setup in test repository
.\setup.ps1 -TargetRepository "C:\test\repo"

# 2. Validate installation
.\scripts\validation\validate-setup.ps1

# 3. Test in Claude Code
claude code
/init-claudify "test domain"
```

### Common Issues
- **"File not found"**: Check cross-platform path separators
- **"Access denied"**: Run validation scripts first
- **"Command not found"**: Verify components-manifest.json entry
- **"Agent error"**: Check tool access permissions

## 🎯 ARCHITECTURAL PATTERNS

### Component System Design
- **Plugin Architecture**: Each component (command/agent/hook) is a self-contained plugin
- **Factory Pattern**: Generators create components from templates with consistent structure
- **Strategy Pattern**: Security matrix applies different tool access strategies per agent
- **Command Pattern**: All commands follow consistent execution and documentation format

### Performance Optimizations
- **Parallel Agent Execution**: Opus 4 agents analyze simultaneously (40-60% faster)
- **Template Caching**: templates/generators/template-cache.ps1 improves repeated operations
- **Lazy Loading**: Components loaded on-demand, not all at startup
- **Selective Installation**: Only relevant components installed based on tech stack

### Security Architecture
- **Defense in Depth**: Multiple security layers (tool restrictions, file permissions, validation)
- **Principle of Least Privilege**: Minimal required tools per agent role
- **Audit Trail**: All agent tool usage can be tracked and validated
- **Sandboxing**: Agents operate within defined boundaries

## 📊 PERFORMANCE OPTIMIZATION

### Parallel Processing
- All Opus 4 agents support parallel analysis
- Use Task tool for concurrent operations in commands
- Batch file operations when possible
- Cache analysis results appropriately

### Script Performance
```powershell
# Good: Single file read
$manifest = Get-Content "components-manifest.json" | ConvertFrom-Json

# Bad: Multiple reads
$version = (Get-Content "components-manifest.json" | ConvertFrom-Json).version
$components = (Get-Content "components-manifest.json" | ConvertFrom-Json).components
```

### Known Performance Gains
- Comprehensive review: 30-45 min (parallel) vs 60-90 min (sequential)
- Tech stack detection: Searches multiple directories efficiently
- Component installation: Selective copying reduces setup time

## 🚀 RELEASE PROCESS

1. Update VERSION file
2. Run all validation scripts
3. Update CHANGELOG.md with release notes
4. Create release commit: "feat: Release version X.Y.Z..."
5. Tag release: `git tag vX.Y.Z`
6. Update README.md if needed
7. Clean any temporary files

## 🤝 CONTRIBUTION GUIDELINES

### Adding New Components
1. Create using appropriate generator
2. Follow existing naming conventions
3. Include comprehensive documentation
4. Add to components-manifest.json
5. Test across platforms
6. Submit PR with examples

### Documentation Updates
- Keep README.md focused on quick start
- Detailed guides go in docs/ folder
- Update FEATURES.md for new capabilities
- Include examples in all documentation

## 🔧 IMPORTANT IMPLEMENTATION DETAILS

### Component Manifest Structure
The `components-manifest.json` serves as the central registry:
- **agents**: Array of available agents with tags and dependencies
- **commands**: Categorized by type (essential, backend, frontend, quality, etc.)
- **agentTools**: Specialized tools for specific agents
- **generators**: Component creation tools
- **hooks**: Event-driven automation scripts
- **selectionRules**: Logic for standard vs comprehensive installation

### Tech Stack Detection Logic
Located in `scripts/analysis/tech-stack-detector.ps1`:
- Searches for framework indicators (.csproj, package.json, angular.json)
- Checks common subdirectories (ClientApp/, frontend/, src/)
- Detects authentication patterns (JWT, Auth0)
- Identifies multi-tenancy by searching for tenant/organization fields

### Claude CLI Integration
The setup process ends with:
```powershell
claude --model opus --dangerously-skip-permissions "/init-claudify $domain"
```
This allows automatic initialization but still requires tool permission approval.

### Directory Persistence Strategy
- `.claudify/`: Contains template sources, persists after setup (git-ignored)
- `.claude/`: Runtime components, can be regenerated from .claudify
- This allows re-running setup with different options without re-downloading

---
**Remember**: Claudify is a sophisticated plugin system that intelligently adapts to each project. Understanding its three-phase architecture (Bootstrap → Component Selection → Runtime) is key to contributing effectively.