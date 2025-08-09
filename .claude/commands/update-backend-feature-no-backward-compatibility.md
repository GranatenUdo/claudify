---
name: update-backend-feature-no-backward-compatibility
model: opus
think-mode: think_harder
description: Replace backend feature entirely with modern patterns, removing all legacy code
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: backend feature replacement description (e.g., "replace monolithic service with microservices")
---

# 🔥 Replace Backend Feature (No Compatibility): $ARGUMENTS

## Optimization Features
- **Advanced Reasoning**: Extended thinking mode for complex architectural decisions
- **Parallel Processing**: Simultaneous analysis of legacy code removal and modern implementation
- **Event-Driven Architecture**: Complete migration to microservices and serverless patterns
- **Zero-Trust Security**: Modern authentication and authorization patterns
- **Cloud-Native Design**: Kubernetes-ready with automatic scaling capabilities
- **Continuous Validation**: Iterative testing until 99% confidence achieved

## ⚠️ AGGRESSIVE BACKEND MODERNIZATION


### Radical Backend Transformation
- **Microservices/Serverless Only**: No monoliths
- **Event-Driven Architecture**: No synchronous coupling
- **CQRS + Event Sourcing**: Where beneficial
- **Cloud-Native Only**: Kubernetes/Serverless ready
- **Zero Legacy Patterns**: No stored procedures, no ORM bloat

## Phase 0: Legacy Backend Elimination Planning



### Legacy Backend Discovery
```bash
# Find all legacy backend code
Searching for pattern: Repository|Service|Controller.*$FEATURE
Searching for pattern: stored.?procedure|trigger|view
Finding files matching: **/*Legacy*.*
Finding files matching: **/*Deprecated*.*
```

### Aggressive Backend Cleanup Tasks
I'll update the task list to track our progress.

## Phase 1: Parallel Modern Architecture Design



### Unrestricted Backend Redesign

I'll have the general-purpose agent Microservices architecture design.

Using the general-purpose agent to: Design zero-trust security for $ARGUMENTS:
1. Service-to-service authentication (mTLS)
2. API gateway with rate limiting
3. Secrets management (Vault/KMS)
4. Policy-as-code (OPA)
5. Runtime security (Falco)
6. Network policies (Calico)
7. Admission controllers
8. Pod security policies
9. Image scanning in CI/CD
10. Compliance automation
Provide complete security implementation

I'll have the Technical Debt Analyst agent Legacy elimination plan.

## Phase 2: Aggressive Legacy Removal

### Complete Backend Demolition

```bash
# Remove entire legacy structure
Running command: `rm -rf src/Controllers/Legacy*`
Running command: `rm -rf src/Services/Legacy*`
Running command: `rm -rf src/Repositories/*`  # Remove all repositories

# Drop legacy database objects
Running command: `psql -c 'DROP SCHEMA legacy CASCADE'`
Running command: `psql -c 'DROP ALL PROCEDURES'`
Running command: `psql -c 'DROP ALL TRIGGERS'`
```

## Phase 3: Modern Microservices Implementation



### Event-Driven Microservice

```typescript
// Command Service (Write Side)
Using Injectable tool for this operation.
export class FeatureCommandService {
    constructor(
        private eventStore: EventStore,
        private eventBus: EventBus
    ) {}
    
    async handle(command: Command): Promise<void> {
        // Pure domain logic
        const aggregate = await this.eventStore.load(command.aggregateId);
        const events = aggregate.handle(command);
        
        // Persist events
        await this.eventStore.save(events);
        
        // Publish for other services
        await this.eventBus.publish(events);
    }
}

// Query Service (Read Side)
Using Injectable tool for this operation.
export class FeatureQueryService {
    constructor(
        private projection: Projection,
        private cache: RedisCache
    ) {}
    
    async query(query: Query): Promise<Result> {
        // Check cache first
        const cached = await this.cache.get(query.key);
        if (cached) return cached;
        
        // Query optimized read model
        const result = await this.projection.query(query);
        
        // Cache for performance
        await this.cache.set(query.key, result, TTL);
        
        return result;
    }
}

// Event Sourcing Aggregate
export class FeatureAggregate extends AggregateRoot {
    private state: FeatureState;
    
    handle(command: Command): DomainEvent[] {
        switch (command.type) {
            case 'CREATE':
                return [new FeatureCreated(command.data)];
            case 'UPDATE':
                return [new FeatureUpdated(command.data)];
            default:
                throw new UnknownCommand(command);
        }
    }
    
    apply(event: DomainEvent): void {
        switch (event.type) {
            case 'FeatureCreated':
                this.state = event.data;
                break;
            case 'FeatureUpdated':
                this.state = { ...this.state, ...event.data };
                break;
        }
    }
}
```

### Serverless Implementation

```typescript
// AWS Lambda Handler
export const commandHandler = async (event: APIGatewayProxyEvent) => {
    const command = JSON.parse(event.body);
    
    // Validate command
    const validation = await validateCommand(command);
    if (!validation.isValid) {
        return {
            statusCode: 400,
            body: JSON.stringify(validation.errors)
        };
    }
    
    // Process command
    const service = new FeatureCommandService();
    await service.handle(command);
    
    return {
        statusCode: 202,
        body: JSON.stringify({ status: 'accepted' })
    };
};

// Event Stream Processor
export const eventProcessor = async (event: KinesisEvent) => {
    const promises = event.Records.map(async (record) => {
        const domainEvent = JSON.parse(
            Buffer.from(record.kinesis.data, 'base64').toString()
        );
        
        // Update read models
        await updateProjection(domainEvent);
        
        // Trigger side effects
        await triggerSideEffects(domainEvent);
    });
    
    await Promise.all(promises);
};
```

### GraphQL API (No REST)

```typescript
// Modern GraphQL Schema
const typeDefs = gql`
    type Feature {
        id: ID!
        name: String!
        metadata: JSON!
        events: [Event!]!
    }
    
    type Query {
        feature(id: ID!): Feature
        features(filter: FeatureFilter): [Feature!]!
    }
    
    type Mutation {
        createFeature(input: CreateFeatureInput!): Feature!
        updateFeature(id: ID!, input: UpdateFeatureInput!): Feature!
    }
    
    type Subscription {
        featureUpdated(id: ID!): Feature!
    }
`;

// Resolvers with DataLoader
const resolvers = {
    Query: {
        feature: async (_, { id }, { dataSources }) => {
            return dataSources.featureAPI.getFeature(id);
        },
        features: async (_, { filter }, { dataSources }) => {
            return dataSources.featureAPI.getFeatures(filter);
        }
    },
    Mutation: {
        createFeature: async (_, { input }, { dataSources }) => {
            const command = new CreateFeatureCommand(input);
            return dataSources.commandBus.send(command);
        }
    },
    Subscription: {
        featureUpdated: {
            subscribe: (_, { id }) => pubsub.asyncIterator([`FEATURE_${id}`])
        }
    }
};
```

## Phase 4: Modern Database Design

### Event Store Implementation

```sql
-- Event store table (append-only)
CREATE TABLE event_store (
    aggregate_id UUID NOT NULL,
    aggregate_type VARCHAR(255) NOT NULL,
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_type VARCHAR(255) NOT NULL,
    event_version INT NOT NULL,
    event_data JSONB NOT NULL,
    event_metadata JSONB NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(aggregate_id, event_version)
);

-- Optimized for event streaming
CREATE INDEX idx_event_store_aggregate ON event_store(aggregate_id, event_version);
CREATE INDEX idx_event_store_created ON event_store(created_at);

-- Snapshots for performance
CREATE TABLE snapshots (
    aggregate_id UUID PRIMARY KEY,
    aggregate_type VARCHAR(255) NOT NULL,
    snapshot_data JSONB NOT NULL,
    snapshot_version INT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Read model (denormalized)
CREATE TABLE feature_projections (
    id UUID PRIMARY KEY,
    data JSONB NOT NULL,
    version INT NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

## Phase 5: Modern Test Implementation

### Cloud-Native Testing

```typescript
describe('Modern Backend Tests', () => {
    // Container-based integration tests
    describe('Container Tests', () => {
        let container: StartedTestContainer;
        
        beforeAll(async () => {
            container = await new GenericContainer('feature-service:latest')
                .withExposedPorts(8080)
                .withEnvironment({
                    'EVENT_STORE_URL': 'postgresql://test',
                    'REDIS_URL': 'redis://test'
                })
                .start();
        });
        
        it('should handle commands', async () => {
            const response = await fetch(
                `http://localhost:${container.getMappedPort(8080)}/command`,
                {
                    method: 'POST',
                    body: JSON.stringify(testCommand)
                }
            );
            expect(response.status).toBe(202);
        });
    });
    
    // Contract testing with Pact
    describe('Contract Tests', () => {
        it('should honor consumer contracts', async () => {
            await new Verifier({
                providerBaseUrl: 'http://localhost:8080',
                pactUrls: ['./pacts/consumer-provider.json']
            }).verifyProvider();
        });
    });
    
    // Chaos engineering tests
    describe('Resilience Tests', () => {
        it('should handle service failures', async () => {
            const chaosMonkey = new ChaosMonkey({
                services: ['database', 'cache', 'message-bus']
            });
            
            await chaosMonkey.killRandomService();
            
            // System should still respond
            const response = await healthCheck();
            expect(response.status).toBe('degraded');
        });
    });
});
```

## Phase 6: Validation Until 100% Success

### Continuous Modern Validation

```typescript
async function validateModernBackend(): Promise<ValidationResult> {
    let confidence = 0;
    let iterations = 0;
    
    while (confidence < 99) {
        iterations++;
        
        // Test all microservices
        const serviceTests = await Promise.all([
            testCommandService(),
            testQueryService(),
            testEventProcessor(),
            testProjections()
        ]);
        
        const failedTests = serviceTests.filter(t => !t.success);
        if (failedTests.length > 0) {
            await fixServiceIssues(failedTests);
            continue;
        }
        
        // Test event sourcing
        const eventTests = await testEventSourcing();
        if (!eventTests.success) {
            await fixEventSourcingIssues(eventTests);
            continue;
        }
        
        // Test resilience
        const chaosTests = await runChaosTests();
        if (!chaosTests.success) {
            await improveResilience(chaosTests);
            continue;
        }
        
        // Performance validation
        const perfTests = await runPerformanceTests();
        if (!perfTests.meetsSLA) {
            await optimizePerformance(perfTests);
            continue;
        }
        
        confidence = calculateConfidence({
            serviceTests,
            eventTests,
            chaosTests,
            perfTests
        });
    }
    
    return {
        success: true,
        confidence,
        iterations,
        testCoverage: 100
    };
}
```

## Phase 7: Cloud Deployment Validation

### Kubernetes Manifest

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: feature-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: feature-service
  template:
    metadata:
      labels:
        app: feature-service
    spec:
      containers:
      - name: feature-service
        image: feature-service:latest
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        env:
        - name: EVENT_STORE_URL
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: url
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: feature-service
spec:
  selector:
    app: feature-service
  ports:
  - port: 80
    targetPort: 8080
  type: ClusterIP
```

## Completion Criteria

```yaml
Modern Backend Checklist:
  ✓ All legacy code removed
  ✓ Microservices implemented
  ✓ Event sourcing active
  ✓ CQRS implemented
  ✓ GraphQL API ready
  ✓ Tests: 100% passing
  ✓ Chaos tests passing
  ✓ Performance validated
  ✓ Cloud deployment ready
  ✓ No monitoring overhead
```


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

## Final Validation

```markdown
## Confidence Score: ≥99%

Modern Backend Status:
- Legacy removed: 100%
- Modern patterns: 100%
- Test success: 100%
- Cloud readiness: Verified
- Performance: Optimized

✅ Backend completely modernized
```

This command will NOT terminate until:
1. ALL legacy backend code removed
2. Modern architecture fully implemented
3. 100% test success achieved
4. Cloud deployment validated
5. Confidence ≥99%