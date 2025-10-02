# CLAUDE.md - Claudify System Documentation

## CONTEXT
**System**: Claudify - Claude Code Setup System
**Version**: 5.0.0
**Purpose**: Specialized commands and agents for .NET/Angular development with Claude Code
**Architecture**: Convention-aware, context-driven command system

## SYSTEM ARCHITECTURE

### Two-Phase Implementation

1. **Setup Phase** (setup.ps1)
   - Copies command files to `.claude/commands/`
   - Copies agent files to `.claude/agents/`

2. **Runtime Phase** (Claude Code)
   - Commands execute in current working directory context
   - Agents operate with security-restricted tool access
   - Dynamic convention detection (examines code at runtime)
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

### Dynamic Pattern Detection

Commands detect conventions by examining actual code at runtime:

1. **Find Similar Files**: Use Glob to locate 2-3 relevant files
2. **Read & Analyze**: Examine those files to detect patterns
3. **Apply Patterns**: Generate new code matching observations
4. **Fallback to Defaults**: Use sensible defaults if no files found

**Always current** - examines code state every time, no caching.

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

  Examine existing code to detect conventions:
  1. Use Glob to find 2-3 similar .component.ts files
  2. Read and detect patterns
  3. Apply observed patterns

  If no files found, discover from package.json and angular.json
  If still unclear, ask user for preferences

  Create Angular 19 component following detected/discovered patterns.",
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

## CONVENTION DETECTION

Commands detect patterns dynamically - no configuration files needed.

When commands generate code, they:
1. Use Glob to find similar existing files
2. Read and analyze patterns
3. Apply observed conventions
4. Use defaults if no files found

**No caching** - always examines current code state.

---

## BEST PRACTICES

### For Users

1. **Navigate before launching**: `cd` to project, then run `claude`
2. **Use git worktrees**: For parallel multi-project work
3. **Ensure example files exist**: Commands detect patterns from existing code

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

**Cause**: No similar files to examine, or files don't match expected patterns
**Solution**: Ensure you have existing code for commands to examine. Commands work best when similar code already exists.

### Commands Don't Find Files

**Cause**: Claude Code launched from wrong directory
**Solution**: `cd` to project directory before running `claude`. Verify with `pwd`.

---

## VERSIONING

### Current Version: 5.0.0

**Breaking Changes from v4.x**:
- Removed template system (`{{WebProject}}`, etc.)
- Removed project detection and configuration
- Commands are pure and path-agnostic
- Work in current directory context only
- Setup just copies files
- No caching - dynamic pattern detection only

**Migration from v4.x to v5.0.0**:
1. Re-run `setup.ps1` on your repository
2. Delete old config files (if exist): `.claude/config/projects.json`, `.claude/config/project-knowledge.json`
3. Navigate to project directory before using commands
4. Use `cd` to switch projects or git worktrees for parallel work

### Version Compatibility
- Supports .NET 8/9
- Supports Angular 17-19
- Works with standard project structures
- Cross-platform (Windows, Linux, macOS)

---

## PERFORMANCE

### Setup Performance
- File copy: < 5 seconds
- No analysis or configuration

### Command Performance
- Pattern detection: +2-3 seconds (examines files dynamically)
- Acceptable for development workflow
- Always current - no stale cache issues

---

## QUALITY ASSURANCE

### Automatic Behaviors
- Commands examine conventions dynamically at runtime
- Work in current directory context
- Pure bash commands (no path manipulation)
- No configuration or caching

### Success Indicators
```
✓ Setup copies 40+ commands
✓ Setup copies 30+ agents
✓ Commands work without configuration
✓ Multi-project switching with cd
✓ Dynamic pattern detection from code
```

---

**Claudify 5.0.0** - Pure, context-aware commands for Claude Code.
