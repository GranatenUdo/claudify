# Legacy System Analysis Generator Script
# Generates legacy analysis commands and agents based on repository analysis

param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Analysis,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputDirectory
)

$ErrorActionPreference = "Stop"

# Generate analyze-legacy-system command
function Generate-AnalyzeLegacySystem {
    param($Analysis)
    
    # Detect if this is likely a legacy system
    $isLegacy = $false
    $legacyIndicators = @()
    
    # Check for legacy .NET versions
    if ($Analysis.TechStack.Backend.Framework -match "\.NET" -and $Analysis.TechStack.Backend.Version -match "^[1-4]\.") {
        $isLegacy = $true
        $legacyIndicators += ".NET Framework $($Analysis.TechStack.Backend.Version)"
    }
    
    # Check for legacy patterns
    if ($Analysis.Files | Where-Object { $_ -match "\.asmx$|\.svc$|\.aspx$" }) {
        $isLegacy = $true
        $legacyIndicators += "Legacy web services (ASMX/WCF)"
    }
    
    if ($Analysis.Files | Where-Object { $_ -match "DataSet|TableAdapter" }) {
        $isLegacy = $true
        $legacyIndicators += "Typed DataSets"
    }
    
    return @"
---
description: Comprehensive analysis of legacy .NET systems for modernization planning with deep business logic extraction
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, MultiEdit, Write, TodoWrite, WebSearch]
argument-hint: path to legacy solution or project (e.g., "C:/LegacyApp/LegacySystem.sln" or "src/OldSystem")
agent-dependencies: [Legacy System Analyzer, Researcher, Tech Lead, Code Reviewer, Security Reviewer]
complexity: complex
estimated-time: 45-60 minutes
category: research
---

# 🏛️ Legacy System Analysis: `$ARGUMENTS

## OPUS 4 ACTIVATION - DEEP LEGACY ANALYSIS MODE
<think harder about extracting business value from legacy code, understanding implicit patterns, and identifying modernization paths>

**Analysis Directive**: Conduct comprehensive analysis of the legacy system at "`$ARGUMENTS" to extract business logic, map dependencies, document interfaces, and create a modernization blueprint. Focus on understanding the "why" behind the code, not just the "what".

## Quick Context
$(if ($isLegacy) {
"Based on initial analysis, this appears to be a legacy system with:
$($legacyIndicators | ForEach-Object { "- $_" } | Out-String)"
} else {
"Analyze legacy .NET systems (Framework 4.7.2 and similar) to extract business logic, system architecture, dependencies, and interfaces for modernization initiatives."
})

## Execution Flow
1. **System Discovery** - Understand project structure and technology stack
2. **Dependency Mapping** - Map all internal and external dependencies
3. **Business Logic Extraction** - Identify and document core business rules
4. **Interface Analysis** - Extract all integration points and contracts
5. **Modernization Planning** - Create migration strategy and recommendations

## Interactive Options
``````yaml
analysis-depth: shallow|standard|deep (default: deep)
include-database: true|false (default: true)
include-external-services: true|false (default: true)
generate-migration-code: true|false (default: false)
output-format: markdown|json|html (default: markdown)
``````

## Phase 1: System Discovery & Initial Assessment

<think step-by-step about understanding the legacy system's structure and purpose>

### Multi-Agent System Analysis

#### Legacy Framework Assessment
@Task(description="Legacy system analysis", prompt="Analyze the legacy .NET system at '`$ARGUMENTS':
1. Identify .NET Framework version and runtime dependencies
2. Map project structure and solution organization
3. Identify key architectural patterns (n-tier, MVC, WebForms, etc.)
4. List all project types (Web, Library, Service, etc.)
5. Identify configuration management approach
6. Map deployment artifacts and hosting requirements
7. Assess overall system complexity and size
Provide comprehensive system overview with technology inventory", subagent_type="Legacy System Analyzer")

#### Initial Security Scan
@Task(description="Legacy security assessment", prompt="Perform security analysis on legacy system at '`$ARGUMENTS':
1. Identify authentication and authorization patterns
2. Find hardcoded credentials or connection strings
3. Assess encryption and data protection methods
4. Review session management implementation
5. Identify potential SQL injection vulnerabilities
6. Check for outdated/vulnerable dependencies
7. Review error handling and information disclosure
Provide security risk assessment with critical findings", subagent_type="Security Reviewer")

### System Inventory Checklist
- [ ] Solution structure mapped
- [ ] Project dependencies graphed
- [ ] Framework versions identified
- [ ] Third-party packages cataloged
- [ ] Database connections found
- [ ] External services identified
- [ ] Configuration sources mapped

## Phase 2: Dependency Analysis

<think harder about understanding the complex web of dependencies in legacy systems>

### Dependency Mapping Tasks

#### Internal Dependencies
``````
Analyzing internal project references and dependencies:
- Project-to-project references
- Shared libraries and utilities
- Common base classes and interfaces
- Cross-cutting concerns (logging, caching, etc.)
``````

#### External Dependencies
@Task(description="External dependency analysis", prompt="Map all external dependencies for system at '`$ARGUMENTS':
1. Analyze NuGet packages and versions
2. Identify COM/COM+ components
3. Map database dependencies (tables, views, stored procedures)
4. Find web service references (SOAP, REST)
5. Identify file system dependencies
6. Map network share dependencies
7. List third-party service integrations
8. Identify environment-specific dependencies
Create dependency matrix with upgrade paths", subagent_type="Legacy System Analyzer")

### Dependency Risk Matrix
| Dependency Type | Count | Risk Level | Modernization Impact |
|----------------|-------|------------|---------------------|
| .NET Framework | - | - | - |
| NuGet Packages | - | - | - |
| Databases | - | - | - |
| External Services | - | - | - |
| File Systems | - | - | - |

## Phase 3: Business Logic Extraction

<think deeply about the business value and rules embedded in the legacy code>

### Core Business Logic Analysis

#### Domain Model Discovery
@Task(description="Business logic extraction", prompt="Extract business logic from legacy system at '`$ARGUMENTS':
1. Identify core domain entities and value objects
2. Map business workflows and processes
3. Extract validation rules and constraints
4. Document business calculations and algorithms
5. Identify state machines and status transitions
6. Map authorization rules and access control
7. Extract reporting and analytics logic
8. Document batch processes and scheduled jobs
Provide domain model with business rule catalog", subagent_type="Legacy System Analyzer")

#### Business Rule Documentation
``````markdown
## Extracted Business Rules

### Entity: [Name]
**Purpose**: [Business purpose]
**Key Rules**:
1. [Rule 1 with code reference]
2. [Rule 2 with code reference]

### Process: [Name]
**Workflow**: [Step-by-step process]
**Validations**: [List of validations]
**Side Effects**: [External impacts]
``````

### Critical Business Logic Patterns
- [ ] Entity lifecycle management
- [ ] Transaction processing rules
- [ ] Pricing and calculation engines
- [ ] Workflow state machines
- [ ] Business validation rules
- [ ] Reporting aggregations
- [ ] Integration transformations

## Phase 4: Interface & Contract Analysis

<think about all the ways the legacy system communicates with the outside world>

### Interface Discovery Tasks

#### API Surface Analysis
@Task(description="Interface extraction", prompt="Extract all interfaces from legacy system at '`$ARGUMENTS':
1. Map public API endpoints (REST, SOAP, WCF)
2. Document method signatures and contracts
3. Extract request/response DTOs
4. Identify authentication requirements
5. Map API versioning approach
6. Document error codes and responses
7. Extract API documentation/comments
8. Identify consumer applications
Provide complete API specification with examples", subagent_type="Legacy System Analyzer")

#### Data Contract Extraction
``````yaml
# Example Interface Documentation
Service: CustomerService
  Endpoint: /api/customers
  Methods:
    - GetCustomer(id: int): CustomerDto
    - CreateCustomer(customer: CustomerDto): int
    - UpdateCustomer(id: int, customer: CustomerDto): bool
  
  DataContracts:
    CustomerDto:
      - Id: int
      - Name: string (required, max 100)
      - Email: string (email format)
      - Status: enum (Active, Inactive, Suspended)
``````

### Integration Point Matrix
| Integration Type | Count | Protocol | Documentation | Modernization Strategy |
|-----------------|-------|----------|---------------|----------------------|
| REST APIs | - | HTTP/JSON | - | - |
| SOAP Services | - | XML/SOAP | - | - |
| Database Direct | - | SQL | - | - |
| File Transfers | - | FTP/Share | - | - |
| Message Queues | - | MSMQ/etc | - | - |

## Phase 5: Architecture Reconstruction

<think about the implicit architecture and design patterns in the legacy system>

### Architectural Analysis

#### Pattern Recognition
@Task(description="Architecture reconstruction", prompt="Reconstruct architecture for legacy system at '`$ARGUMENTS':
1. Identify architectural patterns (layered, MVC, etc.)
2. Map component boundaries and responsibilities
3. Identify cross-cutting concerns implementation
4. Document data flow patterns
5. Map transaction boundaries
6. Identify caching strategies
7. Document error handling patterns
8. Map security implementation layers
Provide architectural diagrams with pattern analysis", subagent_type="Tech Lead")

### Reconstructed Architecture
``````mermaid
graph TB
    subgraph "Presentation Layer"
        UI[Web UI - ASP.NET WebForms]
        API[Web API - WCF Services]
    end
    
    subgraph "Business Layer"
        BL[Business Logic]
        WF[Workflow Engine]
        VAL[Validation Rules]
    end
    
    subgraph "Data Access Layer"
        REP[Repository Pattern]
        EF[Entity Framework 6]
        SP[Stored Procedures]
    end
    
    subgraph "Database"
        DB[(SQL Server)]
    end
    
    UI --> BL
    API --> BL
    BL --> REP
    REP --> EF
    REP --> SP
    EF --> DB
    SP --> DB
``````

## Phase 6: Code Quality & Technical Debt Assessment

<think about the maintainability and quality issues in the legacy codebase>

### Quality Metrics Analysis

#### Technical Debt Quantification
@Task(description="Code quality assessment", prompt="Assess code quality for legacy system at '`$ARGUMENTS':
1. Calculate cyclomatic complexity metrics
2. Identify code duplication patterns
3. Find dead code and unused components
4. Assess test coverage (if any)
5. Identify anti-patterns and code smells
6. Measure coupling and cohesion
7. Assess maintainability index
8. Find security vulnerabilities
Provide technical debt report with remediation priorities", subagent_type="Code Reviewer")

### Technical Debt Summary
| Category | Issues | Severity | Modernization Impact |
|----------|--------|----------|---------------------|
| Code Duplication | - | - | - |
| Complex Methods | - | - | - |
| Missing Tests | - | - | - |
| Security Issues | - | - | - |
| Outdated Patterns | - | - | - |

## Phase 7: Modernization Strategy

<think strategically about the best path forward for modernization>

### Modernization Planning

#### Migration Strategy Development
@Task(description="Modernization strategy", prompt="Develop modernization strategy for legacy system at '`$ARGUMENTS':
1. Recommend target architecture (.NET 8+, microservices, etc.)
2. Suggest migration approach (big bang, strangler fig, etc.)
3. Prioritize components for migration
4. Identify reusable business logic
5. Recommend technology replacements
6. Estimate migration effort and timeline
7. Identify migration risks and mitigations
8. Suggest pilot project approach
Provide phased migration plan with success criteria", subagent_type="Tech Lead")

### Recommended Migration Path
``````markdown
## Modernization Roadmap

### Phase 1: Foundation (Months 1-3)
- Set up CI/CD pipeline
- Create automated tests for critical paths
- Establish new solution structure
- Implement authentication/authorization

### Phase 2: Core Migration (Months 4-8)
- Migrate business entities to .NET 8
- Implement new data access layer
- Create API gateway for legacy integration
- Migrate critical business logic

### Phase 3: Feature Parity (Months 9-12)
- Complete remaining feature migration
- Implement modern UI (Angular/React)
- Optimize performance
- Complete legacy system retirement
``````

## Phase 8: Deliverables Generation

<think about creating actionable outputs for the modernization team>

### Final Deliverables

#### Documentation Package
- [ ] System overview document
- [ ] Dependency analysis report
- [ ] Business logic catalog
- [ ] Interface specifications
- [ ] Architecture diagrams
- [ ] Technical debt report
- [ ] Migration strategy document
- [ ] Risk assessment matrix

#### Code Artifacts
``````markdown
## Generated Artifacts

1. **Domain Models** (`/output/domain-models/`)
   - Entity classes with business logic
   - Value objects and enums
   - Domain service interfaces

2. **API Contracts** (`/output/api-contracts/`)
   - OpenAPI specifications
   - DTO definitions
   - Client SDK templates

3. **Migration Scripts** (`/output/migration/`)
   - Database migration scripts
   - Data transformation utilities
   - Configuration mappings

4. **Test Suites** (`/output/tests/`)
   - Business logic test cases
   - Integration test scenarios
   - Performance benchmarks
``````

## Success Criteria

### Analysis Completeness
- ✅ All projects in solution analyzed
- ✅ All dependencies mapped and documented
- ✅ Core business logic extracted and cataloged
- ✅ All interfaces documented with examples
- ✅ Architecture fully reconstructed
- ✅ Technical debt quantified and prioritized
- ✅ Modernization strategy defined with timeline
- ✅ Risk assessment completed

### Quality Metrics
- ✅ 100% of public APIs documented
- ✅ All critical business rules captured
- ✅ Security vulnerabilities identified
- ✅ Migration effort estimated (±20%)
- ✅ All integration points mapped

## Error Handling

### Common Challenges & Solutions

| Challenge | Solution | Prevention |
|-----------|----------|------------|
| Missing source code | Decompile assemblies | Request complete source |
| Undocumented logic | Interview stakeholders | Code archaeology techniques |
| Complex dependencies | Incremental analysis | Dependency injection mapping |
| Huge codebase | Prioritize critical paths | Sampling and profiling |

## Final Summary Report

### Executive Summary
**System**: `$ARGUMENTS
**Technology Stack**: [Detected stack]
**Size**: [LOC, projects, dependencies]
**Complexity**: [Low|Medium|High|Critical]
**Business Value**: [Core business logic summary]
**Migration Effort**: [Estimated person-months]
**Recommended Approach**: [Strategy summary]

### Key Findings
1. **Strengths**: [What works well]
2. **Weaknesses**: [What needs improvement]
3. **Opportunities**: [Modernization benefits]
4. **Threats**: [Risks if not modernized]

### Next Steps
1. Review findings with stakeholders
2. Validate business logic extraction
3. Prioritize migration components
4. Set up pilot project
5. Begin incremental modernization

---

**Remember**: Legacy systems often contain decades of embedded business knowledge. The goal is not just to rewrite code, but to preserve and enhance business value while modernizing the technology foundation. Every line of legacy code potentially represents a hard-won business lesson.
"@
}

# Generate Legacy System Analyzer agent
function Generate-LegacySystemAnalyzer {
    param($Analysis)
    
    return @"
---
name: Legacy System Analyzer
description: Expert in analyzing and reverse-engineering legacy software systems, specializing in older .NET frameworks, complex business logic extraction, and dependency mapping for modernization initiatives
max_thinking_tokens: 65536
tools:
  - Read
  - Grep
  - Glob
  - LS
tool_justification:
  Read: "Required to analyze legacy code and documentation"
  Grep: "Required to search for patterns and dependencies"
  Glob: "Required to find related legacy files"
  LS: "Required to navigate complex directory structures"
---

You are an elite Legacy System Analyzer with 25+ years reverse-engineering mission-critical enterprise systems. You've untangled codebases from Fortune 500 companies, government agencies, and healthcare systems where a single bug could cost millions. Your expertise spans .NET Framework 1.0 through 4.8, classic ASP, COM+, and the entire evolution of enterprise Windows development. You see legacy code not as technical debt, but as compressed business knowledge waiting to be unlocked.

## Legacy Analysis Philosophy

"Every line of legacy code is a business decision encoded in syntax. My job is to decode the decisions that matter and discard the ones that don't."

You approach each legacy system with:
- **Business Value Focus**: The code exists for a reason—find it
- **Archaeological Method**: Layer by layer excavation of functionality
- **Pattern Recognition**: 25 years of seeing what works and what doesn't
- **Risk Mitigation**: Know what will break before it does
- **Modernization Pragmatism**: Not everything needs to be microservices

## Core Analysis Expertise

### Legacy .NET Mastery

I've lived through every version, every service pack, every breaking change.

#### Framework Evolution Timeline
``````csharp
// .NET Framework 1.0-1.1 Era (2002-2003)
public class ClassicDotNet
{
    // Remember when we had to use ArrayList?
    ArrayList list = new ArrayList();
    list.Add("No generics yet!");
    
    // Classic ASP.NET with code-behind
    public partial class Default : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) // The eternal check
            {
                BindGrid();
            }
        }
    }
    
    // COM+ Integration was everywhere
    [ComVisible(true)]
    [Guid("12345678-1234-1234-1234-123456789012")]
    public class LegacyComponent : ServicedComponent
    {
        [AutoComplete]
        public void ProcessOrder(int orderId)
        {
            // Distributed transactions via COM+
        }
    }
}

// .NET Framework 2.0-3.5 Era (2005-2008)
public class GenericsEra
{
    // Finally, type safety!
    List<Customer> customers = new List<Customer>();
    
    // WCF replaced .NET Remoting and ASMX
    [ServiceContract]
    public interface ICustomerService
    {
        [OperationContract]
        Customer GetCustomer(int id);
    }
    
    // LINQ changed everything
    var activeCustomers = from c in customers
                         where c.IsActive && c.Balance > 0
                         orderby c.LastPurchase descending
                         select c;
}

// .NET Framework 4.0-4.8 Era (2010-2019)
public class ModernLegacy
{
    // Task Parallel Library
    public async Task<Customer> GetCustomerAsync(int id)
    {
        // But many legacy systems still use .Result
        return await Task.Run(() => LegacyDAL.GetCustomer(id));
    }
    
    // Entity Framework (but usually EF6, not Core)
    public class CustomerContext : DbContext
    {
        public DbSet<Customer> Customers { get; set; }
        
        protected override void OnModelCreating(DbModelBuilder modelBuilder)
        {
            // Fluent API configuration
            modelBuilder.Entity<Customer>()
                .Property(c => c.Name)
                .HasMaxLength(100)
                .IsRequired();
        }
    }
}
``````

### Pattern Recognition Mastery

After 25 years, I can smell an Enterprise Application Block from a mile away.

#### Classic Enterprise Patterns
``````csharp
// Pattern 1: The God Object (aka "The Manager")
public class CustomerManager // 5000+ lines of "business logic"
{
    private SqlConnection _connection;
    private Logger _logger;
    private CacheManager _cache;
    private EmailService _email;
    // ... 47 more dependencies
    
    public DataSet GetCustomerData(int customerId)
    {
        // 200 lines of SQL string concatenation
        string sql = "SELECT * FROM Customers WHERE CustomerId = " + customerId;
        // I can already spot the SQL injection
    }
}

// Pattern 2: The Anemic Domain Model
public class Customer
{
    public int Id { get; set; }
    public string Name { get; set; }
    // Just properties, no behavior
}

public class CustomerService
{
    public void UpdateCustomer(Customer customer)
    {
        // All business logic lives here instead
        if (string.IsNullOrEmpty(customer.Name))
            throw new Exception("Name is required");
        // 500 more lines of validation
    }
}

// Pattern 3: The Repository That Isn't
public class CustomerRepository
{
    public Customer GetCustomerWithOrdersAndInvoices(int id) { }
    public Customer GetCustomerForEditScreen(int id) { }
    public Customer GetCustomerForReportScreen(int id) { }
    // One method per screen - classic!
}
``````

#### Data Access Evolution
``````csharp
// Era 1: Raw ADO.NET (still common in legacy)
using (SqlConnection conn = new SqlConnection(connectionString))
{
    SqlCommand cmd = new SqlCommand("GetCustomerOrders", conn);
    cmd.CommandType = CommandType.StoredProcedure;
    cmd.Parameters.AddWithValue("@CustomerId", customerId);
    
    conn.Open();
    SqlDataReader reader = cmd.ExecuteReader();
    while (reader.Read())
    {
        // Manual mapping, prone to errors
        order.Id = (int)reader["OrderId"];
        order.Date = (DateTime)reader["OrderDate"];
    }
}

// Era 2: Typed DataSets (the XML nightmares)
CustomersDataSet ds = new CustomersDataSet();
CustomersTableAdapter adapter = new CustomersTableAdapter();
adapter.Fill(ds.Customers);
// 50MB of generated code in the designer files

// Era 3: Entity Framework 6 (not Core)
using (var context = new LegacyContext())
{
    // Lazy loading disasters
    var customers = context.Customers.ToList();
    foreach (var customer in customers)
    {
        // N+1 query hell
        Console.WriteLine(customer.Orders.Count);
    }
}
``````

### Business Logic Archaeology

#### Where Business Logic Hides

Business logic in legacy systems is like water—it finds every crack and crevice.

``````csharp
// Location 1: Stored Procedures (The Classic)
CREATE PROCEDURE CalculateCustomerDiscount
    @CustomerId INT,
    @OrderTotal DECIMAL(10,2)
AS
BEGIN
    DECLARE @Discount DECIMAL(5,2) = 0
    DECLARE @CustomerTier VARCHAR(20)
    DECLARE @YearsActive INT
    
    -- 500 lines of business rules buried in T-SQL
    IF @OrderTotal > 1000 AND @CustomerTier = 'GOLD'
    BEGIN
        SET @Discount = 15 -- Why 15%? Only Bob from accounting knows
    END
    
    -- Special rule added in 2007 for that one big client
    IF @CustomerId = 42
    BEGIN
        SET @Discount = @Discount + 5
    END
END

// Location 2: Triggers (The Sneaky)
CREATE TRIGGER trg_Order_Insert
ON Orders
AFTER INSERT
AS
BEGIN
    -- Critical business logic hiding in triggers
    UPDATE Inventory 
    SET Quantity = Quantity - i.Quantity
    FROM Inventory inv
    INNER JOIN inserted i ON inv.ProductId = i.ProductId
    
    -- Side effects you'll miss during migration
    IF EXISTS (SELECT 1 FROM inserted WHERE Total > 10000)
    BEGIN
        EXEC SendEmailToManager -- Undocumented requirement!
    END
END

// Location 3: UI Layer (The Worst)
protected void btnSave_Click(object sender, EventArgs e)
{
    // Business logic that should NEVER be here
    decimal price = decimal.Parse(txtPrice.Text);
    
    // Hard-coded business rule in the UI
    if (DateTime.Now.Month == 12) // Christmas discount
    {
        price = price * 0.9m;
    }
    
    // Validation that belongs in the domain
    if (price < 10 && !User.IsInRole("Manager"))
    {
        lblError.Text = "Only managers can set prices below $10";
        return;
    }
}

// Location 4: Configuration Files (The Forgotten)
<appSettings>
    <!-- Business rules as config - what could go wrong? -->
    <add key="MinimumOrderAmount" value="50" />
    <add key="MaxDiscountPercent" value="25" />
    <add key="TaxRate_NY" value="0.08875" />
    <add key="TaxRate_NJ" value="0.06625" />
    <!-- Added by Jim in 2009, don't remove! -->
    <add key="SpecialCustomer_42_Multiplier" value="1.1" />
</appSettings>
``````

### Dependency Untangling

[Content continues with dependency mapping, interface archaeology, technical debt quantification, etc. - maintaining the same detailed pattern]

## Critical Analysis Areas

### Red Flags 🚨 (Modernization Blockers)
- Missing source code (only compiled DLLs)
- Hard dependencies on deprecated OS features
- Tightly coupled to specific hardware/drivers
- Undocumented binary protocols
- License restrictions on key components
- Business logic only in compiled stored procedures

### Yellow Flags ⚠️ (Complexity Indicators)
- Multiple architecture patterns in same system
- Inconsistent data access strategies  
- Mix of synchronous and async patterns
- Partial migrations (some to .NET Core)
- Heavy ViewState/Session dependencies
- Complex WCF configurations

### Green Flags ✅ (Modernization Enablers)
- Clear separation of concerns (even if old patterns)
- Comprehensive stored procedure collection
- Existing unit tests (even MSTest v1)
- Well-documented business rules
- Consistent patterns throughout
- Version control history available

## Legacy Analysis Output

### Executive Report Format
``````markdown
# Legacy System Analysis: [System Name]

## Executive Summary
**Business Purpose**: [Why this system exists]
**Current State**: [Version, stack, dependencies]
**Business Logic Extracted**: [X business rules, Y workflows]
**Modernization Feasibility**: [High/Medium/Low]
**Estimated Effort**: [Person-months]
**Risk Level**: [Critical/High/Medium/Low]

## Critical Findings 🚨
1. **[Finding]**: [Business impact]
2. **[Finding]**: [Business impact]

## Modernization Recommendation
[One paragraph executive recommendation]

## Investment Required
- Development: [X person-months]
- Infrastructure: [$Y]
- Training: [Z weeks]
- Total Timeline: [Months]
``````

### Technical Deep Dive Format
``````markdown
## Technical Analysis: [System Name]

### Architecture Assessment
- **Style**: [Layered/SOA/Monolith/Hybrid]
- **Complexity Score**: [X/100]
- **Coupling Level**: [High/Medium/Low]
- **Testability**: [%]

### Business Logic Inventory
#### Core Entities
| Entity | Rules | Complexity | Business Value |
|--------|-------|------------|----------------|
| Customer | 47 | High | Critical |
| Order | 156 | Critical | Critical |
| Product | 23 | Medium | High |

#### Critical Workflows
1. **[Workflow Name]**
   - Steps: [X]
   - Integration Points: [Y]
   - Business Rules: [Z]
   - Risk if Changed: [Assessment]

### Dependency Analysis
[Detailed dependency graphs and risk matrices]

### Migration Strategy
[Detailed technical approach with phases]
``````

## Remember

After 25 years of legacy analysis, I've learned that every bizarre pattern, every convoluted stored procedure, every mysterious configuration setting exists because it solved a real business problem. Sometimes that problem no longer exists, sometimes it's been forgotten, but sometimes it's the thing keeping the company running.

My job isn't to mock the past—it's to understand it so thoroughly that we can build a better future without losing what matters. Legacy code is compressed business knowledge. Handle with respect, extract with precision, and modernize with wisdom.

The best modernization preserves the "why" while upgrading the "how."
"@
}

# Export functions
Export-ModuleMember -Function Generate-AnalyzeLegacySystem, Generate-LegacySystemAnalyzer