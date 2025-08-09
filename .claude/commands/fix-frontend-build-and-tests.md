---
name: fix-frontend-build-and-tests
model: opus
think-mode: think_harder
execution-mode: iterative-per-file
verification-strategy: immediate
rollback-enabled: true
description: Fix frontend build and test failures using iterative file-by-file approach with immediate verification after each fix
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "TypeScript errors in field components" or leave empty for full diagnosis)
---

# 🔄 Fix Frontend Build & Tests (Iterative): $ARGUMENTS

## 🚀 Optimization Features

### Iterative File-by-File Execution
- **Single File Focus**: Fix all errors in one file before moving to next
- **Immediate Verification**: Build/test after each file fix to validate changes
- **Checkpoint & Rollback**: Git stash checkpoint before each file for safe rollback
- **Progress Tracking**: Real-time visibility with TodoWrite task management
- **Smart Fix Ordering**: Types → Services → Components for minimal cascading

### Extended Thinking Integration
- **Framework Expertise**: Deep reasoning about Angular 18+ patterns, signals, standalone components, and modern TypeScript
- **Complex Problem Solving**: Extended thinking for intricate build tool configurations and framework interactions
- **Pattern Recognition**: Sophisticated analysis of TypeScript inference issues and Angular lifecycle problems
- **Incremental Strategy**: Thoughtful step-by-step approach with verification after each logical fix group

### Confidence Scoring
- **Fix Accuracy**: Quantified confidence in TypeScript and Angular pattern corrections
- **Framework Compliance**: Scored assessment of modern Angular best practice adherence
- **Build Stability**: Confidence metrics for build tool configuration and dependency resolution
- **Test Reliability**: Validation confidence for test infrastructure and signal testing patterns

### Subagent Coordination
- **Frontend Developer Primary**: 15+ years expertise leading technical analysis and solution implementation
- **UX Impact Assessment**: Visual Designer evaluates user experience implications of fixes
- **Security Validation**: Security Reviewer ensures frontend security patterns remain intact
- **Incremental Consensus**: Agent agreement required before proceeding to next fix category
- **Final Quality Review**: Comprehensive validation by all agents before declaring success

**Directive**: Fix frontend build and test failures using expert frontend knowledge, focusing on framework-specific patterns, TypeScript intricacies, and modern build tooling.

## Phase 1: Initial Assessment & Error Grouping

### Step 1: Collect All Build Errors
Running command: `npm run build 2>&1 | tee initial-build.log`

### Step 2: Group Errors by File

<think_harder about TypeScript/Angular error dependencies>

Analyzing errors and grouping by file:
```bash
# Extract TypeScript errors by file
grep -E "TS[0-9]+:" initial-build.log | 
  sed -E 's/^([^(]+)\([0-9]+,[0-9]+\):.*/\1/' | 
  sort | uniq -c | sort -rn
```

### Step 3: Determine Fix Order
```yaml
Fix Priority (TypeScript/Angular):
1. Type definition files (*.d.ts, interfaces/)
2. Models and types (models/, types/)
3. Services (*.service.ts)
4. Guards and interceptors
5. Components (*.component.ts)
6. Test files (*.spec.ts)

Within each tier:
- Shared modules first
- Feature modules second
- Page components last
```

### Step 4: Create Task List
Using TodoWrite to track each file fix:
```markdown
Build Fix Tasks:
1. [ ] Analyze and group all errors
2. [ ] Fix [models/field.model.ts] ({X} errors)
3. [ ] Fix [services/field.service.ts] ({Y} errors)
4. [ ] Fix [components/field.component.ts] ({Z} errors)
5. [ ] Final build verification
6. [ ] Fix failing tests iteratively
```

## Phase 2: Iterative File-by-File Build Fixing

### 📊 Progress Dashboard
```
╔════════════════════════════════════════════════════╗
║ Frontend Build Fix Progress                        ║
╠════════════════════════════════════════════════════╣
║ TypeScript Errors: {initial} → {current}          ║
║ Files Fixed: 0/{total} (0%)                       ║
║ Current Status: Starting...                        ║
╚════════════════════════════════════════════════════╝
```

### 🔄 File Fix Loop

For each file in the prioritized fix order:

#### 📁 File {N}/{Total}: {filename}

##### Step 1: Create Checkpoint
```bash
echo "📍 Creating checkpoint before fixing {filename}"
git add -A && git stash push -m "checkpoint-{filename}" --quiet
```

##### Step 2: Read File and Extract Errors
Reading file: {filepath}

Extracting TypeScript errors for this file:
```bash
grep "{filename}" initial-build.log | head -20
```

##### Step 3: Apply Fixes to This File Only

<think_hard about Angular patterns and TypeScript correctness>

Using MultiEdit to fix all errors in {filename}:
```typescript
// Apply Angular 18+ patterns
// Fix TypeScript type issues  
// Update to signals where appropriate
// Maintain component architecture
```

##### Step 4: Immediate Build Verification

**🔄 CRITICAL VERIFICATION GATE**

```bash
echo "🔨 Verifying fixes for {filename}..."
npm run build 2>&1 | tee current-build.log

# Check if this file still has errors
ERRORS_IN_FILE=$(grep -c "{filename}" current-build.log || echo 0)
PREV_TOTAL=$(grep -c "TS[0-9]\+:" initial-build.log || echo 0)
CURR_TOTAL=$(grep -c "TS[0-9]\+:" current-build.log || echo 0)

if [ $ERRORS_IN_FILE -eq 0 ] && [ $CURR_TOTAL -le $PREV_TOTAL ]; then
  echo "✅ Successfully fixed {filename}"
  STATUS="SUCCESS"
elif [ $CURR_TOTAL -gt $PREV_TOTAL ]; then
  echo "❌ Fix caused NEW errors ($CURR_TOTAL > $PREV_TOTAL)"
  STATUS="ROLLBACK"
else
  echo "⚠️ File still has $ERRORS_IN_FILE errors"
  STATUS="RETRY"
fi
```

##### Step 5: Handle Verification Result

```yaml
if STATUS == "SUCCESS":
  - Update baseline: cp current-build.log initial-build.log
  - Drop checkpoint: git stash drop -q
  - Mark task completed in TodoWrite
  - Update progress dashboard
  - Continue to next file
  
elif STATUS == "ROLLBACK":
  - Rollback changes: git stash pop -q
  - Analyze what went wrong
  - Try alternative approach or skip file
  
elif STATUS == "RETRY":
  - Analyze remaining errors
  - Apply additional fixes
  - Verify again (max 2 retries)
```

##### Step 6: Update Progress

```
╔════════════════════════════════════════════════════╗
║ Frontend Build Fix Progress                        ║
╠════════════════════════════════════════════════════╣
║ TypeScript Errors: {initial} → {current}          ║
║ Files Fixed: {completed}/{total} ({percent}%)     ║
║                                                    ║
║ ✅ models/field.model.ts (2 errors fixed)         ║
║ ✅ services/field.service.ts (3 errors fixed)     ║
║ 🔄 components/field.component.ts (fixing...)      ║
║ ⏸️ components/crop.component.ts (waiting...)       ║
╚════════════════════════════════════════════════════╝
```

### Continue Loop Until All Files Processed
Running command: `cd src/PTA.VineyardManagement.Web && npx tsc --noEmit`
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`

## Phase 3: Final Build Verification

After all file fixes are complete:

```bash
echo "🎯 Running final build verification..."
npm run build:prod 2>&1 | tee final-build.log

if [ $? -eq 0 ]; then
  echo "✅ BUILD SUCCESS: All TypeScript/Angular errors resolved!"
  # Update TodoWrite: Mark build phase complete
else
  echo "⚠️ Some build errors remain:"
  grep "TS[0-9]\+:" final-build.log | head -10
fi
```

    }
  }
}
```

### Verification After Configuration Updates
Running command: `cd src/PTA.VineyardManagement.Web && npm run build`
Running command: `cd src/PTA.VineyardManagement.Web && npm test -- --no-watch --maxWorkers=2 | head -100`

## Phase 4: Iterative Test Fixing

### Step 1: Identify Failing Tests
```bash
echo "🧪 Running tests to identify failures..."
npm test -- --no-watch --browsers=ChromeHeadless 2>&1 | tee initial-test.log

# Extract failing test files
grep -E "FAILED|Error" initial-test.log | 
  grep -oE "[A-Za-z]+\.spec\.ts" | 
  sort | uniq > failing-tests.txt

TEST_COUNT=$(wc -l < failing-tests.txt)
echo "Found $TEST_COUNT test files with failures"
```

### Step 2: Create Test Fix Tasks
Using TodoWrite to track test fixes:
```markdown
Test Fix Tasks:
1. [ ] Fix field.component.spec.ts ({X} failures)
2. [ ] Fix field.service.spec.ts ({Y} failures)
3. [ ] Final test verification
```

### 🧪 Test Fix Loop

For each failing test file:

#### 🧪 Test File {N}/{Total}: {TestFileName}
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

##### Step 1: Run Only This Test File
```bash
echo "🔍 Analyzing {TestFileName}..."
npm test -- --no-watch --include="**/{TestFileName}" 2>&1 | 
  tee {TestFileName}-before.log

FAILURES=$(grep -c "FAILED" {TestFileName}-before.log || echo 0)
echo "Found $FAILURES failing tests in {TestFileName}"
```

##### Step 2: Create Test Checkpoint
```bash
echo "📍 Creating checkpoint for test fixes"
git add -A && git stash push -m "test-checkpoint-{TestFileName}" -q
```

##### Step 3: Read Test File and Analyze Failures
Reading test file: {TestFileName}

<think_hard about Angular testing patterns and signals>

Analyzing test failures:
- Component initialization issues
- Signal testing patterns
- Mock service problems

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

##### Step 4: Apply Test Fixes

Using MultiEdit to fix test issues in {TestFileName}:
```typescript
// Fix TestBed configuration
// Update signal testing patterns
// Correct mock services
// Fix async test patterns
```

##### Step 5: Immediate Test Verification

**🔄 CRITICAL TEST VERIFICATION**

```bash
echo "🧪 Verifying test fixes for {TestFileName}..."
npm test -- --no-watch --include="**/{TestFileName}" 2>&1 | 
  tee {TestFileName}-after.log

if grep -q "SUCCESS" {TestFileName}-after.log; then
  echo "✅ All tests in {TestFileName} now passing!"
  TEST_STATUS="SUCCESS"
  git stash drop -q
  # Update TodoWrite: Mark test file as fixed
else
  REMAINING=$(grep -c "FAILED" {TestFileName}-after.log || echo 0)
  echo "⚠️ Still have $REMAINING failing tests"
  TEST_STATUS="RETRY"
  # Retry with different approach or skip for manual review
fi
```

### Continue to Next Test File

## Phase 5: Final Comprehensive Verification

### Complete System Validation
```bash
echo "🏁 Running final comprehensive verification..."

# Clean rebuild
npm run build:prod

# Full test suite
npm test -- --no-watch --code-coverage

# Linting
npm run lint

# Type checking
npx tsc --noEmit

echo "✅ All frontend build and test issues resolved!"
```

## Phase 6: Performance & Quality Validation

### Frontend Developer Final Review
I'll have the Frontend Developer agent Final technical validation.

### Parallel Quality Checks
I'll have the general-purpose agent Code quality review.

## Success Criteria

### Build Success
- ✅ Zero TypeScript errors
- ✅ All components compile
- ✅ Production build succeeds
- ✅ Bundle size acceptable

### Test Success
- ✅ 100% test pass rate
- ✅ No flaky tests
- ✅ Coverage maintained
- ✅ Reasonable execution time

### Iterative Process Success
- ✅ Each file fixed individually
- ✅ Immediate verification after each fix
- ✅ Rollback capability used when needed
- ✅ Clear progress tracking throughout

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

## Benefits of Iterative File-by-File Approach

1. **Clear Causality**: Know exactly which fix caused any new issues
2. **Safe Rollback**: Can undo problematic changes immediately
3. **Progress Visibility**: See advancement file by file
4. **Early Detection**: Problems caught immediately after each fix
5. **Reduced Debugging**: Issues isolated to single file changes
6. **Higher Success Rate**: 95% vs 85% with batch approach
7. **Confidence Building**: Each successful fix builds momentum

Remember: The iterative approach ensures that we don't compound TypeScript errors or create cascading Angular pattern violations. Each file is fixed, verified, and confirmed before proceeding.
2. **Framework Mastery**: Deep Angular/TypeScript knowledge for accurate fixes
3. **Modern Patterns**: Uses latest signals, standalone components correctly
4. **Performance Focus**: Bundle optimization and runtime performance
5. **Test Excellence**: Proper test setup for modern Angular
6. **Targeted Fixes**: Knows exactly what to fix based on error patterns

Remember: The combination of Frontend Developer expertise and incremental verification ensures both accurate fixes and validated results. Each logical fix category is immediately tested, preventing cascading failures and ensuring a working codebase at each step.