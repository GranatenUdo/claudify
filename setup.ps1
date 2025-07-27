# Claudify - Minimal Setup Script
# Cross-platform setup for Windows, Linux, and macOS
# 
# Usage: 
#   Windows:  .\setup.ps1 -TargetRepository "C:\path\to\your\repo"
#   Linux/Mac: pwsh setup.ps1 -TargetRepository "/path/to/your/repo"

param(
    [Parameter(Mandatory=$true, HelpMessage="Path to the target repository")]
    [string]$TargetRepository
)

$ErrorActionPreference = "Stop"

# Validate target repository exists
if (-not (Test-Path $TargetRepository)) {
    Write-Host "Error: Target repository not found: $TargetRepository" -ForegroundColor Red
    exit 1
}

# Create .claude/commands directory structure (cross-platform)
$commandsPath = Join-Path $TargetRepository ".claude" "commands"
Write-Host "Creating Claude Code directory structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $commandsPath -Force | Out-Null

# Copy the init command from claudify
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$initCommand = Join-Path $scriptDir ".claude" "commands" "init-claudify.md"
$destPath = Join-Path $commandsPath "init-claudify.md"

if (-not (Test-Path $initCommand)) {
    Write-Host "Error: init-claudify.md not found at: $initCommand" -ForegroundColor Red
    exit 1
}

Write-Host "Copying initialization command..." -ForegroundColor Cyan
Copy-Item $initCommand -Destination $destPath -Force

# Display success message and instructions
Write-Host "`nSetup complete!" -ForegroundColor Green
Write-Host ("-" * 50) -ForegroundColor DarkGray
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Open a terminal in: " -NoNewline -ForegroundColor White
Write-Host $TargetRepository -ForegroundColor Yellow
Write-Host "2. Run: " -NoNewline -ForegroundColor White
Write-Host "claude code" -ForegroundColor Yellow
Write-Host "3. In Claude Code, execute: " -NoNewline -ForegroundColor White
Write-Host "/init-claudify 'your project description'" -ForegroundColor Yellow
Write-Host "`nThis will intelligently set up your complete Claude Code environment."
Write-Host ("-" * 50) -ForegroundColor DarkGray