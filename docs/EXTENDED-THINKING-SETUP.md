# Extended Thinking Configuration for Claude Code

## Overview

Extended thinking allows Claude Code agents to perform deeper analysis and reasoning. This replaces the deprecated `max_thinking_tokens` field that was previously in agent YAML frontmatter.

## Quick Setup

Run the configuration script:
```bash
./scripts/configure-extended-thinking.sh
```

## Manual Configuration

### Project-Level Settings (Team/Shared)

Create or update `.claude/settings.json`:
```json
{
  "env": {
    "MAX_THINKING_TOKENS": "49152",
    "ANTHROPIC_CUSTOM_HEADERS": "anthropic-beta: interleaved-thinking-2025-05-14"
  },
  "model": "opus"
}
```

### Personal Settings (Local Only)

Create `.claude/settings.local.json` (gitignored):
```json
{
  "env": {
    "MAX_THINKING_TOKENS": "100000",
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "64000"
  },
  "model": "opus"
}
```

## Token Limits Guide

| Level | Tokens | Use Case | Notes |
|-------|--------|----------|-------|
| Minimum | 1,024 | Quick tasks | Baseline thinking |
| Standard | 32,000 | Most development | Good balance |
| **Recommended** | **49,152** | **Opus 4 optimized** | **Best for agents** ✨ |
| High | 65,536 | Complex analysis | Deep reasoning |
| Maximum | 100,000 | Intensive research | May need batch mode |
| Theoretical | 200,000 | Full context | Potentially unstable |

> ⚠️ **Note**: Values above 32K may require batch processing for network stability

## Settings Precedence

Claude Code uses this hierarchy (highest to lowest):
1. Command line arguments
2. `.claude/settings.local.json` (personal)
3. `.claude/settings.json` (project)
4. `~/.claude/settings.json` (user global)
5. System defaults

## Why This Change?

Previously, agents had `max_thinking_tokens` in their YAML frontmatter:
```yaml
# ❌ OLD (doesn't work)
max_thinking_tokens: 49152
```

This field was **not officially supported** and had no effect. The correct approach is using environment variables in settings files.

## Benefits of Project-Level Configuration

1. **Team Consistency**: Everyone uses the same thinking budget
2. **Version Control**: Settings tracked in git (except .local)
3. **Easy Updates**: Change once, affects all agents
4. **Proper Support**: Uses official Claude Code configuration

## Advanced Configuration

### Maximum Output Tokens
For longer responses (especially with Sonnet):
```json
{
  "env": {
    "CLAUDE_CODE_MAX_OUTPUT_TOKENS": "64000"
  }
}
```

### Interleaved Thinking (Beta)
For advanced reasoning with tool use:
```json
{
  "env": {
    "ANTHROPIC_CUSTOM_HEADERS": "anthropic-beta: interleaved-thinking-2025-05-14"
  }
}
```

### Model Selection
```json
{
  "model": "opus"  // or "sonnet" or "haiku"
}
```

## Verification

After configuration:
1. Restart Claude Code
2. Run: `claude code`
3. Test an agent command
4. Check for improved reasoning depth

## Troubleshooting

### Settings Not Applied?
- Ensure file is valid JSON: `jq . .claude/settings.json`
- Check file location is correct
- Restart Claude Code

### Network Issues with High Tokens?
- Reduce to 32,000 or below
- Or use batch processing mode

### Want Different Settings Per Agent?
- Not supported - use project/personal settings
- All agents share the same thinking budget

## Migration from Old Format

All Claudify agents have been updated to remove non-functional fields:
- ❌ Removed: `max_thinking_tokens` (YAML field)
- ❌ Removed: `tool_justification` (documentation only)
- ✅ Now using: Project-level `MAX_THINKING_TOKENS`

## Related Documentation

- [Claude Code Settings](https://docs.anthropic.com/en/docs/claude-code/settings)
- [Extended Thinking](https://docs.aws.amazon.com/bedrock/latest/userguide/claude-messages-extended-thinking.html)
- [Claudify Agent Documentation](./../.claude/agents/README.md)