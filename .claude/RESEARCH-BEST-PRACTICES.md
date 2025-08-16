# 🔬 Research Best Practices Guide

## The Purpose of Research Commands

Research commands should **transform uncertainty into actionable intelligence**, not generate documentation.

## ✅ What Good Research Does

### 1. Answers the Real Question
- **Bad**: "Research microservices" → 50 pages about microservices
- **Good**: "Should we use microservices?" → "No, because our team of 3 can't maintain them"

### 2. Synthesizes, Not Enumerates
- **Bad**: List of 20 articles about the topic
- **Good**: One key insight from analyzing 20 sources

### 3. Includes Counter-Evidence
- **Bad**: Only positive stories about a technology
- **Good**: "3 companies succeeded, 5 failed, here's why"

### 4. Provides Specific Actions
- **Bad**: "Consider implementing caching"
- **Good**: "Add Redis cache to UserService.GetById(), save 200ms per request"

### 5. Right-Sizes the Effort
- **Bad**: 300-line template for every question
- **Good**: Quick research for simple questions, deep dive for architecture decisions

## 🚫 Anti-Patterns to Avoid

### 1. Template Maximalism
```markdown
# BAD: 300 lines of boilerplate
## Phase 1: Initial Analysis
### Sub-phase 1.1: Preliminary Research
#### Section 1.1.1: Context Gathering
[... 297 more lines of structure ...]
```

### 2. Fake Metrics
```markdown
# BAD: Made-up precision
Confidence Level: 87.3%
Success Probability: 92.7%
Implementation Complexity: 6.4/10
```

### 3. Tool Spamming
```markdown
# BAD: Using every tool because you can
@TodoWrite(...)  # Why?
@Task(subagent_type="general-purpose")  # Wrong agent
@Task(subagent_type="general-purpose")  # Same agent again?
@Task(subagent_type="general-purpose")  # Three times??
```

### 4. Cargo Cult Practices
```markdown
# BAD: ADRs for non-architectural decisions
## ADR-001: Should we fix this typo?
### Status: Proposed
### Context: There's a typo...
### Decision: Fix the typo
### Consequences: The typo will be fixed
```

## ✨ Best Practices

### 1. Use Specialized Agents
```markdown
# GOOD: Each agent brings domain expertise
@Task(subagent_type="security-reviewer")  # For security research
@Task(subagent_type="tech-lead")          # For architecture decisions
@Task(subagent_type="business-domain-analyst")  # For ROI analysis
```

### 2. Parallel Analysis for Different Perspectives
```markdown
# GOOD: Multiple viewpoints simultaneously
- Technical feasibility (tech-lead)
- Business value (business-analyst)
- Security implications (security-reviewer)
- Implementation complexity (developer)
```

### 3. Focus on Synthesis
```markdown
# GOOD: Connect findings into insights
"All three sources agree that this pattern fails at our scale.
The common factor in failures was teams smaller than 10.
We have 5 developers. Therefore: Don't do this."
```

### 4. Include Failure Analysis
```markdown
# GOOD: Learn from others' mistakes
"Uber tried this and rolled back after 6 months because..."
"Stack Overflow abandoned this pattern due to..."
```

### 5. Make Decisions Clear
```markdown
# GOOD: Clear recommendation with reasoning
**Recommendation**: Don't implement CQRS
**Why**: Adds 3 months of work for 10ms improvement
**Instead**: Add database indexes (1 day, 100ms improvement)
```

## 📊 Research Command Types

### Quick Research (2-3 minutes)
**When to use**: 
- Simple technical questions
- "How to" queries
- Best practices lookup

**Tools**: Grep, Read, WebSearch
**Output**: Direct answer with evidence

### Smart Research (3-5 minutes)
**When to use**:
- Complex questions needing synthesis
- Trade-off analysis
- Decision support

**Tools**: Task (parallel agents), WebSearch, WebFetch
**Output**: Synthesized insights with recommendations

### Specialized Research (4-5 minutes)

#### Security Research
- Vulnerability analysis
- Threat assessment
- Defense strategies

#### Performance Research
- Bottleneck identification
- Optimization opportunities
- Benchmark comparisons

#### Architecture Research
- Pattern evaluation
- Migration strategies
- Trade-off analysis

## 🎯 Quality Checklist

Before considering research complete, ensure:

- [ ] **Question answered** - Not just information gathered
- [ ] **Evidence provided** - Specific examples, not generalizations
- [ ] **Trade-offs clear** - No silver bullets
- [ ] **Action specified** - What to do next
- [ ] **Right-sized** - Effort matches importance

## 🔍 Research Workflow

### 1. Clarify the Question
```markdown
User asks: "Research microservices"
Real question: "Would microservices help our specific performance problem?"
```

### 2. Parallel Investigation
```markdown
- Technical: How do microservices solve this problem?
- Practical: What's the real implementation cost?
- Alternative: Could we solve this more simply?
```

### 3. Synthesize Findings
```markdown
- Connect insights across domains
- Identify patterns
- Find contradictions
```

### 4. Make Recommendation
```markdown
- Clear yes/no/wait decision
- Specific next steps
- Success criteria
```

## 💡 Examples

### Bad Research Output
```markdown
# Research on Caching

Caching is a technique used to store frequently accessed data...
[10 paragraphs of Wikipedia-style content]
There are many types of caches...
[More generic information]
```

### Good Research Output
```markdown
# Should we add caching to our user API?

**Answer**: Yes, but only for GetUserById endpoint

**Why**: 
- This endpoint is called 10,000 times/hour
- Database query takes 200ms
- Data changes rarely (once per day)

**Implementation**:
```csharp
[ResponseCache(Duration = 3600)]
public async Task<User> GetUserById(int id)
```

**Expected Impact**: 
- 95% cache hit rate
- 190ms faster per request
- $200/month saved on database DTUs

**First Step**: Add caching to staging and measure
```

## 🚀 Research Command Evolution

### Phase 1: Current State
- `quick-research` - Improved for intelligent searching
- `smart-research` - New parallel synthesis approach
- Specialized commands for security, performance, architecture

### Phase 2: Next Improvements
- Add learning from past research
- Create research templates for common questions
- Build knowledge base integration

### Phase 3: Future Vision
- AI-powered hypothesis generation
- Automated validation of findings
- Continuous research updates

## 📈 Measuring Research Quality

### Good Metrics
- Time to decision
- Accuracy of predictions
- Actions taken from research
- Problems prevented

### Bad Metrics
- Lines of output
- Number of sources consulted
- Time spent researching
- Completeness of documentation

## 🎬 Remember

> "The best research is the one that changes a decision, not the one that generates the most documentation."

Research is a means to an end, not an end in itself. Every research command should help someone make a better decision or solve a real problem.

If your research doesn't lead to action, it's just procrastination with extra steps.