# Dynamic Context Enhancement Hook - TOP 3 Patterns Only
# Adds the most critical context based on user prompt keywords

param([string]$UserPrompt)

# TOP 3 context patterns to check
$promptLower = $UserPrompt.ToLower()

# 1. SECURITY - Most critical
if ($promptLower -match "service|repository|api|controller|query|database") {
    Write-Host "`n🔒 CRITICAL SECURITY CONTEXT" -ForegroundColor Red
    Write-Host "  • ALWAYS filter by OrganizationId in queries" -ForegroundColor Yellow
    Write-Host "  • NEVER accept userId for personal data" -ForegroundColor Yellow
    Write-Host "  • Use Result<T> pattern, never throw exceptions" -ForegroundColor Yellow
}

# 2. ARCHITECTURE - Common patterns
if ($promptLower -match "create|add|implement|build") {
    Write-Host "`n🏗️ ARCHITECTURE PATTERNS" -ForegroundColor Cyan
    Write-Host "  • Backend: Service → Repository → Result<T>" -ForegroundColor Gray
    Write-Host "  • Frontend: Signals only, no Observables" -ForegroundColor Gray
    Write-Host "  • All components: ChangeDetectionStrategy.OnPush" -ForegroundColor Gray
}

# 3. TESTING - Quality gates
if ($promptLower -match "test|spec|mock") {
    Write-Host "`n🧪 TESTING REQUIREMENTS" -ForegroundColor Green
    Write-Host "  • 80% coverage on business logic" -ForegroundColor Gray
    Write-Host "  • Name: Should_ExpectedBehavior_When_StateUnderTest" -ForegroundColor Gray
    Write-Host "  • Pattern: Arrange-Act-Assert" -ForegroundColor Gray
}

exit 0