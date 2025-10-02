# Claudify - Setup Script v4.0.0
# Cross-platform setup for Windows, Linux, and macOS
#
# Usage:
#   Windows:  .\setup.ps1 -TargetRepository "C:\path\to\your\repo"
#   Linux/Mac: pwsh setup.ps1 -TargetRepository "/path/to/your/repo"

param(
    [Parameter(Mandatory=$true, Position=0)]
    [Alias("Path", "p", "Repository", "Repo")]
    [string]$TargetRepository
)

$ErrorActionPreference = "Stop"

# Get version and paths
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$versionFile = Join-Path $scriptDir "VERSION"
$version = if (Test-Path $versionFile) { Get-Content $versionFile -Raw | ForEach-Object { $_.Trim() } } else { "4.0.0" }

# Sanitize target path
$TargetRepository = $TargetRepository.Trim()
if ($TargetRepository.StartsWith('"') -and $TargetRepository.EndsWith('"')) {
    $TargetRepository = $TargetRepository.Substring(1, $TargetRepository.Length - 2)
}
$TargetRepository = [System.IO.Path]::GetFullPath($TargetRepository)

# Helper functions
function Write-Success { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Info { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }
function Write-Detail { param($msg) Write-Host "  $msg" -ForegroundColor DarkGray }

# Banner
Write-Host "`n╔══════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                      CLAUDIFY v$version                       ║" -ForegroundColor Cyan
Write-Host "║          Intelligent Claude Code Setup System              ║" -ForegroundColor Cyan
Write-Host "╚══════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Validate target repository
if (-not (Test-Path $TargetRepository)) {
    Write-Error "Target repository not found: $TargetRepository"
    exit 1
}

Write-Info "Target: $TargetRepository"
Write-Info ""

# Create .claude directory
$claudePath = Join-Path $TargetRepository ".claude"
if (-not (Test-Path $claudePath)) {
    New-Item -ItemType Directory -Path $claudePath -Force | Out-Null
    Write-Detail "Created .claude directory"
}

# Copy commands
Write-Info "📦 Installing Claudify components..."
$sourceCommands = Join-Path $scriptDir ".claude" "commands"
$destCommands = Join-Path $claudePath "commands"

if (Test-Path $sourceCommands) {
    if (-not (Test-Path $destCommands)) {
        New-Item -ItemType Directory -Path $destCommands -Force | Out-Null
    }
    Copy-Item -Path "$sourceCommands\*" -Destination $destCommands -Recurse -Force
    $commandCount = (Get-ChildItem -Path $destCommands -Filter "*.md" | Measure-Object).Count
    Write-Success "  ✓ Installed $commandCount commands"
} else {
    Write-Warning "  Commands directory not found"
}

# Copy agents
$sourceAgents = Join-Path $scriptDir ".claude" "agents"
$destAgents = Join-Path $claudePath "agents"

if (Test-Path $sourceAgents) {
    if (-not (Test-Path $destAgents)) {
        New-Item -ItemType Directory -Path $destAgents -Force | Out-Null
    }
    Copy-Item -Path "$sourceAgents\*" -Destination $destAgents -Recurse -Force
    $agentCount = (Get-ChildItem -Path $destAgents -Filter "*.md" | Measure-Object).Count
    Write-Success "  ✓ Installed $agentCount agents"
} else {
    Write-Warning "  Agents directory not found"
}

Write-Success "`n✓ Claudify installation complete!"

# Final success message
Write-Host "`n" + ("=" * 60) -ForegroundColor Green
Write-Success " CLAUDIFY SETUP COMPLETE!"
Write-Host ("=" * 60) -ForegroundColor Green
Write-Host ""
Write-Info "📁 Location: $claudePath"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Navigate to your project directory:" -ForegroundColor White
Write-Host "     cd src/YourProject.Web" -ForegroundColor Gray
Write-Host "  2. Launch Claude Code:" -ForegroundColor White
Write-Host "     claude" -ForegroundColor Gray
Write-Host "  3. Try a command:" -ForegroundColor White
Write-Host "     /add-frontend-feature \"My Feature\"" -ForegroundColor Gray
Write-Host ""
Write-Host "Commands automatically detect your conventions by examining existing code." -ForegroundColor Cyan
Write-Host ""
Write-Info "View all commands: Run 'claude' and type /"
Write-Info "Documentation: $scriptDir\README.md"
Write-Host ""
