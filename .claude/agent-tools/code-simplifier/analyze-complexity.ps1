# Complexity Analysis Script - Code Simplification Tool
# Usage: .\analyze-complexity.ps1 [-ProjectPath <path>] [-MaxComplexity 10] [-Refactor]

param(
    [string]$ProjectPath = ".",
    [int]$MaxComplexity = 10,
    [switch]$Refactor,
    [switch]$Verbose
)

Write-Host "🔧 Complexity Analysis & Simplification Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan

Push-Location $ProjectPath

try {
    # Initialize results
    $results = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        ComplexFiles = @()
        RefactoringCandidates = @()
        Patterns = @{
            DuplicateCode = @()
            LongMethods = @()
            DeepNesting = @()
            GodClasses = @()
        }
        Metrics = @{
            AverageComplexity = 0
            MaxComplexity = 0
            TotalComplexMethods = 0
        }
        Suggestions = @()
    }
    
    # Detect file types to analyze
    $filePatterns = @("*.cs", "*.js", "*.ts", "*.py", "*.java")
    $files = Get-ChildItem -Path . -Recurse -Include $filePatterns -File |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build|test|\.min\." }
    
    Write-Host "`n📊 Analyzing $($files.Count) files for complexity..." -ForegroundColor Yellow
    
    # 1. Cyclomatic Complexity Analysis
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        $fileComplexity = @{
            Path = $file.FullName.Replace($ProjectPath, ".")
            Methods = @()
            TotalComplexity = 0
        }
        
        # Language-specific analysis
        switch ($file.Extension) {
            ".cs" {
                # C# method extraction
                $methods = [regex]::Matches($content, '(?:public|private|protected|internal)\s+(?:static\s+)?(?:async\s+)?(?:Task<.*?>|void|[\w<>]+)\s+(\w+)\s*\([^)]*\)\s*{')
                
                foreach ($method in $methods) {
                    $methodName = $method.Groups[1].Value
                    $methodBody = Extract-MethodBody $content $method.Index
                    $complexity = Calculate-Complexity $methodBody
                    
                    if ($complexity -gt $MaxComplexity) {
                        $fileComplexity.Methods += @{
                            Name = $methodName
                            Complexity = $complexity
                            StartLine = ($content.Substring(0, $method.Index) -split "`n").Count
                            Issues = Analyze-MethodIssues $methodBody
                        }
                    }
                    
                    $fileComplexity.TotalComplexity += $complexity
                }
            }
            
            {$_ -in ".js", ".ts"} {
                # JavaScript/TypeScript analysis
                $functions = [regex]::Matches($content, '(?:function\s+(\w+)|(\w+)\s*[:=]\s*(?:async\s+)?(?:function|\([^)]*\)\s*=>))')
                
                foreach ($function in $functions) {
                    $functionName = if ($function.Groups[1].Value) { $function.Groups[1].Value } else { $function.Groups[2].Value }
                    $functionBody = Extract-FunctionBody $content $function.Index
                    $complexity = Calculate-Complexity $functionBody
                    
                    if ($complexity -gt $MaxComplexity) {
                        $fileComplexity.Methods += @{
                            Name = $functionName
                            Complexity = $complexity
                            StartLine = ($content.Substring(0, $function.Index) -split "`n").Count
                            Issues = Analyze-MethodIssues $functionBody
                        }
                    }
                    
                    $fileComplexity.TotalComplexity += $complexity
                }
            }
        }
        
        if ($fileComplexity.Methods.Count -gt 0) {
            $results.ComplexFiles += $fileComplexity
        }
    }
    
    # 2. Pattern Detection
    Write-Host "`n🔍 Detecting complexity patterns..." -ForegroundColor Yellow
    
    # Duplicate code detection
    $codeBlocks = @{}
    foreach ($file in $files | Select-Object -First 50) {
        $lines = Get-Content $file.FullName -ErrorAction SilentlyContinue
        if (-not $lines) { continue }
        
        for ($i = 0; $i -lt ($lines.Count - 10); $i++) {
            $block = ($lines[$i..($i+9)] | Where-Object { $_.Trim() -ne "" }) -join "`n"
            $normalizedBlock = $block -replace '\s+', ' ' -replace '[\{\}\(\)]', ''
            
            if ($normalizedBlock.Length -gt 100) {
                $hash = Get-StringHash $normalizedBlock
                
                if ($codeBlocks.ContainsKey($hash)) {
                    $results.Patterns.DuplicateCode += @{
                        File1 = $codeBlocks[$hash].File
                        Line1 = $codeBlocks[$hash].Line
                        File2 = $file.FullName.Replace($ProjectPath, ".")
                        Line2 = $i + 1
                        Size = 10
                    }
                } else {
                    $codeBlocks[$hash] = @{
                        File = $file.FullName.Replace($ProjectPath, ".")
                        Line = $i + 1
                    }
                }
            }
        }
    }
    
    # Long method detection
    foreach ($complexFile in $results.ComplexFiles) {
        foreach ($method in $complexFile.Methods) {
            if ($method.Issues.LineCount -gt 50) {
                $results.Patterns.LongMethods += @{
                    File = $complexFile.Path
                    Method = $method.Name
                    Lines = $method.Issues.LineCount
                    Complexity = $method.Complexity
                }
            }
            
            if ($method.Issues.MaxNesting -gt 4) {
                $results.Patterns.DeepNesting += @{
                    File = $complexFile.Path
                    Method = $method.Name
                    MaxDepth = $method.Issues.MaxNesting
                }
            }
        }
    }
    
    # God class detection
    $classComplexity = $results.ComplexFiles | Group-Object Path | ForEach-Object {
        @{
            File = $_.Name
            TotalComplexity = ($_.Group.Methods | Measure-Object -Property Complexity -Sum).Sum
            MethodCount = $_.Group.Methods.Count
        }
    }
    
    $godClasses = $classComplexity | Where-Object { $_.TotalComplexity -gt 100 -or $_.MethodCount -gt 20 }
    $results.Patterns.GodClasses = $godClasses
    
    # 3. Calculate metrics
    $allComplexities = $results.ComplexFiles.Methods.Complexity
    if ($allComplexities.Count -gt 0) {
        $results.Metrics.AverageComplexity = [Math]::Round(($allComplexities | Measure-Object -Average).Average, 2)
        $results.Metrics.MaxComplexity = ($allComplexities | Measure-Object -Maximum).Maximum
        $results.Metrics.TotalComplexMethods = $allComplexities.Count
    }
    
    # 4. Generate refactoring suggestions
    Write-Host "`n💡 Generating refactoring suggestions..." -ForegroundColor Yellow
    
    foreach ($complexFile in $results.ComplexFiles) {
        foreach ($method in $complexFile.Methods) {
            $suggestion = @{
                File = $complexFile.Path
                Method = $method.Name
                Complexity = $method.Complexity
                Techniques = @()
            }
            
            # Suggest techniques based on issues
            if ($method.Issues.ConditionalCount -gt 5) {
                $suggestion.Techniques += "Extract conditional logic into separate methods"
                $suggestion.Techniques += "Consider using Strategy pattern for complex conditionals"
            }
            
            if ($method.Issues.MaxNesting -gt 3) {
                $suggestion.Techniques += "Use early returns to reduce nesting"
                $suggestion.Techniques += "Extract nested logic into helper methods"
            }
            
            if ($method.Issues.LineCount -gt 30) {
                $suggestion.Techniques += "Split into smaller, focused methods"
                $suggestion.Techniques += "Apply Single Responsibility Principle"
            }
            
            if ($method.Issues.ParameterCount -gt 3) {
                $suggestion.Techniques += "Use Parameter Object pattern"
                $suggestion.Techniques += "Consider Builder pattern for complex initialization"
            }
            
            $results.RefactoringCandidates += $suggestion
        }
    }
    
    # Summary Report
    Write-Host "`n📈 Complexity Analysis Summary" -ForegroundColor Green
    Write-Host "=============================" -ForegroundColor Green
    Write-Host "Files Analyzed: $($files.Count)"
    Write-Host "Complex Methods Found: $($results.Metrics.TotalComplexMethods)"
    Write-Host "Average Complexity: $($results.Metrics.AverageComplexity)"
    Write-Host "Maximum Complexity: $($results.Metrics.MaxComplexity)"
    
    # Pattern summary
    Write-Host "`n🔍 Complexity Patterns:" -ForegroundColor Yellow
    Write-Host "  Duplicate Code Blocks: $($results.Patterns.DuplicateCode.Count)"
    Write-Host "  Long Methods: $($results.Patterns.LongMethods.Count)"
    Write-Host "  Deep Nesting: $($results.Patterns.DeepNesting.Count)"
    Write-Host "  God Classes: $($results.Patterns.GodClasses.Count)"
    
    # Top offenders
    if ($results.ComplexFiles.Count -gt 0) {
        Write-Host "`n🚨 Top 5 Most Complex Methods:" -ForegroundColor Red
        $topMethods = $results.ComplexFiles.Methods | Sort-Object -Property Complexity -Descending | Select-Object -First 5
        
        foreach ($method in $topMethods) {
            $file = ($results.ComplexFiles | Where-Object { $_.Methods -contains $method }).Path
            Write-Host "  $($method.Name) in $file - Complexity: $($method.Complexity)" -ForegroundColor Yellow
        }
    }
    
    # Refactoring suggestions
    if ($results.RefactoringCandidates.Count -gt 0) {
        Write-Host "`n🔧 Refactoring Suggestions:" -ForegroundColor Cyan
        
        foreach ($candidate in $results.RefactoringCandidates | Select-Object -First 5) {
            Write-Host "`n  📍 $($candidate.Method) in $($candidate.File)" -ForegroundColor White
            Write-Host "     Complexity: $($candidate.Complexity)" -ForegroundColor Gray
            foreach ($technique in $candidate.Techniques) {
                Write-Host "     → $technique" -ForegroundColor Cyan
            }
        }
    }
    
    # Export detailed results
    $outputPath = Join-Path $ProjectPath "complexity-analysis-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "`n📄 Detailed results saved to: $outputPath" -ForegroundColor Gray
    
    # Generate refactoring examples if requested
    if ($Refactor -and $results.RefactoringCandidates.Count -gt 0) {
        Write-Host "`n📝 Refactoring Example:" -ForegroundColor Cyan
        $example = $results.RefactoringCandidates | Select-Object -First 1
        
        Write-Host @"

Original Method: $($example.Method) (Complexity: $($example.Complexity))

Suggested Refactoring:
1. Extract Method Pattern
   - Identify logical sections
   - Create focused helper methods
   - Reduce cyclomatic complexity

2. Guard Clause Pattern
   - Replace nested if with early returns
   - Improve readability

3. Replace Conditional with Polymorphism
   - For complex type-based conditionals
   - Use inheritance or interfaces

Example transformation available in: refactoring-examples.md
"@
    }
    
} finally {
    Pop-Location
}

# Helper Functions
function Calculate-Complexity {
    param([string]$Code)
    
    $complexity = 1  # Base complexity
    
    # Count control flow statements
    $complexity += ([regex]::Matches($Code, '\b(if|else if|switch|case|while|for|foreach|do|catch)\b', 'IgnoreCase')).Count
    
    # Count logical operators
    $complexity += ([regex]::Matches($Code, '(\|\||&&)', 'IgnoreCase')).Count
    
    # Count ternary operators
    $complexity += ([regex]::Matches($Code, '\?.*?:', 'IgnoreCase')).Count
    
    return $complexity
}

function Extract-MethodBody {
    param([string]$Content, [int]$StartIndex)
    
    $braceCount = 0
    $inMethod = $false
    $methodBody = ""
    
    for ($i = $StartIndex; $i -lt $Content.Length; $i++) {
        $char = $Content[$i]
        
        if ($char -eq '{') {
            $braceCount++
            $inMethod = $true
        }
        elseif ($char -eq '}') {
            $braceCount--
        }
        
        if ($inMethod) {
            $methodBody += $char
            
            if ($braceCount -eq 0) {
                break
            }
        }
    }
    
    return $methodBody
}

function Extract-FunctionBody {
    param([string]$Content, [int]$StartIndex)
    
    # Similar to Extract-MethodBody but handles JS/TS syntax
    return Extract-MethodBody $Content $StartIndex
}

function Analyze-MethodIssues {
    param([string]$MethodBody)
    
    $issues = @{
        LineCount = ($MethodBody -split "`n").Count
        ConditionalCount = ([regex]::Matches($MethodBody, '\b(if|switch)\b')).Count
        LoopCount = ([regex]::Matches($MethodBody, '\b(for|while|foreach|do)\b')).Count
        MaxNesting = 0
        ParameterCount = 0
    }
    
    # Calculate max nesting
    $currentNesting = 0
    $maxNesting = 0
    
    foreach ($char in $MethodBody.ToCharArray()) {
        if ($char -eq '{') {
            $currentNesting++
            if ($currentNesting -gt $maxNesting) {
                $maxNesting = $currentNesting
            }
        }
        elseif ($char -eq '}') {
            $currentNesting--
        }
    }
    
    $issues.MaxNesting = $maxNesting
    
    return $issues
}

function Get-StringHash {
    param([string]$String)
    
    $hasher = [System.Security.Cryptography.MD5]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    $hash = $hasher.ComputeHash($bytes)
    return [System.BitConverter]::ToString($hash).Replace("-", "")
}