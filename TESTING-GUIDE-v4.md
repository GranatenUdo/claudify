# Testing Guide: Claudify v4.0.0 Dual-Mode System

**Purpose**: Comprehensive testing protocol for validating the dual-mode convention detection system
**Target**: QA, developers, and contributors testing Claudify v4.0.0

---

## Testing Prerequisites

### Required
- PowerShell 7+
- .NET 8 or 9 SDK
- Angular 17-19 project
- Node.js 18+ (for Smart Mode testing)
- Claude Code CLI installed

### Test Projects Needed
- **Simple Project**: Basic .NET/Angular with simple patterns
- **Complex Project**: DDD architecture with rich domain models
- **Legacy Project**: Mixed conventions, technical debt

---

## Test Suite 1: Setup & Mode Selection

### Test 1.1: Smart Mode Setup
```bash
# Start fresh
cd test-project
rm -rf .claude .claudify

# Run setup
..\claudify\setup.ps1 -TargetRepository "."

# When prompted:
# - Choose Comprehensive installation
# - Select Mode: [1] SMART MODE
# - Confirm detected projects
```

**Expected Results**:
- ✅ Mode selection prompt appears
- ✅ Analyzer runs (~60 seconds)
- ✅ Creates `.claude/config/project-knowledge.json`
- ✅ Creates `.claude/config/claudify.json` with `"mode": "smart"`
- ✅ Success message displayed

**Verify**:
```bash
# Check mode
cat .claude/config/claudify.json  # Should show "mode": "smart"

# Check cache exists
ls .claude/config/project-knowledge.json  # Should exist

# Check cache content
cat .claude/config/project-knowledge.json  # Should contain detected patterns
```

### Test 1.2: Adaptive Mode Setup
```bash
# Start fresh
cd test-project-2
rm -rf .claude .claudify

# Run setup
..\claudify\setup.ps1 -TargetRepository "."

# When prompted:
# - Choose Comprehensive installation
# - Select Mode: [2] ADAPTIVE MODE
# - Confirm detected projects
```

**Expected Results**:
- ✅ Mode selection prompt appears
- ✅ Analyzer SKIPPED (no 60-second wait)
- ✅ NO `.claude/config/project-knowledge.json` created
- ✅ Creates `.claude/config/claudify.json` with `"mode": "adaptive"`
- ✅ Message: "Commands will examine code on-demand"

**Verify**:
```bash
# Check mode
cat .claude/config/claudify.json  # Should show "mode": "adaptive"

# Check cache does NOT exist
ls .claude/config/project-knowledge.json  # Should NOT exist
```

### Test 1.3: Refresh Analysis Command
```bash
# From test-project with Smart Mode already set up
..\claudify\setup.ps1 -TargetRepository "." -RefreshAnalysis

# Expected: Quick execution, updates cache
```

**Expected Results**:
- ✅ Runs analyzer only (no full setup)
- ✅ Updates `.claude/config/project-knowledge.json`
- ✅ Updates `analyzedAt` timestamp in `claudify.json`
- ✅ Completes in ~60 seconds

---

## Test Suite 2: Code Generation - Smart Mode

### Test 2.1: Backend Feature Generation (Smart Mode)
```bash
claude /add-backend-feature "Order Management"
```

**Observe During Execution**:
- Command should check for project-knowledge.json (found)
- Should NOT examine files with Glob/Read
- Should generate code quickly (<30 seconds)

**Verify Generated Code**:
1. Check constructor pattern matches project:
   - If project uses parameterless: Generated should too
   - If project uses factory methods: Generated should too

2. Check property patterns:
   - If project uses `{ get; set; }`: Generated should match
   - If project uses `{ get; private set; }`: Generated should match

3. Check collection types:
   - If project uses `List<T>`: Generated should use `List<T>`
   - If project uses `IReadOnlyList<T>`: Generated should match

4. Check date field naming:
   - If project uses `CreatedAtDateTime`: Generated should match
   - If project uses `CreatedAt`: Generated should match

**Pass Criteria**: Generated code matches project conventions 95%+

### Test 2.2: Frontend Feature Generation (Smart Mode)
```bash
claude /add-frontend-feature "User Profile Component"
```

**Verify Generated Code**:
1. Component naming matches project style
2. Signal vs Observable usage matches project
3. Template syntax matches project conventions
4. Styling approach matches project (CSS/SCSS/etc.)

**Pass Criteria**: Generated code matches project conventions 95%+

---

## Test Suite 3: Code Generation - Adaptive Mode

### Test 3.1: Backend Feature Generation (Adaptive Mode)
```bash
# In project with Adaptive Mode
claude /add-backend-feature "Product Management"
```

**Observe During Execution**:
- Command should check for project-knowledge.json (not found)
- Should use Glob to find entity files
- Should Read 2-3 entity files
- Should document detected patterns
- Generation takes longer (~60-90 seconds total)

**Verify Generated Code**:
Same checks as Test 2.1, but expect ~90% accuracy

**Pass Criteria**: Generated code matches project conventions 85-90%

### Test 3.2: Frontend Feature Generation (Adaptive Mode)
```bash
claude /add-frontend-feature "Dashboard Widget"
```

**Observe**: Similar to 3.1 but for frontend files

**Pass Criteria**: Generated code matches project conventions 85-90%

---

## Test Suite 4: Fallback Behavior

### Test 4.1: Cache Missing Fallback
```bash
# In Smart Mode project, delete cache
rm .claude/config/project-knowledge.json

# Generate feature
claude /add-backend-feature "Inventory Management"
```

**Expected**:
- ✅ Command detects missing cache
- ✅ Automatically falls back to adaptive mode
- ✅ Examines files on-demand
- ✅ Generates code successfully

**Pass Criteria**: Command works without cache, uses adaptive detection

### Test 4.2: Stale Cache Handling
```bash
# Refactor project to use different patterns
# Then generate feature WITHOUT refreshing cache
claude /add-backend-feature "Shipping Management"
```

**Expected**:
- Uses cached (stale) patterns
- Generated code may not match new patterns

**Then refresh**:
```bash
.\setup.ps1 -RefreshAnalysis
claude /add-backend-feature "Shipping Management v2"
```

**Expected**:
- ✅ Generated code now matches NEW patterns

**Pass Criteria**: Refresh updates cache, subsequent generation uses new patterns

---

## Test Suite 5: Command Coverage

Test that pattern detection works across all command types:

### Test 5.1: Fix Commands
```bash
claude /fix-backend-bug "NullReferenceException in OrderService"
```

**Expected**: Fixes maintain project conventions

### Test 5.2: Update Commands
```bash
claude /update-backend-feature "Add sorting to Order list"
```

**Expected**: Updates maintain project conventions

### Test 5.3: Review Commands
```bash
claude /review-backend-code "OrderService"
```

**Expected**: Reviews consider project conventions when making recommendations

### Test 5.4: Refactor Commands
```bash
claude /refactor-code "Simplify OrderService constructor"
```

**Expected**: Refactoring maintains project patterns

---

## Test Suite 6: Edge Cases

### Test 6.1: Empty Project (No Existing Code)
```bash
# In brand new project with no entities/services
claude /add-backend-feature "First Feature"
```

**Expected**:
- ✅ No files found to examine
- ✅ Uses simple production-ready defaults:
  - Public parameterless constructors
  - Public `{ get; set; }` properties
  - `List<T>` collections
  - `CreatedAt`/`UpdatedAt` date fields
  - Exception-based error handling

### Test 6.2: Mixed Conventions Project
```bash
# In project with inconsistent patterns
claude /add-backend-feature "Consistency Test"
```

**Expected**:
- Detects most common patterns
- Uses majority pattern for generation

### Test 6.3: Node.js Not Installed (Smart Mode Selected)
```bash
# Uninstall Node.js or make unavailable
..\claudify\setup.ps1 -TargetRepository "."
# Select Smart Mode
```

**Expected**:
- ✅ Graceful failure message
- ✅ Suggests installing Node.js OR choosing Adaptive Mode
- ✅ Setup can be retried

---

## Test Suite 7: Cross-Platform

### Test 7.1: Windows
Run all tests on Windows with PowerShell 7+

### Test 7.2: Linux
Run all tests on Linux with PowerShell 7+

### Test 7.3: macOS
Run all tests on macOS with PowerShell 7+

**Pass Criteria**: All tests pass on all platforms

---

## Test Suite 8: Performance

### Test 8.1: Smart Mode Analysis Speed
```bash
# Time the analyzer
time ..\claudify\setup.ps1 -RefreshAnalysis
```

**Expected**:
- Small project (<100 files): <30 seconds
- Medium project (100-500 files): 30-60 seconds
- Large project (500+ files): 60-120 seconds

### Test 8.2: Adaptive Mode Generation Speed
```bash
# Time code generation
time claude /add-backend-feature "Performance Test"
```

**Expected**:
- With cache (Smart): <30 seconds
- Without cache (Adaptive): 60-90 seconds

---

## Test Suite 9: Backward Compatibility

### Test 9.1: Upgrade from v3.x
```bash
# Set up v3.x first
git checkout v3.x.x
.\setup.ps1 -TargetRepository "test-project"

# Verify v3 works
claude /add-backend-feature "v3 Feature"

# Upgrade to v4
git checkout main
.\setup.ps1 -TargetRepository "test-project"

# Verify v4 works
claude /add-backend-feature "v4 Feature"
```

**Expected**:
- ✅ No errors during upgrade
- ✅ Existing CLAUDE.md and FEATURES.md preserved
- ✅ Commands work in v4
- ✅ New mode selection offered

### Test 9.2: Existing Project Configuration Preserved
After upgrade, verify:
```bash
# Projects still configured
cat .claude/config/projects.json  # Should be unchanged

# Commands still have project names
cat .claude/commands/add-backend-feature.md  # Should have {{WebProject}} replaced
```

---

## Reporting Test Results

### Pass Criteria

**Critical (Must Pass)**:
- ✅ Setup completes without errors in both modes
- ✅ Commands generate code in both modes
- ✅ Generated code matches project conventions (85%+ Adaptive, 95%+ Smart)
- ✅ Fallback works when cache missing
- ✅ Refresh analysis updates cache correctly
- ✅ Backward compatible with v3.x

**High Priority (Should Pass)**:
- ✅ Cross-platform compatibility
- ✅ Performance within expected ranges
- ✅ All command types support pattern detection
- ✅ Edge cases handled gracefully

**Medium Priority (Nice to Have)**:
- ✅ Review commands provide convention-aware recommendations
- ✅ Mixed convention projects handled reasonably
- ✅ Error messages clear and actionable

### Bug Report Template

```markdown
## Bug Report

**Test**: [Test number and name]
**Mode**: Smart / Adaptive
**Platform**: Windows / Linux / macOS
**Project Type**: Simple / Complex / Legacy

**Steps to Reproduce**:
1.
2.
3.

**Expected Result**:


**Actual Result**:


**Logs/Output**:


**Additional Context**:

```

---

## Automated Testing (Future)

For CI/CD integration, create automated tests:

```powershell
# Example automated test
$testProject = "E:\test-projects\simple-project"

# Test 1: Smart Mode Setup
.\setup.ps1 -TargetRepository $testProject
if (-not (Test-Path "$testProject\.claude\config\project-knowledge.json")) {
    throw "Test Failed: project-knowledge.json not created"
}

# Test 2: Code Generation
# (Requires Claude Code API/CLI automation)

Write-Host "All tests passed!" -ForegroundColor Green
```

---

## Summary Checklist

Before releasing v4.0.0, ensure:

- [ ] All Test Suite 1 tests pass (Setup)
- [ ] All Test Suite 2 tests pass (Smart Mode generation)
- [ ] All Test Suite 3 tests pass (Adaptive Mode generation)
- [ ] All Test Suite 4 tests pass (Fallback)
- [ ] All Test Suite 5 tests pass (Command coverage)
- [ ] All Test Suite 6 tests pass (Edge cases)
- [ ] All Test Suite 7 tests pass (Cross-platform)
- [ ] All Test Suite 8 tests pass (Performance)
- [ ] All Test Suite 9 tests pass (Backward compatibility)
- [ ] Documentation reviewed and accurate
- [ ] Migration guide tested on real upgrade
- [ ] Known issues documented

**Test Completion**: ____ / 9 Test Suites Passed

---

**Good luck testing Claudify v4.0.0!**
