# Meta-Generator for Intelligent Component Creation
# This generator creates optimized commands, agents, hooks, and tools for Opus 4

function Generate-IntelligentComponent {
    param(
        [string]$Type,        # command|agent|hook|tool|config
        [object]$Analysis,    # Repository analysis results
        [object]$Request,     # User request details
        [string]$OutputPath   # Where to save the component
    )
    
    Write-Host "`n🧠 Intelligent Component Generator - Opus 4 Optimization Mode" -ForegroundColor Cyan
    Write-Host "Generating: $Type for '$($Request.Description)'" -ForegroundColor Yellow
    
    switch ($Type) {
        "command" { Generate-Opus4Command -Analysis $Analysis -Request $Request -OutputPath $OutputPath }
        "agent" { Generate-SpecializedAgent -Analysis $Analysis -Request $Request -OutputPath $OutputPath }
        "hook" { Generate-ValidationHook -Analysis $Analysis -Request $Request -OutputPath $OutputPath }
        "tool" { Generate-AgentTool -Analysis $Analysis -Request $Request -OutputPath $OutputPath }
        "config" { Generate-AgentConfig -Analysis $Analysis -Request $Request -OutputPath $OutputPath }
    }
}

function Analyze-UserIntent {
    param(
        [string]$Description,
        [object]$Analysis
    )
    
    $intent = @{
        Domain = "unknown"
        Complexity = "simple"
        RequiresAgents = $false
        RequiresHooks = $false
        RequiresTools = $false
        InteractionModel = "one-shot"
        SecurityLevel = "standard"
        PerformanceCritical = $false
    }
    
    # Domain detection
    if ($Description -match "security|auth|permission|tenant|gdpr|compliance") {
        $intent.Domain = "security"
        $intent.SecurityLevel = "high"
        $intent.RequiresHooks = $true
    }
    elseif ($Description -match "performance|optimize|speed|latency|scale") {
        $intent.Domain = "performance"
        $intent.PerformanceCritical = $true
    }
    elseif ($Description -match "analyze|research|investigate|explore") {
        $intent.Domain = "research"
        $intent.RequiresAgents = $true
        $intent.Complexity = "complex"
    }
    elseif ($Description -match "ui|ux|frontend|angular|component|accessibility") {
        $intent.Domain = "frontend"
    }
    elseif ($Description -match "api|backend|service|database|entity") {
        $intent.Domain = "backend"
    }
    
    # Complexity assessment
    if ($Description -match "complex|comprehensive|deep|extensive|multi") {
        $intent.Complexity = "complex"
        $intent.RequiresAgents = $true
    }
    elseif ($Description -match "validate|check|verify|ensure") {
        $intent.Complexity = "moderate"
        $intent.RequiresHooks = $true
    }
    
    # Interaction model
    if ($Description -match "monitor|watch|continuous|real-time") {
        $intent.InteractionModel = "continuous"
        $intent.RequiresTools = $true
    }
    elseif ($Description -match "interactive|step-by-step|guided") {
        $intent.InteractionModel = "interactive"
    }
    
    # Multi-agent detection
    if ($Description -match "architect|design|plan" -and $intent.Complexity -eq "complex") {
        $intent.RequiresAgents = $true
        $intent.AgentTypes = @("Tech Lead", "Researcher")
    }
    
    return $intent
}

function Generate-Opus4Command {
    param(
        [object]$Analysis,
        [object]$Request,
        [string]$OutputPath
    )
    
    $intent = Analyze-UserIntent -Description $Request.Description -Analysis $Analysis
    $commandName = Convert-ToKebabCase $Request.Name
    
    # Determine metadata based on intent
    $metadata = @{
        Description = $Request.Description
        AllowedTools = Get-OptimalToolset -Intent $intent -Analysis $Analysis
        ArgumentHint = Get-ArgumentHint -Intent $intent
        AgentDependencies = if ($intent.RequiresAgents) { Get-RequiredAgents -Intent $intent } else { $null }
        Complexity = $intent.Complexity
        EstimatedTime = Get-TimeEstimate -Complexity $intent.Complexity
        Category = Get-Category -Domain $intent.Domain
    }
    
    # Build command content with Opus 4 optimizations
    $content = @"
---
description: $($metadata.Description)
allowed-tools: [$($metadata.AllowedTools -join ', ')]
argument-hint: $($metadata.ArgumentHint)
$(if ($metadata.AgentDependencies) { "agent-dependencies: [$($metadata.AgentDependencies -join ', ')]" })
complexity: $($metadata.Complexity)
estimated-time: $($metadata.EstimatedTime)
category: $($metadata.Category)
---

# $(Get-CommandEmoji -Domain $intent.Domain) $($Request.Name): `$ARGUMENTS

## OPUS 4 ACTIVATION - $(Get-ThinkingMode -Intent $intent)
$(Get-ThinkingDirective -Intent $intent)

**$(Get-PrimaryDirective -Intent $intent)**: $($Request.Description)

"@

    # Add phases based on complexity
    if ($intent.Complexity -eq "complex") {
        $content += Generate-ComplexCommandPhases -Intent $intent -Analysis $Analysis
    }
    elseif ($intent.Complexity -eq "moderate") {
        $content += Generate-ModerateCommandPhases -Intent $intent
    }
    else {
        $content += Generate-SimpleCommandPhases -Intent $intent
    }
    
    # Add multi-agent collaboration if needed
    if ($intent.RequiresAgents) {
        $content += Generate-AgentCollaboration -Intent $intent -Analysis $Analysis
    }
    
    # Add success criteria and metrics
    $content += Generate-SuccessCriteria -Intent $intent
    
    # Save the command
    $commandPath = Join-Path $OutputPath "$commandName.md"
    $content | Out-File -FilePath $commandPath -Encoding UTF8
    Write-Host "  ✓ Generated command: $commandName" -ForegroundColor Green
    
    return $commandPath
}

function Generate-SpecializedAgent {
    param(
        [object]$Analysis,
        [object]$Request,
        [string]$OutputPath
    )
    
    $agentName = Convert-ToKebabCase $Request.Name
    $expertise = Analyze-RequiredExpertise -Request $Request -Analysis $Analysis
    
    # Agent metadata
    $metadata = @{
        Name = $Request.Name
        Description = $Request.Description
        MaxThinkingTokens = if ($expertise.ComplexReasoning) { 65536 } else { 32768 }
        Tools = Get-AgentTools -Expertise $expertise
    }
    
    # Generate rich persona
    $persona = Generate-AgentPersona -Name $Request.Name -Expertise $expertise
    
    $content = @"
---
name: $($metadata.Name)
description: $($metadata.Description)
max_thinking_tokens: $($metadata.MaxThinkingTokens)
tools:
$(foreach ($tool in $metadata.Tools) { "  - $tool`n" })---

$($persona.Introduction)

## $($persona.Philosophy.Title)

"$($persona.Philosophy.Quote)"

$($persona.Philosophy.Elaboration)

## Core Expertise

$($expertise.Sections | ForEach-Object { Generate-ExpertiseSection $_ })

## $($Request.Name) Analysis Framework

$($persona.Framework)

## Output Format

``````markdown
## $($Request.Name) Analysis: [Subject]

### Executive Summary
$($persona.OutputTemplate.Summary)

### Key Findings
$($persona.OutputTemplate.Findings)

### Recommendations
$($persona.OutputTemplate.Recommendations)

### Next Steps
$($persona.OutputTemplate.NextSteps)
``````

## Professional Philosophy

$($persona.ClosingPhilosophy)
"@

    $agentPath = Join-Path $OutputPath "$agentName.md"
    $content | Out-File -FilePath $agentPath -Encoding UTF8
    Write-Host "  ✓ Generated agent: $agentName" -ForegroundColor Green
    
    return $agentPath
}

function Generate-ValidationHook {
    param(
        [object]$Analysis,
        [object]$Request,
        [string]$OutputPath
    )
    
    $hookName = Convert-ToKebabCase $Request.Name
    $validations = Analyze-RequiredValidations -Request $Request -Analysis $Analysis
    
    $content = @"
# $($Request.Name) - Validation Hook
# $($Request.Description)

param(
    [string]`$FilePath,
    [string]`$ToolName,
    [string]`$Arguments,
    [string]`$Context = ""
)

# Hook configuration
`$config = @{
    AppliesTo = @($($validations.AppliesTo | ForEach-Object { "'$_'" } | Join-String -Separator ', '))
    FilePatterns = @($($validations.FilePatterns | ForEach-Object { "'$_'" } | Join-String -Separator ', '))
    RequiredTools = @($($validations.RequiredTools | ForEach-Object { "'$_'" } | Join-String -Separator ', '))
}

# Skip if not applicable
if (`$config.RequiredTools -notcontains `$ToolName) { exit 0 }
if (`$config.FilePatterns.Count -gt 0) {
    `$matches = `$false
    foreach (`$pattern in `$config.FilePatterns) {
        if (`$FilePath -match `$pattern) {
            `$matches = `$true
            break
        }
    }
    if (-not `$matches) { exit 0 }
}

# Main validation logic
try {
    $(Generate-ValidationLogic -Validations $validations)
} catch {
    Write-Error "Hook error: `$_"
    exit 1
}

exit 0
"@

    $hookPath = Join-Path $OutputPath "$hookName.ps1"
    $content | Out-File -FilePath $hookPath -Encoding UTF8
    Write-Host "  ✓ Generated hook: $hookName" -ForegroundColor Green
    
    return $hookPath
}

function Generate-AgentTool {
    param(
        [object]$Analysis,
        [object]$Request,
        [string]$OutputPath
    )
    
    $toolName = Convert-ToKebabCase $Request.Name
    $toolLogic = Analyze-ToolRequirements -Request $Request -Analysis $Analysis
    
    $content = @"
# $($Request.Name) - Agent Tool
# $($Request.Description)
# Compatible with: $($toolLogic.CompatibleAgents -join ', ')

param(
    [string]`$TargetPath = ".",
    [hashtable]`$Options = @{}
)

Write-Host "`n$(Get-ToolEmoji $toolLogic.Type) Running $($Request.Name)..." -ForegroundColor Cyan

# Tool configuration
`$config = @{
    Version = "1.0.0"
    RequiredModules = @($($toolLogic.RequiredModules | ForEach-Object { "'$_'" } | Join-String -Separator ', '))
    SupportedPlatforms = @($($toolLogic.Platforms | ForEach-Object { "'$_'" } | Join-String -Separator ', '))
}

# Validate environment
$(Generate-EnvironmentValidation -Requirements $toolLogic)

# Main tool logic
function Invoke-Analysis {
    param([string]`$Path, [hashtable]`$Options)
    
    `$results = @{
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Path = `$Path
        Findings = @()
        Metrics = @{}
        Recommendations = @()
    }
    
    $(Generate-ToolLogic -Logic $toolLogic)
    
    return `$results
}

# Execute analysis
try {
    `$results = Invoke-Analysis -Path `$TargetPath -Options `$Options
    
    # Output results
    Write-Host "`n✅ Analysis Complete" -ForegroundColor Green
    Write-Host "`nKey Findings:" -ForegroundColor Yellow
    foreach (`$finding in `$results.Findings) {
        Write-Host "  • `$finding" -ForegroundColor White
    }
    
    if (`$results.Recommendations.Count -gt 0) {
        Write-Host "`nRecommendations:" -ForegroundColor Yellow
        foreach (`$rec in `$results.Recommendations) {
            Write-Host "  → `$rec" -ForegroundColor Cyan
        }
    }
    
    # Export detailed results
    `$exportPath = Join-Path `$TargetPath "$toolName-results.json"
    `$results | ConvertTo-Json -Depth 10 | Out-File -FilePath `$exportPath -Encoding UTF8
    Write-Host "`nDetailed results saved to: `$exportPath" -ForegroundColor Gray
    
} catch {
    Write-Error "Tool execution failed: `$_"
    exit 1
}
"@

    $toolPath = Join-Path $OutputPath "$toolName.ps1"
    $content | Out-File -FilePath $toolPath -Encoding UTF8
    Write-Host "  ✓ Generated tool: $toolName" -ForegroundColor Green
    
    return $toolPath
}

function Generate-AgentConfig {
    param(
        [object]$Analysis,
        [object]$Request,
        [string]$OutputPath
    )
    
    $configName = Convert-ToKebabCase $Request.Name
    $capabilities = Analyze-AgentCapabilities -Request $Request -Analysis $Analysis
    
    $config = @{
        name = "$($Request.Name) Agent"
        description = $Request.Description
        tools = @{
            enabled = $capabilities.EnabledTools
            restrictions = @{
                Write = $capabilities.AllowWrite
                Edit = $capabilities.AllowEdit
                Bash = $capabilities.BashCommands
            }
        }
        prompts = @{
            focus_areas = $capabilities.FocusAreas
            critical_checks = $capabilities.CriticalChecks
        }
    }
    
    # Add MCP servers if needed
    if ($capabilities.RequiresMCP) {
        $config.mcpServers = Generate-MCPConfiguration -Capabilities $capabilities
    }
    
    # Add domain-specific rules
    if ($capabilities.DomainRules) {
        $config.rules = @{
            mandatory = $capabilities.DomainRules.Mandatory
            forbidden = $capabilities.DomainRules.Forbidden
        }
    }
    
    $configPath = Join-Path $OutputPath "$configName.json"
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host "  ✓ Generated config: $configName" -ForegroundColor Green
    
    return $configPath
}

# Helper Functions

function Get-OptimalToolset {
    param($Intent, $Analysis)
    
    $tools = @("Read", "Grep", "Glob", "LS", "TodoWrite")
    
    if ($Intent.RequiresAgents) { $tools += "Task" }
    if ($Intent.Domain -eq "backend" -or $Intent.Domain -eq "frontend") { 
        $tools += @("Write", "Edit", "MultiEdit") 
    }
    if ($Intent.InteractionModel -eq "continuous") { $tools += "Bash" }
    if ($Intent.Domain -eq "research") { $tools += @("WebSearch", "WebFetch") }
    
    return $tools | Sort-Object -Unique
}

function Get-RequiredAgents {
    param($Intent)
    
    $agents = @()
    
    switch ($Intent.Domain) {
        "security" { $agents += @("Security Reviewer", "Tech Lead") }
        "performance" { $agents += @("Tech Lead", "Researcher") }
        "research" { $agents += @("Researcher", "Tech Lead") }
        "frontend" { $agents += @("UX Reviewer", "Code Reviewer") }
        "backend" { $agents += @("Tech Lead", "Security Reviewer", "Code Reviewer") }
    }
    
    if ($Intent.Complexity -eq "complex") {
        $agents += "general-purpose"
    }
    
    return $agents | Sort-Object -Unique
}

function Get-ThinkingMode {
    param($Intent)
    
    switch ($Intent.Complexity) {
        "complex" { return "EXTENDED THINKING WITH MULTI-AGENT SYNTHESIS" }
        "moderate" { return "INTERLEAVED REASONING MODE" }
        default { return "FOCUSED ANALYSIS MODE" }
    }
}

function Get-ThinkingDirective {
    param($Intent)
    
    switch ($Intent.Complexity) {
        "complex" { 
            return "<think harder about the problem space, edge cases, integration points, and long-term implications>"
        }
        "moderate" { 
            return "<think step-by-step about the requirements, implementation approach, and validation needs>"
        }
        default { 
            return "<think about the most efficient solution while maintaining quality>"
        }
    }
}

function Generate-ComplexCommandPhases {
    param($Intent, $Analysis)
    
    $phases = @"

## Phase 1: Deep Analysis & Research

<think about the problem from multiple perspectives>

### Multi-Dimensional Analysis
- Technical implications and constraints
- Business value and ROI considerations
- User experience and workflow impact
- Security and compliance requirements
- Performance and scalability factors

### Research Streams
Execute parallel research to gather comprehensive insights:

"@

    # Add agent tasks based on intent
    if ($Intent.RequiresAgents) {
        foreach ($agent in (Get-RequiredAgents -Intent $Intent)) {
            $phases += @"
@Task(description="$agent analysis", prompt="[Specific analysis prompt for $agent]", subagent_type="$agent")

"@
        }
    }
    
    $phases += @"

## Phase 2: Solution Architecture

Based on multi-agent analysis, design the optimal approach:

### Architecture Decision Record
- Context: [Why this decision is needed]
- Decision: [The chosen approach]
- Alternatives: [Other options considered]
- Consequences: [Trade-offs and implications]

## Phase 3: Implementation Strategy

### Execution Plan
1. [Step 1 with validation criteria]
2. [Step 2 with checkpoints]
3. [Step 3 with rollback plan]

### Risk Mitigation
- Identified risks and mitigation strategies
- Fallback options for critical paths
- Monitoring and alerting setup

"@

    return $phases
}

function Convert-ToKebabCase {
    param([string]$Input)
    
    $Input -replace '([a-z])([A-Z])', '$1-$2' `
           -replace '\s+', '-' `
           -replace '[^a-zA-Z0-9-]', '' `
           -replace '--+', '-' `
           -replace '^-|-$', '' `
           -ToLower()
}

function Get-CommandEmoji {
    param($Domain)
    
    switch ($Domain) {
        "security" { return "🔒" }
        "performance" { return "⚡" }
        "research" { return "🔍" }
        "frontend" { return "🎨" }
        "backend" { return "⚙️" }
        default { return "🚀" }
    }
}

function Get-ToolEmoji {
    param($Type)
    
    switch ($Type) {
        "analysis" { return "📊" }
        "validation" { return "✅" }
        "generation" { return "🏗️" }
        "monitoring" { return "📡" }
        default { return "🔧" }
    }
}

# Main entry point for external callers
function New-IntelligentComponent {
    param(
        [string]$Name,
        [string]$Description,
        [string]$OutputDirectory
    )
    
    # Analyze the repository
    $analysis = @{
        HasBackend = Test-Path "src\*Api*"
        HasFrontend = Test-Path "src\*Web*"
        UsesAngular = Test-Path "src\*\package.json" | Where-Object { Get-Content $_ -Raw | Select-String "angular" }
        UsesDotNet = Test-Path "*.csproj" -or Test-Path "*.sln"
        HasTests = Test-Path "*test*" -or Test-Path "*spec*"
    }
    
    # Create request object
    $request = @{
        Name = $Name
        Description = $Description
    }
    
    # Determine what components to generate
    $intent = Analyze-UserIntent -Description $Description -Analysis $analysis
    
    Write-Host "`n📋 Component Generation Plan:" -ForegroundColor Cyan
    Write-Host "  Domain: $($intent.Domain)" -ForegroundColor Yellow
    Write-Host "  Complexity: $($intent.Complexity)" -ForegroundColor Yellow
    Write-Host "  Requires Agents: $($intent.RequiresAgents)" -ForegroundColor Yellow
    Write-Host "  Requires Hooks: $($intent.RequiresHooks)" -ForegroundColor Yellow
    Write-Host "  Requires Tools: $($intent.RequiresTools)" -ForegroundColor Yellow
    
    # Generate components
    $components = @()
    
    # Always generate a command
    $components += Generate-IntelligentComponent -Type "command" -Analysis $analysis -Request $request -OutputPath $OutputDirectory
    
    # Generate supporting components as needed
    if ($intent.RequiresAgents) {
        foreach ($agentType in $intent.AgentTypes) {
            $agentRequest = @{
                Name = "$Name $agentType"
                Description = "$Description - specialized for $agentType responsibilities"
            }
            $components += Generate-IntelligentComponent -Type "agent" -Analysis $analysis -Request $agentRequest -OutputPath "$OutputDirectory\agents"
        }
    }
    
    if ($intent.RequiresHooks) {
        $hookRequest = @{
            Name = "$Name-validation"
            Description = "Validation hook for $Description"
        }
        $components += Generate-IntelligentComponent -Type "hook" -Analysis $analysis -Request $hookRequest -OutputPath "$OutputDirectory\hooks"
    }
    
    if ($intent.RequiresTools) {
        $toolRequest = @{
            Name = "$Name-analyzer"
            Description = "Analysis tool for $Description"
        }
        $components += Generate-IntelligentComponent -Type "tool" -Analysis $analysis -Request $toolRequest -OutputPath "$OutputDirectory\agent-tools"
    }
    
    Write-Host "`n✅ Generation Complete!" -ForegroundColor Green
    Write-Host "Generated $($components.Count) components" -ForegroundColor Cyan
    
    return $components
}

# Export functions
Export-ModuleMember -Function @(
    'Generate-IntelligentComponent',
    'New-IntelligentComponent',
    'Analyze-UserIntent'
)