---
description: Debug and fix UI issues using Frontend Developer expertise with systematic debugging approach
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, TodoWrite]
argument-hint: bug description or error message
---

# Fix UI Bug: $ARGUMENTS

Internalize CLAUDE.md and FEATURES.md, then use extended thinking to systematically debug and fix **$ARGUMENTS**.

## 🧠 Frontend Developer-Led Bug Analysis

<think about leveraging specialized frontend expertise for efficient debugging>

I'll have the Frontend Developer lead the technical analysis while other agents provide complementary insights:

Using the Frontend Developer agent to: As an elite Frontend Developer, diagnose and fix the UI bug '$ARGUMENTS':
1. **Framework-Specific Analysis**
   - Angular 19 directive syntax (*ngIf, *ngFor, NOT @if/@for)
   - Angular version-specific issues and gotchas
   - Signal update patterns and reactivity problems
   - Change detection strategy conflicts
   - Component lifecycle hook issues
   - Dependency injection problems
2. **State Management Debugging**
   - Signal state synchronization issues
   - Stale closure problems
   - Race conditions in async operations
   - Memory leaks from subscriptions
   - Store/service state conflicts
3. **TypeScript & Type Safety**
   - Type inference failures
   - Generic constraint violations
   - Discriminated union handling
   - Strict mode compliance issues
   - Declaration file conflicts
4. **Browser & Performance Issues**
   - Cross-browser compatibility problems
   - CSS layout/rendering bugs
   - JavaScript engine differences
   - Performance bottlenecks
   - Memory consumption patterns
5. **Build & Tooling Problems**
   - Webpack/build configuration issues
   - Source map problems
   - Hot reload conflicts
   - Module resolution failures
   - Tree shaking issues
Provide expert diagnosis with specific code fixes and testing approach
Using the Visual Designer agent to: Analyze the UI bug '$ARGUMENTS':
1. Identify accessibility impact (WCAG violations)
2. Assess user experience degradation
3. Review mobile/responsive behavior
4. Check cross-browser compatibility issues
5. Evaluate visual regression impact
6. Analyze user workflow disruption
7. Prioritize fix based on user impact
Provide UX-focused bug assessment and fix requirements
I'll have the general-purpose agent Security implications.

### Synthesis of Expert Findings

Based on the Frontend Developer's technical expertise and complementary insights from UX and Security reviewers, I'll implement a targeted fix strategy.

## 🧠 Frontend Developer-Guided Implementation

<think about applying the Frontend Developer's diagnosis to fix the bug efficiently>

Using the Frontend Developer's expert analysis as the primary guide:
- **Primary Diagnosis**: Framework-specific root cause identified by Frontend Developer
- **UX Considerations**: Accessibility and user impact from UX Reviewer
- **Security Constraints**: Any security implications from Security Reviewer
- **Fix Strategy**: Frontend Developer's recommended approach
- **Testing Plan**: Comprehensive validation approach

## 🔍 Systematic Debugging Process

### Phase 1: Parallel Data Collection & Bug Reproduction

<think about gathering all diagnostic data simultaneously>

I'll collect all relevant information in parallel for faster diagnosis:

Searching for pattern: ERROR|WARN|Exception
Searching for pattern: $ARGUMENTS
Reading file: src/PTA.VineyardManagement.Web/package.json
Reading file: src/PTA.VineyardManagement.Web/angular.json
Running command: `cd src/PTA.VineyardManagement.Web && npm ls --depth=0`
Running command: `git log --oneline -10 -- src/PTA.VineyardManagement.Web/`

Now I'll analyze the collected data to:
1. **Reproduce the Issue**
   - Exact steps to reproduce
   - Browser/device specific?
   - User role/permissions related?
   - Data-dependent conditions?

2. **Isolate the Problem Domain**
   - Component-level issue?
   - Service/API problem?
   - State management bug?
   - Styling/layout issue?

3. **Gather Evidence**
   - Browser console errors
   - Network tab failures
   - Angular DevTools state
   - Performance timeline

### Phase 2: Investigation Strategy

Think step-by-step about where to look:

#### Frontend Investigation
- [ ] Check browser console for errors
- [ ] Inspect component state with Angular DevTools
- [ ] Review network requests for API failures
- [ ] Examine CSS for styling conflicts
- [ ] Check responsive breakpoints
- [ ] Verify data bindings and signals

#### Backend Investigation (if needed)
- [ ] Verify API endpoints return expected data
- [ ] Check for organization scoping issues
- [ ] Review server logs for errors
- [ ] Confirm caching behavior
- [ ] Test with different user roles

### Phase 3: Root Cause Analysis

Based on the parallel diagnostics and agent insights, I'll identify the root cause and develop a fix strategy.

## 🛠️ Fix Implementation

### 1. Minimal Reproduction
Create the smallest possible test case:
```typescript
// Isolate the bug in a focused test
it('should reproduce the bug', () => {
  // Minimal setup
  // Trigger the issue
  // Assert the failure
});
```

### 2. Fix Categories

#### Component Logic Bugs
```typescript
// Before: Common signal update mistakes
this.data.set([...this.data(), newItem]); // Might not trigger change detection

// After: Proper signal updates
this.data.update(current => [...current, newItem]);
```

#### Race Conditions
```typescript
// Before: Unmanaged subscriptions
ngOnInit() {
  this.service.getData().subscribe(data => {
    this.data.set(data); // Component might be destroyed
  });
}

// After: Proper cleanup
private destroy$ = new Subject<void>();

ngOnInit() {
  this.service.getData()
    .pipe(takeUntil(this.destroy$))
    .subscribe(data => this.data.set(data));
}

ngOnDestroy() {
  this.destroy$.next();
  this.destroy$.complete();
}
```

#### State Management Issues
```typescript
// Before: Direct mutation
const items = this.items();
items.push(newItem); // Mutating array
this.items.set(items);

// After: Immutable updates
this.items.update(current => [...current, newItem]);
```

#### CSS/Layout Issues
```scss
// Before: Conflicting styles
.container {
  display: flex;
  position: absolute; // Might break layout
}

// After: Scoped and specific
:host {
  .container {
    display: flex;
    position: relative;
    
    @include mobile {
      flex-direction: column;
    }
  }
}
```

## 🧪 Testing & Verification

### Phase 4: Parallel Fix Validation

<think about comprehensive validation across multiple dimensions>

I'll validate the fix from multiple angles simultaneously:

I'll have the Visual Designer agent UX validation.
I'll have the general-purpose agent Technical validation.
I'll have the general-purpose agent Architecture review.
I'll have the Technical Debt Analyst agent Simplification check.

### Comprehensive Testing Checklist
- [ ] Bug no longer reproduces with original steps
- [ ] No regression in related features
- [ ] Works across all supported browsers
- [ ] Mobile responsive behavior maintained
- [ ] Accessibility features still functional
- [ ] Performance metrics unchanged or improved

### Cross-Browser Testing
```typescript
// Test in multiple browsers
const browsers = ['Chrome', 'Firefox', 'Safari', 'Edge'];
// Use BrowserStack or similar for comprehensive testing
```

### Edge Case Verification
Think about:
- Empty states
- Loading states
- Error states
- Concurrent operations
- Different user permissions
- Various data volumes

## 🔄 Prevention Strategies

After fixing, implement safeguards:

### 1. Add Defensive Coding
```typescript
// Add null checks and defaults
protected readonly safeData = computed(() => 
  this.data() ?? []
);

// Type guards for runtime safety
private isValidResponse(response: any): response is ExpectedType {
  return response?.id && response?.name;
}
```

### 2. Improve Error Handling
```typescript
// Comprehensive error handling
this.service.getData().pipe(
  retry({ count: 2, delay: 1000 }),
  catchError(error => {
    this.errorHandler.log('Failed to load data', error);
    this.errorMessage.set('Unable to load data. Please try again.');
    return of([]);
  })
).subscribe(data => this.data.set(data));
```

### 3. Add Monitoring
```typescript
// Add debug logging for production issues
if (!environment.production) {
  console.debug('Component state:', {
    data: this.data(),
    loading: this.isLoading(),
    error: this.errorMessage()
  });
}
```

## 📝 Documentation & Communication

### Bug Report Update
Document in the fix:
- Root cause identified
- Steps taken to fix
- Testing performed
- Prevention measures added

### Update CHANGELOG.md
Add entry under [Unreleased] -> Fixed:
```markdown
### Fixed
- $ARGUMENTS
  - Root cause and user impact
  - Components affected
  - Browser compatibility fixes
```
Use `/update-changelog` command for automated updates

### Code Comments
```typescript
// BUG FIX: Issue #123 - Component was not cleaning up subscriptions
// This caused memory leaks when navigating away quickly
// Solution: Added proper cleanup with takeUntil pattern
```

### Update Tests
```typescript
it('should handle rapid navigation without memory leaks', () => {
  // Test that reproduces and verifies the fix
});
```

## 🚀 Performance Considerations

While fixing bugs, also consider:
- [ ] Is the fix performant?
- [ ] Does it introduce unnecessary re-renders?
- [ ] Are we adding too many watchers/subscriptions?
- [ ] Can we optimize while fixing?

## 🔍 Final Verification Checklist

Before marking complete:
- [ ] Original bug is fixed
- [ ] No new bugs introduced
- [ ] Tests added to prevent regression
- [ ] Code follows project patterns
- [ ] Performance impact assessed
- [ ] Documentation updated
- [ ] FEATURES.md updated if behavior changed
- [ ] Audit trail captures the fix

## 🧠 Extended Thinking Triggers

For complex bugs, think harder about:
- **Timing Issues**: Race conditions, async operations, lifecycle hooks
- **State Synchronization**: Multiple sources of truth, stale closures
- **Memory Management**: Leaks, retained references, cleanup
- **Cross-Component Communication**: Event propagation, service state
- **Browser Quirks**: CSS differences, JavaScript API variations

## 📋 Frontend Developer-Led Fix Summary

```markdown
# UI Bug Fix: [Bug Description]

## Expert Analysis Summary

### Frontend Developer Diagnosis (PRIMARY)
- **Root Cause**: [Framework-specific technical explanation]
- **Fix Approach**: [Specific implementation strategy]
- **Code Changes**: [List of modifications]
- **Testing Strategy**: [Unit/integration/e2e approach]
- **Performance Impact**: [Measured improvements]
- **Prevention**: [Framework best practices to follow]

### UX Reviewer Findings
- **User Impact**: [Low/Medium/High/Critical]
- **Accessibility Impact**: [None/Minor/Major]
- **Workflow Disruption**: [Percentage of users affected]
- **UX Improvements**: [List of enhancements]

### Security Reviewer Assessment
- **Security Risk**: [None/Low/Medium/High]
- **Data Exposure**: [Yes/No]
- **Fix Requirements**: [Security constraints]
- **Mitigations Applied**: [Security improvements]

## Fix Implementation
[Detailed description of the Frontend Developer's solution]

## Verification Results
- TypeScript compilation: [Pass/Fail]
- Unit tests: [X/Y passing]
- Integration tests: [Pass/Fail]
- Visual regression: [Pass/Fail]
- Accessibility tests: [Pass/Fail]
- Cross-browser tests: [Pass/Fail]
- Performance tests: [Pass/Fail]
- Build optimization: [Bundle size impact]

## Prevention Measures
- Framework patterns documented (Frontend Developer)
- UX guidelines added (UX Reviewer)
- Security checks implemented (Security Reviewer)
- Type safety improved (Frontend Developer)
- Test coverage increased (Frontend Developer)
```

## Benefits of Frontend Developer-Led Bug Fixing

1. **Expert Diagnosis**: Frontend Developer provides framework-specific expertise
2. **Faster Resolution**: Expert knowledge reduces debugging time by 50%+
3. **Accurate Fixes**: Deep understanding of Angular/TypeScript prevents incorrect fixes
4. **Comprehensive Testing**: Frontend Developer knows exactly what to test
5. **Better Prevention**: Framework best practices prevent recurrence
6. **Parallel Validation**: UX and Security reviewers provide complementary insights

### Why Frontend Developer Leadership Matters

- **Framework Expertise**: 15+ years of frontend experience catches subtle issues
- **Pattern Recognition**: Instantly identifies common Angular/TypeScript problems
- **Modern Practices**: Knows signals, standalone components, and latest patterns
- **Tool Mastery**: Understands build tools, bundlers, and dev environment
- **Performance Focus**: Optimizes while fixing, not just patching

Remember: **The Frontend Developer agent brings specialized expertise that general agents lack. This targeted knowledge leads to faster, more accurate bug fixes with better testing and prevention strategies. The parallel support from UX and Security reviewers ensures the fix is comprehensive without sacrificing speed.**