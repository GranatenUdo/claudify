# Claudify - Intelligent Setup Script v4.0.0
# Cross-platform setup for Windows, Linux, and macOS
#
# Usage:
#   Windows:  .\setup.ps1 -TargetRepository "C:\path\to\your\repo"
#   Linux/Mac: pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
#
# Optional Flags:
#   -RefreshAnalysis   Refresh project convention analysis (requires Node.js 18+)
#
# Quick Commands:
#   .\setup.ps1 "C:\MyProject"             # Full setup with mode selection
#   .\setup.ps1 "C:\MyProject" -RefreshAnalysis  # Re-analyze conventions only

param(
    [Parameter(
        Mandatory=$true,
        Position=0,
        HelpMessage="Enter the full path to your target repository where Claude Code will be initialized. This can be an existing project or a new directory."
    )]
    [Alias("Path", "p", "Repository", "Repo")]
    [string]$TargetRepository,

    [Parameter(
        Mandatory=$false,
        HelpMessage="Refresh the project convention analysis only (requires Node.js 18+)."
    )]
    [switch]$RefreshAnalysis
)

$ErrorActionPreference = "Stop"

# Get version
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$versionFile = Join-Path $scriptDir "VERSION"
$version = if (Test-Path $versionFile) { Get-Content $versionFile -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() } } else { "unknown" }

# Handle Refresh Analysis mode (quick exit)
if ($RefreshAnalysis) {
    # Sanitize path
    $TargetRepository = $TargetRepository.Trim()
    if ($TargetRepository.StartsWith('"') -and $TargetRepository.EndsWith('"')) {
        $TargetRepository = $TargetRepository.Substring(1, $TargetRepository.Length - 2)
    }
    $TargetRepository = [System.IO.Path]::GetFullPath($TargetRepository)

    Write-Host "`n🔄 Refreshing Convention Analysis..." -ForegroundColor Cyan

    # Check Node.js
    $nodeExists = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeExists) {
        Write-Host "❌ Error: Node.js not found" -ForegroundColor Red
        Write-Host "Install Node.js 18+ to enable convention analysis" -ForegroundColor Yellow
        exit 1
    }

    $nodeVersion = node --version 2>$null
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Gray

    # Run analyzer
    $analyzerPath = Join-Path $scriptDir ".claudify-sdk" "dist" "project-analyzer.bundle.js"
    $claudePath = Join-Path $TargetRepository ".claude"
    $configPath = Join-Path $claudePath "config"
    $knowledgePath = Join-Path $configPath "project-knowledge.json"

    if (-not (Test-Path $analyzerPath)) {
        Write-Host "❌ Error: Analyzer not found at: $analyzerPath" -ForegroundColor Red
        Write-Host "Run: cd .claudify-sdk && npm install && npm run build" -ForegroundColor Yellow
        exit 1
    }

    # Ensure config directory exists
    if (-not (Test-Path $configPath)) {
        New-Item -ItemType Directory -Path $configPath -Force | Out-Null
    }

    try {
        Write-Host "Analyzing project..." -ForegroundColor Cyan
        $analyzerResult = node $analyzerPath --project $TargetRepository --output $knowledgePath 2>&1

        if ($LASTEXITCODE -eq 0) {
            Write-Host "✅ Convention analysis complete!" -ForegroundColor Green
            Write-Host "Saved to: .claude/config/project-knowledge.json" -ForegroundColor Gray

            # Create or update mode config
            $modeConfigPath = Join-Path $configPath "claudify.json"
            if (Test-Path $modeConfigPath) {
                $modeConfig = Get-Content $modeConfigPath -Raw | ConvertFrom-Json
                $modeConfig.analyzedAt = (Get-Date -Format "o")
                $modeConfig.mode = "smart"
            } else {
                $modeConfig = @{
                    mode = "smart"
                    analyzedAt = (Get-Date -Format "o")
                    version = $version
                    installDate = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
                }
            }
            $modeConfig | ConvertTo-Json | Set-Content $modeConfigPath -NoNewline

            exit 0
        } else {
            Write-Host "❌ Analysis failed: $analyzerResult" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "❌ Analysis error: $_" -ForegroundColor Red
        exit 1
    }
}

# Display Claudify banner
Write-Host "`n"
Write-Host "    +--- CLAUDIFY ---+ Smart Claude Code Setup v$version" -ForegroundColor Cyan
Write-Host "    +----------------+ github.com/claudify" -ForegroundColor DarkGray
Write-Host "    $ whoami" -ForegroundColor Yellow
Write-Host "    > GranatenUdo | Tobi" -ForegroundColor Yellow

# Check for existing installation
$existingVersionPath = Join-Path $TargetRepository ".claude" "VERSION"
$existingVersion = $null
if (Test-Path $existingVersionPath) {
    $existingVersion = Get-Content $existingVersionPath -Raw -ErrorAction SilentlyContinue | ForEach-Object { $_.Trim() }
    Write-Host "    [PACKAGE] " -NoNewline -ForegroundColor Cyan
    Write-Host "Existing Installation Detected: " -NoNewline -ForegroundColor White
    Write-Host "v$existingVersion" -ForegroundColor Yellow
    
    if ($existingVersion -ne $version) {
        Write-Host "    [UPDATE] " -NoNewline -ForegroundColor Green
        Write-Host "Update Available: " -NoNewline -ForegroundColor White
        Write-Host "v$existingVersion -> v$version" -ForegroundColor Yellow
        Write-Host "    " + ("-" * 50) -ForegroundColor DarkGray
    } else {
        Write-Host "    [OK] " -NoNewline -ForegroundColor Green
        Write-Host "Already on latest version" -ForegroundColor White
        Write-Host "    " + ("-" * 50) -ForegroundColor DarkGray
    }
}

Write-Host "Would you like to perform a clean installation? (Y/N)" -ForegroundColor Yellow
Write-Host "This will remove all existing Claudify components before installing." -ForegroundColor DarkGray
Write-Host "[Default: N]: " -NoNewline

$cleanResponse = Read-Host

# Default to No for normal updates
if ([string]::IsNullOrWhiteSpace($cleanResponse)) {
    $CleanInstall = $false
} else {
    $CleanInstall = ($cleanResponse -eq 'Y' -or $cleanResponse -eq 'y')
}

if ($CleanInstall) {
    Write-Host "[OK] Clean installation selected" -ForegroundColor Green
} else {
    Write-Host "[OK] Normal installation selected" -ForegroundColor Green
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
    Write-Host "  - .claudify/* (all cached resources)" -ForegroundColor DarkGray
    Write-Host "  Note: CLAUDE.md is a user-managed file" -ForegroundColor Green
    
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
        
        # Note: CLAUDE.md is a user-managed file (not touched by setup)
        
    Write-Host "[OK] Clean removal complete!" -ForegroundColor Green
    Write-Host "`nProceeding with fresh installation..." -ForegroundColor Cyan
}

# Create .claude/commands directory structure (cross-platform)
$commandsPath = Join-Path $TargetRepository ".claude" "commands"
Write-Host "`nCreating Claude Code directory structure..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $commandsPath -Force | Out-Null

# Note: init-claudify.md command has been deprecated in v4.0.0
# The setup process now handles all initialization directly

# Create VERSION file in .claude directory for update tracking
$targetVersionPath = Join-Path $TargetRepository ".claude" "VERSION"
Write-Host "Creating version tracking file..." -ForegroundColor Cyan
Set-Content -Path $targetVersionPath -Value $version -NoNewline

# Create installation metadata
$installTypeValue = if ($CleanInstall) { "clean" } else { "normal" }
$installMetadata = @{
    version = $version
    installDate = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
    installType = $installTypeValue
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
    Write-Host "[OK] .gitignore updated successfully" -ForegroundColor Green
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

# Copy important documentation files
$docFiles = @(
    "README.md",
    "SETUP-GUIDE.md",
    "CHANGELOG.md"
)

Write-Host "  - Copying documentation files..." -ForegroundColor DarkGray
foreach ($docFile in $docFiles) {
    $sourceDoc = Join-Path $scriptDir $docFile
    $destDoc = Join-Path $tempClaudifyPath $docFile
    if (Test-Path $sourceDoc) {
        # Ensure parent directory exists for nested files
        $destDir = Split-Path -Parent $destDoc
        if (-not (Test-Path $destDir)) {
            New-Item -ItemType Directory -Path $destDir -Force | Out-Null
        }
        Copy-Item -Path $sourceDoc -Destination $destDoc -Force
    }
}

Write-Host "Claudify resources copied to .claudify successfully!" -ForegroundColor Green
Write-Host "Note: .claudify is excluded from git via .gitignore" -ForegroundColor DarkGray
Write-Host "      This directory will persist for future configuration updates" -ForegroundColor DarkGray

# Offer intelligent automatic setup
Write-Host "`n" + ("-" * 60) -ForegroundColor DarkGray
Write-Host " [AI] Intelligent Component Installation" -ForegroundColor Cyan
Write-Host ("-" * 60) -ForegroundColor DarkGray
Write-Host ""
Write-Host "Claudify can automatically install Claude Code components now" -ForegroundColor White
Write-Host "based on your detected technology stack." -ForegroundColor White
Write-Host ""
Write-Host "Choose installation mode:" -ForegroundColor Yellow
Write-Host "  [M] Minimal    - Core components for your stack (~15-25 files)" -ForegroundColor White
Write-Host "  [C] Comprehensive - Everything available (~40+ files) " -NoNewline -ForegroundColor White
Write-Host "[RECOMMENDED]" -ForegroundColor Green
Write-Host ""
Write-Host "Select mode (M/C) [C]: " -NoNewline -ForegroundColor Yellow
$setupResponse = Read-Host

# Default to comprehensive if no input
if ([string]::IsNullOrWhiteSpace($setupResponse)) {
    $setupResponse = 'C'
}

switch ($setupResponse.ToUpper()) {
    'M' { $setupMode = "minimal" }
    'C' { $setupMode = "comprehensive" }
    default { $setupMode = "comprehensive" }
}

Write-Host ""
Write-Host "Starting intelligent setup ($setupMode mode)..." -ForegroundColor Cyan
Write-Host ""

# Intelligent Setup Logic (merged from intelligent-setup.ps1)
# Color functions for cross-platform compatibility
function Write-Success { param($msg) Write-Host $msg -ForegroundColor Green }
function Write-Info { param($msg) Write-Host $msg -ForegroundColor Cyan }
function Write-Warning { param($msg) Write-Host $msg -ForegroundColor Yellow }
function Write-Error { param($msg) Write-Host $msg -ForegroundColor Red }
function Write-Detail { param($msg) Write-Host "  $msg" -ForegroundColor DarkGray }
    
    Write-Info "🎯 Intelligent Claude Code Setup"
    Write-Host "=================================" -ForegroundColor DarkGray
    Write-Info "Setup Mode: $($setupMode.ToUpper())"
    Write-Host ""
    
    # Verify .claudify directory exists
    $claudifyPath = Join-Path $TargetRepository ".claudify"
    if (-not (Test-Path $claudifyPath)) {
        Write-Error "❌ ERROR: .claudify directory not found!"
        Write-Host "This should have been created earlier in the setup." -ForegroundColor Yellow
        exit 1
    }
    
    # Create .claude directory structure if not already created
    $claudePath = Join-Path $TargetRepository ".claude"
    $paths = @(
        (Join-Path $claudePath "commands"),
        (Join-Path $claudePath "agents"),
        (Join-Path $claudePath "templates" "documentation")
    )
    
    Write-Info "📁 Creating directory structure..."
    foreach ($path in $paths) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    Write-Success "  [OK] Directories created"
    Write-Info "[PACKAGE] Installing components for $setupMode setup..."
    
    # Define component lists based on mode
    $commandsToInstall = @()
    $agentsToInstall = @()
    
    switch ($setupMode) {
        "minimal" {
            $commandsToInstall = @(
                "comprehensive-review",
                "smart-research",
                "quick-research",
                "security-audit",
                "update-changelog",
                "optimize-performance",
                "refactor-code"
            )
            $agentsToInstall = @(
                "code-review-expert",
                "tech-lead-engineer",
                "best-practices-researcher",
                "code-simplifier",
                "technical-debt-analyzer",
                "test-quality-analyzer"
            )
        }
        "comprehensive" {
            $commandsToInstall = @(
                "comprehensive-review",
                "smart-research",
                "quick-research",
                "research-architecture",
                "research-performance",
                "research-security",
                "update-changelog",
                "optimize-performance",
                "performance-optimization",
                "refactor-code",
                "security-audit",
                "health-check",
                "validate-release",
                "generate-documentation",
                "generate-docs",
                "generate-marketing-material",
                "implement-full-stack-feature",
                "add-backend-feature",
                "add-frontend-feature",
                "figma-implement-current-selection",
                "fix-backend-bug",
                "fix-backend-build-and-tests",
                "fix-frontend-bug",
                "fix-frontend-build-and-tests",
                "review-backend-code",
                "review-frontend-code",
                "update-backend-feature",
                "update-frontend-feature",
                "update-backend-feature-no-backward-compatibility",
                "update-frontend-feature-no-backward-compatibility",
                "optimize-command"
            )
            $agentsToInstall = @(
                "code-review-expert",
                "tech-lead-engineer",
                "best-practices-researcher",
                "code-simplifier",
                "technical-debt-analyzer",
                "test-quality-analyzer",
                "infrastructure-architect",
                "ux-design-expert",
                "legacy-codebase-analyzer",
                "visual-design-expert",
                "security-vulnerability-scanner",
                "frontend-implementation-expert",
                "technical-documentation-writer",
                "tech-docs-specialist",
                "feature-scope-architect",
                "marketing-strategist",
                "sales-pitch-creator"
            )
        }
    }
    
    # Remove duplicates
    $commandsToInstall = $commandsToInstall | Select-Object -Unique
    $agentsToInstall = $agentsToInstall | Select-Object -Unique
    
    # Install commands
    Write-Info "Installing commands..."
    $installedCommands = 0
    $failedCommands = 0
    foreach ($command in $commandsToInstall) {
        $sourcePath = Join-Path $claudifyPath ".claude" "commands" "$command.md"
        $destPath = Join-Path $claudePath "commands" "$command.md"
        
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Detail "[OK] $command"
            $installedCommands++
        } else {
            Write-Detail "✗ $command (not found)"
            $failedCommands++
        }
    }
    Write-Success "  Commands: $installedCommands installed$(if ($failedCommands -gt 0) { ", $failedCommands failed" })"
    
    # Install agents
    Write-Info "Installing agents..."
    $installedAgents = 0
    $failedAgents = 0
    foreach ($agent in $agentsToInstall) {
        $sourcePath = Join-Path $claudifyPath ".claude" "agents" "$agent.md"
        $destPath = Join-Path $claudePath "agents" "$agent.md"
        
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            Write-Detail "[OK] $agent"
            $installedAgents++
        } else {
            Write-Detail "✗ $agent (not found)"
            $failedAgents++
        }
    }
    Write-Success "  Agents: $installedAgents installed$(if ($failedAgents -gt 0) { ", $failedAgents failed" })"

    # Project Detection and Configuration
    Write-Info "`n[CONFIG] Detecting and configuring project names..."
    
    # Function to detect and confirm project names with user
    function Get-ProjectNamesInteractive {
        param([string]$Path)
        
        Write-Host "`n  Scanning for projects..." -ForegroundColor Cyan
        
        # Detect Web Projects (Angular)
        Write-Host "  Looking for Angular projects (angular.json)..." -ForegroundColor DarkGray
        $angularJsonFiles = Get-ChildItem -Path $Path -Recurse -Filter "angular.json" -ErrorAction SilentlyContinue
        $webProjects = @()
        
        # First pass: collect all projects
        $tempWebProjects = @()
        foreach ($angularJson in $angularJsonFiles) {
            $projectDir = Split-Path $angularJson.FullName -Parent
            $projectDirName = Split-Path $projectDir -Leaf
            $projectPath = $projectDir.Replace($Path, "").TrimStart("\", "/")
            
            $tempWebProjects += @{
                Name = $projectDirName
                Path = $projectPath
                Type = "Web"
                DetectedBy = "angular.json"
                FullPath = $projectDir
            }
        }
        
        # Second pass: handle duplicates
        $nameGroups = $tempWebProjects | Group-Object -Property Name
        foreach ($group in $nameGroups) {
            if ($group.Count -eq 1) {
                # No duplicates, use as-is
                $webProjects += $group.Group[0]
            } else {
                # Has duplicates, make unique by prepending parent folder
                foreach ($project in $group.Group) {
                    $parentFolderName = Split-Path (Split-Path $project.FullPath -Parent) -Leaf
                    $project.Name = "$parentFolderName.$($project.Name)"
                    $webProjects += $project
                }
            }
        }
        
        # Detect .NET Projects
        Write-Host "  Looking for .NET projects (.csproj files)..." -ForegroundColor DarkGray
        $csprojFiles = Get-ChildItem -Path $Path -Recurse -Filter "*.csproj" -ErrorAction SilentlyContinue
        $tempApiProjects = @()
        $tempTestProjects = @()
        $tempOtherProjects = @()
        
        # First pass: collect all projects
        foreach ($csproj in $csprojFiles) {
            $content = Get-Content $csproj.FullName -Raw
            $projectName = [System.IO.Path]::GetFileNameWithoutExtension($csproj.Name)
            $relativePath = $csproj.FullName.Replace($Path, "").TrimStart("\", "/")
            $fullPath = $csproj.FullName
            
            if ($content -match 'Microsoft\.NET\.Sdk\.Web') {
                # It's a Web API project
                $tempApiProjects += @{
                    Name = $projectName
                    Path = $relativePath
                    Type = "API"
                    DetectedBy = "Microsoft.NET.Sdk.Web"
                    FullPath = $fullPath
                }
            } elseif ($content -match 'Microsoft\.NET\.Sdk' -and ($projectName -like "*Test*" -or $projectName -like "*Tests")) {
                # It's a test project (has Microsoft.NET.Sdk and Test in name)
                $testType = if ($projectName -like "*ArchitectureTest*") { "ArchitectureTest" } else { "Test" }
                $tempTestProjects += @{
                    Name = $projectName
                    Path = $relativePath
                    Type = $testType
                    DetectedBy = "Microsoft.NET.Sdk (test project)"
                    FullPath = $fullPath
                }
            } elseif ($content -match 'Microsoft\.NET\.Sdk') {
                # It's a regular .NET project (library, console app, etc.)
                $tempOtherProjects += @{
                    Name = $projectName
                    Path = $relativePath
                    Type = "Other"
                    DetectedBy = "Microsoft.NET.Sdk"
                    FullPath = $fullPath
                }
            }
        }
        
        # Second pass: handle duplicates for each project type
        function Resolve-DuplicateNames {
            param($Projects)
            $resolvedProjects = @()
            $nameGroups = $Projects | Group-Object -Property Name
            foreach ($group in $nameGroups) {
                if ($group.Count -eq 1) {
                    $resolvedProjects += $group.Group[0]
                } else {
                    foreach ($project in $group.Group) {
                        $parentFolder = Split-Path (Split-Path $project.FullPath -Parent) -Leaf
                        $project.Name = "$parentFolder.$($project.Name)"
                        $resolvedProjects += $project
                    }
                }
            }
            return $resolvedProjects
        }
        
        $apiProjects = Resolve-DuplicateNames -Projects $tempApiProjects
        $testProjects = Resolve-DuplicateNames -Projects $tempTestProjects
        $otherProjects = Resolve-DuplicateNames -Projects $tempOtherProjects
        
        # Summary
        $totalFound = $webProjects.Count + $apiProjects.Count + $testProjects.Count + $otherProjects.Count
        if ($totalFound -eq 0) {
            Write-Warning "  No projects found in the repository"
            Write-Host "  You can manually enter project names or skip configuration" -ForegroundColor Yellow
        } else {
            Write-Success "  Found $totalFound project(s):"
            if ($webProjects.Count -gt 0) { Write-Host "    - $($webProjects.Count) Angular/Web project(s)" -ForegroundColor Gray }
            if ($apiProjects.Count -gt 0) { Write-Host "    - $($apiProjects.Count) .NET Web API project(s)" -ForegroundColor Gray }
            if ($testProjects.Count -gt 0) { Write-Host "    - $($testProjects.Count) Test project(s)" -ForegroundColor Gray }
            if ($otherProjects.Count -gt 0) { Write-Host "    - $($otherProjects.Count) Other .NET project(s)" -ForegroundColor Gray }
        }
        
        # Interactive confirmation for each project type
        $confirmedProjects = @{}
        
        # Web Project
        Write-Host "`n  [Web Project Configuration]" -ForegroundColor Cyan
        
        if ($webProjects.Count -gt 0) {
            Write-Host "  Detected Angular project(s):" -ForegroundColor White

            if ($webProjects.Count -eq 1) {
                # Single project - simple accept/override
                $proj = $webProjects[0]
                Write-Host "    - $($proj.Name) (at $($proj.Path))" -ForegroundColor Gray
                Write-Host "  Press Enter to accept, or enter different path: " -NoNewline -ForegroundColor Yellow
                $userInput = Read-Host
                $confirmedProjects.WebProject = if ([string]::IsNullOrWhiteSpace($userInput)) { $proj.Path } else { $userInput }
            } else {
                # Multiple projects - select PRIMARY
                Write-Host "  Found $($webProjects.Count) Angular projects:" -ForegroundColor White
                for ($i = 0; $i -lt $webProjects.Count; $i++) {
                    $proj = $webProjects[$i]
                    Write-Host "    [$($i+1)] $($proj.Name)" -ForegroundColor Gray
                    Write-Host "        Path: $($proj.Path)" -ForegroundColor DarkGray
                }
                Write-Host "`n  Select PRIMARY web project for commands [1]: " -NoNewline -ForegroundColor Yellow
                $selection = Read-Host

                $index = if ([string]::IsNullOrWhiteSpace($selection)) { 0 } else { [int]$selection - 1 }
                if ($index -ge 0 -and $index -lt $webProjects.Count) {
                    $confirmedProjects.WebProject = $webProjects[$index].Path
                } else {
                    Write-Warning "  Invalid selection, using first project"
                    $confirmedProjects.WebProject = $webProjects[0].Path
                }
            }
        } else {
            Write-Host "  No Angular project detected (no angular.json found)." -ForegroundColor Yellow
            Write-Host "  Enter web project name(s) (comma-separated) or press Enter to skip: " -NoNewline -ForegroundColor Yellow
            $userInput = Read-Host
            if (![string]::IsNullOrWhiteSpace($userInput)) {
                $confirmedProjects.WebProject = $userInput
            }
        }
        
        if ($confirmedProjects.WebProject) {
            Write-Success "  ✓ Web project: $($confirmedProjects.WebProject)"
        }
        
        # API Project
        Write-Host "`n  [API Project Configuration]" -ForegroundColor Cyan
        
        if ($apiProjects.Count -gt 0) {
            Write-Host "  Detected .NET Web API project(s):" -ForegroundColor White

            if ($apiProjects.Count -eq 1) {
                # Single project - simple accept/override
                $proj = $apiProjects[0]
                Write-Host "    - $($proj.Name) (at $($proj.Path))" -ForegroundColor Gray
                Write-Host "  Press Enter to accept, or enter different name: " -NoNewline -ForegroundColor Yellow
                $userInput = Read-Host
                $confirmedProjects.ApiProject = if ([string]::IsNullOrWhiteSpace($userInput)) { $proj.Name } else { $userInput }
            } else {
                # Multiple projects - select PRIMARY
                Write-Host "  Found $($apiProjects.Count) API projects:" -ForegroundColor White
                for ($i = 0; $i -lt $apiProjects.Count; $i++) {
                    $proj = $apiProjects[$i]
                    Write-Host "    [$($i+1)] $($proj.Name)" -ForegroundColor Gray
                    Write-Host "        Path: $($proj.Path)" -ForegroundColor DarkGray
                }
                Write-Host "`n  Select PRIMARY API project for commands [1]: " -NoNewline -ForegroundColor Yellow
                $selection = Read-Host

                $index = if ([string]::IsNullOrWhiteSpace($selection)) { 0 } else { [int]$selection - 1 }
                if ($index -ge 0 -and $index -lt $apiProjects.Count) {
                    $confirmedProjects.ApiProject = $apiProjects[$index].Name
                } else {
                    Write-Warning "  Invalid selection, using first project"
                    $confirmedProjects.ApiProject = $apiProjects[0].Name
                }
            }
        } else {
            Write-Host "  No .NET Web API project detected (no Microsoft.NET.Sdk.Web found)." -ForegroundColor Yellow
            Write-Host "  Enter API project name(s) (comma-separated) or press Enter to skip: " -NoNewline -ForegroundColor Yellow
            $userInput = Read-Host
            if (![string]::IsNullOrWhiteSpace($userInput)) {
                $confirmedProjects.ApiProject = $userInput
            }
        }
        
        if ($confirmedProjects.ApiProject) {
            Write-Success "  ✓ API project: $($confirmedProjects.ApiProject)"
        }
        
        # Architecture Test Project
        Write-Host "`n  [Architecture Test Project Configuration]" -ForegroundColor Cyan
        $archProjects = $testProjects | Where-Object { $_.Type -eq "ArchitectureTest" }
        
        if ($archProjects.Count -gt 0) {
            Write-Host "  Detected architecture test project(s):" -ForegroundColor White

            if ($archProjects.Count -eq 1) {
                # Single project - simple accept/override
                $proj = $archProjects[0]
                Write-Host "    - $($proj.Name) (at $($proj.Path))" -ForegroundColor Gray
                Write-Host "  Press Enter to accept, or enter different name: " -NoNewline -ForegroundColor Yellow
                $userInput = Read-Host
                $confirmedProjects.ArchitectureTestProject = if ([string]::IsNullOrWhiteSpace($userInput)) { $proj.Name } else { $userInput }
            } else {
                # Multiple projects - select PRIMARY
                Write-Host "  Found $($archProjects.Count) architecture test projects:" -ForegroundColor White
                for ($i = 0; $i -lt $archProjects.Count; $i++) {
                    $proj = $archProjects[$i]
                    Write-Host "    [$($i+1)] $($proj.Name)" -ForegroundColor Gray
                    Write-Host "        Path: $($proj.Path)" -ForegroundColor DarkGray
                }
                Write-Host "`n  Select PRIMARY test project for commands [1]: " -NoNewline -ForegroundColor Yellow
                $selection = Read-Host

                $index = if ([string]::IsNullOrWhiteSpace($selection)) { 0 } else { [int]$selection - 1 }
                if ($index -ge 0 -and $index -lt $archProjects.Count) {
                    $confirmedProjects.ArchitectureTestProject = $archProjects[$index].Name
                } else {
                    Write-Warning "  Invalid selection, using first project"
                    $confirmedProjects.ArchitectureTestProject = $archProjects[0].Name
                }
            }
        } else {
            # Look for any test project as fallback
            if ($testProjects.Count -gt 0) {
                Write-Host "  Detected test project(s) (no architecture-specific tests found):" -ForegroundColor White

                if ($testProjects.Count -eq 1) {
                    # Single test project
                    $proj = $testProjects[0]
                    Write-Host "    - $($proj.Name) (at $($proj.Path))" -ForegroundColor Gray
                    Write-Host "  Press Enter to use as architecture tests, or enter different name: " -NoNewline -ForegroundColor Yellow
                    $userInput = Read-Host
                    $confirmedProjects.ArchitectureTestProject = if ([string]::IsNullOrWhiteSpace($userInput)) { $proj.Name } else { $userInput }
                } else {
                    # Multiple test projects - select PRIMARY
                    Write-Host "  Found $($testProjects.Count) test projects:" -ForegroundColor White
                    for ($i = 0; $i -lt $testProjects.Count; $i++) {
                        $proj = $testProjects[$i]
                        Write-Host "    [$($i+1)] $($proj.Name)" -ForegroundColor Gray
                        Write-Host "        Path: $($proj.Path)" -ForegroundColor DarkGray
                    }
                    Write-Host "`n  Select PRIMARY test project for commands [1]: " -NoNewline -ForegroundColor Yellow
                    $selection = Read-Host

                    $index = if ([string]::IsNullOrWhiteSpace($selection)) { 0 } else { [int]$selection - 1 }
                    if ($index -ge 0 -and $index -lt $testProjects.Count) {
                        $confirmedProjects.ArchitectureTestProject = $testProjects[$index].Name
                    } else {
                        Write-Warning "  Invalid selection, using first project"
                        $confirmedProjects.ArchitectureTestProject = $testProjects[0].Name
                    }
                }
            } else {
                Write-Host "  No test project detected (no .csproj with Test in name)." -ForegroundColor Yellow
                Write-Host "  Enter architecture test project name(s) (comma-separated) or press Enter to skip: " -NoNewline -ForegroundColor Yellow
                $userInput = Read-Host
                if (![string]::IsNullOrWhiteSpace($userInput)) {
                    $confirmedProjects.ArchitectureTestProject = $userInput
                }
            }
        }
        
        if ($confirmedProjects.ArchitectureTestProject) {
            Write-Success "  ✓ Architecture test project: $($confirmedProjects.ArchitectureTestProject)"
        }
        
        # Summary
        Write-Host "`n  [Configuration Summary]" -ForegroundColor Cyan
        if ($confirmedProjects.Count -eq 0) {
            Write-Warning "  No projects configured. Templates will remain unchanged."
        } else {
            Write-Host "  The following projects will be configured:" -ForegroundColor White
            foreach ($key in $confirmedProjects.Keys) {
                Write-Host "    $key = $($confirmedProjects[$key])" -ForegroundColor Green
            }
        }
        
        return $confirmedProjects
    }
    
    # Function to process mustache templates in all Claudify files
    function Apply-ProjectTemplates {
        param(
            [string]$ClaudePath,
            [hashtable]$Projects
        )
        
        if ($Projects.Count -eq 0) {
            Write-Info "  No projects to configure, skipping template processing"
            return 0
        }
        
        Write-Info "  Applying project templates to all files..."
        
        # Build replacement dictionary from confirmed projects
        $replacements = @{}
        
        if ($Projects.WebProject) {
            $replacements['{{WebProject}}'] = $Projects.WebProject
            Write-Detail "    {{WebProject}} → $($Projects.WebProject)"
        }
        
        if ($Projects.ApiProject) {
            $replacements['{{ApiProject}}'] = $Projects.ApiProject
            Write-Detail "    {{ApiProject}} → $($Projects.ApiProject)"
        }
        
        if ($Projects.ArchitectureTestProject) {
            $replacements['{{ArchitectureTestProject}}'] = $Projects.ArchitectureTestProject
            Write-Detail "    {{ArchitectureTestProject}} → $($Projects.ArchitectureTestProject)"
        }
        
        # For any remaining {{ProjectNamespace}} templates (backward compatibility)
        # Use the base namespace from the first configured project
        if ($Projects.Count -gt 0) {
            $firstProject = ($Projects.Values | Select-Object -First 1)
            $baseNamespace = $firstProject -replace '\.(Web|Api|Domain|Infrastructure|Tests|Test|UI|Frontend|WebApi)$', ''
            $replacements['{{ProjectNamespace}}'] = $baseNamespace
            Write-Detail "    {{ProjectNamespace}} → $baseNamespace (for backward compatibility)"
        }
        
        $replacementCount = 0
        $filesProcessed = @()
        
        # Get all files to update
        $filesToUpdate = @()
        $filesToUpdate += Get-ChildItem -Path (Join-Path $ClaudePath "commands") -Filter "*.md" -ErrorAction SilentlyContinue
        $filesToUpdate += Get-ChildItem -Path (Join-Path $ClaudePath "agents") -Filter "*.md" -ErrorAction SilentlyContinue
        
        foreach ($file in $filesToUpdate) {
            $content = Get-Content -Path $file.FullName -Raw -ErrorAction SilentlyContinue
            if ($content) {
                $modified = $false
                $updatedContent = $content
                
                # Apply all replacements
                foreach ($template in $replacements.Keys) {
                    if ($updatedContent.Contains($template)) {
                        $updatedContent = $updatedContent -replace [regex]::Escape($template), $replacements[$template]
                        $modified = $true
                    }
                }
                
                if ($modified) {
                    Set-Content -Path $file.FullName -Value $updatedContent -NoNewline
                    $replacementCount++
                    $filesProcessed += $file.Name
                    Write-Detail "    Processed: $($file.Name)"
                }
            }
        }
        
        # Save configuration to file
        $configPath = Join-Path $ClaudePath "config"
        if (-not (Test-Path $configPath)) {
            New-Item -ItemType Directory -Path $configPath -Force | Out-Null
        }
        
        $projectConfig = @{
            ConfiguredProjects = $Projects
            TemplateReplacements = $replacements
            FilesProcessed = $filesProcessed
            ConfiguredDate = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
        } | ConvertTo-Json -Depth 10
        
        Set-Content -Path (Join-Path $configPath "projects.json") -Value $projectConfig
        
        if ($replacementCount -gt 0) {
            Write-Success "  [OK] Processed $replacementCount file(s) with project templates"
        } else {
            Write-Info "  [INFO] No template replacements were needed"
        }
        
        return $replacementCount
    }
    
    # Get project configuration from user
    $confirmedProjects = Get-ProjectNamesInteractive -Path $TargetRepository
    
    # Apply the templates with confirmed project names
    $updatedFiles = Apply-ProjectTemplates -ClaudePath $claudePath -Projects $confirmedProjects
    
    if ($updatedFiles -gt 0) {
        Write-Success "`n  [SUCCESS] Project configuration complete!"
    } elseif ($confirmedProjects.Count -gt 0) {
        Write-Info "`n  [INFO] Projects configured but no templates needed updating"
    } else {
        Write-Warning "`n  [INFO] No project configuration applied"
        Write-Host "  Commands will use default template placeholders" -ForegroundColor Yellow
        Write-Host "  You can manually edit them later if needed" -ForegroundColor Gray
    }

    # Dual-Mode Selection
    Write-Host "`n" + ("-" * 60) -ForegroundColor DarkGray
    Write-Host " [AI] Convention Detection Mode" -ForegroundColor Cyan
    Write-Host ("-" * 60) -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "Claudify can analyze your project conventions to generate perfectly matching code." -ForegroundColor White
    Write-Host ""
    Write-Host "Choose detection mode:" -ForegroundColor Yellow
    Write-Host "  [1] SMART MODE (Recommended)" -ForegroundColor Green
    Write-Host "      • Analyzes your project once (~60 seconds)" -ForegroundColor White
    Write-Host "      • Commands generate matching code instantly" -ForegroundColor White
    Write-Host "      • 95-100% accuracy, best for teams`n" -ForegroundColor White
    Write-Host "  [2] ADAPTIVE MODE (Lightweight)" -ForegroundColor Yellow
    Write-Host "      • Skips analysis, commands examine code on-demand" -ForegroundColor White
    Write-Host "      • 90% accuracy, always reflects current code" -ForegroundColor White
    Write-Host "      • Best for rapidly changing codebases`n" -ForegroundColor White
    Write-Host "Select mode [1/2] (default: 1): " -NoNewline -ForegroundColor Yellow
    $modeResponse = Read-Host

    # Default to Smart Mode
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
            Write-Success "✓ Adaptive Mode selected - skipping analysis"
        }
        default {
            $conventionMode = "smart"
            $skipAnalyzer = $false
            Write-Host ""
            Write-Success "✓ Smart Mode selected (default) - running analyzer..."
        }
    }

    # Project analysis (Smart Mode)
    if (-not $skipAnalyzer) {
        Write-Info "`n[ANALYSIS] Project Analysis:"
        Write-Host "  Analyzing project to extract conventions and patterns..." -ForegroundColor Cyan
        Write-Host "  This will take 30-60 seconds..." -ForegroundColor Gray

        # Check if Node.js is available
        $nodeExists = Get-Command node -ErrorAction SilentlyContinue
        if (-not $nodeExists) {
            Write-Warning "  [SKIP] Node.js not found - skipping project analysis"
            Write-Host "  Install Node.js 18+ to enable project-aware code generation" -ForegroundColor Yellow
        } else {
            # Check Node version
            $nodeVersion = node --version 2>$null
            Write-Detail "  Node.js version: $nodeVersion"

            # Run analyzer
            $analyzerPath = Join-Path $scriptDir ".claudify-sdk" "dist" "project-analyzer.bundle.js"
            $knowledgePath = Join-Path $claudePath "config" "project-knowledge.json"

            if (Test-Path $analyzerPath) {
                try {
                    $analyzerResult = node $analyzerPath --project $TargetRepository --output $knowledgePath 2>&1

                    if ($LASTEXITCODE -eq 0) {
                        Write-Success "  [OK] Project analysis complete!"
                        Write-Host "  Saved to: .claude/config/project-knowledge.json" -ForegroundColor Gray
                        Write-Host "  Commands will now generate code matching YOUR project conventions" -ForegroundColor Green
                    } else {
                        Write-Warning "  [WARN] Analysis failed: $analyzerResult"
                        Write-Host "  Commands will use general .NET/Angular patterns" -ForegroundColor Yellow
                    }
                } catch {
                    Write-Warning "  [WARN] Analysis error: $_"
                    Write-Host "  Commands will use general .NET/Angular patterns" -ForegroundColor Yellow
                }
            } else {
                Write-Warning "  [SKIP] Analyzer not found at: $analyzerPath"
                Write-Host "  Run 'cd .claudify-sdk && npm install && npm run build' to enable analysis" -ForegroundColor Yellow
            }
        }
    } else {
        # Adaptive Mode selected
        Write-Info "`n[ANALYSIS] Adaptive Mode Active:"
        Write-Host "  Convention analysis skipped" -ForegroundColor Cyan
        Write-Host "  Commands will examine code on-demand when generating" -ForegroundColor Gray
        Write-Host "  To switch to Smart Mode, run: .\setup.ps1 -RefreshAnalysis" -ForegroundColor Yellow
    }

    # Save mode configuration
    $configPath = Join-Path $claudePath "config"
    if (-not (Test-Path $configPath)) {
        New-Item -ItemType Directory -Path $configPath -Force | Out-Null
    }

    $modeConfig = @{
        mode = $conventionMode
        analyzedAt = if ($conventionMode -eq "smart") { (Get-Date -Format "o") } else { $null }
        version = $version
        installDate = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    }

    $modeConfigPath = Join-Path $configPath "claudify.json"
    $modeConfig | ConvertTo-Json | Set-Content -Path $modeConfigPath -NoNewline
    Write-Info "  [OK] Convention mode saved: $conventionMode"

    # Note about CLAUDE.md
    $claudeMdPath = Join-Path $TargetRepository "CLAUDE.md"

    Write-Info "`n[DOC] Documentation:"
    if (Test-Path $claudeMdPath) {
        Write-Success "  [OK] CLAUDE.md exists - preserved (user-managed)"
    } else {
        Write-Host "  [INFO] CLAUDE.md not found - create your own project-specific CLAUDE.md" -ForegroundColor Yellow
    }
    
    # Installation summary
    Write-Host ""
    Write-Info "📊 Installation Summary"
    Write-Host "========================" -ForegroundColor DarkGray
    Write-Success "OK: Commands installed: $installedCommands"
    Write-Success "OK: Agents installed: $installedAgents"

    # Final success message
    Write-Host ""
    Write-Success "✅ Claudify setup completed successfully!"
    
    Write-Host "You can now start using Claude Code with your project!" -ForegroundColor Green
    Write-Host "Run '/init' in Claude Code if you haven't initialized Claude Code in your repository yet." -ForegroundColor White