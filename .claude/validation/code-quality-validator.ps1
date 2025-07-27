# Code Quality Validator - Comprehensive code quality checks
# Supports multiple languages and customizable rules

param(
    [string]$ProjectPath = ".",
    [string[]]$IncludeChecks = @("all"),  # all, complexity, duplication, standards, security, performance
    [string[]]$ExcludeChecks = @(),
    [int]$ComplexityThreshold = 10,
    [int]$DuplicationThreshold = 50,
    [switch]$AutoFix,
    [switch]$GenerateReport,
    [switch]$FailOnIssues,
    [switch]$Verbose
)

Write-Host "🎯 Code Quality Validator - Claudify Edition" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Initialize quality metrics
$qualityMetrics = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Summary = @{
        TotalFiles = 0
        TotalLines = 0
        IssuesFound = 0
        IssuesFixed = 0
        QualityScore = 100.0
    }
    Metrics = @{
        Complexity = @{
            High = 0
            Medium = 0
            Low = 0
            Average = 0
        }
        Duplication = @{
            DuplicatedLines = 0
            DuplicationRatio = 0
            DuplicatedBlocks = @()
        }
        Standards = @{
            Violations = 0
            Categories = @{}
        }
        Security = @{
            Vulnerabilities = 0
            Severity = @{
                High = 0
                Medium = 0
                Low = 0
            }
        }
        Performance = @{
            Issues = 0
            Categories = @{}
        }
    }
    FileReports = @()
    Recommendations = @()
}

# Define quality rules by language
$languageRules = @{
    "CSharp" = @{
        Extensions = @(".cs")
        Standards = @{
            MaxLineLength = 120
            MaxMethodLength = 50
            MaxClassLength = 500
            MaxParameters = 7
            MaxNesting = 4
        }
        Patterns = @{
            AsyncNaming = @{
                Pattern = "async\s+\w+\s+(\w+)\s*\("
                Rule = "Async methods should end with 'Async'"
                Check = { param($match) $match.Groups[1].Value -notmatch "Async$" }
            }
            PublicFields = @{
                Pattern = "public\s+(?!const|static readonly|readonly)\w+\s+\w+\s*[;=]"
                Rule = "Public fields should be properties"
            }
            EmptyCatch = @{
                Pattern = "catch\s*\([^)]*\)\s*\{\s*\}"
                Rule = "Empty catch blocks hide errors"
            }
        }
    }
    "TypeScript" = @{
        Extensions = @(".ts", ".tsx")
        Standards = @{
            MaxLineLength = 100
            MaxMethodLength = 40
            MaxClassLength = 400
            MaxParameters = 5
            MaxNesting = 3
        }
        Patterns = @{
            ConsoleLog = @{
                Pattern = "console\.(log|debug|trace)"
                Rule = "Remove console statements"
            }
            AnyType = @{
                Pattern = ":\s*any\b"
                Rule = "Avoid using 'any' type"
            }
            VarKeyword = @{
                Pattern = "\bvar\s+"
                Rule = "Use 'const' or 'let' instead of 'var'"
            }
        }
    }
    "JavaScript" = @{
        Extensions = @(".js", ".jsx")
        Standards = @{
            MaxLineLength = 100
            MaxMethodLength = 40
            MaxClassLength = 400
            MaxParameters = 5
            MaxNesting = 3
        }
        Patterns = @{
            ConsoleLog = @{
                Pattern = "console\.(log|debug|trace)"
                Rule = "Remove console statements"
            }
            VarKeyword = @{
                Pattern = "\bvar\s+"
                Rule = "Use 'const' or 'let' instead of 'var'"
            }
            DoubleEquals = @{
                Pattern = "[^=!]==[^=]"
                Rule = "Use === instead of =="
            }
        }
    }
}

# Check types to process
$checksToRun = @()
if ($IncludeChecks -contains "all") {
    $checksToRun = @("complexity", "duplication", "standards", "security", "performance")
} else {
    $checksToRun = $IncludeChecks
}
$checksToRun = $checksToRun | Where-Object { $_ -notin $ExcludeChecks }

Write-Host "`nRunning checks: $($checksToRun -join ', ')" -ForegroundColor Yellow

# Helper functions
function Get-CyclomaticComplexity {
    param([string]$Code)
    
    $complexity = 1
    
    # Decision points
    $decisionPatterns = @(
        '\b(if|else if|elseif|elif)\b',
        '\b(for|foreach|while|do)\b',
        '\b(case|when)\b',
        '\b(catch|except)\b',
        '\?',  # Ternary operator
        '&&|\|\|',  # Logical operators
        '\?\?',  # Null coalescing
        '\?\.', # Null conditional
        '=>'  # Lambda expressions
    )
    
    foreach ($pattern in $decisionPatterns) {
        $matches = [regex]::Matches($Code, $pattern)
        $complexity += $matches.Count
    }
    
    return $complexity
}

function Get-CodeDuplication {
    param([string[]]$Lines, [int]$MinBlockSize = 6)
    
    $duplicates = @()
    $hashes = @{}
    
    for ($i = 0; $i -le ($Lines.Count - $MinBlockSize); $i++) {
        $block = $Lines[$i..($i + $MinBlockSize - 1)] -join "`n"
        $normalizedBlock = $block -replace '\s+', ' ' -replace '[^a-zA-Z0-9 {}();\[\]]', ''
        
        if ($normalizedBlock.Length -gt 50) {
            $hash = [System.Security.Cryptography.MD5]::Create().ComputeHash([System.Text.Encoding]::UTF8.GetBytes($normalizedBlock))
            $hashString = [BitConverter]::ToString($hash).Replace("-", "")
            
            if ($hashes.ContainsKey($hashString)) {
                $duplicates += @{
                    FirstLine = $hashes[$hashString]
                    SecondLine = $i + 1
                    LineCount = $MinBlockSize
                    Hash = $hashString
                }
            } else {
                $hashes[$hashString] = $i + 1
            }
        }
    }
    
    return $duplicates
}

function Test-CodeStandards {
    param($FilePath, $Content, $Language)
    
    $issues = @()
    $rules = $languageRules[$Language]
    
    if (-not $rules) { return $issues }
    
    $lines = $Content -split "`n"
    
    # Line length check
    $longLines = $lines | Where-Object { $_.Length -gt $rules.Standards.MaxLineLength }
    if ($longLines.Count -gt 0) {
        $issues += @{
            Type = "LineTooLong"
            Count = $longLines.Count
            Message = "$($longLines.Count) lines exceed $($rules.Standards.MaxLineLength) characters"
            Severity = "Warning"
        }
    }
    
    # Method length check (simplified)
    $methods = [regex]::Matches($Content, '(public|private|protected|internal|function|def)\s+\w+\s*\([^)]*\)\s*\{', [System.Text.RegularExpressions.RegexOptions]::Multiline)
    foreach ($method in $methods) {
        $methodEnd = $Content.IndexOf("}", $method.Index)
        if ($methodEnd -gt $method.Index) {
            $methodContent = $Content.Substring($method.Index, $methodEnd - $method.Index)
            $methodLines = ($methodContent -split "`n").Count
            
            if ($methodLines -gt $rules.Standards.MaxMethodLength) {
                $issues += @{
                    Type = "MethodTooLong"
                    Method = $method.Value
                    Lines = $methodLines
                    Message = "Method exceeds $($rules.Standards.MaxMethodLength) lines"
                    Severity = "Warning"
                }
            }
        }
    }
    
    # Pattern violations
    foreach ($patternName in $rules.Patterns.Keys) {
        $pattern = $rules.Patterns[$patternName]
        $matches = [regex]::Matches($Content, $pattern.Pattern)
        
        foreach ($match in $matches) {
            $isViolation = $true
            
            if ($pattern.Check) {
                $isViolation = & $pattern.Check $match
            }
            
            if ($isViolation) {
                $issues += @{
                    Type = "PatternViolation"
                    Pattern = $patternName
                    Match = $match.Value
                    Message = $pattern.Rule
                    Severity = "Warning"
                    Line = ($Content.Substring(0, $match.Index) -split "`n").Count
                }
            }
        }
    }
    
    return $issues
}

function Test-SecurityIssues {
    param($FilePath, $Content)
    
    $issues = @()
    
    $securityPatterns = @{
        "HardcodedSecret" = @{
            Patterns = @(
                'password\s*=\s*["\'][^"\']+["\']',
                'api[_-]?key\s*=\s*["\'][^"\']+["\']',
                'secret\s*=\s*["\'][^"\']+["\']',
                'token\s*=\s*["\'][^"\']+["\']'
            )
            Severity = "High"
            Message = "Possible hardcoded secret"
        }
        "SQLInjection" = @{
            Patterns = @(
                'string\.Format.*?(?:SELECT|INSERT|UPDATE|DELETE)',
                '\+\s*["\']?\s*(?:SELECT|INSERT|UPDATE|DELETE)',
                'ExecuteSqlCommand\([^@]',
                'query\s*=.*?\+.*?(?:SELECT|INSERT|UPDATE|DELETE)'
            )
            Severity = "High"
            Message = "Possible SQL injection vulnerability"
        }
        "InsecureRandom" = @{
            Patterns = @(
                '\bnew Random\(\)',
                'Math\.random\(\)',
                'rand\(\)'
            )
            Severity = "Medium"
            Message = "Insecure random number generation"
        }
        "WeakCrypto" = @{
            Patterns = @(
                '\b(?:MD5|SHA1)\.Create\(',
                'DES\.Create\(',
                'TripleDES\.Create\('
            )
            Severity = "High"
            Message = "Weak cryptographic algorithm"
        }
    }
    
    foreach ($issueType in $securityPatterns.Keys) {
        $config = $securityPatterns[$issueType]
        
        foreach ($pattern in $config.Patterns) {
            $matches = [regex]::Matches($Content, $pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
            
            foreach ($match in $matches) {
                $issues += @{
                    Type = $issueType
                    Severity = $config.Severity
                    Message = $config.Message
                    Match = $match.Value
                    Line = ($Content.Substring(0, $match.Index) -split "`n").Count
                }
            }
        }
    }
    
    return $issues
}

function Test-PerformanceIssues {
    param($FilePath, $Content, $Language)
    
    $issues = @()
    
    $performancePatterns = @{
        "N+1Query" = @{
            Pattern = 'foreach.*?\{[\s\S]*?(?:await|\.Result|\.Wait\(\))[\s\S]*?\}'
            Message = "Possible N+1 query problem in loop"
            Languages = @("CSharp", "TypeScript")
        }
        "SynchronousIO" = @{
            Pattern = '(?<!await\s+)File\.(?:ReadAllText|WriteAllText|ReadAllLines)\('
            Message = "Use async file operations"
            Languages = @("CSharp")
        }
        "StringConcatenationInLoop" = @{
            Pattern = '(?:for|while|foreach)[\s\S]*?\+='
            Message = "String concatenation in loop - use StringBuilder"
            Languages = @("CSharp", "Java")
        }
        "UnboundedCache" = @{
            Pattern = 'Dictionary<.*?>|Map<.*?>|cache\[|cache\.set\('
            Message = "Ensure cache has size limits"
            Languages = @("CSharp", "TypeScript", "JavaScript")
        }
    }
    
    foreach ($issueType in $performancePatterns.Keys) {
        $config = $performancePatterns[$issueType]
        
        if ($config.Languages -notcontains $Language) { continue }
        
        $matches = [regex]::Matches($Content, $config.Pattern)
        
        foreach ($match in $matches) {
            $issues += @{
                Type = $issueType
                Message = $config.Message
                Match = $match.Value.Substring(0, [Math]::Min(100, $match.Value.Length))
                Line = ($Content.Substring(0, $match.Index) -split "`n").Count
            }
        }
    }
    
    return $issues
}

# Main analysis
$files = Get-ChildItem -Path $ProjectPath -Include "*.cs", "*.ts", "*.js", "*.tsx", "*.jsx" -Recurse |
    Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build|test|\.min\." }

$qualityMetrics.Summary.TotalFiles = $files.Count

foreach ($file in $files) {
    if ($Verbose) {
        Write-Host "  Analyzing: $($file.Name)" -ForegroundColor Gray
    }
    
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    $lines = $content -split "`n"
    $qualityMetrics.Summary.TotalLines += $lines.Count
    
    # Determine language
    $language = $null
    foreach ($lang in $languageRules.Keys) {
        if ($file.Extension -in $languageRules[$lang].Extensions) {
            $language = $lang
            break
        }
    }
    
    if (-not $language) { continue }
    
    $fileReport = @{
        File = $file.FullName
        Language = $language
        Lines = $lines.Count
        Issues = @()
        Complexity = 0
        QualityScore = 100
    }
    
    # Run checks
    if ("complexity" -in $checksToRun) {
        $complexity = Get-CyclomaticComplexity -Code $content
        $fileReport.Complexity = $complexity
        
        if ($complexity -gt $ComplexityThreshold * 2) {
            $qualityMetrics.Metrics.Complexity.High++
            $fileReport.Issues += @{
                Type = "HighComplexity"
                Value = $complexity
                Message = "Very high cyclomatic complexity: $complexity"
                Severity = "Error"
            }
        } elseif ($complexity -gt $ComplexityThreshold) {
            $qualityMetrics.Metrics.Complexity.Medium++
            $fileReport.Issues += @{
                Type = "MediumComplexity"
                Value = $complexity
                Message = "High cyclomatic complexity: $complexity"
                Severity = "Warning"
            }
        } else {
            $qualityMetrics.Metrics.Complexity.Low++
        }
    }
    
    if ("duplication" -in $checksToRun) {
        $duplicates = Get-CodeDuplication -Lines $lines
        if ($duplicates.Count -gt 0) {
            $duplicatedLines = $duplicates.Count * 6  # Assuming min block size of 6
            $qualityMetrics.Metrics.Duplication.DuplicatedLines += $duplicatedLines
            
            $fileReport.Issues += @{
                Type = "CodeDuplication"
                Count = $duplicates.Count
                Message = "$($duplicates.Count) duplicated blocks found"
                Severity = "Warning"
                Duplicates = $duplicates | Select-Object -First 3
            }
        }
    }
    
    if ("standards" -in $checksToRun) {
        $standardIssues = Test-CodeStandards -FilePath $file.FullName -Content $content -Language $language
        $fileReport.Issues += $standardIssues
        $qualityMetrics.Metrics.Standards.Violations += $standardIssues.Count
    }
    
    if ("security" -in $checksToRun) {
        $securityIssues = Test-SecurityIssues -FilePath $file.FullName -Content $content
        $fileReport.Issues += $securityIssues
        
        foreach ($issue in $securityIssues) {
            $qualityMetrics.Metrics.Security.Vulnerabilities++
            $qualityMetrics.Metrics.Security.Severity[$issue.Severity]++
        }
    }
    
    if ("performance" -in $checksToRun) {
        $performanceIssues = Test-PerformanceIssues -FilePath $file.FullName -Content $content -Language $language
        $fileReport.Issues += $performanceIssues
        $qualityMetrics.Metrics.Performance.Issues += $performanceIssues.Count
    }
    
    # Calculate file quality score
    $issueWeight = 0
    foreach ($issue in $fileReport.Issues) {
        switch ($issue.Severity) {
            "Error" { $issueWeight += 10 }
            "Warning" { $issueWeight += 5 }
            default { $issueWeight += 2 }
        }
    }
    
    $fileReport.QualityScore = [Math]::Max(0, 100 - $issueWeight)
    $qualityMetrics.FileReports += $fileReport
    $qualityMetrics.Summary.IssuesFound += $fileReport.Issues.Count
    
    # Auto-fix if requested
    if ($AutoFix -and $fileReport.Issues.Count -gt 0) {
        $fixedContent = $content
        $fixed = $false
        
        foreach ($issue in $fileReport.Issues) {
            if ($issue.Type -eq "PatternViolation" -and $issue.Pattern -eq "VarKeyword") {
                $fixedContent = $fixedContent -replace '\bvar\s+', 'let '
                $fixed = $true
                $qualityMetrics.Summary.IssuesFixed++
            }
            elseif ($issue.Type -eq "PatternViolation" -and $issue.Pattern -eq "DoubleEquals") {
                $fixedContent = $fixedContent -replace '([^=!])={2}([^=])', '$1===$2'
                $fixed = $true
                $qualityMetrics.Summary.IssuesFixed++
            }
        }
        
        if ($fixed) {
            $fixedContent | Out-File -FilePath $file.FullName -Encoding UTF8
            Write-Host "  ✓ Fixed issues in: $($file.Name)" -ForegroundColor Green
        }
    }
}

# Calculate overall metrics
if ($qualityMetrics.Summary.TotalFiles -gt 0) {
    $avgComplexity = ($qualityMetrics.FileReports | Measure-Object -Property Complexity -Average).Average
    $qualityMetrics.Metrics.Complexity.Average = [Math]::Round($avgComplexity, 2)
    
    if ($qualityMetrics.Summary.TotalLines -gt 0) {
        $qualityMetrics.Metrics.Duplication.DuplicationRatio = [Math]::Round(($qualityMetrics.Metrics.Duplication.DuplicatedLines / $qualityMetrics.Summary.TotalLines) * 100, 2)
    }
}

# Calculate overall quality score
$totalIssueWeight = 0
foreach ($report in $qualityMetrics.FileReports) {
    foreach ($issue in $report.Issues) {
        switch ($issue.Severity) {
            "Error" { $totalIssueWeight += 0.5 }
            "Warning" { $totalIssueWeight += 0.2 }
            default { $totalIssueWeight += 0.1 }
        }
    }
}

$qualityMetrics.Summary.QualityScore = [Math]::Max(0, [Math]::Round(100 - $totalIssueWeight, 2))

# Generate recommendations
if ($qualityMetrics.Metrics.Complexity.High -gt 0) {
    $qualityMetrics.Recommendations += "Refactor high-complexity methods using extract method pattern"
}

if ($qualityMetrics.Metrics.Duplication.DuplicationRatio -gt 5) {
    $qualityMetrics.Recommendations += "Extract duplicated code into shared utilities"
}

if ($qualityMetrics.Metrics.Security.Severity.High -gt 0) {
    $qualityMetrics.Recommendations += "Address high-severity security issues immediately"
}

if ($qualityMetrics.Metrics.Performance.Issues -gt 10) {
    $qualityMetrics.Recommendations += "Review and optimize performance hotspots"
}

# Display results
Write-Host "`n📊 Code Quality Report" -ForegroundColor Green
Write-Host "=====================" -ForegroundColor Green
Write-Host "Files Analyzed: $($qualityMetrics.Summary.TotalFiles)" -ForegroundColor White
Write-Host "Total Lines: $($qualityMetrics.Summary.TotalLines)" -ForegroundColor White
Write-Host "Issues Found: $($qualityMetrics.Summary.IssuesFound)" -ForegroundColor $(if ($qualityMetrics.Summary.IssuesFound -gt 0) { "Yellow" } else { "Green" })

if ($AutoFix) {
    Write-Host "Issues Fixed: $($qualityMetrics.Summary.IssuesFixed)" -ForegroundColor Cyan
}

Write-Host "`nQuality Score: $($qualityMetrics.Summary.QualityScore)/100" -ForegroundColor $(
    if ($qualityMetrics.Summary.QualityScore -ge 80) { "Green" }
    elseif ($qualityMetrics.Summary.QualityScore -ge 60) { "Yellow" }
    else { "Red" }
)

# Metrics breakdown
Write-Host "`n📈 Metrics Breakdown:" -ForegroundColor Yellow

if ("complexity" -in $checksToRun) {
    Write-Host "  Complexity:" -ForegroundColor White
    Write-Host "    Average: $($qualityMetrics.Metrics.Complexity.Average)" -ForegroundColor Gray
    Write-Host "    High: $($qualityMetrics.Metrics.Complexity.High) files" -ForegroundColor $(if ($qualityMetrics.Metrics.Complexity.High -gt 0) { "Red" } else { "Gray" })
    Write-Host "    Medium: $($qualityMetrics.Metrics.Complexity.Medium) files" -ForegroundColor $(if ($qualityMetrics.Metrics.Complexity.Medium -gt 0) { "Yellow" } else { "Gray" })
}

if ("duplication" -in $checksToRun) {
    Write-Host "  Duplication:" -ForegroundColor White
    Write-Host "    Ratio: $($qualityMetrics.Metrics.Duplication.DuplicationRatio)%" -ForegroundColor $(if ($qualityMetrics.Metrics.Duplication.DuplicationRatio -gt 5) { "Yellow" } else { "Gray" })
}

if ("security" -in $checksToRun -and $qualityMetrics.Metrics.Security.Vulnerabilities -gt 0) {
    Write-Host "  Security:" -ForegroundColor White
    Write-Host "    High: $($qualityMetrics.Metrics.Security.Severity.High)" -ForegroundColor Red
    Write-Host "    Medium: $($qualityMetrics.Metrics.Security.Severity.Medium)" -ForegroundColor Yellow
    Write-Host "    Low: $($qualityMetrics.Metrics.Security.Severity.Low)" -ForegroundColor Gray
}

# Top issues
$topIssues = $qualityMetrics.FileReports | 
    Where-Object { $_.Issues.Count -gt 0 } |
    Sort-Object -Property { $_.Issues.Count } -Descending |
    Select-Object -First 5

if ($topIssues.Count -gt 0) {
    Write-Host "`n🔍 Files with Most Issues:" -ForegroundColor Yellow
    foreach ($file in $topIssues) {
        Write-Host "  $([System.IO.Path]::GetFileName($file.File)): $($file.Issues.Count) issues (Score: $($file.QualityScore))" -ForegroundColor White
    }
}

# Recommendations
if ($qualityMetrics.Recommendations.Count -gt 0) {
    Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
    foreach ($rec in $qualityMetrics.Recommendations) {
        Write-Host "  • $rec" -ForegroundColor White
    }
}

# Generate report
if ($GenerateReport) {
    $reportPath = "code-quality-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $qualityMetrics | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
    
    # Generate HTML report
    $htmlPath = "code-quality-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').html"
    $html = @"
<!DOCTYPE html>
<html>
<head>
    <title>Code Quality Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .metric { display: inline-block; margin: 10px; padding: 20px; border: 1px solid #ddd; border-radius: 5px; }
        .score { font-size: 48px; font-weight: bold; }
        .high { color: #d32f2f; }
        .medium { color: #f57c00; }
        .low { color: #388e3c; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f5f5f5; }
    </style>
</head>
<body>
    <h1>Code Quality Report</h1>
    <p>Generated: $($qualityMetrics.Timestamp)</p>
    
    <div class="metric">
        <div class="score $(if ($qualityMetrics.Summary.QualityScore -ge 80) { 'low' } elseif ($qualityMetrics.Summary.QualityScore -ge 60) { 'medium' } else { 'high' })">
            $($qualityMetrics.Summary.QualityScore)
        </div>
        <div>Quality Score</div>
    </div>
    
    <h2>Top Issues</h2>
    <table>
        <tr><th>File</th><th>Issues</th><th>Score</th></tr>
        $(foreach ($file in $topIssues) {
            "<tr><td>$([System.IO.Path]::GetFileName($file.File))</td><td>$($file.Issues.Count)</td><td>$($file.QualityScore)</td></tr>"
        })
    </table>
</body>
</html>
"@
    
    $html | Out-File -FilePath $htmlPath -Encoding UTF8
    Write-Host "📄 HTML report saved to: $htmlPath" -ForegroundColor Gray
}

# Exit code for CI/CD
if ($FailOnIssues) {
    if ($qualityMetrics.Metrics.Security.Severity.High -gt 0) {
        Write-Host "`n❌ Critical security issues found!" -ForegroundColor Red
        exit 2
    }
    if ($qualityMetrics.Summary.QualityScore -lt 60) {
        Write-Host "`n❌ Code quality below threshold!" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n✨ Code quality analysis complete!" -ForegroundColor Green

# Return metrics for automation
return $qualityMetrics