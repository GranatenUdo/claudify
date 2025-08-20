---
description: Review frontend code for high-impact issues and provide actionable improvements
allowed-tools: [Task, Read, Grep, Glob, TodoWrite]
argument-hint: component, service, or directory to review
agent-dependencies: [Frontend Developer, Security Reviewer]
complexity: simple
estimated-time: 5-8 minutes
category: quality
---

# 🎯 Review Frontend Code: $ARGUMENTS

<think about the TOP 3 issues that could cause real problems in this frontend code>

## Phase 1: Smart Discovery (1 min)

### Find Target Files
@Glob(pattern="**/*$ARGUMENTS*")
@Grep(pattern="class|@Component|@Injectable|signal", path="$ARGUMENTS", output_mode="files_with_matches", head_limit=10)

### Read Critical Files
<!-- Read 2-3 most important files only -->

## Phase 2: Value-Focused Review (5 min)

### Frontend Developer Analysis
@Task(description="Frontend code review", prompt="Review frontend code in '$ARGUMENTS' for HIGH-IMPACT issues:

FOCUS ON TOP 3 ISSUES:
1. BREAKS functionality (bugs, infinite loops, memory leaks)
2. VIOLATES patterns (signals misuse, wrong Angular patterns, bad state management)
3. HURTS users (performance problems, accessibility issues, mobile breaks)

CHECK SPECIFICALLY:
✓ Signal usage (update vs set, computed efficiency)
✓ Change detection (OnPush everywhere?)
✓ Memory leaks (subscriptions cleaned up?)
✓ Result<T> pattern (proper error handling?)
✓ Angular 19 syntax (*ngIf not @if)
✓ Organization scoping (enforced?)
✓ Type safety (no 'any' types)

FOR EACH ISSUE:
- Problem: [Specific description]
- Impact: [What happens if not fixed]
- Fix: [Exact code to implement]
- Priority: [Critical/High/Medium]

Skip style preferences. Focus on what actually matters.", subagent_type="Frontend Developer")

### Security Quick Check
@Task(description="Security review", prompt="Security check for '$ARGUMENTS' frontend code:

CHECK ONLY:
1. XSS vulnerabilities (innerHTML, sanitization)
2. Sensitive data exposure (logs, localStorage)
3. API key/token handling
4. Organization isolation

If SECURE: Say 'Security ✓'
If ISSUES: Provide exact fix

Skip theoretical risks.", subagent_type="Security Reviewer")

## Phase 3: Actionable Output (2 min)

### Review Summary

#### 🔴 Critical Issues (Fix Now)
<!-- Issues that break functionality -->

#### 🟡 Important Issues (Fix This Sprint)
<!-- Issues that hurt maintainability -->

#### 🟢 Nice to Have (Backlog)
<!-- Minor improvements -->

### Code Quality Metrics
- Signal Architecture: [✓/✗]
- Change Detection: [✓/✗]
- Error Handling: [✓/✗]
- Type Safety: [✓/✗]
- Security: [✓/✗]

### Top 3 Actions
1. [Most important fix]
2. [Second priority]
3. [Third priority]

## Value Principles
1. **Impact Focus**: Find what could actually break
2. **Pattern Compliance**: Ensure consistency
3. **User Experience**: Consider real user impact
4. **Quick Validation**: 5-8 minutes to insights
5. **Actionable Output**: Specific fixes, not vague concerns

Remember: Find the few issues that matter, not every possible improvement.