# 🔬 Research Commands Analysis: A Critical Review

## The Two Commands Under Review

### 1. Quick Research (41 lines)
- **Purpose**: Find TOP 3 answers in 2 minutes
- **Approach**: Grep → Read → WebSearch
- **Output**: Brief markdown summary

### 2. Extensive Research Template (300+ lines)
- **Purpose**: Deep dive with multiple phases
- **Approach**: TodoWrite → Parallel agents → Extended thinking → ADRs → Dashboards
- **Output**: Comprehensive report with diagrams

## 🚨 Critical Problems Identified

### Problem #1: Both Miss the Point of Research

#### Quick Research Issues:
- **Too shallow**: Just greps and reads without understanding
- **No synthesis**: Lists findings without connecting dots
- **No validation**: Accepts first results without verification
- **Poor tool usage**: WebSearch as afterthought, not integrated

#### Extensive Research Issues:
- **Template theater**: 90% boilerplate, 10% actual research
- **Cargo cult practices**: TodoWrite and ADRs without purpose
- **Analysis paralysis**: So many phases nothing gets done
- **Fake sophistication**: Mermaid diagrams hiding lack of insight

### Problem #2: Neither Leverages Claude's Strengths

**What Claude is GREAT at:**
- Pattern recognition across disparate sources
- Synthesizing complex information
- Drawing non-obvious connections
- Evaluating trade-offs

**What these commands do:**
- Mechanical searching
- Template filling
- Checkbox completion
- Format over substance

### Problem #3: Inefficient Tool Usage

**Quick Research:**
```markdown
@Grep(pattern="$ARGUMENTS", ...)  # Too literal
@Read(file_path="README.md", ...) # Why always README?
@WebSearch(query="$ARGUMENTS...") # No query refinement
```

**Extensive Research:**
```markdown
@TodoWrite(todos=[...])  # Unnecessary overhead
@Task(subagent_type="general-purpose")  # Wrong agent
@Task(subagent_type="general-purpose")  # Duplicate agents!
@Task(subagent_type="general-purpose")  # Why 3 times?
```

## ✅ What GOOD Research Commands Look Like

### Optimal Research Pattern

```markdown
---
description: Smart research that finds insights, not just information
allowed-tools: [Task, WebSearch, WebFetch, Read, Grep, Glob]
estimated-time: 3-5 minutes
---

# Research: $ARGUMENTS

## Phase 1: Parallel Intelligence Gathering (90 seconds)

### Domain Expert Analysis
@Task(
  description="Domain research",
  prompt="Research '$ARGUMENTS' focusing on:
  1. Current best practices in the industry
  2. Common pitfalls and how to avoid them
  3. Real-world case studies with outcomes
  
  Use WebSearch for recent developments.
  Synthesize findings, don't just list them.",
  subagent_type="researcher"
)

### Technical Deep Dive
@Task(
  description="Technical analysis",
  prompt="Analyze technical aspects of '$ARGUMENTS':
  1. Implementation patterns that work
  2. Performance implications
  3. Security considerations
  
  Search codebase for existing patterns.
  Identify what we're doing vs. best practices.",
  subagent_type="tech-lead"
)

### Business Impact Analysis
@Task(
  description="Business analysis",
  prompt="Evaluate business impact of '$ARGUMENTS':
  1. Cost-benefit analysis
  2. Risk assessment
  3. ROI timeline
  
  Focus on measurable outcomes.",
  subagent_type="business-domain-analyst"
)

## Phase 2: Synthesis (30 seconds)

Consolidate findings into:
1. **Core Insight**: The ONE thing that matters
2. **Action Items**: What to do about it
3. **Evidence**: Proof points that support decisions
```

### Why This Works Better:
1. **Parallel specialized agents** vs. sequential generic searches
2. **Synthesis-focused** vs. list-making
3. **Outcome-oriented** vs. process-oriented
4. **Right-sized** vs. too short or too long

## 🎯 Specific Improvements Needed

### For Quick Research:
```markdown
# BEFORE (Current)
@Grep(pattern="$ARGUMENTS", ...)  # Too literal

# AFTER (Better)
@Grep(pattern="$KEYWORDS", ...)   # Extract keywords first
@Grep(pattern="class.*$CONCEPT", ...) # Search for implementations
@Grep(pattern="TODO.*$ARGUMENTS", ...) # Find known issues
```

### For Extensive Research:
```markdown
# REMOVE:
- TodoWrite ceremony (adds no value)
- Fake metrics ("Confidence: 87.3%")
- Redundant phases
- Generic templates

# ADD:
- Specific research questions
- Hypothesis testing
- Counter-evidence search
- Practical validation
```

## 📈 Research Quality Metrics

### Good Research Should Answer:
1. **What's the real problem?** (not assumed)
2. **What have others tried?** (with outcomes)
3. **What's our best option?** (with trade-offs)
4. **How do we validate success?** (measurable)

### Current Commands Score:
| Metric | Quick Research | Extensive Research |
|--------|---------------|-------------------|
| Finds real insights | 2/10 | 3/10 |
| Actionable output | 4/10 | 2/10 |
| Time efficiency | 7/10 | 1/10 |
| Leverages Claude | 3/10 | 4/10 |
| **Overall** | **4/10** | **2.5/10** |

## 🔧 Recommended Rewrite

### New "Smart Research" Command
```yaml
---
name: smart-research
description: Research that finds insights, not just information
estimated-time: 3-5 minutes
tools: Task, WebSearch, WebFetch, Grep
---

Purpose: Answer the REAL question behind $ARGUMENTS

1. Parallel Analysis (2 min)
   - Domain expert: Industry best practices
   - Tech lead: Implementation patterns
   - Business analyst: ROI and risks

2. Synthesis (1 min)
   - Connect findings across domains
   - Identify non-obvious patterns
   - Challenge assumptions

3. Recommendations (30 sec)
   - ONE key insight
   - THREE action items
   - Evidence for decisions

Output: Insight → Evidence → Action
```

## 🚫 Anti-Patterns to Avoid

1. **Template Maximalism**: More structure ≠ better research
2. **Tool Spamming**: Using every tool ≠ comprehensive
3. **Fake Sophistication**: Diagrams and metrics ≠ insight
4. **Process Theater**: Following steps ≠ finding answers
5. **Parallel Waste**: Multiple agents doing same thing

## ✅ Best Practices for Research Commands

### DO:
- Start with hypothesis to test
- Use specialized agents for their expertise
- Synthesize across sources
- Challenge findings with counter-evidence
- Focus on actionable insights

### DON'T:
- Grep for literal strings
- Use generic "general-purpose" agents
- Create walls of boilerplate text
- Measure success by output length
- Confuse activity with productivity

## 💡 The Core Problem

Both commands suffer from the same fundamental issue:
**They optimize for LOOKING comprehensive rather than BEING insightful.**

The quick research is too shallow to find real insights.
The extensive research is too bloated to deliver value.

Neither actually does what research should do:
**Transform uncertainty into actionable intelligence.**

## 🎯 Final Verdict

**Quick Research**: 4/10 - Needs depth and synthesis
**Extensive Research**: 2.5/10 - Needs focus and efficiency

Both need complete rewrites focusing on:
1. **Insight generation** over information gathering
2. **Synthesis** over enumeration
3. **Practical value** over process compliance
4. **Right-sized** approach for the question

The extensive research template is particularly problematic - it's a perfect example of "framework fever" where the ceremony obscures the purpose.