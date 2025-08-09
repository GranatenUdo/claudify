# Claude Code Commands

This directory contains project-specific slash commands for Claude Code. These commands enhance productivity by providing structured approaches to common development tasks.

## Command Categories

### Feature Development
- **Backend**: `/add-backend-feature`
- **Frontend**: `/add-frontend-feature`
- **Integration**: `/add-integration`

### Code Quality & Maintenance
- **Bug Fixes**: `/fix-backend-bug`, `/fix-frontend-bug`, `/fix-api-bug`
- **Build & Tests**: `/fix-backend-build-and-tests`, `/fix-frontend-build-and-tests`
- **Reviews**: `/review-backend-code`, `/review-frontend-code`
- **Refactoring**: `/refactor-code`
- **Performance**: `/optimize-performance`

### Analysis & Research
- **Technical Debt**: `/analyze-technical-debt`
- **Legacy Systems**: `/analyze-legacy-system`
- **Domain Analysis**: `/analyze-domain-use-cases`
- **Research**: `/do-extensive-research`, `/quick-research`

### Documentation & Marketing
- **Technical Docs**: `/generate-documentation`, `/generate-docs`
- **Marketing**: `/generate-marketing-material`

### Meta & Utilities
- **Command Creation**: `/create-command-and-or-agent`
- **Template Sync**: `/sync-to-templates`
- **Changelog**: `/update-changelog`

## Available Commands

### `/add-api-feature`

Implements a new backend API feature using domain-driven design and extended thinking.

**Usage:**
```
/add-api-feature harvest tracking with yield calculations
```

**What it does:**
- Uses extended thinking for deep domain analysis
- Enforces multi-tenant security (OrganizationId filtering)
- Follows Domain-Driven Design with factory methods
- Implements Result<T> pattern for all services
- Includes caching, real-time updates, and audit trails
- Creates proper RESTful API endpoints

**Example invocations:**
- `/add-api-feature weather data integration for frost alerts`
- `/add-api-feature equipment maintenance scheduling`
- `/add-api-feature harvest quality metrics and reporting`

The command guides Claude through:
1. Domain analysis with extended thinking
2. Entity modeling with business logic
3. Repository pattern implementation
4. Service layer with Result pattern
5. RESTful API design
6. Comprehensive testing
7. FEATURES.md documentation

### `/fix-ui-bug`

Debug and fix UI issues using extended thinking and systematic debugging approach.

**Usage:**
```
/fix-ui-bug field import wizard not showing file preview
```

**What it does:**
- Uses extended thinking for root cause analysis
- Systematic debugging process (reproduce → isolate → investigate → fix)
- Comprehensive testing across browsers and edge cases
- Implements prevention strategies to avoid similar bugs
- Follows Angular 18 and TypeScript best practices
- Documents fixes for future reference

**Example invocations:**
- `/fix-ui-bug login button not responding on mobile`
- `/fix-ui-bug data grid sorting breaks after filter applied`
- `/fix-ui-bug memory leak in harvest schedule component`

The command guides Claude through:
1. Bug reproduction and isolation
2. Root cause analysis with extended thinking
3. Investigation of frontend and backend
4. Implementation of proper fix
5. Comprehensive testing
6. Prevention strategies
7. Documentation updates

### `/fix-api-bug`

Debug and fix backend API issues using extended thinking and systematic root cause analysis.

**Usage:**
```
/fix-api-bug fields endpoint returns 500 when filtering by date range
```

**What it does:**
- Uses extended thinking for deep root cause analysis
- Multi-layer investigation (Controller → Service → Repository → Domain)
- Checks for common patterns: multi-tenant leaks, N+1 queries, concurrency
- Implements proper error handling with ProblemDetails
- Ensures transaction consistency and caching integrity
- Adds comprehensive logging and monitoring

**Example invocations:**
- `/fix-api-bug organization filter not applied in harvest endpoint`
- `/fix-api-bug deadlock when updating multiple fields concurrently`
- `/fix-api-bug memory leak in SignalR notifications`

The command guides Claude through:
1. Bug reproduction and data collection
2. Multi-layer systematic investigation
3. Root cause analysis with extended thinking
4. Implementation of robust fix
5. Security and performance verification
6. Load testing and monitoring setup
7. Documentation and prevention strategies

### `/review-api-code`

Perform comprehensive API code review using extended thinking for security, performance, and architectural analysis.

**Usage:**
```
/review-api-code src/PTA.VineyardManagement.Api/Services/FieldService.cs
```

**What it does:**
- Uses extended thinking for deep code analysis
- Performs OWASP API Security Top 10 review
- Analyzes performance (N+1 queries, async patterns, caching)
- Verifies architectural patterns (DDD, Result<T>, clean architecture)
- Checks multi-tenant isolation and authorization
- Reviews testing coverage and quality

**Example invocations:**
- `/review-api-code PR #42 field management feature`
- `/review-api-code HarvestController and related services`
- `/review-api-code recent changes to warehouse module`

The command provides:
1. Security vulnerability assessment
2. Performance bottleneck identification
3. Architecture compliance verification
4. Code quality analysis
5. Testing coverage review
6. Detailed findings with fixes
7. Production readiness assessment

Output includes a structured review with severity ratings, specific code examples, and improvement recommendations.

### `/review-ui-code`

Perform comprehensive UI code review using extended thinking for accessibility, performance, and user experience analysis.

**Usage:**
```
/review-ui-code src/app/features/fields/components/field-list/field-list.component.ts
```

**What it does:**
- Uses extended thinking for deep UI/UX analysis
- Performs WCAG 2.1 AA accessibility review
- Analyzes performance (signals, OnPush, bundle size)
- Verifies Angular 19 patterns (standalone, control flow)
- Checks Material Design 3 compliance
- Reviews responsive design and mobile experience

**Example invocations:**
- `/review-ui-code field import wizard component`
- `/review-ui-code PR #35 harvest schedule UI`
- `/review-ui-code dashboard performance optimizations`

The command provides:
1. Accessibility compliance assessment
2. Performance optimization opportunities
3. User experience improvements
4. Angular 18 best practices verification
5. Design system consistency check
6. Memory leak detection
7. Testing coverage analysis

Output includes structured findings with severity levels, code examples, and specific fixes for accessibility, performance, and UX issues.

### `/do-extensive-research`

Perform deep research with Opus 4 extended and interleaved thinking for comprehensive analysis and recommendations.

**Usage:**
```
/do-extensive-research optimal database architecture for multi-tenant spatial data
```

**What it does:**
- Leverages Opus 4's extended thinking capabilities for deep analysis
- Uses interleaved thinking to refine insights progressively
- Performs multi-dimensional analysis (technical, business, operational)
- Synthesizes findings from codebase analysis and external research
- Provides evidence-based recommendations with implementation roadmaps
- Includes risk analysis and mitigation strategies

**Example invocations:**
- `/do-extensive-research harvest season workflow automation strategies`
- `/do-extensive-research microservices migration path for vineyard management`
- `/do-extensive-research optimal caching strategies for geographic data`

The command guides Claude through:
1. Research scope definition with deep reasoning
2. Parallel information gathering from multiple sources
3. Multi-dimensional analysis framework
4. Synthesis and strategic recommendations
5. Risk analysis and mitigation planning
6. Detailed technical specifications
7. Monitoring and success metrics
8. Knowledge transfer documentation

Output includes:
- Executive summary with key findings
- Detailed analysis with supporting evidence
- Implementation roadmap with timelines
- Risk matrix with mitigation strategies
- Architecture Decision Records (ADRs)
- Success metrics and KPIs
- Next steps checklist

### `/fix-frontend-build-and-tests`

Fix frontend build and test failures using Opus 4 extended thinking with iterative reflection and parallel operations.

**Usage:**
```
/fix-frontend-build-and-tests TypeScript errors in field components
```

**What it does:**
- Uses iterative thinking to analyze build and test failures
- Runs operations in parallel for maximum efficiency
- Reflects on results before determining next steps
- Focuses on understanding problem requirements, not just passing tests
- Implements correct algorithms based on business logic
- Asks for user clarification when confidence < 99%

**Example invocations:**
- `/fix-frontend-build-and-tests` (full diagnosis)
- `/fix-frontend-build-and-tests module resolution errors`
- `/fix-frontend-build-and-tests failing component tests`

The command guides Claude through:
1. Parallel information gathering (build, tests, config, changes)
2. Iterative build fixing with reflection after each step
3. Deep understanding of test intent and requirements
4. Parallel implementation of independent fixes
5. Comprehensive verification
6. Documentation and prevention strategies

Key principles:
- Tests verify correctness, they don't define the solution
- Understand requirements before implementing
- When unsure (confidence < 99%), ask for clarification

### `/fix-backend-build-and-tests`

Fix backend build and test failures using Opus 4 extended thinking with iterative reflection and parallel operations.

**Usage:**
```
/fix-backend-build-and-tests dependency injection errors in services
```

**What it does:**
- Analyzes C# compilation errors and test failures iteratively
- Focuses on domain logic and architectural patterns
- Ensures multi-tenant security (OrganizationId scoping)
- Implements fixes based on agricultural domain knowledge
- Validates architectural decisions when confidence < 99%
- Runs parallel operations for faster resolution

**Example invocations:**
- `/fix-backend-build-and-tests` (full diagnosis)
- `/fix-backend-build-and-tests EF Core migration conflicts`
- `/fix-backend-build-and-tests failing integration tests`

The command guides Claude through:
1. Parallel .NET build and test analysis
2. Domain-driven fixes with business logic understanding
3. Multi-tenant security verification
4. Architecture compliance (DDD, Result<T>, clean architecture)
5. Integration test database issues
6. Performance and security validation

Key principles:
- Rich domain models with business logic in entities
- Every query must filter by OrganizationId
- Tests verify domain logic correctness
- When uncertain about architecture, seek validation

## Command Configuration

All commands use the official Claude Code YAML frontmatter format:
- `description`: Brief description of the command
- `allowed-tools`: List of tools the command can use
- `argument-hint`: Expected arguments for the command
- `model`: Optional model specification (opus/sonnet/haiku)

Commands leverage extended thinking via `MAX_THINKING_TOKENS` configured in `.claude/settings.json` at the project level.

## Creating New Commands

Use the command generator to create new commands:
```bash
/create-command-and-or-agent
```

Or use the generator scripts directly:
```powershell
.\.claude\generators\command-generator.ps1
```

## How Commands Work

Commands are markdown files with YAML frontmatter that guide Claude through structured workflows. They:
- **Provide systematic approaches** to common development tasks
- **Include prompts and instructions** that Claude follows
- **Suggest tool usage patterns** for efficient execution
- **Reference documentation** (CLAUDE.md and FEATURES.md) for context

Commands don't automatically enforce anything - they are templates that guide Claude's behavior. The actual enforcement of patterns depends on:
1. What you write in CLAUDE.md (your project-specific rules)
2. The prompts within each command file
3. Claude's interpretation and execution

## Configuration

Extended thinking is configured via `MAX_THINKING_TOKENS` in `.claude/settings.json` at the project level, not in individual commands.