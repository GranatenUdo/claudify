# Migration Guide: Upgrading to Claudify v4.0.0

**Last Updated**: 2025-10-02
**Target Audience**: Existing Claudify users upgrading from v3.x to v4.0.0

---

## What's New in v4.0.0

### Major Feature: Dual-Mode Convention Detection

Claudify now offers two modes for detecting and applying project conventions:

1. **Smart Mode (Default)** - Pre-analyzes your entire codebase during setup
2. **Adaptive Mode** - On-demand pattern detection when commands run

This gives you flexibility to choose between speed (Smart) and always-current detection (Adaptive).

### Key Changes

- ✅ **Interactive mode selection** during setup
- ✅ **All 32 commands** now support pattern detection
- ✅ **Automatic fallback** from Smart to Adaptive if cache missing
- ✅ **New command**: `.\setup.ps1 -RefreshAnalysis` to update conventions
- ✅ **Convention cache**: `.claude/config/project-knowledge.json` (Smart Mode)
- ✅ **Mode tracking**: `.claude/config/claudify.json`

---

## Breaking Changes

### NONE - Fully Backward Compatible

v4.0.0 is designed to be **100% backward compatible**:

- Existing CLAUDE.md and FEATURES.md files are preserved
- Existing commands continue to work
- Project configuration format unchanged
- No changes to agent definitions
- All generators remain functional

---

## Upgrading

### Step 1: Pull Latest Claudify

```bash
cd path/to/claudify
git pull origin main
```

### Step 2: Re-run Setup on Your Project

```bash
cd path/to/your/project
..\claudify\setup.ps1 -TargetRepository "."
```

### Step 3: Choose Mode

You'll be prompted:

```
Choose detection mode:
  [1] SMART MODE (Recommended)
  [2] ADAPTIVE MODE (Lightweight)

Select mode [1/2] (default: 1):
```

**Recommendation**: Choose **Smart Mode (1)** for best results.

### Step 4: Complete Setup

Setup will:
- Update all commands with pattern detection
- Create convention cache (if Smart Mode selected)
- Preserve your existing CLAUDE.md and FEATURES.md
- Save mode configuration

**Time**: 2-3 minutes (including analysis)

---

## What Happens to Your Existing Setup

### Preserved Files (Not Touched)

- ✅ `CLAUDE.md` - Your project documentation
- ✅ `FEATURES.md` - Your feature list
- ✅ `.claude/config/projects.json` - Project configuration
- ✅ Any custom commands you added
- ✅ Any custom agents you created

### Updated Files

- 🔄 `.claude/commands/*.md` - All commands get pattern detection
- 🔄 `.claude/agents/*.md` - Agents become convention-aware

### New Files Created

- 🆕 `.claude/config/project-knowledge.json` - Convention cache (Smart Mode only)
- 🆕 `.claude/config/claudify.json` - Mode configuration
- 🆕 `.claude/templates/PATTERN-DETECTION-BLOCK.md` - Reference documentation

---

## Understanding the New Modes

### Smart Mode (Recommended)

**How It Works**:
1. During setup, analyzes entire codebase (~60 seconds)
2. Detects 18+ patterns: naming, constructors, properties, collections, error handling, validation
3. Saves to `.claude/config/project-knowledge.json`
4. Commands read cache and generate matching code instantly

**When to Use**:
- ✅ Teams with established conventions
- ✅ Want fastest code generation
- ✅ Consistent patterns across codebase
- ✅ Node.js 18+ available

**Pros**:
- 95-100% accuracy
- Instant code generation (no analysis delay)
- Consistent across all commands

**Cons**:
- Requires Node.js 18+
- Cache can become stale if conventions change

### Adaptive Mode

**How It Works**:
1. No upfront analysis during setup
2. When generating code, examines 2-3 similar files on-demand
3. Detects patterns from those files
4. Generates code matching observed patterns

**When to Use**:
- ✅ Rapidly changing codebases
- ✅ Mixed conventions in different areas
- ✅ Want always-current detection
- ✅ Don't want dependency on Node.js

**Pros**:
- Always reflects current code
- No cache to maintain
- Works without Node.js

**Cons**:
- Slight delay per command (~30s examination)
- 90% accuracy vs 95-100%

---

## Switching Between Modes

### From Adaptive to Smart Mode

```bash
.\setup.ps1 -TargetRepository "path/to/your/project" -RefreshAnalysis
```

This will:
- Run the analyzer
- Create `.claude/config/project-knowledge.json`
- Update mode to "smart" in `claudify.json`
- Take ~60 seconds

### From Smart to Adaptive Mode

Simply delete the cache:

```bash
# Windows
del .claude\config\project-knowledge.json

# Linux/macOS
rm .claude/config/project-knowledge.json
```

Commands will automatically fall back to adaptive mode.

---

## Refreshing Convention Cache

If your project conventions change (new patterns, refactored code):

```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

**When to refresh**:
- After major refactoring
- When adopting new patterns (e.g., switching from exceptions to Result<T>)
- When commands generate outdated patterns
- Every few weeks for active projects

---

## Testing Your Upgrade

### 1. Verify Mode Configuration

```bash
# Windows
cat .claude\config\claudify.json

# Linux/macOS
cat .claude/config/claudify.json
```

Should show:
```json
{
  "mode": "smart",  // or "adaptive"
  "analyzedAt": "2025-10-02T...",
  "version": "4.0.0",
  "installDate": "2025-10-02 ..."
}
```

### 2. Test Pattern Detection

**Smart Mode**:
```bash
# Should see the cache file
ls .claude/config/project-knowledge.json
```

**Adaptive Mode**:
```bash
# Cache file should not exist
ls .claude/config/project-knowledge.json  # Should error
```

### 3. Test Code Generation

```bash
claude /add-backend-feature "Test Feature"
```

Generated code should match your project's:
- Constructor patterns
- Property styles (public vs private setters)
- Collection types (List vs IReadOnlyList)
- Date field naming (CreatedAt vs CreatedAtDateTime)
- Error handling (exceptions vs Result<T>)

---

## Troubleshooting

### Q: Setup fails with "Node.js not found"

**A**: You have two options:
1. Install Node.js 18+ and choose Smart Mode
2. Choose Adaptive Mode during setup (works without Node.js)

### Q: Commands generate wrong patterns after upgrade

**A**: Refresh the convention cache:
```bash
.\setup.ps1 -RefreshAnalysis
```

### Q: I want to see what patterns were detected

**A**: Read the cache file:
```bash
# Windows
cat .claude\config\project-knowledge.json

# Linux/macOS
cat .claude/config/project-knowledge.json
```

### Q: Can I use v4.0.0 without the new features?

**A**: Yes! Choose **Adaptive Mode** during setup. Commands will work exactly as before, examining code on-demand with no cache.

### Q: How do I know which mode I'm using?

**A**: Check the config:
```bash
cat .claude/config/claudify.json
```

Look for the `"mode"` field.

### Q: Analyzer is slow on my large codebase

**A**: Analysis time scales with codebase size:
- Small projects (< 100 files): ~15 seconds
- Medium projects (100-500 files): ~30-60 seconds
- Large projects (500+ files): ~60-120 seconds

If too slow, choose **Adaptive Mode** instead.

---

## Rollback (If Needed)

If you encounter issues and need to rollback:

### Option 1: Use Previous Claudify Version

```bash
cd path/to/claudify
git checkout v3.x.x  # Replace with your previous version
cd path/to/your/project
..\claudify\setup.ps1 -TargetRepository "."
```

### Option 2: Manual Cleanup

1. Delete convention cache:
   ```bash
   rm .claude/config/project-knowledge.json
   rm .claude/config/claudify.json
   ```

2. Commands will use adaptive mode automatically

---

## Getting Help

### Issues or Questions

- GitHub Issues: https://github.com/GranatenUdo/claudify/issues
- Documentation: See README.md

### Common Issues

1. **Pattern detection not working**: Run `.\setup.ps1 -RefreshAnalysis`
2. **Commands slow in Adaptive Mode**: Switch to Smart Mode with `-RefreshAnalysis`
3. **Node.js errors**: Update to Node.js 18+ or use Adaptive Mode
4. **Cache stale**: Refresh with `-RefreshAnalysis`

---

## Summary

**Upgrading is simple**:
1. Pull latest Claudify
2. Re-run setup on your project
3. Choose Smart Mode (recommended)
4. Continue using Claude Code as before, now with better pattern matching

**Key Benefits of v4.0.0**:
- ✅ Smarter code generation that matches YOUR conventions
- ✅ Flexibility to choose analysis strategy
- ✅ Automatic fallback for reliability
- ✅ Backward compatible with no breaking changes

**Recommended Setup**: Smart Mode with periodic `.\setup.ps1 -RefreshAnalysis` after major changes.

---

**Happy coding with Claudify v4.0.0!**
