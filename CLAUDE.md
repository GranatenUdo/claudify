# CLAUDE.md - Claudify System Documentation

## 🧠 CONTEXT
**System**: Claudify - Claude Code Setup System
**Version**: 4.0.0
**Purpose**: Automated configuration system for Claude Code in .NET/Angular projects
**Architecture**: Three-phase system with namespace detection

## 🏗️ SYSTEM ARCHITECTURE

### Three-Phase Implementation
1. **Bootstrap Phase** (setup.ps1)
   - Detects existing installations and versions
   - Creates `.claudify` directory with template components
   - Performs intelligent project namespace detection
   - Offers Standard or Comprehensive installation modes

2. **Configuration Phase** (Automatic)
   - Detects project namespace from .csproj files
   - Applies namespace throughout all components
   - Preserves existing CLAUDE.md and FEATURES.md
   - Generates project-specific documentation

3. **Runtime Phase** (Claude Code)
   - Components loaded from configured `.claude` directory
   - Agents operate with security-restricted tool access
   - Commands utilize specialized Opus 4 agents
   - Hooks provide automated workflows

### Project Detection and Template System
The setup uses a mustache-style template system with automatic project detection:

1. **Project Discovery**: Scans for all .csproj files in your repository
2. **Automatic Categorization**:
   - Web projects: `*.Web`, `*.UI`, `*.Frontend`
   - API projects: `*.Api`, `*.WebApi`
   - Test projects: `*Test*`, `*Tests`
3. **Template Variables**:
   - `{{WebProject}}` - Primary web project (e.g., `PTA.VineyardManagement.Web`)
   - `{{ApiProject}}` - API project (e.g., `PTA.VineyardManagement.Api`)
   - `{{ArchitectureTestProject}}` - Architecture tests (e.g., `PTA.VineyardManagement.ArchitectureTests`)
   - `{{ProjectNamespace}}` - Base namespace for backward compatibility
4. **Multi-Project Support**: If multiple web projects exist, prompts for primary selection
5. **Configuration**: Saves to `.claude/config/projects.json`

Example: 
- Template: `cd src/{{WebProject}}`
- Detected: `MyCompany.ProductName.Web` (from MyCompany.ProductName.Web.csproj)
- Result: `cd src/MyCompany.ProductName.Web`

## ⚡ CONFIGURATION RULES

### Project Structure Requirements
- **Standard .NET Layout**: Projects follow `src/[Namespace].Web`, `src/[Namespace].Api`
- **Test Organization**: Tests in `tests/[Namespace].*Tests` pattern
- **Angular Structure**: Frontend at `src/[Namespace].Web` with standard Angular layout
- **Convention-Based**: All projects follow established architectural patterns

### Automatic Configuration
- **Namespace Detection**: Extracts from .csproj files automatically
- **Path Resolution**: Applies namespace to all command paths
- **Documentation Updates**: Customizes CLAUDE.md and FEATURES.md
- **Validation**: Confirms all replacements successful

### Security Configuration
- **Agent Restrictions**: Each agent has minimal required tools
- **Code Reviewer**: Read, Edit, MultiEdit, Grep, Glob, LS only
- **Security Reviewer**: Read, Grep, Glob, LS, WebSearch, Bash only
- **Tech Lead**: Read, Write, Edit, Grep, Glob, LS, TodoWrite only
- **Frontend Developer**: Read, Write, Edit, MultiEdit, Grep, Glob, LS only

## 💻 IMPLEMENTATION PATTERNS

### PowerShell Configuration
```powershell
# Namespace detection function
function Get-ProjectNamespace {
    param([string]$TargetPath)
    
    $csprojFile = Get-ChildItem -Path $TargetPath -Recurse -Filter "*.csproj" | 
                  Where-Object { $_.Name -notlike "*Tests*" } | 
                  Select-Object -First 1
    
    if ($csprojFile) {
        $namespace = [System.IO.Path]::GetFileNameWithoutExtension($csprojFile.Name)
        $namespace = $namespace -replace '\.(Api|Web|Domain|Infrastructure)$', ''
        return $namespace
    }
    
    return Read-Host "Enter your project namespace"
}

# Configuration application
function Apply-ProjectConfiguration {
    param(
        [string]$Content,
        [string]$Namespace
    )
    return $Content -replace 'PTA\.VineyardManagement', $Namespace
}
```

### Component Structure
```
.claude/
├── commands/          # 40+ project-configured commands
├── agents/           # 30+ specialized agents
├── hooks/            # Automated workflows
├── generators/       # Scaffolding tools
└── validation/       # Quality checks
```

### Command Templates
All commands use mustache-style templates with specific project variables:
- Build commands: `cd src/{{WebProject}} && npm run build`
- Test commands: `dotnet test tests/{{ArchitectureTestProject}}`
- API updates: `cd src/{{WebProject}} && npm run update:api`
- API projects: `cd src/{{ApiProject}}`

These templates are automatically replaced with your actual project names during setup.

## 🔒 SECURITY ARCHITECTURE

### Agent Tool Matrix
Each agent operates with restricted permissions:
| Agent | Allowed Tools | Purpose |
|-------|--------------|---------|
| Code Reviewer | Read, Edit, Grep | Code quality analysis |
| Security Reviewer | Read, Grep, WebSearch | Vulnerability detection |
| Tech Lead | Read, Write, Edit, TodoWrite | Architecture decisions |
| Frontend Developer | Read, Write, Edit | UI implementation |
| Test Analyst | Read, Write, Bash | Test creation and execution |

### Security Principles
- **Least Privilege**: Minimal permissions per agent role
- **No Hardcoding**: All paths configured dynamically
- **Audit Trail**: All operations tracked
- **Validation**: Automatic verification of setup

## 📊 PERFORMANCE OPTIMIZATION

### Parallel Agent Execution
- Opus 4 agents support simultaneous analysis
- Commands utilize @Task for concurrent operations
- Bundle size monitoring integrated

### Configuration Performance
- Namespace detection: < 2 seconds
- File configuration: < 10 seconds for files
- Validation: < 1 second
- Total setup time: < 2 minutes

## 🔍 QUALITY ASSURANCE

### Automatic Validation
Setup performs these checks:
1. Namespace detected correctly
2. All files configured properly
3. No remaining template markers
4. Commands executable
5. Documentation generated

### Success Indicators
```powershell
✅ Setup Complete!
  ✓ Commands installed
  ✓ Agents configured
  ✓ Project namespace applied: YourCompany.YourProject
  ✓ Documentation generated
```

## 📈 VERSIONING

### Current Version: 4.0.0
- Interactive project configuration
- Full project name preservation with suffixes
- Multi-project support
- User confirmation and override capability
- Enhanced template variables

### Version Compatibility
- Supports .NET 8/9 projects
- Angular 17-19 compatible
- Works with standard project structures
- Cross-platform (Windows, Linux, macOS)

## 🚀 USAGE PATTERNS

### Standard Workflow
1. Run setup.ps1 with target repository
2. Choose Comprehensive installation
3. Automatic namespace detection occurs
4. Configuration applied to all components
5. Begin using Claude Code immediately

### Common Commands After Setup
```bash
/comprehensive-review     # Full code analysis
/add-backend-feature     # Create new API feature
/fix-frontend-bug        # Debug UI issues
/security-audit          # Security scanning
```

## 🤝 ENTERPRISE INTEGRATION

### CI/CD Support
- Azure DevOps pipeline templates included
- Docker containerization configured
- Automated testing integrated
- Deployment validation hooks

### Team Collaboration
- Consistent setup across all team members
- Shared configuration standards
- Unified development patterns
- Knowledge sharing through agents

## 📋 TROUBLESHOOTING

### Common Solutions
| Issue | Solution |
|-------|----------|
| Namespace not detected | Ensure .csproj exists in standard location |
| Commands fail | Verify project follows conventions |
| Agent errors | Check tool permissions in manifest |
| Documentation missing | Run setup in Comprehensive mode |

### Validation Commands
```bash
# Verify installation
claude /agents

# Test configuration
claude /comprehensive-review

# Check namespace application
grep -r "PTA.VineyardManagement" .claude/
```


---

**Claudify 4.0.0** - Interactive project configuration for Claude Code.