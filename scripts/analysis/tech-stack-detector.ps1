# Technology Stack Detector Script
# Used by init-claudify command

param(
    [string]$RepositoryPath = "."
)

$ErrorActionPreference = "Stop"

# Initialize detection results
$techStack = @{
    Backend = @{
        Language = $null
        Framework = $null
        Version = $null
    }
    Frontend = @{
        Framework = $null
        StateManagement = $null
        UILibrary = $null
    }
    Database = @()
    Authentication = $null
    Orchestration = $null
}

Write-Host "🔍 Detecting Technology Stack..." -ForegroundColor Cyan

# Backend Detection
Write-Host "`n📦 Backend Detection:" -ForegroundColor Yellow

# .NET Detection
$csprojFiles = Get-ChildItem -Path $RepositoryPath -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue
if ($csprojFiles) {
    $techStack.Backend.Language = "C#"
    
    # Check for ASP.NET Core
    $programCs = Get-ChildItem -Path $RepositoryPath -Filter "Program.cs" -Recurse | Select-Object -First 1
    if ($programCs) {
        $content = Get-Content $programCs.FullName -Raw
        if ($content -match "WebApplication\.CreateBuilder") {
            $techStack.Backend.Framework = "ASP.NET Core"
            
            # Detect version from .csproj
            $csprojContent = Get-Content $csprojFiles[0].FullName -Raw
            if ($csprojContent -match '<TargetFramework>net(\d+\.\d+)</TargetFramework>') {
                $techStack.Backend.Version = $matches[1]
            }
        }
    }
    Write-Host "  ✓ Detected: .NET ($($techStack.Backend.Framework) $($techStack.Backend.Version))" -ForegroundColor Green
}

# Node.js Detection
$packageJson = Get-ChildItem -Path $RepositoryPath -Filter "package.json" -Recurse | Where-Object { $_.DirectoryName -notmatch "node_modules" } | Select-Object -First 1
if ($packageJson -and -not $techStack.Backend.Language) {
    $packageContent = Get-Content $packageJson.FullName | ConvertFrom-Json
    
    if ($packageContent.dependencies.express) {
        $techStack.Backend.Language = "JavaScript/TypeScript"
        $techStack.Backend.Framework = "Express.js"
        $techStack.Backend.Version = $packageContent.dependencies.express
        Write-Host "  ✓ Detected: Node.js (Express.js)" -ForegroundColor Green
    }
}

# Frontend Detection
Write-Host "`n🎨 Frontend Detection:" -ForegroundColor Yellow

# Angular Detection
$angularJson = Get-ChildItem -Path $RepositoryPath -Filter "angular.json" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($angularJson) {
    $techStack.Frontend.Framework = "Angular"
    
    # Check package.json for version
    $frontendPackageJson = Get-ChildItem -Path (Split-Path $angularJson.FullName) -Filter "package.json" | Select-Object -First 1
    if ($frontendPackageJson) {
        $pkgContent = Get-Content $frontendPackageJson.FullName | ConvertFrom-Json
        if ($pkgContent.dependencies.'@angular/core') {
            $version = $pkgContent.dependencies.'@angular/core'
            $techStack.Frontend.Framework = "Angular $($version -replace '[^0-9.]', '')"
        }
        
        # Check for signals (Angular 16+)
        if ($version -match "1[6-9]|[2-9]\d") {
            $techStack.Frontend.StateManagement = "Signals"
        }
        
        # Check for Material
        if ($pkgContent.dependencies.'@angular/material') {
            $techStack.Frontend.UILibrary = "Angular Material"
        }
    }
    Write-Host "  ✓ Detected: $($techStack.Frontend.Framework) with $($techStack.Frontend.StateManagement)" -ForegroundColor Green
}

# React Detection
elseif ($packageJson) {
    $packageContent = Get-Content $packageJson.FullName | ConvertFrom-Json
    if ($packageContent.dependencies.react) {
        $techStack.Frontend.Framework = "React"
        
        # Check for Redux
        if ($packageContent.dependencies.redux -or $packageContent.dependencies.'@reduxjs/toolkit') {
            $techStack.Frontend.StateManagement = "Redux"
        }
        # Check for MobX
        elseif ($packageContent.dependencies.mobx) {
            $techStack.Frontend.StateManagement = "MobX"
        }
        
        # Check for Material-UI
        if ($packageContent.dependencies.'@mui/material') {
            $techStack.Frontend.UILibrary = "Material-UI"
        }
        
        Write-Host "  ✓ Detected: React with $($techStack.Frontend.StateManagement)" -ForegroundColor Green
    }
}

# Database Detection
Write-Host "`n💾 Database Detection:" -ForegroundColor Yellow

# Search for connection strings
$configFiles = @(
    "appsettings.json",
    "appsettings.Development.json",
    ".env",
    "config.json"
)

foreach ($configFile in $configFiles) {
    $configs = Get-ChildItem -Path $RepositoryPath -Filter $configFile -Recurse -ErrorAction SilentlyContinue
    foreach ($config in $configs) {
        $content = Get-Content $config.FullName -Raw
        
        # SQL Server
        if ($content -match "Server=.*Initial Catalog=|Data Source=.*Database=") {
            $techStack.Database += "SQL Server"
            Write-Host "  ✓ Detected: SQL Server" -ForegroundColor Green
        }
        
        # PostgreSQL
        if ($content -match "Host=.*Database=.*Username=|postgresql://") {
            $techStack.Database += "PostgreSQL"
            Write-Host "  ✓ Detected: PostgreSQL" -ForegroundColor Green
        }
        
        # MongoDB
        if ($content -match "mongodb://|mongodb\+srv://") {
            $techStack.Database += "MongoDB"
            Write-Host "  ✓ Detected: MongoDB" -ForegroundColor Green
        }
    }
}

# Entity Framework Detection
$efReferences = Get-ChildItem -Path $RepositoryPath -Filter "*.csproj" -Recurse | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    if ($content -match "Microsoft\.EntityFrameworkCore") {
        return $true
    }
}
if ($efReferences) {
    $techStack.Database += "Entity Framework Core"
    Write-Host "  ✓ Detected: Entity Framework Core" -ForegroundColor Green
}

# Authentication Detection
Write-Host "`n🔐 Authentication Detection:" -ForegroundColor Yellow

# Auth0
$authPatterns = @(
    "auth0",
    "Auth0",
    "AUTH0_DOMAIN"
)

foreach ($pattern in $authPatterns) {
    $authFiles = Get-ChildItem -Path $RepositoryPath -Include "*.cs", "*.ts", "*.js", "*.json", ".env" -Recurse -ErrorAction SilentlyContinue | 
        Select-String -Pattern $pattern -List | 
        Select-Object -First 1
    
    if ($authFiles) {
        $techStack.Authentication = "Auth0"
        Write-Host "  ✓ Detected: Auth0" -ForegroundColor Green
        break
    }
}

# Azure AD
if (-not $techStack.Authentication) {
    $azurePatterns = @(
        "Microsoft\.Identity",
        "AzureAd",
        "AZURE_AD"
    )
    
    foreach ($pattern in $azurePatterns) {
        $azureFiles = Get-ChildItem -Path $RepositoryPath -Include "*.cs", "*.json" -Recurse -ErrorAction SilentlyContinue | 
            Select-String -Pattern $pattern -List | 
            Select-Object -First 1
        
        if ($azureFiles) {
            $techStack.Authentication = "Azure AD"
            Write-Host "  ✓ Detected: Azure AD" -ForegroundColor Green
            break
        }
    }
}

# Orchestration Detection
Write-Host "`n🚀 Orchestration Detection:" -ForegroundColor Yellow

# Docker
if (Test-Path (Join-Path $RepositoryPath "Dockerfile") -or Test-Path (Join-Path $RepositoryPath "docker-compose.yml")) {
    $techStack.Orchestration = "Docker"
    Write-Host "  ✓ Detected: Docker" -ForegroundColor Green
}

# Aspire
$aspireHost = Get-ChildItem -Path $RepositoryPath -Filter "*AppHost*" -Directory -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
if ($aspireHost) {
    $techStack.Orchestration = "Aspire"
    Write-Host "  ✓ Detected: .NET Aspire" -ForegroundColor Green
}

# Kubernetes
if (Test-Path (Join-Path $RepositoryPath "k8s") -or (Get-ChildItem -Path $RepositoryPath -Filter "*.yaml" -Recurse | Select-String -Pattern "apiVersion: apps/v1" -List)) {
    $techStack.Orchestration = if ($techStack.Orchestration) { "$($techStack.Orchestration) + Kubernetes" } else { "Kubernetes" }
    Write-Host "  ✓ Detected: Kubernetes" -ForegroundColor Green
}

# Output results as JSON
$techStack | ConvertTo-Json -Depth 3