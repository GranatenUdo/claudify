---
description: Fix frontend build and test failures using specialized Frontend Developer agent with incremental verification after each fix
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "TypeScript errors in field components" or leave empty for full diagnosis)
agent-dependencies: [Frontend Developer, UX Reviewer, Security Reviewer, Code Reviewer]
complexity: moderate
estimated-time: 15-20 minutes
category: quality
---

# 🧠 Fix Frontend Build & Tests: $ARGUMENTS

## OPUS 4 ACTIVATION - FRONTEND SPECIALIST MODE
<think harder about frontend-specific build failures, test issues, and their root causes using specialized frontend expertise>

**Directive**: Fix frontend build and test failures using expert frontend knowledge, focusing on framework-specific patterns, TypeScript intricacies, and modern build tooling.

## Phase 1: Parallel Expert Analysis

<think about optimal parallelization with frontend-focused expertise>

I'll invoke specialized agents simultaneously, with the Frontend Developer leading the technical analysis:

@Task(description="Frontend technical analysis", prompt="As an elite Frontend Developer, analyze build/test failures for '$ARGUMENTS':
1. **TypeScript Issues**
   - Type inference problems
   - Generic constraints violations
   - Discriminated union errors
   - Module resolution failures
   - Declaration file issues
2. **Angular-Specific Problems**
   - Signal usage errors
   - Change detection issues
   - Dependency injection failures
   - Template compilation errors
   - Standalone component problems
3. **Build Configuration**
   - angular.json misconfigurations
   - tsconfig.json path mapping
   - Webpack optimization issues
   - Bundle size problems
   - Source map generation
4. **Test Infrastructure**
   - Jest/Karma configuration
   - Test module setup
   - Mock service issues
   - Async test failures
   - Coverage configuration
5. **Performance Issues**
   - Bundle splitting problems
   - Tree shaking failures
   - Lazy loading errors
   - Preloading strategy issues
Provide expert diagnosis with specific fixes prioritized by impact", subagent_type="Frontend Developer")
@Task(description="UX impact assessment", prompt="Analyze UI/UX implications of build/test failures for '$ARGUMENTS':
1. Component architecture impact
2. Accessibility compliance breaks
3. Responsive design issues
4. User interaction failures
5. Visual regression risks
6. Design system violations
7. Loading performance impact
Provide UX-focused priorities", subagent_type="Visual Designer")
@Task(description="Security assessment", prompt="Review security implications of frontend failures for '$ARGUMENTS':
1. XSS vulnerability risks
2. Dependency vulnerabilities
3. Build-time secret exposure
4. CSP violations
5. Authentication flow breaks
6. Session handling issues
7. Input validation failures
Identify security-critical fixes", subagent_type="general-purpose")

### Synthesis of Expert Findings

Based on the parallel analyses, I'll prioritize fixes using the Frontend Developer's expertise as the primary guide.

## Phase 2: Parallel Diagnostic Data Collection

<think about gathering all diagnostic data simultaneously>

I'll collect comprehensive diagnostic information in parallel:

@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build 2>&1", description="Capture build output")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch 2>&1 | head -100", description="Capture test output")
@Read(file_path="src/PTA.VineyardManagement.Web/tsconfig.json")
@Read(file_path="src/PTA.VineyardManagement.Web/angular.json")
@Read(file_path="src/PTA.VineyardManagement.Web/package.json")
@Grep(pattern="ERROR TS[0-9]+:|error TS[0-9]+:", path="src/PTA.VineyardManagement.Web/", output_mode="content", head_limit=20)
@Bash(command="cd src/PTA.VineyardManagement.Web && npx tsc --noEmit --listFiles | grep -E '(error|ERROR)' | head -20", description="TypeScript diagnostics")

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
@Bash(command="cd src/PTA.VineyardManagement.Web && npx tsc --noEmit", description="Verify TypeScript fixes")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build", description="Quick build check after TS fixes")

<think about whether TypeScript fixes resolved the issues before proceeding>

#### Step 2: Angular Pattern Updates
If TypeScript verification passes, proceed with Angular-specific fixes:

```typescript
// ❌ WRONG: Old patterns that break with signals
@Component({
  template: `{{ data | async }}`
})
class OldComponent {
  data = this.service.getData(); // Observable pattern
}

// ✅ CORRECT: Modern signal patterns
@Component({
  template: `{{ data() }}` // Signal invocation
})
class ModernComponent {
  readonly data = toSignal(this.service.getData(), { initialValue: [] });
}
```

### Verification After Angular Updates
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build", description="Build after Angular pattern fixes")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testPathPattern='component' | head -50", description="Test component-related changes")

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
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build", description="Full build after config changes")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --maxWorkers=2 | head -100", description="Run subset of tests to verify config")

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
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testNamePattern='setup|configuration' | head -50", description="Verify test setup fixes")

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
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --testPathPattern='signal|reactive' | head -50", description="Verify signal-related test fixes")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --coverage --coverageReporters=text-summary", description="Check overall test health")

## Phase 5: Final Comprehensive Verification

<think about ensuring all fixes work together before declaring success>

After all incremental fixes and verifications, run final comprehensive checks:

### Final Build and Test Suite
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run build", description="Final build verification")
@Bash(command="cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --code-coverage", description="Full test suite with coverage")

### Quality Checks
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run lint", description="Linting compliance")
@Bash(command="cd src/PTA.VineyardManagement.Web && npx tsc --noEmit", description="Final TypeScript validation")

### Performance Verification
@Bash(command="cd src/PTA.VineyardManagement.Web && npm run analyze", description="Bundle size check")

<think about whether all verifications passed and if any additional fixes are needed>

## Phase 6: Performance & Quality Validation

### Frontend Developer Final Review
@Task(description="Final technical validation", prompt="As Frontend Developer, validate all fixes:
1. **Code Quality**
   - TypeScript best practices
   - Angular patterns compliance
   - Performance optimizations
   - Bundle size impact
2. **Test Quality**
   - Coverage adequacy
   - Test reliability
   - Mock appropriateness
   - Edge case handling
3. **Build Health**
   - Configuration correctness
   - Optimization settings
   - Development experience
   - CI/CD compatibility
4. **Long-term Maintainability**
   - Code clarity
   - Pattern consistency
   - Documentation
   - Upgrade path
Provide final assessment and any remaining optimizations", subagent_type="Frontend Developer")

### Parallel Quality Checks
@Task(description="Code quality review", prompt="Review the implemented fixes for:
1. Pattern consistency
2. Error handling completeness
3. Memory leak prevention
4. Code duplication
5. Complexity metrics
6. Documentation coverage
7. Test maintainability
Provide improvement suggestions", subagent_type="general-purpose")

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