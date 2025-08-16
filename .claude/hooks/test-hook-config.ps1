# Test hook configuration
Write-Host "`n=== TESTING HOOK CONFIGURATION ===" -ForegroundColor Cyan

# Test 1: Can we execute hooks?
Write-Host "`n1. Testing hook execution..." -ForegroundColor Yellow
$testFile = ".claude/hooks/add-context.ps1"
if (Test-Path $testFile) {
    Write-Host "   ✓ Hook file exists: $testFile" -ForegroundColor Green
    
    # Try to execute it
    try {
        $output = & pwsh -File $testFile -UserPrompt "test" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "   ✓ Hook executes successfully" -ForegroundColor Green
        } else {
            Write-Host "   ✗ Hook failed with exit code: $LASTEXITCODE" -ForegroundColor Red
        }
    } catch {
        Write-Host "   ✗ Error executing hook: $_" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Hook file not found: $testFile" -ForegroundColor Red
}

# Test 2: Check security hook blocks secrets
Write-Host "`n2. Testing security hook..." -ForegroundColor Yellow
$securityHook = ".claude/hooks/security-secrets-check.ps1"
if (Test-Path $securityHook) {
    Write-Host "   ✓ Security hook exists" -ForegroundColor Green
    
    # Test with safe content
    $safeContent = "const apiUrl = 'https://api.example.com'"
    $output = & pwsh -File $securityHook -ToolName "Write" -Content $safeContent 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "   ✓ Safe content passes" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Safe content blocked incorrectly" -ForegroundColor Red
    }
    
    # Test with password (should block)
    $unsafeContent = "password='MySecretPass123'"
    $output = & pwsh -File $securityHook -ToolName "Write" -Content $unsafeContent 2>&1
    if ($LASTEXITCODE -eq 2) {
        Write-Host "   ✓ Password correctly blocked" -ForegroundColor Green
    } else {
        Write-Host "   ✗ Password not blocked (exit code: $LASTEXITCODE)" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Security hook not found" -ForegroundColor Red
}

# Test 3: Check settings.json configuration
Write-Host "`n3. Testing settings.json..." -ForegroundColor Yellow
$settingsFile = ".claude/settings.json"
if (Test-Path $settingsFile) {
    Write-Host "   ✓ Settings file exists" -ForegroundColor Green
    
    $settings = Get-Content $settingsFile -Raw | ConvertFrom-Json
    if ($settings.hooks) {
        Write-Host "   ✓ Hooks configured in settings" -ForegroundColor Green
        
        # Check if paths are relative
        $hasRelativePaths = $true
        foreach ($event in $settings.hooks.PSObject.Properties) {
            foreach ($hook in $event.Value) {
                foreach ($h in $hook.hooks) {
                    if ($h.command -match '\.claude[/\\]hooks') {
                        Write-Host "   ✓ Using relative path: $($h.command.Substring(0, [Math]::Min(50, $h.command.Length)))..." -ForegroundColor Green
                    } elseif ($h.command -match '\$CLAUDE_PROJECT_DIR') {
                        Write-Host "   ⚠ Using environment variable (may not work on Windows)" -ForegroundColor Yellow
                        $hasRelativePaths = $false
                    }
                }
            }
        }
        
        if ($settings.hookSettings.enabled) {
            Write-Host "   ✓ Hooks are enabled" -ForegroundColor Green
        } else {
            Write-Host "   ✗ Hooks are disabled" -ForegroundColor Red
        }
    } else {
        Write-Host "   ✗ No hooks configured" -ForegroundColor Red
    }
} else {
    Write-Host "   ✗ Settings file not found" -ForegroundColor Red
}

Write-Host "`n=== CONFIGURATION TEST COMPLETE ===" -ForegroundColor Cyan
Write-Host "`nRecommendation: The hooks should now work correctly with relative paths." -ForegroundColor Green
Write-Host "The -File parameter tells PowerShell to execute a script file." -ForegroundColor Gray