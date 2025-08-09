# Command Generator Script
# Generates standard commands based on repository analysis

param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Analysis,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"

# Ensure output directory exists
if (-not (Test-Path $OutputDirectory)) {
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Standard command generators
function Generate-AddBackendFeature {
    param($Analysis)
    
    return @"
---
description: Create new backend feature following domain-driven design principles
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite]
argument-hint: feature description (e.g., "user authentication with role-based access")
---

# 🏗️ Add Backend Feature: `$ARGUMENTS

## Quick Context
Create a new backend feature with proper domain modeling, security validation, and test coverage following DDD principles.

## Execution Flow
1. **Security & Architecture Planning** - Early validation with specialized agents
2. **Domain Analysis** - Research and model the business domain
3. **Implementation** - Build layers systematically
4. **Quality Assurance** - Testing, review, and documentation

Based on your codebase:
- **Framework**: $($Analysis.TechStack.Backend.Framework) $($Analysis.TechStack.Backend.Version)
- **Patterns**: $(if ($Analysis.Patterns.RepositoryPattern.Found) { "Repository Pattern" }) $(if ($Analysis.Patterns.ResultPattern.Found) { "Result<T> Pattern" }) $(if ($Analysis.Patterns.DomainDrivenDesign.Found) { "Domain-Driven Design" })
$(if ($Analysis.Patterns.MultiTenancy.Found) { "- **Multi-tenancy**: $($Analysis.Patterns.MultiTenancy.Model) isolation via $($Analysis.Patterns.MultiTenancy.Field)" })

I'll have the Security Reviewer analyze security requirements for this feature.

I'll have the Tech Lead evaluate the architectural approach.

`$ARGUMENTS
"@
}

function Generate-AddFrontendFeature {
    param($Analysis)
    
    $framework = $Analysis.TechStack.Frontend.Framework
    if (-not $framework) {
        $framework = "Frontend framework not detected"
    }
    
    return @"
---
description: Create sophisticated UI features with accessibility focus
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite]
argument-hint: feature description (e.g., "dashboard with real-time updates")
---

# 🎨 Add Frontend Feature: `$ARGUMENTS

## Quick Context
Create new frontend features following backend-first workflow with accessibility and UX excellence.

## Execution Flow
1. **API Verification** - Ensure backend endpoints exist
2. **UX Analysis** - Design review with accessibility focus
3. **Implementation** - Component-based development
4. **Quality Checks** - Testing and review

Based on your codebase:
- **Framework**: $framework
$(if ($Analysis.TechStack.Frontend.StateManagement) { "- **State Management**: $($Analysis.TechStack.Frontend.StateManagement)" })
$(if ($Analysis.TechStack.Frontend.UILibrary) { "- **UI Library**: $($Analysis.TechStack.Frontend.UILibrary)" })

I'll have the UX Reviewer analyze the user experience requirements for this feature.

`$ARGUMENTS
"@
}

function Generate-FixBackendBug {
    param($Analysis)
    
    return @"
---
description: Debug and fix backend issues using systematic root cause analysis
allowed-tools: [Task, Read, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: bug description (e.g., "null reference in service layer")
agent-dependencies: [Code Reviewer, Security Reviewer, Researcher, Code Simplifier]
complexity: moderate
estimated-time: 15-30 minutes
category: quality
---

# 🐞 Fix Backend Bug: `$ARGUMENTS

## Quick Context
Systematic debugging and fixing of backend issues with root cause analysis.

<think harder about potential root causes and debugging strategies>

Based on your tech stack ($($Analysis.TechStack.Backend.Framework)):
$(if ($Analysis.Patterns.MultiTenancy.Found) { "- ⚠️ Multi-tenant data isolation critical" })

@Task(description="Bug research", prompt="Research similar bugs and patterns for `$ARGUMENTS", subagent_type="Researcher")

@Task(description="Security check", prompt="Check for security implications of `$ARGUMENTS", subagent_type="Security Reviewer")

`$ARGUMENTS
"@
}

function Generate-FixFrontendBug {
    param($Analysis)
    
    return @"
# Fix Frontend Bug

Debug and fix frontend issues systematically.

## Usage
``````
/fix-frontend-bug [bug description]
``````

## Debugging Process

I'll help you debug and fix frontend issues with a systematic approach.

<think step-by-step about frontend debugging strategies>

Based on your frontend stack$(if ($Analysis.TechStack.Frontend.Framework) { " ($($Analysis.TechStack.Frontend.Framework))" }):
1. **Reproduce issue**: Consistent reproduction steps
2. **Browser DevTools**: Console, Network, Elements
3. **Component state**: Inspect component data
4. **API calls**: Verify request/response
5. **Fix implementation**: Apply solution
6. **Cross-browser test**: Ensure compatibility

Common issues to check:
$(if ($Analysis.TechStack.Frontend.StateManagement -eq "Signals") { "- Signal update timing" })
- State management problems
- API integration errors
- Event handling issues
- CSS/styling conflicts
- Performance bottlenecks

`$ARGUMENTS
"@
}

function Generate-ReviewBackendCode {
    param($Analysis)
    
    return @"
---
description: Comprehensive backend code review for security, performance, and quality
allowed-tools: [Task, Read, Grep, Glob, LS, TodoWrite]
argument-hint: file path or feature name (e.g., "src/services/UserService.cs")
agent-dependencies: [Code Reviewer, Security Reviewer, Tech Lead]
complexity: moderate
estimated-time: 15-20 minutes
category: quality
---

# 🔍 Review Backend Code: `$ARGUMENTS

## Quick Context
Comprehensive code review focusing on security, performance, and architectural compliance.

<think deeply about code quality, security, and performance>

### Review Focus Areas
$(if ($Analysis.Patterns.MultiTenancy.Found) { "- 🔒 **$($Analysis.Patterns.MultiTenancy.Model) Isolation**: Every query must filter by $($Analysis.Patterns.MultiTenancy.Field)" })
$(if ($Analysis.Patterns.ResultPattern.Found) { "- 📦 **Result<T> Pattern**: Consistent error handling" })
$(if ($Analysis.Patterns.RepositoryPattern.Found) { "- 🏗️ **Repository Pattern**: Proper data access" })

@Task(description="Code review", prompt="Review code quality in `$ARGUMENTS", subagent_type="Code Reviewer")

@Task(description="Security audit", prompt="Audit security in `$ARGUMENTS", subagent_type="Security Reviewer")

@Task(description="Architecture review", prompt="Review architecture in `$ARGUMENTS", subagent_type="Tech Lead")

`$ARGUMENTS
"@
}

function Generate-ReviewFrontendCode {
    param($Analysis)
    
    return @"
# Review Frontend Code

Perform comprehensive frontend code review focusing on accessibility and UX.

## Usage
``````
/review-frontend-code [file or directory path]
``````

## Review Process

I'll review your frontend code with focus on:

<think about UX, accessibility, and performance>

### Accessibility Review
- **WCAG 2.1 Compliance**: AA level standards
- **Keyboard Navigation**: Full keyboard support
- **Screen Readers**: Proper ARIA labels
- **Color Contrast**: Sufficient ratios

### UX Review
- **Consistency**: UI patterns and behaviors
- **Responsiveness**: Mobile and desktop
- **Loading States**: User feedback
- **Error Handling**: Clear error messages

### Performance Review
- **Bundle Size**: Code splitting strategies
- **Render Performance**: Optimization techniques
$(if ($Analysis.TechStack.Frontend.StateManagement) { "- **State Management**: Efficient $($Analysis.TechStack.Frontend.StateManagement) usage" })
- **API Calls**: Proper data fetching

`$ARGUMENTS
"@
}

function Generate-FixBackendBuildAndTests {
    param($Analysis)
    
    return @"
# Fix Backend Build and Tests

Diagnose and fix backend build errors and test failures.

## Usage
``````
/fix-backend-build-and-tests
``````

## Diagnostic Process

I'll help fix build and test issues for your $($Analysis.TechStack.Backend.Framework) backend.

<think systematically about build and test problems>

### Build Issues
1. **Package Restoration**: Missing or conflicting packages
2. **Reference Problems**: Project references
3. **Version Conflicts**: Dependency versions
4. **Configuration**: Build settings

### Test Failures
1. **Unit Tests**: Business logic tests
2. **Integration Tests**: Database and API tests
3. **Test Data**: Fixtures and mocks
4. **Test Isolation**: Parallel execution issues

Common fixes:
``````bash
# Clean and rebuild
$(if ($Analysis.TechStack.Backend.Framework -match "\.NET") { "dotnet clean && dotnet build" } else { "npm run clean && npm run build" })

# Restore packages
$(if ($Analysis.TechStack.Backend.Framework -match "\.NET") { "dotnet restore" } else { "npm install" })

# Run tests with details
$(if ($Analysis.TechStack.Backend.Framework -match "\.NET") { "dotnet test --logger:'console;verbosity=detailed'" } else { "npm test -- --verbose" })
``````

I'll analyze the specific errors and provide targeted solutions.
"@
}

function Generate-FixFrontendBuildAndTests {
    param($Analysis)
    
    $framework = if ($Analysis.TechStack.Frontend.Framework) { $Analysis.TechStack.Frontend.Framework } else { "Frontend" }
    
    return @"
# Fix Frontend Build and Tests

Diagnose and fix frontend build errors and test failures.

## Usage
``````
/fix-frontend-build-and-tests
``````

## Diagnostic Process

I'll help fix build and test issues for your $framework frontend.

<think systematically about frontend build and test problems>

### Build Issues
1. **Module Resolution**: Import path problems
2. **TypeScript Errors**: Type checking issues
3. **Dependency Conflicts**: Package version issues
4. **Build Configuration**: Webpack/build settings

### Test Failures
1. **Component Tests**: UI component testing
2. **Service Tests**: API integration tests
3. **Test Environment**: DOM/browser APIs
4. **Mocking Issues**: Dependencies and services

Common fixes:
``````bash
# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install

# Type checking
$(if ($framework -match "Angular") { "ng build --configuration=development" } else { "npm run build" })

# Run tests with coverage
npm test -- --coverage --verbose
``````

Framework-specific solutions:
$(if ($framework -match "Angular") { "- Angular: Check angular.json, tsconfig paths" })
$(if ($framework -match "React") { "- React: Verify jest config, babel settings" })
$(if ($framework -match "Vue") { "- Vue: Check vue.config.js, test utils" })

I'll analyze the specific errors and provide targeted solutions.
"@
}

# Import generator modules
$legacyGeneratorPath = Join-Path $PSScriptRoot "legacy-generator.ps1"
if (Test-Path $legacyGeneratorPath) {
    . $legacyGeneratorPath
}

$metaGeneratorPath = Join-Path $PSScriptRoot "meta-generator.ps1"
if (Test-Path $metaGeneratorPath) {
    . $metaGeneratorPath
    Write-Host "✨ Meta-Generator loaded - Intelligent component generation enabled" -ForegroundColor Cyan
}

# Generate commands based on analysis
Write-Host "📝 Generating Standard Commands..." -ForegroundColor Cyan

$generatedCommands = @()

# Always generate standard development commands
$standardCommands = @(
    @{
        Name = "add-backend-feature"
        Generator = { param($Analysis) Generate-AddBackendFeature -Analysis $Analysis }
    },
    @{
        Name = "add-frontend-feature"
        Generator = { param($Analysis) Generate-AddFrontendFeature -Analysis $Analysis }
    },
    @{
        Name = "fix-backend-bug"
        Generator = { param($Analysis) Generate-FixBackendBug -Analysis $Analysis }
    },
    @{
        Name = "fix-frontend-bug"
        Generator = { param($Analysis) Generate-FixFrontendBug -Analysis $Analysis }
    },
    @{
        Name = "review-backend-code"
        Generator = { param($Analysis) Generate-ReviewBackendCode -Analysis $Analysis }
    },
    @{
        Name = "review-frontend-code"
        Generator = { param($Analysis) Generate-ReviewFrontendCode -Analysis $Analysis }
    },
    @{
        Name = "fix-backend-build-and-tests"
        Generator = { param($Analysis) Generate-FixBackendBuildAndTests -Analysis $Analysis }
    },
    @{
        Name = "fix-frontend-build-and-tests"
        Generator = { param($Analysis) Generate-FixFrontendBuildAndTests -Analysis $Analysis }
    }
)

# Generate all standard commands
foreach ($cmd in $standardCommands) {
    $commandContent = & $cmd.Generator -Analysis $Analysis
    $commandPath = Join-Path $OutputDirectory "$($cmd.Name).md"
    $commandContent | Out-File -FilePath $commandPath -Encoding UTF8
    $generatedCommands += "$($cmd.Name).md"
    Write-Host "  ✓ Generated command: /$($cmd.Name)" -ForegroundColor Green
}

# Generate legacy analysis command if legacy indicators found
$isLegacy = $false
if ($Analysis.TechStack.Backend.Framework -match "\.NET" -and $Analysis.TechStack.Backend.Version -match "^[1-4]\.") {
    $isLegacy = $true
}
if ($Analysis.Files | Where-Object { $_ -match "\.asmx$|\.svc$|\.aspx$|DataSet|TableAdapter" }) {
    $isLegacy = $true
}

if ($isLegacy -or (Test-Path $legacyGeneratorPath)) {
    Write-Host "🏛️ Generating Legacy Analysis Command..." -ForegroundColor Cyan
    
    # Generate analyze-legacy-system command
    if (Get-Command Generate-AnalyzeLegacySystem -ErrorAction SilentlyContinue) {
        $legacyCommandContent = Generate-AnalyzeLegacySystem -Analysis $Analysis
        $legacyCommandPath = Join-Path $OutputDirectory "analyze-legacy-system.md"
        $legacyCommandContent | Out-File -FilePath $legacyCommandPath -Encoding UTF8
        $generatedCommands += "analyze-legacy-system.md"
        Write-Host "  ✓ Generated command: /analyze-legacy-system" -ForegroundColor Green
    }
}

# Generate Figma command if frontend framework detected
if ($Analysis.TechStack.Frontend.Framework) {
    Write-Host "📐 Generating Figma Integration Command..." -ForegroundColor Cyan
    
    $figmaContent = @"
---
description: Transform current Figma selection into production-ready, accessible, high-quality code using multi-agent analysis and Opus 4's deep reasoning
allowed-tools: [Task, WebFetch, WebSearch, TodoWrite, Read, Write, Edit, MultiEdit, Bash, Grep, Glob, LS]
argument-hint: Optional framework/requirements (e.g., "with $($Analysis.TechStack.Frontend.Framework)" or defaults to project's detected framework)
---

# 🎨 Figma to Production Implementation

## OPUS 4 ACTIVATION - COMPREHENSIVE DESIGN IMPLEMENTATION
<think harder about design intent, user experience, accessibility, performance, and code quality>

**Implementation Directive**: Transform the current Figma selection into production-ready code that prioritizes user experience, accessibility, and maintainability while leveraging multi-agent expertise.

## Phase 1: Design Extraction & Analysis

### Extract Current Selection
``````
@mcp__figma__get_code
Extract the selected Figma design with full context.
Preserve all design decisions, interactions, and states.
``````

### Extract Design System Context
``````
@mcp__figma__get_variable_defs
Extract all design tokens from the selection.
Understand the broader design system context.
``````

### Capture Visual Reference
``````
@mcp__figma__get_image
Capture high-fidelity visual reference for validation.
Document all interactive states and responsive behavior.
``````

## Phase 2: Multi-Agent Analysis

<think step-by-step about leveraging specialized expertise>

### UX Reviewer Analysis
I'll now invoke the UX Reviewer agent to analyze the design from a user experience perspective.

``````
@Task(description="UX design analysis", prompt="Analyze the following Figma design for user experience quality, accessibility compliance, and interaction patterns: [Design context from Phase 1]", subagent_type="UX Reviewer")
``````

The UX Reviewer will evaluate:
- WCAG 2.1 AA compliance
- Interaction patterns and user flow
- Mobile responsiveness
- Cognitive load and usability
- Accessibility features needed

### Tech Lead Architecture Review
Next, I'll consult the Tech Lead for architectural guidance.

``````
@Task(description="Architecture planning", prompt="Recommend component architecture, state management approach, and performance optimizations for implementing: [Design context from Phase 1]", subagent_type="Tech Lead")
``````

The Tech Lead will provide:
- Component hierarchy recommendations
- State management strategy
- Performance optimization approaches
- Scalability considerations
- Integration patterns

### Researcher Deep Analysis
Finally, I'll engage the Researcher for comprehensive analysis.

``````
@Task(description="Implementation research", prompt="Analyze best practices, patterns, and potential challenges for implementing this design with focus on: $($Analysis.TechStack.Frontend.Framework) [Design context from Phase 1]", subagent_type="Researcher")
``````

The Researcher will investigate:
- Framework-specific best practices
- Similar implementation patterns
- Potential technical challenges
- Performance benchmarks
- Alternative approaches

## Phase 3: Implementation Strategy Synthesis

Based on the multi-agent analysis, I'll create a comprehensive implementation plan that incorporates UX requirements, follows architectural best practices, and applies research insights.

## Phase 4: Code Generation

### Component Architecture
Based on $($Analysis.TechStack.Frontend.Framework), I'll generate production-ready components with:
- State management as recommended by Tech Lead
- Accessibility hooks from UX Reviewer
- Performance optimizations from Researcher
- Semantic HTML structure
- ARIA attributes for accessibility
- Responsive design implementation
- Interactive states and animations

### Quality Assurance
- Automated accessibility tests
- Performance validation
- Responsive behavior checks
- Design fidelity comparison

## Phase 5: Documentation & Handoff

Comprehensive documentation including:
- Component API documentation
- Usage examples
- Accessibility notes
- Design decisions rationale
- Integration guide

---

**Remember**: This command leverages the full power of Opus 4's multi-agent system to ensure your Figma designs become not just functional code, but exceptional user experiences that are accessible, performant, and maintainable.

`$ARGUMENTS
"@

    $figmaPath = Join-Path $OutputDirectory "figma-implement-current-selection.md"
    $figmaContent | Out-File -FilePath $figmaPath -Encoding UTF8
    $generatedCommands += "figma-implement-current-selection.md"
    Write-Host "  ✓ Generated command: /figma-implement-current-selection" -ForegroundColor Green
}

# Generate create-command-and-or-agent command if meta-generator is available
if (Get-Command New-IntelligentComponent -ErrorAction SilentlyContinue) {
    Write-Host "🧠 Generating Meta-Command Generator..." -ForegroundColor Cyan
    
    # Create the meta-command directory structure
    $metaCommandDir = Join-Path $OutputDirectory "meta"
    if (-not (Test-Path $metaCommandDir)) {
        New-Item -ItemType Directory -Path $metaCommandDir -Force | Out-Null
    }
    
    # Generate the create-command-and-or-agent command
    $metaRequest = @{
        Name = "create-command-and-or-agent"
        Description = "Intelligently analyze requirements and generate optimized commands, agents, hooks, and tools that maximize Opus 4's capabilities through deep reasoning and multi-agent collaboration"
    }
    
    $metaComponents = New-IntelligentComponent -Name $metaRequest.Name -Description $metaRequest.Description -OutputDirectory $OutputDirectory
    
    if ($metaComponents -and $metaComponents.Count -gt 0) {
        $generatedCommands += "create-command-and-or-agent.md"
        Write-Host "  ✓ Generated meta-command: /create-command-and-or-agent" -ForegroundColor Green
        Write-Host "    This command can now generate other commands and agents intelligently!" -ForegroundColor Yellow
    }
}

Write-Host "✓ Command generation complete ($($generatedCommands.Count) commands)" -ForegroundColor Green

# Return list of generated commands for summary
$generatedCommands