---
name: fix-backend-build-and-tests
model: opus
think-mode: think_harder
execution-mode: iterative-per-file
verification-strategy: immediate
rollback-enabled: true
description: Fix backend build and test failures using iterative file-by-file approach with immediate verification
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Edit, MultiEdit, Write, WebFetch, WebSearch, TodoWrite]
argument-hint: optional specific error or issue description (e.g., "dependency injection errors in services" or leave empty for full diagnosis)
---

# 🔄 Fix Backend Build & Tests (Iterative): $ARGUMENTS

## 🚀 Optimization Features

- **Iterative Execution**: Fix one file, verify immediately, then proceed
- **Immediate Verification**: Test each fix before moving to next file
- **Rollback Capability**: Checkpoint before each file for safe rollback
- **Progress Tracking**: Real-time visibility of fix advancement
- **Smart Ordering**: Fix files in dependency order to minimize cascading

## Phase 1: Initial Assessment & Error Grouping

### Step 1: Collect All Build Errors
Running command: `dotnet build --no-incremental 2>&1 | tee initial-build-output.log`

### Step 2: Parse and Group Errors by File

<think_harder about error dependencies and optimal fix order>

I'll analyze the errors and group them by file, identifying dependencies:

```bash
# Extract unique files with errors
grep -E "\.cs\([0-9]+,[0-9]+\):" initial-build-output.log | 
  sed -E 's/^([^(]+)\([0-9]+,[0-9]+\):.*/\1/' | 
  sort | uniq -c | sort -rn
```

### Step 3: Create Fix Order Based on Dependencies

```yaml
Fix Order Strategy:
1. Domain models first (no dependencies)
2. Value objects second  
3. Services third (depend on domain)
4. Controllers last (depend on services)

Within each tier:
- Fix files with fewer errors first (quick wins)
- Fix files that many others depend on
```

### Step 4: Initialize Task List

Using TodoWrite to create fix tasks:
```markdown
Tasks:
1. [ ] Fix Domain/Field.cs (3 errors)
2. [ ] Fix Domain/Crop.cs (2 errors)
3. [ ] Fix Services/FieldService.cs (5 errors)
4. [ ] Fix Controllers/FieldController.cs (2 errors)
5. [ ] Run final build verification
6. [ ] Fix failing tests iteratively
7. [ ] Run final test verification
```

## Phase 2: Iterative File-by-File Build Fixing

### 📊 Progress Dashboard
```
╔════════════════════════════════════════════════════╗
║ Build Fix Progress                                 ║
╠════════════════════════════════════════════════════╣
║ Files to Fix: {count}                             ║
║ Files Completed: 0/{count} (0%)                   ║
║ Current File: Starting...                          ║
╚════════════════════════════════════════════════════╝
```

### File Fix Loop

<think_harder about maintaining architectural integrity while fixing each file>

For each file in the fix order:

#### 📁 File {N}/{Total}: {filename}

##### Step 1: Create Checkpoint
```bash
echo "📍 Creating checkpoint before fixing {filename}"
git add -A && git stash push -m "checkpoint-before-{filename}" --quiet
```

##### Step 2: Read File and Analyze Errors
Reading file: {filepath}

Extracting errors for this file:
```bash
grep "{filename}" initial-build-output.log | head -20
```

Error Analysis:
- Error 1: [Type and description]
- Error 2: [Type and description]

##### Step 3: Apply Fixes to This File Only

<think_hard about correct fixes that maintain domain integrity>

Using MultiEdit to fix all errors in {filename}:
```csharp
// Fixes specific to this file
// Maintaining architectural patterns
// Respecting domain rules
```

##### Step 4: Immediate Build Verification

**🔄 CRITICAL VERIFICATION GATE**

```bash
echo "🔨 Verifying fixes for {filename}..."
dotnet build --no-incremental 2>&1 | tee current-build.log

# Check if this file still has errors
if grep -q "{filename}" current-build.log; then
  echo "❌ File still has errors after fix"
  ERRORS_IN_FILE=$(grep -c "{filename}" current-build.log)
else
  echo "✅ No errors in {filename}"
  ERRORS_IN_FILE=0
fi

# Check if total error count increased
PREV_ERRORS=$(grep -c ": error" initial-build-output.log)
CURR_ERRORS=$(grep -c ": error" current-build.log)

if [ $CURR_ERRORS -gt $PREV_ERRORS ]; then
  echo "⚠️ Fix caused NEW errors ($CURR_ERRORS > $PREV_ERRORS)"
fi
```

##### Step 5: Decision Gate

```yaml
Decision Logic:
if ERRORS_IN_FILE == 0 and CURR_ERRORS <= PREV_ERRORS:
  status: "✅ Fix successful"
  action: 
    - Update TodoWrite task as completed
    - Update progress dashboard
    - Keep changes and proceed
    
elif ERRORS_IN_FILE > 0:
  status: "⚠️ Fix incomplete"
  action:
    - Analyze why fix didn't work
    - Try alternative approach
    - Reapply and verify again
    
elif CURR_ERRORS > PREV_ERRORS:
  status: "❌ Fix caused problems"
  action:
    - Rollback immediately
    - Analyze what went wrong
    - Skip file or try different approach
```

##### Step 6: Handle Verification Result

###### If Successful:
```bash
echo "✅ Successfully fixed {filename}"
# Update baseline for next iteration
cp current-build.log initial-build-output.log
# Drop checkpoint as we're keeping changes
git stash drop -q
```

Using TodoWrite to mark task completed

###### If Failed - Rollback:
```bash
echo "❌ Rolling back changes to {filename}"
git stash pop -q
# Consider alternative fix or skip file
```

##### Step 7: Update Progress

```
╔════════════════════════════════════════════════════╗
║ Build Fix Progress                                 ║
╠════════════════════════════════════════════════════╣
║ Files to Fix: {total}                             ║
║ Files Completed: {completed}/{total} ({percent}%) ║
║ Current File: {next_file}                         ║
║                                                    ║
║ ✅ {file1} (3 errors fixed)                       ║
║ ✅ {file2} (2 errors fixed)                       ║
║ 🔄 {current} (fixing...)                          ║
║ ⏸️ {pending} (waiting...)                         ║
╚════════════════════════════════════════════════════╝
```

### Continue to Next File
[Loop repeats for each file]

## Phase 3: Final Build Verification

After all files processed:

```bash
echo "🎯 Running final build verification..."
dotnet clean
dotnet build --configuration Release 2>&1 | tee final-build.log

if [ $? -eq 0 ]; then
  echo "✅ BUILD SUCCESS: All compilation errors resolved!"
else
  echo "⚠️ Some errors remain - may need manual intervention"
  grep ": error" final-build.log | head -10
fi
```

## Phase 4: Iterative Test Fixing

### Step 1: Identify Failing Tests

```bash
echo "🧪 Running tests to identify failures..."
dotnet test --no-build 2>&1 | tee initial-test-output.log

# Extract failing test classes
grep -E "Failed|Error" initial-test-output.log | 
  grep -oE "[A-Za-z]+Tests" | 
  sort | uniq > failing-test-classes.txt
```

### Step 2: Create Test Fix Task List

Using TodoWrite to add test fix tasks:
```markdown
Test Fix Tasks:
1. [ ] Fix FieldServiceTests (3 failures)
2. [ ] Fix CropServiceTests (2 failures)
3. [ ] Fix IntegrationTests (5 failures)
```

### Test Fix Loop

For each test class with failures:

#### 🧪 Test Class {N}/{Total}: {TestClassName}

##### Step 1: Run Only This Test Class
```bash
echo "🔍 Running tests for {TestClassName}..."
dotnet test --no-build --filter "FullyQualifiedName~{TestClassName}" 2>&1 | 
  tee {TestClassName}-before.log
```

##### Step 2: Analyze Test Failures
Reading test file: tests/{TestClassName}.cs

Failure Analysis:
- Test 1: [Failure reason]
- Test 2: [Failure reason]

##### Step 3: Create Test Fix Checkpoint
```bash
git add -A && git stash push -m "checkpoint-test-{TestClassName}" -q
```

##### Step 4: Apply Test Fixes

<think_hard about test intentions and correct implementation>

Using MultiEdit to fix test issues:
```csharp
// Fix test setup
// Fix assertions
// Fix mocks
```

##### Step 5: Immediate Test Verification

**🔄 CRITICAL TEST VERIFICATION**

```bash
echo "🧪 Verifying test fixes for {TestClassName}..."
dotnet test --no-build --filter "FullyQualifiedName~{TestClassName}" 2>&1 | 
  tee {TestClassName}-after.log

# Check results
if grep -q "Passed.*Failed: 0" {TestClassName}-after.log; then
  echo "✅ All tests in {TestClassName} now passing!"
  TEST_RESULT="SUCCESS"
else
  FAILURES=$(grep -c "Failed" {TestClassName}-after.log)
  echo "❌ Still have $FAILURES failing tests"
  TEST_RESULT="FAILED"
fi
```

##### Step 6: Handle Test Result

###### If Tests Pass:
```bash
echo "✅ Successfully fixed {TestClassName}"
git stash drop -q
```

Using TodoWrite to mark test task completed

###### If Tests Still Fail:
```bash
echo "⚠️ Tests still failing, trying alternative approach..."
# Either retry with different fix or skip for manual review
```

### Continue to Next Test Class
[Loop repeats for each failing test class]

## Phase 5: Final Verification

### Comprehensive Final Check
```bash
echo "🏁 Running final comprehensive verification..."

# Clean build check
dotnet clean
dotnet build --configuration Release

# Full test suite
dotnet test --configuration Release --no-build

# Code analysis
dotnet build /p:RunAnalyzers=true /p:TreatWarningsAsErrors=true

echo "✅ All build and test issues resolved!"
```

## Success Criteria

### Build Success
- ✅ Zero compilation errors
- ✅ Zero warnings (or acceptable warnings documented)
- ✅ All projects build successfully
- ✅ Release configuration builds

### Test Success  
- ✅ 100% test pass rate
- ✅ No flaky tests (verified with 3x run)
- ✅ Integration tests pass
- ✅ Test execution time reasonable

## Benefits of This Approach

1. **Clear Causality**: Know exactly which fix caused any issues
2. **Safe Rollback**: Can undo problematic changes immediately
3. **Progress Visibility**: See advancement file by file
4. **Early Detection**: Problems caught immediately
5. **Reduced Debugging**: Issues isolated to single file
6. **Higher Success Rate**: More methodical and reliable

## Summary Report Template

```markdown
# Build & Test Fix Summary

## Execution Statistics
- Files with Errors: {initial_count}
- Files Fixed: {fixed_count}
- Files Skipped: {skipped_count}
- Test Classes Fixed: {test_count}
- Total Time: {duration}

## Fix Details
[Automated list of all fixes applied]

## Rollbacks Required
[List any fixes that were rolled back]

## Manual Intervention Needed
[List any issues requiring human review]
```