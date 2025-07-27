# Architecture Analysis Script - Tech Lead's Strategic Tool
# Usage: .\analyze-architecture.ps1 [-ProjectPath <path>] [-TechStack <auto|dotnet|node|python>] [-Deep]

param(
    [string]$ProjectPath = ".",
    [string]$TechStack = "auto",
    [switch]$Deep,
    [switch]$Verbose
)

Write-Host "🏗️ Architecture Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Analyzing architecture patterns and dependencies..." -ForegroundColor Gray

Push-Location $ProjectPath

try {
    # Auto-detect tech stack
    if ($TechStack -eq "auto") {
        Write-Host "`nDetecting technology stack..." -ForegroundColor Yellow
        
        if (Test-Path "*.csproj" -or Test-Path "*.sln") {
            $TechStack = "dotnet"
        }
        elseif (Test-Path "package.json") {
            $TechStack = "node"
        }
        elseif (Test-Path "requirements.txt" -or Test-Path "setup.py") {
            $TechStack = "python"
        }
        else {
            $TechStack = "general"
        }
        
        Write-Host "Detected tech stack: $TechStack" -ForegroundColor Green
    }
    
    # Initialize results
    $results = @{
        TechStack = $TechStack
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Architecture = @{
            Pattern = "Unknown"
            Layers = @()
            BoundedContexts = @()
        }
        Dependencies = @{
            Internal = @()
            External = @()
            Circular = @()
        }
        Patterns = @{
            Repository = $false
            CQRS = $false
            EventSourcing = $false
            DDD = $false
            Microservices = $false
        }
        Metrics = @{
            TotalFiles = 0
            TotalLines = 0
            ComponentCoupling = 0
        }
        Issues = @()
        Recommendations = @()
    }
    
    # 1. Detect Architecture Pattern
    Write-Host "`n📐 Detecting architecture pattern..." -ForegroundColor Yellow
    
    # Look for common patterns
    $srcStructure = Get-ChildItem -Path . -Directory -Recurse | Where-Object { $_.Name -notmatch "bin|obj|node_modules|\.git" }
    
    # Layer detection
    $layers = @()
    $layerPatterns = @{
        "Presentation" = @("Controllers", "Views", "Pages", "Components", "Web")
        "Application" = @("Services", "UseCases", "Handlers", "Commands", "Queries")
        "Domain" = @("Models", "Entities", "ValueObjects", "Aggregates", "DomainServices")
        "Infrastructure" = @("Repositories", "Data", "Persistence", "External")
    }
    
    foreach ($layer in $layerPatterns.Keys) {
        foreach ($pattern in $layerPatterns[$layer]) {
            if ($srcStructure | Where-Object { $_.Name -match $pattern }) {
                $layers += $layer
                break
            }
        }
    }
    
    $results.Architecture.Layers = $layers | Sort-Object -Unique
    
    # Architecture pattern detection
    if ($layers.Count -ge 3) {
        if ($srcStructure | Where-Object { $_.Name -match "Domain|Entities" }) {
            $results.Architecture.Pattern = "Domain-Driven Design (DDD)"
            $results.Patterns.DDD = $true
        }
        else {
            $results.Architecture.Pattern = "Layered Architecture"
        }
    }
    elseif ($srcStructure | Where-Object { $_.Name -match "Features|Modules" }) {
        $results.Architecture.Pattern = "Vertical Slice Architecture"
    }
    else {
        $results.Architecture.Pattern = "Simple MVC/API"
    }
    
    # 2. Pattern Detection
    Write-Host "`n🔍 Detecting design patterns..." -ForegroundColor Yellow
    
    # Repository Pattern
    $repoFiles = Get-ChildItem -Path . -Recurse -Include "*Repository*.cs", "*Repository*.ts", "*repository*.py" -File -ErrorAction SilentlyContinue
    if ($repoFiles.Count -gt 0) {
        $results.Patterns.Repository = $true
        Write-Host "  ✓ Repository Pattern detected" -ForegroundColor Green
    }
    
    # CQRS Pattern
    $commandFiles = Get-ChildItem -Path . -Recurse -Include "*Command*.cs", "*Handler*.cs", "*Query*.cs" -File -ErrorAction SilentlyContinue
    if ($commandFiles.Count -gt 5) {
        $results.Patterns.CQRS = $true
        Write-Host "  ✓ CQRS Pattern detected" -ForegroundColor Green
    }
    
    # Event Sourcing
    $eventFiles = Get-ChildItem -Path . -Recurse -Include "*Event*.cs", "*EventStore*.cs", "*Aggregate*.cs" -File -ErrorAction SilentlyContinue
    if ($eventFiles.Count -gt 3) {
        $results.Patterns.EventSourcing = $true
        Write-Host "  ✓ Event Sourcing detected" -ForegroundColor Green
    }
    
    # 3. Dependency Analysis
    Write-Host "`n📦 Analyzing dependencies..." -ForegroundColor Yellow
    
    switch ($TechStack) {
        "dotnet" {
            # Analyze project references
            $projectFiles = Get-ChildItem -Path . -Recurse -Include "*.csproj" -File
            $dependencies = @{}
            
            foreach ($proj in $projectFiles) {
                $projName = [System.IO.Path]::GetFileNameWithoutExtension($proj.Name)
                $dependencies[$projName] = @()
                
                [xml]$content = Get-Content $proj.FullName
                $refs = $content.Project.ItemGroup.ProjectReference.Include
                
                foreach ($ref in $refs) {
                    if ($ref) {
                        $refName = [System.IO.Path]::GetFileNameWithoutExtension($ref)
                        $dependencies[$projName] += $refName
                    }
                }
            }
            
            # Detect circular dependencies
            foreach ($proj in $dependencies.Keys) {
                foreach ($dep in $dependencies[$proj]) {
                    if ($dependencies.ContainsKey($dep) -and $dependencies[$dep] -contains $proj) {
                        $results.Dependencies.Circular += @{
                            From = $proj
                            To = $dep
                        }
                    }
                }
            }
            
            # Analyze NuGet packages
            $packagesConfig = Get-ChildItem -Path . -Recurse -Include "packages.config", "*.csproj" -File
            $externalPackages = @()
            
            foreach ($file in $packagesConfig) {
                if ($file.Extension -eq ".config") {
                    [xml]$packages = Get-Content $file.FullName
                    $externalPackages += $packages.packages.package | ForEach-Object { $_.id }
                }
                else {
                    [xml]$proj = Get-Content $file.FullName
                    $externalPackages += $proj.Project.ItemGroup.PackageReference.Include
                }
            }
            
            $results.Dependencies.External = $externalPackages | Where-Object { $_ } | Sort-Object -Unique
        }
        
        "node" {
            # Analyze package.json
            if (Test-Path "package.json") {
                $package = Get-Content "package.json" | ConvertFrom-Json
                $results.Dependencies.External = @()
                
                if ($package.dependencies) {
                    $results.Dependencies.External += $package.dependencies.PSObject.Properties.Name
                }
                
                if ($package.devDependencies -and $Deep) {
                    $results.Dependencies.External += $package.devDependencies.PSObject.Properties.Name
                }
            }
            
            # Analyze internal module dependencies
            if ($Deep) {
                Write-Host "  Performing deep dependency analysis..." -ForegroundColor Gray
                
                # Simple import analysis
                $jsFiles = Get-ChildItem -Path . -Recurse -Include "*.js", "*.ts" -File |
                    Where-Object { $_.FullName -notmatch "node_modules|dist|build" }
                
                $importMap = @{}
                foreach ($file in $jsFiles) {
                    $content = Get-Content $file.FullName -Raw
                    $imports = [regex]::Matches($content, "import.*from\s+['""]([^'""]+)['""]")
                    
                    $fileName = $file.FullName.Replace($ProjectPath, ".").Replace("\", "/")
                    $importMap[$fileName] = @()
                    
                    foreach ($import in $imports) {
                        $importPath = $import.Groups[1].Value
                        if ($importPath -notmatch "^[@\w]" -and $importPath -match "^\.") {
                            $importMap[$fileName] += $importPath
                        }
                    }
                }
                
                $results.Dependencies.Internal = $importMap
            }
        }
    }
    
    # 4. Bounded Context Detection (DDD)
    if ($results.Patterns.DDD) {
        Write-Host "`n🏛️ Detecting bounded contexts..." -ForegroundColor Yellow
        
        $contexts = @()
        $domainFolders = Get-ChildItem -Path . -Directory -Recurse |
            Where-Object { $_.FullName -match "Domain|Core" -and $_.Parent.Name -notmatch "bin|obj" }
        
        foreach ($folder in $domainFolders) {
            $subfolders = Get-ChildItem -Path $folder.FullName -Directory
            foreach ($sub in $subfolders) {
                if ($sub.Name -notmatch "Base|Common|Shared|Infrastructure") {
                    $contexts += $sub.Name
                }
            }
        }
        
        $results.Architecture.BoundedContexts = $contexts | Sort-Object -Unique
        
        if ($contexts.Count -gt 0) {
            Write-Host "  Found bounded contexts: $($contexts -join ', ')" -ForegroundColor Green
        }
    }
    
    # 5. Architecture Metrics
    Write-Host "`n📊 Calculating architecture metrics..." -ForegroundColor Yellow
    
    # File and line counts
    $codeFiles = Get-ChildItem -Path . -Recurse -Include "*.cs", "*.js", "*.ts", "*.py" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build" }
    
    $results.Metrics.TotalFiles = $codeFiles.Count
    $totalLines = 0
    foreach ($file in $codeFiles) {
        $totalLines += (Get-Content $file.FullName).Count
    }
    $results.Metrics.TotalLines = $totalLines
    
    # Component coupling (simplified)
    if ($results.Dependencies.Internal.Count -gt 0) {
        $totalDeps = 0
        $results.Dependencies.Internal.Values | ForEach-Object { $totalDeps += $_.Count }
        $results.Metrics.ComponentCoupling = [Math]::Round($totalDeps / $results.Metrics.TotalFiles, 2)
    }
    
    # 6. Architecture Issues Detection
    Write-Host "`n⚠️ Detecting architecture issues..." -ForegroundColor Yellow
    
    # Circular dependencies
    if ($results.Dependencies.Circular.Count -gt 0) {
        $results.Issues += @{
            Type = "Circular Dependencies"
            Severity = "High"
            Count = $results.Dependencies.Circular.Count
            Details = "Projects have circular references"
        }
    }
    
    # God classes/modules
    $largeFiles = $codeFiles | Where-Object { (Get-Content $_.FullName).Count -gt 500 }
    if ($largeFiles.Count -gt 0) {
        $results.Issues += @{
            Type = "Large Classes/Modules"
            Severity = "Medium"
            Count = $largeFiles.Count
            Files = $largeFiles | ForEach-Object { $_.FullName.Replace($ProjectPath, ".") }
        }
    }
    
    # Missing abstractions
    if ($results.Patterns.Repository -eq $false -and $results.Metrics.TotalFiles -gt 50) {
        $results.Issues += @{
            Type = "Missing Abstractions"
            Severity = "Medium"
            Details = "No repository pattern detected for data access"
        }
    }
    
    # High coupling
    if ($results.Metrics.ComponentCoupling -gt 5) {
        $results.Issues += @{
            Type = "High Coupling"
            Severity = "High"
            Metric = $results.Metrics.ComponentCoupling
            Details = "Components are highly coupled"
        }
    }
    
    # 7. Generate Recommendations
    Write-Host "`n💡 Generating architecture recommendations..." -ForegroundColor Yellow
    
    # Based on patterns
    if ($results.Patterns.Repository -eq $false -and $TechStack -eq "dotnet") {
        $results.Recommendations += "Implement Repository pattern for data access abstraction"
    }
    
    if ($results.Architecture.Pattern -eq "Simple MVC/API" -and $results.Metrics.TotalFiles -gt 100) {
        $results.Recommendations += "Consider adopting Domain-Driven Design for better organization"
    }
    
    # Based on issues
    if ($results.Dependencies.Circular.Count -gt 0) {
        $results.Recommendations += "Refactor to eliminate circular dependencies"
    }
    
    if ($results.Issues | Where-Object { $_.Type -eq "Large Classes/Modules" }) {
        $results.Recommendations += "Split large files following Single Responsibility Principle"
    }
    
    if ($results.Metrics.ComponentCoupling -gt 3) {
        $results.Recommendations += "Reduce coupling by introducing interfaces and dependency injection"
    }
    
    # Tech-specific recommendations
    if ($TechStack -eq "dotnet" -and -not ($results.Dependencies.External -contains "MediatR") -and $results.Patterns.CQRS) {
        $results.Recommendations += "Consider using MediatR for CQRS implementation"
    }
    
    # Summary Report
    Write-Host "`n🏗️ Architecture Analysis Summary" -ForegroundColor Green
    Write-Host "==============================" -ForegroundColor Green
    Write-Host "Architecture Pattern: $($results.Architecture.Pattern)"
    Write-Host "Layers Detected: $($results.Architecture.Layers -join ', ')"
    
    if ($results.Architecture.BoundedContexts.Count -gt 0) {
        Write-Host "Bounded Contexts: $($results.Architecture.BoundedContexts -join ', ')"
    }
    
    Write-Host "`nDesign Patterns:"
    $results.Patterns.GetEnumerator() | Where-Object { $_.Value -eq $true } | ForEach-Object {
        Write-Host "  ✓ $($_.Key)" -ForegroundColor Green
    }
    
    Write-Host "`nMetrics:"
    Write-Host "  Total Files: $($results.Metrics.TotalFiles)"
    Write-Host "  Total Lines: $($results.Metrics.TotalLines)"
    Write-Host "  Component Coupling: $($results.Metrics.ComponentCoupling)" -ForegroundColor $(
        if ($results.Metrics.ComponentCoupling -lt 3) { "Green" }
        elseif ($results.Metrics.ComponentCoupling -lt 5) { "Yellow" }
        else { "Red" }
    )
    
    if ($results.Issues.Count -gt 0) {
        Write-Host "`n⚠️ Architecture Issues:" -ForegroundColor Red
        foreach ($issue in $results.Issues) {
            Write-Host "  [$($issue.Severity)] $($issue.Type)" -ForegroundColor Yellow
            if ($Verbose -and $issue.Details) {
                Write-Host "    $($issue.Details)" -ForegroundColor Gray
            }
        }
    }
    
    if ($results.Recommendations.Count -gt 0) {
        Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
        foreach ($rec in $results.Recommendations) {
            Write-Host "  • $rec" -ForegroundColor White
        }
    }
    
    # Export results
    $outputPath = Join-Path $ProjectPath "architecture-analysis-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "`n📄 Detailed results saved to: $outputPath" -ForegroundColor Gray
    
    # Generate architecture diagram suggestion
    if ($Deep) {
        Write-Host "`n📊 Architecture Diagram (PlantUML format):" -ForegroundColor Cyan
        Write-Host "@startuml"
        Write-Host "!define RECTANGLE class"
        
        foreach ($layer in $results.Architecture.Layers) {
            Write-Host "package ""$layer Layer"" {"
            Write-Host "  RECTANGLE $layer"
            Write-Host "}"
        }
        
        Write-Host "@enduml"
    }
    
} finally {
    Pop-Location
}