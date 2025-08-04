---
description: Replace existing feature entirely with no backward compatibility, removing legacy code and implementing modern patterns
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature replacement description (e.g., "replace legacy auth with modern OAuth 2.0")
agent-dependencies: [Tech Lead, Frontend Developer, Security Reviewer, Code Reviewer, Test Quality Analyst, Technical Debt Analyst]
complexity: high
estimated-time: 25-35 minutes
category: development
---

# 🔥 Replace Feature (No Backward Compatibility): $ARGUMENTS

## ⚠️ BREAKING CHANGE MODE ACTIVATED
<think harder about completely replacing this feature with modern implementation, removing all legacy code and technical debt>

### Aggressive Modernization Principles
- **Complete Replacement**: Remove ALL legacy code, no compatibility layer
- **Modern Patterns Only**: Latest frameworks, patterns, and best practices
- **Technical Debt Elimination**: Zero tolerance for legacy workarounds
- **Cloud-Native Design**: Built for scale, no performance monitoring overhead
- **100% Test Coverage**: New tests only, no legacy test maintenance

## Phase 0: Legacy Code Identification & Removal Planning

<think step-by-step about finding and eliminating all legacy code>

### Legacy Discovery Operations
```bash
# Find all legacy code to be removed
@Grep(pattern="$FEATURE_PATTERN|deprecated|legacy|old", output_mode="files_with_matches")
@Grep(pattern="TODO.*remove|FIXME.*legacy|HACK", output_mode="content")
@Glob(pattern="**/*$FEATURE*.*")
@Glob(pattern="**/*deprecated*.*")
@Glob(pattern="**/*legacy*.*")
```

### Aggressive Cleanup Task List
@TodoWrite(todos=[
  {id: "1", content: "Identify ALL legacy code for removal", status: "pending", priority: "high"},
  {id: "2", content: "Document breaking changes", status: "pending", priority: "high"},
  {id: "3", content: "Remove legacy backend code", status: "pending", priority: "high"},
  {id: "4", content: "Remove legacy frontend code", status: "pending", priority: "high"},
  {id: "5", content: "Remove legacy database schemas", status: "pending", priority: "high"},
  {id: "6", content: "Implement modern replacement", status: "pending", priority: "high"},
  {id: "7", content: "Remove all legacy tests", status: "pending", priority: "high"},
  {id: "8", content: "Create new comprehensive test suite", status: "pending", priority: "high"},
  {id: "9", content: "Validate 100% test success", status: "pending", priority: "high"},
  {id: "10", content: "Clean up all references", status: "pending", priority: "high"}
])

## Phase 1: Parallel Breaking Change Analysis

<think harder about the freedom to completely redesign without constraints>

### Unrestricted Modernization Analysis

@Task(description="Complete architecture redesign", prompt="Design a completely new architecture for $ARGUMENTS with NO backward compatibility constraints:
1. Propose modern microservices/serverless architecture
2. Design event-driven communication patterns
3. Implement CQRS where beneficial
4. Use latest framework versions only
5. Design for horizontal scaling
6. Implement modern caching strategies
7. Use NoSQL where appropriate
8. Design GraphQL/gRPC APIs (no REST if not optimal)
9. Implement modern authentication (OAuth2/OIDC only)
10. Design for cloud-native deployment only
Provide aggressive modernization blueprint with zero legacy constraints", subagent_type="general-purpose")

@Task(description="Modern frontend redesign", prompt="Completely redesign frontend for $ARGUMENTS using latest patterns:
1. Use latest Angular 19 features aggressively
2. Implement signals everywhere (no observables)
3. Use standalone components only
4. Implement micro-frontends if beneficial
5. Use CSS Grid/Flexbox only (no legacy layouts)
6. Implement PWA features by default
7. Use WebAssembly where beneficial
8. Implement modern state management (Signals/Stores)
9. Use latest TypeScript features
10. Implement edge rendering/SSR
Design with zero legacy browser support", subagent_type="Frontend Developer")

@Task(description="Zero-trust security design", prompt="Implement modern zero-trust security for $ARGUMENTS:
1. Remove all legacy authentication
2. Implement passwordless by default
3. Use hardware keys/biometrics
4. Implement zero-trust networking
5. Use modern encryption only (no legacy algorithms)
6. Implement complete audit logging
7. Use modern secrets management
8. Implement threat detection
9. Use security headers aggressively
10. Implement CSP strictly
Design assuming no legacy security constraints", subagent_type="general-purpose")

@Task(description="Technical debt elimination", prompt="Identify and eliminate ALL technical debt for $ARGUMENTS:
1. Find all workarounds to remove
2. Identify all deprecated dependencies
3. Find all commented-out code
4. Identify all TODO/FIXME items
5. Find all duplicated code
6. Identify all complex methods (>20 lines)
7. Find all deep nesting (>3 levels)
8. Identify all magic numbers/strings
9. Find all missing error handling
10. Identify all performance bottlenecks
Provide complete elimination plan", subagent_type="Technical Debt Analyst")

@Task(description="Modern testing strategy", prompt="Design modern test strategy for $ARGUMENTS with no legacy:
1. Use latest testing frameworks only
2. Implement property-based testing
3. Use contract testing
4. Implement mutation testing
5. Use visual regression testing
6. Implement performance testing
7. Use chaos engineering principles
8. Implement security testing
9. Use AI-powered test generation
10. Implement continuous testing
Design for 100% coverage with modern tools only", subagent_type="general-purpose")

## Phase 2: Aggressive Legacy Removal

<think step-by-step about safely removing all legacy code>

### Removal Strategy

#### Step 1: Create Feature Branch
```bash
@Bash(command="git checkout -b breaking-change-$ARGUMENTS")
```

#### Step 2: Remove Legacy Backend
```bash
# Delete entire legacy modules
@Bash(command="rm -rf src/legacy/")
@Bash(command="rm -rf src/deprecated/")

# Remove legacy API endpoints
@MultiEdit(file_path="src/controllers/", edits=[
    {old_string: "entire legacy controller", new_string: ""},
])

# Clean up legacy services
@MultiEdit(file_path="src/services/", edits=[
    {old_string: "legacy service code", new_string: ""},
])
```

#### Step 3: Remove Legacy Frontend
```bash
# Delete legacy components
@Bash(command="rm -rf src/app/legacy-components/")

# Remove legacy services
@Bash(command="rm -rf src/app/legacy-services/")

# Clean up legacy styles
@Bash(command="rm -rf src/styles/legacy/")
```

#### Step 4: Database Cleanup
```sql
-- Drop legacy tables
DROP TABLE IF EXISTS legacy_features;
DROP TABLE IF EXISTS deprecated_data;

-- Remove legacy columns
ALTER TABLE features 
DROP COLUMN legacy_field1,
DROP COLUMN legacy_field2,
DROP COLUMN deprecated_field;

-- Remove legacy indexes
DROP INDEX IF EXISTS idx_legacy;

-- Remove legacy stored procedures
DROP PROCEDURE IF EXISTS sp_legacy_process;
```

## Phase 3: Modern Implementation

<think harder about implementing with the latest patterns and zero legacy>

### Modern Architecture Implementation

#### Backend: Event-Driven Microservices
```typescript
// Modern domain model with event sourcing
@Injectable()
export class FeatureAggregate {
    constructor(
        private eventStore: EventStore,
        private projectionEngine: ProjectionEngine
    ) {}
    
    async execute(command: Command): Promise<void> {
        const events = this.handle(command);
        await this.eventStore.append(events);
        await this.projectionEngine.project(events);
    }
}

// CQRS command handler
@CommandHandler(CreateFeatureCommand)
export class CreateFeatureHandler {
    async execute(command: CreateFeatureCommand): Promise<void> {
        // Modern implementation only
    }
}

// GraphQL resolver (no REST)
@Resolver()
export class FeatureResolver {
    @Query(() => Feature)
    @UseGuards(ModernAuthGuard)
    async feature(@Args() args: FeatureArgs): Promise<Feature> {
        // Modern query implementation
    }
}
```

#### Frontend: Signals & Standalone Components
```typescript
// Modern Angular 19 with signals only
@Component({
    selector: 'app-feature',
    standalone: true,
    imports: [CommonModule, ReactiveFormsModule],
    template: `
        <!-- No *ngIf, using modern @if -->
        @if (feature()) {
            <div class="modern-feature">
                {{ feature().name }}
            </div>
        }
    `
})
export class FeatureComponent {
    // Signals only, no observables
    feature = signal<Feature | null>(null);
    loading = signal(false);
    error = signal<Error | null>(null);
    
    constructor() {
        // Modern injection with inject()
        const service = inject(FeatureService);
        
        // Effect for reactive updates
        effect(() => {
            if (this.loading()) {
                service.loadFeature().then(
                    data => this.feature.set(data)
                );
            }
        });
    }
}
```

## Phase 4: Modern Test Implementation

<think step-by-step about implementing comprehensive modern tests>

### Test Strategy: 100% Coverage, Zero Legacy

#### Modern Unit Tests
```typescript
describe('Modern Feature Tests', () => {
    // Property-based testing
    describe('Property Tests', () => {
        it('should maintain invariants', 
            fc.property(
                fc.record({
                    name: fc.string(),
                    value: fc.integer()
                }),
                (input) => {
                    // Test invariants hold
                }
            )
        );
    });
    
    // Mutation testing
    describe('Mutation Tests', () => {
        it('should detect all mutations', async () => {
            const result = await stryker.run();
            expect(result.mutationScore).toBeGreaterThan(90);
        });
    });
    
    // Contract testing
    describe('Contract Tests', () => {
        it('should honor API contracts', async () => {
            await pact.verify();
        });
    });
});
```

#### Modern Integration Tests
```typescript
describe('Modern Integration Tests', () => {
    // Use testcontainers for real dependencies
    let container: StartedTestContainer;
    
    beforeAll(async () => {
        container = await new GenericContainer("postgres:15")
            .withExposedPorts(5432)
            .start();
    });
    
    // Chaos testing
    describe('Chaos Tests', () => {
        it('should handle random failures', async () => {
            const chaos = new ChaosMonkey();
            await chaos.unleash();
            // System should self-heal
        });
    });
    
    // Performance testing
    describe('Performance Tests', () => {
        it('should meet SLA', async () => {
            const result = await k6.run({
                vus: 100,
                duration: '30s'
            });
            expect(result.p95).toBeLessThan(100);
        });
    });
});
```

## Phase 5: Cloud-Native Optimization

<think harder about cloud-native patterns without monitoring overhead>

### Cloud-Ready Implementation

#### Serverless Functions
```typescript
// AWS Lambda handler
export const handler = async (event: APIGatewayEvent) => {
    // Stateless processing
    const result = await processFeature(event);
    
    // No performance monitoring - cloud handles it
    return {
        statusCode: 200,
        body: JSON.stringify(result)
    };
};
```

#### Container Optimization
```dockerfile
# Multi-stage build for minimal size
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

FROM gcr.io/distroless/nodejs18-debian11
COPY --from=builder /app /app
WORKDIR /app
EXPOSE 3000
CMD ["index.js"]
```

## Phase 6: Validation Loop Until 100% Success

<think step-by-step about ensuring complete success>

### Continuous Validation
```typescript
async function validateUntilSuccess() {
    let confidence = 0;
    let testSuccess = 0;
    let iterations = 0;
    
    while (confidence < 99 || testSuccess < 100) {
        iterations++;
        
        // Run all tests
        const testResults = await runAllTests();
        testSuccess = testResults.successRate;
        
        // Fix any failures
        if (testSuccess < 100) {
            const failures = analyzeFailures(testResults);
            await fixIssues(failures);
            await regenerateTests();
        }
        
        // Validate implementation
        const validation = await validateImplementation();
        confidence = validation.confidence;
        
        // Prevent infinite loops
        if (iterations > 50) {
            throw new Error('Unable to achieve 100% success');
        }
    }
    
    return { confidence, testSuccess, iterations };
}
```

## Phase 7: Final Cleanup & Documentation

### Remove All Legacy References
```bash
# Find and remove all legacy imports
@Grep(pattern="import.*legacy|deprecated", output_mode="files_with_matches")
@MultiEdit(/* remove all legacy imports */)

# Update all documentation
@Grep(pattern="legacy|deprecated|backward.?compat", path="docs/", output_mode="files_with_matches")
@MultiEdit(/* update documentation */)

# Clean up configuration
@Edit(file_path="config/app.config.ts", /* remove legacy config */)
```

### Breaking Change Documentation
```markdown
# BREAKING CHANGES

## Removed Features
- Legacy authentication system completely removed
- Deprecated API endpoints removed
- Legacy database schema removed

## Migration Required
- All clients must update to new API
- Database migration required (no rollback)
- Frontend complete rebuild required

## New Requirements
- Node.js 18+ required
- PostgreSQL 15+ required
- Modern browser only (Chrome 100+, Firefox 100+, Safari 15+)
```

## Completion Criteria

### Success Validation
```yaml
Breaking Change Checklist:
  ✓ All legacy code removed (100%)
  ✓ Modern implementation complete
  ✓ Zero backward compatibility
  ✓ All tests passing (100%)
  ✓ No technical debt remaining
  ✓ Cloud-native ready
  ✓ No performance monitoring
  ✓ Documentation updated
```

### Final Confidence Score
```markdown
## Confidence Score: ≥99%

Validation:
- Legacy code removed: 100%
- Modern patterns used: 100%
- Test coverage: 100%
- Test success: 100%
- Technical debt: 0
- Cloud readiness: Verified

✅ Feature completely replaced with modern implementation
```

## Non-Negotiable Completion

This command will NOT terminate until:
1. ALL legacy code is removed
2. Modern implementation is 100% complete
3. ALL tests pass (100% success rate)
4. Zero technical debt remains
5. Confidence score ≥99%

The aggressive approach ensures complete modernization without compromise.