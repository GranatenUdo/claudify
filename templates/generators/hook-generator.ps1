# Hook Generator Script
# Generates validation hooks based on repository analysis

param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Analysis,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"

# Ensure output directory exists
if (-not (Test-Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Generate settings.json with hook configuration
function Generate-SettingsJson {
    param($Analysis)
    
    $settings = @{
        hooks = @{}
    }
    
    # PreToolUse hooks for validation
    $preToolUseHooks = @()
    
    if ($Analysis.Patterns.MultiTenancy.Found) {
        $preToolUseHooks += @{
            matcher = "Edit|Write"
            hooks = @(
                @{
                    type = "command"
                    command = "powershell -ExecutionPolicy Bypass -File `".claude/hooks/validate-$($Analysis.Patterns.MultiTenancy.Model.ToLower())-scoping.ps1`" -FilePath {{file_path}} -Content {{new_content}}"
                }
            )
        }
    }
    
    # Add code style validation
    $preToolUseHooks += @{
        matcher = "Edit|Write"
        hooks = @(
            @{
                type = "command"
                command = "powershell -ExecutionPolicy Bypass -File `".claude/hooks/validate-code-style.ps1`" -FilePath {{file_path}}"
            }
        )
    }
    
    if ($preToolUseHooks.Count -gt 0) {
        $settings.hooks.PreToolUse = $preToolUseHooks
    }
    
    # UserPromptSubmit hooks for context
    $settings.hooks.UserPromptSubmit = @(
        @{
            hooks = @(
                @{
                    type = "command"
                    command = "powershell -ExecutionPolicy Bypass -File `".claude/hooks/add-context.ps1`" -UserPrompt {{user_prompt}}"
                }
            )
        }
    )
    
    return $settings | ConvertTo-Json -Depth 10
}

# Generate tenant validation hook
function Generate-TenantValidationHook {
    param($Analysis)
    
    if (-not $Analysis.Patterns.MultiTenancy.Found) {
        return $null
    }
    
    $tenantField = $Analysis.Patterns.MultiTenancy.Field
    $tenantModel = $Analysis.Patterns.MultiTenancy.Model
    
    $content = @"
# $tenantModel Scoping Validation Hook
# Validates that code changes maintain proper tenant isolation

param(
    [string]`$FilePath,
    [string]`$Content
)

`$ErrorActionPreference = "Stop"

# Skip non-code files
if (`$FilePath -notmatch '\.(cs|ts|js)$') {
    exit 0
}

# Skip test files
if (`$FilePath -match '(test|spec|\.test\.|\.spec\.)') {
    exit 0
}

Write-Host "🔍 Validating $tenantModel scoping in: `$FilePath" -ForegroundColor Yellow

`$issues = @()

# Check for repository/service files
if (`$FilePath -match '(Repository|Service)\.cs$' -and `$FilePath -notmatch 'Interface') {
    
    # Pattern checks for C# files
    `$patterns = @{
        "Missing tenant filter" = @{
            Pattern = '(GetAll|ToList|Where)\s*\(\s*\)'
            Message = "Query may be missing $tenantField filter"
        }
        "Direct context access" = @{
            Pattern = '_context\.\w+\.Find\(|_context\.\w+\.FirstOrDefault\('
            Message = "Direct context access should include $tenantField validation"
        }
        "Hardcoded tenant ID" = @{
            Pattern = '$tenantField\s*=\s*(Guid\.Parse|new Guid)\("[\w-]+"'
            Message = "Hardcoded $tenantField detected - use _userContext.$tenantField"
        }
        "Missing cache scope" = @{
            Pattern = 'cache\.Get.*\("[^"]*"\)'
            Message = "Cache key should include $tenantField for proper isolation"
        }
    }
    
    foreach (`$check in `$patterns.GetEnumerator()) {
        if (`$Content -match `$check.Value.Pattern) {
            `$issues += "⚠️  `$(`$check.Key): `$(`$check.Value.Message)"
        }
    }
}

# Check for TypeScript/JavaScript files
if (`$FilePath -match '\.(ts|js)$' -and `$FilePath -notmatch '\.spec\.' -and `$Content -match 'service|api') {
    
    # Check for API calls without tenant context
    if (`$Content -match 'http\.(get|post|put|delete)\(' -and `$Content -notmatch '$($tenantField.ToLower())') {
        `$issues += "⚠️  API call may be missing $tenantField context"
    }
    
    # Check for hardcoded IDs
    if (`$Content -match '(organizationId|tenantId|companyId)\s*[:=]\s*[''"`][''"]\w+') {
        `$issues += "⚠️  Hardcoded tenant identifier detected"
    }
}

# Report issues
if (`$issues.Count -gt 0) {
    Write-Host "`n❌ $tenantModel Scoping Issues Found:" -ForegroundColor Red
    foreach (`$issue in `$issues) {
        Write-Host "  `$issue" -ForegroundColor Yellow
    }
    Write-Host "`n💡 Remember: Every query must be scoped by $tenantField" -ForegroundColor Cyan
    Write-Host "💡 Use _userContext.$tenantField instead of hardcoded values" -ForegroundColor Cyan
    
    # Ask for confirmation
    Write-Host "`n⚠️  Potential security issue detected. Continue anyway? (y/N): " -ForegroundColor Yellow -NoNewline
    `$response = `$Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    Write-Host ""
    
    if (`$response -ne 'y' -and `$response -ne 'Y') {
        Write-Host "❌ Edit cancelled for security review" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "✅ $tenantModel scoping validation passed" -ForegroundColor Green
}

exit 0
"@
    
    return $content
}

# Generate code style validation hook
function Generate-CodeStyleHook {
    param($Analysis)
    
    $content = @"
# Code Style Validation Hook
# Enforces coding standards based on detected patterns

param(
    [string]`$FilePath
)

`$ErrorActionPreference = "Stop"

# Skip non-code files
if (`$FilePath -notmatch '\.(cs|ts|js|jsx|tsx)$') {
    exit 0
}

Write-Host "🎨 Validating code style in: `$FilePath" -ForegroundColor Cyan

`$issues = @()

# Read file content
if (Test-Path `$FilePath) {
    `$content = Get-Content `$FilePath -Raw
    
    # Language-specific checks
    if (`$FilePath -match '\.cs$') {
        # C# style checks
"@

    if ($Analysis.Patterns.ResultPattern.Found) {
        $content += @"
        
        # Check for exception throwing in services
        if (`$FilePath -match 'Service\.cs$' -and `$content -match 'throw\s+new\s+\w*Exception') {
            `$issues += "Use Result<T>.Failure() instead of throwing exceptions"
        }
"@
    }
    
    $content += @"
        
        # Check for proper async naming
        if (`$content -match 'public\s+async\s+Task.*\s+(\w+)\s*\(' -and `$matches[1] -notmatch 'Async$') {
            `$issues += "Async methods should end with 'Async' suffix"
        }
        
        # Check for var usage consistency
        if (`$content -match '\bnew\s+\w+<.*>\s*\(' -and `$content -notmatch 'var\s+\w+\s*=\s*new') {
            `$issues += "Consider using 'var' for obvious type declarations"
        }
    }
    
    if (`$FilePath -match '\.(ts|js)$') {
        # TypeScript/JavaScript checks
"@

    if ($Analysis.TechStack.Frontend.StateManagement -eq "Signals") {
        $content += @"
        
        # Check for proper signal usage in Angular
        if (`$FilePath -match '\.component\.ts$' -and `$content -match 'BehaviorSubject|Subject<') {
            `$issues += "Consider using signals instead of Subjects for state management"
        }
"@
    }
    
    $content += @"
        
        # Check for console.log statements
        if (`$content -match 'console\.(log|error|warn)\(') {
            `$issues += "Remove console statements before committing"
        }
        
        # Check for proper error handling
        if (`$content -match '\.subscribe\([^)]*\)' -and `$content -notmatch 'error\s*[:=>]') {
            `$issues += "Subscribe calls should include error handling"
        }
    }
    
    # Common checks for all languages
    # Check for TODO comments
    if (`$content -match 'TODO|FIXME|HACK') {
        `$issues += "Found TODO/FIXME comment - create a task instead"
    }
    
    # Check for trailing whitespace
    if (`$content -match '\s+$') {
        `$issues += "Remove trailing whitespace"
    }
}

# Report issues
if (`$issues.Count -gt 0) {
    Write-Host "`n⚠️  Code Style Issues:" -ForegroundColor Yellow
    foreach (`$issue in `$issues) {
        Write-Host "  • `$issue" -ForegroundColor Yellow
    }
    Write-Host "`n💡 Fix these issues to maintain code quality" -ForegroundColor Cyan
} else {
    Write-Host "✅ Code style validation passed" -ForegroundColor Green
}

# Style checks are warnings, not errors
exit 0
"@
    
    return $content
}

# Generate context adding hook
function Generate-ContextHook {
    param($Analysis)
    
    $content = @"
# Context Enhancement Hook
# Adds relevant context based on user prompts

param(
    [string]`$UserPrompt
)

`$ErrorActionPreference = "Stop"

# Analyze prompt for keywords
`$promptLower = `$UserPrompt.ToLower()

# Architecture reminders
if (`$promptLower -match 'creat|add|new|implement') {
"@

    if ($Analysis.Patterns.ResultPattern.Found) {
        $content += @"
    Write-Host "📋 Remember: Use Result<T> pattern for all service methods" -ForegroundColor Cyan
"@
    }
    
    if ($Analysis.Patterns.MultiTenancy.Found) {
        $content += @"
    Write-Host "🔒 Remember: Include $($Analysis.Patterns.MultiTenancy.Field) filtering in all queries" -ForegroundColor Cyan
"@
    }
    
    if ($Analysis.Patterns.RepositoryPattern.Found) {
        $content += @"
    Write-Host "📂 Remember: Data access only through repositories" -ForegroundColor Cyan
"@
    }
    
    $content += @"
}

# Security reminders
if (`$promptLower -match 'api|endpoint|controller|auth') {
"@

    if ($Analysis.TechStack.Authentication) {
        $content += @"
    Write-Host "🔐 Remember: All endpoints require [$($Analysis.TechStack.Authentication) authorization]" -ForegroundColor Cyan
"@
    }
    
    if ($Analysis.Patterns.MultiTenancy.Found) {
        $content += @"
    Write-Host "🏢 Remember: Validate $($Analysis.Patterns.MultiTenancy.Model) context in all operations" -ForegroundColor Cyan
"@
    }
    
    $content += @"
}

# Testing reminders
if (`$promptLower -match 'test|spec|mock') {
    Write-Host "🧪 Remember: Aim for 80% coverage on business logic" -ForegroundColor Cyan
    Write-Host "🧪 Remember: Write integration tests for data access" -ForegroundColor Cyan
}

# Performance reminders
if (`$promptLower -match 'query|performance|slow|optimize') {
    Write-Host "⚡ Remember: Check for N+1 queries" -ForegroundColor Cyan
    Write-Host "⚡ Remember: Use proper indexing on frequent queries" -ForegroundColor Cyan
"@

    if ($Analysis.Patterns.MultiTenancy.Found) {
        $content += @"
    Write-Host "⚡ Remember: Index on ($($Analysis.Patterns.MultiTenancy.Field), [other fields])" -ForegroundColor Cyan
"@
    }
    
    $content += @"
}

# Documentation reminders
if (`$promptLower -match 'feature|implement|create.*service|add.*entity') {
    Write-Host "📝 Remember: Update FEATURES.md after implementation" -ForegroundColor Cyan
}

exit 0
"@
    
    return $content
}

# Generate hooks
Write-Host "🔧 Generating Validation Hooks..." -ForegroundColor Cyan

# Generate settings.json
$settingsPath = Join-Path (Split-Path $OutputDirectory) "settings.json"
$settingsContent = Generate-SettingsJson -Analysis $Analysis
$settingsContent | Out-File -FilePath $settingsPath -Encoding UTF8
Write-Host "  ✓ Generated settings.json with hook configuration" -ForegroundColor Green

# Generate tenant validation hook if multi-tenant
if ($Analysis.Patterns.MultiTenancy.Found) {
    $tenantHookContent = Generate-TenantValidationHook -Analysis $Analysis
    if ($tenantHookContent) {
        $hookName = "validate-$($Analysis.Patterns.MultiTenancy.Model.ToLower())-scoping.ps1"
        $hookPath = Join-Path $OutputDirectory $hookName
        $tenantHookContent | Out-File -FilePath $hookPath -Encoding UTF8
        Write-Host "  ✓ Generated $hookName" -ForegroundColor Green
    }
}

# Generate code style hook
$styleHookContent = Generate-CodeStyleHook -Analysis $Analysis
$styleHookPath = Join-Path $OutputDirectory "validate-code-style.ps1"
$styleHookContent | Out-File -FilePath $styleHookPath -Encoding UTF8
Write-Host "  ✓ Generated validate-code-style.ps1" -ForegroundColor Green

# Generate context hook
$contextHookContent = Generate-ContextHook -Analysis $Analysis
$contextHookPath = Join-Path $OutputDirectory "add-context.ps1"
$contextHookContent | Out-File -FilePath $contextHookPath -Encoding UTF8
Write-Host "  ✓ Generated add-context.ps1" -ForegroundColor Green

Write-Host "✓ Hook generation complete" -ForegroundColor Green