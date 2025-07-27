# Test Coverage Analyzer - Analyzes test coverage and quality
# Supports multiple test frameworks and languages

param(
    [string]$ProjectPath = ".",
    [string]$TestFramework = "auto",  # auto, xunit, nunit, jest, mocha, pytest
    [int]$CoverageThreshold = 80,
    [switch]$GenerateMissingTests,
    [switch]$RunTests,
    [switch]$GenerateReport,
    [switch]$Verbose
)

Write-Host "🧪 Test Coverage Analyzer - Claudify Edition" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Initialize coverage analysis
$coverageAnalysis = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Summary = @{
        TotalFiles = 0
        TestedFiles = 0
        TotalMethods = 0
        TestedMethods = 0
        LineCoverage = 0
        BranchCoverage = 0
        TestFiles = 0
        TotalTests = 0
    }
    Framework = $TestFramework
    Coverage = @{
        ByFile = @()
        ByNamespace = @{}
        ByComponent = @{}
    }
    MissingTests = @()
    TestQuality = @{
        AssertionDensity = 0
        TestNaming = @()
        TestStructure = @()
    }
    Recommendations = @()
}

# Auto-detect test framework
if ($TestFramework -eq "auto") {
    Write-Host "`nDetecting test framework..." -ForegroundColor Yellow
    
    # .NET test frameworks
    if (Get-ChildItem -Path $ProjectPath -Include "*.csproj" -Recurse | 
        Select-String -Pattern "xunit|XUnit" -Quiet) {
        $TestFramework = "xunit"
        Write-Host "✓ Detected xUnit" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $ProjectPath -Include "*.csproj" -Recurse | 
        Select-String -Pattern "nunit|NUnit" -Quiet) {
        $TestFramework = "nunit"
        Write-Host "✓ Detected NUnit" -ForegroundColor Green
    }
    # JavaScript test frameworks
    elseif (Test-Path (Join-Path $ProjectPath "package.json")) {
        $packageJson = Get-Content (Join-Path $ProjectPath "package.json") -Raw | ConvertFrom-Json
        if ($packageJson.devDependencies.jest -or $packageJson.dependencies.jest) {
            $TestFramework = "jest"
            Write-Host "✓ Detected Jest" -ForegroundColor Green
        }
        elseif ($packageJson.devDependencies.mocha -or $packageJson.dependencies.mocha) {
            $TestFramework = "mocha"
            Write-Host "✓ Detected Mocha" -ForegroundColor Green
        }
    }
    # Python test framework
    elseif (Get-ChildItem -Path $ProjectPath -Include "test_*.py", "*_test.py" -Recurse) {
        $TestFramework = "pytest"
        Write-Host "✓ Detected pytest" -ForegroundColor Green
    }
}

$coverageAnalysis.Framework = $TestFramework

# Define test patterns by framework
$testPatterns = @{
    "xunit" = @{
        TestFilePattern = @("*Test.cs", "*Tests.cs", "*Spec.cs")
        TestMethodPattern = '\[Fact\]|\[Theory\]'
        AssertPattern = 'Assert\.'
        Language = "CSharp"
    }
    "nunit" = @{
        TestFilePattern = @("*Test.cs", "*Tests.cs", "*Spec.cs")
        TestMethodPattern = '\[Test\]|\[TestCase\]'
        AssertPattern = 'Assert\.'
        Language = "CSharp"
    }
    "jest" = @{
        TestFilePattern = @("*.test.js", "*.test.ts", "*.spec.js", "*.spec.ts")
        TestMethodPattern = '(test|it)\s*\('
        AssertPattern = 'expect\('
        Language = "JavaScript"
    }
    "mocha" = @{
        TestFilePattern = @("*.test.js", "*.test.ts", "*.spec.js", "*.spec.ts")
        TestMethodPattern = 'it\s*\('
        AssertPattern = 'expect\(|assert\.'
        Language = "JavaScript"
    }
    "pytest" = @{
        TestFilePattern = @("test_*.py", "*_test.py")
        TestMethodPattern = 'def\s+test_'
        AssertPattern = 'assert\s+'
        Language = "Python"
    }
}

# Helper functions
function Get-MethodsFromFile {
    param($FilePath, $Language)
    
    $methods = @()
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    
    if (-not $content) { return $methods }
    
    switch ($Language) {
        "CSharp" {
            $pattern = '(public|private|protected|internal)\s+(?:async\s+)?(?:static\s+)?(?:Task<.*?>|void|[\w<>]+)\s+(\w+)\s*\([^)]*\)'
            $matches = [regex]::Matches($content, $pattern)
            foreach ($match in $matches) {
                $methods += @{
                    Name = $match.Groups[2].Value
                    Signature = $match.Value
                    IsPublic = $match.Groups[1].Value -eq "public"
                }
            }
        }
        "JavaScript" {
            # Functions and methods
            $patterns = @(
                '(?:export\s+)?(?:async\s+)?function\s+(\w+)',
                '(\w+)\s*:\s*(?:async\s+)?function',
                '(\w+)\s*=\s*(?:async\s+)?(?:function|\([^)]*\)\s*=>)',
                '(?:async\s+)?(\w+)\s*\([^)]*\)\s*\{'
            )
            
            foreach ($pattern in $patterns) {
                $matches = [regex]::Matches($content, $pattern)
                foreach ($match in $matches) {
                    $methods += @{
                        Name = $match.Groups[1].Value
                        Signature = $match.Value
                        IsPublic = $content -match "export.*$($match.Groups[1].Value)"
                    }
                }
            }
        }
        "Python" {
            $pattern = 'def\s+(\w+)\s*\([^)]*\):'
            $matches = [regex]::Matches($content, $pattern)
            foreach ($match in $matches) {
                $methods += @{
                    Name = $match.Groups[1].Value
                    Signature = $match.Value
                    IsPublic = -not ($match.Groups[1].Value -match '^_')
                }
            }
        }
    }
    
    return $methods
}

function Find-TestsForMethod {
    param($MethodName, $TestFiles, $TestPattern)
    
    $tests = @()
    
    foreach ($testFile in $TestFiles) {
        $content = Get-Content $testFile.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Look for test methods that mention the method name
        if ($content -match $MethodName) {
            $testMethods = [regex]::Matches($content, $TestPattern)
            
            foreach ($test in $testMethods) {
                # Check if this test is related to our method
                $testContext = $content.Substring([Math]::Max(0, $test.Index - 200), [Math]::Min(400, $content.Length - $test.Index))
                if ($testContext -match $MethodName) {
                    $tests += @{
                        File = $testFile.Name
                        TestName = $test.Value
                    }
                }
            }
        }
    }
    
    return $tests
}

function Measure-TestQuality {
    param($TestFile, $AssertPattern)
    
    $content = Get-Content $TestFile -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $null }
    
    $lines = ($content -split "`n").Count
    $assertions = ([regex]::Matches($content, $AssertPattern)).Count
    $testMethods = ([regex]::Matches($content, $testPatterns[$TestFramework].TestMethodPattern)).Count
    
    return @{
        File = $TestFile
        Lines = $lines
        Assertions = $assertions
        Tests = $testMethods
        AssertionDensity = if ($testMethods -gt 0) { [Math]::Round($assertions / $testMethods, 2) } else { 0 }
    }
}

# Main analysis
Write-Host "`nAnalyzing test coverage..." -ForegroundColor Yellow

# Get source files (excluding tests)
$sourceExtensions = @{
    "CSharp" = @("*.cs")
    "JavaScript" = @("*.js", "*.ts")
    "Python" = @("*.py")
}

$language = $testPatterns[$TestFramework].Language
$sourceFiles = @()

foreach ($ext in $sourceExtensions[$language]) {
    $sourceFiles += Get-ChildItem -Path $ProjectPath -Include $ext -Recurse |
        Where-Object { 
            $_.FullName -notmatch "test|spec|bin|obj|node_modules|dist|build" -and
            $_.Name -notmatch "test|spec"
        }
}

$coverageAnalysis.Summary.TotalFiles = $sourceFiles.Count

# Get test files
$testFiles = @()
foreach ($pattern in $testPatterns[$TestFramework].TestFilePattern) {
    $testFiles += Get-ChildItem -Path $ProjectPath -Include $pattern -Recurse |
        Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build" }
}

$coverageAnalysis.Summary.TestFiles = $testFiles.Count

# Analyze each source file
foreach ($sourceFile in $sourceFiles) {
    if ($Verbose) {
        Write-Host "  Analyzing: $($sourceFile.Name)" -ForegroundColor Gray
    }
    
    $methods = Get-MethodsFromFile -FilePath $sourceFile.FullName -Language $language
    $coverageAnalysis.Summary.TotalMethods += $methods.Count
    
    $fileCoverage = @{
        File = $sourceFile.FullName
        FileName = $sourceFile.Name
        Methods = $methods.Count
        TestedMethods = 0
        Coverage = 0
        MissingTests = @()
    }
    
    # Find tests for each method
    foreach ($method in $methods) {
        $tests = Find-TestsForMethod -MethodName $method.Name -TestFiles $testFiles -TestPattern $testPatterns[$TestFramework].TestMethodPattern
        
        if ($tests.Count -gt 0) {
            $fileCoverage.TestedMethods++
            $coverageAnalysis.Summary.TestedMethods++
        } else {
            # Only track missing tests for public methods
            if ($method.IsPublic) {
                $fileCoverage.MissingTests += $method.Name
                $coverageAnalysis.MissingTests += @{
                    File = $sourceFile.Name
                    Method = $method.Name
                    Signature = $method.Signature
                }
            }
        }
    }
    
    if ($methods.Count -gt 0) {
        $fileCoverage.Coverage = [Math]::Round(($fileCoverage.TestedMethods / $methods.Count) * 100, 2)
    }
    
    $coverageAnalysis.Coverage.ByFile += $fileCoverage
    
    # Track tested files
    if ($fileCoverage.TestedMethods -gt 0) {
        $coverageAnalysis.Summary.TestedFiles++
    }
}

# Analyze test quality
Write-Host "`nAnalyzing test quality..." -ForegroundColor Yellow

foreach ($testFile in $testFiles) {
    $quality = Measure-TestQuality -TestFile $testFile.FullName -AssertPattern $testPatterns[$TestFramework].AssertPattern
    
    if ($quality) {
        $coverageAnalysis.Summary.TotalTests += $quality.Tests
        
        # Check assertion density
        if ($quality.AssertionDensity -lt 1) {
            $coverageAnalysis.TestQuality.TestStructure += @{
                File = $testFile.Name
                Issue = "Low assertion density"
                AssertionsPerTest = $quality.AssertionDensity
                Recommendation = "Add more assertions to thoroughly test behavior"
            }
        }
        
        # Check test naming
        $content = Get-Content $testFile.FullName -Raw
        $poorNames = [regex]::Matches($content, 'test1|test2|testA|testB|temp|todo', [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
        
        if ($poorNames.Count -gt 0) {
            $coverageAnalysis.TestQuality.TestNaming += @{
                File = $testFile.Name
                Issue = "Poor test naming"
                Count = $poorNames.Count
                Recommendation = "Use descriptive test names: Should_ExpectedBehavior_When_StateUnderTest"
            }
        }
    }
}

# Calculate overall coverage
if ($coverageAnalysis.Summary.TotalMethods -gt 0) {
    $coverageAnalysis.Summary.LineCoverage = [Math]::Round(($coverageAnalysis.Summary.TestedMethods / $coverageAnalysis.Summary.TotalMethods) * 100, 2)
}

# Generate missing test templates
if ($GenerateMissingTests -and $coverageAnalysis.MissingTests.Count -gt 0) {
    Write-Host "`nGenerating test templates..." -ForegroundColor Yellow
    
    $testTemplate = ""
    
    switch ($TestFramework) {
        "xunit" {
            $testTemplate = @"
using Xunit;
using FluentAssertions;

public class {ClassName}Tests
{
{TestMethods}
}
"@
        }
        "jest" {
            $testTemplate = @"
describe('{ClassName}', () => {
{TestMethods}
});
"@
        }
    }
    
    # Group missing tests by file
    $missingByFile = $coverageAnalysis.MissingTests | Group-Object -Property File
    
    foreach ($fileGroup in $missingByFile) {
        $className = [System.IO.Path]::GetFileNameWithoutExtension($fileGroup.Name)
        $testMethods = ""
        
        foreach ($missing in $fileGroup.Group) {
            switch ($TestFramework) {
                "xunit" {
                    $testMethods += @"
    [Fact]
    public async Task ${missing.Method}_Should_ReturnExpectedResult_When_ValidInput()
    {
        // Arrange
        var sut = new $className();
        
        // Act
        var result = await sut.${missing.Method}();
        
        // Assert
        result.Should().NotBeNull();
    }

"@
                }
                "jest" {
                    $testMethods += @"
  it('should ${missing.Method} when valid input', async () => {
    // Arrange
    const sut = new $className();
    
    // Act
    const result = await sut.${missing.Method}();
    
    // Assert
    expect(result).toBeDefined();
  });

"@
                }
            }
        }
        
        $testContent = $testTemplate -replace '\{ClassName\}', $className -replace '\{TestMethods\}', $testMethods
        $testFileName = "${className}Tests.generated.$($language.ToLower())"
        $testContent | Out-File -FilePath $testFileName -Encoding UTF8
        
        Write-Host "  ✓ Generated: $testFileName" -ForegroundColor Green
    }
}

# Run tests if requested
if ($RunTests) {
    Write-Host "`nRunning tests..." -ForegroundColor Yellow
    
    switch ($TestFramework) {
        "xunit" {
            $testOutput = & dotnet test --collect:"XPlat Code Coverage" 2>&1
        }
        "jest" {
            $testOutput = & npm test -- --coverage 2>&1
        }
        "pytest" {
            $testOutput = & pytest --cov 2>&1
        }
    }
    
    Write-Host $testOutput
}

# Generate recommendations
if ($coverageAnalysis.Summary.LineCoverage -lt $CoverageThreshold) {
    $coverageAnalysis.Recommendations += "Increase test coverage to meet $CoverageThreshold% threshold"
}

if ($coverageAnalysis.MissingTests.Count -gt 10) {
    $coverageAnalysis.Recommendations += "Focus on testing public methods in core business logic"
}

if ($coverageAnalysis.TestQuality.TestStructure.Count -gt 0) {
    $coverageAnalysis.Recommendations += "Improve test quality with more comprehensive assertions"
}

if ($coverageAnalysis.Summary.TestFiles -eq 0) {
    $coverageAnalysis.Recommendations += "No test files found - implement a testing strategy"
}

# Display results
Write-Host "`n📊 Test Coverage Report" -ForegroundColor Green
Write-Host "======================" -ForegroundColor Green
Write-Host "Test Framework: $TestFramework" -ForegroundColor White
Write-Host "Source Files: $($coverageAnalysis.Summary.TotalFiles)" -ForegroundColor White
Write-Host "Test Files: $($coverageAnalysis.Summary.TestFiles)" -ForegroundColor White
Write-Host "Total Tests: $($coverageAnalysis.Summary.TotalTests)" -ForegroundColor White

Write-Host "`n📈 Coverage Metrics:" -ForegroundColor Yellow
Write-Host "  Files with Tests: $($coverageAnalysis.Summary.TestedFiles)/$($coverageAnalysis.Summary.TotalFiles) ($([Math]::Round($coverageAnalysis.Summary.TestedFiles / [Math]::Max(1, $coverageAnalysis.Summary.TotalFiles) * 100, 2))%)" -ForegroundColor White
Write-Host "  Methods Tested: $($coverageAnalysis.Summary.TestedMethods)/$($coverageAnalysis.Summary.TotalMethods) ($($coverageAnalysis.Summary.LineCoverage)%)" -ForegroundColor $(
    if ($coverageAnalysis.Summary.LineCoverage -ge $CoverageThreshold) { "Green" }
    elseif ($coverageAnalysis.Summary.LineCoverage -ge ($CoverageThreshold * 0.8)) { "Yellow" }
    else { "Red" }
)

# Files with lowest coverage
$lowestCoverage = $coverageAnalysis.Coverage.ByFile | 
    Where-Object { $_.Methods -gt 0 } |
    Sort-Object -Property Coverage |
    Select-Object -First 5

if ($lowestCoverage.Count -gt 0) {
    Write-Host "`n🔍 Files Needing Tests:" -ForegroundColor Yellow
    foreach ($file in $lowestCoverage) {
        Write-Host "  $($file.FileName): $($file.Coverage)% coverage ($($file.MissingTests.Count) methods missing tests)" -ForegroundColor White
    }
}

# Test quality issues
if ($coverageAnalysis.TestQuality.TestNaming.Count -gt 0 -or $coverageAnalysis.TestQuality.TestStructure.Count -gt 0) {
    Write-Host "`n⚠️  Test Quality Issues:" -ForegroundColor Yellow
    
    foreach ($issue in $coverageAnalysis.TestQuality.TestNaming) {
        Write-Host "  • $($issue.File): $($issue.Issue)" -ForegroundColor Yellow
    }
    
    foreach ($issue in $coverageAnalysis.TestQuality.TestStructure) {
        Write-Host "  • $($issue.File): $($issue.Issue) ($(($issue.AssertionsPerTest)) assertions/test)" -ForegroundColor Yellow
    }
}

# Recommendations
if ($coverageAnalysis.Recommendations.Count -gt 0) {
    Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
    foreach ($rec in $coverageAnalysis.Recommendations) {
        Write-Host "  • $rec" -ForegroundColor White
    }
}

# Generate report
if ($GenerateReport) {
    $reportPath = "test-coverage-report-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $coverageAnalysis | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
    
    # Generate coverage badge
    $badgeColor = if ($coverageAnalysis.Summary.LineCoverage -ge 80) { "brightgreen" }
                  elseif ($coverageAnalysis.Summary.LineCoverage -ge 60) { "yellow" }
                  else { "red" }
    
    $badgeUrl = "https://img.shields.io/badge/coverage-$($coverageAnalysis.Summary.LineCoverage)%25-$badgeColor"
    Write-Host "📛 Coverage badge URL: $badgeUrl" -ForegroundColor Gray
}

Write-Host "`n✨ Test coverage analysis complete!" -ForegroundColor Green

# Return analysis for automation
return $coverageAnalysis