# Pre-Commit Quality Check - TOP 3 Critical Checks Only
# Blocks commits only for critical security/build issues

param(
    [string]$ToolName,
    [string]$Arguments
)

# Only run on git commits
if ($ToolName -ne "Bash" -or $Arguments -notmatch "git commit") { exit 0 }

Write-Host "🔍 Running TOP 3 quality checks..." -ForegroundColor Yellow

$errors = @()

# 1. BUILD CHECK - Must compile
# .NET check (search recursively for .csproj in src/)
$csprojFiles = Get-ChildItem -Path "src" -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue 2>$null | Select-Object -First 1
if ($csprojFiles) {
    Write-Host "  ✓ Checking .NET build..." -ForegroundColor Gray
    $buildOutput = dotnet build --no-restore 2>&1
    if ($LASTEXITCODE -ne 0) {
        $errors += "Build failed - fix compilation errors before committing"
    }
}

# TypeScript check (look in common locations)
$tsconfigLocations = @("tsconfig.json", "src/*/tsconfig.json", "*/tsconfig.json")
$tsconfigFound = $false
foreach ($location in $tsconfigLocations) {
    if (Test-Path $location) {
        $tsconfigFound = $true
        break
    }
}
if ($tsconfigFound) {
    Write-Host "  ✓ Checking TypeScript..." -ForegroundColor Gray
    # Check if npx is available
    $npxAvailable = Get-Command npx -ErrorAction SilentlyContinue
    if ($npxAvailable) {
        $tsOutput = npx tsc --noEmit 2>&1
        if ($LASTEXITCODE -ne 0) {
            $errors += "TypeScript compilation failed - fix type errors"
        }
    }
}

# 2. SECURITY CHECK - No credentials (only check code files)
Write-Host "  ✓ Checking for secrets..." -ForegroundColor Gray
$stagedFiles = git diff --cached --name-only 2>$null
$codeExtensions = @('.cs', '.ts', '.js', '.json', '.config', '.yml', '.yaml', '.ps1')
foreach ($file in $stagedFiles) {
    # Only check code files, skip binaries/images
    $ext = [System.IO.Path]::GetExtension($file)
    if ($ext -notin $codeExtensions) { continue }
    if (-not (Test-Path $file)) { continue }

    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }

    # Check for hardcoded credentials
    if ($content -match 'password\s*=\s*["''][^"'']{6,}["'']|api[_-]?key\s*=\s*["''][a-zA-Z0-9]{20,}["'']') {
        $errors += "${file}: Contains hardcoded credentials!"
    }
}

# 3. TENANT ISOLATION CHECK - Critical for multi-tenant (C# files only)
Write-Host "  ✓ Checking tenant isolation..." -ForegroundColor Gray
$backendFiles = $stagedFiles | Where-Object { $_ -match "Service\.cs$|Repository\.cs$" }
foreach ($file in $backendFiles) {
    if (-not (Test-Path $file)) { continue }

    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($null -eq $content) { continue }

    # Check for queries without organization filtering
    if ($content -match "\.ToListAsync\(\)|\.FirstOrDefaultAsync\(\)|\.AnyAsync\(\)" -and
        $content -notmatch "OrganizationId|IOrganizationScoped") {
        $errors += "${file}: Missing OrganizationId filter - multi-tenant breach risk!"
    }
}

# Report results
if ($errors.Count -eq 0) {
    Write-Host "`n✅ All checks passed!" -ForegroundColor Green
    exit 0
}

Write-Host "`n❌ COMMIT BLOCKED:" -ForegroundColor Red
foreach ($error in $errors) {
    Write-Host "   • $error" -ForegroundColor Red
}
Write-Host "`nFix these issues or use: git commit --no-verify" -ForegroundColor Gray

exit 2  # Block the commit