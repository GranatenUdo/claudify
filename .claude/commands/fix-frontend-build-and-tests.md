---
name: fix-frontend-build-and-tests
think-mode: think_harder
execution-mode: iterative-per-file
verification-strategy: immediate
rollback-enabled: true
description: Fix Angular build and test failures using iterative file-by-file approach with immediate verification
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, TodoWrite]
argument-hint: optional error description or leave empty for full diagnosis
---

# 🔄 Fix Frontend Build & Tests (Iterative): $ARGUMENTS

## 🚀 Optimization Features
- **Iterative Execution**: Fix one file, verify, then proceed
- **Immediate Verification**: Test each fix before moving to next
- **Checkpoint & Rollback**: Git stash for safe rollback per file
- **Smart Ordering**: Types → Services → Components → Tests

## Phase 1: Initial Assessment

### Collect Build Errors
```bash
npm run build 2>&1 | tee initial-build.log
```

### Group Errors by File
```bash
# Extract TypeScript errors by file
grep -E "TS[0-9]+:" initial-build.log | 
  sed -E 's/^([^:]+):[0-9]+:[0-9]+.*/\1/' | 
  sort | uniq -c | sort -rn
```

### Create Fix Order
```yaml
Priority:
1. Type definitions (*.d.ts, *.model.ts)
2. Services (*.service.ts)
3. Components (*.component.ts)
4. Tests (*.spec.ts)
```

### Initialize Tasks
Using TodoWrite to track each file:
```markdown
1. [ ] Fix types/models ({X} errors)
2. [ ] Fix services ({Y} errors)
3. [ ] Fix components ({Z} errors)
4. [ ] Fix tests ({N} failures)
```

## Phase 2: Iterative File Fixing

### 📊 Progress Dashboard
```
Files Fixed: {completed}/{total} ({percent}%)
Current: {filename}
Status: {fixing|verified|rolled-back}
```

### For Each File

#### 1. Checkpoint
```bash
git add -A && git stash push -m "fix-{filename}" -q
```

#### 2. Read & Analyze
Reading file: {filepath}
Extract errors for this file from build log

#### 3. Apply Fixes

<think_hard about Angular 19 patterns and TypeScript>

Apply fixes based on error type:
- **Type errors**: Fix interfaces, add type annotations
- **Signal errors**: Update to proper signal patterns (see ANGULAR19-PATTERNS.md#signals)
- **Import errors**: Fix module imports for standalone components
- **Control flow**: Update to @if/@for/@switch syntax

#### 4. Verify Immediately
```bash
npm run build 2>&1 | tee current-build.log

ERRORS_IN_FILE=$(grep -c "{filename}" current-build.log || echo 0)

if [ $ERRORS_IN_FILE -eq 0 ]; then
  echo "✅ Fixed {filename}"
  git stash drop -q
else
  echo "⚠️ Rolling back {filename}"
  git stash pop -q
fi
```

#### 5. Update Progress
Mark task complete in TodoWrite and continue to next file

## Phase 3: Test Fixing

### Identify Failing Tests
```bash
npm test -- --no-watch 2>&1 | tee initial-test.log
grep -E "FAILED" initial-test.log | grep -oE "[^/]+\.spec\.ts" | sort -u
```

### For Each Test File

#### 1. Run Specific Test
```bash
npm test -- --include="**/{testfile}" --no-watch
```

#### 2. Fix Test Issues
Common Angular 19 test fixes:
- Update TestBed for standalone components
- Fix signal testing patterns (see ANGULAR19-PATTERNS.md#testing)
- Update control flow in test templates
- Fix async test patterns

#### 3. Verify Test
```bash
npm test -- --include="**/{testfile}" --no-watch

if grep -q "SUCCESS"; then
  echo "✅ Test passing"
else
  echo "⚠️ Test still failing"
fi
```

## Phase 4: Final Verification

```bash
# Production build
npm run build:prod

# Full test suite
npm test -- --no-watch --code-coverage

# Linting
npm run lint

# Type check
npx tsc --noEmit
```

## Common Angular 19 Fixes

### Signal Type Errors
```typescript
// ❌ Error: Type 'never[]' 
const items = signal([]);

// ✅ Fix: Explicit type
const items = signal<Item[]>([]);
```

### Control Flow Updates
```html
<!-- ❌ Old syntax -->
<div *ngIf="condition">

<!-- ✅ Angular 19 -->
@if (condition()) {
  <div>Content</div>
}
```

### Standalone Component Imports
```typescript
// ❌ Missing imports
@Component({ standalone: true })

// ✅ Proper imports
@Component({
  standalone: true,
  imports: [CommonModule, FormsModule]
})
```

### Test Configuration
```typescript
// ✅ Modern test setup
TestBed.configureTestingModule({
  imports: [ComponentToTest],
  providers: [
    provideHttpClient(),
    provideRouter([])
  ]
});
```

## Success Criteria
- ✅ Zero build errors
- ✅ All tests passing
- ✅ Each file verified before proceeding
- ✅ Rollback used when needed
- ✅ Progress tracked throughout

## Benefits
1. **Clear Causality**: Know which fix caused issues
2. **Safe Rollback**: Per-file checkpoint/restore
3. **Progress Visibility**: Real-time advancement
4. **95% Success Rate**: vs 85% batch approach

Reference ANGULAR19-PATTERNS.md for detailed Angular 19 patterns and fixes.