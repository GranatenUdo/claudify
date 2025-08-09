# Claude Code Command Improvements for Opus 4

## Executive Summary
After extensive research on Claude Code command best practices for Opus 4, I've identified critical issues and improvement opportunities across all 33 commands in the repository.

## Critical Issues to Fix

### 1. Remove Non-Standard YAML Fields
**Issue**: Commands use unofficial fields that Claude Code doesn't recognize
**Impact**: These fields are ignored and may cause confusion

**Fields to remove from ALL commands:**
- `agent-dependencies` 
- `complexity`
- `estimated-time`
- `category`

**Official fields only:**
- `description` - Brief description of the command
- `allowed-tools` - Comma-separated list of tools (or `*` for all)
- `argument-hint` - Expected arguments for the command
- `model` - Optional model specification (opus/sonnet/haiku)

### 2. Fix Tool Usage Patterns
**Issue**: Commands use `@Tool()` syntax which doesn't work
**Impact**: Commands won't execute properly

**Current (WRONG):**
```markdown
@TodoWrite(todos=[{id: "1", content: "Task", status: "pending"}])
@Bash(command="echo 'Hello'", description="Say hello")
```

**Correct approach:**
```markdown
I'll now organize the tasks using TodoWrite:
[Describe what you're doing]

Let me check the current status:
[Use bash to check something]
```

Commands should guide Claude with natural language, not pseudo-function calls.

### 3. Simplify Extended Thinking References
**Issue**: Commands mention extended thinking configuration incorrectly
**Impact**: Confusion about how to enable extended thinking

**Solution**: 
- Remove all mentions of `max_thinking_tokens` from command content
- Extended thinking is configured via `.claude/settings.json` at project level
- Commands automatically benefit from this configuration

## Specific Command Fixes

### High Priority Commands

#### 1. `/init-claudify`
- Remove: `complexity`, `estimated-time`, `category` fields
- Fix: Replace all `@Tool()` patterns with natural language instructions
- Keep: Core functionality is good

#### 2. `/comprehensive-review`
- Remove: `agent-dependencies`, `complexity`, `estimated-time`, `category`
- Fix: The `@TodoWrite` syntax throughout the file
- Improve: Simplify parallel execution instructions

#### 3. `/do-extensive-research`
- Remove: Non-standard YAML fields
- Fix: "OPUS 4 ACTIVATION - EXTENDED THINKING MODE" section (this is automatic)
- Simplify: Agent specialization matrix

#### 4. `/add-backend-feature` & `/add-frontend-feature`
- Remove: Non-standard fields
- Fix: `@TodoWrite` patterns
- Improve: More concise instructions

### Pattern Fixes Across All Commands

1. **Replace pseudo-function calls with instructions:**
   ```markdown
   # Instead of:
   @Task(agent="Tech Lead", prompt="Review architecture")
   
   # Use:
   I'll have the Tech Lead agent review the architecture for scalability and best practices.
   ```

2. **Simplify TodoWrite usage:**
   ```markdown
   # Instead of complex JSON-like syntax
   # Use natural language:
   I'll track the following tasks:
   1. Analyze the current implementation
   2. Identify improvement areas
   3. Generate recommendations
   ```

3. **Remove "extended thinking" prompts:**
   - Delete sections like "OPUS 4 ACTIVATION"
   - Delete `<think harder>` tags
   - These are handled automatically by MAX_THINKING_TOKENS

## Recommended YAML Template

```yaml
---
description: Brief, clear description of what the command does
allowed-tools: Read, Write, Edit, Grep, Glob, Task, TodoWrite
argument-hint: expected arguments (e.g., "file path" or "feature name")
model: opus  # Optional, defaults to user's setting
---
```

## Implementation Priority

### Phase 1 (Immediate):
1. Fix `/init-claudify` - Critical for setup
2. Remove non-standard YAML fields from all commands
3. Fix `@Tool()` syntax in top 10 most-used commands

### Phase 2 (This Week):
1. Simplify extended thinking references
2. Update command documentation
3. Test all commands with Opus 4

### Phase 3 (Next Week):
1. Optimize prompting patterns
2. Add command validation script
3. Create command template generator

## Benefits of These Changes

1. **Compliance**: Commands will follow official Claude Code format
2. **Reliability**: Proper syntax ensures commands execute correctly
3. **Performance**: Cleaner prompts may improve execution speed
4. **Maintainability**: Simpler format easier to update
5. **User Experience**: Less confusion about configuration

## Testing Checklist

- [ ] All YAML frontmatter uses only official fields
- [ ] No `@Tool()` syntax remains in commands
- [ ] Extended thinking references removed or corrected
- [ ] Commands tested with Opus 4 model
- [ ] Documentation updated to reflect changes

## Next Steps

1. Create a validation script to check command format
2. Batch update all commands using MultiEdit
3. Test each command category systematically
4. Update the command generator to use correct format
5. Document the official command format in README

---

*Generated after extensive research on Claude Code best practices for Opus 4.1*