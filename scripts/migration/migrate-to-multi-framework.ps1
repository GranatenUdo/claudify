# Claudify Multi-Framework Migration Script
# Version: 1.0.0
# Purpose: Migrate Claudify from single-framework to multi-framework architecture

param(
    [Parameter(Mandatory=$false)]
    [string]$SourcePath = ".",
    
    [Parameter(Mandatory=$false)]
    [string]$BackupPath = ".\.claudify-backup",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipBackup = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Component classification mappings
$ComponentMappings = @{
    # Core/Engineering Support Department Components
    "core" = @{
        "agents" = @(
            "code-reviewer",
            "security-reviewer", 
            "tech-lead",
            "test-quality-analyst",
            "technical-debt-analyst",
            "infrastructure-architect",
            "researcher",
            "business-domain-analyst",
            "code-simplifier",
            "legacy-system-analyzer",
            "customer-value-translator",
            "feature-analyzer",
            "technical-documentation-expert"
        )
        "commands" = @{
            "essential" = @(
                "comprehensive-review",
                "do-extensive-research",
                "quick-research",
                "create-command-and-or-agent",
                "agents",
                "init-claudify"
            )
            "quality" = @(
                "analyze-technical-debt",
                "analyze-test-quality",
                "refactor-code",
                "optimize-performance"
            )
            "documentation" = @(
                "generate-documentation",
                "update-changelog"
            )
            "specialized" = @(
                "analyze-legacy-system",
                "analyze-domain-use-cases",
                "add-integration",
                "update-comprehensive-feature",
                "update-comprehensive-feature-no-backward-compatibility"
            )
        }
        "hooks" = @(
            "add-context",
            "pre-commit-quality-check",
            "check-changelog-updates",
            "after-component-creation",
            "install-hooks"
        )
        "generators" = @(
            "command-generator",
            "agent-generator", 
            "hook-generator"
        )
    }
    
    # Frontend Angular Components
    "frontend-angular" = @{
        "agents" = @(
            "frontend-developer",
            "ux-reviewer",
            "visual-designer",
            "visual-designer-marketing"
        )
        "commands" = @(
            "add-frontend-feature",
            "fix-frontend-bug",
            "review-frontend-code",
            "fix-frontend-build-and-tests",
            "figma-implement-current-selection",
            "update-frontend-feature",
            "update-frontend-feature-no-backward-compatibility"
        )
        "hooks" = @()
        "templates" = @()
    }
    
    # Backend .NET/MSSQL Components  
    "backend-dotnet-mssql" = @{
        "agents" = @()
        "commands" = @(
            "add-backend-feature",
            "fix-backend-bug",
            "review-backend-code",
            "fix-backend-build-and-tests",
            "update-backend-feature",
            "update-backend-feature-no-backward-compatibility"
        )
        "hooks" = @(
            "check-tenant-scoping",
            "validate-tenant-scoping"
        )
        "agent-tools" = @(
            "security-scanner",
            "dependency-analyzer",
            "complexity-analyzer",
            "debt-tracker",
            "deployment-analyzer",
            "cloud-cost-optimizer",
            "performance-baseline"
        )
    }
    
    # Marketing/Sales Components (separate category)
    "business-operations" = @{
        "agents" = @(
            "marketing-strategist",
            "sales-genius"
        )
        "commands" = @(
            "generate-marketing-material",
            "analyze-features"
        )
    }
}

function Write-MigrationLog {
    param(
        [string]$Message,
        [string]$Level = "INFO"
    )
    
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] [$Level] $Message"
    
    switch ($Level) {
        "ERROR" { Write-Host $logMessage -ForegroundColor Red }
        "WARNING" { Write-Host $logMessage -ForegroundColor Yellow }
        "SUCCESS" { Write-Host $logMessage -ForegroundColor Green }
        "INFO" { Write-Host $logMessage -ForegroundColor Cyan }
        default { Write-Host $logMessage }
    }
    
    # Also write to log file
    $logFile = Join-Path $SourcePath "migration.log"
    Add-Content -Path $logFile -Value $logMessage
}

function Backup-CurrentStructure {
    param([string]$Source, [string]$Destination)
    
    Write-MigrationLog "Creating backup of current structure..." "INFO"
    
    if (Test-Path $Destination) {
        Write-MigrationLog "Backup directory already exists. Removing old backup..." "WARNING"
        Remove-Item -Path $Destination -Recurse -Force
    }
    
    New-Item -ItemType Directory -Path $Destination -Force | Out-Null
    
    # Backup .claude directory
    if (Test-Path (Join-Path $Source ".claude")) {
        Copy-Item -Path (Join-Path $Source ".claude") `
                  -Destination (Join-Path $Destination ".claude") `
                  -Recurse -Force
        Write-MigrationLog "Backed up .claude directory" "SUCCESS"
    }
    
    # Backup .claudify directory
    if (Test-Path (Join-Path $Source ".claudify")) {
        Copy-Item -Path (Join-Path $Source ".claudify") `
                  -Destination (Join-Path $Destination ".claudify") `
                  -Recurse -Force
        Write-MigrationLog "Backed up .claudify directory" "SUCCESS"
    }
    
    # Backup components-manifest.json
    if (Test-Path (Join-Path $Source "components-manifest.json")) {
        Copy-Item -Path (Join-Path $Source "components-manifest.json") `
                  -Destination (Join-Path $Destination "components-manifest.json") `
                  -Force
        Write-MigrationLog "Backed up components-manifest.json" "SUCCESS"
    }
}

function Create-DirectoryStructure {
    param([string]$BasePath)
    
    Write-MigrationLog "Creating new directory structure..." "INFO"
    
    $directories = @(
        # Core directories
        "core\agents",
        "core\commands\essential",
        "core\commands\quality",
        "core\commands\documentation",
        "core\commands\specialized",
        "core\hooks",
        "core\generators",
        "core\validation",
        
        # Framework directories
        "frameworks\frontend-angular\agents",
        "frameworks\frontend-angular\commands",
        "frameworks\frontend-angular\hooks",
        "frameworks\frontend-angular\templates\components",
        "frameworks\frontend-angular\templates\services",
        "frameworks\frontend-angular\templates\patterns",
        "frameworks\frontend-angular\agent-configs",
        
        "frameworks\backend-dotnet-mssql\agents",
        "frameworks\backend-dotnet-mssql\commands",
        "frameworks\backend-dotnet-mssql\hooks",
        "frameworks\backend-dotnet-mssql\templates\entities",
        "frameworks\backend-dotnet-mssql\templates\repositories",
        "frameworks\backend-dotnet-mssql\templates\services",
        "frameworks\backend-dotnet-mssql\templates\patterns",
        "frameworks\backend-dotnet-mssql\agent-tools",
        
        "frameworks\business-operations\agents",
        "frameworks\business-operations\commands",
        
        # Plugin directories
        "plugins\community",
        "plugins\custom",
        
        # Source modules
        "src\modules\plugin-management",
        "src\modules\framework-detection",
        "src\modules\component-selection"
    )
    
    foreach ($dir in $directories) {
        $fullPath = Join-Path $BasePath $dir
        if (-not (Test-Path $fullPath)) {
            if (-not $DryRun) {
                New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
            }
            Write-MigrationLog "Created directory: $dir" "SUCCESS"
        }
    }
}

function Migrate-Component {
    param(
        [string]$SourceFile,
        [string]$TargetFile,
        [string]$ComponentType,
        [hashtable]$Transformations = @{}
    )
    
    if (-not (Test-Path $SourceFile)) {
        Write-MigrationLog "Source file not found: $SourceFile" "WARNING"
        return
    }
    
    $targetDir = Split-Path -Parent $TargetFile
    if (-not (Test-Path $targetDir)) {
        if (-not $DryRun) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
    }
    
    if (-not $DryRun) {
        # Read source content
        $content = Get-Content -Path $SourceFile -Raw
        
        # Apply transformations
        foreach ($search in $Transformations.Keys) {
            $replace = $Transformations[$search]
            $content = $content -replace $search, $replace
        }
        
        # Update component references for framework-specific components
        if ($TargetFile -match "frameworks\\frontend-angular") {
            $content = Update-AngularReferences -Content $content
        }
        elseif ($TargetFile -match "frameworks\\backend-dotnet-mssql") {
            $content = Update-DotNetReferences -Content $content
        }
        
        # Write to target
        Set-Content -Path $TargetFile -Value $content -Encoding UTF8
    }
    
    Write-MigrationLog "Migrated ${ComponentType}: $(Split-Path -Leaf $SourceFile) -> $TargetFile" "SUCCESS"
}

function Update-AngularReferences {
    param([string]$Content)
    
    $replacements = @{
        "frontend-developer" = "angular-developer"
        "add-frontend-feature" = "add-angular-feature"
        "fix-frontend-bug" = "fix-angular-bug"
        "review-frontend-code" = "review-angular-code"
        "update-frontend-feature" = "update-angular-feature"
    }
    
    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        $Content = $Content -replace $old, $new
    }
    
    return $Content
}

function Update-DotNetReferences {
    param([string]$Content)
    
    $replacements = @{
        "add-backend-feature" = "add-dotnet-feature"
        "fix-backend-bug" = "fix-dotnet-bug"
        "review-backend-code" = "review-dotnet-code"
        "update-backend-feature" = "update-dotnet-feature"
    }
    
    foreach ($old in $replacements.Keys) {
        $new = $replacements[$old]
        $Content = $Content -replace $old, $new
    }
    
    return $Content
}

function Migrate-Components {
    param([string]$SourceBase, [string]$TargetBase)
    
    Write-MigrationLog "Starting component migration..." "INFO"
    
    # Migrate Core Components
    Write-MigrationLog "Migrating core components..." "INFO"
    foreach ($agent in $ComponentMappings.core.agents) {
        $source = Join-Path $SourceBase ".claude\agents\$agent.md"
        $target = Join-Path $TargetBase "core\agents\$agent.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "core-agent"
    }
    
    foreach ($category in $ComponentMappings.core.commands.Keys) {
        foreach ($command in $ComponentMappings.core.commands[$category]) {
            $source = Join-Path $SourceBase ".claude\commands\$command.md"
            $target = Join-Path $TargetBase "core\commands\$category\$command.md"
            Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "core-command"
        }
    }
    
    foreach ($hook in $ComponentMappings.core.hooks) {
        $source = Join-Path $SourceBase ".claude\hooks\$hook.ps1"
        $target = Join-Path $TargetBase "core\hooks\$hook.ps1"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "core-hook"
    }
    
    foreach ($generator in $ComponentMappings.core.generators) {
        $source = Join-Path $SourceBase ".claude\generators\$generator.ps1"
        $target = Join-Path $TargetBase "core\generators\$generator.ps1"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "core-generator"
    }
    
    # Migrate Angular Components
    Write-MigrationLog "Migrating Angular components..." "INFO"
    foreach ($agent in $ComponentMappings."frontend-angular".agents) {
        $source = Join-Path $SourceBase ".claude\agents\$agent.md"
        $newName = $agent -replace "frontend-developer", "angular-developer" `
                         -replace "ux-reviewer", "angular-ux-reviewer" `
                         -replace "visual-designer", "angular-visual-designer"
        $target = Join-Path $TargetBase "frameworks\frontend-angular\agents\$newName.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "angular-agent"
    }
    
    foreach ($command in $ComponentMappings."frontend-angular".commands) {
        $source = Join-Path $SourceBase ".claude\commands\$command.md"
        $newName = $command -replace "frontend", "angular"
        $target = Join-Path $TargetBase "frameworks\frontend-angular\commands\$newName.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "angular-command"
    }
    
    # Migrate .NET Components
    Write-MigrationLog "Migrating .NET components..." "INFO"
    foreach ($command in $ComponentMappings."backend-dotnet-mssql".commands) {
        $source = Join-Path $SourceBase ".claude\commands\$command.md"
        $newName = $command -replace "backend", "dotnet"
        $target = Join-Path $TargetBase "frameworks\backend-dotnet-mssql\commands\$newName.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "dotnet-command"
    }
    
    foreach ($hook in $ComponentMappings."backend-dotnet-mssql".hooks) {
        $source = Join-Path $SourceBase ".claude\hooks\$hook.ps1"
        $target = Join-Path $TargetBase "frameworks\backend-dotnet-mssql\hooks\$hook.ps1"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "dotnet-hook"
    }
    
    # Migrate Business Operations Components
    Write-MigrationLog "Migrating business operations components..." "INFO"
    foreach ($agent in $ComponentMappings."business-operations".agents) {
        $source = Join-Path $SourceBase ".claude\agents\$agent.md"
        $target = Join-Path $TargetBase "frameworks\business-operations\agents\$agent.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "business-agent"
    }
    
    foreach ($command in $ComponentMappings."business-operations".commands) {
        $source = Join-Path $SourceBase ".claude\commands\$command.md"
        $target = Join-Path $TargetBase "frameworks\business-operations\commands\$command.md"
        Migrate-Component -SourceFile $source -TargetFile $target -ComponentType "business-command"
    }
}

function Create-PluginManifests {
    param([string]$BasePath)
    
    Write-MigrationLog "Creating plugin manifests..." "INFO"
    
    # Angular Plugin Manifest
    $angularManifest = @{
        pluginInfo = @{
            name = "frontend-angular"
            displayName = "Angular Frontend Framework"
            version = "1.0.0"
            description = "Complete Angular development toolkit with TypeScript, RxJS, and Material Design support"
            author = "Claudify Team"
            tags = @("frontend", "angular", "typescript", "spa", "rxjs")
        }
        compatibility = @{
            claudifyMinVersion = "4.0.0"
            claudifyMaxVersion = "5.0.0"
            frameworkVersions = @{
                angular = ">=16.0.0"
                typescript = ">=4.9.0"
            }
        }
        dependencies = @{
            required = @("core")
            optional = @("testing-jasmine", "ui-material")
            conflicts = @("frontend-react", "frontend-vue")
        }
        detection = @{
            patterns = @{
                files = @("angular.json", "package.json")
                content = @("@angular/core", "ng serve", "angular.json")
                directories = @("src/app", "src/environments")
            }
            priority = 90
            autoSelect = $true
        }
    }
    
    $angularManifestPath = Join-Path $BasePath "frameworks\frontend-angular\plugin-manifest.json"
    if (-not $DryRun) {
        $angularManifest | ConvertTo-Json -Depth 10 | Set-Content -Path $angularManifestPath -Encoding UTF8
    }
    Write-MigrationLog "Created Angular plugin manifest" "SUCCESS"
    
    # .NET Plugin Manifest
    $dotnetManifest = @{
        pluginInfo = @{
            name = "backend-dotnet-mssql"
            displayName = ".NET Backend with SQL Server"
            version = "1.0.0"
            description = "Enterprise .NET development toolkit with Entity Framework, DDD patterns, and SQL Server"
            author = "Claudify Team"
            tags = @("backend", "dotnet", "csharp", "mssql", "entity-framework", "ddd")
        }
        compatibility = @{
            claudifyMinVersion = "4.0.0"
            claudifyMaxVersion = "5.0.0"
            frameworkVersions = @{
                dotnet = ">=6.0"
                "entity-framework" = ">=7.0"
            }
        }
        dependencies = @{
            required = @("core")
            optional = @("testing-xunit", "api-swagger")
            conflicts = @("backend-nodejs", "backend-python")
        }
        detection = @{
            patterns = @{
                files = @("*.csproj", "*.sln", "appsettings.json")
                content = @("Microsoft.EntityFrameworkCore", "Microsoft.AspNetCore")
                directories = @("Controllers", "Models", "Services")
            }
            priority = 85
            autoSelect = $true
        }
    }
    
    $dotnetManifestPath = Join-Path $BasePath "frameworks\backend-dotnet-mssql\plugin-manifest.json"
    if (-not $DryRun) {
        $dotnetManifest | ConvertTo-Json -Depth 10 | Set-Content -Path $dotnetManifestPath -Encoding UTF8
    }
    Write-MigrationLog "Created .NET plugin manifest" "SUCCESS"
}

function Create-BackwardCompatibilityLayer {
    param([string]$BasePath)
    
    Write-MigrationLog "Creating backward compatibility layer..." "INFO"
    
    # Create .claude directory with symbolic links or redirect scripts
    $claudeDir = Join-Path $BasePath ".claude"
    if (-not (Test-Path $claudeDir)) {
        New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
    }
    
    # Create subdirectories
    @("agents", "commands", "hooks", "generators") | ForEach-Object {
        $subDir = Join-Path $claudeDir $_
        if (-not (Test-Path $subDir)) {
            New-Item -ItemType Directory -Path $subDir -Force | Out-Null
        }
    }
    
    # Create compatibility mapping file
    $compatibilityMap = @{
        agents = @{
            "frontend-developer" = "frameworks/frontend-angular/agents/angular-developer.md"
            "code-reviewer" = "core/agents/code-reviewer.md"
            "security-reviewer" = "core/agents/security-reviewer.md"
        }
        commands = @{
            "add-frontend-feature" = "frameworks/frontend-angular/commands/add-angular-feature.md"
            "add-backend-feature" = "frameworks/backend-dotnet-mssql/commands/add-dotnet-feature.md"
            "comprehensive-review" = "core/commands/essential/comprehensive-review.md"
        }
    }
    
    $compatMapPath = Join-Path $BasePath ".claude\compatibility-map.json"
    if (-not $DryRun) {
        $compatibilityMap | ConvertTo-Json -Depth 10 | Set-Content -Path $compatMapPath -Encoding UTF8
    }
    
    Write-MigrationLog "Created backward compatibility mapping" "SUCCESS"
}

function Update-ComponentsManifest {
    param([string]$BasePath)
    
    Write-MigrationLog "Updating components-manifest.json..." "INFO"
    
    $manifestPath = Join-Path $BasePath "components-manifest.json"
    if (Test-Path $manifestPath) {
        $manifest = Get-Content $manifestPath | ConvertFrom-Json
        
        # Update version
        $manifest.claudifyVersion = "4.0.0"
        $manifest.version = "4.0.0"
        
        # Add plugin support
        if (-not $manifest.PSObject.Properties["plugins"]) {
            $manifest | Add-Member -MemberType NoteProperty -Name "plugins" -Value @{
                enabled = $true
                autoDetect = $true
                installed = @("frontend-angular", "backend-dotnet-mssql")
            }
        }
        
        # Add framework mappings
        if (-not $manifest.PSObject.Properties["frameworkMappings"]) {
            $manifest | Add-Member -MemberType NoteProperty -Name "frameworkMappings" -Value @{
                "frontend-angular" = @{
                    path = "frameworks/frontend-angular"
                    manifest = "plugin-manifest.json"
                }
                "backend-dotnet-mssql" = @{
                    path = "frameworks/backend-dotnet-mssql"
                    manifest = "plugin-manifest.json"
                }
            }
        }
        
        if (-not $DryRun) {
            $manifest | ConvertTo-Json -Depth 10 | Set-Content -Path $manifestPath -Encoding UTF8
        }
        
        Write-MigrationLog "Updated components-manifest.json to version 4.0.0" "SUCCESS"
    }
}

function Test-Migration {
    param([string]$BasePath)
    
    Write-MigrationLog "Running migration validation tests..." "INFO"
    
    $tests = @(
        @{
            Name = "Core agents exist"
            Test = { Test-Path (Join-Path $BasePath "core\agents\code-reviewer.md") }
        },
        @{
            Name = "Angular plugin manifest exists"
            Test = { Test-Path (Join-Path $BasePath "frameworks\frontend-angular\plugin-manifest.json") }
        },
        @{
            Name = ".NET plugin manifest exists"
            Test = { Test-Path (Join-Path $BasePath "frameworks\backend-dotnet-mssql\plugin-manifest.json") }
        },
        @{
            Name = "Backward compatibility layer exists"
            Test = { Test-Path (Join-Path $BasePath ".claude\compatibility-map.json") }
        },
        @{
            Name = "Components manifest updated"
            Test = {
                $manifest = Get-Content (Join-Path $BasePath "components-manifest.json") | ConvertFrom-Json
                $manifest.version -eq "4.0.0"
            }
        }
    )
    
    $passed = 0
    $failed = 0
    
    foreach ($test in $tests) {
        try {
            if (& $test.Test) {
                Write-MigrationLog "✓ $($test.Name)" "SUCCESS"
                $passed++
            } else {
                Write-MigrationLog "✗ $($test.Name)" "ERROR"
                $failed++
            }
        } catch {
            Write-MigrationLog "✗ $($test.Name): $_" "ERROR"
            $failed++
        }
    }
    
    Write-MigrationLog "Migration validation complete: $passed passed, $failed failed" $(if ($failed -eq 0) { "SUCCESS" } else { "WARNING" })
    
    return $failed -eq 0
}

# Main execution
function Main {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Claudify Multi-Framework Migration   " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    if ($DryRun) {
        Write-MigrationLog "Running in DRY RUN mode - no changes will be made" "WARNING"
    }
    
    # Step 1: Backup
    if (-not $SkipBackup) {
        Backup-CurrentStructure -Source $SourcePath -Destination $BackupPath
    }
    
    # Step 2: Create new structure
    Create-DirectoryStructure -BasePath $SourcePath
    
    # Step 3: Migrate components
    Migrate-Components -SourceBase $SourcePath -TargetBase $SourcePath
    
    # Step 4: Create plugin manifests
    Create-PluginManifests -BasePath $SourcePath
    
    # Step 5: Create backward compatibility
    Create-BackwardCompatibilityLayer -BasePath $SourcePath
    
    # Step 6: Update manifest
    Update-ComponentsManifest -BasePath $SourcePath
    
    # Step 7: Validate
    if (-not $DryRun) {
        $success = Test-Migration -BasePath $SourcePath
        
        if ($success) {
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "  Migration Completed Successfully!     " -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "Next steps:" -ForegroundColor Yellow
            Write-Host "1. Review the migrated structure in core/ and frameworks/" -ForegroundColor White
            Write-Host "2. Test with: .\setup.ps1 -TargetRepository [path]" -ForegroundColor White
            Write-Host "3. Run Claude Code and test commands" -ForegroundColor White
            Write-Host ""
            Write-Host "Backup saved to: $BackupPath" -ForegroundColor Cyan
        } else {
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Red
            Write-Host "  Migration Completed with Warnings    " -ForegroundColor Red
            Write-Host "========================================" -ForegroundColor Red
            Write-Host ""
            Write-Host "Please review the migration.log for details" -ForegroundColor Yellow
            Write-Host "Backup saved to: $BackupPath" -ForegroundColor Cyan
        }
    }
}

# Execute main function
Main