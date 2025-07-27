# Code Quality Analysis Script - Multi-language support
# Usage: .\code-quality.ps1 [-ProjectPath <path>] [-TechStack <auto|dotnet|node|python>] [-MinCoverage 80]

param(
    [string]$ProjectPath = ".",
    [string]$TechStack = "auto",
    [int]$MinCoverage = 80,
    [switch]$Verbose
)

Write-Host "📊 Code Quality Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

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
        CodeCoverage = @{
            Overall = 0
            ByFile = @()
        }
        ComplexityMetrics = @()
        CodeSmells = @()
        BestPractices = @()
        Score = 0
    }
    
    # 1. Code Coverage Analysis
    Write-Host "`n🧪 Analyzing code coverage..." -ForegroundColor Yellow
    
    switch ($TechStack) {
        "dotnet" {
            # Check for coverage results
            $coverageFiles = Get-ChildItem -Path . -Recurse -Include "coverage.cobertura.xml", "coverage.opencover.xml" -ErrorAction SilentlyContinue
            
            if ($coverageFiles) {
                foreach ($file in $coverageFiles) {
                    [xml]$coverage = Get-Content $file.FullName
                    $lineRate = [double]$coverage.coverage.'line-rate' * 100
                    $results.CodeCoverage.Overall = [Math]::Round($lineRate, 2)
                    
                    Write-Host "Overall coverage: $($results.CodeCoverage.Overall)%" -ForegroundColor $(if ($lineRate -ge $MinCoverage) { "Green" } else { "Red" })
                }
            }
            else {
                Write-Host "No coverage data found. Run tests with coverage first." -ForegroundColor Yellow
                $results.CodeCoverage.Note = "No coverage data available"
            }
        }
        
        "node" {
            # Look for NYC/Istanbul coverage
            $coveragePath = Join-Path $ProjectPath "coverage"
            if (Test-Path $coveragePath) {
                $lcovFile = Join-Path $coveragePath "lcov.info"
                if (Test-Path $lcovFile) {
                    $lcov = Get-Content $lcovFile -Raw
                    $lines = ($lcov -split "`n" | Where-Object { $_ -match "^DA:" }).Count
                    $covered = ($lcov -split "`n" | Where-Object { $_ -match "^DA:\d+,[1-9]" }).Count
                    
                    if ($lines -gt 0) {
                        $coverage = [Math]::Round(($covered / $lines) * 100, 2)
                        $results.CodeCoverage.Overall = $coverage
                        Write-Host "Overall coverage: $coverage%" -ForegroundColor $(if ($coverage -ge $MinCoverage) { "Green" } else { "Red" })
                    }
                }
            }
            else {
                Write-Host "No coverage data found. Run 'npm test -- --coverage' first." -ForegroundColor Yellow
            }
        }
        
        "python" {
            # Look for coverage.py results
            $coverageFile = ".coverage"
            if (Test-Path $coverageFile) {
                if (Get-Command coverage -ErrorAction SilentlyContinue) {
                    $coverageReport = & coverage report --format=json 2>&1
                    if ($coverageReport) {
                        $report = $coverageReport | ConvertFrom-Json -ErrorAction SilentlyContinue
                        if ($report.totals.percent_covered) {
                            $results.CodeCoverage.Overall = [Math]::Round($report.totals.percent_covered, 2)
                            Write-Host "Overall coverage: $($results.CodeCoverage.Overall)%" -ForegroundColor $(if ($results.CodeCoverage.Overall -ge $MinCoverage) { "Green" } else { "Red" })
                        }
                    }
                }
            }
        }
    }
    
    # 2. Complexity Analysis
    Write-Host "`n🔍 Analyzing code complexity..." -ForegroundColor Yellow
    
    $complexityThresholds = @{
        Low = 10
        Medium = 20
        High = 50
        VeryHigh = 100
    }
    
    switch ($TechStack) {
        "dotnet" {
            # Analyze C# files for cyclomatic complexity
            $csFiles = Get-ChildItem -Path . -Recurse -Include "*.cs" -File -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch "bin|obj|test|\.g\." }
            
            foreach ($file in $csFiles | Select-Object -First 10) {
                $content = Get-Content $file.FullName -Raw
                
                # Simple complexity estimation based on control structures
                $complexity = 1
                $complexity += ([regex]::Matches($content, '\b(if|else if|switch|case|while|for|foreach|catch)\b').Count)
                $complexity += ([regex]::Matches($content, '&&|\|\|').Count)
                
                $results.ComplexityMetrics += @{
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Complexity = $complexity
                    Rating = if ($complexity -lt $complexityThresholds.Low) { "Low" }
                            elseif ($complexity -lt $complexityThresholds.Medium) { "Medium" }
                            elseif ($complexity -lt $complexityThresholds.High) { "High" }
                            else { "Very High" }
                }
            }
        }
        
        "node" {
            # Analyze JS/TS files
            $jsFiles = Get-ChildItem -Path . -Recurse -Include "*.js", "*.ts" -File -ErrorAction SilentlyContinue |
                Where-Object { $_.FullName -notmatch "node_modules|dist|build|test|spec" }
            
            foreach ($file in $jsFiles | Select-Object -First 10) {
                $content = Get-Content $file.FullName -Raw
                
                $complexity = 1
                $complexity += ([regex]::Matches($content, '\b(if|else if|switch|case|while|for|catch)\b').Count)
                $complexity += ([regex]::Matches($content, '&&|\|\|').Count)
                
                $results.ComplexityMetrics += @{
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Complexity = $complexity
                    Rating = if ($complexity -lt $complexityThresholds.Low) { "Low" }
                            elseif ($complexity -lt $complexityThresholds.Medium) { "Medium" }
                            elseif ($complexity -lt $complexityThresholds.High) { "High" }
                            else { "Very High" }
                }
            }
        }
    }
    
    # 3. Code Smell Detection
    Write-Host "`n🐛 Detecting code smells..." -ForegroundColor Yellow
    
    $codeSmells = @()
    
    # Long methods
    $longMethodThreshold = 50
    $files = Get-ChildItem -Path . -Recurse -Include "*.cs", "*.js", "*.ts", "*.py" -File -ErrorAction SilentlyContinue |
        Where-Object { $_.FullName -notmatch "node_modules|bin|obj|dist|build" }
    
    foreach ($file in $files | Select-Object -First 20) {
        $lines = Get-Content $file.FullName
        $methodStart = -1
        $bracketCount = 0
        
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '(function|def|public|private|protected)\s+\w+\s*\(') {
                $methodStart = $i
                $bracketCount = 0
            }
            
            if ($methodStart -ge 0) {
                $bracketCount += ([regex]::Matches($lines[$i], '\{').Count - [regex]::Matches($lines[$i], '\}').Count)
                
                if ($bracketCount -eq 0 -and $lines[$i] -match '\}') {
                    $methodLength = $i - $methodStart
                    if ($methodLength -gt $longMethodThreshold) {
                        $codeSmells += @{
                            Type = "Long Method"
                            File = $file.FullName.Replace($ProjectPath, ".")
                            Line = $methodStart + 1
                            Length = $methodLength
                        }
                    }
                    $methodStart = -1
                }
            }
        }
    }
    
    # Duplicate code detection (simple)
    $duplicateThreshold = 5
    $codeBlocks = @{}
    
    foreach ($file in $files | Select-Object -First 10) {
        $lines = Get-Content $file.FullName
        for ($i = 0; $i -lt ($lines.Count - $duplicateThreshold); $i++) {
            $block = $lines[$i..($i + $duplicateThreshold - 1)] -join "`n"
            $block = $block -replace '\s+', ' ' # Normalize whitespace
            
            if ($block.Length -gt 100) { # Only consider substantial blocks
                if ($codeBlocks.ContainsKey($block)) {
                    $codeSmells += @{
                        Type = "Duplicate Code"
                        Files = @($codeBlocks[$block], $file.FullName.Replace($ProjectPath, "."))
                        Lines = $duplicateThreshold
                    }
                }
                else {
                    $codeBlocks[$block] = $file.FullName.Replace($ProjectPath, ".")
                }
            }
        }
    }
    
    $results.CodeSmells = $codeSmells
    
    # 4. Best Practices Check
    Write-Host "`n✅ Checking best practices..." -ForegroundColor Yellow
    
    switch ($TechStack) {
        "dotnet" {
            # Check for async best practices
            $asyncIssues = Get-ChildItem -Path . -Recurse -Include "*.cs" -File |
                Select-String -Pattern "\.Result|\.Wait\(\)" |
                Where-Object { $_.Path -notmatch "test|spec" }
            
            if ($asyncIssues) {
                $results.BestPractices += @{
                    Type = "Async Anti-pattern"
                    Severity = "High"
                    Count = $asyncIssues.Count
                    Recommendation = "Use 'await' instead of .Result or .Wait()"
                }
            }
            
            # Check for proper disposal
            $disposalIssues = Get-ChildItem -Path . -Recurse -Include "*.cs" -File |
                Select-String -Pattern "new\s+(SqlConnection|HttpClient|FileStream)" |
                Where-Object { $_.Line -notmatch "using\s*\(" }
            
            if ($disposalIssues) {
                $results.BestPractices += @{
                    Type = "Missing Disposal"
                    Severity = "Medium"
                    Count = $disposalIssues.Count
                    Recommendation = "Use 'using' statements for IDisposable objects"
                }
            }
        }
        
        "node" {
            # Check for console.log in production code
            $consoleLogs = Get-ChildItem -Path . -Recurse -Include "*.js", "*.ts" -File |
                Select-String -Pattern "console\.(log|error|warn)" |
                Where-Object { $_.Path -notmatch "test|spec|debug" }
            
            if ($consoleLogs) {
                $results.BestPractices += @{
                    Type = "Console Statements"
                    Severity = "Low"
                    Count = $consoleLogs.Count
                    Recommendation = "Remove console statements from production code"
                }
            }
            
            # Check for error handling
            $unhandledPromises = Get-ChildItem -Path . -Recurse -Include "*.js", "*.ts" -File |
                Select-String -Pattern "\.then\([^)]*\)(?!.*\.catch)" |
                Where-Object { $_.Path -notmatch "test|spec" }
            
            if ($unhandledPromises) {
                $results.BestPractices += @{
                    Type = "Unhandled Promises"
                    Severity = "Medium"
                    Count = $unhandledPromises.Count
                    Recommendation = "Add .catch() handlers to all promises"
                }
            }
        }
    }
    
    # Calculate overall score
    $score = 100
    
    # Deduct for low coverage
    if ($results.CodeCoverage.Overall -gt 0 -and $results.CodeCoverage.Overall -lt $MinCoverage) {
        $score -= [Math]::Min(20, ($MinCoverage - $results.CodeCoverage.Overall) / 2)
    }
    
    # Deduct for high complexity
    $highComplexityCount = ($results.ComplexityMetrics | Where-Object { $_.Rating -in @("High", "Very High") }).Count
    $score -= [Math]::Min(20, $highComplexityCount * 2)
    
    # Deduct for code smells
    $score -= [Math]::Min(30, $results.CodeSmells.Count * 3)
    
    # Deduct for best practice violations
    $score -= [Math]::Min(30, $results.BestPractices.Count * 5)
    
    $results.Score = [Math]::Max(0, [Math]::Round($score))
    
    # Summary Report
    Write-Host "`n📈 Code Quality Summary" -ForegroundColor Green
    Write-Host "=====================" -ForegroundColor Green
    Write-Host "Tech Stack: $($results.TechStack)"
    Write-Host "Quality Score: $($results.Score)/100" -ForegroundColor $(if ($results.Score -ge 80) { "Green" } elseif ($results.Score -ge 60) { "Yellow" } else { "Red" })
    
    if ($results.CodeCoverage.Overall -gt 0) {
        Write-Host "Code Coverage: $($results.CodeCoverage.Overall)%" -ForegroundColor $(if ($results.CodeCoverage.Overall -ge $MinCoverage) { "Green" } else { "Red" })
    }
    
    Write-Host "`nComplexity Analysis:"
    $complexityGroups = $results.ComplexityMetrics | Group-Object Rating
    foreach ($group in $complexityGroups) {
        Write-Host "  $($group.Name): $($group.Count) files" -ForegroundColor $(
            switch ($group.Name) {
                "Low" { "Green" }
                "Medium" { "Yellow" }
                "High" { "DarkYellow" }
                "Very High" { "Red" }
            }
        )
    }
    
    if ($results.CodeSmells.Count -gt 0) {
        Write-Host "`n🐛 Code Smells Found: $($results.CodeSmells.Count)" -ForegroundColor Yellow
        $results.CodeSmells | Group-Object Type | ForEach-Object {
            Write-Host "  $($_.Name): $($_.Count)" -ForegroundColor Yellow
        }
    }
    
    if ($results.BestPractices.Count -gt 0) {
        Write-Host "`n⚠️ Best Practice Violations:" -ForegroundColor Yellow
        foreach ($issue in $results.BestPractices) {
            Write-Host "  [$($issue.Severity)] $($issue.Type): $($issue.Count) occurrences" -ForegroundColor Yellow
            if ($Verbose) {
                Write-Host "    💡 $($issue.Recommendation)" -ForegroundColor Cyan
            }
        }
    }
    
    # Recommendations
    Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
    
    if ($results.CodeCoverage.Overall -lt $MinCoverage -and $results.CodeCoverage.Overall -gt 0) {
        Write-Host "  • Increase test coverage to at least $MinCoverage%" -ForegroundColor White
    }
    
    if ($highComplexityCount -gt 0) {
        Write-Host "  • Refactor $highComplexityCount files with high complexity" -ForegroundColor White
    }
    
    if ($results.CodeSmells.Count -gt 5) {
        Write-Host "  • Address code smells to improve maintainability" -ForegroundColor White
    }
    
    if ($results.Score -lt 60) {
        Write-Host "  • Consider a dedicated refactoring sprint" -ForegroundColor White
    }
    
    # Export results
    $outputPath = Join-Path $ProjectPath "code-quality-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "`n📄 Detailed results saved to: $outputPath" -ForegroundColor Gray
    
} finally {
    Pop-Location
}