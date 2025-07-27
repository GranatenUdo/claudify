# Research Analysis Script - Deep Knowledge Extraction
# Usage: .\research.ps1 [-ProjectPath <path>] [-Topic <string>] [-OutputFormat <markdown|json|html>]

param(
    [string]$ProjectPath = ".",
    [string]$Topic = "general",
    [string]$OutputFormat = "markdown",
    [switch]$Deep,
    [switch]$IncludeDiagrams
)

Write-Host "🔬 Research Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Topic: $Topic" -ForegroundColor Yellow

Push-Location $ProjectPath

try {
    # Initialize results
    $results = @{
        Topic = $Topic
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ProjectInfo = @{
            Name = Split-Path $ProjectPath -Leaf
            TechStack = @()
            Size = @{
                Files = 0
                Lines = 0
            }
        }
        DomainAnalysis = @{
            Entities = @()
            Services = @()
            Patterns = @()
        }
        Documentation = @{
            Available = @()
            Coverage = 0
            Quality = "Unknown"
        }
        Knowledge = @{
            BusinessRules = @()
            TechnicalPatterns = @()
            IntegrationPoints = @()
        }
        Insights = @()
        Recommendations = @()
    }
    
    # 1. Project Overview
    Write-Host "`n📂 Analyzing project structure..." -ForegroundColor Yellow
    
    # Detect tech stack
    if (Test-Path "*.csproj" -or Test-Path "*.sln") {
        $results.ProjectInfo.TechStack += ".NET"
        $csProjFiles = Get-ChildItem -Path . -Recurse -Include "*.csproj" -File
        foreach ($proj in $csProjFiles) {
            [xml]$content = Get-Content $proj.FullName
            $framework = $content.Project.PropertyGroup.TargetFramework
            if ($framework) {
                $results.ProjectInfo.TechStack += "Target: $framework"
            }
        }
    }
    
    if (Test-Path "package.json") {
        $results.ProjectInfo.TechStack += "Node.js"
        $package = Get-Content "package.json" | ConvertFrom-Json
        if ($package.dependencies."@angular/core") {
            $results.ProjectInfo.TechStack += "Angular"
        }
        if ($package.dependencies.react) {
            $results.ProjectInfo.TechStack += "React"
        }
    }
    
    if (Test-Path "requirements.txt" -or Test-Path "setup.py") {
        $results.ProjectInfo.TechStack += "Python"
    }
    
    # Count files and lines
    $codeFiles = Get-ChildItem -Path . -Recurse -Include "*.cs", "*.js", "*.ts", "*.py", "*.java" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build|\.git" }
    
    $results.ProjectInfo.Size.Files = $codeFiles.Count
    $totalLines = 0
    foreach ($file in $codeFiles) {
        $totalLines += (Get-Content $file.FullName -ErrorAction SilentlyContinue).Count
    }
    $results.ProjectInfo.Size.Lines = $totalLines
    
    # 2. Domain Analysis
    Write-Host "`n🏛️ Analyzing domain models..." -ForegroundColor Yellow
    
    # Find entity/model files
    $entityFiles = Get-ChildItem -Path . -Recurse -Include "*Entity*.cs", "*Model*.cs", "*Domain*.cs", "*.model.ts", "*entity*.py" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|test" }
    
    foreach ($file in $entityFiles | Select-Object -First 20) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        # Extract class/interface names
        $matches = [regex]::Matches($content, '(?:public\s+)?(?:class|interface|struct)\s+(\w+)')
        foreach ($match in $matches) {
            $entityName = $match.Groups[1].Value
            if ($entityName -notmatch "Base|Abstract|Interface|Exception") {
                $results.DomainAnalysis.Entities += @{
                    Name = $entityName
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Properties = @()
                }
                
                # Extract properties (simplified)
                $propMatches = [regex]::Matches($content, '(?:public|private|protected)?\s*(?:readonly)?\s*(\w+)\s+(\w+)\s*[{;]')
                foreach ($prop in $propMatches | Select-Object -First 10) {
                    $results.DomainAnalysis.Entities[-1].Properties += @{
                        Type = $prop.Groups[1].Value
                        Name = $prop.Groups[2].Value
                    }
                }
            }
        }
    }
    
    # Find service files
    $serviceFiles = Get-ChildItem -Path . -Recurse -Include "*Service*.cs", "*Service*.ts", "*Handler*.cs", "*UseCase*.cs" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|test" }
    
    foreach ($file in $serviceFiles | Select-Object -First 20) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        # Extract service class names and methods
        $classMatch = [regex]::Match($content, '(?:public\s+)?(?:class|interface)\s+(\w+Service\w*)')
        if ($classMatch.Success) {
            $serviceName = $classMatch.Groups[1].Value
            
            # Extract public methods
            $methodMatches = [regex]::Matches($content, '(?:public|async)\s+(?:Task<)?(\w+)(?:>)?\s+(\w+)\s*\(')
            $methods = @()
            foreach ($method in $methodMatches | Select-Object -First 10) {
                if ($method.Groups[2].Value -notmatch "ctor|Dispose") {
                    $methods += $method.Groups[2].Value
                }
            }
            
            $results.DomainAnalysis.Services += @{
                Name = $serviceName
                File = $file.FullName.Replace($ProjectPath, ".")
                Methods = $methods
            }
        }
    }
    
    # 3. Pattern Detection
    Write-Host "`n🔍 Detecting patterns and practices..." -ForegroundColor Yellow
    
    # Repository Pattern
    if (Get-ChildItem -Path . -Recurse -Include "*Repository*.cs", "*Repository*.ts" -File | Where-Object { $_.FullName -notmatch "test" }) {
        $results.DomainAnalysis.Patterns += "Repository Pattern"
    }
    
    # Factory Pattern
    if (Get-ChildItem -Path . -Recurse -Include "*Factory*.cs", "*Factory*.ts" -File | Where-Object { $_.FullName -notmatch "test" }) {
        $results.DomainAnalysis.Patterns += "Factory Pattern"
    }
    
    # CQRS
    if ((Get-ChildItem -Path . -Recurse -Include "*Command*.cs", "*Query*.cs", "*Handler*.cs" -File).Count -gt 5) {
        $results.DomainAnalysis.Patterns += "CQRS Pattern"
    }
    
    # Event-Driven
    if (Get-ChildItem -Path . -Recurse -Include "*Event*.cs", "*EventBus*.cs", "*MessageBus*.cs" -File) {
        $results.DomainAnalysis.Patterns += "Event-Driven Architecture"
    }
    
    # 4. Documentation Analysis
    Write-Host "`n📚 Analyzing documentation..." -ForegroundColor Yellow
    
    # Find documentation files
    $docFiles = Get-ChildItem -Path . -Recurse -Include "*.md", "*.txt", "*.adoc" -File |
        Where-Object { $_.FullName -notmatch "node_modules|bin|obj" }
    
    foreach ($doc in $docFiles) {
        $results.Documentation.Available += @{
            Name = $doc.Name
            Path = $doc.FullName.Replace($ProjectPath, ".")
            Size = [Math]::Round($doc.Length / 1KB, 2)
        }
    }
    
    # Check for specific documentation
    $importantDocs = @("README.md", "ARCHITECTURE.md", "API.md", "CONTRIBUTING.md", "CHANGELOG.md")
    $foundDocs = $results.Documentation.Available | Where-Object { $_.Name -in $importantDocs }
    $results.Documentation.Coverage = [Math]::Round(($foundDocs.Count / $importantDocs.Count) * 100, 2)
    
    # 5. Extract Business Rules and Knowledge
    Write-Host "`n💼 Extracting business rules and knowledge..." -ForegroundColor Yellow
    
    # Search for validation rules
    $validationFiles = Get-ChildItem -Path . -Recurse -Include "*Validator*.cs", "*Validation*.cs", "*Rules*.cs" -File |
        Where-Object { $_.FullName -notmatch "test" }
    
    foreach ($file in $validationFiles | Select-Object -First 10) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        # Look for validation methods
        $ruleMatches = [regex]::Matches($content, '(?:RuleFor|Validate|Check|Must|Should)\w*\s*\(([^)]+)\)')
        foreach ($match in $ruleMatches | Select-Object -First 5) {
            $results.Knowledge.BusinessRules += @{
                Source = $file.Name
                Rule = $match.Groups[0].Value.Trim()
            }
        }
    }
    
    # Search for configuration and constants
    $configFiles = Get-ChildItem -Path . -Recurse -Include "*Config*.cs", "*Constants*.cs", "*Settings*.cs", "*.config", "*.json" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules" }
    
    foreach ($file in $configFiles | Select-Object -First 10) {
        if ($file.Extension -eq ".json") {
            try {
                $config = Get-Content $file.FullName | ConvertFrom-Json
                # Extract interesting configuration
                if ($config.PSObject.Properties.Name -contains "ConnectionStrings") {
                    $results.Knowledge.TechnicalPatterns += "Database: " + ($config.ConnectionStrings.PSObject.Properties.Name -join ", ")
                }
            } catch {}
        }
    }
    
    # 6. Integration Points
    Write-Host "`n🔌 Identifying integration points..." -ForegroundColor Yellow
    
    # API Controllers
    $apiFiles = Get-ChildItem -Path . -Recurse -Include "*Controller*.cs", "*Api*.cs", "*.controller.ts" -File |
        Where-Object { $_.FullName -notmatch "test" }
    
    foreach ($file in $apiFiles | Select-Object -First 10) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        # Extract API endpoints
        $endpointMatches = [regex]::Matches($content, '\[(HttpGet|HttpPost|HttpPut|HttpDelete|Route)\("([^"]+)"\)')
        foreach ($match in $endpointMatches | Select-Object -First 5) {
            $results.Knowledge.IntegrationPoints += @{
                Type = "REST API"
                Method = $match.Groups[1].Value
                Endpoint = $match.Groups[2].Value
                File = $file.Name
            }
        }
    }
    
    # External service calls
    $httpCalls = Get-ChildItem -Path . -Recurse -Include "*.cs", "*.ts", "*.js" -File |
        Select-String -Pattern "HttpClient|fetch\(|axios\.|RestClient" |
        Select-Object -First 10
    
    foreach ($call in $httpCalls) {
        $results.Knowledge.IntegrationPoints += @{
            Type = "External API Call"
            File = Split-Path $call.Path -Leaf
            Line = $call.LineNumber
        }
    }
    
    # 7. Generate Insights
    Write-Host "`n🎯 Generating insights..." -ForegroundColor Yellow
    
    # Size insights
    if ($results.ProjectInfo.Size.Files -gt 500) {
        $results.Insights += "Large codebase with $($results.ProjectInfo.Size.Files) files - consider modularization"
    }
    
    # Architecture insights
    if ($results.DomainAnalysis.Patterns -contains "CQRS Pattern" -and $results.DomainAnalysis.Patterns -contains "Event-Driven Architecture") {
        $results.Insights += "Advanced architecture patterns detected - suitable for complex domains"
    }
    
    # Documentation insights
    if ($results.Documentation.Coverage -lt 50) {
        $results.Insights += "Documentation coverage is low ($($results.Documentation.Coverage)%) - critical docs missing"
    }
    
    # Domain complexity
    if ($results.DomainAnalysis.Entities.Count -gt 20) {
        $results.Insights += "Complex domain model with $($results.DomainAnalysis.Entities.Count) entities - consider bounded contexts"
    }
    
    # Integration complexity
    if ($results.Knowledge.IntegrationPoints.Count -gt 10) {
        $results.Insights += "Multiple integration points detected - ensure proper error handling and resilience"
    }
    
    # 8. Generate Recommendations
    Write-Host "`n💡 Generating recommendations..." -ForegroundColor Yellow
    
    # Based on findings
    if ($results.Documentation.Coverage -lt 60) {
        $results.Recommendations += "Create comprehensive README.md and ARCHITECTURE.md"
    }
    
    if ($results.DomainAnalysis.Services.Count -gt 20 -and $results.DomainAnalysis.Patterns -notcontains "CQRS Pattern") {
        $results.Recommendations += "Consider CQRS pattern to manage service complexity"
    }
    
    if ($results.Knowledge.BusinessRules.Count -lt 5) {
        $results.Recommendations += "Centralize business rules in domain layer"
    }
    
    if ($results.Knowledge.IntegrationPoints | Where-Object { $_.Type -eq "External API Call" }) {
        $results.Recommendations += "Implement circuit breaker pattern for external APIs"
    }
    
    # Output Results
    Write-Host "`n📋 Research Summary" -ForegroundColor Green
    Write-Host "==================" -ForegroundColor Green
    Write-Host "Project: $($results.ProjectInfo.Name)"
    Write-Host "Tech Stack: $($results.ProjectInfo.TechStack -join ', ')"
    Write-Host "Size: $($results.ProjectInfo.Size.Files) files, $($results.ProjectInfo.Size.Lines) lines"
    
    Write-Host "`nDomain Analysis:"
    Write-Host "  Entities: $($results.DomainAnalysis.Entities.Count)"
    Write-Host "  Services: $($results.DomainAnalysis.Services.Count)"
    Write-Host "  Patterns: $($results.DomainAnalysis.Patterns -join ', ')"
    
    Write-Host "`nDocumentation:"
    Write-Host "  Available: $($results.Documentation.Available.Count) files"
    Write-Host "  Coverage: $($results.Documentation.Coverage)%"
    
    if ($results.Insights.Count -gt 0) {
        Write-Host "`n🎯 Key Insights:" -ForegroundColor Cyan
        foreach ($insight in $results.Insights) {
            Write-Host "  • $insight" -ForegroundColor White
        }
    }
    
    if ($results.Recommendations.Count -gt 0) {
        Write-Host "`n💡 Recommendations:" -ForegroundColor Yellow
        foreach ($rec in $results.Recommendations) {
            Write-Host "  → $rec" -ForegroundColor White
        }
    }
    
    # Export based on format
    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $baseOutputPath = Join-Path $ProjectPath "research-$Topic-$timestamp"
    
    switch ($OutputFormat) {
        "json" {
            $outputPath = "$baseOutputPath.json"
            $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
        }
        
        "markdown" {
            $outputPath = "$baseOutputPath.md"
            $markdown = @"
# Research Analysis: $Topic

Generated: $($results.Timestamp)

## Project Overview

- **Name**: $($results.ProjectInfo.Name)
- **Tech Stack**: $($results.ProjectInfo.TechStack -join ', ')
- **Size**: $($results.ProjectInfo.Size.Files) files, $($results.ProjectInfo.Size.Lines) lines of code

## Domain Analysis

### Entities ($($results.DomainAnalysis.Entities.Count))
$(foreach ($entity in $results.DomainAnalysis.Entities | Select-Object -First 10) {
"- **$($entity.Name)**: $($entity.Properties.Count) properties"
})

### Services ($($results.DomainAnalysis.Services.Count))
$(foreach ($service in $results.DomainAnalysis.Services | Select-Object -First 10) {
"- **$($service.Name)**: $($service.Methods.Count) methods"
})

### Patterns Detected
$($results.DomainAnalysis.Patterns | ForEach-Object { "- $_" })

## Documentation Analysis

- **Coverage**: $($results.Documentation.Coverage)%
- **Available Documents**: $($results.Documentation.Available.Count)

### Key Documents
$(foreach ($doc in $results.Documentation.Available | Where-Object { $_.Name -match "README|ARCHITECTURE|API" }) {
"- $($doc.Name) ($($doc.Size) KB)"
})

## Business Knowledge

### Business Rules Extracted
$(foreach ($rule in $results.Knowledge.BusinessRules | Select-Object -First 5) {
"- $($rule.Rule)"
})

### Integration Points
$(($results.Knowledge.IntegrationPoints | Group-Object Type).Name | ForEach-Object { "- $_" })

## Insights

$($results.Insights | ForEach-Object { "- $_" })

## Recommendations

$($results.Recommendations | ForEach-Object { "1. $_" })

---
*Generated by Claudify Research Tool*
"@
            $markdown | Out-File -FilePath $outputPath -Encoding UTF8
        }
        
        "html" {
            $outputPath = "$baseOutputPath.html"
            # Generate HTML report (simplified)
            $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Research Analysis: $Topic</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        h1, h2, h3 { color: #333; }
        .metric { background: #f0f0f0; padding: 10px; margin: 10px 0; }
        .insight { background: #e8f4f8; padding: 10px; margin: 10px 0; }
        .recommendation { background: #f8f4e8; padding: 10px; margin: 10px 0; }
    </style>
</head>
<body>
    <h1>Research Analysis: $Topic</h1>
    <p>Generated: $($results.Timestamp)</p>
    
    <h2>Project Overview</h2>
    <div class="metric">
        <strong>Tech Stack:</strong> $($results.ProjectInfo.TechStack -join ', ')<br>
        <strong>Size:</strong> $($results.ProjectInfo.Size.Files) files, $($results.ProjectInfo.Size.Lines) lines
    </div>
    
    <h2>Domain Analysis</h2>
    <div class="metric">
        <strong>Entities:</strong> $($results.DomainAnalysis.Entities.Count)<br>
        <strong>Services:</strong> $($results.DomainAnalysis.Services.Count)<br>
        <strong>Patterns:</strong> $($results.DomainAnalysis.Patterns -join ', ')
    </div>
    
    <h2>Insights</h2>
    $($results.Insights | ForEach-Object { "<div class='insight'>$_</div>" })
    
    <h2>Recommendations</h2>
    $($results.Recommendations | ForEach-Object { "<div class='recommendation'>$_</div>" })
</body>
</html>
"@
            $html | Out-File -FilePath $outputPath -Encoding UTF8
        }
    }
    
    Write-Host "`n📄 Research report saved to: $outputPath" -ForegroundColor Gray
    
    # Generate diagram if requested
    if ($IncludeDiagrams) {
        Write-Host "`n📊 Domain Model Diagram (PlantUML):" -ForegroundColor Cyan
        Write-Host "@startuml"
        Write-Host "!define ENTITY class"
        Write-Host "!define SERVICE interface"
        
        foreach ($entity in $results.DomainAnalysis.Entities | Select-Object -First 10) {
            Write-Host "ENTITY $($entity.Name) {"
            foreach ($prop in $entity.Properties | Select-Object -First 5) {
                Write-Host "  $($prop.Type) $($prop.Name)"
            }
            Write-Host "}"
        }
        
        Write-Host "@enduml"
    }
    
} finally {
    Pop-Location
}