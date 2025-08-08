---
description: Perform comprehensive UI code review led by Frontend Developer for framework compliance, performance, and quality
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, TodoWrite]
argument-hint: component path, PR number, or feature name to review
agent-dependencies: [Frontend Developer, UX Reviewer, Security Reviewer, Code Reviewer]
complexity: moderate
estimated-time: 15-20 minutes
category: quality
---

# Review UI Code: $ARGUMENTS

## 🧠 Frontend Developer-Led Code Review

<think about leveraging specialized frontend expertise for comprehensive review>

I'll have the Frontend Developer lead the technical review while other agents provide complementary assessments.

### Phase 0: Multi-Agent Parallel Review

@Task(description="Frontend technical code review", prompt="As an elite Frontend Developer, perform comprehensive code review of $ARGUMENTS:

FRAMEWORK COMPLIANCE:
1. **Angular Best Practices**
   - Signal usage and reactivity patterns
   - Standalone component structure
   - Dependency injection correctness
   - Change detection optimization
   - Modern control flow syntax (@if, @for)
2. **TypeScript Excellence**
   - Type safety and inference
   - Strict mode compliance
   - Generic usage appropriateness
   - Interface vs type decisions
   - Discriminated unions
3. **Performance Analysis**
   - Bundle size impact
   - Render cycle optimization
   - Memory leak prevention
   - Virtual scrolling usage
   - Lazy loading boundaries
4. **Code Quality**
   - SOLID principles adherence
   - DRY implementation
   - Naming conventions
   - File organization
   - Import structure
5. **Testing Coverage**
   - Unit test completeness
   - Integration test scenarios
   - E2E test coverage
   - Test maintainability
   - Mock appropriateness
6. **Modern Patterns**
   - Signals vs observables
   - Computed properties
   - Effects usage
   - State management
   - Error handling

Provide detailed review with specific improvements, code examples, and severity ratings.", subagent_type="Frontend Developer")
@Task(description="UX and accessibility review", prompt="Review UI/UX aspects of $ARGUMENTS:
1. WCAG 2.1 AA compliance verification
2. Keyboard navigation completeness
3. Screen reader compatibility
4. Mobile responsiveness
5. Touch target sizes
6. Color contrast ratios
7. Focus management
8. Error messaging clarity
9. Loading state quality
10. Animation performance
Provide accessibility score and UX improvements", subagent_type="Visual Designer")
@Task(description="Security code review", prompt="Analyze security aspects of $ARGUMENTS:
1. XSS vulnerability assessment
2. Input sanitization verification
3. Safe innerHTML usage
4. Content Security Policy compliance
5. Authentication state handling
6. Sensitive data exposure
7. Third-party library risks
8. CORS implementation
Provide security assessment with risk ratings", subagent_type="general-purpose")

### Synthesis of Expert Reviews

Based on the Frontend Developer's technical leadership and complementary insights from UX and Security reviewers, I'll provide comprehensive review feedback.

## 🔍 Frontend Developer-Guided Review Process

### Phase 1: Context and Scope Analysis

Use interleaved thinking to understand the UI code:

1. **Component Architecture Review**
   ```bash
   # Check component structure
   find src/app -name "*.component.ts" -o -name "*.component.html" | head -20
   
   # Review recent UI changes
   git diff --name-only main..HEAD | grep -E '\.(ts|html|scss)$'
   ```

2. **Design System Compliance**
   - Uses Angular Material components correctly?
   - Follows established UI patterns from FEATURES.md?
   - Consistent with existing components?

3. **Signal Usage Analysis**
   ```typescript
   // Check for proper signal patterns
   grep -r "signal(" --include="*.ts" src/app/
   ```

### Phase 2: Accessibility Review (WCAG 2.1 AA)

#### 1. Semantic HTML
```html
<!-- ❌ BAD: Generic divs -->
<div class="header">
  <div class="nav-item" (click)="navigate()">Home</div>
</div>

<!-- ✅ GOOD: Semantic elements -->
<header>
  <nav>
    <button type="button" (click)="navigate()">Home</button>
  </nav>
</header>
```

#### 2. ARIA Implementation
```html
<!-- ❌ BAD: Missing ARIA labels -->
<button mat-icon-button (click)="delete()">
  <mat-icon>delete</mat-icon>
</button>

<!-- ✅ GOOD: Proper ARIA -->
<button mat-icon-button 
        (click)="delete()"
        [attr.aria-label]="'Delete ' + field.name"
        [attr.aria-describedby]="'delete-confirm-' + field.id">
  <mat-icon>delete</mat-icon>
</button>
```

#### 3. Keyboard Navigation
```typescript
// ✅ GOOD: Keyboard support
@HostListener('keydown', ['$event'])
handleKeyboardEvent(event: KeyboardEvent) {
  switch (event.key) {
    case 'Enter':
    case ' ':
      event.preventDefault();
      this.onClick();
      break;
    case 'Escape':
      this.close();
      break;
  }
}
```

#### 4. Color Contrast
```scss
// ❌ BAD: Poor contrast
.text-light {
  color: #999; // on white background
}

// ✅ GOOD: WCAG AA compliant
.text-secondary {
  color: #666; // 4.5:1 contrast ratio
  
  @media (prefers-contrast: high) {
    color: #333; // Higher contrast
  }
}
```

### Phase 3: Performance Analysis

#### 1. Change Detection Optimization
```typescript
// ❌ BAD: Default change detection
@Component({
  selector: 'app-field-list',
  templateUrl: './field-list.component.html'
})

// ✅ GOOD: OnPush strategy
@Component({
  selector: 'app-field-list',
  templateUrl: './field-list.component.html',
  changeDetection: ChangeDetectionStrategy.OnPush
})
```

#### 2. Signal Patterns
```typescript
// ❌ BAD: Improper signal updates
ngOnInit() {
  this.data.set(this.service.getData()); // Async operation
}

// ✅ GOOD: Proper signal with effects
private readonly data = signal<Field[]>([]);
private readonly loading = signal(true);

constructor() {
  effect(() => {
    this.loadData();
  });
}

private async loadData() {
  this.loading.set(true);
  try {
    const result = await firstValueFrom(this.service.getData());
    this.data.set(result);
  } finally {
    this.loading.set(false);
  }
}
```

#### 3. Memory Leak Prevention
```typescript
// ❌ BAD: Unmanaged subscriptions
ngOnInit() {
  this.service.data$.subscribe(data => {
    this.data = data;
  });
}

// ✅ GOOD: Proper cleanup
private readonly destroy$ = new Subject<void>();

ngOnInit() {
  this.service.data$
    .pipe(takeUntil(this.destroy$))
    .subscribe(data => this.data.set(data));
}

ngOnDestroy() {
  this.destroy$.next();
  this.destroy$.complete();
}
```

#### 4. Bundle Size Optimization
```typescript
// ❌ BAD: Importing entire library
import * as _ from 'lodash';

// ✅ GOOD: Tree-shakeable imports
import { debounce } from 'lodash-es/debounce';
```

### Phase 4: Angular 18 Best Practices

#### 1. Standalone Components
```typescript
// ✅ GOOD: Standalone with explicit imports
@Component({
  selector: 'app-field-card',
  standalone: true,
  imports: [
    CommonModule,
    MatCardModule,
    MatButtonModule,
    MatIconModule
  ],
  templateUrl: './field-card.component.html',
  styleUrl: './field-card.component.scss'
})
```

#### 2. Control Flow Syntax
```html
<!-- ❌ OLD: Structural directives -->
<div *ngIf="loading">Loading...</div>
<div *ngFor="let item of items">{{ item.name }}</div>

<!-- ✅ NEW: Control flow syntax -->
@if (loading()) {
  <app-loading-skeleton />
}
@for (item of items(); track item.id) {
  <app-field-card [field]="item" />
}
```

#### 3. Reactive Forms with Signals
```typescript
// ✅ GOOD: Form state with signals
protected readonly formValid = signal(false);
protected readonly formErrors = signal<ValidationErrors | null>(null);

ngOnInit() {
  this.form.statusChanges
    .pipe(takeUntil(this.destroy$))
    .subscribe(status => {
      this.formValid.set(status === 'VALID');
      this.formErrors.set(this.form.errors);
    });
}
```

### Phase 4.5: Security Analysis

I'll invoke the Security Reviewer agent for this analysis.

@Task(description="Security Reviewer analysis", prompt="Review UI security for $ARGUMENTS:
1. XSS vulnerability assessment
2. Secure handling of user inputs
3. Safe innerHTML usage verification
4. Content Security Policy compliance
5. Authentication state management
6. Sensitive data exposure in DOM
7. Third-party library vulnerabilities
8. CORS and API security
Provide UI security assessment report
", subagent_type="Security Reviewer")

### Phase 5: Code Simplification Opportunities

I'll invoke the Code Simplifier agent for this analysis.

@Task(description="Code Simplifier analysis", prompt="Identify complexity reduction opportunities in $ARGUMENTS:
1. Over-engineered components
2. Redundant state management
3. Complex template logic that belongs in components
4. Repeated patterns that could be extracted
5. Unnecessary abstractions
6. Consolidation of similar components
7. Simplification of event handling
Provide refactoring recommendations
", subagent_type="Code Simplifier")

### Phase 5.1: UI/UX Review

#### 1. Loading States
```html
<!-- ✅ GOOD: Comprehensive loading states -->
@if (loading()) {
  <div class="grid gap-4">
    @for (i of [1,2,3]; track i) {
      <app-skeleton-card />
    }
  </div>
} @else if (error()) {
  <app-error-state 
    [message]="errorMessage()"
    (retry)="loadData()">
  </app-error-state>
} @else if (isEmpty()) {
  <app-empty-state
    icon="folder_open"
    title="No fields found"
    description="Create your first field to get started">
    <button mat-raised-button color="primary" (click)="createField()">
      Create Field
    </button>
  </app-empty-state>
} @else {
  <!-- Data display -->
}
```

#### 2. Responsive Design
```scss
// ✅ GOOD: Mobile-first responsive
.field-grid {
  display: grid;
  gap: 1rem;
  grid-template-columns: 1fr;
  
  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }
  
  @media (min-width: 1024px) {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

#### 3. Form Validation & Feedback
```typescript
// ✅ GOOD: User-friendly validation
fieldName = new FormControl('', [
  Validators.required,
  Validators.minLength(3),
  CommonValidators.noSpecialCharacters()
], {
  updateOn: 'blur' // Better UX
});

getFieldError(): string {
  if (this.fieldName.hasError('required')) {
    return 'Field name is required';
  }
  if (this.fieldName.hasError('minlength')) {
    return 'Field name must be at least 3 characters';
  }
  if (this.fieldName.hasError('noSpecialCharacters')) {
    return 'Field name cannot contain special characters';
  }
  return '';
}
```

## 🎨 Design System Review

### Material 3 Compliance
- [ ] Uses Material Design components correctly
- [ ] Follows elevation and shadow guidelines
- [ ] Implements proper spacing (8px grid)
- [ ] Uses theme colors via CSS variables
- [ ] Respects motion principles (300ms ease-in-out)

### Component Consistency
- [ ] Follows established patterns in codebase
- [ ] Reuses existing shared components
- [ ] Maintains visual hierarchy
- [ ] Consistent icon usage
- [ ] Proper typography scale

## 🧪 Testing Review

### Unit Tests
```typescript
// Check for:
- Component initialization tests
- User interaction tests
- Signal state changes
- Form validation
- Error handling
```

### Accessibility Tests
```typescript
// Verify:
it('should be keyboard navigable', () => {
  const compiled = fixture.nativeElement;
  const button = compiled.querySelector('button');
  
  button.focus();
  expect(document.activeElement).toBe(button);
  
  const event = new KeyboardEvent('keydown', { key: 'Enter' });
  button.dispatchEvent(event);
  
  expect(component.onClick).toHaveBeenCalled();
});
```

## 📊 Performance Metrics

### Lighthouse Audit
```bash
# Run Lighthouse CI
npm run lighthouse -- --url=http://localhost:4200/fields
```

Target metrics:
- Performance: > 90
- Accessibility: 100
- Best Practices: > 95
- SEO: > 90

### Bundle Analysis
```bash
# Analyze bundle size
npm run build -- --stats-json
npx webpack-bundle-analyzer dist/stats.json
```

### Phase 6: Final Comprehensive Assessment

I'll invoke the general-purpose agent for this analysis.

@Task(description="general-purpose analysis", prompt="Conduct final testing verification for $ARGUMENTS:
1. Cross-browser compatibility testing
2. Mobile device testing checklist
3. Integration test coverage
4. E2E test scenarios
5. Visual regression test requirements
6. Performance budget compliance
7. Error boundary implementation
8. Production build verification
Generate testing compliance report
", subagent_type="general-purpose")

## 📝 Frontend Developer-Led Review Output

### Consolidated Expert Reports

```markdown
# UI Code Review: [Component/Feature Name]

## Expert Assessment Summary

### Frontend Developer Findings (PRIMARY)
- **Framework Compliance**: [Score/10]
- **TypeScript Quality**: [Excellent/Good/Needs Work]
- **Performance Impact**: [Measurements and analysis]
- **Modern Patterns**: [Adoption level]
- **Test Coverage**: [Percentage with gaps identified]
- **Critical Issues**: [Framework-specific problems]
- **Improvement Priority**: [Ordered list with examples]

### UX Reviewer Findings
- **Accessibility Score**: [A/B/C/D/F]
- **WCAG Compliance**: [Full/Partial/None]
- **Mobile Usability**: [Excellent/Good/Poor]
- **User Experience**: [Key improvements needed]

### Security Reviewer Findings
- **Security Risk**: [Low/Medium/High/Critical]
- **Vulnerabilities**: [Count and severity]
- **Compliance Status**: [Pass/Fail]
- **Mitigations Required**: [Specific fixes]

### Code Reviewer Validation
- **Code Quality**: [Validation of Frontend Developer findings]
- **Pattern Consistency**: [Score]
- **Maintainability**: [Assessment]
- **Documentation**: [Complete/Partial/Missing]

## Executive Summary
- **Overall Score**: [Frontend Developer weighted heavily]
- **Production Ready**: [Yes/No with Frontend Developer's conditions]
- **Required Actions**: [Frontend Developer's prioritized list]
- **Technical Debt**: [Identified by Frontend Developer]
```

### Detailed Findings
```markdown
**Issue**: Missing error boundary
**Severity**: Medium
**Location**: `field-list.component.ts`
**Current**: No error handling for failed API calls
**Suggested**: Add proper error state with retry action
**Impact**: Users see blank screen on errors
```

## 🚀 Modern UI Patterns Checklist

- [ ] **Signals**: All state managed with signals
- [ ] **Standalone**: Components are standalone
- [ ] **Control Flow**: New @if/@for syntax used
- [ ] **Accessibility**: WCAG 2.1 AA compliant
- [ ] **Performance**: OnPush + trackBy used
- [ ] **Responsive**: Mobile-first design
- [ ] **Testing**: > 80% coverage
- [ ] **TypeScript**: Strict typing, no `any`
- [ ] **Design System**: Material 3 compliance

## Final Review Checklist

- [ ] Accessibility standards met (WCAG 2.1 AA)
- [ ] Performance optimized (OnPush, signals, lazy loading)
- [ ] User experience polished (loading, error, empty states)
- [ ] Angular 19 patterns followed
- [ ] Design system consistency maintained
- [ ] Memory leaks prevented
- [ ] Bundle size acceptable
- [ ] Tests comprehensive
- [ ] Documentation complete

## Agent-Prioritized Recommendations

### Critical (Block Merge) - By Agent
**UX Reviewer**:
- Fix color contrast violations
- Add missing ARIA labels
- Implement keyboard navigation

**Security Reviewer**:
- Sanitize user inputs
- Fix XSS vulnerabilities
- Secure API calls

### High Priority (Before Production)
**Code Reviewer**:
- Add missing tests (target 80%)
- Fix memory leaks
- Implement proper error boundaries

**Tech Lead**:
- Optimize bundle size
- Implement lazy loading
- Add performance monitoring

### Medium Priority (Next Sprint)
**Code Simplifier**:
- Refactor complex components
- Extract reusable patterns
- Consolidate duplicate logic

### Low Priority (Backlog)
- Enhanced animations
- Additional features
- Documentation updates

## Frontend Developer-Led Review Benefits

1. **Framework Expertise**: Frontend Developer catches subtle Angular/TypeScript issues
2. **Modern Patterns**: Ensures latest best practices (signals, standalone components)
3. **Performance Focus**: Identifies optimization opportunities others miss
4. **Accurate Severity**: Frontend Developer correctly prioritizes issues
5. **Practical Solutions**: Provides working code examples, not just criticism
6. **Faster Reviews**: Expert knowledge reduces review time by 40%

### Why Frontend Developer Leadership Matters in Reviews

- **Deep Knowledge**: 15+ years of experience spots anti-patterns instantly
- **Framework Updates**: Knows the latest Angular 20 features and patterns
- **Real-World Context**: Understands production implications
- **Tool Expertise**: Familiar with build tools, bundlers, and dev environment
- **Teaching Approach**: Explains why something is wrong and how to fix it

The parallel support from UX and Security reviewers ensures comprehensive coverage while the Frontend Developer's expertise drives actionable technical improvements.

Remember: **A code review led by the Frontend Developer agent is like having a senior frontend architect on your team. Their specialized knowledge ensures not just compliance, but excellence in modern frontend development.**