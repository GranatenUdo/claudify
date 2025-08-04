# Test script for Angular detection in various project structures
# This creates test project structures and validates the detection

Write-Host "Angular Detection Test Suite" -ForegroundColor Cyan
Write-Host "=============================" -ForegroundColor Cyan
Write-Host ""

# Create test directory
$testRoot = Join-Path $PSScriptRoot "test-projects"
if (Test-Path $testRoot) {
    Remove-Item $testRoot -Recurse -Force
}
New-Item -ItemType Directory -Path $testRoot -Force | Out-Null

# Test Case 1: Angular in ClientApp (ASP.NET Core standard)
Write-Host "Test 1: ASP.NET Core + Angular (ClientApp structure)" -ForegroundColor Yellow
$test1Path = Join-Path $testRoot "aspnet-angular"
New-Item -ItemType Directory -Path $test1Path -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $test1Path "ClientApp") -Force | Out-Null

# Create backend indicator
@"
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
</Project>
"@ | Set-Content (Join-Path $test1Path "WebApp.csproj")

# Create Angular project files
@"
{
  "name": "web-app",
  "version": "1.0.0",
  "dependencies": {
    "@angular/core": "^17.0.0",
    "@angular/common": "^17.0.0",
    "@angular/platform-browser": "^17.0.0"
  },
  "devDependencies": {
    "@angular/cli": "^17.0.0"
  }
}
"@ | Set-Content (Join-Path $test1Path "ClientApp\package.json")

@"
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "projects": {
    "app": {
      "projectType": "application",
      "root": "",
      "sourceRoot": "src"
    }
  }
}
"@ | Set-Content (Join-Path $test1Path "ClientApp\angular.json")

# Test Case 2: Angular in frontend directory
Write-Host "Test 2: Separate frontend directory structure" -ForegroundColor Yellow
$test2Path = Join-Path $testRoot "separate-frontend"
New-Item -ItemType Directory -Path $test2Path -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $test2Path "backend") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $test2Path "frontend") -Force | Out-Null

# Create backend
@"
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
</Project>
"@ | Set-Content (Join-Path $test2Path "backend\Api.csproj")

# Create Angular in frontend
@"
{
  "name": "frontend-app",
  "version": "1.0.0",
  "dependencies": {
    "@angular/core": "^16.2.0",
    "@angular/router": "^16.2.0"
  }
}
"@ | Set-Content (Join-Path $test2Path "frontend\package.json")

# Test Case 3: Angular in root (simple structure)
Write-Host "Test 3: Angular in root directory" -ForegroundColor Yellow
$test3Path = Join-Path $testRoot "angular-root"
New-Item -ItemType Directory -Path $test3Path -Force | Out-Null

@"
{
  "name": "angular-app",
  "version": "1.0.0",
  "dependencies": {
    "@angular/core": "^17.1.0",
    "@angular/animations": "^17.1.0"
  },
  "devDependencies": {
    "@angular/cli": "^17.1.0"
  }
}
"@ | Set-Content (Join-Path $test3Path "package.json")

@"
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "version": 1,
  "projects": {
    "app": {
      "projectType": "application"
    }
  }
}
"@ | Set-Content (Join-Path $test3Path "angular.json")

# Test Case 4: React project (should detect React, not Angular)
Write-Host "Test 4: React project (negative test)" -ForegroundColor Yellow
$test4Path = Join-Path $testRoot "react-app"
New-Item -ItemType Directory -Path $test4Path -Force | Out-Null

@"
{
  "name": "react-app",
  "version": "1.0.0",
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  }
}
"@ | Set-Content (Join-Path $test4Path "package.json")

# Test Case 5: No frontend (should detect nothing)
Write-Host "Test 5: Backend only (no frontend)" -ForegroundColor Yellow
$test5Path = Join-Path $testRoot "backend-only"
New-Item -ItemType Directory -Path $test5Path -Force | Out-Null

@"
<Project Sdk="Microsoft.NET.Sdk.Web">
  <PropertyGroup>
    <TargetFramework>net8.0</TargetFramework>
  </PropertyGroup>
</Project>
"@ | Set-Content (Join-Path $test5Path "BackendOnly.csproj")

Write-Host ""
Write-Host "Running detection tests..." -ForegroundColor Green
Write-Host "==========================" -ForegroundColor Green

# Load the enhanced detection function from setup.ps1
. (Join-Path $PSScriptRoot "setup.ps1") -TargetRepository "." -SkipInstall

# Test function
function Test-AngularDetection {
    param(
        [string]$TestPath,
        [string]$TestName,
        [string]$ExpectedResult,
        [string]$ExpectedLocation = ""
    )
    
    Write-Host ""
    Write-Host "Testing: $TestName" -ForegroundColor Cyan
    Write-Host "Path: $TestPath" -ForegroundColor Gray
    
    $result = Find-FrontendProject -RootPath $TestPath
    
    if ($ExpectedResult -eq "None") {
        if ($null -eq $result) {
            Write-Host "✅ PASS: No frontend detected (as expected)" -ForegroundColor Green
            return $true
        } else {
            Write-Host "❌ FAIL: Expected no frontend, but detected $($result.Type)" -ForegroundColor Red
            return $false
        }
    } else {
        if ($null -eq $result) {
            Write-Host "❌ FAIL: Expected $ExpectedResult but nothing detected" -ForegroundColor Red
            return $false
        } elseif ($result.Type -ne $ExpectedResult) {
            Write-Host "❌ FAIL: Expected $ExpectedResult but detected $($result.Type)" -ForegroundColor Red
            return $false
        } else {
            Write-Host "✅ PASS: $($result.Type) detected correctly" -ForegroundColor Green
            if ($ExpectedLocation -and $result.RelativePath -ne $ExpectedLocation) {
                Write-Host "⚠️ WARNING: Expected in '$ExpectedLocation' but found in '$($result.RelativePath)'" -ForegroundColor Yellow
            } else {
                Write-Host "   Location: $($result.RelativePath)" -ForegroundColor Gray
                if ($result.Version) {
                    Write-Host "   Version: $($result.Version)" -ForegroundColor Gray
                }
            }
            return $true
        }
    }
}

# Run tests
$results = @()
$results += Test-AngularDetection -TestPath $test1Path -TestName "ASP.NET Core + Angular" -ExpectedResult "Angular" -ExpectedLocation "ClientApp"
$results += Test-AngularDetection -TestPath $test2Path -TestName "Separate frontend directory" -ExpectedResult "Angular" -ExpectedLocation "frontend"
$results += Test-AngularDetection -TestPath $test3Path -TestName "Angular in root" -ExpectedResult "Angular" -ExpectedLocation "."
$results += Test-AngularDetection -TestPath $test4Path -TestName "React project" -ExpectedResult "React" -ExpectedLocation "."
$results += Test-AngularDetection -TestPath $test5Path -TestName "Backend only" -ExpectedResult "None"

# Summary
Write-Host ""
Write-Host "Test Summary" -ForegroundColor Cyan
Write-Host "============" -ForegroundColor Cyan

$passed = ($results | Where-Object { $_ -eq $true }).Count
$total = $results.Count
$successRate = [math]::Round(($passed / $total) * 100, 1)

Write-Host "Passed: $passed / $total ($successRate%)" -ForegroundColor $(if ($passed -eq $total) { "Green" } else { "Yellow" })

if ($passed -eq $total) {
    Write-Host ""
    Write-Host "🎉 All tests passed! Angular detection is working correctly." -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "⚠️ Some tests failed. Review the detection logic." -ForegroundColor Yellow
}

# Cleanup
Write-Host ""
Write-Host "Cleaning up test files..." -ForegroundColor Gray
Remove-Item $testRoot -Recurse -Force -ErrorAction SilentlyContinue

Write-Host "Test complete!" -ForegroundColor Green