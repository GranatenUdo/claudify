# Claudify Setup Guide

## Prerequisites

Before running Claudify, ensure you have:

✅ **PowerShell 7+** installed (cross-platform)
- Windows: Pre-installed or via Microsoft Store
- macOS: `brew install powershell`
- Linux: [Installation guide](https://docs.microsoft.com/powershell/scripting/install/installing-powershell)

✅ **Claude Code CLI** installed and configured
- Run `claude --version` to verify installation
- Ensure you're logged in with `claude login`

✅ **.NET/Angular Project** following standard conventions
- .NET 8 or 9 backend
- Angular 17-19 frontend
- Standard project structure (src/, tests/ folders)

## Installation Steps

### Step 1: Download Claudify

Download or clone the Claudify repository to your local machine:

```bash
git clone https://github.com/your-org/claudify.git
cd claudify
```

### Step 2: Run Setup

#### Windows
```powershell
.\setup.ps1 -TargetRepository "C:\path\to\your\project"
```

#### macOS/Linux
```bash
pwsh setup.ps1 -TargetRepository "/path/to/your/project"
```

### Step 3: Installation Options

When prompted, select your installation mode:

```
Choose installation mode:
  [M] Minimal   - Core components for your stack (~15-25 files)
  [C] Comprehensive - Everything available (~40+ files) [RECOMMENDED]

Select mode (M/C) [C]: C
```

**Recommendation**: Choose **Comprehensive** for full capabilities.

### Step 4: Interactive Project Configuration

Claudify will guide you through an interactive configuration:

1. **Scans for all projects**:
   - Angular projects via angular.json files
   - .NET Web API projects via Microsoft.NET.Sdk.Web
   - Test projects via Microsoft.NET.Sdk with 'Test' in name
2. **Shows what it found** - Lists each detected project with its location
3. **Handles duplicates** - If multiple projects have the same name (e.g., ClientApp), prepends parent folder
4. **Lets you confirm or correct** - For each project type:
   - Shows the detected project name(s) as default
   - Press Enter to accept all detected projects
   - Or enter names (comma-separated for multiple)
   - Or press Enter with no name to skip that project type
5. **Saves your configuration** to `.claude/config/projects.json`
6. **Applies templates** - Replaces all `{{WebProject}}`, `{{ApiProject}}`, etc.

You'll see an interactive configuration process:
```
[CONFIG] Detecting and configuring project names...

  Scanning for projects...
  Found 4 project(s)

  [Web Project Configuration]
  Detected web project(s):
    - MyCompany.MyProject.Web (at src\MyCompany.MyProject.Web\MyCompany.MyProject.Web.csproj)
  Enter primary web project name [MyCompany.MyProject.Web]: ⏎
  ✓ Web project: MyCompany.MyProject.Web

  [API Project Configuration]
  Detected API project(s):
    - MyCompany.MyProject.Api (at src\MyCompany.MyProject.Api\MyCompany.MyProject.Api.csproj)
  Enter API project name [MyCompany.MyProject.Api]: ⏎
  ✓ API project: MyCompany.MyProject.Api

  [Architecture Test Project Configuration]
  Detected architecture test project(s):
    - MyCompany.MyProject.ArchitectureTests (at tests\MyCompany.MyProject.ArchitectureTests\MyCompany.MyProject.ArchitectureTests.csproj)
  Enter architecture test project name [MyCompany.MyProject.ArchitectureTests]: ⏎
  ✓ Architecture test project: MyCompany.MyProject.ArchitectureTests

  [Configuration Summary]
  The following projects will be configured:
    WebProject = MyCompany.MyProject.Web
    ApiProject = MyCompany.MyProject.Api
    ArchitectureTestProject = MyCompany.MyProject.ArchitectureTests

  Applying project templates to all files...
    {{WebProject}} → MyCompany.MyProject.Web
    {{ApiProject}} → MyCompany.MyProject.Api
    {{ArchitectureTestProject}} → MyCompany.MyProject.ArchitectureTests
    Processed: add-backend-feature.md
    Processed: fix-frontend-bug.md
    ... (more files)
  [OK] Processed 12 file(s) with project templates

✅ Setup Complete!
  ✓ Commands installed
  ✓ Agents configured
  ✓ Project configuration applied
  ✓ CLAUDE.md and FEATURES.md preserved (user-managed)
```

### Step 5: Start Using Claude Code

Open a terminal in your project directory and run:

```bash
claude code
```

Try your first command:
```
/comprehensive-review
```

## Configuration Details

### Project Structure

Claudify expects this standard structure:
```
your-project/
├── src/
│   ├── YourNamespace.Api/        # Backend API
│   ├── YourNamespace.Web/        # Angular frontend
│   └── YourNamespace.Domain/     # Domain models
├── tests/
│   ├── YourNamespace.Api.Tests/
│   └── YourNamespace.ArchitectureTests/
└── .claude/                       # Created by Claudify
```

### Namespace Detection

Claudify automatically detects your namespace from:
- Primary .csproj files (non-test projects)
- Removes common suffixes (.Api, .Web, .Domain)
- Example: `Acme.Inventory.Api` → `Acme.Inventory`

### What Gets Configured

All commands and agents are configured with your namespace:
- Build paths: `cd src/YourNamespace.Web && npm run build`
- Test paths: `dotnet test tests/YourNamespace.ArchitectureTests`
- API updates: `cd src/YourNamespace.Web && npm run update:api`

## Common Scenarios

### Fresh Installation

For a new project without Claude Code:
1. Run setup.ps1 with Comprehensive mode
2. Namespace is detected automatically
3. All components installed and configured
4. Ready to use immediately

### Updating Existing Installation

To update an existing Claude Code setup:
1. Run setup.ps1 again
2. Choose "Y" for clean installation when prompted
3. Your CLAUDE.md and FEATURES.md are preserved
4. Updated components with latest optimizations

### Multiple Projects

For multiple projects with different namespaces:
1. Run Claudify separately for each project
2. Each gets its own namespace configuration
3. Commands adapt to each project structure
4. No manual configuration needed

## Verification

### Confirm Successful Setup

Check that setup completed correctly:

```bash
# List installed agents
claude /agents

# Verify commands exist
ls .claude/commands/

# Test a command
claude /comprehensive-review

# Check for template markers (should return nothing)
grep -r "{{.*}}" .claude/
```

### Expected Results

After successful setup:
- ✅ 30+ agents available
- ✅ 40+ commands installed
- ✅ No template markers remaining
- ✅ Commands execute without errors
- ✅ Documentation reflects your project

## Troubleshooting

### Issue: Namespace Not Detected

**Solution**: Ensure you have .csproj files in standard locations:
- Check for `src/YourNamespace.Api/YourNamespace.Api.csproj`
- Verify project follows naming conventions
- Manually enter namespace when prompted

**Validation**: After setup, run the validation script:
```powershell
.\validate-namespace.ps1 -TargetPath "C:\path\to\your\project"
```

This will verify:
- Namespace was correctly detected and saved
- All template references were replaced
- Project structure matches the configured namespace

### Issue: Commands Fail to Execute

**Solution**: Verify project structure:
- Angular app at `src/YourNamespace.Web/`
- Package.json with standard npm scripts
- Tests in `tests/` directory

### Issue: Permission Denied

**Solution**: On macOS/Linux:
```bash
chmod +x setup.ps1
pwsh setup.ps1 -TargetRepository "/path/to/project"
```

### Issue: PowerShell Not Found

**Solution**: Install PowerShell 7+:
- Windows: Microsoft Store or [downloads](https://github.com/PowerShell/PowerShell)
- macOS: `brew install powershell`
- Linux: Follow [official guide](https://docs.microsoft.com/powershell)

## Best Practices

### Recommended Workflow

1. **Always use Comprehensive mode** for full capabilities
2. **Run setup from project root** for best detection
3. **Commit .claude folder** to share configuration with team
4. **Update regularly** to get latest optimizations

### Team Setup

For consistent team configuration:
1. One team member runs Claudify
2. Commit `.claude/` folder to repository
3. Team members clone and immediately have Claude Code ready
4. Everyone uses same commands and agents

### CI/CD Integration

Claudify includes Azure DevOps support:
- Pipeline templates in `.claude/pipelines/`
- Automated testing integration
- Deployment validation scripts
- Quality gates configuration

## Advanced Configuration

### Custom Namespace

If automatic detection doesn't work:
```powershell
# You'll be prompted to enter manually
Enter your project namespace: Acme.ProductName
```

### Selective Installation

For minimal setup, choose Standard mode:
- Installs only essential components
- Faster setup time
- Can upgrade to Comprehensive later

### Preserving Customizations

Your customizations are preserved:
- CLAUDE.md modifications kept
- FEATURES.md additions maintained
- Custom commands in .claude/commands/
- Project-specific agents retained

## Success Indicators

You know setup succeeded when you see:

```
✅ Setup Complete!
  ✓ Commands installed
  ✓ Agents configured
  ✓ Project namespace applied: YourNamespace
  ✓ Documentation generated

Start using Claude Code:
  claude code
  /comprehensive-review
```

## Getting Help

### Resources

- **Documentation**: See `/docs` folder in Claudify
- **Commands Help**: Run `/help` in Claude Code
- **Agent List**: Run `/agents` to see available agents
- **Example Usage**: Check command files for examples

### Support Channels

- Internal team wiki for organization-specific guidance
- Claude Code documentation at [claude.ai/docs](https://claude.ai/docs)
- Team lead for architecture questions

## Next Steps

After successful setup:

1. **Explore Commands**: Try `/comprehensive-review` for code analysis
2. **Create Features**: Use `/add-backend-feature` or `/add-frontend-feature`
3. **Fix Issues**: Use `/fix-backend-bug` or `/fix-frontend-bug`
4. **Security Audit**: Run `/security-audit` regularly
5. **Learn Agents**: Explore specialized agents with `/agents`

---

**Claudify Setup Complete!** Your project is now configured for accelerated development with Claude Code.