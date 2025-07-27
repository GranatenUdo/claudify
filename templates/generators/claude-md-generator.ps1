# CLAUDE.md Generator Script
# Generates concise CLAUDE.md focused on essential rules for agents/commands

param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Analysis,
    
    [Parameter(Mandatory=$true)]
    [string]$BusinessDomain,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"

function Format-TechStack {
    param($TechStack)
    
    $parts = @()
    
    if ($TechStack.Backend.Framework) {
        $parts += "$($TechStack.Backend.Framework) $($TechStack.Backend.Version)"
    }
    
    if ($TechStack.Frontend.Framework) {
        $parts += $TechStack.Frontend.Framework
    }
    
    if ($TechStack.Database.Count -gt 0) {
        $parts += $TechStack.Database[0]
    }
    
    if ($TechStack.Orchestration) {
        $parts += $TechStack.Orchestration
    }
    
    return $parts -join " + "
}

function Generate-CriticalRules {
    param($Patterns, $TechStack)
    
    $rules = @()
    
    # Architecture rules
    if ($Patterns.ResultPattern.Found) {
        $rules += "- **Result<T>**: All service methods return Result<T>, never throw"
    }
    if ($Patterns.RepositoryPattern.Found) {
        $rules += "- **Repository Pattern**: Data access only via repositories"
    }
    
    # Multi-tenancy rules
    if ($Patterns.MultiTenancy.Found) {
        $rules += "- **$($Patterns.MultiTenancy.Model) Scoping**: EVERY query must filter by $($Patterns.MultiTenancy.Field)"
    }
    
    # Additional critical patterns
    if ($Patterns.DomainDrivenDesign.Found) {
        $rules += "- **DDD**: Business logic in domain models"
    }
    
    return $rules -join "`n"
}

function Generate-SecurityRules {
    param($Patterns)
    
    $rules = @()
    
    if ($Patterns.Authentication.Found -and $Patterns.Authentication.Type -eq "JWT") {
        $rules += "- ❌ **NEVER** accept userId in API endpoints - use JWT token"
        $rules += "- ❌ **NEVER** allow client-controlled userId in DTOs"
    }
    
    if ($Patterns.MultiTenancy.Found) {
        $rules += "- ❌ **NEVER** bypass $($Patterns.MultiTenancy.Model.ToLower()) filtering"
        $rules += "- ✅ **ALWAYS** use ICurrentUserService for user context"
    }
    
    return $rules -join "`n"
}

function Generate-CodePattern {
    param($Language, $Framework, $Patterns, $Domain)
    
    $entity = if ($Domain.Entities.Count -gt 0) { $Domain.Entities[0].Name } else { "Entity" }
    $tenantField = if ($Patterns.MultiTenancy.Found) { $Patterns.MultiTenancy.Field } else { "TenantId" }
    
    if ($Language -eq "C#") {
        return @"
public async Task<Result<$entity>> Create${entity}Async(Create${entity}Dto dto)
{
    // Validation with early return
    if (!IsValid(dto))
        return Result<$entity>.Failure("Validation failed");
    
    // Factory method
    var entity = $entity.Create(_currentUserService.$tenantField, dto);
    
    // Save then invalidate cache
    await _repository.AddAsync(entity);
    await _cacheService.InvalidateAsync(`$`"${entity.ToLower()}:{entity.$tenantField}`");
    
    return Result<$entity>.Success(entity);
}
"@
    }
    elseif ($Language -eq "TypeScript" -and $Framework -match "Angular") {
        $entityLower = $entity.ToLower()
        return @"
export class ${entity}Service {
  private readonly ${entityLower}s = signal<$entity[]>([]);
  
  create$entity(dto: Create${entity}Dto): Observable<$entity> {
    return this.api.post<$entity>('${entityLower}s', dto).pipe(
      tap(item => this.${entityLower}s.update(list => [...list, item])),
      catchError(error => this.errorHandler.handle(error))
    );
  }
}
"@
    }
    return "// Code pattern here"
}

# Generate concise CLAUDE.md content
$claudeMd = @"
# CLAUDE.md - Essential Rules & Patterns

## 🧠 CONTEXT
**System**: $BusinessDomain
**Stack**: $(Format-TechStack $Analysis.TechStack)
**Security**: $($Analysis.Patterns.Authentication.Type) with $($Analysis.Patterns.MultiTenancy.Model.ToLower()) isolation

## ⚡ CRITICAL RULES

### Architecture
$(Generate-CriticalRules $Analysis.Patterns $Analysis.TechStack)

### Security (CRITICAL)
$(Generate-SecurityRules $Analysis.Patterns)

``````csharp
// ❌ WRONG - Security vulnerability
[HttpGet("user/{userId}")]
public async Task<IActionResult> GetUserData(Guid userId) { }

// ✅ CORRECT - Secure
[HttpGet("me")]
public async Task<IActionResult> GetMyData()
{
    var userId = CurrentUser.UserId; // From JWT
}
``````

### Development Workflow
1. Backend first: Model → Repository → Service → API
2. Update FEATURES.md immediately
3. Frontend last: Only for existing APIs
4. Test business logic (80% target)

## 💻 CODE PATTERNS

### $($Analysis.TechStack.Backend.Language) Services
``````$($Analysis.TechStack.Backend.Language.ToLower())
$(Generate-CodePattern $Analysis.TechStack.Backend.Language $Analysis.TechStack.Backend.Framework $Analysis.Patterns $Analysis.Domain.DomainModel)
``````
"@

if ($Analysis.TechStack.Frontend.Framework) {
    $claudeMd += @"

### $($Analysis.TechStack.Frontend.Framework) Services
``````typescript
$(Generate-CodePattern "TypeScript" $Analysis.TechStack.Frontend.Framework $Analysis.Patterns $Analysis.Domain.DomainModel)
``````
"@
}

if ($Analysis.Patterns.MultiTenancy.Found) {
    $claudeMd += @"

### Multi-Tenant Pattern
``````csharp
// Service gets org from CurrentUserService
var $($Analysis.Patterns.MultiTenancy.Field.ToLower()) = _currentUserService.$($Analysis.Patterns.MultiTenancy.Field);

// Repository explicitly filters
public async Task<IEnumerable<$entity>> GetBy$($Analysis.Patterns.MultiTenancy.Model)Async(string $($Analysis.Patterns.MultiTenancy.Field.ToLower()))
{
    return await _dbSet.Where(x => x.$($Analysis.Patterns.MultiTenancy.Field) == $($Analysis.Patterns.MultiTenancy.Field.ToLower())).ToListAsync();
}
``````
"@
}

$claudeMd += @"

## 🔒 SECURITY CHECKLIST
- [ ] No userId parameters in APIs
- [ ] User context from JWT only
"@

if ($Analysis.Patterns.MultiTenancy.Found) {
    $claudeMd += @"  
- [ ] $($Analysis.Patterns.MultiTenancy.Model) filtering in EVERY query
"@
}

$claudeMd += @"
- [ ] Result<T> pattern for all services
- [ ] Cache keys include $($Analysis.Patterns.MultiTenancy.Field)

## 🔍 QUICK REFERENCE

### Key Patterns
- **Domain Models**: Factory methods, soft delete
- **Caching**: 1-5 min TTL, invalidate after writes
"@

if ($Analysis.TechStack.Frontend.Framework -match "Angular") {
    $claudeMd += @"
- **Angular**: Signals for state, standalone components
"@
}

$claudeMd += @"
- **Testing**: Business logic focus, not frameworks

### Environment
``````bash
"@

if ($Analysis.Patterns.Authentication.Type -eq "Auth0") {
    $claudeMd += @"
AUTH0_DOMAIN=your-domain.auth0.com
AUTH0_AUDIENCE=your-api-audience
"@
}

$claudeMd += @"
``````

### Commands
- ``/add-backend-feature`` - DDD backend feature
- ``/add-frontend-feature`` - Frontend for existing API
- ``/fix-backend-bug`` - Debug with analysis
- ``/generate-documentation`` - Tech docs
- ``/generate-marketing-material`` - Sales content

---
**Remember**: Security first. $($Analysis.Patterns.MultiTenancy.Model) isolation always. No exceptions.
"@

# Write the file
$claudeMd | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "✓ Generated concise CLAUDE.md at $OutputPath" -ForegroundColor Green