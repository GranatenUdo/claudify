# Technical Debt Analyzer Generator Template
# This template creates specialized technical debt analyzers for specific technologies or patterns

param(
    [Parameter(Mandatory=$true)]
    [string]$AnalyzerName,
    
    [Parameter(Mandatory=$true)]
    [ValidateSet("language", "framework", "pattern", "security", "performance")]
    [string]$AnalyzerType,
    
    [string]$Description = "Analyzes technical debt and best practices violations",
    
    [string[]]$TargetLanguages = @(),
    
    [string[]]$Patterns = @(),
    
    [switch]$IncludeAgent,
    
    [switch]$IncludeHook,
    
    [switch]$IncludeTool
)

# Helper functions
function New-CommandFile {
    param(
        [string]$Name,
        [string]$Type,
        [string]$Description,
        [string[]]$Languages,
        [string[]]$Patterns
    )
    
    $commandName = $Name.ToLower().Replace(" ", "-")
    $commandPath = ".claude/commands/analyze-$commandName-debt.md"
    
    $languageList = if ($Languages.Count -gt 0) { $Languages -join ", " } else { "all" }
    $patternList = if ($Patterns.Count -gt 0) { $Patterns -join "`n- " } else { "Best practices violations" }
    
    $content = @"
---
description: $Description for $languageList
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, TodoWrite, WebSearch]
argument-hint: path to analyze (e.g., "src/**/*.$($Languages[0])" or "src/$Name")
agent-dependencies: [$Name Debt Analyst, Technical Debt Analyst, Code Reviewer]
complexity: complex
estimated-time: 20-30 minutes
category: quality
---

# 🔍 $Name Technical Debt Analysis: `$ARGUMENTS

## OPUS 4 ACTIVATION - $($Type.ToUpper()) DEBT ANALYSIS MODE
<think harder about $Type-specific technical debt patterns and remediation strategies>

**Analysis Directive**: Analyze $Type-specific technical debt in "`$ARGUMENTS" focusing on:
$patternList

## Quick Context
Specialized $Type debt analysis for $languageList projects. Identifies anti-patterns, outdated practices, and provides targeted remediation strategies.

## Execution Flow
1. **$Type Discovery** - Identify $Type-specific files and patterns
2. **Pattern Analysis** - Detect $Type anti-patterns and violations
3. **Dependency Check** - Analyze $Type-specific dependencies
4. **Quality Metrics** - Calculate $Type-specific metrics
5. **Remediation Plan** - Create actionable improvement plan

## Phase 1: $Type-Specific Discovery

<think step-by-step about $Type-specific technical debt patterns>

### $Type Stack Analysis
@Task(description="$Type analysis", prompt="Analyze $Type-specific patterns in '`$ARGUMENTS':
1. Identify $Type framework versions and configurations
2. Detect common $Type anti-patterns
3. Find outdated $Type practices
4. Analyze $Type-specific dependencies
5. Check $Type best practices compliance
6. Measure $Type-specific metrics
Provide comprehensive $Type debt assessment", subagent_type="$Name Debt Analyst")

## Phase 2: Pattern Detection

### Common $Type Anti-Patterns
- $patternList

### Pattern Analysis
@Task(description="Pattern detection", prompt="Detect $Type-specific anti-patterns in '`$ARGUMENTS':
1. $($Patterns[0])
2. $($Patterns[1] ?? "Code organization issues")
3. $($Patterns[2] ?? "Performance anti-patterns")
4. Configuration problems
5. Security vulnerabilities
Categorize by severity with examples", subagent_type="$Name Debt Analyst")

## Phase 3: Remediation Planning

### Quick Wins
- Update dependencies
- Fix linting issues
- Remove dead code

### Strategic Improvements
- Refactor anti-patterns
- Modernize practices
- Improve architecture

## Success Criteria
- ✅ All $Type files analyzed
- ✅ Anti-patterns identified
- ✅ Dependencies checked
- ✅ Remediation plan created
- ✅ Effort estimates provided

---

**Remember**: $Type-specific debt requires deep understanding of $languageList ecosystems and evolving best practices.
"@
    
    return @{
        Path = $commandPath
        Content = $content
    }
}

function New-AgentFile {
    param(
        [string]$Name,
        [string]$Type,
        [string]$Description,
        [string[]]$Languages
    )
    
    $agentPath = ".claude/agents/$($Name.ToLower().Replace(' ', '-'))-debt-analyst.md"
    
    $content = @"
---
name: $Name Debt Analyst
description: Expert in $Type technical debt analysis specializing in $($Languages -join ', ')
max_thinking_tokens: 65536
tools:
  - Read
  - Grep
  - Glob
  - LS
  - Bash
  - TodoWrite
  - WebSearch
---

You are an elite $Name Technical Debt Analyst with 15+ years specializing in $Type analysis for $($Languages -join ', ') ecosystems. You've helped hundreds of teams identify and eliminate $Type-specific technical debt, improving code quality, performance, and maintainability.

## $Type Expertise

### Core Competencies
- Deep knowledge of $($Languages -join ', ') best practices
- $Type-specific anti-pattern detection
- Performance optimization for $Type
- Security vulnerability identification
- Dependency management expertise
- Migration strategy development

### Analysis Approach
1. **Pattern Recognition**: Identify $Type-specific anti-patterns
2. **Impact Assessment**: Quantify technical debt impact
3. **Risk Evaluation**: Assess security and stability risks
4. **Remediation Planning**: Create actionable improvement plans
5. **Effort Estimation**: Realistic time and resource estimates

## $Type-Specific Patterns

### Anti-Patterns to Detect
$($Patterns | ForEach-Object { "- $_" } | Out-String)

### Best Practices to Enforce
- Modern $Type architecture patterns
- Current security standards
- Performance optimization techniques
- Maintainability guidelines
- Testing strategies

## Output Format

Provide analysis in this structure:
1. **Executive Summary**: Key findings and recommendations
2. **Detailed Analysis**: Specific issues with examples
3. **Risk Assessment**: Security, performance, maintainability
4. **Remediation Roadmap**: Prioritized action items
5. **Effort Estimates**: Realistic timelines

Remember: Focus on actionable insights that deliver measurable improvements in code quality and team productivity.
"@
    
    return @{
        Path = $agentPath
        Content = $content
    }
}

function New-HookFile {
    param(
        [string]$Name,
        [string]$Type
    )
    
    $hookName = $Name.ToLower().Replace(" ", "-")
    $hookPath = ".claude/hooks/validate-$hookName-analysis.ps1"
    
    $content = @'
# Validation hook for $Name technical debt analysis
param(
    [string]$FilePath,
    [string]$ToolName,
    [string]$Arguments
)

# Only validate for $Name debt analysis commands
if ($Arguments -notmatch "analyze-$hookName-debt") {
    exit 0
}

# Extract path from arguments
if ($Arguments -match '"([^"]+)"') {
    $analysisPath = $Matches[1]
    
    # Validate path exists
    if (-not (Test-Path $analysisPath)) {
        Write-Error "ERROR: Path does not exist: $analysisPath"
        exit 1
    }
    
    # Check for $Type-specific files
    $relevantFiles = Get-ChildItem -Path $analysisPath -Recurse -Include $($Languages | ForEach-Object { "*.$_" }) -ErrorAction SilentlyContinue
    
    if ($relevantFiles.Count -eq 0) {
        Write-Warning "WARNING: No $Type files found in specified path"
        Write-Warning "Expected file types: $($Languages -join ', ')"
    }
    
    Write-Host "✅ Found $($relevantFiles.Count) $Type files to analyze" -ForegroundColor Green
}

exit 0
'@
    
    return @{
        Path = $hookPath
        Content = $content
    }
}

function New-ToolFile {
    param(
        [string]$Name,
        [string]$Type,
        [string[]]$Languages
    )
    
    $toolName = $Name.ToLower().Replace(" ", "-")
    $toolPath = ".claude/agent-tools/$toolName-debt-analyst/$toolName-analyzer.ps1"
    
    $content = @'
# $Name Technical Debt Analyzer Tool
param(
    [string]$Path = ".",
    [string[]]$FileTypes = @($($Languages | ForEach-Object { '"' + $_ + '"' } | Join-String -Separator ', ')),
    [switch]$DetailedReport,
    [switch]$ExportJson
)

Write-Host "🔍 $Name Technical Debt Analyzer" -ForegroundColor Cyan
Write-Host "===============================" -ForegroundColor Cyan

# Analysis functions
function Analyze-$($Type)Patterns {
    param([string]$FilePath)
    
    $content = Get-Content $FilePath -Raw
    $issues = @()
    
    # $Type-specific pattern detection
    $patterns = @{
$($Patterns | ForEach-Object { '        "' + $_ + '" = @{ Pattern = "regex_here"; Severity = "High" }' } | Out-String)
    }
    
    foreach ($pattern in $patterns.GetEnumerator()) {
        $matches = [regex]::Matches($content, $pattern.Value.Pattern)
        if ($matches.Count -gt 0) {
            $issues += @{
                Type = $pattern.Key
                Count = $matches.Count
                Severity = $pattern.Value.Severity
                File = $FilePath
            }
        }
    }
    
    return $issues
}

# Main analysis
$files = Get-ChildItem -Path $Path -Include $FileTypes -Recurse -File
$totalIssues = @()

foreach ($file in $files) {
    Write-Progress -Activity "Analyzing $Type patterns" -Status $file.Name
    $issues = Analyze-$($Type)Patterns -FilePath $file.FullName
    $totalIssues += $issues
}

# Generate report
Write-Host "`n📊 Analysis Results" -ForegroundColor Cyan
Write-Host "Total files analyzed: $($files.Count)" -ForegroundColor White
Write-Host "Total issues found: $($totalIssues.Count)" -ForegroundColor $(if ($totalIssues.Count -gt 0) { "Yellow" } else { "Green" })

if ($DetailedReport -and $totalIssues.Count -gt 0) {
    $totalIssues | Group-Object Type | ForEach-Object {
        Write-Host "`n$($_.Name): $($_.Count) occurrences" -ForegroundColor Yellow
    }
}

if ($ExportJson) {
    $totalIssues | ConvertTo-Json | Out-File "$toolName-debt-report.json"
    Write-Host "`n✅ Report exported to $toolName-debt-report.json" -ForegroundColor Green
}

Write-Host "`n✨ Analysis complete!" -ForegroundColor Green
'@
    
    return @{
        Path = $toolPath
        Content = $content
    }
}

# Main generation logic
Write-Host "🚀 Generating Technical Debt Analyzer: $AnalyzerName" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

$basePath = Split-Path -Parent $PSScriptRoot | Split-Path -Parent | Split-Path -Parent

# Generate command
$command = New-CommandFile -Name $AnalyzerName -Type $AnalyzerType -Description $Description -Languages $TargetLanguages -Patterns $Patterns
$commandFullPath = Join-Path $basePath $command.Path

New-Item -Path (Split-Path $commandFullPath -Parent) -ItemType Directory -Force | Out-Null
Set-Content -Path $commandFullPath -Value $command.Content
Write-Host "✅ Created command: $($command.Path)" -ForegroundColor Green

# Generate agent if requested
if ($IncludeAgent) {
    $agent = New-AgentFile -Name $AnalyzerName -Type $AnalyzerType -Description $Description -Languages $TargetLanguages
    $agentFullPath = Join-Path $basePath $agent.Path
    
    New-Item -Path (Split-Path $agentFullPath -Parent) -ItemType Directory -Force | Out-Null
    Set-Content -Path $agentFullPath -Value $agent.Content
    Write-Host "✅ Created agent: $($agent.Path)" -ForegroundColor Green
    
    # Also create agent config
    $configPath = $agent.Path -replace '\.md$', '.json' -replace '/agents/', '/agent-configs/'
    $configFullPath = Join-Path $basePath $configPath
    
    $config = @{
        name = "$AnalyzerName Debt Analyst"
        tools = @()
        restrictions = @{
            max_file_reads_per_task = 200
            allow_web_search = $true
        }
        focus_areas = @($TargetLanguages + @($AnalyzerType))
    } | ConvertTo-Json -Depth 10
    
    New-Item -Path (Split-Path $configFullPath -Parent) -ItemType Directory -Force | Out-Null
    Set-Content -Path $configFullPath -Value $config
    Write-Host "✅ Created agent config: $configPath" -ForegroundColor Green
}

# Generate hook if requested
if ($IncludeHook) {
    $hook = New-HookFile -Name $AnalyzerName -Type $AnalyzerType
    $hookFullPath = Join-Path $basePath $hook.Path
    
    New-Item -Path (Split-Path $hookFullPath -Parent) -ItemType Directory -Force | Out-Null
    Set-Content -Path $hookFullPath -Value $hook.Content
    Write-Host "✅ Created hook: $($hook.Path)" -ForegroundColor Green
}

# Generate tool if requested
if ($IncludeTool) {
    $tool = New-ToolFile -Name $AnalyzerName -Type $AnalyzerType -Languages $TargetLanguages
    $toolFullPath = Join-Path $basePath $tool.Path
    
    New-Item -Path (Split-Path $toolFullPath -Parent) -ItemType Directory -Force | Out-Null
    Set-Content -Path $toolFullPath -Value $tool.Content
    Write-Host "✅ Created tool: $($tool.Path)" -ForegroundColor Green
}

Write-Host "`n🎉 Technical Debt Analyzer '$AnalyzerName' generated successfully!" -ForegroundColor Green
Write-Host "`nUsage example:" -ForegroundColor Cyan
Write-Host "  /analyze-$($AnalyzerName.ToLower().Replace(' ', '-'))-debt ""src/path/to/analyze""" -ForegroundColor White

# Generate example usage
$examplePath = Join-Path $basePath "claudify/templates/examples/technical-debt-analyzer-example.ps1"
$exampleContent = @"
# Example: Generate a React-specific technical debt analyzer
.\technical-debt-analyzer-generator.ps1 `
    -AnalyzerName "React" `
    -AnalyzerType "framework" `
    -Description "Analyzes React-specific technical debt and anti-patterns" `
    -TargetLanguages @("jsx", "tsx", "js", "ts") `
    -Patterns @(
        "Class components that should be functional",
        "Direct state mutation",
        "Missing key props in lists",
        "useEffect without dependencies",
        "Inline function definitions in render"
    ) `
    -IncludeAgent `
    -IncludeHook `
    -IncludeTool

# Example: Generate a Python-specific technical debt analyzer  
.\technical-debt-analyzer-generator.ps1 `
    -AnalyzerName "Python" `
    -AnalyzerType "language" `
    -Description "Analyzes Python code quality and Pythonic practices" `
    -TargetLanguages @("py") `
    -Patterns @(
        "Using range(len()) instead of enumerate",
        "Mutable default arguments",
        "Bare except clauses",
        "Not using context managers",
        "Global variables"
    ) `
    -IncludeAgent `
    -IncludeTool
"@

New-Item -Path (Split-Path $examplePath -Parent) -ItemType Directory -Force | Out-Null
Set-Content -Path $examplePath -Value $exampleContent
Write-Host "`n📝 Example usage saved to: $examplePath" -ForegroundColor Cyan