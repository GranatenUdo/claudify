# Security Hook - Check Tenant/Organization Scoping
# This hook validates that all code changes maintain proper multi-tenant isolation

param(
    [string]$FilePath,
    [string]$ToolName,
    [string]$Arguments
)

$ErrorFound = $false
$Warnings = @()

Write-Host "🔒 Checking tenant isolation for: $FilePath" -ForegroundColor Cyan

# Skip non-code files
if ($FilePath -notmatch '\.(cs|ts|js)$') {
    exit 0
}

# Read the file content from the arguments (for Edit/Write operations)
$FileContent = ""
if ($ToolName -eq "Edit" -or $ToolName -eq "Write") {
    try {
        $ArgsObj = $Arguments | ConvertFrom-Json
        $FileContent = $ArgsObj.new_string
        if (-not $FileContent -and $ArgsObj.content) {
            $FileContent = $ArgsObj.content
        }
    } catch {
        Write-Host "⚠️  Could not parse file content from arguments" -ForegroundColor Yellow
    }
}

# C# Validations
if ($FilePath -match '\.cs$') {
    
    # Check for repository/service files
    if ($FilePath -match '(Repository|Service)\.cs$' -and $FilePath -notmatch '(Base|Interface|Test)') {
        
        # Check for database queries without organization filtering
        if ($FileContent -match '_context\.\w+\.Where\s*\(' -or $FileContent -match '_db\.\w+\.Where\s*\(') {
            if ($FileContent -notmatch '(OrganizationId|TenantId|CompanyId)\s*==') {
                $ErrorFound = $true
                Write-Host "❌ ERROR: Database query without tenant filtering found!" -ForegroundColor Red
                Write-Host "   Every query must filter by organization/tenant ID" -ForegroundColor Red
                Write-Host "   Example: .Where(x => x.OrganizationId == _userContext.OrganizationId)" -ForegroundColor Yellow
            }
        }
        
        # Check for GetAll patterns without filtering
        if ($FileContent -match '\.ToListAsync\(\)' -and $FileContent -notmatch '\.Where\s*\(') {
            $Warnings += "GetAll pattern without Where clause - ensure organization filtering is applied"
        }
        
        # Check for direct DbSet access
        if ($FileContent -match '_context\.\w+\s*\.' -and $FileContent -notmatch '(Where|OrganizationScoped)') {
            $Warnings += "Direct DbSet access detected - consider using OrganizationScoped() method"
        }
    }
    
    # Check for missing Result<T> pattern in services
    if ($FilePath -match 'Service\.cs$' -and $FileContent -match 'public\s+async\s+Task<(?!Result)') {
        $Warnings += "Service method not returning Result<T> - use Result pattern for error handling"
    }
    
    # Check for thrown exceptions in services
    if ($FilePath -match 'Service\.cs$' -and $FileContent -match 'throw\s+new\s+\w+Exception') {
        $Warnings += "Service throwing exception - use Result<T>.Failure() instead"
    }
    
    # Check cache keys for organization scoping
    if ($FileContent -match '_cache\.(Get|Set|Remove)' -and $FileContent -notmatch '(organization|tenant|company)') {
        $Warnings += "Cache operation may need organization-scoped keys"
    }
}

# TypeScript/JavaScript Validations
if ($FilePath -match '\.(ts|js)$' -and $FilePath -notmatch '\.spec\.(ts|js)$') {
    
    # Check for API calls without proper error handling
    if ($FileContent -match '\.subscribe\s*\(' -and $FileContent -notmatch 'error:') {
        $Warnings += "API subscription without error handler - add error handling"
    }
    
    # Check for missing loading states
    if ($FileContent -match 'http\.(get|post|put|delete)' -and $FileContent -notmatch 'loading\s*=\s*(true|signal)') {
        $Warnings += "HTTP operation without loading state management"
    }
    
    # Check for setTimeout usage
    if ($FileContent -match 'setTimeout\s*\(') {
        $Warnings += "setTimeout detected - consider using RxJS operators or proper async handling"
    }
    
    # Check for direct state mutation in Angular
    if ($FileContent -match '\.push\s*\(' -or $FileContent -match '\.\w+\s*=\s*' -and $FileContent -match '@Component') {
        $Warnings += "Possible direct state mutation - use signals or immutable updates"
    }
}

# Output results
if ($ErrorFound) {
    Write-Host "`n❌ SECURITY VALIDATION FAILED" -ForegroundColor Red
    Write-Host "The code changes do not maintain proper tenant isolation." -ForegroundColor Red
    Write-Host "Please fix the errors above before proceeding." -ForegroundColor Red
    
    # Block the operation
    exit 1
}

if ($Warnings.Count -gt 0) {
    Write-Host "`n⚠️  Warnings found:" -ForegroundColor Yellow
    foreach ($warning in $Warnings) {
        Write-Host "   - $warning" -ForegroundColor Yellow
    }
    Write-Host "`nConsider addressing these warnings for better code quality." -ForegroundColor Cyan
}
else {
    Write-Host "✅ Tenant isolation check passed" -ForegroundColor Green
}

# Allow the operation to proceed
exit 0