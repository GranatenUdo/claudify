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
if (Test-Path "*.csproj") {
    Write-Host "  ✓ Checking build..." -ForegroundColor Gray
    $output = dotnet build --no-restore 2>&1
    if ($LASTEXITCODE -ne 0) {
        $errors += "Build failed - fix compilation errors"
    }
}
if (Test-Path "tsconfig.json") {
    Write-Host "  ✓ Checking TypeScript..." -ForegroundColor Gray
    $output = npx tsc --noEmit 2>&1
    if ($LASTEXITCODE -ne 0) {
        $errors += "TypeScript compilation failed"
    }
}

# 2. SECURITY CHECK - No credentials
Write-Host "  ✓ Checking for secrets..." -ForegroundColor Gray
$stagedFiles = git diff --cached --name-only 2>$null
foreach ($file in $stagedFiles) {
    if (-not (Test-Path $file)) { continue }
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($content -match 'password\s*=\s*["''][^"'']+["'']|api[_-]?key\s*=\s*["''][^"'']+["'']') {
        $errors += "${file}: Contains hardcoded credentials!"
    }
}

# 3. TENANT ISOLATION CHECK - Critical for multi-tenant
Write-Host "  ✓ Checking tenant isolation..." -ForegroundColor Gray
$backendFiles = $stagedFiles | Where-Object { $_ -match "Service\.cs$|Repository\.cs$" }
foreach ($file in $backendFiles) {
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if ($content -match "\.ToListAsync\(\)" -and $content -notmatch "OrganizationId") {
        $errors += "${file}: Missing OrganizationId filter!"
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