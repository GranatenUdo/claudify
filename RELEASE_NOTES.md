# Claudify v4.0.0

## Summary

This release improves project detection accuracy, handles duplicate project names properly, and removes automatic documentation generation.

## Breaking Changes

### Template Variables
- `{{ProjectNamespace}}.Web` → `{{WebProject}}`
- `{{ProjectNamespace}}.Api` → `{{ApiProject}}`  
- `{{ProjectNamespace}}.ArchitectureTests` → `{{ArchitectureTestProject}}`

### Installation
- "Standard" mode renamed to "Minimal"
- "None" option removed

### Documentation
- CLAUDE.md and FEATURES.md are no longer auto-generated

## New Features

### Project Detection
- Angular projects detected via `angular.json` files
- .NET API projects detected via `Microsoft.NET.Sdk.Web` in .csproj
- Test projects detected via `Microsoft.NET.Sdk` with "Test" in name

### Duplicate Name Handling
- Projects with identical folder names (e.g., multiple "ClientApp") are disambiguated by prepending the parent folder name

### Interactive Configuration
- Prompts for confirmation of detected projects
- Supports comma-separated input for multiple projects
- Manual entry available when detection fails

## Bug Fixes

- Fixed "Cannot index into a null array" error when no architecture test projects exist
- Fixed duplicate project name handling
- Improved project detection using SDK markers instead of naming conventions

## Installation

```powershell
# Windows
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"

# Linux/macOS
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

## Upgrading from 3.x

1. Existing CLAUDE.md and FEATURES.md files will be preserved
2. Template variables in commands will be updated automatically
3. Choose "Comprehensive" for all available components

## Changes

### Added
- SDK-based project detection
- Duplicate name resolution
- Interactive configuration with multi-project support

### Changed
- Project detection logic uses file markers and SDK types
- Installation flow simplified to Minimal/Comprehensive
- Documentation files are user-managed

### Removed
- "None" installation option
- Automatic documentation generation
- Legacy init-claudify references
- Unsubstantiated performance claims

## Documentation

- [Setup Guide](SETUP-GUIDE.md)
- [Features](FEATURES.md)
- [Changelog](CHANGELOG.md)