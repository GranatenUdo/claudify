# Security Analysis Script - Adapts to project tech stack
# Usage: .\security-scan.ps1 [-ProjectPath <path>] [-TechStack <auto|dotnet|node|python>] [-Verbose]

param(
    [string]$ProjectPath = ".",
    [string]$TechStack = "auto",
    [switch]$Verbose
)

Write-Host "🔒 Security Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Change to project directory
Push-Location $ProjectPath

try {
    # Auto-detect tech stack if needed
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
        VulnerabilityCount = 0
        SecurityIssues = @()
        Recommendations = @()
    }
    
    # 1. Dependency vulnerability scanning
    Write-Host "`n📦 Checking dependency vulnerabilities..." -ForegroundColor Yellow
    
    switch ($TechStack) {
        "dotnet" {
            if (Get-Command dotnet -ErrorAction SilentlyContinue) {
                # Check for vulnerable packages
                $vulnCheck = & dotnet list package --vulnerable 2>&1
                if ($LASTEXITCODE -eq 0 -and $vulnCheck -match "has the following vulnerable packages") {
                    $results.SecurityIssues += @{
                        Type = "Vulnerable Dependencies"
                        Severity = "High"
                        Details = $vulnCheck | Out-String
                    }
                    $results.VulnerabilityCount++
                }
                
                # Run security analyzers if available
                if (Test-Path "*.csproj") {
                    Write-Host "Running .NET security analyzers..." -ForegroundColor Gray
                    & dotnet build /p:RunAnalyzers=true /p:TreatWarningsAsErrors=false 2>&1 | Out-Null
                }
            }
        }
        
        "node" {
            if (Get-Command npm -ErrorAction SilentlyContinue) {
                # Run npm audit
                $auditResult = & npm audit --json 2>&1
                if ($auditResult) {
                    $audit = $auditResult | ConvertFrom-Json -ErrorAction SilentlyContinue
                    if ($audit.metadata.vulnerabilities) {
                        $vulnCount = $audit.metadata.vulnerabilities.total
                        if ($vulnCount -gt 0) {
                            $results.SecurityIssues += @{
                                Type = "NPM Vulnerabilities"
                                Severity = "High"
                                Count = $vulnCount
                                Critical = $audit.metadata.vulnerabilities.critical
                                High = $audit.metadata.vulnerabilities.high
                            }
                            $results.VulnerabilityCount += $vulnCount
                        }
                    }
                }
            }
        }
        
        "python" {
            if (Get-Command pip -ErrorAction SilentlyContinue) {
                # Check with pip-audit if available
                if (Get-Command pip-audit -ErrorAction SilentlyContinue) {
                    $pipAudit = & pip-audit --format json 2>&1
                    if ($pipAudit) {
                        $vulns = $pipAudit | ConvertFrom-Json -ErrorAction SilentlyContinue
                        if ($vulns.Count -gt 0) {
                            $results.SecurityIssues += @{
                                Type = "Python Dependencies"
                                Severity = "High"
                                Count = $vulns.Count
                            }
                            $results.VulnerabilityCount += $vulns.Count
                        }
                    }
                }
            }
        }
    }
    
    # 2. Check for hardcoded secrets
    Write-Host "`n🔑 Scanning for hardcoded secrets..." -ForegroundColor Yellow
    
    $secretPatterns = @(
        'password\s*[=:]\s*["''][^"'']+["'']',
        'api[_-]?key\s*[=:]\s*["''][^"'']+["'']',
        'secret\s*[=:]\s*["''][^"'']+["'']',
        'token\s*[=:]\s*["''][^"'']+["'']',
        'private[_-]?key\s*[=:]\s*["''][^"'']+["'']',
        'aws[_-]?access[_-]?key',
        'azure[_-]?storage[_-]?key'
    )
    
    $fileExtensions = switch ($TechStack) {
        "dotnet" { @("*.cs", "*.config", "*.json", "*.xml") }
        "node" { @("*.js", "*.ts", "*.json", "*.env") }
        "python" { @("*.py", "*.json", "*.env", "*.ini") }
        default { @("*.cs", "*.js", "*.ts", "*.py", "*.json", "*.config", "*.env") }
    }
    
    $suspiciousFindings = @()
    foreach ($ext in $fileExtensions) {
        $files = Get-ChildItem -Path . -Recurse -Include $ext -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch "node_modules|bin|obj|\.git|test" }
        
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            foreach ($pattern in $secretPatterns) {
                if ($content -match $pattern) {
                    $suspiciousFindings += @{
                        File = $file.FullName.Replace($ProjectPath, ".")
                        Pattern = $pattern
                        Line = ($content -split "`n" | Select-String $pattern).LineNumber
                    }
                }
            }
        }
    }
    
    if ($suspiciousFindings.Count -gt 0) {
        $results.SecurityIssues += @{
            Type = "Potential Hardcoded Secrets"
            Severity = "Critical"
            Count = $suspiciousFindings.Count
            Details = $suspiciousFindings
        }
    }
    
    # 3. Multi-tenant security checks (if applicable)
    Write-Host "`n🏢 Checking multi-tenant isolation patterns..." -ForegroundColor Yellow
    
    $tenantPatterns = @(
        'OrganizationId', 'TenantId', 'CompanyId', 'CustomerId'
    )
    
    $missingTenantChecks = @()
    if ($TechStack -eq "dotnet") {
        $serviceFiles = Get-ChildItem -Path . -Recurse -Include "*Service.cs", "*Repository.cs" -File -ErrorAction SilentlyContinue |
            Where-Object { $_.FullName -notmatch "bin|obj|test" }
        
        foreach ($file in $serviceFiles) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            
            # Check for queries without tenant filtering
            if ($content -match "(GetAll|ToList|Where)\s*\(\s*\)" -and 
                $content -notmatch "($($tenantPatterns -join '|'))") {
                $missingTenantChecks += $file.FullName.Replace($ProjectPath, ".")
            }
        }
    }
    
    if ($missingTenantChecks.Count -gt 0) {
        $results.SecurityIssues += @{
            Type = "Missing Tenant Isolation"
            Severity = "High"
            Count = $missingTenantChecks.Count
            Files = $missingTenantChecks
        }
    }
    
    # 4. Authentication/Authorization checks
    Write-Host "`n🔐 Checking authentication patterns..." -ForegroundColor Yellow
    
    $authIssues = @()
    if ($TechStack -eq "dotnet") {
        $controllerFiles = Get-ChildItem -Path . -Recurse -Include "*Controller.cs" -File -ErrorAction SilentlyContinue
        
        foreach ($file in $controllerFiles) {
            $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
            
            # Check for missing [Authorize] attributes
            if ($content -match "public\s+.*\s+(Get|Post|Put|Delete|Patch)" -and
                $content -notmatch "\[Authorize") {
                $authIssues += @{
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Issue = "Potential missing authorization"
                }
            }
        }
    }
    
    if ($authIssues.Count -gt 0) {
        $results.SecurityIssues += @{
            Type = "Authorization Issues"
            Severity = "High"
            Count = $authIssues.Count
            Details = $authIssues
        }
    }
    
    # 5. OWASP checks
    Write-Host "`n🛡️ Running OWASP compliance checks..." -ForegroundColor Yellow
    
    # SQL Injection risks
    $sqlInjectionRisks = @()
    $sqlPatterns = @(
        'string\.Format.*SELECT.*FROM',
        'string\.Concat.*SELECT.*FROM',
        '\+.*SELECT.*FROM.*\+',
        'execute.*\+\s*\w+\s*\+'
    )
    
    foreach ($pattern in $sqlPatterns) {
        $matches = Get-ChildItem -Path . -Recurse -Include $fileExtensions -File -ErrorAction SilentlyContinue |
            Select-String -Pattern $pattern
        
        if ($matches) {
            $sqlInjectionRisks += $matches | ForEach-Object {
                @{
                    File = $_.Path.Replace($ProjectPath, ".")
                    Line = $_.LineNumber
                }
            }
        }
    }
    
    if ($sqlInjectionRisks.Count -gt 0) {
        $results.SecurityIssues += @{
            Type = "SQL Injection Risk"
            Severity = "Critical"
            Count = $sqlInjectionRisks.Count
            Details = $sqlInjectionRisks
        }
    }
    
    # Generate recommendations
    Write-Host "`n📋 Generating security recommendations..." -ForegroundColor Yellow
    
    if ($results.VulnerabilityCount -gt 0) {
        $results.Recommendations += "Update vulnerable dependencies immediately"
    }
    
    if ($results.SecurityIssues | Where-Object { $_.Type -eq "Potential Hardcoded Secrets" }) {
        $results.Recommendations += "Move secrets to secure configuration (Azure Key Vault, environment variables)"
    }
    
    if ($results.SecurityIssues | Where-Object { $_.Type -eq "Missing Tenant Isolation" }) {
        $results.Recommendations += "Implement tenant filtering in all data access methods"
    }
    
    if ($results.SecurityIssues | Where-Object { $_.Type -eq "Authorization Issues" }) {
        $results.Recommendations += "Add [Authorize] attributes to all API endpoints"
    }
    
    if ($results.SecurityIssues | Where-Object { $_.Type -eq "SQL Injection Risk" }) {
        $results.Recommendations += "Use parameterized queries or ORM instead of string concatenation"
    }
    
    # Summary report
    Write-Host "`n📊 Security Analysis Summary" -ForegroundColor Green
    Write-Host "===========================" -ForegroundColor Green
    Write-Host "Tech Stack: $($results.TechStack)"
    Write-Host "Total Issues Found: $($results.SecurityIssues.Count)"
    Write-Host "Critical Issues: $(($results.SecurityIssues | Where-Object { $_.Severity -eq 'Critical' }).Count)"
    Write-Host "High Issues: $(($results.SecurityIssues | Where-Object { $_.Severity -eq 'High' }).Count)"
    
    if ($results.SecurityIssues.Count -gt 0) {
        Write-Host "`n⚠️ Security Issues Details:" -ForegroundColor Red
        foreach ($issue in $results.SecurityIssues) {
            Write-Host "`n[$($issue.Severity)] $($issue.Type)" -ForegroundColor Yellow
            if ($issue.Count) {
                Write-Host "  Count: $($issue.Count)" -ForegroundColor Gray
            }
            if ($Verbose -and $issue.Details) {
                Write-Host "  Details:" -ForegroundColor Gray
                $issue.Details | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
            }
        }
    }
    
    if ($results.Recommendations.Count -gt 0) {
        Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
        foreach ($rec in $results.Recommendations) {
            Write-Host "  • $rec" -ForegroundColor White
        }
    }
    
    # Export detailed results
    $outputPath = Join-Path $ProjectPath "security-scan-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "`n📄 Detailed results saved to: $outputPath" -ForegroundColor Gray
    
    # Exit code based on severity
    $criticalCount = ($results.SecurityIssues | Where-Object { $_.Severity -eq 'Critical' }).Count
    if ($criticalCount -gt 0) {
        exit 1
    }
    
} finally {
    Pop-Location
}