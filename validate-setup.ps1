# Validate-Setup.ps1
# Validates that Claudify setup completed successfully
#
# Usage: .\validate-setup.ps1 -TargetRepository "C:\path\to\your\repo"

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetRepository
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Success { Write-Host $args -ForegroundColor Green }
function Write-Warning { Write-Host $args -ForegroundColor Yellow }
function Write-Error { Write-Host $args -ForegroundColor Red }
function Write-Info { Write-Host $args -ForegroundColor Cyan }

Write-Host "`n=== Claudify Setup Validation ===" -ForegroundColor Cyan
Write-Host "Target: $TargetRepository`n" -ForegroundColor White

$validationPassed = $true
$warnings = @()
$errors = @()

# Check if .claude directory exists
Write-Info "Checking .claude directory..."
$claudeDir = Join-Path $TargetRepository ".claude"
if (Test-Path $claudeDir) {
    Write-Success "  ✓ .claude directory exists"
} else {
    Write-Error "  ✗ .claude directory not found"
    $errors += ".claude directory missing - setup may not have run"
    $validationPassed = $false
}

# Check configuration file
Write-Info "Checking configuration..."
$configFile = Join-Path $claudeDir "config\projects.json"
if (Test-Path $configFile) {
    Write-Success "  ✓ Configuration file exists"
    
    # Validate JSON structure
    try {
        $config = Get-Content $configFile -Raw | ConvertFrom-Json
        if ($config.projects) {
            Write-Success "  ✓ Projects configuration found"
            
            # Display configured projects
            if ($config.projects.WebProject) {
                Write-Host "    - Web: $($config.projects.WebProject)" -ForegroundColor Gray
            }
            if ($config.projects.ApiProject) {
                Write-Host "    - API: $($config.projects.ApiProject)" -ForegroundColor Gray
            }
            if ($config.projects.ArchitectureTestProject) {
                Write-Host "    - Tests: $($config.projects.ArchitectureTestProject)" -ForegroundColor Gray
            }
        } else {
            Write-Warning "  ⚠ No projects configured"
            $warnings += "No projects found in configuration"
        }
    } catch {
        Write-Error "  ✗ Invalid JSON in configuration file"
        $errors += "Configuration file has invalid JSON"
        $validationPassed = $false
    }
} else {
    Write-Error "  ✗ Configuration file not found"
    $errors += "Configuration file missing at $configFile"
    $validationPassed = $false
}

# Check for commands
Write-Info "Checking commands..."
$commandsDir = Join-Path $claudeDir "commands"
if (Test-Path $commandsDir) {
    $commandCount = (Get-ChildItem -Path $commandsDir -Filter "*.md" | Measure-Object).Count
    if ($commandCount -gt 0) {
        Write-Success "  ✓ $commandCount commands installed"
    } else {
        Write-Warning "  ⚠ No commands found"
        $warnings += "No command files in commands directory"
    }
} else {
    Write-Error "  ✗ Commands directory not found"
    $errors += "Commands directory missing"
    $validationPassed = $false
}

# Check for agents
Write-Info "Checking agents..."
$agentsDir = Join-Path $claudeDir "agents"
if (Test-Path $agentsDir) {
    $agentCount = (Get-ChildItem -Path $agentsDir -Filter "*.md" | Measure-Object).Count
    if ($agentCount -gt 0) {
        Write-Success "  ✓ $agentCount agents installed"
    } else {
        Write-Warning "  ⚠ No agents found"
        $warnings += "No agent files in agents directory"
    }
} else {
    Write-Error "  ✗ Agents directory not found"
    $errors += "Agents directory missing"
    $validationPassed = $false
}

# Check for template placeholders
Write-Info "Checking for unreplaced templates..."
if ((Test-Path $commandsDir) -and (Test-Path $agentsDir)) {
    $placeholders = @()
    
    # Search for template variables in commands
    Get-ChildItem -Path $commandsDir -Filter "*.md" | ForEach-Object {
        $content = Get-Content $_.FullName -Raw
        if ($content -match '\{\{.*?\}\}') {
            $placeholders += $_.Name
        }
    }
    
    if ($placeholders.Count -eq 0) {
        Write-Success "  ✓ All templates replaced successfully"
    } else {
        Write-Warning "  ⚠ Found unreplaced templates in: $($placeholders -join ', ')"
        $warnings += "Some files still contain template placeholders"
    }
}

# Check VERSION file
Write-Info "Checking version..."
$versionFile = Join-Path $claudeDir "VERSION"
if (Test-Path $versionFile) {
    $version = Get-Content $versionFile -Raw | ForEach-Object { $_.Trim() }
    Write-Success "  ✓ Version: $version"
} else {
    Write-Warning "  ⚠ VERSION file not found"
    $warnings += "Cannot determine installed version"
}

# Check for hooks (optional)
Write-Info "Checking hooks (optional)..."
$hooksDir = Join-Path $claudeDir "hooks"
if (Test-Path $hooksDir) {
    $hookCount = (Get-ChildItem -Path $hooksDir -Filter "*.ps1" | Measure-Object).Count
    if ($hookCount -gt 0) {
        Write-Success "  ✓ $hookCount hooks installed"
    } else {
        Write-Info "  - No hooks configured"
    }
} else {
    Write-Info "  - Hooks directory not present (optional)"
}

# Check for user-managed files
Write-Info "Checking user files..."
$claudeMd = Join-Path $TargetRepository "CLAUDE.md"
$featuresMd = Join-Path $TargetRepository "FEATURES.md"

if (Test-Path $claudeMd) {
    Write-Success "  ✓ CLAUDE.md exists (user-managed)"
} else {
    Write-Info "  - CLAUDE.md not found (optional)"
}

if (Test-Path $featuresMd) {
    Write-Success "  ✓ FEATURES.md exists (user-managed)"
} else {
    Write-Info "  - FEATURES.md not found (optional)"
}

# Summary
Write-Host "`n=== Validation Summary ===" -ForegroundColor Cyan

if ($errors.Count -gt 0) {
    Write-Host "`nErrors:" -ForegroundColor Red
    $errors | ForEach-Object { Write-Host "  • $_" -ForegroundColor Red }
}

if ($warnings.Count -gt 0) {
    Write-Host "`nWarnings:" -ForegroundColor Yellow
    $warnings | ForEach-Object { Write-Host "  • $_" -ForegroundColor Yellow }
}

if ($validationPassed) {
    if ($warnings.Count -eq 0) {
        Write-Host "`n✓ Setup validation PASSED - Everything looks good!" -ForegroundColor Green
    } else {
        Write-Host "`n✓ Setup validation PASSED with warnings" -ForegroundColor Green
        Write-Host "  The setup is functional but review the warnings above." -ForegroundColor Gray
    }
    exit 0
} else {
    Write-Host "`n✗ Setup validation FAILED" -ForegroundColor Red
    Write-Host "  Please review the errors above and re-run setup if needed." -ForegroundColor Gray
    exit 1
}