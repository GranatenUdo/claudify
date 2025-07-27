# Check Changelog Updates Hook - Reminds users to update changelog after significant changes
# Triggered after tool use that makes substantial changes

param(
    [Parameter(Mandatory=$true)]
    [string]$EventName,
    
    [Parameter(Mandatory=$false)]
    [string]$ToolName = "",
    
    [Parameter(Mandatory=$false)]
    [string]$FilePath = "",
    
    [Parameter(Mandatory=$false)]
    [string]$UserPrompt = ""
)

# Configuration
$changelogFile = "CHANGELOG.md"
$significantTools = @("Edit", "MultiEdit", "Write")
$significantPatterns = @(
    "add.*feature",
    "fix.*bug",
    "optimize.*performance",
    "refactor",
    "implement",
    "create.*integration",
    "update.*security",
    "enhance",
    "improve"
)

# Track changes in this session
$script:sessionChanges = @()

# Function to check if this is a significant change
function Test-SignificantChange {
    param(
        [string]$Tool,
        [string]$File,
        [string]$Prompt
    )
    
    # Check if it's a significant tool
    if ($Tool -in $significantTools) {
        # Skip test files and documentation
        if ($File -match "\.(test|spec)\." -or $File -match "\.(md|txt)$") {
            return $false
        }
        
        # Check file patterns for source code
        if ($File -match "\.(cs|ts|js|py|go|java)$") {
            return $true
        }
    }
    
    # Check prompt for significant actions
    foreach ($pattern in $significantPatterns) {
        if ($Prompt -imatch $pattern) {
            return $true
        }
    }
    
    return $false
}

# Function to analyze recent changes
function Get-ChangesSummary {
    $changes = @{
        Added = @()
        Changed = @()
        Fixed = @()
        Security = @()
    }
    
    # Analyze recent file modifications
    $recentFiles = Get-ChildItem -Path . -Recurse -File |
        Where-Object { $_.LastWriteTime -gt (Get-Date).AddMinutes(-30) } |
        Where-Object { $_.FullName -notmatch "node_modules|bin|obj|\.git" }
    
    foreach ($file in $recentFiles) {
        $relativePath = Resolve-Path -Path $file.FullName -Relative
        
        # Categorize based on file name and path
        if ($file.Name -match "^(Create|Add|New)") {
            $changes.Added += $relativePath
        }
        elseif ($file.FullName -match "fix|bug|issue") {
            $changes.Fixed += $relativePath
        }
        elseif ($file.FullName -match "security|auth|permission") {
            $changes.Security += $relativePath
        }
        else {
            $changes.Changed += $relativePath
        }
    }
    
    return $changes
}

# Function to check if changelog was recently updated
function Test-ChangelogRecentlyUpdated {
    if (Test-Path $changelogFile) {
        $lastModified = (Get-Item $changelogFile).LastWriteTime
        $minutesAgo = [Math]::Round(((Get-Date) - $lastModified).TotalMinutes)
        
        return $minutesAgo -lt 5
    }
    
    return $false
}

# Main execution
try {
    # Only process PostToolUse events
    if ($EventName -ne "PostToolUse") {
        exit 0
    }
    
    # Check if this is a significant change
    $isSignificant = Test-SignificantChange -Tool $ToolName -File $FilePath -Prompt $UserPrompt
    
    if ($isSignificant) {
        # Track this change
        $script:sessionChanges += @{
            Tool = $ToolName
            File = $FilePath
            Time = Get-Date
        }
        
        # Check if we should remind about changelog
        $changeCount = $script:sessionChanges.Count
        
        # Remind after every 5 significant changes or if it's been a while
        if ($changeCount -ge 5 -or $changeCount -eq 1) {
            if (-not (Test-ChangelogRecentlyUpdated)) {
                Write-Host "`n💡 CHANGELOG REMINDER" -ForegroundColor Yellow
                Write-Host "You've made $changeCount significant changes in this session." -ForegroundColor White
                
                # Get changes summary
                $summary = Get-ChangesSummary
                
                if ($summary.Added.Count -gt 0 -or $summary.Changed.Count -gt 0 -or 
                    $summary.Fixed.Count -gt 0 -or $summary.Security.Count -gt 0) {
                    
                    Write-Host "`nRecent changes detected:" -ForegroundColor Cyan
                    
                    if ($summary.Added.Count -gt 0) {
                        Write-Host "  Added: $($summary.Added.Count) new features/files" -ForegroundColor Green
                    }
                    if ($summary.Changed.Count -gt 0) {
                        Write-Host "  Changed: $($summary.Changed.Count) modifications" -ForegroundColor Blue
                    }
                    if ($summary.Fixed.Count -gt 0) {
                        Write-Host "  Fixed: $($summary.Fixed.Count) bug fixes" -ForegroundColor Magenta
                    }
                    if ($summary.Security.Count -gt 0) {
                        Write-Host "  Security: $($summary.Security.Count) security updates" -ForegroundColor Red
                    }
                }
                
                Write-Host "`nConsider updating the changelog with:" -ForegroundColor White
                Write-Host "  /update-changelog <description of changes>" -ForegroundColor Gray
                Write-Host ""
                
                # Reset counter after reminder
                if ($changeCount -ge 5) {
                    $script:sessionChanges = @()
                }
            }
        }
    }
    
    # Always allow the operation to continue
    exit 0
}
catch {
    # Log error but don't block the operation
    Write-Host "Changelog reminder hook error: $_" -ForegroundColor Red
    exit 0
}