---
description: Fix frontend build and test failures using specialized Frontend Developer agent with incremental verification after each fix
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "TypeScript errors in field components" or leave empty for full diagnosis)
---

# 🧠 Fix Frontend Build & Tests: $ARGUMENTS



**Directive**: Fix frontend build and test failures using expert frontend knowledge, focusing on framework-specific patterns, TypeScript intricacies, and modern build tooling.

## Phase 1: Parallel Expert Analysis

<think about optimal parallelization with frontend-focused expertise>

I'll invoke specialized agents simultaneously, with the Frontend Developer leading the technical analysis:

I'll have the Frontend Developer agent Frontend technical analysis.
I'll have the Visual Designer agent UX impact assessment.
I'll have the general-purpose agent Security assessment.

### Synthesis of Expert Findings

Based on the parallel analyses, I'll prioritize fixes using the Frontend Developer's expertise as the primary guide.

## Phase 2: Parallel Diagnostic Data Collection

<think about gathering all diagnostic data simultaneously>

I'll collect comprehensive diagnostic information in parallel:

Running command: `cd src/PTA.VineyardManagement.Web && npm run build 2>&1`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch 2>&1 | head -100`
Reading file: src/PTA.VineyardManagement.Web/tsconfig.json
Reading file: src/PTA.VineyardManagement.Web/angular.json
Reading file: src/PTA.VineyardManagement.Web/package.json
Searching for pattern: ERROR TS[0-9]+:|error TS[0-9]+:
Running command: `cd src/PTA.VineyardManagement.Web && npx tsc --noEmit --listFiles | grep -E '(error|ERROR)' | head -20`

## Phase 3: Iterative Fix Implementation with Verification

<think deeply about implementing fixes incrementally with verification after each logical operation>

### TypeScript Issues - Fix and Verify

#### Step 1: Type Inference Fixes
Based on the Frontend Developer's analysis, I'll fix TypeScript issues systematically:

```typescript
// Example: Signal type inference fix
// ❌ WRONG: Letting TypeScript struggle with inference
const data = signal([]); // Type 'never[]' issues

// ✅ CORRECT: Explicit typing for signals
const data = signal<FieldData[]>([]);

// ❌ WRONG: Improper discriminated union handling
if (state.status === 'success') {
  console.log(state.data); // TS error: Property 'data' does not exist
}

// ✅ CORRECT: Type narrowing with proper guards
if (state.status === 'success' && 'data' in state) {
  console.log(state.data); // TypeScript understands the narrowing
}
```

### Verification After TypeScript Fixes
Running command: `cd src/PTA.VineyardManagement.Web && npx tsc --noEmit`
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`

<think about whether TypeScript fixes resolved the issues before proceeding>

#### Step 2: Angular Pattern Updates
If TypeScript verification passes, proceed with Angular-specific fixes:

```typescript
// ❌ WRONG: Old patterns that break with signals
Using Component tool for this operation.
class OldComponent {
  data = this.service.getData(); // Observable pattern
}

// ✅ CORRECT: Modern signal patterns
Using Component tool for this operation. }}` // Signal invocation
})
class ModernComponent {
  readonly data = toSignal(this.service.getData(), { initialValue: [] });
}
```

### Verification After Angular Updates
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testPathPattern='component' | head -50`

<think about build and test results before continuing with configuration changes>

#### Step 3: Build Configuration Fixes
If previous verifications pass, update build configurations:

```json
// tsconfig.json path mapping for clean imports
{
  "compilerOptions": {
    "paths": {
      "@app/*": ["src/app/*"],
      "@shared/*": ["src/app/shared/*"],
      "@features/*": ["src/app/features/*"]
    }
  }
}
```

### Verification After Configuration Updates
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --maxWorkers=2 | head -100`

## Phase 4: Test Infrastructure Fixes with Incremental Verification

<think about modern testing patterns and Angular-specific test setup>

#### Step 1: Test Module Configuration Fixes
```typescript
// ✅ CORRECT: Proper test module setup with signals
beforeEach(() => {
  TestBed.configureTestingModule({
    imports: [CommonModule, ReactiveFormsModule],
    providers: [
      { provide: FieldService, useValue: mockFieldService },
      provideRouter([]),
      provideHttpClient(),
      provideHttpClientTesting()
    ]
  });
  
  // Component with signals needs proper initialization
  fixture = TestBed.createComponent(FieldComponent);
  component = fixture.componentInstance;
  fixture.detectChanges(); // Initial change detection
});
```

### Verification After Test Setup Fixes
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testNamePattern='setup|configuration' | head -50`

#### Step 2: Signal Testing Patterns
If test setup verification passes, fix signal-specific test patterns:

```typescript
// ✅ CORRECT: Testing signals
it('should update data when signal changes', () => {
  const testData = [{ id: 1, name: 'Test Field' }];
  
  TestBed.runInInjectionContext(() => {
    component.data.set(testData);
  });
  
  fixture.detectChanges();
  
  expect(fixture.nativeElement.textContent).toContain('Test Field');
});
```

### Verification After Signal Test Fixes
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testPathPattern='signal|reactive' | head -50`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --coverage --coverageReporters=text-summary`

## Phase 5: Final Comprehensive Verification

<think about ensuring all fixes work together before declaring success>

After all incremental fixes and verifications, run final comprehensive checks:

### Final Build and Test Suite
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --code-coverage`

### Quality Checks
Running command: `cd src/PTA.VineyardManagement.Web && npm run lint`
Running command: `cd src/PTA.VineyardManagement.Web && npx tsc --noEmit`

### Performance Verification
Running command: `cd src/PTA.VineyardManagement.Web && npm run analyze`

<think about whether all verifications passed and if any additional fixes are needed>

## Phase 6: Performance & Quality Validation

### Frontend Developer Final Review
I'll have the Frontend Developer agent Final technical validation.

### Parallel Quality Checks
I'll have the general-purpose agent Code quality review.

## Success Criteria

### Build Success
- ✅ `npm run build` exits with code 0
- ✅ No TypeScript errors
- ✅ Bundle sizes acceptable (<250KB main)
- ✅ All assets generated correctly

### Test Success
- ✅ 100% test pass rate
- ✅ >80% code coverage maintained
- ✅ No flaky tests
- ✅ <3 minute total test time

### Quality Metrics
- ✅ No linting errors
- ✅ No accessibility violations
- ✅ Performance budgets met
- ✅ Type safety maintained

## Fix Summary Template

```markdown
# Frontend Build/Test Fix Summary

## Expert Analysis Results

### Frontend Developer Findings
- **Root Causes**: [Technical issues identified]
- **Framework Issues**: [Angular-specific problems]
- **TypeScript Problems**: [Type system issues]
- **Build Config**: [Configuration problems]

### UX Reviewer Impact
- **Component Architecture**: [Impact assessment]
- **User Experience**: [UX implications]
- **Performance**: [Loading/runtime impact]

### Security Assessment
- **Vulnerabilities**: [Security issues found]
- **Risk Level**: [Critical/High/Medium/Low]
- **Mitigations**: [Security fixes applied]

## Fixes Applied
1. **TypeScript Fixes**: [Specific corrections]
2. **Angular Updates**: [Pattern modernizations]
3. **Test Repairs**: [Test infrastructure fixes]
4. **Build Optimizations**: [Configuration improvements]

## Verification Results
- Build: [Success/Failure]
- Tests: [X/Y passing]
- Coverage: [X%]
- Bundle Size: [XKB]
- Type Safety: [Verified]

## Prevention Strategy
- [ ] Updated coding standards
- [ ] Enhanced pre-commit hooks
- [ ] Improved CI/CD checks
- [ ] Documentation updates
```

## Benefits of Incremental Verification Approach

1. **Early Detection**: Issues caught immediately after each fix category
2. **Focused Debugging**: Know exactly which change caused any new issues
3. **Progressive Confidence**: Build assurance as each verification passes
4. **Efficient Rollback**: Can revert specific changes if verification fails
5. **Clear Progress**: Visible advancement through fix categories
6. **Reduced Rework**: Avoid compounding errors across multiple changes
7. **Better Success Rate**: Higher probability of complete resolution

## Frontend Developer-Led Benefits

1. **Expert Knowledge**: 15+ years of frontend expertise applied directly
2. **Framework Mastery**: Deep Angular/TypeScript knowledge for accurate fixes
3. **Modern Patterns**: Uses latest signals, standalone components correctly
4. **Performance Focus**: Bundle optimization and runtime performance
5. **Test Excellence**: Proper test setup for modern Angular
6. **Targeted Fixes**: Knows exactly what to fix based on error patterns

Remember: The combination of Frontend Developer expertise and incremental verification ensures both accurate fixes and validated results. Each logical fix category is immediately tested, preventing cascading failures and ensuring a working codebase at each step.