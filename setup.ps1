# Claudify - Setup Script v4.0.0
# Cross-platform setup for Windows, Linux, and macOS
#
# Usage:
#   Windows:  .\setup.ps1 -TargetRepository "C:\path\to\your\repo"
#   Linux/Mac: pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
#
# Optional Flags:
#   -RefreshAnalysis   Refresh project convention analysis only (requires Node.js 18+)

param(
    [Parameter(Mandatory=$true, Position=0)]
    [Alias("Path", "p", "Repository", "Repo")]
    [string]$TargetRepository,

    [Parameter(Mandatory=$false)]
    [switch]$RefreshAnalysis
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

# Handle Refresh Analysis mode
if ($RefreshAnalysis) {
    Write-Info "🔄 Refreshing Convention Analysis..."

    $nodeExists = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeExists) {
        Write-Error "Node.js not found. Install Node.js 18+ to run convention analysis."
        Write-Info "Or use Adaptive Mode (commands detect patterns on-demand)."
        exit 1
    }

    $analyzerPath = Join-Path $scriptDir ".claudify-sdk" "dist" "analyzer.js"
    if (-not (Test-Path $analyzerPath)) {
        Write-Error "Analyzer not found at: $analyzerPath"
        exit 1
    }

    $configPath = Join-Path $TargetRepository ".claude" "config"
    New-Item -ItemType Directory -Path $configPath -Force | Out-Null

    Write-Info "Analyzing project conventions..."
    $outputPath = Join-Path $configPath "project-knowledge.json"

    try {
        node $analyzerPath $TargetRepository $outputPath
        Write-Success "✓ Convention analysis complete: $outputPath"

        # Update mode config
        $claudifyConfig = @{
            mode = "smart"
            analyzedAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        } | ConvertTo-Json
        Set-Content -Path (Join-Path $configPath "claudify.json") -Value $claudifyConfig

    } catch {
        Write-Error "Analysis failed: $_"
        exit 1
    }

    exit 0
}

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

# Copy config directory structure (but not old config files)
$sourceConfig = Join-Path $scriptDir ".claude" "config"
$destConfig = Join-Path $claudePath "config"
if (-not (Test-Path $destConfig)) {
    New-Item -ItemType Directory -Path $destConfig -Force | Out-Null
}

Write-Success "`n✓ Claudify components installed!"

# Mode selection
Write-Host "`n" + ("-" * 60) -ForegroundColor DarkGray
Write-Host " [AI] Convention Detection Mode" -ForegroundColor Cyan
Write-Host ("-" * 60) -ForegroundColor DarkGray
Write-Host ""
Write-Host "Claudify can analyze your project conventions to generate matching code." -ForegroundColor White
Write-Host ""
Write-Host "Choose detection mode:" -ForegroundColor Yellow
Write-Host "  [1] SMART MODE (Recommended)" -ForegroundColor Green
Write-Host "      • Analyzes your project once (~60 seconds)" -ForegroundColor White
Write-Host "      • Commands generate matching code instantly" -ForegroundColor White
Write-Host "      • 95-100% accuracy, best for established projects`n" -ForegroundColor White
Write-Host "  [2] ADAPTIVE MODE (Lightweight)" -ForegroundColor Yellow
Write-Host "      • Skips analysis, commands examine code on-demand" -ForegroundColor White
Write-Host "      • 90% accuracy, always reflects current code" -ForegroundColor White
Write-Host "      • Best for rapidly changing codebases`n" -ForegroundColor White
Write-Host "Select mode [1/2] (default: 1): " -NoNewline -ForegroundColor Yellow
$modeResponse = Read-Host

if ([string]::IsNullOrWhiteSpace($modeResponse)) {
    $modeResponse = '1'
}

$skipAnalyzer = $false
$conventionMode = "smart"

switch ($modeResponse) {
    '1' {
        $conventionMode = "smart"
        $skipAnalyzer = $false
        Write-Host ""
        Write-Success "✓ Smart Mode selected - running analyzer..."
    }
    '2' {
        $conventionMode = "adaptive"
        $skipAnalyzer = $true
        Write-Host ""
        Write-Success "✓ Adaptive Mode selected - commands will examine code on-demand"
    }
    default {
        $conventionMode = "smart"
        $skipAnalyzer = $false
        Write-Host ""
        Write-Success "✓ Smart Mode selected (default) - running analyzer..."
    }
}

# Run analyzer if Smart Mode
if (-not $skipAnalyzer) {
    $nodeExists = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeExists) {
        Write-Warning "`nNode.js not found. Falling back to Adaptive Mode."
        Write-Info "Commands will examine code on-demand (no pre-analysis)."
        Write-Info "To use Smart Mode: Install Node.js 18+ and run: .\setup.ps1 -RefreshAnalysis"
        $conventionMode = "adaptive"
        $skipAnalyzer = $true
    } else {
        $analyzerPath = Join-Path $scriptDir ".claudify-sdk" "dist" "analyzer.js"
        if (-not (Test-Path $analyzerPath)) {
            Write-Warning "Analyzer not found. Falling back to Adaptive Mode."
            $conventionMode = "adaptive"
            $skipAnalyzer = $true
        } else {
            Write-Info "Analyzing project conventions (this may take ~60 seconds)..."
            $outputPath = Join-Path $destConfig "project-knowledge.json"

            try {
                node $analyzerPath $TargetRepository $outputPath 2>&1 | Out-Null
                if (Test-Path $outputPath) {
                    Write-Success "✓ Convention analysis complete"
                } else {
                    Write-Warning "Analysis did not generate output. Using Adaptive Mode."
                    $conventionMode = "adaptive"
                }
            } catch {
                Write-Warning "Analysis failed: $($_.Exception.Message)"
                Write-Info "Falling back to Adaptive Mode."
                $conventionMode = "adaptive"
            }
        }
    }
}

# Save mode configuration
$claudifyConfig = @{
    mode = $conventionMode
    configuredAt = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
} | ConvertTo-Json
Set-Content -Path (Join-Path $destConfig "claudify.json") -Value $claudifyConfig

# Final success message
Write-Host "`n" + ("=" * 60) -ForegroundColor Green
Write-Success " CLAUDIFY SETUP COMPLETE!"
Write-Host ("=" * 60) -ForegroundColor Green
Write-Host ""
Write-Info "🎯 Mode: $conventionMode"
Write-Info "📁 Location: $claudePath"
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Navigate to your project directory:" -ForegroundColor White
Write-Host "     cd $TargetRepository" -ForegroundColor Gray
Write-Host "  2. Launch Claude Code:" -ForegroundColor White
Write-Host "     claude" -ForegroundColor Gray
Write-Host "  3. Try a command:" -ForegroundColor White
Write-Host "     /add-frontend-feature \"My Feature\"" -ForegroundColor Gray
Write-Host ""
Write-Host "Commands will automatically work in your current directory context." -ForegroundColor Cyan
Write-Host ""
Write-Info "View all commands: Run 'claude' and type /help"
Write-Info "Documentation: $scriptDir\README.md"
Write-Host ""
