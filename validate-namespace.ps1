# Claudify Namespace Validation Script
# Validates that namespace parameterization was successful

param(
    [Parameter(Mandatory=$true)]
    [string]$TargetPath,
    
    [Parameter(Mandatory=$false)]
    [string]$ExpectedNamespace
)

Write-Host "`n==== Claudify Namespace Validation ====" -ForegroundColor Cyan
Write-Host "Target: $TargetPath" -ForegroundColor Gray

# Check if .claude directory exists
$claudePath = Join-Path $TargetPath ".claude"
if (-not (Test-Path $claudePath)) {
    Write-Host "[ERROR] .claude directory not found at $claudePath" -ForegroundColor Red
    exit 1
}

# Read project configuration
$configPath = Join-Path $claudePath "config" "projects.json"
$configuredProjects = @{}
if (Test-Path $configPath) {
    $config = Get-Content $configPath -Raw | ConvertFrom-Json
    Write-Host "[OK] Project configuration found" -ForegroundColor Green
    
    if ($config.Replacements) {
        Write-Host "  Configured templates:" -ForegroundColor White
        foreach ($key in $config.Replacements.PSObject.Properties.Name) {
            Write-Host "    $key = $($config.Replacements.$key)" -ForegroundColor Gray
            $configuredProjects[$key] = $config.Replacements.$key
        }
    }
    
    Write-Host "  Configured date: $($config.ConfiguredDate)" -ForegroundColor Gray
} else {
    Write-Host "[INFO] No project configuration file found" -ForegroundColor Yellow
    Write-Host "  Templates may not have been processed" -ForegroundColor Gray
}

Write-Host "`nChecking for unprocessed template references..." -ForegroundColor Cyan

# Search for any remaining template placeholders
$templatePatterns = @("{{WebProject}}", "{{ApiProject}}", "{{ArchitectureTestProject}}", "{{ProjectNamespace}}")
$foundTemplates = @()

# Check commands
$commandsPath = Join-Path $claudePath "commands"
if (Test-Path $commandsPath) {
    $commandFiles = Get-ChildItem -Path $commandsPath -Filter "*.md" -ErrorAction SilentlyContinue
    foreach ($file in $commandFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content) {
            foreach ($pattern in $templatePatterns) {
                if ($content.Contains($pattern)) {
                    $foundTemplates += "  Command: $($file.Name) contains $pattern"
                    break
                }
            }
        }
    }
}

# Check agents
$agentsPath = Join-Path $claudePath "agents"
if (Test-Path $agentsPath) {
    $agentFiles = Get-ChildItem -Path $agentsPath -Filter "*.md" -ErrorAction SilentlyContinue
    foreach ($file in $agentFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -and $content.Contains($templatePattern)) {
            $foundTemplates += "  Agent: $($file.Name)"
        }
    }
}

# Check hooks
$hooksPath = Join-Path $claudePath "hooks"
if (Test-Path $hooksPath) {
    $hookFiles = Get-ChildItem -Path $hooksPath -Filter "*.ps1" -ErrorAction SilentlyContinue
    foreach ($file in $hookFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if ($content -and $content.Contains($templatePattern)) {
            $foundTemplates += "  Hook: $($file.Name)"
        }
    }
}

# Report results
if ($foundTemplates.Count -eq 0) {
    Write-Host "[OK] All template placeholders processed" -ForegroundColor Green
    Write-Host "  All files configured with namespace: $configuredNamespace" -ForegroundColor Green
} else {
    Write-Host "[WARNING] Found $($foundTemplates.Count) files with unprocessed templates" -ForegroundColor Yellow
    Write-Host "These files still contain '{{ProjectNamespace}}':" -ForegroundColor Yellow
    foreach ($template in $foundTemplates) {
        Write-Host $template -ForegroundColor Yellow
    }
    Write-Host "`nThis indicates the namespace was not applied during setup" -ForegroundColor Yellow
}

# Verify actual project structure matches configured namespace
Write-Host "`nVerifying project structure..." -ForegroundColor Cyan

$expectedWebPath = Join-Path $TargetPath "src" "$configuredNamespace.Web"
$expectedApiPath = Join-Path $TargetPath "src" "$configuredNamespace.Api"
$expectedTestPath = Join-Path $TargetPath "tests" "$configuredNamespace.ArchitectureTests"

$structureValid = $true

if (Test-Path $expectedWebPath) {
    Write-Host "[OK] Web project found: $expectedWebPath" -ForegroundColor Green
} else {
    Write-Host "[INFO] Web project not found at expected location: $expectedWebPath" -ForegroundColor Yellow
    $structureValid = $false
}

if (Test-Path $expectedApiPath) {
    Write-Host "[OK] API project found: $expectedApiPath" -ForegroundColor Green
} else {
    Write-Host "[INFO] API project not found at expected location: $expectedApiPath" -ForegroundColor Yellow
    $structureValid = $false
}

if (Test-Path $expectedTestPath) {
    Write-Host "[OK] Test project found: $expectedTestPath" -ForegroundColor Green
} else {
    Write-Host "[INFO] Test project not found at expected location: $expectedTestPath" -ForegroundColor Yellow
    $structureValid = $false
}

# Final summary
Write-Host "`n==== Validation Summary ====" -ForegroundColor Cyan
if ($foundTemplates.Count -eq 0 -and $structureValid) {
    Write-Host "[SUCCESS] Namespace configuration is valid" -ForegroundColor Green
    Write-Host "  Project namespace: $configuredNamespace" -ForegroundColor White
    exit 0
} elseif ($foundTemplates.Count -eq 0) {
    Write-Host "[PARTIAL] Template processing successful" -ForegroundColor Yellow
    Write-Host "  However, project structure doesn't match expected paths" -ForegroundColor Yellow
    Write-Host "  This is normal if your project uses different naming conventions" -ForegroundColor Gray
    exit 0
} else {
    Write-Host "[NEEDS ATTENTION] Some issues found" -ForegroundColor Yellow
    Write-Host "  - Unprocessed templates remaining: $($foundTemplates.Count)" -ForegroundColor Yellow
    if (-not $structureValid) {
        Write-Host "  - Project structure mismatch" -ForegroundColor Yellow
    }
    exit 1
}