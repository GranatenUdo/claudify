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
Write-Host "    ╔═══ CLAUDIFY ═══╗ Smart Claude Code Setup v$version" -ForegroundColor Cyan
Write-Host "    ║▶ Initialize ◀ ║ Opus 4 Optimized • AI-Powered" -ForegroundColor White
Write-Host "    ╚════════════════╝ github.com/claudify" -ForegroundColor DarkGray
Write-Host "    $ whoami" -ForegroundColor Yellow
Write-Host "    > GranatenUdo | Tobi" -ForegroundColor Yellow

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
}

# Check for version 2.0.0 and recommend clean install
$recommendClean = $false
if ($version -eq "2.0.0" -and ($existingVersion -eq $null -or $existingVersion -lt "2.0.0")) {
    Write-Host "    🎉 " -NoNewline -ForegroundColor Cyan
    Write-Host "Version 2.0.0 MAJOR UPDATE!" -ForegroundColor Yellow
    Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
    Write-Host "    This major release includes:" -ForegroundColor White
    Write-Host "    • ✨ Opus 4 optimized agents with parallel analysis" -ForegroundColor Green
    Write-Host "    • 🧠 Extended thinking capabilities (65536 tokens)" -ForegroundColor Green
    Write-Host "    • 🤖 AI-powered generation with confidence scoring" -ForegroundColor Green
    Write-Host "    ⚠️  BREAKING CHANGES - Clean install required" -ForegroundColor Yellow
    Write-Host "    " + ("─" * 50) -ForegroundColor DarkGray
    $recommendClean = $true
}

if ($recommendClean) {
    Write-Host "⚠️  " -NoNewline -ForegroundColor Yellow
    Write-Host "Clean installation is " -NoNewline -ForegroundColor White
    Write-Host "REQUIRED" -NoNewline -ForegroundColor Red
    Write-Host " for version 2.0.0" -ForegroundColor White
    Write-Host "   Major architectural changes require a fresh installation." -ForegroundColor DarkGray
}

Write-Host "Would you like to perform a clean installation? (Y/N)" -ForegroundColor Yellow
Write-Host "This will remove all existing Claudify components before installing." -ForegroundColor DarkGray
if ($recommendClean -or $version -eq "2.0.0") {
    Write-Host "[Default: Y]: " -NoNewline -ForegroundColor Green
} else {
    Write-Host "[Default: N]: " -NoNewline
}

$cleanResponse = Read-Host

# Default to Yes for v2.0.0, No for others
if ([string]::IsNullOrWhiteSpace($cleanResponse)) {
    if ($recommendClean -or $version -eq "2.0.0") {
        $CleanInstall = $true
    } else {
        $CleanInstall = $false
    }
} else {
    $CleanInstall = ($cleanResponse -eq 'Y' -or $cleanResponse -eq 'y')
}

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
    "docs/AGENT-COLLABORATION-GUIDE.md",
    "docs/AGENT-COLLABORATION-EXAMPLES.md"
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
if ($version -eq "2.0.0") {
    Write-Host "      " -NoNewline -ForegroundColor DarkGray
    Write-Host "🚀 Version $version - Major release with Opus 4 optimizations" -ForegroundColor Cyan
    Write-Host "      " -NoNewline -ForegroundColor DarkGray
    Write-Host "📝 Fixed init-claudify command for proper component installation" -ForegroundColor Green
}

# Offer intelligent automatic setup
Write-Host "`n" + ("─" * 60) -ForegroundColor DarkGray
Write-Host " 🤖 Intelligent Component Installation" -ForegroundColor Cyan
Write-Host ("─" * 60) -ForegroundColor DarkGray
Write-Host ""
Write-Host "Claudify can automatically install Claude Code components now" -ForegroundColor White
Write-Host "based on your detected technology stack." -ForegroundColor White
Write-Host ""
Write-Host "Choose installation mode:" -ForegroundColor Yellow
Write-Host "  [M] Minimal    - Essential components only (~5-10 files)" -ForegroundColor White
Write-Host "  [S] Standard   - Core components for your stack (~15-25 files)" -ForegroundColor White
Write-Host "  [C] Comprehensive - Everything available (~40+ files) " -NoNewline -ForegroundColor White
Write-Host "[RECOMMENDED]" -ForegroundColor Green
Write-Host "  [N] None       - Skip automatic installation" -ForegroundColor White
Write-Host ""
Write-Host "Select mode (M/S/C/N) [C]: " -NoNewline -ForegroundColor Yellow
$setupResponse = Read-Host

# Default to comprehensive if no input
if ([string]::IsNullOrWhiteSpace($setupResponse)) {
    $setupResponse = 'C'
}

$setupMode = $null
switch ($setupResponse.ToUpper()) {
    'M' { $setupMode = "minimal" }
    'S' { $setupMode = "standard" }
    'C' { $setupMode = "comprehensive" }
    'N' { $setupMode = $null }
    default { $setupMode = "comprehensive" }
}

if ($setupMode) {
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
        (Join-Path $claudePath "agent-tools"),
        (Join-Path $claudePath "hooks"),
        (Join-Path $claudePath "generators"),
        (Join-Path $claudePath "validation"),
        (Join-Path $claudePath "templates" "documentation")
    )
    
    Write-Info "📁 Creating directory structure..."
    foreach ($path in $paths) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
    Write-Success "  ✓ Directories created"
    
    # Technology Stack Detection
    Write-Info "`n🔍 Detecting technology stack..."
    
    $detectedStack = @{
        Backend = $null
        Frontend = $null
        MultiTenant = $false
        Database = $null
        Infrastructure = $null
    }
    
    # Backend detection
    if (Get-ChildItem -Path $TargetRepository -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue) {
        $detectedStack.Backend = ".NET/C#"
        Write-Success "  ✓ .NET/C# backend detected"
    } elseif (Test-Path (Join-Path $TargetRepository "go.mod")) {
        $detectedStack.Backend = "Go"
        Write-Success "  ✓ Go backend detected"
    } elseif (Test-Path (Join-Path $TargetRepository "pom.xml")) {
        $detectedStack.Backend = "Java"
        Write-Success "  ✓ Java backend detected"
    } elseif (Test-Path (Join-Path $TargetRepository "requirements.txt")) {
        $detectedStack.Backend = "Python"
        Write-Success "  ✓ Python backend detected"
    } elseif (Test-Path (Join-Path $TargetRepository "package.json")) {
        $packageJson = Get-Content (Join-Path $TargetRepository "package.json") -Raw | ConvertFrom-Json
        if ($packageJson.dependencies -and ($packageJson.dependencies.PSObject.Properties.Name -match "express|fastify|nestjs")) {
            $detectedStack.Backend = "Node.js"
            Write-Success "  ✓ Node.js backend detected"
        }
    }
    
    # Frontend detection with enhanced Angular support
    function Find-FrontendProject {
        param([string]$RootPath)
        
        # Common frontend project locations in enterprise projects
        $searchPaths = @(
            "",                  # Root directory
            "ClientApp",         # Default ASP.NET Core Angular template
            "frontend",          # Common convention
            "client",            # Alternative naming
            "web",               # Web app folder
            "ui",                # UI folder
            "src",               # Source folder
            "app",               # App folder
            "wwwroot",           # ASP.NET static files
            "apps"               # Nx workspace convention
        )
        
        foreach ($subPath in $searchPaths) {
            $checkPath = if ($subPath) { 
                Join-Path $RootPath $subPath 
            } else { 
                $RootPath 
            }
            
            if (-not (Test-Path $checkPath)) {
                continue
            }
            
            # Check for Angular-specific files first
            $angularJson = Join-Path $checkPath "angular.json"
            if (Test-Path $angularJson) {
                return @{
                    Type = "Angular"
                    Path = $checkPath
                    RelativePath = if ($subPath) { $subPath } else { "." }
                    ConfigFile = "angular.json"
                }
            }
            
            # Check package.json for framework detection
            $packageJsonPath = Join-Path $checkPath "package.json"
            if (Test-Path $packageJsonPath) {
                try {
                    $packageJson = Get-Content $packageJsonPath -Raw | ConvertFrom-Json
                    
                    # Check both dependencies and devDependencies
                    $allDeps = @()
                    if ($packageJson.dependencies) {
                        $allDeps += $packageJson.dependencies.PSObject.Properties.Name
                    }
                    if ($packageJson.devDependencies) {
                        $allDeps += $packageJson.devDependencies.PSObject.Properties.Name
                    }
                    
                    # Angular detection
                    if ($allDeps | Where-Object { $_ -match "^@angular/" -or $_ -eq "angular" }) {
                        $angularVersion = $null
                        if ($packageJson.dependencies."@angular/core") {
                            $angularVersion = $packageJson.dependencies."@angular/core"
                        } elseif ($packageJson.devDependencies."@angular/core") {
                            $angularVersion = $packageJson.devDependencies."@angular/core"
                        }
                        
                        return @{
                            Type = "Angular"
                            Path = $checkPath
                            RelativePath = if ($subPath) { $subPath } else { "." }
                            Version = $angularVersion
                            ConfigFile = "package.json"
                        }
                    }
                    
                    # React detection
                    if ($allDeps -contains "react" -or $allDeps -contains "next") {
                        return @{
                            Type = "React"
                            Path = $checkPath
                            RelativePath = if ($subPath) { $subPath } else { "." }
                            ConfigFile = "package.json"
                        }
                    }
                    
                    # Vue detection
                    if ($allDeps -contains "vue" -or $allDeps -contains "@vue/cli") {
                        return @{
                            Type = "Vue"
                            Path = $checkPath
                            RelativePath = if ($subPath) { $subPath } else { "." }
                            ConfigFile = "package.json"
                        }
                    }
                    
                    # Svelte detection
                    if ($allDeps -contains "svelte") {
                        return @{
                            Type = "Svelte"
                            Path = $checkPath
                            RelativePath = if ($subPath) { $subPath } else { "." }
                            ConfigFile = "package.json"
                        }
                    }
                }
                catch {
                    Write-Warning "Failed to parse package.json at $packageJsonPath"
                }
            }
        }
        
        return $null
    }
    
    # Execute frontend detection
    $frontendProject = Find-FrontendProject -RootPath $TargetRepository
    if ($frontendProject) {
        $detectedStack.Frontend = $frontendProject.Type
        $relativePath = $frontendProject.RelativePath
        
        if ($relativePath -eq ".") {
            Write-Success "  ✓ $($frontendProject.Type) frontend detected in root directory"
        } else {
            Write-Success "  ✓ $($frontendProject.Type) frontend detected in '$relativePath' directory"
        }
        
        if ($frontendProject.Version) {
            Write-Detail "    Version: $($frontendProject.Version)"
        }
        Write-Detail "    Config: $($frontendProject.ConfigFile)"
    }
    
    # Multi-tenancy detection
    $multiTenantPatterns = @("OrganizationId", "TenantId", "CompanyId", "multi-tenant", "IMultiTenant")
    $searchExtensions = @("*.cs", "*.ts", "*.js", "*.py", "*.go", "*.java")
    foreach ($ext in $searchExtensions) {
        $files = Get-ChildItem -Path $TargetRepository -Filter $ext -Recurse -ErrorAction SilentlyContinue | Select-Object -First 10
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            foreach ($pattern in $multiTenantPatterns) {
                if ($content -match $pattern) {
                    $detectedStack.MultiTenant = $true
                    Write-Success "  ✓ Multi-tenant patterns detected"
                    break
                }
            }
            if ($detectedStack.MultiTenant) { break }
        }
        if ($detectedStack.MultiTenant) { break }
    }
    
    Write-Host ""
    Write-Info "📦 Installing components for $setupMode setup..."
    
    # Define component lists based on mode
    $commandsToInstall = @()
    $agentsToInstall = @()
    $installGenerators = $false
    $installTools = $false
    $installHooks = $false
    
    switch ($setupMode) {
        "minimal" {
            $commandsToInstall = @(
                "comprehensive-review",
                "quick-research",
                "create-command-and-or-agent"
            )
            $agentsToInstall = @(
                "code-reviewer",
                "tech-lead",
                "researcher"
            )
        }
        "standard" {
            $commandsToInstall = @(
                "comprehensive-review",
                "do-extensive-research",
                "quick-research",
                "create-command-and-or-agent",
                "update-changelog",
                "optimize-performance",
                "refactor-code"
            )
            $agentsToInstall = @(
                "code-reviewer",
                "tech-lead",
                "researcher",
                "code-simplifier",
                "technical-debt-analyst",
                "test-quality-analyst"
            )
            $installGenerators = $true
            $installHooks = $true
        }
        "comprehensive" {
            $commandsToInstall = @(
                "comprehensive-review",
                "do-extensive-research",
                "quick-research",
                "create-command-and-or-agent",
                "update-changelog",
                "optimize-performance",
                "refactor-code",
                "analyze-test-quality",
                "analyze-features",
                "analyze-domain-use-cases",
                "analyze-legacy-system",
                "analyze-technical-debt",
                "generate-documentation",
                "generate-marketing-material",
                "add-integration",
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
                "update-comprehensive-feature",
                "update-backend-feature-no-backward-compatibility",
                "update-frontend-feature-no-backward-compatibility",
                "update-comprehensive-feature-no-backward-compatibility"
            )
            $agentsToInstall = @(
                "code-reviewer",
                "tech-lead",
                "researcher",
                "code-simplifier",
                "technical-debt-analyst",
                "test-quality-analyst",
                "infrastructure-architect",
                "ux-reviewer",
                "business-domain-analyst",
                "legacy-system-analyzer",
                "visual-designer",
                "visual-designer-marketing",
                "security-reviewer",
                "frontend-developer",
                "technical-documentation-expert",
                "customer-value-translator",
                "feature-analyzer",
                "marketing-strategist",
                "sales-genius"
            )
            $installGenerators = $true
            $installTools = $true
            $installHooks = $true
        }
    }
    
    # Add backend-specific components (for non-comprehensive setups)
    if ($detectedStack.Backend -and $setupMode -ne "comprehensive") {
        $backendCommands = @(
            "add-backend-feature",
            "fix-backend-bug",
            "review-backend-code",
            "fix-backend-build-and-tests"
        )
        $commandsToInstall += $backendCommands
    }
    
    # Add frontend-specific components (for non-comprehensive setups)
    if ($detectedStack.Frontend -and $setupMode -ne "comprehensive") {
        $frontendCommands = @(
            "add-frontend-feature",
            "fix-frontend-bug",
            "review-frontend-code",
            "fix-frontend-build-and-tests"
        )
        $commandsToInstall += $frontendCommands
        if ($setupMode -ne "minimal") {
            $agentsToInstall += "frontend-developer"
        }
    }
    
    # Add security components for multi-tenant
    if ($detectedStack.MultiTenant -and $setupMode -ne "minimal") {
        $agentsToInstall += "security-reviewer"
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
            Write-Detail "✓ $command"
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
            Write-Detail "✓ $agent"
            $installedAgents++
        } else {
            Write-Detail "✗ $agent (not found)"
            $failedAgents++
        }
    }
    Write-Success "  Agents: $installedAgents installed$(if ($failedAgents -gt 0) { ", $failedAgents failed" })"
    
    # Install generators (if applicable)
    if ($installGenerators) {
        Write-Info "Installing generators..."
        $generatorFiles = @(
            "command-generator.ps1",
            "agent-generator.ps1",
            "hook-generator.ps1"
        )
        $installedGenerators = 0
        foreach ($generator in $generatorFiles) {
            $sourcePath = Join-Path $claudifyPath "templates" "generators" $generator
            $destPath = Join-Path $claudePath "generators" $generator
            
            if (Test-Path $sourcePath) {
                Copy-Item -Path $sourcePath -Destination $destPath -Force
                Write-Detail "✓ $generator"
                $installedGenerators++
            }
        }
        
        # Copy generator README
        $sourceReadme = Join-Path $claudifyPath "templates" "META-GENERATOR-README.md"
        $destReadme = Join-Path $claudePath "generators" "README.md"
        if (Test-Path $sourceReadme) {
            Copy-Item -Path $sourceReadme -Destination $destReadme -Force
        }
        
        Write-Success "  Generators: $installedGenerators installed"
    }
    
    # Install hooks (if applicable)
    if ($installHooks) {
        Write-Info "Installing hooks..."
        $hookFiles = @(
            "add-context.ps1",
            "pre-commit-quality-check.ps1",
            "check-changelog-updates.ps1"
        )
        
        if ($detectedStack.MultiTenant) {
            $hookFiles += "check-tenant-scoping.ps1"
        }
        
        $installedHooks = 0
        foreach ($hook in $hookFiles) {
            $sourcePath = Join-Path $claudifyPath ".claude" "hooks" $hook
            $destPath = Join-Path $claudePath "hooks" $hook
            
            if (Test-Path $sourcePath) {
                Copy-Item -Path $sourcePath -Destination $destPath -Force
                Write-Detail "✓ $hook"
                $installedHooks++
            }
        }
        Write-Success "  Hooks: $installedHooks installed"
    }
    
    # Install agent tools (comprehensive only)
    if ($installTools) {
        Write-Info "Installing agent tools..."
        $toolDirs = @(
            "security-reviewer",
            "technical-debt-analyst",
            "infrastructure-architect"
        )
        
        $installedTools = 0
        foreach ($toolDir in $toolDirs) {
            $sourcePath = Join-Path $claudifyPath ".claude" "agent-tools" $toolDir
            $destPath = Join-Path $claudePath "agent-tools" $toolDir
            
            if (Test-Path $sourcePath) {
                Copy-Item -Path $sourcePath -Destination $destPath -Recurse -Force
                Write-Detail "✓ $toolDir tools"
                $installedTools++
            }
        }
        
        # Copy agent-tools config
        $sourceConfig = Join-Path $claudifyPath ".claude" "agent-tools" "agent-tools-config.json"
        $destConfig = Join-Path $claudePath "agent-tools" "agent-tools-config.json"
        if (Test-Path $sourceConfig) {
            Copy-Item -Path $sourceConfig -Destination $destConfig -Force
        }
        
        Write-Success "  Agent tools: $installedTools tool sets installed"
    }
    
    # Copy validation tools
    Write-Info "Installing validation tools..."
    $validationFiles = @(
        "architecture-validator.ps1",
        "code-quality-validator.ps1",
        "test-coverage-analyzer.ps1"
    )
    $installedValidation = 0
    foreach ($validation in $validationFiles) {
        $sourcePath = Join-Path $claudifyPath ".claude" "validation" $validation
        $destPath = Join-Path $claudePath "validation" $validation
        
        if (Test-Path $sourcePath) {
            Copy-Item -Path $sourcePath -Destination $destPath -Force
            $installedValidation++
        }
    }
    Write-Success "  Validation tools: $installedValidation installed"
    
    # Copy documentation templates
    $sourceTemplates = Join-Path $claudifyPath ".claude" "templates" "documentation" "*.template"
    if (Test-Path $sourceTemplates) {
        Copy-Item -Path $sourceTemplates -Destination (Join-Path $claudePath "templates" "documentation") -Force
    }
    
    # Copy design guidelines
    $sourceGuidelines = Join-Path $claudifyPath ".claude" "COMMAND-AGENT-DESIGN-GUIDELINES.md"
    $destGuidelines = Join-Path $claudePath "COMMAND-AGENT-DESIGN-GUIDELINES.md"
    if (Test-Path $sourceGuidelines) {
        Copy-Item -Path $sourceGuidelines -Destination $destGuidelines -Force
    }
    
    # Generate CLAUDE.md if it doesn't exist
    $claudeMdPath = Join-Path $TargetRepository "CLAUDE.md"
    if (-not (Test-Path $claudeMdPath)) {
        Write-Info "`n📝 Generating intelligent CLAUDE.md..."
        
        $claudeMdContent = @"
# CLAUDE.md - Project Configuration

## 🧠 CONTEXT
**System**: $(if ($detectedStack.Backend) { $detectedStack.Backend } else { "Not detected - please specify" })
**Frontend**: $(if ($detectedStack.Frontend) { $detectedStack.Frontend } else { "Not detected - please specify" })
**Database**: $(if ($detectedStack.Database) { $detectedStack.Database } else { "Not detected - please specify" })
**Infrastructure**: $(if ($detectedStack.Infrastructure) { $detectedStack.Infrastructure } else { "Not detected - please specify" })
**Multi-tenant**: $(if ($detectedStack.MultiTenant) { "Yes - ensure tenant isolation" } else { "No" })
**Domain**: [Please specify your business domain]

## ⚡ CRITICAL RULES

### Architecture
$(if ($detectedStack.Backend -eq ".NET/C#") { "- Follow Domain-Driven Design (DDD) principles`n- Use Result pattern for operation outcomes`n- Implement repository pattern with Entity Framework Core" })
$(if ($detectedStack.Frontend -eq "React") { "- Use functional components with hooks`n- Implement proper state management (Redux/Context)`n- Follow React best practices and patterns" })
$(if ($detectedStack.Frontend -eq "Angular") { "- Use standalone components (Angular 19+)`n- Implement reactive forms`n- Follow Angular style guide" })
$(if ($detectedStack.MultiTenant) { "- ALWAYS scope data by tenant`n- Validate tenant context in all operations`n- Never allow cross-tenant data access" })
- Write clean, maintainable, testable code
- Follow SOLID principles
- Implement comprehensive error handling

### Development Workflow
1. Backend first: Model → Repository → Service → API
2. Update FEATURES.md immediately after implementing features
3. Frontend last: Only create UI for existing APIs
4. Write tests for business logic (80% coverage target)
5. Document all public APIs and complex logic

## 💻 CODE PATTERNS

### Backend Patterns
$(if ($detectedStack.Backend -eq ".NET/C#") { @"
- Async/await for all I/O operations
- Dependency injection for all services
- DTOs for API contracts
- Entity models for database
- Value objects for domain concepts
"@ })
$(if ($detectedStack.Backend -eq "Node.js") { @"
- Express middleware for cross-cutting concerns
- Async/await for all async operations
- Validation middleware for request validation
- Error handling middleware
"@ })
$(if ($detectedStack.Backend -eq "Python") { @"
- Type hints for all functions
- Pydantic for data validation
- Async/await for async operations
- Proper exception handling
"@ })

### Frontend Patterns
$(if ($detectedStack.Frontend) { @"
- Component-based architecture
- Proper state management
- Responsive design (mobile-first)
- Accessibility (WCAG 2.1 AA compliance)
- Performance optimization (lazy loading, code splitting)
"@ })

## 🔒 SECURITY CHECKLIST
- [ ] Input validation on all endpoints
- [ ] Authentication and authorization implemented
- [ ] SQL injection prevention (parameterized queries)
- [ ] XSS prevention (output encoding)
- [ ] CSRF protection
$(if ($detectedStack.MultiTenant) { "- [ ] Tenant isolation verified`n- [ ] Cross-tenant access prevented" })
- [ ] Sensitive data encryption
- [ ] Security headers configured
- [ ] Rate limiting implemented

## 🔍 QUICK REFERENCE

### Key Commands
**Backend Development:**
- `/add-backend-feature` - Create new backend features with DDD
- `/fix-backend-bug` - Debug and fix backend issues
- `/review-backend-code` - Comprehensive backend code review
- `/fix-backend-build-and-tests` - Fix build and test failures

**Frontend Development:**
- `/add-frontend-feature` - Create UI features with excellence
- `/fix-frontend-bug` - Debug UI issues systematically
- `/review-frontend-code` - Frontend code review with UX focus
- `/fix-frontend-build-and-tests` - Fix frontend build issues

**Quality & Analysis:**
- `/comprehensive-review` - Multi-agent comprehensive review
- `/analyze-technical-debt` - Identify and prioritize tech debt
- `/optimize-performance` - Performance optimization
- `/refactor-code` - Improve code quality

### Available Agents
$(foreach ($agent in $agentsToInstall) { "- **$agent** - Specialized expert agent`n" })

---
**Setup**: Claudify v2.0.0 | Mode: $setupMode | Generated: $(Get-Date -Format "yyyy-MM-dd")
**Remember**: Always prioritize code quality, security, and maintainability.
"@
        
        Set-Content -Path $claudeMdPath -Value $claudeMdContent -NoNewline
        Write-Success "  ✓ CLAUDE.md generated with intelligent defaults"
    }
    
    # Generate FEATURES.md if it doesn't exist
    $featuresMdPath = Join-Path $TargetRepository "FEATURES.md"
    if (-not (Test-Path $featuresMdPath)) {
        Write-Info "📝 Generating FEATURES.md template..."
        
        $featuresMdContent = @"
# Features Documentation

## Overview
[Please provide a brief description of your project]

## System Architecture

### Technology Stack
- **Backend**: $(if ($detectedStack.Backend) { $detectedStack.Backend } else { "Not detected" })
- **Frontend**: $(if ($detectedStack.Frontend) { $detectedStack.Frontend } else { "Not detected" })
- **Database**: $(if ($detectedStack.Database) { $detectedStack.Database } else { "Not detected" })
- **Infrastructure**: $(if ($detectedStack.Infrastructure) { $detectedStack.Infrastructure } else { "Not detected" })

### Architectural Patterns
$(if ($detectedStack.Backend -eq ".NET/C#") { "- Domain-Driven Design (DDD)`n- Repository Pattern`n- CQRS (if applicable)" })
$(if ($detectedStack.MultiTenant) { "- Multi-tenant architecture`n- Tenant isolation strategy" })
- [Add your architectural patterns]

### Key Components
- [List your main system components]
- [e.g., API Gateway, Auth Service, etc.]

---

## Core Features

### Feature 1: [Feature Name]
- **Description**: [What it does]
- **API Endpoints**: 
  - `GET /api/[endpoint]` - [Description]
  - `POST /api/[endpoint]` - [Description]
- **Business Rules**: 
  - [Key rule 1]
  - [Key rule 2]
- **Status**: ✅ Implemented / 🚧 In Progress / 📋 Planned

### Feature 2: [Feature Name]
- **Description**: [What it does]
- **API Endpoints**: [List endpoints]
- **Business Rules**: [Key rules]
- **Status**: [Status]

---

## Planned Features

### Q1 2025
1. **[Feature Name]** - [Brief description]
   - Priority: High/Medium/Low
   - Estimated effort: [X days/weeks]

2. **[Feature Name]** - [Brief description]
   - Priority: High/Medium/Low
   - Estimated effort: [X days/weeks]

### Q2 2025
1. **[Feature Name]** - [Brief description]
2. **[Feature Name]** - [Brief description]

---

## API Documentation

### Authentication
- **Method**: [JWT/OAuth2/etc.]
- **Endpoints**: [Auth endpoints]

### Main API Endpoints
[Document your main API endpoints here or link to API documentation]

---

## Development Guidelines

### Coding Standards
- [Language-specific standards]
- [Framework conventions]
- [Testing requirements]

### Git Workflow
- [Branch naming conventions]
- [Commit message format]
- [PR process]

---

## Deployment

### Environments
- **Development**: [URL/details]
- **Staging**: [URL/details]
- **Production**: [URL/details]

### CI/CD Pipeline
- [Build process]
- [Test automation]
- [Deployment steps]

---

*Last updated: $(Get-Date -Format "yyyy-MM-dd")*
*Generated by Claudify v2.0.0 Intelligent Setup*
"@
        
        Set-Content -Path $featuresMdPath -Value $featuresMdContent -NoNewline
        Write-Success "  ✓ FEATURES.md template generated"
    }
    
    # Installation summary
    Write-Host ""
    Write-Info "📊 Installation Summary"
    Write-Host "========================" -ForegroundColor DarkGray
    Write-Success "✓ Commands installed: $installedCommands"
    Write-Success "✓ Agents installed: $installedAgents"
    if ($installGenerators) { Write-Success "✓ Generators installed: 3" }
    if ($installHooks) { Write-Success "✓ Hooks installed: $(if ($detectedStack.MultiTenant) { 4 } else { 3 })" }
    if ($installTools) { Write-Success "✓ Agent tools installed: 3 sets" }
    Write-Success "✓ Validation tools: $installedValidation"
    
    # Final success message
    Write-Host ""
    Write-Success "✅ Claude Code setup completed successfully!"
    Write-Host ""
    Write-Info "Next Steps:"
    Write-Host "  1. Review and customize CLAUDE.md with your specific requirements" -ForegroundColor White
    Write-Host "  2. Update FEATURES.md with your actual features" -ForegroundColor White
    Write-Host "  3. Open terminal and run: " -NoNewline -ForegroundColor White
    Write-Host "claude code" -ForegroundColor Yellow
    Write-Host "  4. Try a command like: " -NoNewline -ForegroundColor White
    Write-Host "/comprehensive-review" -ForegroundColor Yellow
    Write-Host ""
    Write-Info "💡 TIP: You can still run /init-claudify in Claude Code for advanced customization"
    Write-Host ""
} else {
    Write-Host ""
    Write-Host "Skipping automatic installation." -ForegroundColor Yellow
    Write-Host "You can run /init-claudify in Claude Code for manual setup." -ForegroundColor White
}

# Display success message and instructions
Write-Host "`n" + ("─" * 60) -ForegroundColor DarkGray
Write-Host " ✓ Setup Complete!" -ForegroundColor Green
Write-Host ("─" * 60) -ForegroundColor DarkGray

if (-not $setupMode) {
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "  1. " -NoNewline -ForegroundColor DarkGray
    Write-Host "Open a terminal in: " -NoNewline -ForegroundColor White
    Write-Host $TargetRepository -ForegroundColor Yellow

    Write-Host "  2. " -NoNewline -ForegroundColor DarkGray
    Write-Host "Run: " -NoNewline -ForegroundColor White
    Write-Host "claude code" -ForegroundColor Yellow

    Write-Host "  3. " -NoNewline -ForegroundColor DarkGray
    Write-Host "In Claude Code, execute: " -NoNewline -ForegroundColor White
    Write-Host "/init-claudify" -ForegroundColor Yellow
} else {
    Write-Host "`nClaude Code is ready to use!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Quick start:" -ForegroundColor Cyan
    Write-Host "  1. " -NoNewline -ForegroundColor DarkGray
    Write-Host "Open a terminal in: " -NoNewline -ForegroundColor White
    Write-Host $TargetRepository -ForegroundColor Yellow
    
    Write-Host "  2. " -NoNewline -ForegroundColor DarkGray
    Write-Host "Run: " -NoNewline -ForegroundColor White
    Write-Host "claude code" -ForegroundColor Yellow
    
    Write-Host "  3. " -NoNewline -ForegroundColor DarkGray
    Write-Host "Try a command like: " -NoNewline -ForegroundColor White
    Write-Host "/comprehensive-review" -ForegroundColor Yellow
}

if ($CleanInstall) {
    Write-Host "`n  🆕 " -NoNewline -ForegroundColor Cyan
    Write-Host "Clean Install Complete: " -NoNewline -ForegroundColor White
    Write-Host "Fresh Claudify $version installation" -ForegroundColor Green
    Write-Host "     All previous components have been removed." -ForegroundColor DarkGray
    Write-Host "     Ready for Opus 4 optimized configuration." -ForegroundColor DarkGray
}