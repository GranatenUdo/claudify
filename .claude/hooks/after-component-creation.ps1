# After Component Creation Hook
# Automatically syncs newly created commands/agents to the templating solution

param(
    [string]$ComponentType,  # command|agent|hook
    [string]$ComponentName,
    [string]$FilePath
)

# Configuration
$AutoSyncEnabled = $true
$VerboseOutput = $false

# Try to find template repository in multiple locations
$possiblePaths = @(
    # Same directory as current project
    Join-Path (Get-Location) "claude-code-base-repository-setup",
    # Parent directory
    Join-Path (Split-Path (Get-Location) -Parent) "claude-code-base-repository-setup",
    # Grandparent directory
    Join-Path (Split-Path (Split-Path (Get-Location) -Parent) -Parent) "claude-code-base-repository-setup",
    # Check for environment variable
    if ($env:CLAUDE_TEMPLATE_PATH) { $env:CLAUDE_TEMPLATE_PATH } else { $null }
)

$TemplateRepoPath = $null
foreach ($path in $possiblePaths) {
    if ($path -and (Test-Path $path)) {
        $TemplateRepoPath = $path
        Write-Host "[INFO] Found template repository at: $TemplateRepoPath" -ForegroundColor Green
        break
    }
}

# Check if template repo was found
if (-not $TemplateRepoPath) {
    Write-Host "[INFO] Template repository not found. Skipping auto-sync." -ForegroundColor Yellow
    Write-Host "   Searched in: current dir, parent dir, grandparent dir" -ForegroundColor Gray
    Write-Host "   Set CLAUDE_TEMPLATE_PATH environment variable to specify location" -ForegroundColor Gray
    exit 0
}

if (-not $AutoSyncEnabled) {
    Write-Host "[INFO] Auto-sync is disabled. Enable in hook configuration." -ForegroundColor Cyan
    exit 0
}

# Only process command and agent creation
if ($ComponentType -notin @("command", "agent")) {
    exit 0
}

Write-Host "`n[SYNC] Auto-syncing to templates..." -ForegroundColor Cyan

# Determine target path in template repo
$targetDir = switch ($ComponentType) {
    "command" { Join-Path $TemplateRepoPath ".claude\commands" }
    "agent" { Join-Path $TemplateRepoPath ".claude\agents" }
}

# Ensure target directory exists
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

# Copy the new component
$fileName = Split-Path $FilePath -Leaf
$targetPath = Join-Path $targetDir $fileName

try {
    Copy-Item -Path $FilePath -Destination $targetPath -Force
    Write-Host "[OK] Synced $ComponentType to templates: $fileName" -ForegroundColor Green
    
    # Also sync any related configuration files
    if ($ComponentType -eq "agent") {
        # Check for agent config
        $configName = $ComponentName -replace '\.md$', '.json'
        $configPath = Join-Path (Split-Path $FilePath -Parent | Split-Path -Parent) "agent-configs\$configName"
        
        if (Test-Path $configPath) {
            $targetConfigDir = Join-Path $TemplateRepoPath ".claude\agent-configs"
            if (-not (Test-Path $targetConfigDir)) {
                New-Item -ItemType Directory -Path $targetConfigDir -Force | Out-Null
            }
            
            Copy-Item -Path $configPath -Destination (Join-Path $targetConfigDir $configName) -Force
            Write-Host "[OK] Synced agent configuration: $configName" -ForegroundColor Green
        }
        
        # Check for agent tools
        $toolsDir = Join-Path (Split-Path $FilePath -Parent | Split-Path -Parent) "agent-tools\$($ComponentName -replace '\.md$', '')"
        
        if (Test-Path $toolsDir) {
            $targetToolsDir = Join-Path $TemplateRepoPath ".claude\agent-tools\$($ComponentName -replace '\.md$', '')"
            if (-not (Test-Path $targetToolsDir)) {
                New-Item -ItemType Directory -Path $targetToolsDir -Force | Out-Null
            }
            
            Copy-Item -Path "$toolsDir\*" -Destination $targetToolsDir -Recurse -Force
            Write-Host "[OK] Synced agent tools directory" -ForegroundColor Green
        }
    }
    
    # Update template README if needed
    $readmePath = Join-Path $TemplateRepoPath ".claude\$ComponentType`s\README.md"
    if (Test-Path $readmePath) {
        $readmeContent = Get-Content $readmePath -Raw
        
        # Check if component is already documented
        if ($readmeContent -notmatch [regex]::Escape($ComponentName)) {
            Write-Host "[NOTE] Remember to update the README.md in templates" -ForegroundColor Yellow
        }
    }
    
    # Git status reminder
    Write-Host "`n[GIT] Template changes:" -ForegroundColor Yellow
    Write-Host "   cd $TemplateRepoPath" -ForegroundColor Gray
    Write-Host "   git add ." -ForegroundColor Gray
    Write-Host "   git commit -m 'feat(templates): Add $ComponentName $ComponentType'" -ForegroundColor Gray
    
} catch {
    Write-Host "[ERROR] Failed to sync to templates: $_" -ForegroundColor Red
    exit 1
}

exit 0