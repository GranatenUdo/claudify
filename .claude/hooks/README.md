# Claude Code Hooks - Claudify Edition

Parameterized hooks that adapt to your project's specific patterns and requirements.

## Overview

Claude Code hooks allow you to intercept and enhance various operations. The Claudify hooks system provides intelligent, self-adapting hooks that automatically configure themselves based on your project's technology stack and patterns.

## Available Hooks

### 1. **add-context.ps1** (User Prompt Submit)
Automatically adds contextual information to your prompts based on:
- Detected tech stack (.NET, Node.js, Python, etc.)
- Framework usage (Angular, React, Vue)
- Architecture patterns (multi-tenancy, repository pattern, Result<T>)
- Current task context (backend, frontend, security, testing)

**Features:**
- Auto-detects project configuration from files
- Reads patterns from CLAUDE.md if available
- Provides framework-specific guidance
- Adds security reminders for sensitive operations

### 2. **validate-tenant-scoping.ps1** (Pre Tool Use)
Ensures multi-tenant isolation is maintained in all code changes:
- Detects tenant field names (OrganizationId, TenantId, etc.)
- Validates repository queries include tenant filtering
- Checks for hardcoded tenant IDs
- Warns about missing tenant context in API calls

**Features:**
- Adapts to your specific tenant field naming
- Language-specific validation (.NET, Java, Python, JS/TS)
- Configurable strictness levels
- Security-focused blocking on critical issues

### 3. **pre-commit-quality-check.ps1** (User Prompt Submit)
Enforces quality standards before Git commits:
- Syntax and compilation checks
- Code quality analysis (complexity, TODOs, debug statements)
- Security validation (hardcoded credentials, tenant isolation)
- Test execution (if configured)
- Documentation requirements

**Features:**
- Multi-language support
- Configurable quality thresholds
- Fast, focused checks
- Clear actionable feedback

## Installation

### Quick Install (Recommended)
```powershell
# From your project root
./.claude/hooks/install-hooks.ps1
```

### Interactive Install
```powershell
# Choose which hooks to install
./.claude/hooks/install-hooks.ps1 -Interactive
```

### Install Profiles
```powershell
# Minimal - Just context enhancement
./.claude/hooks/install-hooks.ps1 -Minimal

# Comprehensive - All available hooks
./.claude/hooks/install-hooks.ps1 -Comprehensive
```

## Configuration

### Project Configuration (project-hooks-config.json)
```json
{
  "hooks": {
    "pre-tool-use": {
      "validate-tenant-scoping": {
        "enabled": true,
        "config": {
          "tenantField": "OrganizationId",
          "strictMode": false
        }
      }
    },
    "user-prompt-submit": {
      "add-context": {
        "enabled": true
      }
    }
  },
  "projectInfo": {
    "techStack": {
      "backend": ".NET",
      "frontend": "Angular"
    },
    "features": {
      "multiTenant": true
    }
  }
}
```

### Global Configuration
Hooks respect the global Claude Code settings while adding project-specific enhancements.

## How Hooks Adapt

### Tech Stack Detection
Hooks automatically detect:
- **Backend**: .NET (*.csproj), Node.js (package.json), Python (*.py)
- **Frontend**: Angular, React, Vue (from package.json)
- **Database**: SQL Server, PostgreSQL, MongoDB (from connection strings)
- **Testing**: Jest, xUnit, pytest (from config files)

### Pattern Recognition
Hooks identify and adapt to:
- Multi-tenant patterns and field names
- Repository/Service layer architecture
- Result<T> error handling patterns
- Authentication methods (JWT, OAuth, Auth0)

### Dynamic Behavior
Based on detection, hooks provide:
- Framework-specific code examples
- Relevant security warnings
- Appropriate validation rules
- Contextual recommendations

## Examples

### Context Enhancement in Action
```
User: "create a new service for handling invoices"

Hook adds:
🔧 CONTEXT: Service layer patterns
- Return type: Always use Result<T>
- Organization: Get from ICurrentUserService
- Caching: Invalidate after writes
- Validation: Check before database operations
```

### Tenant Validation in Action
```
File edit detected: InvoiceRepository.cs

🔍 Validating tenant scoping...
❌ SECURITY ERROR: GetAll() without tenant filter detected!
💡 Example fix:
public async Task<IEnumerable<Invoice>> GetAllByOrganizationAsync(string organizationId)
{
    return await _context.Invoices
        .Where(i => i.OrganizationId == organizationId)
        .ToListAsync();
}
```

### Pre-commit Quality Check
```
git commit -m "Add invoice feature"

🔍 Running pre-commit quality checks...
✓ Phase 1: Syntax validation
✓ Phase 2: Code quality analysis
⚠️ WARNINGS:
  • InvoiceService.cs: Contains 3 TODO without ticket references
  • Large file warning: InvoiceController.cs (600 lines)
✅ Commit allowed with warnings
```

## Customization

### Adding Custom Validations
Edit hooks directly to add project-specific rules:

```powershell
# In validate-tenant-scoping.ps1
if ($content -match "YourCustomPattern") {
    $errors += "Custom validation failed"
}
```

### Extending Context
Add domain-specific context in add-context.ps1:

```powershell
# Domain-specific patterns
if ($promptLower -match "invoice|billing|payment") {
    $context += "💰 CONTEXT: Financial operations"
    $context += "- Always use decimal for money"
    $context += "- Include audit trail"
}
```

## Troubleshooting

### Hooks Not Running
1. Check Claude Code settings: hooks must be enabled
2. Verify PowerShell execution policy: `Set-ExecutionPolicy -Scope CurrentUser RemoteSigned`
3. Ensure hooks are in `.claude/hooks/` directory
4. Check hook configuration is valid JSON

### False Positives
- Adjust `strictMode` in configuration
- Add patterns to `skipPatterns` array
- Use exit code 0 for warnings (non-blocking)

### Performance Issues
- Hooks timeout after 30 seconds by default
- Limit file scanning to relevant directories
- Use `-First` parameter in PowerShell queries

## Best Practices

1. **Start Simple**: Use minimal hooks first, add more as needed
2. **Configure Don't Code**: Use configuration files rather than editing hooks
3. **Test Hooks**: Run operations to verify hook behavior
4. **Monitor Output**: Check Claude Code output for hook messages
5. **Keep Updated**: Pull latest hooks from claudify for improvements

## Integration with CI/CD

Hooks can be integrated with your CI/CD pipeline:

```yaml
# Example: GitHub Actions
- name: Run Claude Code Hooks
  run: |
    pwsh ./.claude/hooks/pre-commit-quality-check.ps1
```

## Contributing

To contribute new hooks or improvements:
1. Follow the parameterization pattern
2. Ensure cross-platform compatibility (Windows/Linux/Mac)
3. Add detection logic for auto-configuration
4. Include clear documentation

## Support

- **Documentation**: [Claude Code Hooks Guide](https://docs.anthropic.com/claude-code/hooks)
- **Issues**: Report in your project repository
- **Updates**: Check claudify repository for latest versions

---

*Hooks by Claudify - Intelligent assistance that adapts to your code*