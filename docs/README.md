# Claudify Documentation

This directory contains comprehensive documentation for the Claudify system.

## Documentation Files

- **[COMMAND_REFERENCE.md](COMMAND_REFERENCE.md)** - Complete list of all 40+ commands with descriptions and examples
- **[AGENT_REFERENCE.md](AGENT_REFERENCE.md)** - Complete list of all 30+ specialized agents
- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup and installation instructions

## Quick Links

- [Main README](../README.md) - Project overview and quick start
- [Command Reference](COMMAND_REFERENCE.md) - Browse all available commands
- [Agent Reference](AGENT_REFERENCE.md) - Browse all available agents
- [Setup Guide](SETUP_GUIDE.md) - Installation instructions
- [Migration Guide](../MIGRATION-GUIDE-v4.md) - Upgrading from v3.x to v4.0.0
- [Changelog](../CHANGELOG.md) - Complete version history

## Project Information

- **Version**: 4.0.0
- **Released**: 2025-10-02
- **Repository**: https://github.com/GranatenUdo/claudify

## Getting Help

For issues, questions, or feature requests:
- GitHub Issues: https://github.com/GranatenUdo/claudify/issues
- Browse documentation in this folder

## What Claudify v4.0.0 Provides

After running setup, your project will have:

```
your-project/
├── .claude/
│   ├── commands/       # 40+ specialized commands
│   └── agents/         # 30+ expert agents
```

**Key principles**:
- Pure, context-aware commands (no hardcoded paths)
- Dynamic convention detection (examines code at runtime)
- Zero configuration needed
- Works with current directory context

## Usage Model

```bash
# Navigate to your project
cd src/YourProject.Web

# Launch Claude Code
claude

# Commands work in current directory
> /add-frontend-feature "Dashboard"
```

Commands automatically detect your conventions by examining existing code and configuration files.

---

**Built by GranatenUdo** | **Powered by Claude Code**
