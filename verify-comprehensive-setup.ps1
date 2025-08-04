# Verify Comprehensive Setup
# This script verifies that all agents and commands are included in comprehensive setup

Write-Host "Claudify Comprehensive Setup Verification" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Get all available agents and commands
$availableAgents = Get-ChildItem -Path ".\.claude\agents\*.md" -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -ne "README.md" } | 
    ForEach-Object { $_.BaseName }

$availableCommands = Get-ChildItem -Path ".\.claude\commands\*.md" -ErrorAction SilentlyContinue | 
    Where-Object { $_.Name -notmatch "README|COMMAND-STANDARDS|command-categories" } | 
    ForEach-Object { $_.BaseName }

# Read setup.ps1 and extract comprehensive lists
$setupContent = Get-Content -Path ".\setup.ps1" -Raw

# Extract agents list from comprehensive section
if ($setupContent -match '"comprehensive"\s*\{[\s\S]*?\$agentsToInstall\s*=\s*@\(([\s\S]*?)\)') {
    $agentsList = $matches[1]
    $comprehensiveAgents = [regex]::Matches($agentsList, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
} else {
    Write-Host "Could not extract agents list from setup.ps1" -ForegroundColor Red
    $comprehensiveAgents = @()
}

# Extract commands list from comprehensive section
if ($setupContent -match '"comprehensive"\s*\{[\s\S]*?\$commandsToInstall\s*=\s*@\(([\s\S]*?)\)') {
    $commandsList = $matches[1]
    $comprehensiveCommands = [regex]::Matches($commandsList, '"([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
} else {
    Write-Host "Could not extract commands list from setup.ps1" -ForegroundColor Red
    $comprehensiveCommands = @()
}

# Compare agents
Write-Host "AGENT VERIFICATION" -ForegroundColor Yellow
Write-Host "-----------------" -ForegroundColor Yellow

$missingAgents = @()
$extraAgents = @()

foreach ($agent in $availableAgents) {
    if ($agent -notin $comprehensiveAgents) {
        $missingAgents += $agent
    }
}

foreach ($agent in $comprehensiveAgents) {
    if ($agent -notin $availableAgents) {
        $extraAgents += $agent
    }
}

if ($missingAgents.Count -eq 0) {
    Write-Host "✅ All available agents are included in comprehensive setup" -ForegroundColor Green
} else {
    Write-Host "❌ Missing agents in comprehensive setup:" -ForegroundColor Red
    foreach ($agent in $missingAgents) {
        Write-Host "   - $agent" -ForegroundColor Red
    }
}

if ($extraAgents.Count -gt 0) {
    Write-Host "⚠️ Agents in setup that don't exist in files:" -ForegroundColor Yellow
    foreach ($agent in $extraAgents) {
        Write-Host "   - $agent" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Total available agents: $($availableAgents.Count)" -ForegroundColor Cyan
Write-Host "Agents in comprehensive setup: $($comprehensiveAgents.Count)" -ForegroundColor Cyan
Write-Host ""

# Compare commands
Write-Host "COMMAND VERIFICATION" -ForegroundColor Yellow
Write-Host "-------------------" -ForegroundColor Yellow

$missingCommands = @()
$extraCommands = @()

# init-claudify is special - handled separately
$specialCommands = @("init-claudify")

foreach ($command in $availableCommands) {
    if ($command -notin $comprehensiveCommands -and $command -notin $specialCommands) {
        $missingCommands += $command
    }
}

foreach ($command in $comprehensiveCommands) {
    if ($command -notin $availableCommands) {
        $extraCommands += $command
    }
}

if ($missingCommands.Count -eq 0) {
    Write-Host "✅ All available commands are included in comprehensive setup" -ForegroundColor Green
    if ($specialCommands.Count -gt 0) {
        Write-Host "   (Note: init-claudify is handled separately during setup)" -ForegroundColor DarkGray
    }
} else {
    Write-Host "❌ Missing commands in comprehensive setup:" -ForegroundColor Red
    foreach ($command in $missingCommands) {
        Write-Host "   - $command" -ForegroundColor Red
    }
}

if ($extraCommands.Count -gt 0) {
    Write-Host "⚠️ Commands in setup that don't exist in files:" -ForegroundColor Yellow
    foreach ($command in $extraCommands) {
        Write-Host "   - $command" -ForegroundColor Yellow
    }
}

Write-Host ""
Write-Host "Total available commands: $($availableCommands.Count)" -ForegroundColor Cyan
Write-Host "Commands in comprehensive setup: $($comprehensiveCommands.Count)" -ForegroundColor Cyan
Write-Host "Special commands (handled separately): $($specialCommands -join ', ')" -ForegroundColor DarkGray
Write-Host ""

# Summary
Write-Host "SUMMARY" -ForegroundColor Green
Write-Host "-------" -ForegroundColor Green

$totalIssues = $missingAgents.Count + $missingCommands.Count + $extraAgents.Count + $extraCommands.Count

if ($totalIssues -eq 0) {
    Write-Host "✅ Comprehensive setup is complete and correct!" -ForegroundColor Green
    Write-Host "   All agents and commands are properly configured." -ForegroundColor Green
} else {
    Write-Host "⚠️ Found $totalIssues issue(s) that need attention" -ForegroundColor Yellow
    if ($missingAgents.Count -gt 0 -or $missingCommands.Count -gt 0) {
        Write-Host "   Please update setup.ps1 to include missing components" -ForegroundColor Yellow
    }
    if ($extraAgents.Count -gt 0 -or $extraCommands.Count -gt 0) {
        Write-Host "   Please verify that referenced components exist" -ForegroundColor Yellow
    }
}