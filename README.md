# Claudify

![Version](https://img.shields.io/badge/version-5.0.0-blue)

**Intelligent Claude Code setup for .NET/Angular projects.**

Claudify installs specialized commands and agents that understand your project conventions automatically.

## What It Does

**Without Claudify**: Generic Claude Code commands that don't match your project style.
**With Claudify**: 40+ specialized commands that detect and match your coding conventions.

## How It Works

Claudify offers two convention detection modes:

### Smart Mode (Recommended)
- Analyzes your entire codebase during setup (~60 seconds)
- Caches conventions to `.claude/config/project-knowledge.json`
- Commands generate matching code instantly
- 95-100% accuracy for naming, patterns, and architecture
- Best for established projects with consistent conventions

### Adaptive Mode (Lightweight)
- Skips upfront analysis
- Commands examine 2-3 similar files on-demand when generating code
- Always reflects current codebase state
- 90% accuracy
- Best for rapidly changing projects

## Quick Start

```bash
# Clone Claudify
git clone https://github.com/GranatenUdo/claudify.git

# Run setup on your project
cd your-dotnet-angular-project
..\claudify\setup.ps1 -TargetRepository "."

# Choose Smart or Adaptive mode
# Setup completes in 1-2 minutes

# Navigate to the project you want to work on
cd src/YourProject.Web

# Launch Claude Code
claude

# Use commands - they work in your current directory context
> /add-frontend-feature "User Profile"
```

## Commands Work in Your Directory Context

**Key concept**: Commands operate in whatever directory Claude Code is launched from.

```bash
# Working on frontend
cd src/MyProject.Web
claude
> /add-frontend-feature "Dashboard"
# Creates component in MyProject.Web

# Working on backend
cd src/MyProject.Api
claude
> /add-backend-feature "Orders"
# Creates API in MyProject.Api
```

**No configuration needed**. Commands automatically work with your current directory.

## Multi-Project Development

Use git worktrees for working on multiple projects simultaneously:

```bash
# Create worktrees
git worktree add ../repo-admin-web main
git worktree add ../repo-public-web main

# Terminal 1: Admin work
cd ../repo-admin-web/src/Admin.Web
claude
> /add-frontend-feature "Admin Dashboard"

# Terminal 2: Public work
cd ../repo-public-web/src/Public.Web
claude
> /add-frontend-feature "Landing Page"
```

Each Claude session has independent context.

## Features

- **40+ Specialized Commands**: Backend, frontend, testing, analysis, deployment
- **30+ Expert Agents**: Security, architecture, code review, UX, technical debt
- **Convention Detection**: Smart (pre-analyzed) or Adaptive (on-demand)
- **Context-Aware**: Commands work in your current directory automatically
- **Zero Configuration**: No project setup or path configuration needed

## Commands

### Development
- `/add-backend-feature` - Create .NET API feature with tests
- `/add-frontend-feature` - Create Angular component with types
- `/implement-full-stack-feature` - Full-stack feature with parallel agents
- `/fix-backend-bug` - Debug and fix .NET issues
- `/fix-frontend-bug` - Debug and fix UI issues

### Code Quality
- `/comprehensive-review` - Multi-agent code quality review
- `/review-backend-code` - Backend-specific code review
- `/review-frontend-code` - Frontend-specific code review
- `/refactor-code` - Improve code quality and maintainability

### Analysis
- `/security-audit` - Security vulnerability scanning
- `/optimize-performance` - Performance analysis and fixes
- `/health-check` - Overall codebase health assessment
- `/validate-release` - Release readiness validation

### Updates
- `/update-backend-feature` - Enhance API with backward compatibility
- `/update-frontend-feature` - Update UI with compatibility
- `*-no-backward-compatibility` - Breaking change updates

[See full command list in `.claude/commands/`]

## Requirements

- **Operating System**: Windows, Linux, or macOS
- **PowerShell**: Version 7+ (cross-platform)
- **.NET**: Version 8 or 9
- **Angular**: Version 17+
- **Node.js**: Version 18+ (for Smart Mode analyzer only)
- **Claude Code**: Latest version

## Installation

After setup, Claudify creates:

```
your-project/
├── .claude/
│   ├── commands/          # 40+ specialized commands
│   ├── agents/            # 30+ expert agents
│   └── config/
│       ├── project-knowledge.json # Convention cache (Smart Mode)
│       └── claudify.json          # Mode configuration
```

## Refreshing Analysis

If your codebase conventions change:

```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

Updates convention analysis without reinstalling.

## How Convention Detection Works

### Smart Mode (Pre-Analysis)
1. Setup runs TypeScript analyzer on entire codebase
2. Detects 18+ patterns: naming, constructors, properties, collections, error handling, validation, testing
3. Saves to `.claude/config/project-knowledge.json`
4. Commands read cache and generate matching code instantly

### Adaptive Mode (On-Demand)
1. When generating code, commands examine 2-3 similar existing files
2. Detect patterns: constructors, properties, collections, naming, error handling
3. Generate new code matching observed patterns
4. No cache needed, always current

### Fallback Strategy
Commands automatically fall back to Adaptive Mode if:
- Cache doesn't exist (Adaptive Mode was chosen)
- Cache is missing or corrupted
- Node.js not available during setup

## Supported Project Types

- **.NET 8/9** Web APIs
- **Angular 17-19** applications
- **.NET test projects** (xUnit, NUnit, MSTest)
- **Multi-project solutions** (monorepos)

## Example Project Structure

Claudify works with standard .NET/Angular layouts:

```
your-solution/
├── src/
│   ├── MyCompany.Product.Web/        # Angular + .NET host
│   ├── MyCompany.Product.Api/        # .NET Web API
│   ├── MyCompany.Product.Domain/     # Domain models
│   └── MyCompany.Product.Infrastructure/
└── tests/
    ├── MyCompany.Product.Tests/
    └── MyCompany.Product.ArchitectureTests/
```

## Security Considerations

- Each agent restricted to minimal required tools
- No hardcoded paths in commands or agents
- All configuration stored locally in `.claude/config/`
- Convention cache contains only detected patterns (no code, no secrets)

## Version

**Current**: 5.0.0

**What's New in 5.0.0** (Breaking):
- Commands are now pure and path-agnostic
- Work in current directory context (no hardcoded paths)
- Simplified setup (just copies files, no project detection)
- Commands use bash commands directly (`npm run build` not `cd X && npm run build`)
- Aligns with official Claude Code best practices

See [CHANGELOG.md](CHANGELOG.md) for complete version history.

## Getting Started

1. **Clone Claudify**:
   ```bash
   git clone https://github.com/GranatenUdo/claudify.git
   ```

2. **Run Setup**:
   ```bash
   cd your-dotnet-angular-project
   ..\claudify\setup.ps1 -TargetRepository "."
   ```

3. **Choose Mode**:
   - Smart Mode (recommended): Analyzes project once, instant generation
   - Adaptive Mode: On-demand detection, always current

4. **Navigate & Launch**:
   ```bash
   cd src/YourProject.Web
   claude
   ```

5. **Use Commands**:
   ```bash
   > /add-frontend-feature "User Dashboard"
   ```

Commands work in your current directory automatically.

## Troubleshooting

**Q: Commands generate wrong patterns**
A: Run `.\setup.ps1 -RefreshAnalysis` to update convention cache.

**Q: Node.js not found during setup**
A: Choose Adaptive Mode during setup, or install Node.js 18+ for Smart Mode.

**Q: Analyzer fails**
A: Commands automatically fall back to Adaptive Mode. Check: `node --version`

**Q: Want to switch from Adaptive to Smart Mode**
A: Run `.\setup.ps1 -RefreshAnalysis` to generate convention cache.

**Q: How do I work on multiple projects?**
A: Use `cd` to switch projects, or use git worktrees for parallel sessions.

## Contributing

Contributions welcome! Please:
1. Follow existing command/agent structure
2. Test on real .NET/Angular projects
3. Update documentation for new features
4. Commands must be path-agnostic (no hardcoded paths)

## License

[Your License Here]

## Support

For issues, questions, or feature requests:
- GitHub Issues: https://github.com/GranatenUdo/claudify/issues
- Documentation: See `.claude/commands/README.md` after setup

---

**Built by GranatenUdo** | **Powered by Claude Code**
