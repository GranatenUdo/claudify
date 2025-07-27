# ADD API FEATURE - OPUS 4 EXTENDED THINKING

<think harder about the feature requirements and domain implications before implementing>

## ACTIVATION
You are implementing a new backend API feature. Use extended thinking to deeply analyze the domain requirements and create a robust, production-ready implementation.

**Feature Request**: "$ARGUMENTS"

## Phase 1: Domain Analysis (Extended Thinking)

<think step-by-step about the domain model and business rules>

### 1.1 Feature Decomposition
- What are the core entities involved?
- What are the business rules and invariants?
- What are the relationships between entities?
- What are the domain events that occur?

### 1.2 Security & Multi-Tenancy
- How does organization/tenant scoping apply?
- What authorization rules are needed?
- What data can cross tenant boundaries (if any)?
- What audit trail requirements exist?

### 1.3 Performance Considerations
- Expected data volume and growth rate
- Read vs write patterns
- Caching opportunities
- Real-time update requirements

## Phase 2: Implementation Plan

### 2.1 Domain Model
Create rich domain entities with:
- Factory methods for creation
- Business logic methods
- Validation rules
- Domain events

### 2.2 Repository Layer
- Define repository interfaces
- Implement with proper tenant filtering
- Include audit fields (CreatedBy, UpdatedBy, etc.)

### 2.3 Service Layer
- Use Result<T> pattern for all returns
- Implement business workflows
- Handle caching and invalidation
- Emit domain events

### 2.4 API Layer
- RESTful endpoint design
- Request/Response DTOs
- Validation attributes
- OpenAPI documentation

### 2.5 Testing Strategy
- Unit tests for domain logic
- Integration tests for workflows
- API tests for endpoints
- Performance tests if needed

## Phase 3: Implementation

### Step 1: Domain Models
```csharp
// Create domain entities with factory methods
public class [Entity] : BaseEntity
{
    // Private constructor for factory method
    private [Entity]() { }
    
    // Factory method
    public static [Entity] Create(Guid organizationId, ...)
    {
        // Validation and business rules
        // Return new instance
    }
    
    // Business methods
    public Result<bool> [BusinessMethod]()
    {
        // Implement business logic
        // Return Result<T>
    }
}
```

### Step 2: Repository
```csharp
public interface I[Entity]Repository : IRepository<[Entity]>
{
    // Custom query methods
}

public class [Entity]Repository : BaseRepository<[Entity]>, I[Entity]Repository
{
    // Implementation with organization filtering
}
```

### Step 3: Service
```csharp
public interface I[Entity]Service
{
    Task<Result<[Entity]>> CreateAsync(Create[Entity]Dto dto);
    // Other methods
}

public class [Entity]Service : I[Entity]Service
{
    // Implement with Result<T> pattern
    // Include caching and real-time updates
}
```

### Step 4: API Controller
```csharp
[ApiController]
[Route("api/v1/[entities]")]
[Authorize]
public class [Entity]Controller : BaseController
{
    // RESTful endpoints
    // Proper HTTP status codes
    // OpenAPI annotations
}
```

### Step 5: Tests
- Domain model tests
- Service tests with mocks
- Integration tests
- API endpoint tests

## Phase 4: Documentation

Update FEATURES.md with:
- Feature description
- API endpoints
- Business rules
- Usage examples

## Phase 5: Verification

Checklist:
- [ ] Organization/tenant scoping implemented
- [ ] Result<T> pattern used throughout
- [ ] Caching strategy implemented
- [ ] Real-time updates if applicable
- [ ] Audit trail complete
- [ ] Tests passing with good coverage
- [ ] API documentation complete
- [ ] FEATURES.md updated

## Remember
- Every database query must filter by organization
- Use factory methods for entity creation
- Business logic belongs in domain models
- Services orchestrate, not implement business logic
- Always update documentation immediately
- Think about edge cases and error scenarios