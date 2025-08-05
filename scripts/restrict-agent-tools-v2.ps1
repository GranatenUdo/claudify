# Restrict Agent Tools Script
# Applies Claude Code best practices for tool access restrictions

param(
    [string]$AgentPath = ".claude/agents",
    [switch]$DryRun,
    [switch]$Verbose
)

$ErrorActionPreference = "Stop"

# Ensure output directory exists
if (-not (Test-Path $AgentPath)) {
    Write-Host "Error: Agent directory not found at $AgentPath" -ForegroundColor Red
    exit 1
}

Write-Host "Agent Tool Access Restriction Script" -ForegroundColor Cyan
Write-Host "=======================================" -ForegroundColor DarkGray

# Tool access matrix based on agent roles
$toolMatrix = @{
    "code-reviewer" = @{
        allowed = @("Read", "Edit", "MultiEdit", "Grep", "Glob", "LS")
        forbidden = @("Write", "Bash", "WebSearch", "WebFetch")
        justification = @{
            "Read" = "Required to read code files"
            "Edit" = "Required to suggest improvements"
            "MultiEdit" = "Required for bulk corrections"
            "Grep" = "Required to search patterns"
            "Glob" = "Required to find related files"
            "LS" = "Required to navigate structure"
        }
    }
    "security-reviewer" = @{
        allowed = @("Read", "Grep", "Glob", "LS", "WebSearch", "Bash")
        forbidden = @("Write", "Edit", "MultiEdit")
        justification = @{
            "Read" = "Required to analyze code and configs"
            "Grep" = "Required to search for vulnerabilities"
            "Glob" = "Required to find security-relevant files"
            "LS" = "Required to navigate structure"
            "WebSearch" = "Required for CVE and threat research"
            "Bash" = "Required for security scanning tools"
        }
    }
    "tech-lead" = @{
        allowed = @("Read", "Write", "Edit", "Grep", "Glob", "LS", "TodoWrite")
        forbidden = @("Bash", "WebFetch")
        justification = @{
            "Read" = "Required to review architecture"
            "Write" = "Required to create documentation"
            "Edit" = "Required to update configurations"
            "Grep" = "Required to find patterns"
            "Glob" = "Required to analyze structure"
            "LS" = "Required to navigate"
            "TodoWrite" = "Required for planning"
        }
    }
    "researcher" = @{
        allowed = @("Read", "WebSearch", "WebFetch", "Write", "TodoWrite")
        forbidden = @("Edit", "MultiEdit", "Bash")
        justification = @{
            "Read" = "Required to read existing docs"
            "WebSearch" = "Required for external research"
            "WebFetch" = "Required to fetch documentation"
            "Write" = "Required to document findings"
            "TodoWrite" = "Required to track research"
        }
    }
    "frontend-developer" = @{
        allowed = @("Read", "Write", "Edit", "MultiEdit", "Grep", "Glob", "LS")
        forbidden = @("Bash", "WebSearch")
        justification = @{
            "Read" = "Required to read components"
            "Write" = "Required to create components"
            "Edit" = "Required to modify UI code"
            "MultiEdit" = "Required for refactoring"
            "Grep" = "Required to find UI patterns"
            "Glob" = "Required to find components"
            "LS" = "Required to navigate"
        }
    }
    "test-quality-analyst" = @{
        allowed = @("Read", "Write", "Grep", "Glob", "LS", "Bash")
        forbidden = @("Edit", "MultiEdit", "WebSearch")
        justification = @{
            "Read" = "Required to analyze test coverage"
            "Write" = "Required to create test files"
            "Grep" = "Required to find test patterns"
            "Glob" = "Required to locate test files"
            "LS" = "Required to navigate"
            "Bash" = "Required to run test commands"
        }
    }
}

# Default restrictive access for unknown agents
$defaultAccess = @{
    allowed = @("Read", "Grep", "Glob", "LS")
    forbidden = @("Write", "Edit", "MultiEdit", "Bash", "WebSearch", "WebFetch")
    justification = @{
        "Read" = "Basic file reading capability"
        "Grep" = "Basic search capability"
        "Glob" = "Basic file finding capability"
        "LS" = "Basic navigation capability"
    }
}

function Get-AgentRole {
    param($AgentName)
    
    # Map agent names to roles
    $roleMap = @{
        "code-reviewer" = "code-reviewer"
        "code-reviewer-enhanced" = "code-reviewer"
        "security-reviewer" = "security-reviewer"
        "security-reviewer-enhanced" = "security-reviewer"
        "tech-lead" = "tech-lead"
        "tech-lead-enhanced" = "tech-lead"
        "researcher" = "researcher"
        "researcher-enhanced" = "researcher"
        "frontend-developer" = "frontend-developer"
        "frontend-developer-enhanced" = "frontend-developer"
        "ux-reviewer" = "frontend-developer"
        "test-quality-analyst" = "test-quality-analyst"
        "test-quality-analyst-enhanced" = "test-quality-analyst"
        "business-domain-analyst" = "researcher"
        "code-simplifier" = "code-reviewer"
        "customer-value-translator" = "researcher"
        "feature-analyzer" = "researcher"
        "infrastructure-architect" = "tech-lead"
        "legacy-system-analyzer" = "researcher"
        "marketing-strategist" = "researcher"
        "sales-genius" = "researcher"
        "technical-debt-analyst" = "code-reviewer"
        "technical-documentation-expert" = "tech-lead"
        "visual-designer" = "frontend-developer"
        "visual-designer-marketing" = "frontend-developer"
    }
    
    $normalizedName = $AgentName.ToLower().Replace("_", "-")
    if ($roleMap.ContainsKey($normalizedName)) {
        return $roleMap[$normalizedName]
    }
    
    # Try to match partial names
    foreach ($key in $roleMap.Keys) {
        if ($normalizedName -like "*$key*") {
            return $roleMap[$key]
        }
    }
    
    return "default"
}

function Update-AgentTools {
    param(
        [string]$FilePath,
        [hashtable]$ToolAccess
    )
    
    $content = Get-Content $FilePath -Raw
    $fileName = Split-Path $FilePath -Leaf
    
    Write-Host "`nProcessing: $fileName" -ForegroundColor White
    
    # Extract current tools using simpler regex
    $toolsSection = $null
    if ($content -match '(?s)tools:\s*\n((?:\s*-[^\n]+\n)+)') {
        $toolsSection = $matches[0]
        $currentToolsBlock = $matches[1]
        
        # Extract tool names
        $currentTools = @()
        $lines = $currentToolsBlock -split '\n'
        foreach ($line in $lines) {
            if ($line -match '^\s*-\s*(\w+)') {
                $currentTools += $matches[1]
            }
        }
        
        Write-Host "  Current tools: $($currentTools -join ', ')" -ForegroundColor DarkGray
        
        # Check for violations
        $violations = $currentTools | Where-Object { $_ -in $ToolAccess.forbidden }
        if ($violations) {
            Write-Host "  WARNING: Forbidden tools found: $($violations -join ', ')" -ForegroundColor Yellow
        }
        
        # Build new tools list
        $newTools = $ToolAccess.allowed
        $removedTools = $currentTools | Where-Object { $_ -notin $newTools }
        $addedTools = $newTools | Where-Object { $_ -notin $currentTools }
        
        if ($removedTools) {
            Write-Host "  - Removing: $($removedTools -join ', ')" -ForegroundColor Red
        }
        if ($addedTools) {
            Write-Host "  + Adding: $($addedTools -join ', ')" -ForegroundColor Green
        }
        
        if (-not $DryRun) {
            # Build new tools section
            $toolsYaml = "tools:`n"
            foreach ($tool in $newTools) {
                $toolsYaml += "  - $tool`n"
            }
            
            # Add justifications if not present
            if ($content -notmatch 'tool_justification:') {
                $toolsYaml += "tool_justification:`n"
                foreach ($tool in $newTools) {
                    if ($ToolAccess.justification.ContainsKey($tool)) {
                        $toolsYaml += "  $tool`: `"$($ToolAccess.justification[$tool])`"`n"
                    }
                }
            }
            
            # Replace tools section
            $newContent = $content -replace '(?s)tools:\s*\n(?:\s*-[^\n]+\n)+', $toolsYaml
            Set-Content -Path $FilePath -Value $newContent.TrimEnd() -NoNewline
            
            Write-Host "  [OK] Updated successfully" -ForegroundColor Green
        } else {
            Write-Host "  [DRY RUN] Would update tools to: $($newTools -join ', ')" -ForegroundColor Cyan
        }
    } else {
        Write-Host "  ERROR: Could not parse tools section" -ForegroundColor Red
    }
}

# Main execution
$agentFiles = Get-ChildItem -Path $AgentPath -Filter "*.md" -File
$totalAgents = $agentFiles.Count
$updatedCount = 0
$violationCount = 0

Write-Host "`nFound $totalAgents agents to process" -ForegroundColor White

foreach ($file in $agentFiles) {
    $agentName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)
    $role = Get-AgentRole -AgentName $agentName
    
    if ($Verbose) {
        Write-Host "`nAgent: $agentName -> Role: $role" -ForegroundColor DarkGray
    }
    
    # Get appropriate tool access
    $toolAccess = if ($toolMatrix.ContainsKey($role)) {
        $toolMatrix[$role]
    } else {
        Write-Host "  WARNING: Using default restrictive access for unknown role" -ForegroundColor Yellow
        $defaultAccess
    }
    
    Update-AgentTools -FilePath $file.FullName -ToolAccess $toolAccess
}

# Summary
Write-Host "`nSummary" -ForegroundColor Cyan
Write-Host "========" -ForegroundColor DarkGray
Write-Host "Total agents processed: $totalAgents" -ForegroundColor White
Write-Host "Agents updated: $updatedCount" -ForegroundColor Green
Write-Host "Violations found: $violationCount" -ForegroundColor Yellow

if ($DryRun) {
    Write-Host "`nThis was a DRY RUN - no files were modified" -ForegroundColor Yellow
    Write-Host "Remove -DryRun flag to apply changes" -ForegroundColor Yellow
}

Write-Host "`nTool restriction process complete!" -ForegroundColor Green

# Generate report
$reportPath = "agent-tool-audit-report.md"
@"
# Agent Tool Access Audit Report

Generated: $(Get-Date -Format "yyyy-MM-dd HH:mm:ss")

## Summary
- Total Agents: $totalAgents
- Updated: $updatedCount
- Violations: $violationCount

## Tool Access Matrix Applied

### Code Reviewer
- **Allowed**: Read, Edit, MultiEdit, Grep, Glob, LS
- **Forbidden**: Write, Bash, WebSearch, WebFetch

### Security Reviewer
- **Allowed**: Read, Grep, Glob, LS, WebSearch, Bash
- **Forbidden**: Write, Edit, MultiEdit

### Tech Lead
- **Allowed**: Read, Write, Edit, Grep, Glob, LS, TodoWrite
- **Forbidden**: Bash, WebFetch

### Researcher
- **Allowed**: Read, WebSearch, WebFetch, Write, TodoWrite
- **Forbidden**: Edit, MultiEdit, Bash

### Frontend Developer
- **Allowed**: Read, Write, Edit, MultiEdit, Grep, Glob, LS
- **Forbidden**: Bash, WebSearch

### Test Quality Analyst
- **Allowed**: Read, Write, Grep, Glob, LS, Bash
- **Forbidden**: Edit, MultiEdit, WebSearch

## Recommendations

1. Review agents with custom roles
2. Add tool justifications to all agents
3. Implement regular tool access audits
4. Document any exceptions with security review

## Next Steps

1. Run without -DryRun to apply changes
2. Test agents after tool restrictions
3. Update documentation
4. Commit changes to version control
"@ | Set-Content -Path $reportPath

Write-Host "`nDetailed report saved to: $reportPath" -ForegroundColor Cyan