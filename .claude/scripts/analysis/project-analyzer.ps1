# Comprehensive Project Analyzer - Gathers data for documentation templates
# Analyzes tech stack, patterns, architecture, and more

param(
    [string]$ProjectPath = ".",
    [switch]$Force,
    [switch]$Verbose
)

Write-Host "🔍 Claudify Project Analyzer" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan

$cachePath = Join-Path $ProjectPath ".claude/analysis-cache.json"

# Check cache
if ((Test-Path $cachePath) -and -not $Force) {
    $cache = Get-Content $cachePath -Raw | ConvertFrom-Json
    $cacheAge = (Get-Date) - [DateTime]$cache.AnalysisDate
    
    if ($cacheAge.TotalHours -lt 24) {
        Write-Host "✓ Using cached analysis (age: $([int]$cacheAge.TotalHours) hours)" -ForegroundColor Green
        Write-Host "  Use -Force to refresh" -ForegroundColor Gray
        return
    }
}

Write-Host "`nAnalyzing project structure..." -ForegroundColor Yellow

# Initialize analysis structure
$analysis = @{
    AnalysisDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    ProjectName = Split-Path $ProjectPath -Leaf
    ProjectPath = (Resolve-Path $ProjectPath).Path
    Description = ""
    TechStack = @{
        Backend = @{
            Primary = ""
            Language = ""
            Framework = ""
            Version = ""
            Libraries = @()
        }
        Frontend = @{
            Primary = ""
            Framework = ""
            Version = ""
            Libraries = @()
        }
        Database = @{
            Primary = ""
            ORM = ""
            Cache = ""
        }
    }
    Patterns = @{
        MultiTenant = $false
        TenantField = "OrganizationId"
        RepositoryPattern = $false
        ResultPattern = $false
        CQRS = $false
        EventDriven = $false
    }
    Architecture = @{
        Style = ""
        Components = @()
        Layers = @()
    }
    API = @{
        Style = "REST"
        Versioning = ""
        Controllers = @()
    }
    Security = @{
        AuthMethod = ""
        AuthProvider = ""
        Encryption = @()
    }
    Testing = @{
        Framework = ""
        Coverage = 0
        Types = @()
    }
    Documentation = @{
        HasReadme = $false
        HasApiDocs = $false
        HasArchitectureDocs = $false
    }
}

# Helper functions
function Get-ProjectFileContent {
    param([string]$Pattern, [int]$MaxFiles = 10)
    
    Get-ChildItem -Path $ProjectPath -Include $Pattern -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "node_modules|bin|obj|dist|build|\.git" } |
        Select-Object -First $MaxFiles |
        ForEach-Object { 
            @{
                Path = $_.FullName
                Content = Get-Content $_.FullName -Raw -ErrorAction SilentlyContinue
            }
        }
}

# Detect Backend Technology
Write-Host "  • Detecting backend technology..." -ForegroundColor Gray

# .NET Detection
$csprojFiles = Get-ChildItem -Path $ProjectPath -Include "*.csproj" -Recurse -ErrorAction SilentlyContinue
if ($csprojFiles) {
    $analysis.TechStack.Backend.Primary = ".NET"
    $analysis.TechStack.Backend.Language = "C#"
    
    # Get .NET version
    $csproj = [xml](Get-Content $csprojFiles[0].FullName)
    $targetFramework = $csproj.Project.PropertyGroup.TargetFramework
    if ($targetFramework) {
        $analysis.TechStack.Backend.Version = $targetFramework
        if ($targetFramework -match "net\d") {
            $analysis.TechStack.Backend.Framework = ".NET Core / .NET 5+"
        }
    }
    
    # Check for common libraries
    $packages = $csproj.Project.ItemGroup.PackageReference.Include
    if ($packages -contains "Microsoft.AspNetCore.App") {
        $analysis.TechStack.Backend.Framework = "ASP.NET Core"
    }
    if ($packages -contains "Microsoft.EntityFrameworkCore") {
        $analysis.TechStack.Database.ORM = "Entity Framework Core"
    }
    
    Write-Host "    ✓ Detected .NET $targetFramework" -ForegroundColor Green
}

# Node.js Detection
elseif (Test-Path (Join-Path $ProjectPath "package.json")) {
    $packageJson = Get-Content (Join-Path $ProjectPath "package.json") -Raw | ConvertFrom-Json
    $analysis.TechStack.Backend.Primary = "Node.js"
    $analysis.TechStack.Backend.Language = "JavaScript/TypeScript"
    
    if ($packageJson.dependencies.express) {
        $analysis.TechStack.Backend.Framework = "Express.js"
    }
    elseif ($packageJson.dependencies.'@nestjs/core') {
        $analysis.TechStack.Backend.Framework = "NestJS"
    }
    elseif ($packageJson.dependencies.fastify) {
        $analysis.TechStack.Backend.Framework = "Fastify"
    }
    
    Write-Host "    ✓ Detected Node.js with $($analysis.TechStack.Backend.Framework)" -ForegroundColor Green
}

# Python Detection
elseif (Test-Path (Join-Path $ProjectPath "requirements.txt")) {
    $analysis.TechStack.Backend.Primary = "Python"
    $analysis.TechStack.Backend.Language = "Python"
    
    $requirements = Get-Content (Join-Path $ProjectPath "requirements.txt") -ErrorAction SilentlyContinue
    if ($requirements -match "django") {
        $analysis.TechStack.Backend.Framework = "Django"
    }
    elseif ($requirements -match "flask") {
        $analysis.TechStack.Backend.Framework = "Flask"
    }
    elseif ($requirements -match "fastapi") {
        $analysis.TechStack.Backend.Framework = "FastAPI"
    }
    
    Write-Host "    ✓ Detected Python with $($analysis.TechStack.Backend.Framework)" -ForegroundColor Green
}

# Detect Frontend Technology
Write-Host "  • Detecting frontend technology..." -ForegroundColor Gray

if (Test-Path (Join-Path $ProjectPath "package.json")) {
    $packageJson = Get-Content (Join-Path $ProjectPath "package.json") -Raw | ConvertFrom-Json
    
    if ($packageJson.dependencies.'@angular/core') {
        $analysis.TechStack.Frontend.Primary = "Angular"
        $analysis.TechStack.Frontend.Framework = "Angular"
        $analysis.TechStack.Frontend.Version = $packageJson.dependencies.'@angular/core'
        Write-Host "    ✓ Detected Angular $($analysis.TechStack.Frontend.Version)" -ForegroundColor Green
    }
    elseif ($packageJson.dependencies.react) {
        $analysis.TechStack.Frontend.Primary = "React"
        $analysis.TechStack.Frontend.Framework = "React"
        $analysis.TechStack.Frontend.Version = $packageJson.dependencies.react
        Write-Host "    ✓ Detected React $($analysis.TechStack.Frontend.Version)" -ForegroundColor Green
    }
    elseif ($packageJson.dependencies.vue) {
        $analysis.TechStack.Frontend.Primary = "Vue"
        $analysis.TechStack.Frontend.Framework = "Vue.js"
        $analysis.TechStack.Frontend.Version = $packageJson.dependencies.vue
        Write-Host "    ✓ Detected Vue $($analysis.TechStack.Frontend.Version)" -ForegroundColor Green
    }
}

# Detect Patterns
Write-Host "  • Analyzing code patterns..." -ForegroundColor Gray

# Multi-tenancy detection
$sourceFiles = Get-ProjectFileContent -Pattern "*.cs", "*.ts", "*.js" -MaxFiles 50
$tenantFieldCount = 0
$tenantFields = @("OrganizationId", "TenantId", "CompanyId", "CustomerId")

foreach ($file in $sourceFiles) {
    foreach ($field in $tenantFields) {
        if ($file.Content -match $field) {
            $tenantFieldCount++
            $analysis.Patterns.TenantField = $field
            break
        }
    }
}

if ($tenantFieldCount -gt 5) {
    $analysis.Patterns.MultiTenant = $true
    Write-Host "    ✓ Detected multi-tenant pattern (field: $($analysis.Patterns.TenantField))" -ForegroundColor Green
}

# Repository pattern detection
$repoCount = ($sourceFiles | Where-Object { $_.Content -match "Repository|IRepository" }).Count
if ($repoCount -gt 3) {
    $analysis.Patterns.RepositoryPattern = $true
    Write-Host "    ✓ Detected repository pattern" -ForegroundColor Green
}

# Result pattern detection
$resultCount = ($sourceFiles | Where-Object { $_.Content -match "Result<|Result\[" }).Count
if ($resultCount -gt 3) {
    $analysis.Patterns.ResultPattern = $true
    Write-Host "    ✓ Detected Result<T> pattern" -ForegroundColor Green
}

# API Analysis
Write-Host "  • Analyzing API structure..." -ForegroundColor Gray

if ($analysis.TechStack.Backend.Primary -eq ".NET") {
    $controllers = Get-ChildItem -Path $ProjectPath -Include "*Controller.cs" -Recurse -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "bin|obj" }
    
    foreach ($controller in $controllers | Select-Object -First 10) {
        $content = Get-Content $controller.FullName -Raw
        $className = [regex]::Match($content, 'class\s+(\w+)Controller').Groups[1].Value
        
        if ($className) {
            $endpoints = [regex]::Matches($content, '\[(HttpGet|HttpPost|HttpPut|HttpDelete|HttpPatch)\]')
            
            $analysis.API.Controllers += @{
                Name = $className
                File = $controller.Name
                EndpointCount = $endpoints.Count
            }
        }
    }
    
    Write-Host "    ✓ Found $($analysis.API.Controllers.Count) API controllers" -ForegroundColor Green
}

# Security Analysis
Write-Host "  • Analyzing security configuration..." -ForegroundColor Gray

# Check for Auth0
if ($sourceFiles | Where-Object { $_.Content -match "Auth0|auth0" }) {
    $analysis.Security.AuthMethod = "JWT"
    $analysis.Security.AuthProvider = "Auth0"
    Write-Host "    ✓ Detected Auth0 authentication" -ForegroundColor Green
}
# Check for Identity
elseif ($sourceFiles | Where-Object { $_.Content -match "Microsoft\.AspNetCore\.Identity" }) {
    $analysis.Security.AuthMethod = "Cookie/JWT"
    $analysis.Security.AuthProvider = "ASP.NET Identity"
    Write-Host "    ✓ Detected ASP.NET Identity" -ForegroundColor Green
}

# Documentation Check
Write-Host "  • Checking documentation..." -ForegroundColor Gray

if (Test-Path (Join-Path $ProjectPath "README.md")) {
    $analysis.Documentation.HasReadme = $true
    
    # Try to extract description
    $readme = Get-Content (Join-Path $ProjectPath "README.md") -Raw -ErrorAction SilentlyContinue
    if ($readme) {
        $firstParagraph = ($readme -split "`n`n")[0]
        $analysis.Description = $firstParagraph -replace "^#.*`n", "" -replace "`n", " " | 
            ForEach-Object { $_.Trim() } |
            Where-Object { $_.Length -gt 10 } |
            Select-Object -First 1
    }
}

# Set project name from various sources
if (Test-Path (Join-Path $ProjectPath ".git/config")) {
    $gitConfig = Get-Content (Join-Path $ProjectPath ".git/config") -Raw
    if ($gitConfig -match 'url = .*[/:]([^/]+)\.git') {
        $analysis.ProjectName = $Matches[1]
    }
}
elseif ($csprojFiles) {
    $analysis.ProjectName = [System.IO.Path]::GetFileNameWithoutExtension($csprojFiles[0].Name)
}

# Architecture style inference
if ($analysis.API.Controllers.Count -gt 0) {
    if ($analysis.API.Controllers.Count -gt 20) {
        $analysis.Architecture.Style = "Microservices"
    } else {
        $analysis.Architecture.Style = "Monolithic"
    }
}

# Save analysis
Write-Host "`n💾 Saving analysis..." -ForegroundColor Yellow

# Ensure .claude directory exists
$claudeDir = Join-Path $ProjectPath ".claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir -Force | Out-Null
}

$analysis | ConvertTo-Json -Depth 10 | Out-File -FilePath $cachePath -Encoding UTF8

# Summary
Write-Host "`n✅ Analysis Complete!" -ForegroundColor Green
Write-Host "===================" -ForegroundColor Green

Write-Host "`nProject: $($analysis.ProjectName)" -ForegroundColor White
if ($analysis.Description) {
    Write-Host "Description: $($analysis.Description)" -ForegroundColor Gray
}

Write-Host "`nTech Stack:" -ForegroundColor Yellow
Write-Host "  Backend: $($analysis.TechStack.Backend.Primary) ($($analysis.TechStack.Backend.Framework))" -ForegroundColor White
if ($analysis.TechStack.Frontend.Primary) {
    Write-Host "  Frontend: $($analysis.TechStack.Frontend.Primary) $($analysis.TechStack.Frontend.Version)" -ForegroundColor White
}
if ($analysis.TechStack.Database.ORM) {
    Write-Host "  Database: $($analysis.TechStack.Database.ORM)" -ForegroundColor White
}

Write-Host "`nPatterns Detected:" -ForegroundColor Yellow
if ($analysis.Patterns.MultiTenant) {
    Write-Host "  ✓ Multi-tenant (field: $($analysis.Patterns.TenantField))" -ForegroundColor Green
}
if ($analysis.Patterns.RepositoryPattern) {
    Write-Host "  ✓ Repository pattern" -ForegroundColor Green
}
if ($analysis.Patterns.ResultPattern) {
    Write-Host "  ✓ Result<T> pattern" -ForegroundColor Green
}

Write-Host "`nAnalysis cached to: $cachePath" -ForegroundColor Gray
Write-Host "Use this data with documentation templates for intelligent doc generation!" -ForegroundColor Cyan

# Return analysis for pipeline use
return $analysis