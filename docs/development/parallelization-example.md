# Parallelization Example: Updating comprehensive-review.md

This example demonstrates how to update a command to use parallelization for significant performance improvements.

## Before: Sequential Execution (~30-60 minutes)

```markdown
### 🎨 UX & Accessibility Review
I'll start with the UX Reviewer for user experience insights.

@Task(description="Comprehensive UX analysis", prompt="...", subagent_type="UX Reviewer")

### 🏗️ Technical Architecture Review
Next, the Tech Lead will assess architectural decisions.

@Task(description="Architecture deep dive", prompt="...", subagent_type="Tech Lead")

### 🔒 Security & Compliance Assessment
The Security Reviewer will identify vulnerabilities and risks.

@Task(description="Security deep analysis", prompt="...", subagent_type="Security Reviewer")

[... and so on for each agent ...]
```

## After: Parallel Execution (~10-15 minutes)

```markdown
## Phase 2: Parallel Multi-Agent Analysis

<think about optimal parallelization strategy for comprehensive review>

I'll now invoke all specialized agents in parallel for maximum efficiency. Each agent will analyze independently from their unique perspective, then I'll synthesize their findings into actionable insights.

### Launching Parallel Analysis

Initiating comprehensive analysis across all domains simultaneously:

@Task(description="UX and accessibility analysis", prompt="Perform deep UX analysis of $ARGUMENTS:
1. **Accessibility Audit**
   - WCAG 2.1 AA compliance check
   - Keyboard navigation assessment
   - Screen reader compatibility
   - Color contrast validation
2. **User Flow Analysis**
   - Task completion efficiency
   - Error handling and recovery
   - Cognitive load assessment
   - Mobile responsiveness
[... full prompt ...]", subagent_type="UX Reviewer")

@Task(description="Architecture and scalability analysis", prompt="Analyze architectural aspects of $ARGUMENTS:
1. **System Design**
   - Alignment with overall architecture
   - Scalability for 10x growth
   - Performance under load
   - Fault tolerance and resilience
[... full prompt ...]", subagent_type="Tech Lead")

@Task(description="Security and compliance audit", prompt="Conduct security review of $ARGUMENTS:
1. **OWASP Top 10 Analysis**
   - Injection vulnerabilities
   - Broken authentication
   - Sensitive data exposure
   - XXE, XSS, CSRF risks
[... full prompt ...]", subagent_type="Security Reviewer")

@Task(description="Domain research and best practices", prompt="Research context for $ARGUMENTS:
1. **Industry Best Practices**
   - Similar implementations in agriculture
   - Proven patterns and anti-patterns
   - Performance benchmarks
   - Common pitfalls to avoid
[... full prompt ...]", subagent_type="Researcher")

@Task(description="Code simplification opportunities", prompt="Analyze $ARGUMENTS for simplification:
1. **Complexity Metrics**
   - Cyclomatic complexity scores
   - Cognitive complexity analysis
   - Method/class length issues
   - Nesting depth problems
[... full prompt ...]", subagent_type="Code Simplifier")

@Task(description="Detailed code quality review", prompt="Review code quality in $ARGUMENTS:
1. **Code Standards**
   - Naming conventions
   - Comment quality
   - Error handling patterns
   - Logging practices
[... full prompt ...]", subagent_type="Code Reviewer")

### Synthesis Phase

Now that all agents have completed their analyses in parallel, I'll synthesize their findings:

@Task(description="Synthesize all specialist findings", prompt="Integrate findings from all specialist agents for $ARGUMENTS:

You have received comprehensive analyses from:
- UX Reviewer: User experience and accessibility findings
- Tech Lead: Architecture and scalability assessment
- Security Reviewer: Security vulnerabilities and risks
- Researcher: Industry best practices and context
- Code Simplifier: Complexity reduction opportunities
- Code Reviewer: Code quality and standards compliance

Please:
1. **Cross-Cutting Concerns**
   - Identify conflicts between recommendations
   - Find synergies to leverage
   - Discover hidden dependencies
   - Recognize emergent patterns

2. **Priority Matrix**
   - Create Impact vs. Effort quadrants
   - Perform Risk vs. Reward analysis
   - Identify quick wins
   - Highlight long-term investments

3. **Implementation Roadmap**
   - Define logical sequence of changes
   - Map dependencies between tasks
   - Estimate resource requirements
   - Project realistic timelines

4. **Success Metrics**
   - Define KPIs to track
   - Establish quality gates
   - Set monitoring requirements
   - Plan review checkpoints

Create a unified action plan with clear priorities and a visual summary matrix.", subagent_type="general-purpose")

## Phase 3: Consolidated Findings

[Rest of the command remains the same, working with the synthesized results]
```

## Key Changes Made

1. **Batched Agent Invocations**: All 6 independent agent analyses now run in parallel
2. **Preserved Context**: Each agent still receives complete context for their analysis
3. **Added Synthesis Step**: The general-purpose agent explicitly waits for all results
4. **Maintained Quality**: Same detailed prompts, just executed simultaneously
5. **Clear Phase Separation**: Parallel execution → Synthesis → Presentation

## Performance Impact

- **Before**: 6 agents × 5 minutes each = 30 minutes (sequential)
- **After**: 6 agents in parallel = 5 minutes + 5 minutes synthesis = 10 minutes total
- **Improvement**: 67% reduction in execution time

## Best Practices Demonstrated

1. ✅ All independent operations identified and parallelized
2. ✅ Synthesis phase clearly separated
3. ✅ Context preserved in each prompt
4. ✅ Error handling considered (partial results)
5. ✅ Quality maintained through comprehensive prompts
6. ✅ Clear documentation of parallel execution

This pattern can be applied to many other commands in our suite for similar performance gains.