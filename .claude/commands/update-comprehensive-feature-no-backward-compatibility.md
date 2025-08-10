---
name: update-comprehensive-feature-no-backward-compatibility
think-mode: think_harder
description: Replace existing feature entirely with no backward compatibility, removing legacy code and implementing modern patterns
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: feature replacement description (e.g., "replace legacy auth with modern OAuth 2.0")
---

# 🔥 Replace Feature (No Backward Compatibility): $ARGUMENTS

## Optimization Features
- **Breaking Change Analysis**: Deep reasoning about complete system transformation
- **Legacy Code Elimination**: Systematic removal of all deprecated patterns and code
- **Modern Architecture**: Full migration to microservices, event sourcing, and cloud-native patterns
- **Multi-Agent Collaboration**: Coordinated expertise from Frontend, Backend, Security, and Architecture agents
- **Comprehensive Modernization**: Zero compromise approach to technical debt elimination
- **Iterative Validation**: Continuous testing until 99% confidence and 100% success rate

## ⚠️ BREAKING CHANGE MODE ACTIVATED


### Aggressive Modernization Principles
- **Complete Replacement**: Remove ALL legacy code, no compatibility layer
- **Modern Patterns Only**: Latest frameworks, patterns, and best practices
- **Technical Debt Elimination**: Zero tolerance for legacy workarounds
- **Cloud-Native Design**: Built for scale, no performance monitoring overhead
- **100% Test Coverage**: New tests only, no legacy test maintenance

## Phase 0: Legacy Code Identification & Removal Planning



### Legacy Discovery Operations
```bash
# Find all legacy code to be removed
Searching for pattern: $FEATURE_PATTERN|deprecated|legacy|old
Searching for pattern: TODO.*remove|FIXME.*legacy|HACK
Finding files matching: **/*$FEATURE*.*
Finding files matching: **/*deprecated*.*
Finding files matching: **/*legacy*.*
```

### Aggressive Cleanup Task List
I'll update the task list to track our progress.

## Phase 1: Parallel Breaking Change Analysis



### Unrestricted Modernization Analysis

Using the general-purpose agent to: Design a completely new architecture for $ARGUMENTS with NO backward compatibility constraints:
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
Provide aggressive modernization blueprint with zero legacy constraints

Using the Frontend Developer agent to: Completely redesign frontend for $ARGUMENTS using latest patterns:
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
Design with zero legacy browser support

Using the general-purpose agent to: Implement modern zero-trust security for $ARGUMENTS:
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
Design assuming no legacy security constraints

Using the Technical Debt Analyst agent to: Identify and eliminate ALL technical debt for $ARGUMENTS:
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
Provide complete elimination plan

I'll have the general-purpose agent Modern testing strategy.

## Phase 2: Aggressive Legacy Removal



### Removal Strategy

#### Step 1: Create Feature Branch
```bash
Running command: `git checkout -b breaking-change-$ARGUMENTS`
```

#### Step 2: Remove Legacy Backend
```bash
# Delete entire legacy modules
Running command: `rm -rf src/legacy/`
Running command: `rm -rf src/deprecated/`

# Remove legacy API endpoints
Making multiple edits to the file.

# Clean up legacy services
Making multiple edits to the file.
```

#### Step 3: Remove Legacy Frontend
```bash
# Delete legacy components
Running command: `rm -rf src/app/legacy-components/`

# Remove legacy services
Running command: `rm -rf src/app/legacy-services/`

# Clean up legacy styles
Running command: `rm -rf src/styles/legacy/`
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



### Modern Architecture Implementation

#### Backend: Event-Driven Microservices
```typescript
// Modern domain model with event sourcing
Using Injectable tool for this operation.
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
Using CommandHandler tool for this operation.
export class CreateFeatureHandler {
    async execute(command: CreateFeatureCommand): Promise<void> {
        // Modern implementation only
    }
}

// GraphQL resolver (no REST)
Using Resolver tool for this operation.
export class FeatureResolver {
    Using Query tool for this operation. => Feature)
    Using UseGuards tool for this operation.
    async feature(Using Args tool for this operation. args: FeatureArgs): Promise<Feature> {
        // Modern query implementation
    }
}
```

#### Frontend: Signals & Standalone Components
```typescript
// Modern Angular 19 with signals only
Using Component tool for this operation.) {
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
Searching for pattern: import.*legacy|deprecated
Making multiple edits to the file.

# Update all documentation
Searching for pattern: legacy|deprecated|backward.?compat
Making multiple edits to the file.

# Clean up configuration
Editing the file with the necessary changes.
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

#
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
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
Searching for pattern: $ARGUMENTS
```

## Final Confidence Score
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