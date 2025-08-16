# Hook Configuration Fix Documentation

## Problem
The hooks were failing with the error:
```
The argument '$CLAUDE_PROJECT_DIR/.claude/hooks/security-secrets-check.ps1' is not recognized as the name of a script file
```

## Root Cause
Windows PowerShell doesn't expand environment variables like `$CLAUDE_PROJECT_DIR` when passed as string literals in the command. The original configuration was:
```json
"command": "pwsh \"$CLAUDE_PROJECT_DIR/.claude/hooks/security-secrets-check.ps1\""
```

## Solution
Changed to use relative paths with the `-File` parameter:
```json
"command": "pwsh -File \".claude/hooks/security-secrets-check.ps1\""
```

## Key Changes Made

### 1. Settings.json Updates
- Replaced `pwsh "$CLAUDE_PROJECT_DIR/..."` with `pwsh -File ".claude/..."`
- Used relative paths from project root
- Added `-File` parameter to explicitly tell PowerShell to execute a script file

### 2. Why This Works
- **Relative paths**: Claude Code executes commands from the project root directory
- **-File parameter**: Tells PowerShell explicitly that the next argument is a script file path
- **Cross-platform**: Works on both Windows and Unix-like systems

## Testing
Created `test-hook-config.ps1` to verify:
1. ✅ Hook files are accessible
2. ✅ Hooks execute without errors
3. ✅ Security hook blocks passwords
4. ✅ Settings.json properly configured

## Hook Configuration Reference

### Working Configuration
```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Write|Edit|MultiEdit",
        "hooks": [{
          "type": "command",
          "command": "pwsh -File \".claude/hooks/security-secrets-check.ps1\" -ToolName \"$TOOL_NAME\" -Content \"$CONTENT\"",
          "canBlock": true
        }]
      }
    ]
  }
}
```

### Variables Available to Hooks
- `$TOOL_NAME` - Name of the tool being used
- `$CONTENT` - Content being written/edited
- `$FILE_PATH` - Path to file being modified
- `$USER_PROMPT` - User's input prompt
- `$ARGUMENTS` - Tool arguments

## Troubleshooting Guide

### If hooks still don't work:

1. **Check PowerShell is installed**:
   ```bash
   pwsh --version
   ```

2. **Verify hook files exist**:
   ```bash
   ls .claude/hooks/*.ps1
   ```

3. **Test a hook manually**:
   ```bash
   pwsh -File ".claude/hooks/add-context.ps1" -UserPrompt "test"
   ```

4. **Check execution policy** (Windows):
   ```powershell
   Get-ExecutionPolicy
   # If restricted, run as admin:
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```

5. **Enable hook debugging**:
   ```json
   "hookSettings": {
     "logLevel": "debug"
   }
   ```

## Best Practices

1. **Always use relative paths** from project root
2. **Use -File parameter** for PowerShell scripts
3. **Quote paths** containing spaces
4. **Test hooks** after configuration changes
5. **Keep hooks simple** - they have a 5-second timeout

## Summary
The fix ensures hooks work consistently across Windows environments by:
- Using relative paths instead of environment variables
- Explicitly specifying script execution with `-File`
- Maintaining cross-platform compatibility