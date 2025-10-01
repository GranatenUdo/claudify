---
description: Architecture decision research with trade-off analysis
allowed-tools: [Task, WebSearch, WebFetch, Read, Grep, Glob]
argument-hint: architecture decision or pattern (e.g., "microservices vs monolith", "event sourcing", "CQRS")
complexity: moderate
estimated-time: 4-5 minutes
category: architecture
model: opus
---

# 🏛️ Architecture Research: $ARGUMENTS

**For major architecture decisions or complex trade-off analysis, enable extended thinking for comprehensive evaluation.**

## Phase 1: Parallel Architecture Analysis (3 minutes)

### 🎯 Pattern Research Agent
@Task(
  description="Research architecture pattern",
  prompt="Research architecture pattern '$ARGUMENTS':
  
  INVESTIGATE:
  1. When this pattern actually makes sense
  2. Real companies using it successfully (and failures)
  3. Complexity vs. benefit trade-off
  
  Find:
  - Case studies with outcomes (not just adoption stories)
  - Martin Fowler / Microsoft architecture guidance
  - Post-mortems from companies that tried and failed
  
  Critical questions:
  - At what scale does this pay off?
  - What problems does it REALLY solve?
  - What new problems does it create?
  
  Be skeptical. Include failure stories.",
  subagent_type="tech-lead-engineer"
)

### 💰 Cost-Benefit Agent
@Task(
  description="Analyze costs and benefits",
  prompt="Analyze cost-benefit of '$ARGUMENTS' for our context:
  
  QUANTIFY:
  1. Implementation cost (developer months)
  2. Operational complexity increase
  3. Performance impact
  4. Maintenance burden
  
  Consider our specific context:
  - Team size and expertise
  - Current scale and growth projections
  - Existing technical debt
  - Business priorities
  
  Calculate:
  - Time to implement
  - Time to proficiency
  - Operational overhead
  - Point of positive ROI
  
  Include hidden costs most ignore.",
  subagent_type="tech-lead-engineer"
)

### 🔄 Migration Path Agent
@Task(
  description="Research migration approach",
  prompt="Research migration path to '$ARGUMENTS':
  
  DETERMINE:
  1. Can we migrate incrementally?
  2. What's the minimum viable implementation?
  3. How do others handle the transition?
  
  Find:
  - Strangler fig patterns
  - Gradual migration strategies
  - Rollback approaches
  
  Map out:
  - Phase 1: Minimum change for value
  - Phase 2: Expanding adoption
  - Phase 3: Full implementation
  - Exit strategy if it fails
  
  Focus on reversible decisions.",
  subagent_type="infrastructure-architect"
)

### ⚖️ Alternative Patterns Agent
@Task(
  description="Research alternatives",
  prompt="Find alternatives to '$ARGUMENTS':
  
  EXPLORE:
  1. Simpler patterns that solve 80% of the problem
  2. What successful companies use instead
  3. The 'boring technology' alternative
  
  Compare:
  - Implementation complexity
  - Operational complexity
  - Team learning curve
  - Long-term flexibility
  
  Sometimes the best architecture is the simplest one that could possibly work.
  
  Include the 'do nothing' option.",
  subagent_type="tech-lead-engineer"
)

## Phase 2: Our Codebase Analysis (1 minute)

### Current State Assessment
@Grep(pattern="Controller|Service|Repository", glob="**/*.cs", output_mode="files_with_matches", head_limit=20)
@Read(file_path="ARCHITECTURE.md", limit=50)

## Synthesis

```markdown
# Architecture Decision: $ARGUMENTS

## 🎭 The Reality Check

### When This Pattern Makes Sense
- [Specific scenario 1]
- [Specific scenario 2]

### When It's Overkill
- [Common misconception 1]
- [Common misconception 2]

## 📊 Trade-off Analysis

| Aspect | Current Architecture | With $ARGUMENTS | Alternative (Simpler) |
|--------|---------------------|-----------------|----------------------|
| Complexity | Low | High | Medium |
| Dev Time | - | 6 months | 2 months |
| Performance | Good | Better? | Good |
| Maintenance | 2 devs | 5 devs | 3 devs |
| Flexibility | Limited | High | Moderate |

## 💡 Key Insights

### From Success Stories
- **Company X**: Implemented at Y scale, saw Z benefit
- **Key Factor**: They had [specific need]

### From Failure Stories
- **Company A**: Spent B months, rolled back because [reason]
- **Lesson**: Don't do this unless [condition]

## 🗺️ Migration Strategy (If We Proceed)

### Phase 1: Pilot (1 month)
```csharp
// Minimal implementation for one bounded context
[Specific code structure]
```
**Success Criteria**: [Measurable outcome]

### Phase 2: Expand (3 months)
- Apply to [next area]
- Learn and adjust
- **Checkpoint**: Continue or rollback?

### Phase 3: Full adoption (6 months)
- Complete migration
- Decommission old patterns

## 🎯 Recommendation

### The Verdict: [DO IT / DON'T DO IT / WAIT]

**Why**: [One paragraph with clear reasoning]

### If YES, Start With:
1. [Specific first step]
2. [Specific second step]
3. [Success metric]

### If NO, Instead Do:
1. [Alternative approach]
2. [Why it's better for us]
3. [When to reconsider]

## ⚠️ Critical Risks

1. **Risk**: [Biggest danger]
   **Mitigation**: [How to handle]

2. **Risk**: [Second danger]
   **Mitigation**: [How to handle]

## 📏 Decision Metrics

We'll know we made the right choice if:
- [ ] [Metric 1] improves by X%
- [ ] [Metric 2] doesn't degrade
- [ ] Team velocity [increases/maintained]
- [ ] No "I told you so" moments

## 🔗 References
- [Architecture Guide](link)
- [Case Study](link)
- [Failure Post-mortem](link)
```

## Why This Architecture Research Works

1. **Reality-based** - Includes failures, not just successes
2. **Context-aware** - Considers OUR specific situation
3. **Trade-off honest** - No silver bullets
4. **Migration-focused** - How to actually get there
5. **Reversible** - Includes exit strategies

Remember: The best architecture is the one your team can actually maintain.