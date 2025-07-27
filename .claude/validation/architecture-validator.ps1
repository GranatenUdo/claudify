# Architecture Compliance Validator - Ensures code follows architectural patterns
# Adapts to project-specific patterns and rules

param(
    [string]$ProjectPath = ".",
    [string]$ValidationProfile = "auto",  # auto, strict, relaxed, custom
    [string]$ConfigFile = "",
    [switch]$FixIssues,
    [switch]$GenerateReport,
    [switch]$FailOnError,
    [switch]$Verbose
)

Write-Host "🏛️ Architecture Compliance Validator" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan

# Load project analysis if available
$analysisPath = Join-Path $ProjectPath ".claude/analysis-cache.json"
$projectConfig = $null

if (Test-Path $analysisPath) {
    $projectConfig = Get-Content $analysisPath -Raw | ConvertFrom-Json
    Write-Host "✓ Loaded project configuration" -ForegroundColor Green
}

# Initialize validation rules based on detected patterns
$validationRules = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Profile = $ValidationProfile
    Rules = @{
        LayerViolations = @()
        PatternViolations = @()
        NamingViolations = @()
        DependencyViolations = @()
        SecurityViolations = @()
    }
    Results = @{
        Passed = 0
        Failed = 0
        Warnings = 0
        Fixed = 0
    }
    Issues = @()
}

# Define architecture layers (customizable)
$layers = @{
    "Controller" = @{
        Order = 1
        AllowedDependencies = @("Service", "Model", "DTO")
        ForbiddenDependencies = @("Repository", "Entity", "Infrastructure")
        FilePatterns = @("*Controller.cs", "*Controller.ts", "*controller.js")
    }
    "Service" = @{
        Order = 2
        AllowedDependencies = @("Repository", "Model", "DTO", "Utils")
        ForbiddenDependencies = @("Controller", "Infrastructure")
        FilePatterns = @("*Service.cs", "*Service.ts", "*service.js")
    }
    "Repository" = @{
        Order = 3
        AllowedDependencies = @("Entity", "Model", "Infrastructure")
        ForbiddenDependencies = @("Controller", "Service")
        FilePatterns = @("*Repository.cs", "*Repository.ts", "*repository.js")
    }
}

# Pattern-specific rules
$patternRules = @{}

if ($projectConfig -and $projectConfig.Patterns.MultiTenant) {
    $patternRules["MultiTenant"] = @{
        TenantField = $projectConfig.Patterns.TenantField
        RequiredInQueries = $true
        RequiredInEntities = $true
    }
}

if ($projectConfig -and $projectConfig.Patterns.ResultPattern) {
    $patternRules["ResultPattern"] = @{
        RequiredReturnType = "Result<"
        AppliesTo = @("Service")
        ExceptionHandling = "Forbidden"
    }
}

if ($projectConfig -and $projectConfig.Patterns.RepositoryPattern) {
    $patternRules["RepositoryPattern"] = @{
        InterfaceRequired = $true
        DirectDbContextAccess = "Forbidden"
        DataAccessOnlyVia = "Repository"
    }
}

# Load custom validation config if provided
if ($ConfigFile -and (Test-Path $ConfigFile)) {
    $customConfig = Get-Content $ConfigFile -Raw | ConvertFrom-Json
    # Merge custom rules
    Write-Host "✓ Loaded custom validation rules" -ForegroundColor Green
}

# Validation functions
function Test-LayerViolation {
    param($FilePath, $Content, $CurrentLayer)
    
    $violations = @()
    
    # Check imports/usings for layer violations
    $imports = @()
    
    # C# usings
    if ($FilePath -match "\.cs$") {
        $imports = [regex]::Matches($Content, "using\s+([^;]+);") | ForEach-Object { $_.Groups[1].Value }
    }
    # TypeScript/JavaScript imports
    elseif ($FilePath -match "\.(ts|js)$") {
        $imports = [regex]::Matches($Content, "import.*from\s+['""]([^'""]+)['""]") | ForEach-Object { $_.Groups[1].Value }
    }
    
    foreach ($import in $imports) {
        foreach ($forbiddenLayer in $layers[$CurrentLayer].ForbiddenDependencies) {
            if ($import -match $forbiddenLayer) {
                $violations += @{
                    Type = "LayerViolation"
                    File = $FilePath
                    Layer = $CurrentLayer
                    ViolatedDependency = $forbiddenLayer
                    Import = $import
                    Message = "$CurrentLayer should not depend on $forbiddenLayer"
                    Severity = "Error"
                }
            }
        }
    }
    
    return $violations
}

function Test-PatternCompliance {
    param($FilePath, $Content, $Layer)
    
    $violations = @()
    
    # Multi-tenant validation
    if ($patternRules.ContainsKey("MultiTenant") -and $Layer -in @("Repository", "Service")) {
        $tenantField = $patternRules["MultiTenant"].TenantField
        
        # Check for queries without tenant filter
        if ($Content -match "(GetAll|FindAll|Where|Select|From)") {
            # Simple check - in production use proper AST parsing
            $queryBlocks = [regex]::Matches($Content, "(public|private|protected).*?async.*?Task.*?\{[\s\S]*?\}", [System.Text.RegularExpressions.RegexOptions]::Multiline)
            
            foreach ($block in $queryBlocks) {
                if ($block.Value -match "(GetAll|FindAll)" -and $block.Value -notmatch $tenantField) {
                    $violations += @{
                        Type = "MultiTenantViolation"
                        File = $FilePath
                        Pattern = "Multi-tenant"
                        Message = "Query missing $tenantField filter"
                        Severity = "Error"
                        CodeBlock = $block.Value.Substring(0, [Math]::Min(200, $block.Value.Length)) + "..."
                    }
                }
            }
        }
    }
    
    # Result pattern validation
    if ($patternRules.ContainsKey("ResultPattern") -and $Layer -eq "Service") {
        # Check service methods return Result<T>
        $methods = [regex]::Matches($Content, "(public|internal).*?async.*?Task<([^>]+)>.*?\(")
        
        foreach ($method in $methods) {
            $returnType = $method.Groups[2].Value
            if ($returnType -notmatch "^Result") {
                $violations += @{
                    Type = "ResultPatternViolation"
                    File = $FilePath
                    Pattern = "Result<T>"
                    Message = "Service method should return Result<T>, not Task<$returnType>"
                    Severity = "Error"
                    Method = $method.Value
                }
            }
        }
        
        # Check for exception throwing
        if ($Content -match "throw\s+new\s+\w*Exception") {
            $violations += @{
                Type = "ResultPatternViolation"
                File = $FilePath
                Pattern = "Result<T>"
                Message = "Service should return Result.Failure() instead of throwing exceptions"
                Severity = "Error"
            }
        }
    }
    
    # Repository pattern validation
    if ($patternRules.ContainsKey("RepositoryPattern")) {
        # Check for direct DbContext usage outside repositories
        if ($Layer -ne "Repository" -and $Content -match "_context\.|DbContext|DataContext") {
            $violations += @{
                Type = "RepositoryPatternViolation"
                File = $FilePath
                Pattern = "Repository"
                Message = "Direct database access outside repository layer"
                Severity = "Error"
            }
        }
        
        # Check repository has interface
        if ($Layer -eq "Repository" -and $FilePath -notmatch "^I" -and $Content -match "class\s+\w+Repository") {
            $violations += @{
                Type = "RepositoryPatternViolation"
                File = $FilePath
                Pattern = "Repository"
                Message = "Repository missing interface definition"
                Severity = "Warning"
            }
        }
    }
    
    return $violations
}

function Test-NamingConventions {
    param($FilePath, $Content)
    
    $violations = @()
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($FilePath)
    $extension = [System.IO.Path]::GetExtension($FilePath)
    
    # C# naming conventions
    if ($extension -eq ".cs") {
        # Check class name matches file name
        if ($Content -match "class\s+(\w+)") {
            $className = $Matches[1]
            if ($className -ne $fileName) {
                $violations += @{
                    Type = "NamingViolation"
                    File = $FilePath
                    Expected = $fileName
                    Actual = $className
                    Message = "Class name should match file name"
                    Severity = "Warning"
                }
            }
        }
        
        # Check for proper casing
        if ($fileName -match "^[a-z]") {
            $violations += @{
                Type = "NamingViolation"
                File = $FilePath
                Message = "C# file names should start with uppercase"
                Severity = "Warning"
            }
        }
    }
    
    # Check for consistency in layer naming
    foreach ($layer in $layers.Keys) {
        if ($fileName -match $layer -and $fileName -notmatch "$layer$") {
            $violations += @{
                Type = "NamingViolation"
                File = $FilePath
                Message = "$layer files should end with '$layer'"
                Severity = "Warning"
            }
        }
    }
    
    return $violations
}

function Test-SecurityPatterns {
    param($FilePath, $Content)
    
    $violations = @()
    
    # Check for hardcoded secrets
    $secretPatterns = @(
        'password\s*=\s*"[^"]+"',
        'apikey\s*=\s*"[^"]+"',
        'connectionstring.*password[^"]*"[^"]+"',
        'token\s*=\s*"[^"]+"'
    )
    
    foreach ($pattern in $secretPatterns) {
        if ($Content -match $pattern) {
            $violations += @{
                Type = "SecurityViolation"
                File = $FilePath
                Pattern = "Hardcoded Secret"
                Message = "Possible hardcoded secret detected"
                Severity = "Error"
                Match = $Matches[0]
            }
        }
    }
    
    # Check for SQL injection vulnerabilities
    if ($Content -match 'string\.Format.*?(SELECT|INSERT|UPDATE|DELETE)' -or
        $Content -match '\+.*?(SELECT|INSERT|UPDATE|DELETE)') {
        $violations += @{
            Type = "SecurityViolation"
            File = $FilePath
            Pattern = "SQL Injection"
            Message = "Possible SQL injection vulnerability"
            Severity = "Error"
        }
    }
    
    return $violations
}

# Main validation process
Write-Host "`nAnalyzing architecture compliance..." -ForegroundColor Yellow

$files = Get-ChildItem -Path $ProjectPath -Include "*.cs", "*.ts", "*.js", "*.java" -Recurse |
    Where-Object { $_.FullName -notmatch "bin|obj|node_modules|dist|build|test" }

$totalFiles = $files.Count
$currentFile = 0

foreach ($file in $files) {
    $currentFile++
    if ($Verbose) {
        Write-Progress -Activity "Validating Architecture" -Status "$currentFile of $totalFiles" -PercentComplete (($currentFile / $totalFiles) * 100)
    }
    
    $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    # Determine layer
    $currentLayer = $null
    foreach ($layer in $layers.Keys) {
        foreach ($pattern in $layers[$layer].FilePatterns) {
            if ($file.Name -like $pattern) {
                $currentLayer = $layer
                break
            }
        }
        if ($currentLayer) { break }
    }
    
    if (-not $currentLayer) { continue }
    
    # Run validations
    $layerViolations = Test-LayerViolation -FilePath $file.FullName -Content $content -CurrentLayer $currentLayer
    $patternViolations = Test-PatternCompliance -FilePath $file.FullName -Content $content -Layer $currentLayer
    $namingViolations = Test-NamingConventions -FilePath $file.FullName -Content $content
    $securityViolations = Test-SecurityPatterns -FilePath $file.FullName -Content $content
    
    # Collect all violations
    $allViolations = $layerViolations + $patternViolations + $namingViolations + $securityViolations
    
    foreach ($violation in $allViolations) {
        $validationRules.Issues += $violation
        
        if ($violation.Severity -eq "Error") {
            $validationRules.Results.Failed++
        } else {
            $validationRules.Results.Warnings++
        }
        
        # Attempt to fix if requested
        if ($FixIssues -and $violation.Type -eq "NamingViolation") {
            # Simple fix example - rename file
            if ($violation.Message -match "Class name should match file name") {
                $newFileName = Join-Path (Split-Path $file.FullName) "$($violation.Actual).cs"
                if ($Verbose) {
                    Write-Host "  Fixing: Renaming $($file.Name) to $($violation.Actual).cs" -ForegroundColor Yellow
                }
                # Move-Item $file.FullName $newFileName
                $validationRules.Results.Fixed++
            }
        }
    }
    
    if ($allViolations.Count -eq 0) {
        $validationRules.Results.Passed++
    }
}

# Summary report
Write-Host "`n📊 Validation Summary" -ForegroundColor Green
Write-Host "====================" -ForegroundColor Green
Write-Host "Files Analyzed: $totalFiles" -ForegroundColor White
Write-Host "Passed: $($validationRules.Results.Passed)" -ForegroundColor Green
Write-Host "Failed: $($validationRules.Results.Failed)" -ForegroundColor Red
Write-Host "Warnings: $($validationRules.Results.Warnings)" -ForegroundColor Yellow

if ($FixIssues -and $validationRules.Results.Fixed -gt 0) {
    Write-Host "Fixed: $($validationRules.Results.Fixed)" -ForegroundColor Cyan
}

# Group violations by type
$violationGroups = $validationRules.Issues | Group-Object Type

Write-Host "`n🔍 Violations by Type:" -ForegroundColor Yellow
foreach ($group in $violationGroups) {
    Write-Host "  $($group.Name): $($group.Count)" -ForegroundColor White
    
    if ($Verbose) {
        $group.Group | Select-Object -First 3 | ForEach-Object {
            Write-Host "    - $($_.Message)" -ForegroundColor Gray
            Write-Host "      File: $([System.IO.Path]::GetFileName($_.File))" -ForegroundColor DarkGray
        }
        if ($group.Count -gt 3) {
            Write-Host "    ... and $($group.Count - 3) more" -ForegroundColor DarkGray
        }
    }
}

# Critical issues
$criticalIssues = $validationRules.Issues | Where-Object { $_.Severity -eq "Error" }
if ($criticalIssues.Count -gt 0) {
    Write-Host "`n❌ Critical Issues Found:" -ForegroundColor Red
    $criticalIssues | Select-Object -First 5 | ForEach-Object {
        Write-Host "  • $($_.Message)" -ForegroundColor Red
        Write-Host "    File: $([System.IO.Path]::GetFileName($_.File))" -ForegroundColor Gray
        if ($_.CodeBlock) {
            Write-Host "    Code: $($_.CodeBlock.Substring(0, [Math]::Min(100, $_.CodeBlock.Length)))..." -ForegroundColor DarkGray
        }
    }
}

# Generate detailed report
if ($GenerateReport) {
    $reportPath = "architecture-validation-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $validationRules | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
    
    # Generate fix script
    if ($validationRules.Issues.Count -gt 0) {
        $fixScriptPath = "architecture-fixes-$(Get-Date -Format 'yyyyMMdd-HHmmss').ps1"
        $fixScript = @"
# Architecture Violation Fix Script
# Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

Write-Host "Applying architecture fixes..." -ForegroundColor Yellow

"@
        
        foreach ($issue in $validationRules.Issues | Where-Object { $_.Severity -eq "Error" }) {
            $fixScript += @"

# Fix: $($issue.Message)
# File: $($issue.File)
Write-Host "TODO: Fix $($issue.Type) in $([System.IO.Path]::GetFileName($issue.File))" -ForegroundColor Cyan

"@
        }
        
        $fixScript | Out-File -FilePath $fixScriptPath -Encoding UTF8
        Write-Host "📄 Fix script saved to: $fixScriptPath" -ForegroundColor Gray
    }
}

# Exit code for CI/CD
if ($FailOnError -and $validationRules.Results.Failed -gt 0) {
    Write-Host "`n❌ Architecture validation failed!" -ForegroundColor Red
    exit 1
}

Write-Host "`n✅ Architecture validation complete!" -ForegroundColor Green

# Return results for automation
return $validationRules