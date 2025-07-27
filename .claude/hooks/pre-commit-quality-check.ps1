# Pre-commit Quality Check Hook
# Enforces quality standards before allowing commits
# Adapts to project tech stack and coding standards

param(
    [string]$FilePath,
    [string]$ToolName,
    [string]$Arguments
)

# Only run on Git commits
if ($ToolName -ne "Bash" -or $Arguments -notmatch "git commit") {
    exit 0
}

Write-Host "🔍 Running pre-commit quality checks..." -ForegroundColor Yellow
Write-Host "====================================" -ForegroundColor Yellow

$errors = @()
$warnings = @()

# Detect project type and run appropriate checks
$projectType = @{
    DotNet = $false
    NodeJS = $false
    Python = $false
    HasTests = $false
    HasLinter = $false
}

# Check for project indicators
if (Get-ChildItem -Path . -Include "*.csproj", "*.sln" -Recurse -ErrorAction SilentlyContinue) {
    $projectType.DotNet = $true
}
if (Test-Path "package.json") {
    $projectType.NodeJS = $true
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($packageJson.scripts.lint) { $projectType.HasLinter = $true }
    if ($packageJson.scripts.test) { $projectType.HasTests = $true }
}
if (Get-ChildItem -Path . -Include "*.py", "requirements.txt", "setup.py" -Recurse -ErrorAction SilentlyContinue) {
    $projectType.Python = $true
}

# Get list of changed files
$stagedFiles = git diff --cached --name-only 2>$null
if (-not $stagedFiles) {
    Write-Host "No staged files to check" -ForegroundColor Gray
    exit 0
}

Write-Host "`n📋 Checking $($stagedFiles.Count) staged files..." -ForegroundColor Cyan

# Phase 1: Syntax and compilation checks
Write-Host "`n✓ Phase 1: Syntax validation" -ForegroundColor Green

if ($projectType.DotNet) {
    # Check if solution builds
    Write-Host "  - Building .NET solution..." -ForegroundColor Gray
    $buildOutput = dotnet build --no-restore 2>&1
    if ($LASTEXITCODE -ne 0) {
        $errors += "Build failed! Fix compilation errors before committing"
        $errors += ($buildOutput | Select-String -Pattern "error" | Select-Object -First 5)
    }
}

if ($projectType.NodeJS) {
    # Check TypeScript compilation if applicable
    if (Test-Path "tsconfig.json") {
        Write-Host "  - Checking TypeScript compilation..." -ForegroundColor Gray
        $tscOutput = npx tsc --noEmit 2>&1
        if ($LASTEXITCODE -ne 0) {
            $errors += "TypeScript compilation failed!"
            $errors += ($tscOutput | Select-String -Pattern "error" | Select-Object -First 5)
        }
    }
}

# Phase 2: Code quality checks
Write-Host "`n✓ Phase 2: Code quality analysis" -ForegroundColor Green

# Check for common code smells in staged files
foreach ($file in $stagedFiles) {
    if (-not (Test-Path $file)) { continue }
    
    $ext = [System.IO.Path]::GetExtension($file)
    if ($ext -notin @(".cs", ".ts", ".js", ".py", ".java")) { continue }
    
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    # Check for debugging artifacts
    if ($content -match "console\.(log|debug|trace)|Debug\.Write|System\.out\.print") {
        $warnings += "${file}: Contains debug output statements"
    }
    
    # Check for TODO/FIXME without ticket numbers
    $todos = [regex]::Matches($content, "(TODO|FIXME|HACK)(?!.*[A-Z]+-\d+)")
    if ($todos.Count -gt 0) {
        $warnings += "${file}: Contains $($todos.Count) TODO/FIXME without ticket references"
    }
    
    # Check for hardcoded credentials
    if ($content -match 'password\s*=\s*["''][^"'']+["'']|api[_-]?key\s*=\s*["''][^"'']+["'']') {
        $errors += "${file}: SECURITY: Possible hardcoded credentials detected!"
    }
    
    # File size check
    $lines = ($content -split "`n").Count
    if ($lines -gt 500) {
        $warnings += "${file}: Large file ($lines lines) - consider splitting"
    }
}

# Phase 3: Multi-tenant security validation
Write-Host "`n✓ Phase 3: Security and tenant isolation" -ForegroundColor Green

# Check for tenant isolation in backend files
$backendFiles = $stagedFiles | Where-Object { 
    $_ -match "\.(cs|java|py)$" -and 
    $_ -match "(Service|Repository|Controller)" -and 
    $_ -notmatch "(Test|Spec)"
}

foreach ($file in $backendFiles) {
    $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
    if (-not $content) { continue }
    
    # Look for database queries without tenant context
    if ($content -match "(GetAll|FindAll|SELECT \*)" -and 
        $content -notmatch "(OrganizationId|TenantId|CompanyId)") {
        $warnings += "${file}: May be missing tenant isolation in queries"
    }
}

# Phase 4: Test execution (if quick tests available)
if ($projectType.HasTests) {
    Write-Host "`n✓ Phase 4: Running quick tests" -ForegroundColor Green
    
    # Only run unit tests, not integration tests
    if ($projectType.DotNet) {
        Write-Host "  - Running .NET unit tests..." -ForegroundColor Gray
        $testOutput = dotnet test --filter "Category!=Integration" --no-build 2>&1
        if ($LASTEXITCODE -ne 0) {
            $errors += "Unit tests failed! Fix before committing"
        }
    }
    
    if ($projectType.NodeJS) {
        Write-Host "  - Running Jest unit tests..." -ForegroundColor Gray
        $testOutput = npm test -- --passWithNoTests --testPathPattern="\.spec\." 2>&1
        if ($LASTEXITCODE -ne 0) {
            $warnings += "Some unit tests failed"
        }
    }
}

# Phase 5: Linting (if available)
if ($projectType.HasLinter) {
    Write-Host "`n✓ Phase 5: Code style validation" -ForegroundColor Green
    Write-Host "  - Running linter..." -ForegroundColor Gray
    
    $lintOutput = npm run lint 2>&1
    if ($LASTEXITCODE -ne 0) {
        $warnings += "Linting issues found - run 'npm run lint:fix'"
    }
}

# Phase 6: Documentation checks
Write-Host "`n✓ Phase 6: Documentation requirements" -ForegroundColor Green

# Check if significant code changes have corresponding doc updates
$codeFiles = $stagedFiles | Where-Object { $_ -match "\.(cs|ts|js|py)$" }
$docFiles = $stagedFiles | Where-Object { $_ -match "\.(md|txt)$" }

if ($codeFiles.Count -gt 5 -and $docFiles.Count -eq 0) {
    $warnings += "Large code change without documentation updates"
}

# Check for missing XML docs in public APIs (.NET)
if ($projectType.DotNet) {
    foreach ($file in $stagedFiles | Where-Object { $_ -match "\.cs$" }) {
        $content = Get-Content $file -Raw -ErrorAction SilentlyContinue
        if ($content -match "public (class|interface|method)" -and 
            $content -notmatch "///<summary>") {
            $warnings += "${file}: Missing XML documentation for public APIs"
        }
    }
}

# Report results
Write-Host "`n" -NoNewline
Write-Host "════════════════════════════════════" -ForegroundColor DarkCyan
Write-Host "       PRE-COMMIT CHECK RESULTS     " -ForegroundColor Cyan
Write-Host "════════════════════════════════════" -ForegroundColor DarkCyan

if ($errors.Count -eq 0 -and $warnings.Count -eq 0) {
    Write-Host "`n✅ All quality checks passed!" -ForegroundColor Green
    Write-Host "   Your commit is ready to go." -ForegroundColor Gray
    exit 0
}

if ($errors.Count -gt 0) {
    Write-Host "`n❌ ERRORS FOUND (must fix):" -ForegroundColor Red
    foreach ($error in $errors) {
        Write-Host "   • $error" -ForegroundColor Red
    }
}

if ($warnings.Count -gt 0) {
    Write-Host "`n⚠️  WARNINGS (should review):" -ForegroundColor Yellow
    foreach ($warning in $warnings) {
        Write-Host "   • $warning" -ForegroundColor Yellow
    }
}

# Allow override for warnings only
if ($errors.Count -eq 0 -and $warnings.Count -gt 0) {
    Write-Host "`n💡 Warnings don't block commits, but should be addressed" -ForegroundColor Cyan
    Write-Host "   Consider fixing these issues in a follow-up commit" -ForegroundColor Gray
    exit 0
}

# Block commit if errors found
if ($errors.Count -gt 0) {
    Write-Host "`n🚫 Commit blocked due to errors" -ForegroundColor Red
    Write-Host "   Fix the issues above and try again" -ForegroundColor Gray
    Write-Host "`n💡 To bypass (NOT RECOMMENDED):" -ForegroundColor DarkGray
    Write-Host "   git commit --no-verify" -ForegroundColor DarkGray
    exit 2  # Exit code 2 blocks the operation
}

exit 0