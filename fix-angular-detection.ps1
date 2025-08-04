# Angular Detection Fix for setup.ps1
# Replace the frontend detection section (lines 458-476) with this improved version

function Find-AngularProject {
    param([string]$RootPath)
    
    Write-Verbose "Searching for Angular projects in $RootPath"
    
    # Common Angular project locations in enterprise projects
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
        
        # Check for Angular-specific files
        $angularJson = Join-Path $checkPath "angular.json"
        $packageJson = Join-Path $checkPath "package.json"
        
        # Primary indicator: angular.json
        if (Test-Path $angularJson) {
            Write-Verbose "Found angular.json in $checkPath"
            return @{
                Detected = $true
                Path = $checkPath
                RelativePath = if ($subPath) { $subPath } else { "." }
                Type = "Angular"
                ConfigFile = "angular.json"
            }
        }
        
        # Secondary indicator: package.json with Angular dependencies
        if (Test-Path $packageJson) {
            try {
                $packageContent = Get-Content $packageJson -Raw | ConvertFrom-Json
                
                # Check both dependencies and devDependencies
                $allDeps = @()
                if ($packageContent.dependencies) {
                    $allDeps += $packageContent.dependencies.PSObject.Properties.Name
                }
                if ($packageContent.devDependencies) {
                    $allDeps += $packageContent.devDependencies.PSObject.Properties.Name
                }
                
                # Check for Angular indicators
                $hasAngular = $allDeps | Where-Object { 
                    $_ -eq "@angular/core" -or 
                    $_ -eq "@angular/cli" -or
                    $_ -eq "@angular/common" -or
                    $_ -match "^@angular/"
                }
                
                if ($hasAngular) {
                    Write-Verbose "Found Angular dependencies in $checkPath/package.json"
                    
                    # Get Angular version if available
                    $angularVersion = $null
                    if ($packageContent.dependencies."@angular/core") {
                        $angularVersion = $packageContent.dependencies."@angular/core"
                    } elseif ($packageContent.devDependencies."@angular/core") {
                        $angularVersion = $packageContent.devDependencies."@angular/core"
                    }
                    
                    return @{
                        Detected = $true
                        Path = $checkPath
                        RelativePath = if ($subPath) { $subPath } else { "." }
                        Type = "Angular"
                        Version = $angularVersion
                        ConfigFile = "package.json"
                    }
                }
            }
            catch {
                Write-Warning "Failed to parse package.json at $packageJson: $_"
            }
        }
    }
    
    return @{ Detected = $false }
}

# Enhanced Frontend detection section for setup.ps1
# This replaces lines 458-476 in the original file

Write-Info "`n🔍 Detecting frontend framework..."

# Angular detection with subdirectory support
$angularResult = Find-AngularProject -RootPath $TargetRepository
if ($angularResult.Detected) {
    $detectedStack.Frontend = "Angular"
    $relativePath = $angularResult.RelativePath
    if ($relativePath -eq ".") {
        Write-Success "  ✓ Angular frontend detected in root directory"
    } else {
        Write-Success "  ✓ Angular frontend detected in '$relativePath' directory"
    }
    if ($angularResult.Version) {
        Write-Detail "    Version: $($angularResult.Version)"
    }
    Write-Detail "    Config: $($angularResult.ConfigFile)"
}
# Continue with other framework detection (React, Vue, etc.)
elseif (Test-Path (Join-Path $TargetRepository "package.json")) {
    $packageJson = Get-Content (Join-Path $TargetRepository "package.json") -Raw | ConvertFrom-Json
    if ($packageJson.dependencies) {
        if ($packageJson.dependencies.PSObject.Properties.Name -contains "react" -or 
            $packageJson.dependencies.PSObject.Properties.Name -contains "next") {
            $detectedStack.Frontend = "React"
            Write-Success "  ✓ React frontend detected"
        } elseif ($packageJson.dependencies.PSObject.Properties.Name -contains "vue") {
            $detectedStack.Frontend = "Vue"
            Write-Success "  ✓ Vue frontend detected"
        } elseif ($packageJson.dependencies.PSObject.Properties.Name -contains "svelte") {
            $detectedStack.Frontend = "Svelte"
            Write-Success "  ✓ Svelte frontend detected"
        }
    }
}

if (-not $detectedStack.Frontend) {
    Write-Host "  ℹ No frontend framework detected" -ForegroundColor Gray
    Write-Host "  💡 Tip: If you have a frontend in a subdirectory, it should now be detected" -ForegroundColor DarkGray
}