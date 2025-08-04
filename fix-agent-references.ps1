# Fix Agent References Script
# This script updates all commands to use only available agents

Write-Host "Agent Reference Fix Script" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan
Write-Host ""

# Define agent mappings
$agentMappings = @{
    "UX Reviewer" = "Visual Designer"
    "Code Reviewer" = "general-purpose"
    "Security Reviewer" = "general-purpose"
    "Code Simplifier" = "Technical Debt Analyst"
    "Researcher" = "general-purpose"
    "Tech Lead" = "general-purpose"
    "Infrastructure Architect" = "general-purpose"
    "Test Quality Analyst" = "general-purpose"
}

# Available agents in Claude
$availableAgents = @(
    "general-purpose",
    "Visual Designer",
    "Technical Debt Analyst",
    "Legacy System Analyzer",
    "Frontend Developer",
    "Business Domain Analyst"
)

Write-Host "Available Claude agents:" -ForegroundColor Green
foreach ($agent in $availableAgents) {
    Write-Host "  ✓ $agent" -ForegroundColor Green
}

Write-Host ""
Write-Host "Agent mappings to apply:" -ForegroundColor Yellow
foreach ($mapping in $agentMappings.GetEnumerator()) {
    Write-Host "  $($mapping.Key) → $($mapping.Value)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Scanning command files..." -ForegroundColor Cyan

# Get all command files
$commandFiles = Get-ChildItem -Path ".\.claude\commands\*.md" -ErrorAction SilentlyContinue

if ($commandFiles.Count -eq 0) {
    Write-Host "No command files found in .\.claude\commands\" -ForegroundColor Red
    exit 1
}

$totalFiles = $commandFiles.Count
$updatedFiles = 0
$fixedReferences = 0

foreach ($file in $commandFiles) {
    Write-Host "Processing: $($file.Name)" -ForegroundColor Gray
    
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileUpdated = $false
    
    # Fix each agent mapping
    foreach ($mapping in $agentMappings.GetEnumerator()) {
        $oldAgent = $mapping.Key
        $newAgent = $mapping.Value
        
        # Pattern 1: subagent_type="Agent Name"
        $pattern1 = "subagent_type=`"$oldAgent`""
        $replacement1 = "subagent_type=`"$newAgent`""
        
        if ($content -match [regex]::Escape($pattern1)) {
            $content = $content -replace [regex]::Escape($pattern1), $replacement1
            $fileUpdated = $true
            $fixedReferences++
            Write-Host "  Fixed: $oldAgent → $newAgent" -ForegroundColor Green
        }
        
        # Pattern 2: subagent_type='Agent Name'
        $pattern2 = "subagent_type='$oldAgent'"
        $replacement2 = "subagent_type='$newAgent'"
        
        if ($content -match [regex]::Escape($pattern2)) {
            $content = $content -replace [regex]::Escape($pattern2), $replacement2
            $fileUpdated = $true
            $fixedReferences++
            Write-Host "  Fixed: $oldAgent → $newAgent" -ForegroundColor Green
        }
    }
    
    # Check for any remaining invalid agents
    if ($content -match 'subagent_type="([^"]+)"') {
        $matches | ForEach-Object {
            $agentName = $_.Groups[1].Value
            if ($agentName -notin $availableAgents -and $agentName -notin $agentMappings.Values) {
                Write-Host "  ⚠️ Warning: Unknown agent '$agentName' still present" -ForegroundColor Yellow
            }
        }
    }
    
    # Save file if updated
    if ($fileUpdated) {
        # Create backup
        $backupPath = "$($file.FullName).backup"
        Copy-Item $file.FullName $backupPath -Force
        
        # Save updated content
        Set-Content -Path $file.FullName -Value $content -NoNewline
        $updatedFiles++
        Write-Host "  ✓ File updated (backup created)" -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Fix Summary" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Files processed: $totalFiles" -ForegroundColor White
Write-Host "Files updated: $updatedFiles" -ForegroundColor $(if ($updatedFiles -gt 0) { "Green" } else { "Gray" })
Write-Host "References fixed: $fixedReferences" -ForegroundColor $(if ($fixedReferences -gt 0) { "Green" } else { "Gray" })

if ($updatedFiles -gt 0) {
    Write-Host ""
    Write-Host "✅ Agent references have been fixed!" -ForegroundColor Green
    Write-Host "Backup files created with .backup extension" -ForegroundColor Gray
} else {
    Write-Host ""
    Write-Host "ℹ️ No agent references needed fixing" -ForegroundColor Cyan
}

# Create validation report
$reportPath = ".\agent-fix-report.txt"
@"
Agent Reference Fix Report
Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

Available Agents:
$($availableAgents -join "`n")

Applied Mappings:
$(foreach ($m in $agentMappings.GetEnumerator()) { "$($m.Key) → $($m.Value)" })

Files Updated: $updatedFiles / $totalFiles
References Fixed: $fixedReferences

Updated Files:
$(($commandFiles | Where-Object { 
    $content = Get-Content $_.FullName -Raw
    $updated = $false
    foreach ($mapping in $agentMappings.GetEnumerator()) {
        if ($content -match [regex]::Escape("subagent_type=`"$($mapping.Key)`"")) {
            $updated = $true
            break
        }
    }
    $updated
} | ForEach-Object { $_.Name }) -join "`n")
"@ | Set-Content $reportPath

Write-Host ""
Write-Host "Report saved to: $reportPath" -ForegroundColor Cyan