# Troubleshooting Guide

## Common Issues and Solutions

### Setup Issues

#### "Target repository not found"
**Problem**: The script can't find the specified directory.
**Solution**: 
- Verify the path exists
- Use absolute paths, not relative
- On Windows, use backslashes: `C:\path\to\repo`
- On Linux/Mac, use forward slashes: `/path/to/repo`

#### "Cannot index into a null array"
**Problem**: No projects of a certain type were found.
**Solution**: 
- This is normal if you don't have that project type
- Enter project names manually when prompted
- Or press Enter to skip that project type

#### PowerShell execution policy error
**Problem**: Windows blocks script execution by default.
**Solution**: 
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Project Detection Issues

#### Projects not detected
**Possible causes**:
1. Non-standard project structure
2. Missing file markers (angular.json, .csproj)
3. Projects in unexpected locations

**Solution**: Enter project names manually when prompted.

#### Wrong projects detected
**Problem**: Script picks up example or node_modules projects.
**Solution**: 
- Review the detected projects carefully
- Enter correct names when prompted
- Use comma-separated format: `MyWeb, MyApi, MyTests`

#### Duplicate project names
**Problem**: Multiple projects have the same name.
**Solution**: The script automatically prepends parent folder names to make them unique.

### Configuration Issues

#### Template variables not replaced
**Problem**: Commands still contain `{{WebProject}}` placeholders.
**Diagnosis**: Check `.claude/config/projects.json` exists and contains your project names.
**Solution**: 
1. Re-run the setup script
2. Ensure you confirmed the correct project names
3. Check for typos in project names

#### Commands not working
**Problem**: Claude Code commands fail or aren't recognized.
**Possible causes**:
1. Claude Code CLI not installed
2. Commands not properly configured
3. Working directory issues

**Solution**:
1. Verify Claude Code is installed: `claude --version`
2. Check commands exist: `ls .claude/commands/`
3. Ensure you're in the repository root when running Claude

### Runtime Issues

#### "Agent not found" errors
**Problem**: Commands reference agents that weren't installed.
**Solution**: 
- Check which installation mode you chose (Minimal vs Comprehensive)
- Re-run setup with Comprehensive mode if needed
- Verify agents exist: `ls .claude/agents/`

#### Permission denied errors
**Problem**: Scripts can't execute or access files.
**Solution**:
- On Linux/Mac: `chmod +x .claude/hooks/*.ps1`
- Ensure you have write permissions in the repository
- Run PowerShell as administrator if needed

### Validation Issues

#### How to verify successful setup
Run these checks:
```bash
# Check configuration exists
cat .claude/config/projects.json

# List installed commands
ls .claude/commands/

# List installed agents  
ls .claude/agents/

# Test a simple command
claude code
/quick-research "test"
```

#### How to validate template replacement
```bash
# Search for remaining placeholders
grep -r "{{.*}}" .claude/
```
If this returns results, template replacement may have failed.

### Clean Reinstallation

If you need to start over:
```bash
# Remove existing installation
rm -rf .claude/

# Re-run setup
pwsh setup.ps1 -TargetRepository "."

# Choose "Y" for clean installation when prompted
```

### Getting Help

If these solutions don't resolve your issue:
1. Check the setup log output for specific error messages
2. Verify your project follows standard .NET/Angular conventions
3. Contact your organization's support channel with:
   - The error message
   - Your project structure
   - PowerShell version (`$PSVersionTable.PSVersion`)
   - Operating system

## Frequently Asked Questions

### Q: Can I modify the installed commands and agents?
A: Yes, they're just text files in `.claude/`. However, your changes may be overwritten if you re-run setup.

### Q: How do I update to a new version of Claudify?
A: Pull the latest Claudify repository and re-run the setup script. It will detect the existing installation and offer to update.

### Q: Can I use this with non-.NET/Angular projects?
A: The setup is optimized for .NET/Angular, but you can manually enter any project names. Some commands may need adjustment for other tech stacks.

### Q: Why are some agents not included in Minimal installation?
A: Minimal includes only essential agents to keep the setup lightweight. Use Comprehensive if you need specialized agents.

### Q: Can I selectively install specific agents?
A: Currently, you choose between Minimal and Comprehensive. For custom selection, you can manually copy specific agent files from the Claudify repository.