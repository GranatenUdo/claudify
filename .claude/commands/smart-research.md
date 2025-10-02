---
description: Parallel research that finds insights, not just information
allowed-tools: [Task, WebSearch, WebFetch, Read, Grep, Glob]
argument-hint: research question or topic (e.g., "should we migrate to .NET 9", "best auth pattern for multi-tenant")
complexity: moderate
estimated-time: 3-5 minutes
category: research
---

# 🧠 Smart Research: $ARGUMENTS

**For complex topics or unfamiliar domains, enable extended thinking for comprehensive analysis.**

## Phase 1: Parallel Deep Analysis (2 minutes)

### 🔍 Technical Research Agent
@Task(
  description="Technical deep dive",
  prompt="Research technical aspects of '$ARGUMENTS':

  FIRST: Check if .claude/config/project-knowledge.json exists to understand project conventions.

  FIND:
  1. How is this actually implemented in production systems?
  2. What are the real performance/security implications?
  3. What breaks when you do this wrong?

  Search for:
  - Implementation patterns in our codebase (respect existing patterns)
  - GitHub repos with actual code (not tutorials)
  - Stack Overflow problems (not just solutions)

  SYNTHESIZE findings into:
  - What works in THIS project context (with evidence)
  - What fails (with examples)
  - What aligns with our conventions (or requires change)

  Base recommendations on:
  - Project's existing patterns (if cached)
  - Observed codebase patterns (if not cached)
  - Practical needs, not theoretical ideals

  Skip prescriptive 'best practices'. Find what fits THIS project.",
  subagent_type="best-practices-researcher"
)

### 💰 Business Impact Agent
@Task(
  description="Business and ROI analysis",
  prompt="Analyze business impact of '$ARGUMENTS':
  
  QUANTIFY:
  1. What's the REAL problem this solves?
  2. What's the cost of NOT doing this?
  3. What's the ROI timeline?
  
  Consider:
  - Developer time saved/wasted
  - User experience impact
  - Technical debt created/resolved
  - Maintenance burden change
  
  Provide:
  - Cost to implement (hours)
  - Value delivered (concrete)
  - Payback period
  
  No hand-waving. Use numbers where possible.",
  subagent_type="tech-lead-engineer"
)

### ⚡ Implementation Reality Agent
@Task(
  description="Implementation feasibility check",
  prompt="Assess implementation reality for '$ARGUMENTS':
  
  CHECK:
  1. What would actually need to change in our codebase?
  2. What could break during implementation?
  3. How long would this REALLY take?
  
  Scan for:
  - Dependencies that would be affected
  - Similar changes we've done before
  - Technical debt that blocks this
  
  Be pessimistic. Include:
  - Hidden complexity
  - Integration challenges  
  - Testing requirements
  
  Give me the truth, not the sales pitch.",
  subagent_type="tech-lead-engineer"
)

### 🔄 Alternative Solutions Agent
@Task(
  description="Find alternative approaches",
  prompt="Research alternatives to '$ARGUMENTS':
  
  FIND:
  1. What are people using instead?
  2. What's the 80/20 solution?
  3. What if we do nothing?
  
  Look for:
  - Simpler alternatives that work
  - Battle-tested patterns
  - The 'boring' solution that just works
  
  Compare:
  - Complexity vs. benefit
  - Time to implement
  - Long-term maintenance
  
  Sometimes the best solution is no solution.",
  subagent_type="infrastructure-architect"
)

## Phase 2: Synthesis & Decision (1 minute)

After parallel research completes, synthesize into:

```markdown
# Research Summary: $ARGUMENTS

## 🎯 The ONE Key Insight
[The most important thing we learned]

## 📊 Evidence Supporting This
1. **Technical**: [Concrete technical finding]
2. **Business**: [Quantified business impact]  
3. **Practical**: [Real-world validation]

## ⚖️ Trade-offs Analysis
| Approach | Pros | Cons | Time | Risk |
|----------|------|------|------|------|
| Option 1 | ... | ... | X days | Low/Med/High |
| Option 2 | ... | ... | X days | Low/Med/High |
| Do Nothing | ... | ... | 0 days | Low/Med/High |

## 🎬 Recommendation
**What to do**: [Specific action]
**Why**: [One sentence reasoning]
**When**: [Now/This Sprint/Later/Never]
**How**: [First concrete step]

## ⚠️ What Could Go Wrong
1. [Biggest risk]
2. [Second risk]
3. [Mitigation for both]

## 📏 Success Metrics
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]
```

## What This Research Command Does RIGHT

1. **Parallel specialized agents** - Each has a different lens
2. **Synthesis over enumeration** - Connects findings
3. **Decision-focused** - Ends with clear recommendation
4. **Honest about trade-offs** - Including "do nothing" option
5. **Measurable outcomes** - Know if it worked

## Convention Awareness

This command adapts to your project:
- **With cached conventions** (`.claude/config/project-knowledge.json`): Recommendations align with established patterns
- **Without cached conventions**: Recommendations based on observed codebase patterns

Research findings are contextual to YOUR project, not generic "best practices".

## What We DON'T Do

❌ TodoWrite ceremony
❌ Fake metrics and percentages
❌ Mermaid diagrams for simple decisions
❌ ADRs for non-architectural decisions
❌ Pages of boilerplate text
❌ Research for research's sake
❌ Prescribe patterns without context (Result<T>, factory methods, etc.)

Remember: **Research should reduce uncertainty, not impose patterns.**