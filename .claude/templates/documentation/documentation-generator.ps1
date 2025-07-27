# Documentation Generator - Uses templates to create project-specific documentation
# This script analyzes your project and generates comprehensive documentation

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectPath = ".",
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("api", "architecture", "development", "troubleshooting", "all")]
    [string]$DocumentType = "all",
    
    [Parameter(Mandatory=$false)]
    [string]$OutputPath = "./docs/generated",
    
    [switch]$Interactive,
    [switch]$IncludeDrafts,
    [switch]$Verbose
)

Write-Host "📚 Claudify Documentation Generator" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Load the project analysis data
$analysisPath = Join-Path $ProjectPath ".claude/analysis-cache.json"
$projectAnalysis = $null

if (Test-Path $analysisPath) {
    $projectAnalysis = Get-Content $analysisPath -Raw | ConvertFrom-Json
    Write-Host "✓ Loaded cached project analysis" -ForegroundColor Green
} else {
    Write-Host "⚠️  No project analysis found. Running analysis..." -ForegroundColor Yellow
    # Here we would call the analyzer script
    & "$PSScriptRoot/../../scripts/analysis/project-analyzer.ps1" -ProjectPath $ProjectPath
    if (Test-Path $analysisPath) {
        $projectAnalysis = Get-Content $analysisPath -Raw | ConvertFrom-Json
    }
}

if (-not $projectAnalysis) {
    Write-Error "Failed to analyze project. Please ensure the project exists at: $ProjectPath"
    exit 1
}

# Create output directory
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}

# Template variable mappings
$globalVariables = @{
    PROJECT_NAME = $projectAnalysis.ProjectName
    PROJECT_DESCRIPTION = $projectAnalysis.Description
    TIMESTAMP = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    PROJECT_ROOT = $ProjectPath
    
    # Tech stack
    BACKEND_TECH = $projectAnalysis.TechStack.Backend.Primary
    FRONTEND_TECH = $projectAnalysis.TechStack.Frontend.Primary
    PRIMARY_DB = $projectAnalysis.TechStack.Database.Primary
    CACHE_TECH = $projectAnalysis.TechStack.Cache
    
    # Architecture patterns
    MULTI_TENANT = $projectAnalysis.Patterns.MultiTenant
    TENANT_FIELD = $projectAnalysis.Patterns.TenantField
    REPOSITORY_PATTERN = $projectAnalysis.Patterns.RepositoryPattern
    RESULT_PATTERN = $projectAnalysis.Patterns.ResultPattern
    
    # Auth
    AUTH_METHOD = $projectAnalysis.Security.AuthMethod
    AUTH_PROVIDER = $projectAnalysis.Security.AuthProvider
}

# Function to process template variables
function Process-Template {
    param(
        [string]$TemplateContent,
        [hashtable]$Variables
    )
    
    $processed = $TemplateContent
    
    # Simple variable replacement
    foreach ($key in $Variables.Keys) {
        $value = $Variables[$key]
        if ($null -eq $value) { $value = "Not specified" }
        $processed = $processed -replace "\`${$key}", $value
    }
    
    # Process conditionals
    $processed = Process-Conditionals -Content $processed -Variables $Variables
    
    # Process loops
    $processed = Process-Loops -Content $processed -Variables $Variables
    
    return $processed
}

# Process IF conditionals
function Process-Conditionals {
    param(
        [string]$Content,
        [hashtable]$Variables
    )
    
    $pattern = '\${IF_([^}]+)}([\s\S]*?)\${END_IF}'
    
    while ($Content -match $pattern) {
        $condition = $Matches[1]
        $conditionalContent = $Matches[2]
        $fullMatch = $Matches[0]
        
        $includeContent = $false
        
        # Evaluate condition
        if ($Variables.ContainsKey($condition)) {
            $value = $Variables[$condition]
            if ($value -eq $true -or $value -eq "true" -or 
                ($value -is [string] -and $value.Length -gt 0) -or
                ($value -is [array] -and $value.Count -gt 0)) {
                $includeContent = $true
            }
        }
        
        if ($includeContent) {
            $Content = $Content.Replace($fullMatch, $conditionalContent)
        } else {
            $Content = $Content.Replace($fullMatch, "")
        }
    }
    
    return $Content
}

# Process FOREACH loops
function Process-Loops {
    param(
        [string]$Content,
        [hashtable]$Variables
    )
    
    $pattern = '\${FOREACH_([^}]+)}([\s\S]*?)\${END_FOREACH}'
    
    while ($Content -match $pattern) {
        $loopVar = $Matches[1]
        $loopContent = $Matches[2]
        $fullMatch = $Matches[0]
        
        $output = ""
        
        if ($Variables.ContainsKey($loopVar + "S")) {
            $items = $Variables[$loopVar + "S"]
            if ($items -is [array]) {
                foreach ($item in $items) {
                    $itemContent = $loopContent
                    foreach ($prop in $item.PSObject.Properties) {
                        $itemContent = $itemContent -replace "\`${$($prop.Name)}", $prop.Value
                    }
                    $output += $itemContent
                }
            }
        }
        
        $Content = $Content.Replace($fullMatch, $output)
    }
    
    return $Content
}

# Generate specific documentation type
function Generate-Documentation {
    param(
        [string]$Type,
        [string]$TemplateName,
        [hashtable]$ExtraVariables = @{}
    )
    
    Write-Host "`n📄 Generating $Type documentation..." -ForegroundColor Yellow
    
    $templatePath = Join-Path $PSScriptRoot "$TemplateName.template"
    if (-not (Test-Path $templatePath)) {
        Write-Warning "Template not found: $templatePath"
        return
    }
    
    $template = Get-Content $templatePath -Raw
    
    # Merge variables
    $variables = $globalVariables.Clone()
    foreach ($key in $ExtraVariables.Keys) {
        $variables[$key] = $ExtraVariables[$key]
    }
    
    # Add type-specific variables based on analysis
    switch ($Type) {
        "api" {
            $variables["API_VERSION"] = "v1"
            $variables["API_BASE_URL"] = "https://api.example.com"
            $variables["RATE_LIMIT_AUTHENTICATED"] = "1000"
            $variables["RATE_LIMIT_UNAUTHENTICATED"] = "100"
            $variables["RATE_LIMIT_WINDOW"] = "hour"
            
            # Add endpoints from analysis
            if ($projectAnalysis.API) {
                $variables["CONTROLLERS"] = $projectAnalysis.API.Controllers
            }
        }
        
        "architecture" {
            $variables["SYSTEM_TYPE"] = "Multi-tenant SaaS"
            $variables["ARCHITECTURE_STYLE"] = "Microservices"
            $variables["DEPLOYMENT_MODEL"] = "Cloud-native"
            
            # Add components
            if ($projectAnalysis.Architecture) {
                $variables["COMPONENTS"] = $projectAnalysis.Architecture.Components
            }
        }
        
        "development" {
            # Add language-specific variables
            $lang = $projectAnalysis.TechStack.Backend.Language
            $variables["PRIMARY_LANGUAGE"] = $lang
            $variables["CODE_LANGUAGE"] = $lang.ToLower()
            
            if ($lang -eq "C#") {
                $variables["DOTNET"] = $true
                $variables["BUILD_DEV_COMMAND"] = "dotnet build"
                $variables["BUILD_PROD_COMMAND"] = "dotnet publish -c Release"
                $variables["RUN_UNIT_TESTS_COMMAND"] = "dotnet test --filter Category!=Integration"
            }
            elseif ($projectAnalysis.TechStack.Frontend.Primary -match "Angular|React|Vue") {
                $variables["NODEJS"] = $true
                $variables["BUILD_DEV_COMMAND"] = "npm run build:dev"
                $variables["BUILD_PROD_COMMAND"] = "npm run build:prod"
                $variables["RUN_UNIT_TESTS_COMMAND"] = "npm test"
            }
        }
        
        "troubleshooting" {
            $variables["HEALTH_CHECK_COMMAND"] = "curl http://localhost/health"
            $variables["VIEW_LOGS_COMMAND"] = "tail -f logs/app.log"
            $variables["DEFAULT_PORT"] = "5000"
            
            # Add common errors from codebase
            $variables["ERRORS"] = @(
                @{
                    ERROR_MESSAGE = "OrganizationId not found"
                    ERROR_MEANING = "Tenant context is missing from the request"
                    ERROR_CAUSE = "JWT token missing org_id claim or middleware not configured"
                    ERROR_SOLUTION = "Ensure authentication middleware is properly configured"
                }
            )
        }
    }
    
    # Process template
    $processed = Process-Template -TemplateContent $template -Variables $variables
    
    # Write output
    $outputFile = Join-Path $OutputPath "$Type-documentation.md"
    $processed | Out-File -FilePath $outputFile -Encoding UTF8
    
    Write-Host "✓ Generated: $outputFile" -ForegroundColor Green
    
    # Preview if verbose
    if ($Verbose) {
        Write-Host "`nPreview:" -ForegroundColor Cyan
        $processed.Split("`n") | Select-Object -First 20 | ForEach-Object { Write-Host $_ }
        Write-Host "..." -ForegroundColor Gray
    }
}

# Main documentation generation
try {
    if ($DocumentType -eq "all") {
        $types = @("api", "architecture", "development", "troubleshooting")
    } else {
        $types = @($DocumentType)
    }
    
    foreach ($type in $types) {
        $templateName = switch ($type) {
            "api" { "api-documentation.md" }
            "architecture" { "architecture-guide.md" }
            "development" { "development-guide.md" }
            "troubleshooting" { "troubleshooting-guide.md" }
        }
        
        Generate-Documentation -Type $type -TemplateName $templateName
    }
    
    # Generate index/README
    Write-Host "`n📑 Generating documentation index..." -ForegroundColor Yellow
    
    $indexContent = @"
# ${PROJECT_NAME} Documentation

> Auto-generated documentation - Last updated: $($globalVariables.TIMESTAMP)

## Available Documentation

### 📘 [API Documentation](./api-documentation.md)
Complete REST API reference with endpoints, models, and examples.

### 🏗️ [Architecture Guide](./architecture-guide.md)
System architecture, design patterns, and technical decisions.

### 💻 [Development Guide](./development-guide.md)
Setup instructions, coding standards, and development workflow.

### 🔧 [Troubleshooting Guide](./troubleshooting-guide.md)
Common issues, solutions, and debugging procedures.

## Quick Links

- **Repository**: [GitHub](#)
- **Issue Tracker**: [JIRA](#)
- **CI/CD**: [Jenkins](#)
- **Monitoring**: [Grafana](#)

## Project Overview

$($projectAnalysis.Description)

### Technology Stack

- **Backend**: $($projectAnalysis.TechStack.Backend.Primary) ($($projectAnalysis.TechStack.Backend.Language))
- **Frontend**: $($projectAnalysis.TechStack.Frontend.Primary)
- **Database**: $($projectAnalysis.TechStack.Database.Primary)
$(if ($projectAnalysis.TechStack.Cache) { "- **Cache**: $($projectAnalysis.TechStack.Cache)" })

### Key Features

$(if ($projectAnalysis.Patterns.MultiTenant) { "- ✅ Multi-tenant architecture" })
$(if ($projectAnalysis.Patterns.RepositoryPattern) { "- ✅ Repository pattern" })
$(if ($projectAnalysis.Patterns.ResultPattern) { "- ✅ Result<T> error handling" })
$(if ($projectAnalysis.Security.AuthMethod) { "- ✅ $($projectAnalysis.Security.AuthMethod) authentication" })

## Getting Started

1. Read the [Development Guide](./development-guide.md) for setup instructions
2. Review the [Architecture Guide](./architecture-guide.md) for system design
3. Check the [API Documentation](./api-documentation.md) for endpoint reference
4. Bookmark the [Troubleshooting Guide](./troubleshooting-guide.md) for issues

---

*Documentation generated by Claudify - Keeping your docs in sync with your code*
"@
    
    $indexPath = Join-Path $OutputPath "README.md"
    $indexContent | Out-File -FilePath $indexPath -Encoding UTF8
    Write-Host "✓ Generated: $indexPath" -ForegroundColor Green
    
    # Summary
    Write-Host "`n✅ Documentation generation complete!" -ForegroundColor Green
    Write-Host "====================================" -ForegroundColor Green
    Write-Host "Generated $($types.Count) documentation files in: $OutputPath" -ForegroundColor White
    
    # Interactive mode - open in browser/editor
    if ($Interactive) {
        Write-Host "`nWould you like to:" -ForegroundColor Yellow
        Write-Host "1. Open documentation folder" -ForegroundColor White
        Write-Host "2. Preview in browser (requires local server)" -ForegroundColor White
        Write-Host "3. Exit" -ForegroundColor White
        
        $choice = Read-Host "Enter choice (1-3)"
        
        switch ($choice) {
            "1" {
                if ($IsWindows) {
                    Start-Process explorer.exe $OutputPath
                } else {
                    Start-Process open $OutputPath
                }
            }
            "2" {
                Write-Host "Starting local server..." -ForegroundColor Yellow
                Push-Location $OutputPath
                if (Get-Command python -ErrorAction SilentlyContinue) {
                    Start-Process python -ArgumentList "-m", "http.server", "8080"
                    Start-Sleep -Seconds 2
                    Start-Process "http://localhost:8080"
                } else {
                    Write-Warning "Python not found. Please start a local server manually."
                }
                Pop-Location
            }
        }
    }
    
} catch {
    Write-Error "Documentation generation failed: $_"
    exit 1
}