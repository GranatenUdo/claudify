# Architecture Pattern Recognizer Script
# Used by init-claudify command

param(
    [string]$RepositoryPath = "."
)

$ErrorActionPreference = "Stop"

# Initialize pattern results
$patterns = @{
    RepositoryPattern = @{
        Found = $false
        Confidence = 0
        Evidence = @()
    }
    ResultPattern = @{
        Found = $false
        Confidence = 0
        Evidence = @()
    }
    DomainDrivenDesign = @{
        Found = $false
        Confidence = 0
        Evidence = @()
    }
    CQRS = @{
        Found = $false
        Confidence = 0
        Evidence = @()
    }
    MultiTenancy = @{
        Found = $false
        Model = $null
        Field = $null
        Confidence = 0
        Evidence = @()
    }
}

Write-Host "🔍 Analyzing Architecture Patterns..." -ForegroundColor Cyan

# Repository Pattern Detection
Write-Host "`n📂 Repository Pattern Detection:" -ForegroundColor Yellow

$repoInterfaces = Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse -ErrorAction SilentlyContinue | 
    Select-String -Pattern "interface\s+I\w*Repository" -List

if ($repoInterfaces.Count -gt 0) {
    $patterns.RepositoryPattern.Found = $true
    $patterns.RepositoryPattern.Confidence = [Math]::Min(100, $repoInterfaces.Count * 10)
    $patterns.RepositoryPattern.Evidence += "$($repoInterfaces.Count) repository interfaces found"
    Write-Host "  ✓ Found $($repoInterfaces.Count) repository interfaces" -ForegroundColor Green
    
    # Look for base repository
    $baseRepo = Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | 
        Select-String -Pattern "class\s+\w*RepositoryBase|class\s+\w*BaseRepository" -List
    
    if ($baseRepo) {
        $patterns.RepositoryPattern.Confidence = 100
        $patterns.RepositoryPattern.Evidence += "Base repository class found"
        Write-Host "  ✓ Base repository implementation detected" -ForegroundColor Green
    }
}

# Result Pattern Detection
Write-Host "`n📊 Result<T> Pattern Detection:" -ForegroundColor Yellow

$resultPatterns = @(
    "class\s+Result<",
    "Result<\w+>",
    "Task<Result<",
    "Result\.Success",
    "Result\.Failure"
)

$resultUsage = 0
foreach ($pattern in $resultPatterns) {
    $matches = Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse -ErrorAction SilentlyContinue | 
        Select-String -Pattern $pattern -List
    $resultUsage += $matches.Count
}

if ($resultUsage -gt 5) {
    $patterns.ResultPattern.Found = $true
    $patterns.ResultPattern.Confidence = [Math]::Min(100, $resultUsage * 5)
    $patterns.ResultPattern.Evidence += "Result pattern used in $resultUsage locations"
    Write-Host "  ✓ Result<T> pattern detected with $resultUsage usages" -ForegroundColor Green
    
    # Check for Result class definition
    $resultClass = Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | 
        Select-String -Pattern "class\s+Result<T>|class\s+Result\s*{" -List
    
    if ($resultClass) {
        $patterns.ResultPattern.Confidence = 100
        $patterns.ResultPattern.Evidence += "Result class implementation found"
    }
}

# Domain-Driven Design Detection
Write-Host "`n🏛️ Domain-Driven Design Detection:" -ForegroundColor Yellow

$dddIndicators = @{
    "Domain folder" = Test-Path (Join-Path $RepositoryPath "Domain") -or (Get-ChildItem -Path $RepositoryPath -Filter "Domain" -Directory -Recurse)
    "Entity classes" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+\s*:\s*Entity|class\s+\w+\s*:\s*IEntity" -List).Count -gt 0
    "Value objects" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+\s*:\s*ValueObject|record\s+\w+" -List).Count -gt 0
    "Aggregates" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+Aggregate|IAggregateRoot" -List).Count -gt 0
    "Domain events" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+Event\s*:|IDomainEvent" -List).Count -gt 0
    "Factory methods" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "public\s+static\s+\w+\s+Create\(" -List).Count -gt 0
}

$dddScore = 0
foreach ($indicator in $dddIndicators.GetEnumerator()) {
    if ($indicator.Value) {
        $dddScore++
        $patterns.DomainDrivenDesign.Evidence += $indicator.Key
        Write-Host "  ✓ $($indicator.Key) detected" -ForegroundColor Green
    }
}

if ($dddScore -ge 3) {
    $patterns.DomainDrivenDesign.Found = $true
    $patterns.DomainDrivenDesign.Confidence = ($dddScore / 6) * 100
}

# CQRS Detection
Write-Host "`n📤 CQRS Pattern Detection:" -ForegroundColor Yellow

$cqrsIndicators = @{
    "Command classes" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+Command\s*:|ICommand" -List).Count
    "Query classes" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+Query\s*:|IQuery" -List).Count
    "Handler classes" = (Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | Select-String -Pattern "class\s+\w+Handler\s*:|IRequestHandler" -List).Count
    "MediatR usage" = (Get-ChildItem -Path $RepositoryPath -Include "*.csproj" -Recurse | Select-String -Pattern "MediatR" -List).Count -gt 0
}

$cqrsScore = 0
foreach ($indicator in $cqrsIndicators.GetEnumerator()) {
    if ($indicator.Value -and $indicator.Value -ne $false) {
        $cqrsScore++
        $patterns.CQRS.Evidence += "$($indicator.Key): $($indicator.Value)"
        Write-Host "  ✓ $($indicator.Key) detected" -ForegroundColor Green
    }
}

if ($cqrsScore -ge 2) {
    $patterns.CQRS.Found = $true
    $patterns.CQRS.Confidence = ($cqrsScore / 4) * 100
}

# Multi-Tenancy Detection
Write-Host "`n🏢 Multi-Tenancy Detection:" -ForegroundColor Yellow

$tenantFields = @{
    "OrganizationId" = @{ Pattern = "OrganizationId|organizationId"; Model = "Organization" }
    "TenantId" = @{ Pattern = "TenantId|tenantId"; Model = "Tenant" }
    "CompanyId" = @{ Pattern = "CompanyId|companyId"; Model = "Company" }
    "CustomerId" = @{ Pattern = "CustomerId|customerId"; Model = "Customer" }
}

$maxCount = 0
$detectedField = $null
$detectedModel = $null

foreach ($field in $tenantFields.GetEnumerator()) {
    $count = (Get-ChildItem -Path $RepositoryPath -Include "*.cs", "*.ts" -Recurse -ErrorAction SilentlyContinue | 
        Select-String -Pattern $field.Value.Pattern -List).Count
    
    if ($count -gt $maxCount) {
        $maxCount = $count
        $detectedField = $field.Key
        $detectedModel = $field.Value.Model
    }
}

if ($maxCount -gt 5) {
    $patterns.MultiTenancy.Found = $true
    $patterns.MultiTenancy.Field = $detectedField
    $patterns.MultiTenancy.Model = $detectedModel
    $patterns.MultiTenancy.Confidence = [Math]::Min(100, $maxCount * 2)
    $patterns.MultiTenancy.Evidence += "$detectedField found in $maxCount files"
    Write-Host "  ✓ Multi-tenancy detected: $detectedModel-based (field: $detectedField)" -ForegroundColor Green
    
    # Check for query filtering
    $filterPatterns = Get-ChildItem -Path $RepositoryPath -Include "*.cs" -Recurse | 
        Select-String -Pattern "Where.*$detectedField\s*==|filter.*$detectedField" -List
    
    if ($filterPatterns) {
        $patterns.MultiTenancy.Confidence = 100
        $patterns.MultiTenancy.Evidence += "Query filtering by $detectedField detected"
        Write-Host "  ✓ Tenant filtering in queries confirmed" -ForegroundColor Green
    }
}

# Output results as JSON
$patterns | ConvertTo-Json -Depth 4