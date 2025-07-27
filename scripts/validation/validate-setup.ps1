# Validate Claude Code Setup
param(
    [Parameter(Mandatory=$true)]
    [string]$TargetRepository
)

$ErrorActionPreference = "Stop"
$ValidationPassed = $true

Write-Host @"
╔═══════════════════════════════════════════════════════════════╗
║           Claude Code Setup Validation                          ║
╚═══════════════════════════════════════════════════════════════╝
"@ -ForegroundColor Cyan

Write-Host "`nValidating setup in: $TargetRepository" -ForegroundColor Yellow

# Check if target exists
if (-not (Test-Path $TargetRepository)) {
    Write-Host "❌ Target repository not found: $TargetRepository" -ForegroundColor Red
    exit 1
}

# Function to check file/directory existence
function Test-SetupItem {
    param(
        [string]$Path,
        [string]$Description,
        [switch]$Required
    )
    
    $FullPath = Join-Path $TargetRepository $Path
    if (Test-Path $FullPath) {
        Write-Host "  ✓ $Description" -ForegroundColor Green
        return $true
    } else {
        if ($Required) {
            Write-Host "  ❌ $Description (REQUIRED)" -ForegroundColor Red
            $script:ValidationPassed = $false
        } else {
            Write-Host "  ⚠️  $Description (Optional)" -ForegroundColor Yellow
        }
        return $false
    }
}

# Core files
Write-Host "`n📄 Core Files:" -ForegroundColor Cyan
Test-SetupItem -Path "CLAUDE.md" -Description "CLAUDE.md exists" -Required
Test-SetupItem -Path "FEATURES.md" -Description "FEATURES.md exists"

# Claude directory structure
Write-Host "`n📁 Claude Configuration:" -ForegroundColor Cyan
Test-SetupItem -Path ".claude" -Description ".claude directory exists" -Required
Test-SetupItem -Path ".claude/settings.json" -Description "Settings configured" -Required
Test-SetupItem -Path ".claude/agents" -Description "Agents directory exists" -Required
Test-SetupItem -Path ".claude/commands" -Description "Commands directory exists" -Required
Test-SetupItem -Path ".claude/hooks" -Description "Hooks directory exists" -Required

# Check for at least one agent
Write-Host "`n🤖 Agents:" -ForegroundColor Cyan
$AgentPath = Join-Path $TargetRepository ".claude/agents"
if (Test-Path $AgentPath) {
    $AgentFiles = Get-ChildItem -Path $AgentPath -Filter "*.md" -ErrorAction SilentlyContinue
    if ($AgentFiles.Count -gt 0) {
        Write-Host "  ✓ Found $($AgentFiles.Count) agent(s)" -ForegroundColor Green
        foreach ($Agent in $AgentFiles) {
            Write-Host "    - $($Agent.BaseName)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠️  No agents found" -ForegroundColor Yellow
    }
}

# Check for commands
Write-Host "`n📝 Commands:" -ForegroundColor Cyan
$CommandPath = Join-Path $TargetRepository ".claude/commands"
if (Test-Path $CommandPath) {
    $CommandFiles = Get-ChildItem -Path $CommandPath -Filter "*.md" -ErrorAction SilentlyContinue
    if ($CommandFiles.Count -gt 0) {
        Write-Host "  ✓ Found $($CommandFiles.Count) command(s)" -ForegroundColor Green
        foreach ($Command in $CommandFiles) {
            Write-Host "    - /$($Command.BaseName)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠️  No commands found" -ForegroundColor Yellow
    }
}

# Check hooks
Write-Host "`n🔒 Security Hooks:" -ForegroundColor Cyan
$HooksPath = Join-Path $TargetRepository ".claude/hooks"
if (Test-Path $HooksPath) {
    $HookFiles = Get-ChildItem -Path $HooksPath -Filter "*.ps1" -ErrorAction SilentlyContinue
    if ($HookFiles.Count -gt 0) {
        Write-Host "  ✓ Found $($HookFiles.Count) hook(s)" -ForegroundColor Green
        foreach ($Hook in $HookFiles) {
            Write-Host "    - $($Hook.BaseName)" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠️  No hooks found" -ForegroundColor Yellow
    }
}

# Scripts directory
Write-Host "`n📂 Scripts:" -ForegroundColor Cyan
Test-SetupItem -Path "scripts" -Description "Scripts directory exists"
Test-SetupItem -Path "scripts/setup" -Description "Setup scripts directory"
Test-SetupItem -Path "scripts/README.md" -Description "Scripts documentation"

# Validate settings.json structure
Write-Host "`n⚙️  Settings Validation:" -ForegroundColor Cyan
$SettingsPath = Join-Path $TargetRepository ".claude/settings.json"
if (Test-Path $SettingsPath) {
    try {
        $Settings = Get-Content $SettingsPath | ConvertFrom-Json
        
        if ($Settings.hooks) {
            Write-Host "  ✓ Hooks configuration found" -ForegroundColor Green
        }
        if ($Settings.env) {
            Write-Host "  ✓ Environment variables configured" -ForegroundColor Green
        }
        if ($Settings.permissions) {
            Write-Host "  ✓ Permissions configured" -ForegroundColor Green
        }
    } catch {
        Write-Host "  ❌ Invalid settings.json format" -ForegroundColor Red
        $ValidationPassed = $false
    }
}

# Check CLAUDE.md content
Write-Host "`n📋 CLAUDE.md Content Check:" -ForegroundColor Cyan
$ClaudeMdPath = Join-Path $TargetRepository "CLAUDE.md"
if (Test-Path $ClaudeMdPath) {
    $Content = Get-Content $ClaudeMdPath -Raw
    
    # Check for key sections
    $RequiredSections = @(
        @{Pattern = "ACTIVATION INSTRUCTIONS"; Description = "Activation instructions"},
        @{Pattern = "PROJECT CONTEXT"; Description = "Project context"},
        @{Pattern = "CRITICAL RULES"; Description = "Critical rules"},
        @{Pattern = "CODE STANDARDS"; Description = "Code standards"}
    )
    
    foreach ($Section in $RequiredSections) {
        if ($Content -match $Section.Pattern) {
            Write-Host "  ✓ $($Section.Description) section found" -ForegroundColor Green
        } else {
            Write-Host "  ❌ Missing $($Section.Description) section" -ForegroundColor Red
            $ValidationPassed = $false
        }
    }
}

# Summary
Write-Host "`n" -NoNewline
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan

if ($ValidationPassed) {
    Write-Host "✅ Validation Passed!" -ForegroundColor Green
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    Write-Host "`n🎉 Your Claude Code setup is complete and valid!" -ForegroundColor Green
    Write-Host "`n🚀 Next steps:" -ForegroundColor Yellow
    Write-Host "  1. Open the project in Claude Code"
    Write-Host "  2. Try a command like: /add-backend-feature"
    Write-Host "  3. Review CLAUDE.md for project guidelines"
    
    exit 0
} else {
    Write-Host "❌ Validation Failed!" -ForegroundColor Red
    Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    
    Write-Host "`n⚠️  Please fix the issues above and run validation again." -ForegroundColor Yellow
    Write-Host "`nTo fix issues, you can:" -ForegroundColor Cyan
    Write-Host "  1. Re-run setup with -OverwriteExisting flag"
    Write-Host "  2. Manually create missing files"
    Write-Host "  3. Check the template documentation"
    
    exit 1
}