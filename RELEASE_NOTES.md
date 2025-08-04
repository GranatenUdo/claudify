## 🎉 Claudify v2.0.1 - Cleanup and Documentation Update

This release focuses on cleaning up temporary files, improving documentation, and enhancing the setup experience.

### ✨ What's New

- **🚀 Integrated Intelligent Setup** - Choose installation mode during setup (Minimal/Standard/Comprehensive)
- **🔍 Enhanced Tech Detection** - Finds Angular/React/Vue in subdirectories like `ClientApp/`, `frontend/`
- **🧹 Clean Install Option** - Recommended for major version upgrades
- **📝 Auto-Generated Config** - Creates CLAUDE.md and FEATURES.md tailored to your stack
- **🎯 Fixed Agent Mappings** - All commands now use available Claude agents
- **📁 Better Organization** - Documentation moved to docs/ folder

### 🐛 Fixed
- Corrected release date for version 2.0.0 in documentation
- Removed temporary test scripts (4 files)
- Removed temporary documentation (2 files)

### 📝 Changed
- Updated version to 2.0.1
- Cleaned up project structure
- Moved agent collaboration docs to `docs/` folder
- Updated all references to new documentation locations

### 📚 Documentation
- Updated README.md to reflect new integrated intelligent setup flow
- Added installation modes section to clarify options
- Enhanced Quick Start section with detailed setup process
- Updated Common Questions to reflect new features

### 🚀 Quick Start

```powershell
# Windows
.\setup.ps1 -TargetRepository "C:\path\to\your\repo"

# Linux/macOS
pwsh setup.ps1 -TargetRepository "/path/to/your/repo"
```

Choose your installation mode when prompted:
- **[M]** Minimal - Essential components only
- **[S]** Standard - Core components for your stack
- **[C]** Comprehensive - Everything available **(Recommended)**

### 📋 Full Changelog
See [CHANGELOG.md](https://github.com/GranatenUdo/claudify/blob/main/CHANGELOG.md) for complete details.

---
**Note**: Version 2.0.0 users should perform a clean install when updating to 2.0.1.