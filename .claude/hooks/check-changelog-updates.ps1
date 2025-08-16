# Changelog Reminder Hook - Simple & Effective
# Reminds to update CHANGELOG.md after 5 significant changes

param(
    [string]$EventName,
    [string]$ToolName = "",
    [string]$FilePath = ""
)

# Only process significant edits
if ($EventName -ne "PostToolUse") { exit 0 }
if ($ToolName -notin @("Edit", "MultiEdit", "Write")) { exit 0 }
if ($FilePath -match "\.(test|spec|md|txt)$") { exit 0 }

# Track changes in session file
$sessionFile = "$env:TEMP\claude_changes_$([DateTime]::Now.ToString('yyyyMMdd')).tmp"
if (-not (Test-Path $sessionFile)) {
    "1" | Out-File $sessionFile
} else {
    $count = [int](Get-Content $sessionFile)
    $count++
    $count | Out-File $sessionFile
    
    # Remind every 5 changes
    if ($count % 5 -eq 0) {
        Write-Host "`n📝 CHANGELOG REMINDER" -ForegroundColor Yellow
        Write-Host "  You've made $count significant changes" -ForegroundColor White
        Write-Host "  Run: /update-changelog <description>" -ForegroundColor Cyan
    }
}

exit 0