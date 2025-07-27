# Claudify Setup Guide

## 🧠 Overview

Claudify provides an intelligent, minimal-footprint setup process for initializing Claude Code in any repository. Instead of copying dozens of files upfront, it uses a streamlined two-step approach that lets Claude Code analyze your project and install only what you need.

## 🎯 Core Philosophy

1. **Minimal Footprint**: Start with just one command file
2. **Intelligent Analysis**: Let Claude Code understand your project
3. **Interactive Setup**: Confirm and customize during installation
4. **Preservation**: Never overwrite existing customizations

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

Then continue in your repository:
```bash
claude code
```

In Claude Code:
```
/init-claudify "your project domain description"
```

## 📋 How It Works

### Step 1: Minimal Setup Script (setup.ps1)

The PowerShell script (~50 lines) performs these simple tasks:
1. Validates the target repository exists
2. Creates `.claude/commands` directory
3. Copies only the `init-claudify` command
4. Displays clear instructions for next steps

### Step 2: Intelligent Initialization (in Claude Code)

When you run `/init-claudify`, Claude Code:

#### 1. **Analyzes Your Repository**
- **Backend Technology**: ASP.NET Core, Node.js, Python, Go, Java
- **Frontend Framework**: Angular, React, Vue, Svelte
- **Database Systems**: SQL Server, PostgreSQL, MongoDB
- **Architectural Patterns**: Repository, DDD, CQRS, Multi-tenancy
- **Testing Frameworks**: xUnit, Jest, PyTest
- **Infrastructure**: Docker, Kubernetes, Cloud providers

#### 2. **Confirms Findings**
```
Based on my analysis:
- Backend: ASP.NET Core (.NET 8)
- Frontend: Angular 19
- Patterns: Repository, Result<T>, Multi-tenancy (OrganizationId)
- Domain: Multi-tenant SaaS for vineyard management

Is this correct? (Y/N)
```

#### 3. **Selects Components**
Based on your tech stack and the business domain provided:
- **Agents**: Only those relevant to your stack
- **Commands**: Specific to your technologies
- **Hooks**: Based on your patterns (e.g., tenant validation)
- **Generators**: For creating custom components

#### 4. **Generates Documentation**
- **CLAUDE.md**: Customized with your specific patterns and rules
- **FEATURES.md**: Template based on your domain
- **Settings**: Project-specific configuration

## 🏗️ Component Selection Modes

### Minimal Mode (~5-10 components)
Perfect for simple projects or getting started:
- Code Reviewer agent
- Essential commands (research, review)
- Basic documentation

### Standard Mode (~15-25 components) - Recommended
Intelligently selected based on your project:
- Relevant agents for your tech stack
- Backend/Frontend specific commands  
- Quality and testing tools
- Generators for customization

### Comprehensive Mode (~40+ components)
Everything available - for complex enterprise projects:
- All agents and commands
- Specialized tools
- Advanced generators
- Complete hook system

## 📊 What Gets Detected

### Technology Stack Detection
```yaml
Backend:
  - ASP.NET Core: *.csproj files
  - Node.js: package.json + node_modules
  - Python: requirements.txt, setup.py
  - Go: go.mod
  - Java: pom.xml, build.gradle

Frontend:
  - Angular: angular.json
  - React: react in package.json, *.jsx/tsx files
  - Vue: vue in package.json, *.vue files
  - Svelte: svelte in package.json

Database:
  - SQL Server: Microsoft.EntityFrameworkCore.SqlServer
  - PostgreSQL: Npgsql references
  - MongoDB: MongoDB.Driver references
```

### Pattern Detection
```yaml
Architectural Patterns:
  - Repository: *Repository*.cs files
  - Result Pattern: Result<T> usage
  - Multi-tenancy: OrganizationId/TenantId/CompanyId fields
  - DDD: Domain/Application/Infrastructure folders
  - CQRS: Commands/Queries separation
```

## 🛡️ Safety Features

### Preservation
- Never overwrites existing files
- Detects and respects current setup
- Only adds missing components

### Interactive Confirmation
- Shows what will be installed
- Allows customization before proceeding
- Option to select different modes

### Intelligent Defaults
- Recommends based on your patterns
- Suggests best practices for your stack
- Adapts to your coding style

## 📁 What Gets Created

### Directory Structure
```
your-repo/
├── .claude/
│   ├── commands/        # Your selected commands
│   ├── agents/          # Your selected agents  
│   ├── hooks/           # Validation hooks (if needed)
│   ├── generators/      # Component generators
│   └── settings.json    # Project configuration
├── CLAUDE.md           # Customized instructions
└── FEATURES.md         # Domain-specific template
```

### Example CLAUDE.md (Generated)
```markdown
# CLAUDE.md - Multi-tenant Vineyard Management

## 🧠 CONTEXT
**System**: Multi-tenant SaaS Application
**Stack**: ASP.NET Core (.NET 8) + Angular 19
**Security**: JWT with OrganizationId isolation

## ⚡ CRITICAL RULES

### Architecture
- **Result<T>**: All service methods return Result<T>, never throw
- **Repository Pattern**: Data access only via repositories
- **OrganizationId Scoping**: EVERY query must filter by OrganizationId

### Security (CRITICAL)
- ❌ NEVER accept userId in API endpoints
- ❌ NEVER bypass OrganizationId filtering
- ✅ ALWAYS use ICurrentUserService

[... customized for your patterns ...]
```

## 🔄 Updating Components

### Adding New Components
After setup, you can:
1. Use generators to create new commands/agents
2. Manually add components from the claudify library
3. Use `/sync-to-templates` to share back

### Checking for Updates
The init command can be re-run to:
- Detect new components available
- Add missing components
- Update documentation

## ❓ FAQ

**Q: What if detection is wrong?**
A: The init command is interactive - you can correct any misdetections.

**Q: Can I run this on an existing Claude setup?**
A: Yes! It will detect existing components and only add what's missing.

**Q: How do I know what components are available?**
A: Check `components-manifest.json` for the full catalog.

**Q: Can I create a custom selection mode?**
A: Yes! Edit the manifest to add your own selection rules.

## 🎯 Best Practices

1. **Provide Clear Domain Description**
   - Good: "multi-tenant SaaS for project management with Kanban boards"
   - Bad: "web app"

2. **Review Generated Files**
   - Check CLAUDE.md for accuracy
   - Customize FEATURES.md with your actual features
   - Adjust settings.json if needed

3. **Use Appropriate Mode**
   - Start with Standard mode
   - Use Minimal for simple scripts
   - Use Comprehensive for enterprise apps

4. **Keep Components Updated**
   - Re-run init command periodically
   - Check for new components
   - Contribute improvements back

## 🚀 Next Steps

After setup:
1. Try `/add-backend-feature` to create your first feature
2. Use `/comprehensive-review` for code quality checks
3. Run `/help` to see all available commands
4. Create custom components with generators

---

**Remember**: Minimal setup, maximum intelligence. Let Claude Code do what it does best!