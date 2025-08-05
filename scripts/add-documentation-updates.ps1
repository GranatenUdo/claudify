# Add Documentation Update Instructions to Commands and Agents
# Following Opus 4 best practices with parallel processing and confidence scoring

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet("commands", "agents", "both")]
    [string]$Target = "both",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun,
    
    [Parameter(Mandatory=$false)]
    [string]$ClaudifyPath = "E:\claudify"
)

Write-Host "[STARTING] Adding Documentation Update Instructions (Opus 4 Optimized)" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor DarkGray

# Documentation templates following Opus 4 patterns
$commandDocTemplate = @'

## Documentation Updates

<think about what documentation needs updating based on the changes made>

### Update Checklist
Based on the changes made, update these files:

1. **CHANGELOG.md** (Confidence: 95%)
   - Add entry under `[Unreleased]` section
   - Use appropriate section: Added/Changed/Fixed/Removed
   - Include technical details and user impact

2. **FEATURES.md** (If capabilities changed)
   - Document new or modified features
   - Update technical implementation details
   - Include usage examples

3. **CLAUDE.md** (If patterns/conventions introduced)
   - Document new code patterns
   - Update architectural decisions
   - Add domain-specific rules

### Quick Update Commands
```bash
# Automated changelog update
/update-changelog "$ARGUMENTS"

# Manual update template
### [Section]
- Description of change
  - Technical implementation details
  - User-facing impact
  - Breaking changes (if any)
```

### Parallel Documentation Check
Check all documentation files simultaneously for existing references:
```bash
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```
'@

$agentDocTemplate = @'

## Documentation Reminders

<think about what documentation updates the implemented changes require>

When your analysis leads to implemented changes, ensure proper documentation:

### Documentation Checklist (Confidence Scoring)
- **CHANGELOG.md** - Update if changes implemented (Confidence: [X]%)
- **FEATURES.md** - Update if capabilities added/modified (Confidence: [X]%)
- **CLAUDE.md** - Update if patterns/conventions introduced (Confidence: [X]%)

### Recommended Updates
Based on the changes suggested:

1. **For Bug Fixes**: 
   ```markdown
   /update-changelog "Fixed [issue description]"
   ```

2. **For New Features**:
   ```markdown
   /update-changelog "Added [feature description]"
   ```

3. **For Refactoring**:
   ```markdown
   /update-changelog "Changed [component] to [improvement]"
   ```

### Important
- Use confidence scores to prioritize documentation updates
- High confidence (>90%) = Critical to document
- Medium confidence (70-90%) = Should document
- Low confidence (<70%) = Consider documenting

**Remember**: Well-documented changes help the entire team understand system evolution!
'@

# Function to check if file already has documentation instructions
function Test-HasDocumentation {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw -ErrorAction SilentlyContinue
    if (-not $content) { return $false }
    
    return $content -match "(CHANGELOG\.md|FEATURES\.md|CLAUDE\.md|Documentation Updates|Documentation Reminders|update.*changelog)"
}

# Function to add documentation section to file
function Add-DocumentationSection {
    param(
        [string]$FilePath,
        [string]$Template,
        [string]$FileType
    )
    
    $fileName = Split-Path $FilePath -Leaf
    Write-Host "  Processing: $fileName" -NoNewline
    
    if (Test-HasDocumentation $FilePath) {
        Write-Host " [SKIP - Already has documentation]" -ForegroundColor Yellow
        return $false
    }
    
    if ($DryRun) {
        Write-Host " [DRY RUN - Would update]" -ForegroundColor Cyan
        return $true
    }
    
    # Read current content
    $content = Get-Content $FilePath -Raw
    
    # Add documentation section before the last line or at the end
    # Try to add it before any final summary or conclusion
    if ($content -match '(## (Final|Summary|Conclusion|Next Steps)[\s\S]*$)') {
        $beforeSection = $matches[1]
        $newContent = $content.Replace($beforeSection, "$Template`n`n$beforeSection")
    } else {
        # Just append to the end
        $newContent = $content.TrimEnd() + "`n`n$Template"
    }
    
    # Write updated content
    Set-Content -Path $FilePath -Value $newContent -NoNewline
    Write-Host " [UPDATED]" -ForegroundColor Green
    return $true
}

# Process commands
if ($Target -eq "commands" -or $Target -eq "both") {
    Write-Host "`n[PROCESSING] Command Files..." -ForegroundColor Cyan
    $commandsPath = Join-Path $ClaudifyPath ".claude\commands"
    
    # List of commands that should definitely have documentation updates
    $criticalCommands = @(
        "add-backend-feature.md",
        "add-frontend-feature.md",
        "add-integration.md",
        "fix-backend-bug.md",
        "fix-frontend-bug.md",
        "refactor-code.md",
        "optimize-performance.md",
        "update-backend-feature.md",
        "update-frontend-feature.md",
        "comprehensive-review.md",
        "create-command-and-or-agent.md"
    )
    
    $commandFiles = Get-ChildItem -Path $commandsPath -Filter "*.md" -File
    $updatedCount = 0
    $skippedCount = 0
    
    foreach ($file in $commandFiles) {
        $isCritical = $criticalCommands -contains $file.Name
        if ($isCritical) {
            Write-Host "  [CRITICAL]" -NoNewline -ForegroundColor Red
        }
        
        if (Add-DocumentationSection -FilePath $file.FullName -Template $commandDocTemplate -FileType "command") {
            $updatedCount++
        } else {
            $skippedCount++
        }
    }
    
    Write-Host "`n  Summary: $updatedCount updated, $skippedCount skipped" -ForegroundColor White
}

# Process agents
if ($Target -eq "agents" -or $Target -eq "both") {
    Write-Host "`n[PROCESSING] Agent Files..." -ForegroundColor Cyan
    $agentsPath = Join-Path $ClaudifyPath ".claude\agents"
    
    $agentFiles = Get-ChildItem -Path $agentsPath -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" }
    $updatedCount = 0
    $skippedCount = 0
    
    foreach ($file in $agentFiles) {
        if (Add-DocumentationSection -FilePath $file.FullName -Template $agentDocTemplate -FileType "agent") {
            $updatedCount++
        } else {
            $skippedCount++
        }
    }
    
    Write-Host "`n  Summary: $updatedCount updated, $skippedCount skipped" -ForegroundColor White
}

# Final verification
Write-Host "`n[VERIFICATION] Summary" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor DarkGray

# Check commands
if ($Target -eq "commands" -or $Target -eq "both") {
    $commandsWithoutDocs = @()
    $commandFiles = Get-ChildItem -Path (Join-Path $ClaudifyPath ".claude\commands") -Filter "*.md" -File
    
    foreach ($file in $commandFiles) {
        if (-not (Test-HasDocumentation $file.FullName)) {
            $commandsWithoutDocs += $file.Name
        }
    }
    
    if ($commandsWithoutDocs.Count -eq 0) {
        Write-Host "[OK] All command files have documentation instructions" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Commands still missing documentation ($($commandsWithoutDocs.Count)):" -ForegroundColor Red
        $commandsWithoutDocs | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    }
}

# Check agents
if ($Target -eq "agents" -or $Target -eq "both") {
    $agentsWithoutDocs = @()
    $agentFiles = Get-ChildItem -Path (Join-Path $ClaudifyPath ".claude\agents") -Filter "*.md" -File | Where-Object { $_.Name -ne "README.md" }
    
    foreach ($file in $agentFiles) {
        if (-not (Test-HasDocumentation $file.FullName)) {
            $agentsWithoutDocs += $file.Name
        }
    }
    
    if ($agentsWithoutDocs.Count -eq 0) {
        Write-Host "[OK] All agent files have documentation reminders" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Agents still missing documentation ($($agentsWithoutDocs.Count)):" -ForegroundColor Red
        $agentsWithoutDocs | ForEach-Object { Write-Host "   - $_" -ForegroundColor Yellow }
    }
}

Write-Host "`n[SUCCESS] Documentation update process complete!" -ForegroundColor Green

if ($DryRun) {
    Write-Host "`n[WARNING] This was a DRY RUN - no files were actually modified" -ForegroundColor Yellow
    Write-Host "   Run without -DryRun to apply changes" -ForegroundColor Yellow
}