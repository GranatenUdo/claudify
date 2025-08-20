# Claudify Setup Guide

## Prerequisites

- PowerShell 7+ (Windows, Linux, or macOS)
- Claude Code CLI installed and configured
- A .NET/Angular project following standard conventions

## Installation Steps

### 1. Get Claudify

Clone or download the Claudify repository to a local directory.

### 2. Run the Setup Script

#### Windows
```powershell
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"
```

#### Linux/macOS
```bash
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

### 3. Choose Installation Mode

You'll be prompted to select:
- **Minimal**: Core components only (15-25 files)
- **Comprehensive**: All available components (40+ files)

For most projects, Minimal is sufficient. Choose Comprehensive if you need specialized agents for security, infrastructure, or legacy code analysis.

### 4. Review Detected Projects

The script will scan for:
- Angular projects (via angular.json)
- .NET API projects (via .csproj with Microsoft.NET.Sdk.Web)
- Test projects (via .csproj with "Test" in the name)

You'll see something like:
```
Detected Projects:
  Web: MyCompany.Product.Web
  API: MyCompany.Product.Api
  Tests: MyCompany.Product.Tests
```

If these are incorrect, you can enter the correct names manually.

### 5. Confirm and Complete

The script will:
1. Apply your project names to all command templates
2. Copy configured files to `.claude/` in your repository
3. Create a `projects.json` configuration file
4. Display a summary of what was installed

## Configuration Details

### Template Variables

Commands use these template variables that get replaced:
- `{{WebProject}}` - Your Angular project name
- `{{ApiProject}}` - Your .NET API project name
- `{{ArchitectureTestProject}}` - Your architecture test project name

### Project Detection Logic

The setup script uses these patterns:

**Angular Projects**: 
- Searches for `angular.json` files
- Uses the parent folder name as the project name

**API Projects**:
- Searches for `.csproj` files
- Checks for `<Project Sdk="Microsoft.NET.Sdk.Web">`
- Extracts project name from the filename

**Test Projects**:
- Searches for `.csproj` files with "Test" or "Tests" in the name
- Prioritizes architecture test projects if multiple exist

### Handling Duplicate Names

If multiple projects have the same name (e.g., multiple "ClientApp" folders), the script prepends the parent folder name to make them unique.

## Troubleshooting

### Script Fails to Detect Projects

If automatic detection fails:
1. The script will prompt you to enter project names manually
2. Enter them comma-separated: `MyWeb, MyApi, MyTests`

### Permission Errors

On Linux/macOS, you may need to make the script executable:
```bash
chmod +x setup.ps1
```

### PowerShell Version Issues

Check your PowerShell version:
```powershell
$PSVersionTable.PSVersion
```

If it's below 7.0, install PowerShell 7:
- Windows: `winget install Microsoft.PowerShell`
- Linux/macOS: See [Microsoft's installation guide](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell)

### Clean Installation

If you want to completely remove and reinstall:
1. Delete the `.claude` directory from your repository
2. Run the setup script again
3. Choose "Y" when prompted for a clean installation

## Post-Setup

After successful setup:

1. **Test a command**: 
   ```
   claude code
   /comprehensive-review
   ```

2. **View available commands**:
   ```
   claude /help
   ```

3. **Check your configuration**:
   ```
   cat .claude/config/projects.json
   ```

## Notes

- Your existing CLAUDE.md and FEATURES.md files are preserved
- The setup doesn't modify any of your source code
- Configuration is stored locally in your repository
- No data is sent to external services during setup