# Claudify - Minimal Setup Script
# Cross-platform setup for Windows, Linux, and macOS
# 
# Usage: 
#   Windows:  .\setup.ps1 -TargetRepository "C:\path\to\your\repo"
#   Linux/Mac: pwsh setup.ps1 -TargetRepository "/path/to/your/repo"

param(
    [Parameter(
        Mandatory=$true, 
        Position=0,
        HelpMessage="Enter the full path to your target repository where Claude Code will be initialized. This can be an existing project or a new directory."
    )]
    [Alias("Path", "p", "Repository", "Repo")]
    [string]$TargetRepository
)

$ErrorActionPreference = "Stop"

# Get version
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$versionFile = Join-Path $scriptDir "VERSION"
$version = if (Test-Path $versionFile) { Get-Content $versionFile -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() } } else { "unknown" }

# Display Claudify banner
Write-Host "`n"
Write-Host "     ██████╗██╗      █████╗ ██╗   ██╗██████╗ ██╗███████╗██╗   ██╗" -ForegroundColor Cyan
Write-Host "    ██╔════╝██║     ██╔══██╗██║   ██║██╔══██╗██║██╔════╝╚██╗ ██╔╝" -ForegroundColor Cyan
Write-Host "    ██║     ██║     ███████║██║   ██║██║  ██║██║█████╗   ╚████╔╝ " -ForegroundColor Cyan
Write-Host "    ██║     ██║     ██╔══██║██║   ██║██║  ██║██║██╔══╝    ╚██╔╝  " -ForegroundColor Cyan
Write-Host "    ╚██████╗███████╗██║  ██║╚██████╔╝██████╔╝██║██║        ██║   " -ForegroundColor Cyan
Write-Host "     ╚═════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝╚═╝        ╚═╝   " -ForegroundColor Cyan
Write-Host "`n    Intelligent Claude Code Setup for Your Repository" -ForegroundColor White
Write-Host "    Version $version" -ForegroundColor DarkGray
Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
Write-Host "`n"
Write-Host "    $ whoami" -ForegroundColor Yellow
Write-Host "    > GranatenUdo | Tobias Ens" -ForegroundColor Yellow
Write-Host "    > Claudify - Smart Claude Code Setup" -ForegroundColor Yellow
Write-Host "`n"

# Check for existing installation
$existingVersionPath = Join-Path $TargetRepository ".claude" "VERSION"
$existingVersion = $null
if (Test-Path $existingVersionPath) {
    $existingVersion = Get-Content $existingVersionPath -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() }
    Write-Host "    📦 " -NoNewline -ForegroundColor Cyan
    Write-Host "Existing Installation Detected: " -NoNewline -ForegroundColor White
    Write-Host "v$existingVersion" -ForegroundColor Yellow
    
    if ($existingVersion -ne $version) {
        Write-Host "    🔄 " -NoNewline -ForegroundColor Green
        Write-Host "Update Available: " -NoNewline -ForegroundColor White
        Write-Host "v$existingVersion → v$version" -ForegroundColor Yellow
        Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
    } else {
        Write-Host "    ✓ " -NoNewline -ForegroundColor Green
        Write-Host "Already on latest version" -ForegroundColor White
        Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
    }
    Write-Host "`n"
}

# Check for version 1.4.0 and recommend clean install
$recommendClean = $false
if ($version -eq "1.4.0" -and ($existingVersion -eq $null -or $existingVersion -lt "1.4.0")) {
    Write-Host "    🆕 " -NoNewline -ForegroundColor Cyan
    Write-Host "Version 1.4.0 Major Update!" -ForegroundColor Yellow
    Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
    Write-Host "    This major update includes:" -ForegroundColor White
    Write-Host "    • Opus 4 optimized agents with parallel analysis" -ForegroundColor Green
    Write-Host "    • Extended thinking capabilities (65536 tokens)" -ForegroundColor Green
    Write-Host "    • AI-powered generation with confidence scoring" -ForegroundColor Green
    Write-Host "    • Enhanced collaboration protocols" -ForegroundColor Green
    Write-Host "    • Improved command agent dependencies" -ForegroundColor Green
    Write-Host "`n"
    $recommendClean = $true
}

if ($recommendClean) {
    Write-Host "⚠️  " -NoNewline -ForegroundColor Yellow
    Write-Host "Clean installation is " -NoNewline -ForegroundColor White
    Write-Host "STRONGLY RECOMMENDED" -NoNewline -ForegroundColor Yellow
    Write-Host " for version 1.4.0" -ForegroundColor White
    Write-Host "   This ensures all new Opus 4 optimizations are properly installed." -ForegroundColor DarkGray
    Write-Host "`n"
}

Write-Host "Would you like to perform a clean installation? (Y/N)" -ForegroundColor Yellow
Write-Host "This will remove all existing Claudify components before installing." -ForegroundColor DarkGray
if ($recommendClean) {
    Write-Host "[Recommended: Y]" -NoNewline -ForegroundColor Green
    Write-Host ": " -NoNewline
} else {
    Write-Host "[Default: N]: " -NoNewline
}

$cleanResponse = Read-Host
$CleanInstall = ($cleanResponse -eq 'Y' -or $cleanResponse -eq 'y')

if ($CleanInstall) {
    Write-Host "✓ Clean installation selected" -ForegroundColor Green
} else {
    if ($recommendClean) {
        Write-Host "⚠️  Proceeding with normal installation (not recommended for v1.4.0)" -ForegroundColor Yellow
    } else {
        Write-Host "✓ Normal installation selected" -ForegroundColor Green
    }
}
Write-Host "`n"

# Sanitize the target repository path
# Remove surrounding quotes (both single and double)
$TargetRepository = $TargetRepository.Trim()
if ($TargetRepository.StartsWith('"') -and $TargetRepository.EndsWith('"')) {
    $TargetRepository = $TargetRepository.Substring(1, $TargetRepository.Length - 2)
}
elseif ($TargetRepository.StartsWith("'") -and $TargetRepository.EndsWith("'")) {
    $TargetRepository = $TargetRepository.Substring(1, $TargetRepository.Length - 2)
}

# Resolve to absolute path
try {
    $TargetRepository = [System.IO.Path]::GetFullPath($TargetRepository)
} catch {
    Write-Host "Error: Invalid path format: $TargetRepository" -ForegroundColor Red
    Write-Host "Please provide a valid directory path." -ForegroundColor Yellow
    exit 1
}

# Validate target repository exists
if (-not (Test-Path $TargetRepository)) {
    Write-Host "Error: Target repository not found: $TargetRepository" -ForegroundColor Red
    Write-Host "`nWould you like to create this directory? (Y/N): " -NoNewline -ForegroundColor Yellow
    $response = Read-Host
    if ($response -eq 'Y' -or $response -eq 'y') {
        try {
            New-Item -ItemType Directory -Path $TargetRepository -Force | Out-Null
            Write-Host "Directory created successfully!" -ForegroundColor Green
        } catch {
            Write-Host "Error creating directory: $_" -ForegroundColor Red
            exit 1
        }
    } else {
        Write-Host "Setup cancelled. Please specify an existing directory or allow creation." -ForegroundColor Yellow
        exit 1
    }
}

Write-Host "Target Repository: " -NoNewline -ForegroundColor White
Write-Host $TargetRepository -ForegroundColor Green

# Clean install logic
if ($CleanInstall) {
    Write-Host "`n🧹  Clean Install Mode" -ForegroundColor Cyan
    Write-Host "Preparing to remove existing Claudify components..." -ForegroundColor White
    Write-Host "Affected items:" -ForegroundColor DarkGray
    Write-Host "  - .claude/commands/* (all commands)" -ForegroundColor DarkGray
    Write-Host "  - .claude/agents/* (all agents)" -ForegroundColor DarkGray
    Write-Host "  - .claude/agent-tools/* (all agent tools)" -ForegroundColor DarkGray
    Write-Host "  - .claude/agent-configs/* (all agent configs)" -ForegroundColor DarkGray
    Write-Host "  - .claude/hooks/* (all hooks)" -ForegroundColor DarkGray
    Write-Host "  - .claudify/* (all cached resources)" -ForegroundColor DarkGray
    Write-Host "  - CLAUDE.md (if exists)" -ForegroundColor DarkGray
    Write-Host "  - FEATURES.md (if exists)" -ForegroundColor DarkGray
    
    Write-Host "`nPerforming clean removal..." -ForegroundColor Cyan
        
        # Remove .claude directory contents
        $claudePath = Join-Path $TargetRepository ".claude"
        if (Test-Path $claudePath) {
            Write-Host "  - Removing .claude directory..." -ForegroundColor DarkGray
            Remove-Item -Path $claudePath -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Remove .claudify directory
        $claudifyPath = Join-Path $TargetRepository ".claudify"
        if (Test-Path $claudifyPath) {
            Write-Host "  - Removing .claudify directory..." -ForegroundColor DarkGray
            Remove-Item -Path $claudifyPath -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Remove CLAUDE.md if exists
        $claudeMdPath = Join-Path $TargetRepository "CLAUDE.md"
        if (Test-Path $claudeMdPath) {
            Write-Host "  - Removing CLAUDE.md..." -ForegroundColor DarkGray
            Remove-Item -Path $claudeMdPath -Force -ErrorAction SilentlyContinue
        }
        
        # Remove FEATURES.md if exists
        $featuresMdPath = Join-Path $TargetRepository "FEATURES.md"
        if (Test-Path $featuresMdPath) {
            Write-Host "  - Removing FEATURES.md..." -ForegroundColor DarkGray
            Remove-Item -Path $featuresMdPath -Force -ErrorAction SilentlyContinue
        }
        
    Write-Host "✓ Clean removal complete!" -ForegroundColor Green
    Write-Host "`nProceeding with fresh installation..." -ForegroundColor Cyan
}

# Create .claude/commands directory structure (cross-platform)
$commandsPath = Join-Path $TargetRepository ".claude" "commands"
Write-Host "`nCreating Claude Code directory structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $commandsPath -Force | Out-Null

# Copy the init command from claudify
$initCommand = Join-Path $scriptDir ".claude" "commands" "init-claudify.md"
$destPath = Join-Path $commandsPath "init-claudify.md"

if (-not (Test-Path $initCommand)) {
    Write-Host "Error: init-claudify.md not found at: $initCommand" -ForegroundColor Red
    Write-Host "Please ensure you're running this script from the claudify directory." -ForegroundColor Yellow
    exit 1
}

Write-Host "Copying initialization command..." -ForegroundColor Cyan
Copy-Item $initCommand -Destination $destPath -Force

# Create VERSION file in .claude directory for update tracking
$targetVersionPath = Join-Path $TargetRepository ".claude" "VERSION"
Write-Host "Creating version tracking file..." -ForegroundColor Cyan
Set-Content -Path $targetVersionPath -Value $version -NoNewline

# Create installation metadata
$installMetadata = @{
    version = $version
    installDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    installType = if ($CleanInstall) { "clean" } else { "normal" }
    sourcePath = $scriptDir
}
$metadataPath = Join-Path $TargetRepository ".claude" "install-metadata.json"
$installMetadata | ConvertTo-Json | Set-Content -Path $metadataPath -NoNewline

# Handle .gitignore
$gitignorePath = Join-Path $TargetRepository ".gitignore"
Write-Host "Checking .gitignore..." -ForegroundColor Cyan

$gitignoreUpdated = $false
if (Test-Path $gitignorePath) {
    # Read existing .gitignore
    $gitignoreContent = Get-Content $gitignorePath -Raw
    if ($gitignoreContent -notmatch '\.claudify') {
        # Add .claudify if not already present
        Write-Host "  - Adding .claudify to existing .gitignore" -ForegroundColor DarkGray
        Add-Content -Path $gitignorePath -Value "`n# Claudify temporary resources`n.claudify" -NoNewline
        $gitignoreUpdated = $true
    } else {
        Write-Host "  - .claudify already in .gitignore" -ForegroundColor DarkGray
    }
} else {
    # Create new .gitignore
    Write-Host "  - Creating .gitignore with .claudify exclusion" -ForegroundColor DarkGray
    Set-Content -Path $gitignorePath -Value "# Claudify temporary resources`n.claudify" -NoNewline
    $gitignoreUpdated = $true
}

if ($gitignoreUpdated) {
    Write-Host "✓ .gitignore updated successfully" -ForegroundColor Green
}

# Create temporary claudify resources directory
$tempClaudifyPath = Join-Path $TargetRepository ".claudify"
Write-Host "`nCopying claudify resources to .claudify directory..." -ForegroundColor Cyan

# Copy entire claudify directory structure (excluding .git and other unnecessary files)
New-Item -ItemType Directory -Path $tempClaudifyPath -Force | Out-Null
$excludePatterns = @('.git', '.gitignore', '*.log', 'test-*', 'signature-options.txt', 'bug-fix-proposal.md')

# Copy .claude directory
$sourceClaudePath = Join-Path $scriptDir ".claude"
$destClaudePath = Join-Path $tempClaudifyPath ".claude"
if (Test-Path $sourceClaudePath) {
    Write-Host "  - Copying .claude directory..." -ForegroundColor DarkGray
    Copy-Item -Path $sourceClaudePath -Destination $destClaudePath -Recurse -Force
}

# Copy components-manifest.json
$sourceManifest = Join-Path $scriptDir "components-manifest.json"
$destManifest = Join-Path $tempClaudifyPath "components-manifest.json"
if (Test-Path $sourceManifest) {
    Write-Host "  - Copying components manifest..." -ForegroundColor DarkGray
    Copy-Item -Path $sourceManifest -Destination $destManifest -Force
}

# Copy VERSION file
$sourceVersion = Join-Path $scriptDir "VERSION"
$destVersion = Join-Path $tempClaudifyPath "VERSION"
if (Test-Path $sourceVersion) {
    Write-Host "  - Copying version file..." -ForegroundColor DarkGray
    Copy-Item -Path $sourceVersion -Destination $destVersion -Force
}

# Copy templates directory
$sourceTemplates = Join-Path $scriptDir "templates"
$destTemplates = Join-Path $tempClaudifyPath "templates"
if (Test-Path $sourceTemplates) {
    Write-Host "  - Copying templates..." -ForegroundColor DarkGray
    Copy-Item -Path $sourceTemplates -Destination $destTemplates -Recurse -Force
}

# Copy scripts directory
$sourceScripts = Join-Path $scriptDir "scripts"
$destScripts = Join-Path $tempClaudifyPath "scripts"
if (Test-Path $sourceScripts) {
    Write-Host "  - Copying scripts directory..." -ForegroundColor DarkGray
    Copy-Item -Path $sourceScripts -Destination $destScripts -Recurse -Force
}

# Copy important documentation files
$docFiles = @(
    "README.md",
    "SETUP-GUIDE.md",
    "CHANGELOG.md",
    "AGENT-COLLABORATION-GUIDE.md",
    "AGENT-COLLABORATION-EXAMPLES.md"
)

Write-Host "  - Copying documentation files..." -ForegroundColor DarkGray
foreach ($docFile in $docFiles) {
    $sourceDoc = Join-Path $scriptDir $docFile
    $destDoc = Join-Path $tempClaudifyPath $docFile
    if (Test-Path $sourceDoc) {
        Copy-Item -Path $sourceDoc -Destination $destDoc -Force
    }
}

Write-Host "Claudify resources copied to .claudify successfully!" -ForegroundColor Green
Write-Host "Note: .claudify is excluded from git via .gitignore" -ForegroundColor DarkGray
Write-Host "      This directory will persist to allow re-running /init-claudify" -ForegroundColor DarkGray
if ($version -eq "1.4.0") {
    Write-Host "      " -NoNewline -ForegroundColor DarkGray
    Write-Host "✨ Version $version includes Opus 4 optimized agents" -ForegroundColor Cyan
}

# Display success message and instructions
Write-Host "`n" + ("─" * 60) -ForegroundColor DarkGray
Write-Host " ✓ Setup Complete!" -ForegroundColor Green
Write-Host ("─" * 60) -ForegroundColor DarkGray

Write-Host "`nNext steps:" -ForegroundColor Cyan
Write-Host "  1. " -NoNewline -ForegroundColor DarkGray
Write-Host "Open a terminal in: " -NoNewline -ForegroundColor White
Write-Host $TargetRepository -ForegroundColor Yellow

Write-Host "  2. " -NoNewline -ForegroundColor DarkGray
Write-Host "Run: " -NoNewline -ForegroundColor White
Write-Host "claude code" -ForegroundColor Yellow

Write-Host "  3. " -NoNewline -ForegroundColor DarkGray
Write-Host "In Claude Code, execute: " -NoNewline -ForegroundColor White
Write-Host "/init-claudify 'your project description'" -ForegroundColor Yellow

if ($CleanInstall) {
    Write-Host "`n  🆕 " -NoNewline -ForegroundColor Cyan
    Write-Host "Clean Install Complete: " -NoNewline -ForegroundColor White
    Write-Host "Fresh Claudify $version installation" -ForegroundColor Green
    Write-Host "     All previous components have been removed." -ForegroundColor DarkGray
    Write-Host "     Ready for Opus 4 optimized configuration." -ForegroundColor DarkGray
}

Write-Host "`n" + ("─" * 60) -ForegroundColor DarkGray
Write-Host "This will intelligently set up your complete Claude Code environment" -ForegroundColor White
Write-Host "based on your project's technology stack and architecture patterns." -ForegroundColor White
Write-Host ("─" * 60) -ForegroundColor DarkGray
Write-Host "`n"