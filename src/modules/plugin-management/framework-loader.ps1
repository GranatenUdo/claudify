# Framework Loader for Claudify v4.0.0
# Loads framework plugins based on detection or user selection

param(
    [Parameter(Mandatory=$false)]
    [string]$RepositoryPath = ".",
    
    [Parameter(Mandatory=$false)]
    [string[]]$Frameworks = @(),
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoDetect = $true,
    
    [Parameter(Mandatory=$false)]
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Load components manifest
function Get-ComponentsManifest {
    param([string]$Path = ".")
    
    $manifestPath = Join-Path $Path "components-manifest.json"
    if (Test-Path $manifestPath) {
        return Get-Content $manifestPath | ConvertFrom-Json
    }
    
    Write-Error "Components manifest not found at $manifestPath"
    return $null
}

# Detect frameworks in repository
function Detect-Frameworks {
    param([string]$Path)
    
    $manifest = Get-ComponentsManifest
    $detected = @()
    
    if ($Verbose) {
        Write-Host "Detecting frameworks in: $Path" -ForegroundColor Cyan
    }
    
    # Check frontend frameworks
    foreach ($framework in $manifest.techStackDetection.frontend.PSObject.Properties) {
        $frameworkName = $framework.Name
        $patterns = $framework.Value.patterns
        
        foreach ($pattern in $patterns) {
            if ($pattern -match '\*') {
                # File pattern
                $files = Get-ChildItem -Path $Path -Filter $pattern -Recurse -ErrorAction SilentlyContinue
                if ($files) {
                    $detected += $framework.Value.plugin
                    if ($Verbose) {
                        Write-Host "  Detected $frameworkName via pattern: $pattern" -ForegroundColor Green
                    }
                    break
                }
            } else {
                # Check in package.json or file existence
                if ($pattern -match '@|^[a-z-]+$') {
                    # Package dependency
                    $packageJsonPath = Join-Path $Path "package.json"
                    if (Test-Path $packageJsonPath) {
                        $packageJson = Get-Content $packageJsonPath | ConvertFrom-Json
                        if ($packageJson.dependencies.PSObject.Properties.Name -contains $pattern -or
                            $packageJson.devDependencies.PSObject.Properties.Name -contains $pattern) {
                            $detected += $framework.Value.plugin
                            if ($Verbose) {
                                Write-Host "  Detected $frameworkName via dependency: $pattern" -ForegroundColor Green
                            }
                            break
                        }
                    }
                } elseif (Test-Path (Join-Path $Path $pattern)) {
                    $detected += $framework.Value.plugin
                    if ($Verbose) {
                        Write-Host "  Detected $frameworkName via file: $pattern" -ForegroundColor Green
                    }
                    break
                }
            }
        }
    }
    
    # Check backend frameworks
    foreach ($framework in $manifest.techStackDetection.backend.PSObject.Properties) {
        $frameworkName = $framework.Name
        $patterns = $framework.Value.patterns
        
        foreach ($pattern in $patterns) {
            if ($pattern -match '\*') {
                $files = Get-ChildItem -Path $Path -Filter $pattern -Recurse -ErrorAction SilentlyContinue
                if ($files) {
                    $detected += $framework.Value.plugin
                    if ($Verbose) {
                        Write-Host "  Detected $frameworkName via pattern: $pattern" -ForegroundColor Green
                    }
                    break
                }
            } elseif (Test-Path (Join-Path $Path $pattern)) {
                $detected += $framework.Value.plugin
                if ($Verbose) {
                    Write-Host "  Detected $frameworkName via file: $pattern" -ForegroundColor Green
                }
                break
            }
        }
    }
    
    # Remove duplicates
    $detected = $detected | Select-Object -Unique
    
    if ($Verbose) {
        Write-Host "`nDetected frameworks: $($detected -join ', ')" -ForegroundColor Yellow
    }
    
    return $detected
}

# Load framework plugin
function Load-FrameworkPlugin {
    param(
        [string]$PluginName,
        [string]$TargetPath
    )
    
    $manifest = Get-ComponentsManifest
    
    if (-not $manifest.frameworkMappings.PSObject.Properties.Name -contains $PluginName) {
        Write-Warning "Framework plugin '$PluginName' not found in manifest"
        return $false
    }
    
    $frameworkConfig = $manifest.frameworkMappings.$PluginName
    $pluginPath = $frameworkConfig.path
    
    if (-not (Test-Path $pluginPath)) {
        Write-Warning "Framework plugin path not found: $pluginPath"
        return $false
    }
    
    # Load plugin manifest if exists
    if ($frameworkConfig.manifest) {
        $pluginManifestPath = Join-Path $pluginPath $frameworkConfig.manifest
        if (Test-Path $pluginManifestPath) {
            $pluginManifest = Get-Content $pluginManifestPath | ConvertFrom-Json
            
            if ($Verbose) {
                Write-Host "Loading plugin: $($pluginManifest.pluginInfo.displayName)" -ForegroundColor Cyan
                Write-Host "  Version: $($pluginManifest.pluginInfo.version)" -ForegroundColor Gray
                Write-Host "  Description: $($pluginManifest.pluginInfo.description)" -ForegroundColor Gray
            }
            
            # Check compatibility
            if ($pluginManifest.compatibility.claudifyMinVersion) {
                $currentVersion = [Version]$manifest.claudifyVersion
                $minVersion = [Version]$pluginManifest.compatibility.claudifyMinVersion
                
                if ($currentVersion -lt $minVersion) {
                    Write-Warning "Plugin requires Claudify version $minVersion or higher (current: $currentVersion)"
                    return $false
                }
            }
        }
    }
    
    Write-Host "✓ Loaded framework plugin: $PluginName" -ForegroundColor Green
    return $true
}

# Get list of components from plugin
function Get-PluginComponents {
    param([string]$PluginName)
    
    $manifest = Get-ComponentsManifest
    $components = @{
        Agents = @()
        Commands = @()
        Hooks = @()
        Templates = @()
    }
    
    # For core, use the core section
    if ($PluginName -eq "core") {
        $components.Agents = $manifest.core.agents
        $components.Commands = $manifest.core.commands | ForEach-Object { $_.PSObject.Properties.Value } | ForEach-Object { $_ }
        $components.Hooks = $manifest.core.hooks
        $components.Generators = $manifest.core.generators
        return $components
    }
    
    # For framework plugins, load from plugin manifest
    $frameworkConfig = $manifest.frameworkMappings.$PluginName
    if ($frameworkConfig -and $frameworkConfig.manifest) {
        $pluginManifestPath = Join-Path $frameworkConfig.path $frameworkConfig.manifest
        if (Test-Path $pluginManifestPath) {
            $pluginManifest = Get-Content $pluginManifestPath | ConvertFrom-Json
            
            $components.Agents = $pluginManifest.components.agents | ForEach-Object { $_.name }
            $components.Commands = $pluginManifest.components.commands | ForEach-Object { $_.name }
            $components.Hooks = $pluginManifest.components.hooks | ForEach-Object { $_.name }
            $components.Templates = $pluginManifest.components.templates | ForEach-Object { $_.name }
        }
    }
    
    return $components
}

# Main execution
function Main {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "   Claudify Framework Loader v4.0.0    " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Always load core
    Write-Host "Loading core components..." -ForegroundColor Yellow
    Load-FrameworkPlugin -PluginName "core" -TargetPath $RepositoryPath | Out-Null
    
    # Auto-detect or use specified frameworks
    $frameworksToLoad = @()
    
    if ($AutoDetect -and $Frameworks.Count -eq 0) {
        Write-Host "Auto-detecting frameworks..." -ForegroundColor Yellow
        $frameworksToLoad = Detect-Frameworks -Path $RepositoryPath
    } else {
        $frameworksToLoad = $Frameworks
    }
    
    # Load each framework
    foreach ($framework in $frameworksToLoad) {
        Write-Host "`nLoading framework: $framework" -ForegroundColor Yellow
        $success = Load-FrameworkPlugin -PluginName $framework -TargetPath $RepositoryPath
        
        if ($success -and $Verbose) {
            $components = Get-PluginComponents -PluginName $framework
            Write-Host "  Agents: $($components.Agents.Count)" -ForegroundColor Gray
            Write-Host "  Commands: $($components.Commands.Count)" -ForegroundColor Gray
            Write-Host "  Hooks: $($components.Hooks.Count)" -ForegroundColor Gray
            Write-Host "  Templates: $($components.Templates.Count)" -ForegroundColor Gray
        }
    }
    
    # Summary
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "        Framework Loading Complete      " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Loaded plugins:" -ForegroundColor Yellow
    Write-Host "  - core (always loaded)" -ForegroundColor White
    foreach ($framework in $frameworksToLoad) {
        Write-Host "  - $framework" -ForegroundColor White
    }
    
    # Show available components summary
    $totalComponents = @{
        Agents = 0
        Commands = 0
        Hooks = 0
        Templates = 0
    }
    
    # Count core components
    $coreComponents = Get-PluginComponents -PluginName "core"
    $totalComponents.Agents += $coreComponents.Agents.Count
    $totalComponents.Commands += $coreComponents.Commands.Count
    $totalComponents.Hooks += $coreComponents.Hooks.Count
    
    # Count framework components
    foreach ($framework in $frameworksToLoad) {
        $frameworkComponents = Get-PluginComponents -PluginName $framework
        $totalComponents.Agents += $frameworkComponents.Agents.Count
        $totalComponents.Commands += $frameworkComponents.Commands.Count
        $totalComponents.Hooks += $frameworkComponents.Hooks.Count
        $totalComponents.Templates += $frameworkComponents.Templates.Count
    }
    
    Write-Host ""
    Write-Host "Total available components:" -ForegroundColor Yellow
    Write-Host "  Agents: $($totalComponents.Agents)" -ForegroundColor White
    Write-Host "  Commands: $($totalComponents.Commands)" -ForegroundColor White
    Write-Host "  Hooks: $($totalComponents.Hooks)" -ForegroundColor White
    Write-Host "  Templates: $($totalComponents.Templates)" -ForegroundColor White
    
    Write-Host ""
    Write-Host "Use '/framework-management' in Claude Code to manage frameworks" -ForegroundColor Cyan
    
    return @{
        LoadedPlugins = @("core") + $frameworksToLoad
        Components = $totalComponents
    }
}

# Execute if run directly
if ($MyInvocation.InvocationName -ne '.') {
    Main
}