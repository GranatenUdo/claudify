---
description: Analyze and optimize existing commands for maximum value delivery
allowed-tools: [Read, Write, Task, TodoWrite]
argument-hint: command name to optimize (without .md extension)
---

# 🎯 Optimize Command for Value: $ARGUMENTS

<think harder about what this command REALLY needs to deliver vs what it currently does>

## Phase 1: Value Analysis (2 min)

### Read Current Command
@Read(file_path=".claude/commands/$ARGUMENTS.md")

### Analyze with Tech Lead
@Task(description="Optimize for value", prompt="Analyze the '$ARGUMENTS' command and optimize for MAXIMUM VALUE:

IDENTIFY WASTE:
1. Redundant operations (doing the same thing twice)
2. Over-analysis (analyzing everything vs what matters)
3. Excessive agents (>2-3 for most tasks)
4. Sequential operations (could be parallel)
5. Low-value activities (documentation before working code)

OPTIMIZE FOR VALUE:
- Focus: TOP 3-5 things that matter most
- Evidence: Must read actual files
- Delivery: Working code over plans
- Agents: Minimum necessary (usually 1-2)
- Time: Look for reduction opportunities

VALUE PRINCIPLES:
1. Ship what users need TODAY
2. Fix what could actually break
3. Follow existing patterns
4. Security is non-negotiable
5. Good enough to ship, perfect enough to maintain

PROVIDE:
1. What to REMOVE (line numbers or sections)
2. What to FOCUS ON (top 3 deliverables)
3. Agents to consolidate
4. Parallel execution opportunities
5. Rewritten core prompt (concise, value-focused)", subagent_type="tech-lead-engineer")

## Phase 2: Generate Value-Focused Version (3 min)

### Create Optimized Command
<!-- Will update $ARGUMENTS.md with value optimizations -->

### Value-First Patterns

#### Focus on What Matters
```yaml
# BEFORE (trying to do everything):
- Comprehensive analysis
- Complete documentation
- Complete test coverage
- All edge cases
- Perfect code style

# AFTER (ship value):
- TOP 3 features users need
- Working code with basic tests
- Security validation
- Follows existing patterns
- Ships today
```

#### Consolidate Agents
```yaml
# BEFORE (many specialists):
- Visual Designer (UI)
- UX Reviewer (UX)
- Frontend Developer (code)
- Code Reviewer (quality)
- Test Analyst (tests)

# AFTER (focused expertise):
- Frontend Developer (handles UI/UX/code/tests)
- Security Reviewer (if needed)
```

#### Parallel Everything
```yaml
# BEFORE (sequential):
Read file 1, wait...
Read file 2, wait...
Analyze, wait...

# AFTER (parallel):
All reads + analysis simultaneously
Reduced waiting time
```

## Phase 3: Value Validation (2 min)

### Optimized Command Must:
- [ ] Deliver TOP 3-5 value items
- [ ] Use ≤3 agents (usually 1-2)
- [ ] Run operations in parallel
- [ ] Focus on working code
- [ ] Include security checks
- [ ] Reduce time where possible
- [ ] Be <150 lines total

### Document Value Gains
- Original approach: Document time and agents used
- Optimized approach: Document improvements made
- What we skip: Low-value activities
- What we deliver: High-impact results

## Success Metrics
- Value focus: TOP 3-5 items only
- Agent reduction: Use minimum necessary
- Time reduction: Optimize where possible
- Line reduction: Keep concise
- Actionable output: Always provide next steps

## Convention Awareness

When optimizing commands, respect project patterns observed in the codebase.

Remember: Every line should help ship value. If it doesn't directly contribute to working features, remove it.