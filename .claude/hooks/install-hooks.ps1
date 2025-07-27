# Hook Installation and Configuration Script
# Sets up Claude Code hooks for your project with appropriate configuration

param(
    [string]$ProjectPath = ".",
    [switch]$Interactive,
    [switch]$Minimal,
    [switch]$Comprehensive
)

Write-Host "🔧 Claude Code Hooks Installer - Claudify Edition" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host ""

# Change to project directory
Push-Location $ProjectPath

try {
    # Detect project characteristics
    Write-Host "📊 Analyzing project..." -ForegroundColor Yellow
    
    $projectInfo = @{
        TechStack = @{
            Backend = ""
            Frontend = ""
            Database = ""
        }
        Features = @{
            MultiTenant = $false
            Authentication = $false
            Testing = $false
            CI_CD = $false
        }
        TenantField = "OrganizationId"
    }
    
    # Detect backend technology
    if (Get-ChildItem -Path . -Include "*.csproj" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $projectInfo.TechStack.Backend = ".NET"
        Write-Host "  ✓ Detected .NET backend" -ForegroundColor Green
    }
    elseif (Test-Path "package.json") {
        $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($packageJson.dependencies.express -or $packageJson.dependencies.nestjs) {
            $projectInfo.TechStack.Backend = "Node.js"
            Write-Host "  ✓ Detected Node.js backend" -ForegroundColor Green
        }
    }
    elseif (Get-ChildItem -Path . -Include "*.py", "requirements.txt" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $projectInfo.TechStack.Backend = "Python"
        Write-Host "  ✓ Detected Python backend" -ForegroundColor Green
    }
    
    # Detect frontend technology
    if (Test-Path "package.json") {
        $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
        if ($packageJson.dependencies."@angular/core") {
            $projectInfo.TechStack.Frontend = "Angular"
            Write-Host "  ✓ Detected Angular frontend" -ForegroundColor Green
        }
        elseif ($packageJson.dependencies.react) {
            $projectInfo.TechStack.Frontend = "React"
            Write-Host "  ✓ Detected React frontend" -ForegroundColor Green
        }
        elseif ($packageJson.dependencies.vue) {
            $projectInfo.TechStack.Frontend = "Vue"
            Write-Host "  ✓ Detected Vue frontend" -ForegroundColor Green
        }
    }
    
    # Detect multi-tenancy
    $searchPatterns = @("OrganizationId", "TenantId", "CompanyId", "CustomerId", "multi-tenant", "multitenant")
    $foundTenantPattern = $false
    
    foreach ($pattern in $searchPatterns) {
        $matches = Get-ChildItem -Path . -Include "*.cs", "*.ts", "*.js", "*.py" -Recurse -ErrorAction SilentlyContinue |
            Select-Object -First 20 |
            Select-String -Pattern $pattern -ErrorAction SilentlyContinue
        
        if ($matches) {
            $projectInfo.Features.MultiTenant = $true
            if ($pattern -match "Id$") {
                $projectInfo.TenantField = $pattern
            }
            $foundTenantPattern = $true
            Write-Host "  ✓ Detected multi-tenant architecture (field: $($projectInfo.TenantField))" -ForegroundColor Green
            break
        }
    }
    
    # Detect authentication
    if ((Get-ChildItem -Path . -Recurse -ErrorAction SilentlyContinue | 
         Select-String -Pattern "JWT|OAuth|Auth0|Identity" -ErrorAction SilentlyContinue |
         Select-Object -First 1)) {
        $projectInfo.Features.Authentication = $true
        Write-Host "  ✓ Detected authentication system" -ForegroundColor Green
    }
    
    # Detect testing
    if ((Test-Path "package.json" -and (Get-Content "package.json" -Raw | Select-String -Pattern '"test":'))) {
        $projectInfo.Features.Testing = $true
        Write-Host "  ✓ Detected test framework" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path . -Include "*test*", "*spec*" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1) {
        $projectInfo.Features.Testing = $true
        Write-Host "  ✓ Detected test framework" -ForegroundColor Green
    }
    
    # Interactive mode - ask for confirmation/customization
    if ($Interactive) {
        Write-Host "`n🎯 Customize Hook Configuration" -ForegroundColor Yellow
        Write-Host "==============================" -ForegroundColor Yellow
        
        # Multi-tenant field
        if ($projectInfo.Features.MultiTenant) {
            Write-Host "`nDetected tenant field: $($projectInfo.TenantField)" -ForegroundColor Cyan
            $customField = Read-Host "Press Enter to accept or type a different field name"
            if ($customField) {
                $projectInfo.TenantField = $customField
            }
        }
        
        # Hook selection
        Write-Host "`nSelect hooks to install:" -ForegroundColor Cyan
        Write-Host "1. [Recommended] Security & Quality hooks" -ForegroundColor White
        Write-Host "2. Minimal (context enhancement only)" -ForegroundColor White
        Write-Host "3. Comprehensive (all available hooks)" -ForegroundColor White
        Write-Host "4. Custom selection" -ForegroundColor White
        
        $selection = Read-Host "Enter your choice (1-4) [1]"
        if (-not $selection) { $selection = "1" }
        
        switch ($selection) {
            "2" { $Minimal = $true }
            "3" { $Comprehensive = $true }
            "4" { 
                # Custom selection logic here
                Write-Host "Custom selection not yet implemented. Using recommended." -ForegroundColor Yellow
            }
        }
    }
    
    # Determine which hooks to install
    $hooksToInstall = @()
    
    if ($Minimal) {
        $hooksToInstall = @("add-context.ps1")
    }
    elseif ($Comprehensive) {
        $hooksToInstall = @(
            "add-context.ps1",
            "validate-tenant-scoping.ps1",
            "pre-commit-quality-check.ps1"
        )
    }
    else {
        # Recommended based on project analysis
        $hooksToInstall = @("add-context.ps1")
        
        if ($projectInfo.Features.MultiTenant) {
            $hooksToInstall += "validate-tenant-scoping.ps1"
        }
        
        if ($projectInfo.Features.Testing -or $projectInfo.TechStack.Backend) {
            $hooksToInstall += "pre-commit-quality-check.ps1"
        }
    }
    
    # Create .claude/hooks directory if it doesn't exist
    $hooksDir = Join-Path $ProjectPath ".claude/hooks"
    if (-not (Test-Path $hooksDir)) {
        New-Item -ItemType Directory -Path $hooksDir -Force | Out-Null
        Write-Host "`n📁 Created hooks directory: $hooksDir" -ForegroundColor Green
    }
    
    # Copy selected hooks
    Write-Host "`n📋 Installing hooks..." -ForegroundColor Yellow
    
    $sourceHooksDir = Split-Path -Parent $MyInvocation.MyCommand.Path
    
    foreach ($hook in $hooksToInstall) {
        $sourcePath = Join-Path $sourceHooksDir $hook
        $destPath = Join-Path $hooksDir $hook
        
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Host "  ✓ Installed: $hook" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ Hook not found: $hook" -ForegroundColor Red
        }
    }
    
    # Generate project-specific configuration
    Write-Host "`n⚙️  Generating configuration..." -ForegroundColor Yellow
    
    $config = @{
        hooks = @{
            "pre-tool-use" = @{}
            "user-prompt-submit" = @{}
        }
        projectInfo = $projectInfo
    }
    
    # Configure add-context hook
    if ("add-context.ps1" -in $hooksToInstall) {
        $config.hooks."user-prompt-submit"."add-context" = @{
            enabled = $true
            priority = 1
        }
    }
    
    # Configure tenant validation hook
    if ("validate-tenant-scoping.ps1" -in $hooksToInstall -and $projectInfo.Features.MultiTenant) {
        $config.hooks."pre-tool-use"."validate-tenant-scoping" = @{
            enabled = $true
            priority = 10
            config = @{
                tenantField = $projectInfo.TenantField
                strictMode = $false
            }
        }
    }
    
    # Configure pre-commit hook
    if ("pre-commit-quality-check.ps1" -in $hooksToInstall) {
        $config.hooks."user-prompt-submit"."pre-commit-quality-check" = @{
            enabled = $true
            priority = 20
            config = @{
                runTests = $projectInfo.Features.Testing
                blockOnErrors = $true
                blockOnWarnings = $false
            }
        }
    }
    
    # Save configuration
    $configPath = Join-Path $hooksDir "project-hooks-config.json"
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host "  ✓ Created configuration: project-hooks-config.json" -ForegroundColor Green
    
    # Create README for hooks
    $readmePath = Join-Path $hooksDir "README.md"
    $readmeContent = @"
# Claude Code Hooks

This directory contains hooks that enhance Claude Code's behavior for this project.

## Installed Hooks

$(foreach ($hook in $hooksToInstall) {
    $hookName = [System.IO.Path]::GetFileNameWithoutExtension($hook)
    "- **$hookName**: $(switch($hookName) {
        'add-context' { 'Adds contextual information based on prompt content' }
        'validate-tenant-scoping' { 'Validates multi-tenant isolation in code changes' }
        'pre-commit-quality-check' { 'Enforces quality standards before commits' }
        default { 'Custom hook' }
    })`n"
})

## Configuration

Project-specific configuration is stored in `project-hooks-config.json`.

### Detected Project Settings:
- Backend: $($projectInfo.TechStack.Backend)
- Frontend: $($projectInfo.TechStack.Frontend)
- Multi-tenant: $($projectInfo.Features.MultiTenant) $(if ($projectInfo.Features.MultiTenant) { "(Field: $($projectInfo.TenantField))" })
- Testing: $($projectInfo.Features.Testing)

## Managing Hooks

To disable a hook temporarily, edit `project-hooks-config.json` and set `enabled: false` for that hook.

To add more hooks, run the installer again:
```bash
./.claude/hooks/install-hooks.ps1 -Interactive
```

## Troubleshooting

If hooks are not running:
1. Ensure Claude Code hooks are enabled in your settings
2. Check that PowerShell execution policy allows script execution
3. Review Claude Code output for any error messages

For more information, see the [Claude Code documentation](https://docs.anthropic.com/claude-code/hooks).
"@
    
    $readmeContent | Out-File -FilePath $readmePath -Encoding UTF8
    Write-Host "  ✓ Created hooks README" -ForegroundColor Green
    
    # Summary
    Write-Host "`n✅ Hook Installation Complete!" -ForegroundColor Green
    Write-Host "=============================" -ForegroundColor Green
    Write-Host ""
    Write-Host "Installed $($hooksToInstall.Count) hooks for your project:" -ForegroundColor White
    
    foreach ($hook in $hooksToInstall) {
        Write-Host "  • $([System.IO.Path]::GetFileNameWithoutExtension($hook))" -ForegroundColor Gray
    }
    
    Write-Host "`n💡 Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Review the configuration in .claude/hooks/project-hooks-config.json" -ForegroundColor White
    Write-Host "  2. Test the hooks by making relevant code changes" -ForegroundColor White
    Write-Host "  3. Customize hook behavior as needed" -ForegroundColor White
    
    if ($projectInfo.Features.MultiTenant) {
        Write-Host "`n🔒 Security Note:" -ForegroundColor Cyan
        Write-Host "  Multi-tenant validation is configured for field: $($projectInfo.TenantField)" -ForegroundColor White
        Write-Host "  All data queries will be checked for proper tenant isolation" -ForegroundColor White
    }
    
} finally {
    Pop-Location
}

Write-Host "`n✨ Happy coding with Claude Code hooks!" -ForegroundColor Cyan