# Technical Debt Complexity Analyzer - Identifies and quantifies technical debt
# Usage: .\complexity-analyzer.ps1 [-ProjectPath <path>] [-DebtThreshold 50] [-GenerateReport]

param(
    [string]$ProjectPath = ".",
    [int]$DebtThreshold = 50,
    [switch]$GenerateReport,
    [switch]$Verbose
)

Write-Host "🏗️ Technical Debt Complexity Analyzer - Claudify Edition" -ForegroundColor Cyan
Write-Host "====================================================" -ForegroundColor Cyan

Push-Location $ProjectPath

try {
    # Initialize debt analysis
    $debtAnalysis = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ProjectPath = $ProjectPath
        TotalDebtScore = 0
        DebtCategories = @{
            CodeComplexity = @{ Score = 0; Items = @() }
            Duplication = @{ Score = 0; Items = @() }
            Dependencies = @{ Score = 0; Items = @() }
            Documentation = @{ Score = 0; Items = @() }
            Testing = @{ Score = 0; Items = @() }
            Security = @{ Score = 0; Items = @() }
            Performance = @{ Score = 0; Items = @() }
        }
        CriticalIssues = @()
        RefactoringPriorities = @()
        EstimatedEffort = @{
            Hours = 0
            Cost = 0
        }
    }
    
    Write-Host "`n📊 Phase 1: Analyzing code complexity..." -ForegroundColor Yellow
    
    # Get all source files
    $sourceFiles = Get-ChildItem -Path . -Recurse -Include "*.cs", "*.js", "*.ts", "*.py", "*.java" -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build|\.git" }
    
    # Analyze each file
    foreach ($file in $sourceFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $fileMetrics = @{
            Path = $file.FullName.Replace($ProjectPath, ".")
            Lines = ($content -split "`n").Count
            Complexity = 0
            Issues = @()
        }
        
        # Calculate cyclomatic complexity
        $complexity = 1
        $complexity += ([regex]::Matches($content, '\b(if|else if|switch|case|while|for|foreach|catch)\b')).Count
        $complexity += ([regex]::Matches($content, '(\|\||&&)')).Count
        
        $fileMetrics.Complexity = $complexity
        
        # Check for various debt indicators
        
        # 1. Long files
        if ($fileMetrics.Lines -gt 500) {
            $debtScore = [Math]::Min(20, [Math]::Round(($fileMetrics.Lines - 500) / 50))
            $debtAnalysis.DebtCategories.CodeComplexity.Items += @{
                Type = "Long File"
                File = $fileMetrics.Path
                Metric = "$($fileMetrics.Lines) lines"
                DebtScore = $debtScore
                Recommendation = "Split into smaller, focused files"
            }
            $debtAnalysis.DebtCategories.CodeComplexity.Score += $debtScore
        }
        
        # 2. Complex methods
        $methods = [regex]::Matches($content, '(?:public|private|protected)\s+(?:static\s+)?(?:async\s+)?(?:Task<.*?>|void|[\w<>]+)\s+(\w+)\s*\([^)]*\)\s*{')
        foreach ($method in $methods) {
            $methodBody = Extract-MethodBody $content $method.Index
            $methodComplexity = Calculate-MethodComplexity $methodBody
            
            if ($methodComplexity -gt 10) {
                $debtScore = [Math]::Min(15, $methodComplexity - 10)
                $debtAnalysis.DebtCategories.CodeComplexity.Items += @{
                    Type = "Complex Method"
                    File = $fileMetrics.Path
                    Method = $method.Groups[1].Value
                    Metric = "Complexity: $methodComplexity"
                    DebtScore = $debtScore
                    Recommendation = "Refactor into smaller methods"
                }
                $debtAnalysis.DebtCategories.CodeComplexity.Score += $debtScore
            }
        }
        
        # 3. Commented code
        $commentedCode = [regex]::Matches($content, '//.*(?:if|for|while|function|class|public|private)')
        if ($commentedCode.Count -gt 5) {
            $debtScore = [Math]::Min(10, $commentedCode.Count)
            $debtAnalysis.DebtCategories.CodeComplexity.Items += @{
                Type = "Commented Code"
                File = $fileMetrics.Path
                Metric = "$($commentedCode.Count) blocks"
                DebtScore = $debtScore
                Recommendation = "Remove commented code, use version control instead"
            }
            $debtAnalysis.DebtCategories.CodeComplexity.Score += $debtScore
        }
        
        # 4. TODO/FIXME comments
        $todoComments = [regex]::Matches($content, '(TODO|FIXME|HACK|XXX):')
        if ($todoComments.Count -gt 0) {
            $debtScore = $todoComments.Count * 2
            $debtAnalysis.DebtCategories.CodeComplexity.Items += @{
                Type = "Technical Debt Markers"
                File = $fileMetrics.Path
                Metric = "$($todoComments.Count) TODO/FIXME"
                DebtScore = $debtScore
                Recommendation = "Address TODOs or create proper tickets"
            }
            $debtAnalysis.DebtCategories.CodeComplexity.Score += $debtScore
        }
    }
    
    # Phase 2: Code Duplication Analysis
    Write-Host "`n🔍 Phase 2: Detecting code duplication..." -ForegroundColor Yellow
    
    $hashBlocks = @{}
    $duplicates = @()
    
    foreach ($file in $sourceFiles | Select-Object -First 100) {
        $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
        if ($lines.Count -lt 10) { continue }
        
        for ($i = 0; $i -le ($lines.Count - 10); $i++) {
            $block = $lines[$i..($i+9)] -join "`n"
            $normalizedBlock = $block -replace '\s+', ' ' -replace '[^a-zA-Z0-9 ]', ''
            
            if ($normalizedBlock.Length -gt 100) {
                $hash = Get-FileHash -InputStream ([System.IO.MemoryStream]::new([System.Text.Encoding]::UTF8.GetBytes($normalizedBlock))) -Algorithm MD5
                
                if ($hashBlocks.ContainsKey($hash.Hash)) {
                    if ($hashBlocks[$hash.Hash].File -ne $file.FullName) {
                        $duplicates += @{
                            File1 = $hashBlocks[$hash.Hash].File.Replace($ProjectPath, ".")
                            Line1 = $hashBlocks[$hash.Hash].Line
                            File2 = $file.FullName.Replace($ProjectPath, ".")
                            Line2 = $i + 1
                        }
                    }
                } else {
                    $hashBlocks[$hash.Hash] = @{
                        File = $file.FullName
                        Line = $i + 1
                    }
                }
            }
        }
    }
    
    if ($duplicates.Count -gt 0) {
        $debtScore = [Math]::Min(50, $duplicates.Count * 3)
        $debtAnalysis.DebtCategories.Duplication.Score = $debtScore
        $debtAnalysis.DebtCategories.Duplication.Items += @{
            Type = "Code Duplication"
            Count = $duplicates.Count
            DebtScore = $debtScore
            Recommendation = "Extract common code into shared utilities"
            Examples = $duplicates | Select-Object -First 5
        }
    }
    
    # Phase 3: Dependency Analysis
    Write-Host "`n📦 Phase 3: Analyzing dependencies..." -ForegroundColor Yellow
    
    # Check for outdated packages
    if (Test-Path "package.json") {
        # Node.js project
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            $outdated = npm outdated --json 2>$null | ConvertFrom-Json -ErrorAction SilentlyContinue
            if ($outdated) {
                $outdatedCount = ($outdated.PSObject.Properties).Count
                if ($outdatedCount -gt 0) {
                    $debtScore = [Math]::Min(30, $outdatedCount * 2)
                    $debtAnalysis.DebtCategories.Dependencies.Score += $debtScore
                    $debtAnalysis.DebtCategories.Dependencies.Items += @{
                        Type = "Outdated NPM Packages"
                        Count = $outdatedCount
                        DebtScore = $debtScore
                        Recommendation = "Update dependencies to latest stable versions"
                    }
                }
            }
        }
    }
    
    if (Test-Path "*.csproj") {
        # .NET project
        $csprojFiles = Get-ChildItem -Path . -Recurse -Include "*.csproj" -File
        $totalPackages = 0
        
        foreach ($proj in $csprojFiles) {
            [xml]$projContent = Get-Content $proj.FullName
            $packages = $projContent.Project.ItemGroup.PackageReference
            $totalPackages += $packages.Count
        }
        
        if ($totalPackages -gt 50) {
            $debtScore = [Math]::Min(20, ($totalPackages - 50) / 5)
            $debtAnalysis.DebtCategories.Dependencies.Score += $debtScore
            $debtAnalysis.DebtCategories.Dependencies.Items += @{
                Type = "High Dependency Count"
                Count = $totalPackages
                DebtScore = $debtScore
                Recommendation = "Review and consolidate dependencies"
            }
        }
    }
    
    # Phase 4: Documentation Debt
    Write-Host "`n📚 Phase 4: Checking documentation..." -ForegroundColor Yellow
    
    # Check for missing documentation
    $publicMethods = 0
    $documentedMethods = 0
    
    foreach ($file in $sourceFiles | Where-Object { $_.Extension -in @(".cs", ".ts", ".js") }) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        # Count public methods
        $publicMethodMatches = [regex]::Matches($content, '(?:public|export)\s+(?:async\s+)?(?:function\s+)?(\w+)\s*\(')
        $publicMethods += $publicMethodMatches.Count
        
        # Count documented methods (with comments above)
        foreach ($method in $publicMethodMatches) {
            $methodStart = $method.Index
            $precedingText = $content.Substring([Math]::Max(0, $methodStart - 200), [Math]::Min(200, $methodStart))
            if ($precedingText -match '///|/\*\*|\*\s*@') {
                $documentedMethods++
            }
        }
    }
    
    if ($publicMethods -gt 0) {
        $docPercentage = [Math]::Round(($documentedMethods / $publicMethods) * 100)
        if ($docPercentage -lt 50) {
            $debtScore = [Math]::Min(30, (50 - $docPercentage) / 2)
            $debtAnalysis.DebtCategories.Documentation.Score = $debtScore
            $debtAnalysis.DebtCategories.Documentation.Items += @{
                Type = "Missing Documentation"
                Metric = "$docPercentage% documented"
                PublicMethods = $publicMethods
                Documented = $documentedMethods
                DebtScore = $debtScore
                Recommendation = "Document public APIs and complex logic"
            }
        }
    }
    
    # Check for README
    if (-not (Test-Path "README.md")) {
        $debtAnalysis.DebtCategories.Documentation.Score += 10
        $debtAnalysis.DebtCategories.Documentation.Items += @{
            Type = "Missing README"
            DebtScore = 10
            Recommendation = "Create comprehensive README.md"
        }
    }
    
    # Phase 5: Test Coverage Analysis
    Write-Host "`n🧪 Phase 5: Analyzing test coverage..." -ForegroundColor Yellow
    
    $testFiles = Get-ChildItem -Path . -Recurse -Include "*test*", "*spec*" -File |
        Where-Object { $_.Extension -in @(".cs", ".js", ".ts", ".py") }
    
    $testRatio = if ($sourceFiles.Count -gt 0) { [Math]::Round(($testFiles.Count / $sourceFiles.Count) * 100) } else { 0 }
    
    if ($testRatio -lt 30) {
        $debtScore = [Math]::Min(40, (30 - $testRatio) * 2)
        $debtAnalysis.DebtCategories.Testing.Score = $debtScore
        $debtAnalysis.DebtCategories.Testing.Items += @{
            Type = "Low Test Coverage"
            Metric = "$testRatio% test file ratio"
            SourceFiles = $sourceFiles.Count
            TestFiles = $testFiles.Count
            DebtScore = $debtScore
            Recommendation = "Increase test coverage to at least 80%"
        }
    }
    
    # Phase 6: Security Debt
    Write-Host "`n🔒 Phase 6: Checking security patterns..." -ForegroundColor Yellow
    
    $securityIssues = @()
    
    # Check for hardcoded secrets
    foreach ($file in $sourceFiles | Select-Object -First 100) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        
        if ($content -match 'password\s*=\s*["''][^"'']+["'']' -or
            $content -match 'api[_-]?key\s*=\s*["''][^"'']+["'']') {
            $securityIssues += @{
                Type = "Hardcoded Secrets"
                File = $file.FullName.Replace($ProjectPath, ".")
            }
        }
    }
    
    if ($securityIssues.Count -gt 0) {
        $debtScore = $securityIssues.Count * 10
        $debtAnalysis.DebtCategories.Security.Score = $debtScore
        $debtAnalysis.DebtCategories.Security.Items += @{
            Type = "Security Vulnerabilities"
            Count = $securityIssues.Count
            DebtScore = $debtScore
            Issues = $securityIssues | Select-Object -First 5
            Recommendation = "Move secrets to secure configuration"
        }
    }
    
    # Calculate total debt score
    foreach ($category in $debtAnalysis.DebtCategories.Values) {
        $debtAnalysis.TotalDebtScore += $category.Score
    }
    
    # Estimate effort
    $debtAnalysis.EstimatedEffort.Hours = [Math]::Round($debtAnalysis.TotalDebtScore * 2)
    $debtAnalysis.EstimatedEffort.Cost = $debtAnalysis.EstimatedEffort.Hours * 150  # Assuming $150/hour
    
    # Identify critical issues
    foreach ($category in $debtAnalysis.DebtCategories.GetEnumerator()) {
        foreach ($item in $category.Value.Items | Where-Object { $_.DebtScore -gt 10 }) {
            $debtAnalysis.CriticalIssues += @{
                Category = $category.Key
                Issue = $item
            }
        }
    }
    
    # Generate refactoring priorities
    $priorities = @()
    
    # Sort all issues by debt score
    $allIssues = @()
    foreach ($category in $debtAnalysis.DebtCategories.GetEnumerator()) {
        foreach ($item in $category.Value.Items) {
            $allIssues += @{
                Category = $category.Key
                Item = $item
            }
        }
    }
    
    $sortedIssues = $allIssues | Sort-Object -Property { $_.Item.DebtScore } -Descending
    
    foreach ($issue in $sortedIssues | Select-Object -First 10) {
        $debtAnalysis.RefactoringPriorities += @{
            Priority = $debtAnalysis.RefactoringPriorities.Count + 1
            Category = $issue.Category
            Type = $issue.Item.Type
            DebtScore = $issue.Item.DebtScore
            Effort = "$([Math]::Round($issue.Item.DebtScore * 2)) hours"
            Impact = if ($issue.Item.DebtScore -gt 20) { "High" } elseif ($issue.Item.DebtScore -gt 10) { "Medium" } else { "Low" }
            Recommendation = $issue.Item.Recommendation
        }
    }
    
    # Summary Report
    Write-Host "`n📊 Technical Debt Analysis Summary" -ForegroundColor Green
    Write-Host "=================================" -ForegroundColor Green
    Write-Host "Total Debt Score: $($debtAnalysis.TotalDebtScore)" -ForegroundColor $(
        if ($debtAnalysis.TotalDebtScore -lt $DebtThreshold) { "Green" }
        elseif ($debtAnalysis.TotalDebtScore -lt ($DebtThreshold * 2)) { "Yellow" }
        else { "Red" }
    )
    Write-Host "Estimated Effort: $($debtAnalysis.EstimatedEffort.Hours) hours (~`$$($debtAnalysis.EstimatedEffort.Cost))"
    
    Write-Host "`n📈 Debt by Category:" -ForegroundColor Yellow
    foreach ($category in $debtAnalysis.DebtCategories.GetEnumerator() | Sort-Object -Property { $_.Value.Score } -Descending) {
        if ($category.Value.Score -gt 0) {
            Write-Host "  $($category.Key): $($category.Value.Score) points" -ForegroundColor White
        }
    }
    
    if ($debtAnalysis.CriticalIssues.Count -gt 0) {
        Write-Host "`n🚨 Critical Issues ($($debtAnalysis.CriticalIssues.Count)):" -ForegroundColor Red
        foreach ($issue in $debtAnalysis.CriticalIssues | Select-Object -First 5) {
            Write-Host "  • [$($issue.Category)] $($issue.Issue.Type)" -ForegroundColor Yellow
            if ($issue.Issue.File) {
                Write-Host "    File: $($issue.Issue.File)" -ForegroundColor Gray
            }
            Write-Host "    Impact: $($issue.Issue.DebtScore) points" -ForegroundColor Gray
        }
    }
    
    Write-Host "`n🎯 Top Refactoring Priorities:" -ForegroundColor Cyan
    foreach ($priority in $debtAnalysis.RefactoringPriorities | Select-Object -First 5) {
        Write-Host "`n  $($priority.Priority). [$($priority.Category)] $($priority.Type)" -ForegroundColor White
        Write-Host "     Impact: $($priority.Impact) | Effort: $($priority.Effort)" -ForegroundColor Gray
        Write-Host "     → $($priority.Recommendation)" -ForegroundColor Cyan
    }
    
    # Recommendations
    Write-Host "`n💡 Strategic Recommendations:" -ForegroundColor Yellow
    
    if ($debtAnalysis.TotalDebtScore -gt ($DebtThreshold * 2)) {
        Write-Host "  • Schedule dedicated refactoring sprint" -ForegroundColor White
        Write-Host "  • Establish code quality gates in CI/CD" -ForegroundColor White
        Write-Host "  • Create technical debt backlog" -ForegroundColor White
    } elseif ($debtAnalysis.TotalDebtScore -gt $DebtThreshold) {
        Write-Host "  • Allocate 20% of sprint capacity to debt reduction" -ForegroundColor White
        Write-Host "  • Focus on high-impact, low-effort improvements" -ForegroundColor White
    } else {
        Write-Host "  • Maintain current quality standards" -ForegroundColor White
        Write-Host "  • Continue proactive refactoring" -ForegroundColor White
    }
    
    # Export report
    if ($GenerateReport) {
        $reportPath = "technical-debt-analysis-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        $debtAnalysis | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
        Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
        
        # Generate markdown report
        $mdPath = "technical-debt-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
        $markdown = @"
# Technical Debt Analysis Report

Generated: $($debtAnalysis.Timestamp)

## Executive Summary

- **Total Debt Score**: $($debtAnalysis.TotalDebtScore)
- **Estimated Effort**: $($debtAnalysis.EstimatedEffort.Hours) hours
- **Estimated Cost**: `$$($debtAnalysis.EstimatedEffort.Cost)
- **Critical Issues**: $($debtAnalysis.CriticalIssues.Count)

## Debt Distribution

| Category | Score | Percentage |
|----------|-------|------------|
$(foreach ($cat in $debtAnalysis.DebtCategories.GetEnumerator() | Sort-Object -Property { $_.Value.Score } -Descending) {
    if ($cat.Value.Score -gt 0) {
        $percentage = [Math]::Round(($cat.Value.Score / $debtAnalysis.TotalDebtScore) * 100)
        "| $($cat.Key) | $($cat.Value.Score) | $percentage% |`n"
    }
})

## Top Priorities

$(foreach ($priority in $debtAnalysis.RefactoringPriorities | Select-Object -First 10) {
    "### $($priority.Priority). $($priority.Type)`n"
    "- **Category**: $($priority.Category)`n"
    "- **Impact**: $($priority.Impact)`n"
    "- **Effort**: $($priority.Effort)`n"
    "- **Recommendation**: $($priority.Recommendation)`n`n"
})

## Action Plan

1. Address critical security issues immediately
2. Implement automated quality gates
3. Schedule refactoring sessions
4. Track debt reduction progress
5. Establish coding standards

---
*Generated by Claudify Technical Debt Analyzer*
"@
        $markdown | Out-File -FilePath $mdPath -Encoding UTF8
        Write-Host "📄 Markdown report saved to: $mdPath" -ForegroundColor Gray
    }
    
} finally {
    Pop-Location
}

# Helper functions
function Extract-MethodBody {
    param([string]$Content, [int]$StartIndex)
    
    $braceCount = 0
    $inMethod = $false
    $endIndex = $StartIndex
    
    for ($i = $StartIndex; $i -lt $Content.Length; $i++) {
        if ($Content[$i] -eq '{') {
            $braceCount++
            $inMethod = $true
        } elseif ($Content[$i] -eq '}') {
            $braceCount--
            if ($braceCount -eq 0 -and $inMethod) {
                $endIndex = $i
                break
            }
        }
    }
    
    return $Content.Substring($StartIndex, $endIndex - $StartIndex + 1)
}

function Calculate-MethodComplexity {
    param([string]$MethodBody)
    
    $complexity = 1
    $complexity += ([regex]::Matches($MethodBody, '\b(if|else if|switch|case|while|for|foreach|catch)\b')).Count
    $complexity += ([regex]::Matches($MethodBody, '(\|\||&&)')).Count
    
    return $complexity
}