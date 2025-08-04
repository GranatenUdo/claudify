# Standalone test for Angular detection
# Extract the function from setup.ps1 and test it

Write-Host "Angular Detection Test Suite (Standalone)" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Define the detection function (extracted from setup.ps1)
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

# Create test directory
$testRoot = Join-Path $PSScriptRoot "test-projects"
if (Test-Path $testRoot) {
    Remove-Item $testRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $testRoot -Force | Out-Null

# Test Case 1: Angular in ClientApp (ASP.NET Core standard)
Write-Host "Creating Test 1: ASP.NET Core + Angular (ClientApp structure)..." -ForegroundColor Yellow
$test1Path = Join-Path $testRoot "aspnet-angular"
New-Item -ItemType Directory -Path $test1Path -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $test1Path "ClientApp") -Force | Out-Null

# Create Angular project files
$angularPackageJson = @{
    name = "web-app"
    version = "1.0.0"
    dependencies = @{
        "@angular/core" = "^17.0.0"
        "@angular/common" = "^17.0.0"
        "@angular/platform-browser" = "^17.0.0"
    }
    devDependencies = @{
        "@angular/cli" = "^17.0.0"
    }
}
$angularPackageJson | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test1Path "ClientApp\package.json")

$angularConfig = @{
    '$schema' = "./node_modules/@angular/cli/lib/config/schema.json"
    version = 1
    projects = @{
        app = @{
            projectType = "application"
            root = ""
            sourceRoot = "src"
        }
    }
}
$angularConfig | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test1Path "ClientApp\angular.json")

# Test Case 2: Angular in frontend directory
Write-Host "Creating Test 2: Separate frontend directory structure..." -ForegroundColor Yellow
$test2Path = Join-Path $testRoot "separate-frontend"
New-Item -ItemType Directory -Path $test2Path -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $test2Path "frontend") -Force | Out-Null

$frontendPackageJson = @{
    name = "frontend-app"
    version = "1.0.0"
    dependencies = @{
        "@angular/core" = "^16.2.0"
        "@angular/router" = "^16.2.0"
    }
}
$frontendPackageJson | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test2Path "frontend\package.json")

# Test Case 3: Angular in root
Write-Host "Creating Test 3: Angular in root directory..." -ForegroundColor Yellow
$test3Path = Join-Path $testRoot "angular-root"
New-Item -ItemType Directory -Path $test3Path -Force | Out-Null

$rootPackageJson = @{
    name = "angular-app"
    version = "1.0.0"
    dependencies = @{
        "@angular/core" = "^17.1.0"
        "@angular/animations" = "^17.1.0"
    }
    devDependencies = @{
        "@angular/cli" = "^17.1.0"
    }
}
$rootPackageJson | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test3Path "package.json")

$rootAngularConfig = @{
    '$schema' = "./node_modules/@angular/cli/lib/config/schema.json"
    version = 1
    projects = @{
        app = @{
            projectType = "application"
        }
    }
}
$rootAngularConfig | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test3Path "angular.json")

# Test Case 4: React project
Write-Host "Creating Test 4: React project (negative test)..." -ForegroundColor Yellow
$test4Path = Join-Path $testRoot "react-app"
New-Item -ItemType Directory -Path $test4Path -Force | Out-Null

$reactPackageJson = @{
    name = "react-app"
    version = "1.0.0"
    dependencies = @{
        react = "^18.2.0"
        "react-dom" = "^18.2.0"
    }
}
$reactPackageJson | ConvertTo-Json -Depth 10 | Set-Content (Join-Path $test4Path "package.json")

# Test Case 5: No frontend
Write-Host "Creating Test 5: Backend only (no frontend)..." -ForegroundColor Yellow
$test5Path = Join-Path $testRoot "backend-only"
New-Item -ItemType Directory -Path $test5Path -Force | Out-Null
"<Project></Project>" | Set-Content (Join-Path $test5Path "Backend.csproj")

Write-Host ""
Write-Host "Running detection tests..." -ForegroundColor Green
Write-Host "==========================" -ForegroundColor Green

# Test function
function Test-Detection {
    param(
        [string]$TestPath,
        [string]$TestName,
        [string]$ExpectedResult,
        [string]$ExpectedLocation = ""
    )
    
    Write-Host ""
    Write-Host "Testing: $TestName" -ForegroundColor Cyan
    
    $result = Find-FrontendProject -RootPath $TestPath
    
    if ($ExpectedResult -eq "None") {
        if ($null -eq $result) {
            Write-Host "✅ PASS: No frontend detected (as expected)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ FAIL: Expected no frontend, but detected $($result.Type)" -ForegroundColor Red
            Write-Host "   Details: $($result | ConvertTo-Json -Compress)" -ForegroundColor Gray
            return $false
        }
    } else {
        if ($null -eq $result) {
            Write-Host "❌ FAIL: Expected $ExpectedResult but nothing detected" -ForegroundColor Red
            return $false
        } elseif ($result.Type -ne $ExpectedResult) {
            Write-Host "❌ FAIL: Expected $ExpectedResult but detected $($result.Type)" -ForegroundColor Red
            Write-Host "   Details: $($result | ConvertTo-Json -Compress)" -ForegroundColor Gray
            return $false
        } else {
            Write-Host "✅ PASS: $($result.Type) detected correctly" -ForegroundColor Green
            if ($ExpectedLocation -and $result.RelativePath -ne $ExpectedLocation) {
                Write-Host "⚠️ Location mismatch: Expected '$ExpectedLocation' but found in '$($result.RelativePath)'" -ForegroundColor Yellow
                return $false
            } else {
                Write-Host "   Location: $($result.RelativePath)" -ForegroundColor Gray
                if ($result.Version) {
                    Write-Host "   Version: $($result.Version)" -ForegroundColor Gray
                }
                Write-Host "   Config: $($result.ConfigFile)" -ForegroundColor Gray
            }
            return $true
        }
    }
}

# Run tests
$results = @()
$results += Test-Detection -TestPath $test1Path -TestName "ASP.NET Core + Angular" -ExpectedResult "Angular" -ExpectedLocation "ClientApp"
$results += Test-Detection -TestPath $test2Path -TestName "Separate frontend directory" -ExpectedResult "Angular" -ExpectedLocation "frontend"
$results += Test-Detection -TestPath $test3Path -TestName "Angular in root" -ExpectedResult "Angular" -ExpectedLocation "."
$results += Test-Detection -TestPath $test4Path -TestName "React project" -ExpectedResult "React" -ExpectedLocation "."
$results += Test-Detection -TestPath $test5Path -TestName "Backend only" -ExpectedResult "None"

# Summary
Write-Host ""
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════" -ForegroundColor Cyan

$passed = ($results | Where-Object { $_ -eq $true }).Count
$total = $results.Count
$successRate = [math]::Round(($passed / $total) * 100, 1)

Write-Host "Passed: $passed / $total ($successRate%)" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })

if ($passed -eq $total) {
    Write-Host ""
    Write-Host "🎉 All tests passed! Angular detection is working correctly." -ForegroundColor Green
    Write-Host "✅ The fix successfully detects Angular in subdirectories." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️ Some tests failed. Review the detection logic." -ForegroundColor Yellow
}

# Cleanup
Write-Host ""
Write-Host "Cleaning up test files..." -ForegroundColor Gray
Remove-Item $testRoot -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Test complete!" -ForegroundColor Green