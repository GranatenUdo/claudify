# Claude Code Hooks System

## Overview
Hooks provide automated quality gates and enhancements to your Claude Code workflow. They execute at critical moments to enforce standards, provide context, and prevent issues.

## Active Hooks

### 🔒 Security Context (`add-context.ps1`)
**Trigger**: Every user prompt
**Purpose**: Adds critical security and architecture reminders
**Focus**: TOP 3 patterns - Security, Architecture, Testing

### 📝 Changelog Reminder (`check-changelog-updates.ps1`)
**Trigger**: After Edit/Write operations
**Purpose**: Reminds to update CHANGELOG.md every 5 changes
**Focus**: Simple counter, gentle reminders

### 🚫 Pre-Commit Quality (`pre-commit-quality-check.ps1`)
**Trigger**: Before `git commit` commands
**Purpose**: Blocks commits with critical issues
**TOP 3 Checks**:
1. Build must succeed
2. No hardcoded credentials
3. Multi-tenant isolation enforced
**Can Block**: Yes (exit code 2)

### 🔐 Secrets Detection (`security-secrets-check.ps1`)
**Trigger**: Before Write/Edit operations
**Purpose**: Prevents accidental credential exposure
**Blocks**: API keys, passwords, private keys
**Can Block**: Yes (exit code 2)

### 🚀 Post-Deploy Verification (`post-deploy-verify.ps1`)
**Trigger**: After deployment commands
**Purpose**: Verifies deployment success
**TOP 3 Checks**:
1. Service running
2. Database connected
3. Endpoints responding

## Configuration
Hooks are configured in `.claude/settings.json`. Each hook specifies:
- Event trigger (UserPromptSubmit, PreToolUse, PostToolUse)
- Tool matcher (regex pattern)
- Command to execute
- Whether it can block operations

## Testing
Run all hook tests:
```powershell
.\test-hooks.ps1 -Verbose
```

## Best Practices
1. **Keep hooks fast** - Under 2 seconds execution
2. **TOP 3 focus** - Check only critical issues
3. **Non-blocking default** - Only block for security/build issues
4. **Clear messages** - Tell user what's wrong and how to fix
5. **Exit codes**:
   - 0 = Success, continue
   - 1 = Warning, continue
   - 2 = Error, block operation

## Adding New Hooks
1. Create `.ps1` file in `.claude/hooks/`
2. Follow the minimal template:
```powershell
param([string]$EventName, [string]$ToolName)
if ($EventName -ne "TARGET") { exit 0 }

# TOP 3 checks only
$errors = @()
# ... checks ...

if ($errors.Count -gt 0) {
    Write-Host "❌ Issues found:" -ForegroundColor Red
    exit 2  # Block if critical
}
exit 0
```
3. Add to `settings.json`
4. Test with `test-hooks.ps1`

## Troubleshooting
- **Hook not firing**: Check settings.json configuration
- **Hook blocking incorrectly**: Review exit codes
- **Performance issues**: Simplify to TOP 3 checks
- **Errors**: Hooks should handle errors gracefully (exit 0)