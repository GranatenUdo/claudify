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
   - Performs intelligent project detection
   - Offers Minimal or Comprehensive installation modes

2. **Configuration Phase** (Automatic)
   - Detects Angular projects via angular.json
   - Detects .NET APIs via Microsoft.NET.Sdk.Web
   - Detects test projects via Microsoft.NET.Sdk with 'Test' in name
   - Handles duplicate project names intelligently
   - Preserves existing CLAUDE.md and FEATURES.md (user-managed)

3. **Runtime Phase** (Claude Code)
   - Components loaded from configured `.claude` directory
   - Agents operate with security-restricted tool access
   - Commands utilize specialized Opus 4 agents
   - Hooks provide automated workflows

### Project Detection and Template System
The setup uses a mustache-style template system with automatic project detection:

1. **Project Discovery**: 
   - Angular: Scans for angular.json files
   - .NET: Scans for .csproj files with SDK detection
2. **Automatic Categorization**:
   - Web projects: Folders containing angular.json
   - API projects: Projects with Microsoft.NET.Sdk.Web
   - Test projects: Projects with Microsoft.NET.Sdk and 'Test' in name
3. **Template Variables**:
   - `{{WebProject}}` - Primary web project (e.g., `MyCompany.Product.Web`)
   - `{{ApiProject}}` - API project (e.g., `MyCompany.Product.Api`)
   - `{{ArchitectureTestProject}}` - Architecture tests (e.g., `MyCompany.Product.ArchitectureTests`)
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
- **Project Detection**: Smart detection based on file markers and SDK types
- **Duplicate Handling**: Prepends parent folder for duplicate names
- **Path Resolution**: Applies project names to all command paths
- **Documentation**: CLAUDE.md and FEATURES.md remain user-managed
- **Validation**: Confirms all replacements successful

### Convention Detection Modes
- **Smart Mode (Default)**: Pre-analyzes entire codebase (~60s), caches conventions, 95-100% accuracy
- **Adaptive Mode**: On-demand examination of 2-3 files per command, 90% accuracy, always current
- **Automatic Fallback**: Commands use cache if available, examine code if not
- **Refresh Analysis**: Run `.\setup.ps1 -RefreshAnalysis` to update cached conventions

### Security Configuration
- **Agent Restrictions**: Each agent has minimal required tools
- **Code Reviewer**: Read, Edit, MultiEdit, Grep, Glob, LS only
- **Security Reviewer**: Read, Grep, Glob, LS, WebSearch, Bash only
- **Tech Lead**: Read, Write, Edit, Grep, Glob, LS, TodoWrite only
- **Frontend Developer**: Read, Write, Edit, MultiEdit, Grep, Glob, LS only

## 💻 IMPLEMENTATION PATTERNS

### PowerShell Configuration
```powershell
# Project detection example
function Detect-Projects {
    param([string]$TargetPath)
    
    # Angular detection
    $angularProjects = Get-ChildItem -Path $TargetPath -Recurse -Filter "angular.json"
    
    # .NET API detection
    $apiProjects = Get-ChildItem -Path $TargetPath -Recurse -Filter "*.csproj" | 
                   Where-Object { 
                       (Get-Content $_.FullName -Raw) -match 'Microsoft\.NET\.Sdk\.Web'
                   }
    
    # Test project detection
    $testProjects = Get-ChildItem -Path $TargetPath -Recurse -Filter "*.csproj" | 
                    Where-Object { 
                        $_.Name -like "*Test*" -or $_.Name -like "*Tests"
                    }
    
    return @{
        Web = $angularProjects
        Api = $apiProjects
        Tests = $testProjects
    }
}

# Handle duplicate names
function Resolve-DuplicateNames {
    param($Projects)
    $nameGroups = $Projects | Group-Object -Property Name
    foreach ($group in $nameGroups) {
        if ($group.Count -gt 1) {
            foreach ($project in $group.Group) {
                $parentFolder = Split-Path (Split-Path $project.FullPath -Parent) -Leaf
                $project.Name = "$parentFolder.$($project.Name)"
            }
        }
    }
    return $Projects
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
3. Choose convention detection mode (Smart recommended)
4. Automatic project detection and configuration
5. Begin using Claude Code with convention-aware generation

### Common Commands After Setup
```bash
/comprehensive-review     # Full code analysis
/add-backend-feature     # Create new API feature (matches your conventions)
/fix-frontend-bug        # Debug UI issues (respects your patterns)
/security-audit          # Security scanning (aligns with architecture)
```

### Convention Detection Commands
```bash
.\setup.ps1 -RefreshAnalysis  # Update convention cache after code changes
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
grep -r "MyCompany.Product" .claude/
```


---

**Claudify 4.0.0** - Interactive project configuration for Claude Code.