# Claudify

![Version](https://img.shields.io/badge/version-4.0.0-blue)

**Automated configuration system for Claude Code in .NET/Angular projects.**

Claudify configures Claude Code to generate code that matches YOUR project's conventions automatically.

## What It Does

**Without Claudify**: Claude generates generic "best practice" code that doesn't match your style.
**With Claudify**: Claude examines your codebase and generates code that fits perfectly.

## How It Works

Claudify offers two convention detection modes:

### Smart Mode (Default, Recommended)
- Analyzes your project conventions during setup (~60 seconds)
- Commands generate perfectly matching code instantly
- 95-100% accuracy for naming, patterns, and architecture
- Best for teams with established conventions

### Adaptive Mode (Lightweight)
- Skips analysis, commands examine relevant code on-demand
- Always reflects current codebase state
- 90% accuracy from examining 2-3 similar files
- Best for rapidly changing projects

Both modes work seamlessly - commands automatically fall back to adaptive detection if no cache exists.

## Quick Start

```bash
# Clone Claudify
git clone https://github.com/GranatenUdo/claudify.git

# Run setup on your project
cd your-dotnet-angular-project
..\claudify\setup.ps1 -TargetRepository "."

# Choose mode when prompted (Smart Mode recommended)
# Setup completes in 1-2 minutes

# Start using Claude Code with perfect convention matching
claude /add-backend-feature "Order Management"
```

## Features

- **Project-Aware Generation**: Code matches your conventions automatically
- **40+ Specialized Commands**: Backend, frontend, testing, analysis, deployment
- **30+ Expert Agents**: Security, architecture, code review, UX, technical debt
- **Dual-Mode System**: Choose between pre-analyzed (fast) or on-demand (always current)
- **Zero Breaking Changes**: Fully backward compatible with existing setups

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
- **Node.js**: Version 18+ (for Smart Mode analyzer)
- **Claude Code**: Latest version

## Configuration

After setup, Claudify creates:

```
your-project/
├── .claude/
│   ├── commands/          # 40+ project-configured commands
│   ├── agents/            # 30+ specialized agents
│   ├── config/
│   │   ├── projects.json          # Project structure
│   │   ├── project-knowledge.json # Convention cache (Smart Mode)
│   │   └── claudify.json          # Mode configuration
│   └── templates/         # Code generation templates
└── .claudify/             # Temporary resources (gitignored)
```

## Refreshing Analysis

If your codebase conventions change:

```bash
.\setup.ps1 -TargetRepository "." -RefreshAnalysis
```

This updates the convention analysis without reinstalling Claudify.

## How Convention Detection Works

### Smart Mode (Pre-Analysis)
1. Setup runs TypeScript analyzer on your entire codebase
2. Detects 18+ patterns: naming, constructors, properties, collections, error handling, validation, testing
3. Saves to `.claude/config/project-knowledge.json`
4. Commands read cache and generate matching code instantly

### Adaptive Mode (On-Demand)
1. When generating code, commands examine 2-3 similar existing files
2. Detect patterns from those files: constructors, properties, collections, naming
3. Generate new code matching observed patterns
4. No cache needed, always reflects current code state

### Fallback Strategy
Commands automatically fall back to adaptive mode if:
- Cache doesn't exist (Adaptive Mode was chosen)
- Cache is missing or corrupted
- First-time setup before analysis runs

## Supported Project Types

- **.NET 8/9** Web APIs with typical structure
- **Angular 17-19** applications
- **.NET test projects** (xUnit, NUnit, MSTest)
- **Multi-project solutions** with multiple APIs/frontends

## Project Structure Requirements

Claudify works best with standard project layouts:

```
your-solution/
├── src/
│   ├── YourCompany.Product.Web/        # Angular + .NET host
│   ├── YourCompany.Product.Api/        # .NET Web API
│   ├── YourCompany.Product.Domain/     # Domain models
│   └── YourCompany.Product.Infrastructure/
└── tests/
    ├── YourCompany.Product.Tests/
    └── YourCompany.Product.ArchitectureTests/
```

## Security Considerations

- Each agent restricted to minimal required tools
- No hardcoded paths or secrets in configuration
- All configuration stored locally in `.claude/config/`
- Convention cache contains only detected patterns, no sensitive data

## Version

**Current**: 4.0.0

**What's New in 4.0.0**:
- Dual-Mode convention detection (Smart + Adaptive)
- All 32 commands support pattern detection
- Automatic fallback between modes
- Interactive mode selection during setup
- `.\setup.ps1 -RefreshAnalysis` for updating conventions

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

4. **Confirm Projects**:
   - Setup detects your projects automatically
   - Confirm or override detected names

5. **Start Using**:
   ```bash
   claude /add-backend-feature "User Management"
   ```

## Troubleshooting

**Q: Commands generate wrong patterns**
A: Run `.\setup.ps1 -RefreshAnalysis` to update convention cache.

**Q: Node.js not found during setup**
A: Install Node.js 18+ for Smart Mode, or choose Adaptive Mode during setup.

**Q: Analyzer fails**
A: Commands automatically fall back to Adaptive Mode. Check Node.js version: `node --version`

**Q: Want to switch from Adaptive to Smart Mode**
A: Run `.\setup.ps1 -RefreshAnalysis` to generate convention cache.

## Contributing

Contributions welcome! Please:
1. Follow existing command/agent structure
2. Test on real .NET/Angular projects
3. Update documentation for new features
4. Ensure backward compatibility

## License

[Your License Here]

## Support

For issues, questions, or feature requests:
- GitHub Issues: https://github.com/GranatenUdo/claudify/issues
- Documentation: See `.claude/commands/README.md` after setup

---

**Built by GranatenUdo** | **Powered by Claude Code**
