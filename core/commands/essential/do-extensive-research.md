---
description: Conduct deep technical research with multi-agent analysis and extended thinking
allowed-tools: [Task, Read, Grep, Glob, LS, TodoWrite, WebSearch, Bash]
argument-hint: research topic or technical question
agent-dependencies: [Researcher, Tech Lead, Security Reviewer, Code Reviewer, Feature Analyzer, general-purpose]
complexity: moderate
estimated-time: 15-20 minutes (reduced from 30 with parallel execution)
category: analysis
---

# 🧠 Deep Research Analysis: $ARGUMENTS

## Phase 0: Task Management Setup

### 📋 TodoWrite Task Management
<think step-by-step about organizing the research process>

@TodoWrite(todos=[
  {id: "1", content: "Define research scope and questions", status: "in_progress", priority: "high"},
  {id: "2", content: "Parallel information gathering", status: "pending", priority: "high"},
  {id: "3", content: "Multi-agent analysis", status: "pending", priority: "high"},
  {id: "4", content: "Pattern recognition", status: "pending", priority: "high"},
  {id: "5", content: "Synthesize findings", status: "pending", priority: "high"},
  {id: "6", content: "Generate recommendations", status: "pending", priority: "high"}
])

### 📊 Agent Specialization Matrix

| Research Type | Primary Agent | Secondary Agents | Parallel? |
|--------------|---------------|------------------|----------|
| Technical | Tech Lead | Code Reviewer | ✅ Yes |
| Security | Security Reviewer | Tech Lead | ✅ Yes |
| Best Practices | Researcher | Tech Lead | ✅ Yes |
| Industry | Researcher | - | ❌ No |

## OPUS 4 ACTIVATION - EXTENDED THINKING MODE
<think harder about the research topic from multiple perspectives - technical, business, operational, and strategic implications>

**Research Directive**: Conduct comprehensive analysis of "$ARGUMENTS" using deep interleaved thinking to uncover insights, patterns, and actionable recommendations. Leverage Opus 4's advanced reasoning capabilities to explore complex interconnections and provide strategic guidance.

## Phase 1: Research Scope Definition (Deep Reasoning)

<think step-by-step about the research dimensions and boundaries>

### Initial Analysis Framework
Execute parallel research streams:
1. **Domain Context**: Understanding the problem space
2. **Current State Analysis**: What exists today - patterns, solutions, limitations
3. **Industry Best Practices**: How leading organizations solve similar challenges
4. **Future Trends**: Emerging technologies and methodologies
5. **Risk & Opportunity Assessment**: What to leverage vs. what to avoid

### Research Questions to Address
<think deeper about the fundamental questions that need answering>
- What are the core challenges and constraints?
- Who are the stakeholders and what are their needs?
- What are the technical and business trade-offs?
- What are the short-term vs. long-term implications?
- How does this align with the domain context?

## Phase 2: Information Gathering (Parallel Analysis)

<think harder about efficient information gathering strategies>

### Task Progress Update
@TodoWrite(todos=[/* Update task 1 to completed, task 2 to in_progress */])

### 🚀 Parallel Execution Pattern (40-60% Performance Gain)
```bash
# ✅ OPTIMAL: All research operations run in parallel
@Grep(pattern="$ARGUMENTS", output_mode="files_with_matches")
@Glob(pattern="**/*$ARGUMENTS*.*")
@WebSearch(query="$ARGUMENTS best practices 2025")
@WebSearch(query="$ARGUMENTS security considerations")
@Read(file_path="README.md")
@Read(file_path="ARCHITECTURE.md")
@Bash(command="git log --grep='$ARGUMENTS' --oneline -20")
```

### Codebase Analysis
```
Parallel searches to understand existing patterns:
- Domain models and business logic
- Service implementations  
- Infrastructure patterns
- Configuration and setup
```

### Parallel Multi-Agent Research
<think about credible sources and latest developments>

@Task(description="Technical research", prompt="Research technical aspects of $ARGUMENTS:
1. Current implementation patterns
2. Performance benchmarks
3. Scalability considerations
4. Integration approaches
5. Common pitfalls
6. Success stories
Provide evidence-based findings", subagent_type="general-purpose")
@Task(description="Security research", prompt="Analyze security implications of $ARGUMENTS:
1. Known vulnerabilities
2. Attack vectors
3. Mitigation strategies
4. Compliance requirements
5. Best practices
Provide security assessment", subagent_type="general-purpose")
@Task(description="Architecture analysis", prompt="Evaluate architectural patterns for $ARGUMENTS:
1. Design patterns
2. Anti-patterns
3. Trade-offs
4. Alternative approaches
5. Future-proofing
Provide architectural recommendations", subagent_type="general-purpose")

### Pattern Recognition
<use extended thinking to identify patterns across the research>
- Common approaches and their trade-offs
- Anti-patterns to avoid
- Success factors from similar implementations
- Failure modes and mitigation strategies

## Phase 3: Deep Analysis (Opus 4 Extended Reasoning)

<think step-by-step about multi-dimensional implications>

### Task Progress Update
@TodoWrite(todos=[/* Update task 2 to completed, task 3-4 to in_progress */])

### Multi-Dimensional Analysis Framework

#### Technical Dimension
<think harder about technical implications and architectural decisions>
- **Performance Impact**: Latency, throughput, resource utilization
- **Scalability Patterns**: Horizontal vs. vertical, sharding strategies
- **Security Considerations**: Authentication, authorization, data protection
- **Integration Complexity**: APIs, data formats, protocols
- **Maintenance Burden**: Code complexity, operational overhead

#### Business Dimension
<analyze business value and strategic alignment>
- **ROI Analysis**: Implementation cost vs. business value
- **Time to Market**: Development timeline and milestones
- **Competitive Advantage**: Differentiation opportunities
- **Risk Assessment**: Technical, operational, and market risks
- **Compliance Requirements**: Regulatory and industry standards

#### Operational Dimension
<consider day-to-day operational impacts>
- **Team Capabilities**: Required skills and training
- **Deployment Strategy**: Rollout plan and rollback procedures
- **Monitoring & Observability**: Metrics, alerts, dashboards
- **Support Requirements**: Documentation, runbooks, escalation
- **Disaster Recovery**: Backup, restore, business continuity

## Phase 4: Synthesis & Recommendations

<think harder about actionable insights and practical applications>

### Task Progress Update
@TodoWrite(todos=[/* Update tasks 3-4 to completed, task 5-6 to in_progress */])

### Key Findings Summary
<synthesize research into actionable insights>

#### Critical Insights
1. **Primary Discovery**: [Core finding from research]
2. **Unexpected Learning**: [Surprising insight that changes perspective]
3. **Risk Identification**: [Major risk that must be addressed]
4. **Opportunity Recognition**: [Untapped potential discovered]

### Strategic Recommendations

#### Immediate Actions (0-1 month)
- **Quick Wins**: Low-effort, high-impact changes
- **Risk Mitigation**: Address critical vulnerabilities
- **Foundation Building**: Prerequisites for larger changes

#### Short-term Initiatives (1-3 months)
- **Feature Implementation**: Core functionality development
- **Integration Work**: API and service connections
- **Testing Framework**: Comprehensive test coverage

#### Long-term Strategy (3-6 months)
- **Architecture Evolution**: Scalability improvements
- **Performance Optimization**: Cloud-native patterns
- **Team Development**: Skills and knowledge transfer

### Implementation Confidence
- **Technical Feasibility**: [Score/10]
- **Resource Availability**: [Score/10]
- **Risk Level**: [Low/Medium/High]
- **Success Probability**: [Percentage]

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
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```

## Final Task Completion
@TodoWrite(todos=[/* Mark all tasks as completed */])

## Research Complete
✅ All research tasks completed
✅ Multi-agent analysis synthesized
✅ Actionable recommendations provided
✅ Confidence score calculated
- **Core Implementation**: Primary solution components
- **Team Enablement**: Training and process updates
- **Measurement Setup**: KPIs and success metrics

#### Long-term Vision (3-12 months)
- **Strategic Evolution**: Major architectural shifts
- **Capability Development**: Team and technology growth
- **Market Positioning**: Competitive advantages to build

### Implementation Roadmap

```mermaid
gantt
    title Research-Driven Implementation Plan
    dateFormat  YYYY-MM-DD
    section Foundation
    Research Validation       :a1, 2025-01-25, 7d
    Proof of Concept         :a2, after a1, 14d
    Team Alignment           :a3, after a1, 7d
    section Development
    Core Features            :b1, after a2, 30d
    Integration Work         :b2, after a2, 21d
    Testing & Validation     :b3, after b1, 14d
    section Deployment
    Pilot Rollout           :c1, after b3, 7d
    Full Deployment         :c2, after c1, 14d
    Optimization Phase      :c3, after c2, 30d
```

## Phase 5: Risk Analysis & Mitigation (Deep Thinking)

<think harder about what could go wrong and how to prevent it>

### Risk Matrix

| Risk Category | Probability | Impact | Mitigation Strategy |
|--------------|-------------|---------|-------------------|
| Technical Debt | Medium | High | Incremental refactoring, clear boundaries |
| Performance Degradation | Low | High | Load testing, monitoring, gradual rollout |
| Team Resistance | Medium | Medium | Early involvement, training, clear benefits |
| Integration Failures | Low | Medium | Comprehensive testing, fallback mechanisms |
| Budget Overrun | Medium | Medium | Phased approach, regular checkpoints |

### Contingency Planning
1. **Fallback Options**: Alternative approaches if primary fails
2. **Rollback Procedures**: How to safely revert changes
3. **Communication Plan**: Stakeholder updates and escalation
4. **Success Criteria**: Clear go/no-go decision points

## Phase 6: Detailed Technical Specification

<provide concrete technical guidance based on research>

### Architecture Decision Record (ADR)

```markdown
## ADR-[NUMBER]: [DECISION TITLE]

### Status
Proposed

### Context
[Detailed background from research findings]

### Decision
[Specific technical choice with rationale]

### Consequences
**Positive:**
- [Benefit 1 with supporting evidence]
- [Benefit 2 with metrics]

**Negative:**
- [Trade-off 1 with mitigation]
- [Trade-off 2 with acceptance criteria]

### Alternatives Considered
1. [Alternative 1]: [Why not chosen]
2. [Alternative 2]: [Why not chosen]
```

### Sample Implementation

```csharp
// Example implementation based on research findings
public class ResearchDrivenSolution : IOptimalApproach
{
    // Implementation incorporates all research insights
    // Comments reference specific findings and rationale
}
```

## Phase 7: Monitoring & Success Metrics

### Key Performance Indicators (KPIs)
<define measurable success criteria>

#### Technical Metrics
- Response time: < [target]ms (p95)
- Error rate: < [target]%
- Resource utilization: < [target]%
- Code coverage: > [target]%

#### Business Metrics
- User adoption: [target]% in [timeframe]
- Process efficiency: [target]% improvement
- Cost savings: $[target] annually
- Customer satisfaction: [target] NPS increase

### Monitoring Dashboard
```yaml
dashboard:
  - metric: API Performance
    threshold: 200ms
    alert: PagerDuty
  - metric: Error Rate
    threshold: 0.1%
    alert: Slack
  - metric: User Engagement
    threshold: 80%
    alert: Email
```

## Phase 8: Knowledge Transfer & Documentation

### Documentation Deliverables
1. **Executive Summary**: 1-page overview for leadership
2. **Technical Deep Dive**: Detailed implementation guide
3. **Operations Runbook**: Day-to-day management procedures
4. **Training Materials**: Team enablement resources

### Knowledge Base Update
- Update project documentation with patterns discovered
- Document significant decisions as ADRs
- Create runbooks for operations
- Share learnings with team

## OPUS 4 FINAL SYNTHESIS

<use maximum thinking depth to integrate all insights>

### Executive Summary
**Research Topic**: $ARGUMENTS

**Key Finding**: [Primary insight that drives all recommendations]

**Recommended Approach**: [Clear, actionable direction based on research]

**Expected Outcome**: [Measurable business and technical impact]

### Top 3 Recommendations
1. **[HIGHEST PRIORITY]**: [Specific action with timeline]
2. **[MEDIUM PRIORITY]**: [Specific action with dependencies]  
3. **[FUTURE CONSIDERATION]**: [Strategic direction to explore]

### Critical Success Factors
- ✅ [Factor 1]: [How to ensure]
- ✅ [Factor 2]: [How to ensure]
- ✅ [Factor 3]: [How to ensure]

### Next Steps Checklist
- [ ] Review findings with stakeholders
- [ ] Validate assumptions with POC
- [ ] Create detailed project plan
- [ ] Assign team responsibilities
- [ ] Set up monitoring and metrics
- [ ] Schedule regular review checkpoints

---

**Remember**: Deep research with Opus 4 combines exhaustive analysis with practical recommendations. Every finding is backed by evidence, every recommendation considers implementation reality, and every decision accounts for long-term sustainability.