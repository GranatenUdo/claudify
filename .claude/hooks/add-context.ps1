# Dynamic Context Enhancement Hook
# Adds relevant context based on user prompts and detected project patterns
# This hook adapts to your project's tech stack and architecture

param(
    [string]$UserPrompt
)

# Try to load project configuration if available
$projectConfig = @{
    TechStack = @{
        Backend = ""
        Frontend = ""
        Database = ""
    }
    Patterns = @{
        MultiTenant = $false
        TenantField = "OrganizationId"
        ResultPattern = $false
        RepositoryPattern = $false
    }
    Domain = ""
}

# Check for common project files to determine context
if (Test-Path "*.csproj") {
    $projectConfig.TechStack.Backend = ".NET"
}
if (Test-Path "package.json") {
    $packageJson = Get-Content "package.json" -Raw | ConvertFrom-Json -ErrorAction SilentlyContinue
    if ($packageJson) {
        if ($packageJson.dependencies."@angular/core") {
            $projectConfig.TechStack.Frontend = "Angular"
        }
        elseif ($packageJson.dependencies.react) {
            $projectConfig.TechStack.Frontend = "React"
        }
        elseif ($packageJson.dependencies.vue) {
            $projectConfig.TechStack.Frontend = "Vue"
        }
    }
}

# Check for CLAUDE.md for project-specific patterns
if (Test-Path "CLAUDE.md") {
    $claudeMd = Get-Content "CLAUDE.md" -Raw
    if ($claudeMd -match "multi-tenant|Multi-tenant|MultiTenant") {
        $projectConfig.Patterns.MultiTenant = $true
    }
    if ($claudeMd -match "(OrganizationId|TenantId|CompanyId|CustomerId)") {
        $projectConfig.Patterns.TenantField = $Matches[1]
    }
    if ($claudeMd -match "Result<T>|Result pattern") {
        $projectConfig.Patterns.ResultPattern = $true
    }
    if ($claudeMd -match "Repository pattern|Repository Pattern") {
        $projectConfig.Patterns.RepositoryPattern = $true
    }
}

# Build context based on prompt content
$context = @()
$promptLower = $UserPrompt.ToLower()

# Backend development context
if ($promptLower -match "service|repository|api|endpoint|controller|backend") {
    $context += "🔧 CONTEXT: Backend Development Patterns"
    
    if ($projectConfig.TechStack.Backend) {
        $context += "- Tech Stack: $($projectConfig.TechStack.Backend)"
    }
    
    if ($projectConfig.Patterns.ResultPattern) {
        $context += "- Return type: Always use Result<T> pattern"
        $context += "- Error handling: No exceptions, use Result.Failure()"
    }
    
    if ($projectConfig.Patterns.MultiTenant) {
        $context += "- Multi-tenant: Always filter by $($projectConfig.Patterns.TenantField)"
        $context += "- Context: Get tenant from ICurrentUserService or equivalent"
    }
    
    if ($projectConfig.Patterns.RepositoryPattern) {
        $context += "- Data Access: Only through repository interfaces"
        $context += "- No direct database context usage in services"
    }
    
    $context += "- Validation: Validate inputs before database operations"
    $context += "- Caching: Invalidate cache after write operations"
}

# Frontend development context
if ($promptLower -match "component|frontend|ui|view|angular|react|vue") {
    $context += "🎨 CONTEXT: Frontend Development Patterns"
    
    if ($projectConfig.TechStack.Frontend) {
        $context += "- Framework: $($projectConfig.TechStack.Frontend)"
        
        # Framework-specific guidance
        switch ($projectConfig.TechStack.Frontend) {
            "Angular" {
                $context += "- Components: Use standalone components"
                $context += "- State: Prefer signals for reactive state"
                $context += "- Forms: Use reactive forms with validators"
                $context += "- HTTP: Handle errors with catchError"
            }
            "React" {
                $context += "- Components: Functional components with hooks"
                $context += "- State: useState, useReducer for complex state"
                $context += "- Side effects: useEffect with cleanup"
                $context += "- Memoization: useMemo, useCallback for performance"
            }
            "Vue" {
                $context += "- Components: Composition API preferred"
                $context += "- State: ref, reactive for reactivity"
                $context += "- Computed: Use computed for derived state"
                $context += "- Lifecycle: onMounted, onUnmounted hooks"
            }
        }
    }
    
    $context += "- Accessibility: WCAG 2.1 AA compliance"
    $context += "- Error handling: User-friendly error messages"
    $context += "- Loading states: Show feedback for async operations"
}

# Security context
if ($promptLower -match "security|auth|authentication|authorization|permission|role") {
    $context += "🔒 CONTEXT: Security Requirements"
    
    if ($projectConfig.Patterns.MultiTenant) {
        $context += "- Multi-tenant isolation is CRITICAL"
        $context += "- Always validate $($projectConfig.Patterns.TenantField) context"
        $context += "- Never allow cross-tenant data access"
    }
    
    $context += "- Authentication: Validate JWT tokens"
    $context += "- Authorization: Check permissions before operations"
    $context += "- Input validation: Sanitize all user inputs"
    $context += "- Audit: Log security-relevant operations"
}

# Testing context
if ($promptLower -match "test|spec|mock|stub|tdd|unit|integration") {
    $context += "🧪 CONTEXT: Testing Best Practices"
    
    if ($projectConfig.TechStack.Backend -eq ".NET") {
        $context += "- Unit tests: xUnit with FluentAssertions"
        $context += "- Mocking: Moq or NSubstitute"
        $context += "- Integration: WebApplicationFactory for API tests"
    }
    elseif ($projectConfig.TechStack.Frontend) {
        $context += "- Unit tests: Jest with Testing Library"
        $context += "- Component tests: Render and interact"
        $context += "- E2E tests: Cypress or Playwright"
    }
    
    $context += "- Coverage: Aim for 80% on business logic"
    $context += "- Test naming: Should_ExpectedBehavior_When_StateUnderTest"
    $context += "- Arrange-Act-Assert pattern"
}

# Database/Data context
if ($promptLower -match "database|entity|model|migration|schema|query") {
    $context += "📊 CONTEXT: Data Layer Patterns"
    
    if ($projectConfig.Patterns.MultiTenant) {
        $context += "- CRITICAL: Every table needs $($projectConfig.Patterns.TenantField)"
        $context += "- Indexes: Always include $($projectConfig.Patterns.TenantField) first"
    }
    
    if ($projectConfig.TechStack.Backend -eq ".NET") {
        $context += "- ORM: Entity Framework Core"
        $context += "- Migrations: Code-first approach"
        $context += "- Configurations: Fluent API in separate files"
    }
    
    $context += "- Soft deletes: IsDeleted flag, don't hard delete"
    $context += "- Audit fields: CreatedAt, UpdatedAt, CreatedBy, UpdatedBy"
}

# Performance context
if ($promptLower -match "performance|optimize|slow|speed|cache|index") {
    $context += "⚡ CONTEXT: Performance Optimization"
    
    if ($projectConfig.Patterns.MultiTenant) {
        $context += "- Indexes: ($($projectConfig.Patterns.TenantField), [other fields])"
        $context += "- Cache keys: Include $($projectConfig.Patterns.TenantField)"
    }
    
    $context += "- Query optimization: Use includes to prevent N+1"
    $context += "- Caching: 1-5 minute TTL for read-heavy data"
    $context += "- Pagination: Always paginate large result sets"
    $context += "- Async: Use async/await throughout"
}

# Domain-specific context (generic)
if ($promptLower -match "business|domain|requirement|feature|user story") {
    $context += "💼 CONTEXT: Domain-Driven Design"
    $context += "- Entities: Encapsulate business logic"
    $context += "- Value objects: For complex types without identity"
    $context += "- Domain events: For cross-aggregate communication"
    $context += "- Invariants: Enforce in aggregate roots"
}

# Add general best practices if creating new features
if ($promptLower -match "create|add|new|implement|build") {
    $context += "📋 GENERAL BEST PRACTICES:"
    $context += "- Start with tests (TDD approach)"
    $context += "- Follow existing patterns in codebase"
    $context += "- Update documentation (FEATURES.md)"
    $context += "- Consider edge cases and error scenarios"
    $context += "- Review security implications"
}

# Output context if any was added
if ($context.Count -gt 0) {
    Write-Host "`n" -NoNewline
    Write-Host "╔═══════════════════════════════════════╗" -ForegroundColor DarkCyan
    Write-Host "║     AUTOMATED CONTEXT ENHANCEMENT     ║" -ForegroundColor DarkCyan
    Write-Host "╚═══════════════════════════════════════╝" -ForegroundColor DarkCyan
    
    foreach ($item in $context) {
        if ($item -match "^[🔧🎨🔒🧪📊⚡💼📋]") {
            Write-Host "`n$item" -ForegroundColor Cyan
        } else {
            Write-Host "  $item" -ForegroundColor Gray
        }
    }
    
    Write-Host "`n" -NoNewline
    Write-Host "════════════════════════════════════════" -ForegroundColor DarkCyan
    Write-Host ""
}

exit 0