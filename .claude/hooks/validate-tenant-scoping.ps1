# Parameterized Tenant Scoping Validation Hook
# Validates that code changes maintain proper tenant isolation
# This hook adapts to your project's specific multi-tenancy implementation

param(
    [string]$FilePath,
    [string]$ToolName,
    [string]$Arguments
)

# Configuration - These will be set based on project analysis
$config = @{
    # Common tenant field names to check for
    TenantFields = @("OrganizationId", "TenantId", "CompanyId", "CustomerId")
    
    # File patterns to check
    CheckPatterns = @("Repository", "Service", "Controller")
    
    # File patterns to skip
    SkipPatterns = @("Tests?", "Test\.cs", "Migrations", "Mock", "Stub", "Fake")
    
    # Language-specific file extensions
    BackendExtensions = @(".cs", ".java", ".py", ".go", ".rb")
    FrontendExtensions = @(".ts", ".js", ".tsx", ".jsx")
}

# Only check for Write and Edit operations
if ($ToolName -notmatch "Write|Edit|MultiEdit") {
    exit 0
}

# Determine file type and skip if not relevant
$fileExtension = [System.IO.Path]::GetExtension($FilePath)
if ($fileExtension -notin ($config.BackendExtensions + $config.FrontendExtensions)) {
    exit 0
}

# Skip test files and migrations
foreach ($pattern in $config.SkipPatterns) {
    if ($FilePath -match $pattern) {
        exit 0
    }
}

# Check if file should be validated based on patterns
$shouldCheck = $false
foreach ($pattern in $config.CheckPatterns) {
    if ($FilePath -match $pattern) {
        $shouldCheck = $true
        break
    }
}

if (-not $shouldCheck) {
    exit 0
}

Write-Host "🔍 Validating tenant scoping in: $FilePath" -ForegroundColor Yellow

# Read the file content or get it from arguments
$content = ""
if ($Arguments) {
    # For Edit operations, the new content might be in Arguments
    $content = $Arguments
} elseif (Test-Path $FilePath) {
    $content = Get-Content $FilePath -Raw
}

if (-not $content) {
    exit 0
}

$warnings = @()
$errors = @()

# Find which tenant field is used in this project
$detectedTenantField = $null
foreach ($field in $config.TenantFields) {
    if ($content -match $field) {
        $detectedTenantField = $field
        break
    }
}

# Backend-specific checks
if ($fileExtension -in $config.BackendExtensions) {
    
    # C# specific patterns
    if ($fileExtension -eq ".cs") {
        # Check for repository methods missing tenant filter
        if ($content -match "Repository" -and $content -match "GetAll\s*\(\s*\)") {
            $errors += "GetAll() without tenant filter detected! All repository queries must filter by tenant ID"
        }
        
        # Check for direct DbContext queries
        if ($content -match "_context\.\w+\.(Where|FirstOrDefault|ToList)" -and $detectedTenantField) {
            if ($content -notmatch $detectedTenantField) {
                $warnings += "Database query may be missing $detectedTenantField filter"
            }
        }
        
        # Check for missing Result<T> pattern
        if ($content -match "public\s+async\s+Task<(?!Result)" -and $content -match "Service") {
            $warnings += "Service method not returning Result<T> - consider using Result pattern for consistent error handling"
        }
        
        # Check for cache keys without tenant context
        if ($content -match "cache\.(Get|Set|Remove).*\(" -and $detectedTenantField) {
            $cacheKeyPattern = "cache\.\w+\s*\([^)]+\)"
            $cacheMatches = [regex]::Matches($content, $cacheKeyPattern)
            foreach ($match in $cacheMatches) {
                if ($match.Value -notmatch $detectedTenantField) {
                    $warnings += "Cache operation may be missing tenant context in key"
                }
            }
        }
    }
    
    # Java specific patterns
    elseif ($fileExtension -eq ".java") {
        if ($content -match "@Repository|@Service" -and $content -match "findAll\s*\(\s*\)") {
            $errors += "findAll() without tenant filter detected!"
        }
    }
    
    # Python specific patterns
    elseif ($fileExtension -eq ".py") {
        if ($content -match "class.*Repository|class.*Service" -and $content -match "\.all\(\)") {
            $warnings += "Query using .all() may be missing tenant filter"
        }
    }
}

# Frontend-specific checks
elseif ($fileExtension -in $config.FrontendExtensions) {
    
    # Check for hardcoded IDs
    $hardcodedPatterns = @(
        '["'']organizationId["'']\s*:\s*["''][a-zA-Z0-9-]+["'']',
        '["'']tenantId["'']\s*:\s*["''][a-zA-Z0-9-]+["'']',
        '["'']companyId["'']\s*:\s*["''][a-zA-Z0-9-]+["'']'
    )
    
    foreach ($pattern in $hardcodedPatterns) {
        if ($content -match $pattern) {
            $errors += "Hardcoded tenant ID detected! Use dynamic values from user context"
        }
    }
    
    # Check for API calls without tenant context
    if ($content -match "http\.(get|post|put|delete|patch)" -or $content -match "fetch\(") {
        if ($detectedTenantField -and $content -notmatch $detectedTenantField.ToLower()) {
            $warnings += "API call may be missing tenant context"
        }
    }
}

# Report results
if ($errors.Count -gt 0) {
    Write-Host "`n❌ SECURITY ERRORS FOUND:" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "  ⚠️  $error" -ForegroundColor Red
    }
    
    Write-Host "`n💡 How to fix:" -ForegroundColor Cyan
    Write-Host "  - All data queries must include tenant filtering" -ForegroundColor White
    Write-Host "  - Use parameterized tenant IDs from user context" -ForegroundColor White
    Write-Host "  - Never hardcode tenant identifiers" -ForegroundColor White
    
    if ($detectedTenantField) {
        Write-Host "`n📋 Example (using $detectedTenantField):" -ForegroundColor Yellow
        
        if ($fileExtension -eq ".cs") {
            Write-Host @"
    // Repository method:
    public async Task<IEnumerable<Entity>> GetAllByOrganizationAsync(string organizationId)
    {
        return await _context.Entities
            .Where(e => e.$detectedTenantField == organizationId)
            .ToListAsync();
    }
"@ -ForegroundColor Gray
        }
    }
    
    Write-Host "`n⚠️  Continue anyway? This may introduce security vulnerabilities! (y/N): " -ForegroundColor Yellow -NoNewline
    $response = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown").Character
    Write-Host ""
    
    if ($response -ne 'y' -and $response -ne 'Y') {
        Write-Host "❌ Operation cancelled for security review" -ForegroundColor Red
        exit 2  # Exit code 2 blocks the operation
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️  Security Warnings:" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "  • $warning" -ForegroundColor Yellow
    }
    Write-Host "`n💡 Please review these warnings to ensure proper tenant isolation" -ForegroundColor Cyan
}

# If we have neither errors nor warnings, show success
if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "✅ Tenant scoping validation passed" -ForegroundColor Green
}

exit 0