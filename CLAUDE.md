# CLAUDE.md - Claudify System Documentation

## CONTEXT
**System**: Claudify - Claude Code Setup System
**Version**: 4.0.0
**Purpose**: Specialized commands and agents for .NET/Angular development with Claude Code
**Architecture**: Convention-aware, context-driven command system

## SYSTEM ARCHITECTURE

### Two-Phase Implementation

1. **Setup Phase** (setup.ps1)
   - Copies command files to `.claude/commands/`
   - Copies agent files to `.claude/agents/`
   - Optional: Runs convention analyzer (Smart Mode)
   - Creates `.claude/config/` directory structure

2. **Runtime Phase** (Claude Code)
   - Commands execute in current working directory context
   - Agents operate with security-restricted tool access
   - Convention detection (Smart Mode cache or Adaptive Mode on-demand)
   - Commands use pure bash operations (no hardcoded paths)

### How It Works

**Key Principle**: Commands are path-agnostic and work in whatever directory Claude Code is launched from.

**User Workflow**:
```bash
# Navigate to target project
cd src/MyProject.Web

# Launch Claude Code
claude

# Commands work in current directory
> /add-frontend-feature "Dashboard"
# Creates feature in MyProject.Web
```

**No configuration needed**. Claude Code provides directory context; commands use it.

---

## CONVENTION DETECTION

### Smart Mode (Pre-Analysis)
- Setup runs TypeScript analyzer once (~60 seconds)
- Analyzes entire codebase for 18+ pattern categories
- Caches results to `.claude/config/project-knowledge.json`
- Commands read cache and apply patterns instantly
- 95-100% accuracy for established projects
- Run `.\setup.ps1 -RefreshAnalysis` to update cache

### Adaptive Mode (On-Demand)
- No upfront analysis
- Commands examine 2-3 similar files when generating code
- Detects patterns on-demand from observed code
- Always reflects current codebase state
- 90% accuracy
- Best for rapidly changing projects

### Pattern Categories Detected
1. **Naming Conventions**: Classes, methods, properties, fields, date fields
2. **Constructors**: Parameterless, parameterized, factory methods, private
3. **Properties**: Public set, init-only, readonly, private set
4. **Collections**: List<T>, IReadOnlyList<T>, IEnumerable<T>, arrays
5. **Error Handling**: Exceptions, Result<T> pattern, custom types
6. **Validation**: Constructor validation, FluentValidation, DataAnnotations
7. **Testing**: Framework (xUnit, NUnit, MSTest), patterns (AAA, BDD), mocking
8. **State Management**: Signals, Observables, Services, Stores
9. **API Patterns**: RESTful conventions, response formats, versioning
10. **Architecture**: Layering, dependency injection, repository patterns

### Fallback Strategy
Commands automatically use Adaptive Mode if:
- Cache doesn't exist (Adaptive Mode was chosen)
- Cache is corrupted or missing
- Node.js was not available during setup

---

## COMMAND ARCHITECTURE

### Pure, Context-Aware Commands

Commands do NOT contain:
- ❌ Hardcoded project paths
- ❌ `cd` prefixes to change directories
- ❌ Template variables (`{{WebProject}}`, etc.)
- ❌ Project-specific configuration

Commands DO contain:
- ✅ Pure bash commands (`npm run build`, `dotnet test`)
- ✅ Convention detection logic (Smart or Adaptive)
- ✅ Agent task definitions with clear prompts
- ✅ Allowed tool restrictions

### Example Command Structure

```markdown
---
description: Create Angular 19 frontend feature
allowed-tools: [Task, Bash, Read, Write, Edit]
---

# 🎨 Frontend Feature: $ARGUMENTS

## Phase 1: Implementation

@Task(
  description="Implement feature",
  prompt="Implement '$ARGUMENTS':

  Check .claude/config/project-knowledge.json for conventions.

  If exists: Apply cached patterns
  If not: Examine 2-3 similar .component.ts files

  Create Angular 19 component following detected patterns.",
  subagent_type="frontend-implementation-expert"
)

## Phase 2: Validation

@Bash(command="npm run build", description="Build")
@Bash(command="npm test", description="Test")
```

**Note**: Commands work in current directory - no `cd` needed.

---

## SECURITY CONFIGURATION

### Agent Tool Restrictions

Each agent operates with minimal required permissions:

| Agent | Allowed Tools | Purpose |
|-------|--------------|---------|
| code-reviewer | Read, Edit, MultiEdit, Grep, Glob | Code quality analysis |
| security-vulnerability-scanner | Read, Grep, Glob, WebSearch | Security scanning |
| tech-lead-engineer | Read, Write, Edit, Grep, Glob, TodoWrite, Bash | Full implementation |
| frontend-implementation-expert | Read, Write, Edit, MultiEdit, Grep, Glob | UI development |
| ux-design-expert | Read, Write, Glob | Design work |
| test-quality-analyzer | Read, Grep, Glob | Test analysis |

### Security Principles
- **Least Privilege**: Agents get only tools they need
- **No Hardcoding**: No paths, secrets, or configuration in commands
- **Audit Trail**: All operations visible in Claude Code
- **Local Storage**: All config in `.claude/config/` (gitignored)

---

## MULTI-PROJECT WORKFLOW

### Working on Different Projects

**Switch with `cd`**:
```bash
# Frontend work
cd src/Admin.Web
claude
> /add-frontend-feature "Dashboard"

# Backend work
cd src/Admin.Api
claude
> /add-backend-feature "Orders"
```

### Parallel Development with Git Worktrees

**Official Claude Code recommendation**:
```bash
# Create worktrees
git worktree add ../repo-admin main
git worktree add ../repo-public main

# Terminal 1: Admin
cd ../repo-admin/src/Admin.Web
claude
> /add-frontend-feature "Admin Panel"

# Terminal 2: Public
cd ../repo-public/src/Public.Web
claude
> /add-frontend-feature "Landing Page"
```

Each Claude session has independent context and history.

---

## CONFIGURATION FILES

### `.claude/config/project-knowledge.json` (Smart Mode only)

Contains detected conventions:
```json
{
  "naming": {
    "classes": "PascalCase",
    "methods": "PascalCase",
    "properties": "PascalCase",
    "fields": "_camelCase",
    "dateFields": "CreatedAt"
  },
  "patterns": {
    "entityConstructors": "parameterless",
    "collectionProperties": "List<T>",
    "errorHandling": "exceptions",
    "validation": "FluentValidation"
  },
  "testing": {
    "framework": "xUnit",
    "pattern": "AAA",
    "mockingLibrary": "Moq"
  }
}
```

**Generated by**: TypeScript analyzer during setup
**Refreshed by**: `.\setup.ps1 -RefreshAnalysis`

### `.claude/config/claudify.json`

Tracks mode configuration:
```json
{
  "mode": "smart",
  "configuredAt": "2025-10-02 15:30:00"
}
```

---

## BEST PRACTICES

### For Users

1. **Navigate before launching**: `cd` to project, then run `claude`
2. **Use git worktrees**: For parallel multi-project work
3. **Refresh analysis**: After major convention changes
4. **Choose Smart Mode**: For established projects
5. **Choose Adaptive Mode**: For rapidly evolving codebases

### For Command Authors

1. **Never hardcode paths**: Commands must be path-agnostic
2. **Use pure bash commands**: `npm run build` not `cd X && npm run build`
3. **Include convention detection**: Check cache, fallback to examination
4. **Restrict agent tools**: Minimal required permissions only
5. **Test in multiple directories**: Verify context-awareness

### For Agent Authors

1. **Don't assume paths**: Discover structure from current directory
2. **Respect conventions**: Apply detected patterns consistently
3. **Work in context**: Use current working directory
4. **Document operations**: Clear descriptions of what you're doing
5. **Handle fallbacks**: Graceful defaults when patterns unclear

---

## TROUBLESHOOTING

### Commands Generate Wrong Patterns

**Cause**: Stale convention cache
**Solution**: `.\setup.ps1 -RefreshAnalysis`

### Commands Don't Find Files

**Cause**: Claude Code launched from wrong directory
**Solution**: `cd` to project directory before `claude`

### Analyzer Fails

**Cause**: Node.js not available or project structure unexpected
**Solution**: Commands automatically fall back to Adaptive Mode

### Want to Switch Modes

**Smart → Adaptive**: Delete `.claude/config/project-knowledge.json`
**Adaptive → Smart**: Run `.\setup.ps1 -RefreshAnalysis`

---

## VERSIONING

### Current Version: 4.0.0

**Breaking Changes from v3.x**:
- Removed template system (`{{WebProject}}`, etc.)
- Removed project detection from setup
- Commands are now pure and path-agnostic
- Work in current directory context only
- Setup just copies files (no configuration)

**Migration from v3.x to v4.0.0**:
1. Re-run `setup.ps1` on your repository
2. Delete old `.claude/config/projects.json` (if exists from v3.x)
3. Commands now work in directory context
4. Use `cd` to switch projects

### Version Compatibility
- Supports .NET 8/9
- Supports Angular 17-19
- Works with standard project structures
- Cross-platform (Windows, Linux, macOS)

---

## PERFORMANCE

### Setup Performance
- File copy: < 5 seconds
- Smart Mode analysis: ~60 seconds (one-time)
- Adaptive Mode: 0 seconds (no analysis)

### Command Performance
- Smart Mode: Instant (reads cache)
- Adaptive Mode: +2-3 seconds (examines files on-demand)
- Both modes: Acceptable for development workflow

---

## QUALITY ASSURANCE

### Automatic Behaviors
- Commands examine conventions (Smart cache or Adaptive scan)
- Fallback to Adaptive if cache unavailable
- Work in current directory context
- Pure bash commands (no path manipulation)

### Success Indicators
```
✓ Setup copies 40+ commands
✓ Setup copies 30+ agents
✓ Convention analyzer runs (Smart Mode)
✓ Commands work without path configuration
✓ Multi-project switching with cd
```

---

**Claudify 4.0.0** - Pure, context-aware commands for Claude Code.
