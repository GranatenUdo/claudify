# Hook Testing Framework - Validates all hooks work correctly
# Usage: .\test-hooks.ps1 [-Verbose]

param([switch]$Verbose)

Write-Host "`n🧪 HOOK TESTING FRAMEWORK" -ForegroundColor Cyan
Write-Host "=========================" -ForegroundColor Cyan

$testResults = @{
    Passed = 0
    Failed = 0
    Errors = @()
}

# Test helper function
function Test-Hook {
    param(
        [string]$Name,
        [string]$Script,
        [hashtable]$Params = @{},
        [int]$ExpectedExitCode = 0,
        [string]$ExpectedOutput = ""
    )
    
    Write-Host "`nTesting: $Name" -ForegroundColor Yellow
    
    try {
        # Build parameter string
        $paramString = ""
        foreach ($key in $Params.Keys) {
            $paramString += "-$key `"$($Params[$key])`" "
        }
        
        # Execute hook
        $output = & pwsh -File $Script $paramString 2>&1
        $exitCode = $LASTEXITCODE
        
        # Check exit code
        if ($exitCode -eq $ExpectedExitCode) {
            Write-Host "  ✅ Exit code correct: $exitCode" -ForegroundColor Green
            $script:testResults.Passed++
        } else {
            Write-Host "  ❌ Exit code wrong: Expected $ExpectedExitCode, got $exitCode" -ForegroundColor Red
            $script:testResults.Failed++
            $script:testResults.Errors += "$Name - Wrong exit code"
        }
        
        # Check output if specified
        if ($ExpectedOutput -and $output -notmatch $ExpectedOutput) {
            Write-Host "  ❌ Output missing expected text: $ExpectedOutput" -ForegroundColor Red
            $script:testResults.Failed++
            $script:testResults.Errors += "$Name - Missing expected output"
        } elseif ($ExpectedOutput) {
            Write-Host "  ✅ Output contains expected text" -ForegroundColor Green
            $script:testResults.Passed++
        }
        
        if ($Verbose) {
            Write-Host "  Output:" -ForegroundColor Gray
            $output | ForEach-Object { Write-Host "    $_" -ForegroundColor DarkGray }
        }
        
    } catch {
        Write-Host "  ❌ Error: $_" -ForegroundColor Red
        $script:testResults.Failed++
        $script:testResults.Errors += "$Name - Exception: $_"
    }
}

# TEST 1: Context Enhancement Hook
Test-Hook -Name "Context Hook - Security Prompt" `
    -Script "$PSScriptRoot\add-context.ps1" `
    -Params @{ UserPrompt = "create a new service" } `
    -ExpectedOutput "SECURITY CONTEXT"

Test-Hook -Name "Context Hook - Test Prompt" `
    -Script "$PSScriptRoot\add-context.ps1" `
    -Params @{ UserPrompt = "write unit tests" } `
    -ExpectedOutput "TESTING REQUIREMENTS"

# TEST 2: Changelog Reminder Hook
Test-Hook -Name "Changelog Hook - Edit Event" `
    -Script "$PSScriptRoot\check-changelog-updates.ps1" `
    -Params @{ 
        EventName = "PostToolUse"
        ToolName = "Edit"
        FilePath = "test.cs"
    } `
    -ExpectedExitCode = 0

Test-Hook -Name "Changelog Hook - Skip Test Files" `
    -Script "$PSScriptRoot\check-changelog-updates.ps1" `
    -Params @{ 
        EventName = "PostToolUse"
        ToolName = "Edit"
        FilePath = "test.spec.ts"
    } `
    -ExpectedExitCode = 0

# TEST 3: Pre-Commit Quality Check
# Create test file with issue
$testFile = "$env:TEMP\test-service.cs"
@"
public class TestService {
    public async Task<List<Item>> GetAllAsync() {
        return await _context.Items.ToListAsync();  // Missing OrganizationId
    }
}
"@ | Out-File $testFile

# Stage the file (simulate git)
$originalLocation = Get-Location
Set-Location $env:TEMP
git init 2>$null
git add $testFile 2>$null

Test-Hook -Name "Pre-Commit - Missing Tenant Filter" `
    -Script "$PSScriptRoot\pre-commit-quality-check.ps1" `
    -Params @{ 
        ToolName = "Bash"
        Arguments = "git commit -m test"
    } `
    -ExpectedExitCode = 2 `
    -ExpectedOutput "Missing OrganizationId"

Set-Location $originalLocation
Remove-Item $testFile -ErrorAction SilentlyContinue

# TEST 4: Security Secrets Check
Test-Hook -Name "Security Hook - Block API Key" `
    -Script "$PSScriptRoot\security-secrets-check.ps1" `
    -Params @{ 
        ToolName = "Write"
        Content = 'const apiKey = "sk-1234567890abcdefghijklmnop"'
    } `
    -ExpectedExitCode = 2 `
    -ExpectedOutput "SECURITY ALERT"

Test-Hook -Name "Security Hook - Allow Env Variable" `
    -Script "$PSScriptRoot\security-secrets-check.ps1" `
    -Params @{ 
        ToolName = "Write"
        Content = 'const apiKey = process.env.API_KEY'
    } `
    -ExpectedExitCode = 0

Test-Hook -Name "Security Hook - Block Password" `
    -Script "$PSScriptRoot\security-secrets-check.ps1" `
    -Params @{ 
        ToolName = "Write"
        Content = 'password: "MySecretPass123"'
    } `
    -ExpectedExitCode = 2 `
    -ExpectedOutput "password detected"

# TEST 5: Post-Deploy Verification
Test-Hook -Name "Deploy Hook - Docker Check" `
    -Script "$PSScriptRoot\post-deploy-verify.ps1" `
    -Params @{ Arguments = "docker-compose up" } `
    -ExpectedExitCode = 0 `
    -ExpectedOutput "POST-DEPLOY VERIFICATION"

Test-Hook -Name "Deploy Hook - Azure Check" `
    -Script "$PSScriptRoot\post-deploy-verify.ps1" `
    -Params @{ Arguments = "azd up" } `
    -ExpectedExitCode = 0 `
    -ExpectedOutput "Checking service status"

# SUMMARY
Write-Host "`n" -NoNewline
Write-Host "════════════════════════════════" -ForegroundColor Cyan
Write-Host "         TEST RESULTS           " -ForegroundColor Cyan
Write-Host "════════════════════════════════" -ForegroundColor Cyan

$total = $testResults.Passed + $testResults.Failed
$passRate = if ($total -gt 0) { [Math]::Round(($testResults.Passed / $total) * 100, 1) } else { 0 }

Write-Host "`n📊 Summary:" -ForegroundColor White
Write-Host "  Passed: $($testResults.Passed)/$total ($passRate%)" -ForegroundColor Green
Write-Host "  Failed: $($testResults.Failed)" -ForegroundColor $(if ($testResults.Failed -eq 0) { "Gray" } else { "Red" })

if ($testResults.Failed -gt 0) {
    Write-Host "`n❌ Failed Tests:" -ForegroundColor Red
    foreach ($error in $testResults.Errors) {
        Write-Host "  • $error" -ForegroundColor Yellow
    }
    exit 1
} else {
    Write-Host "`n✅ All hooks working correctly!" -ForegroundColor Green
    exit 0
}