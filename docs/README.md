# Claudify Documentation

This directory contains documentation for the Claudify setup system.

## Available Documentation

- [Setup Guide](SETUP_GUIDE.md) - Detailed installation and configuration instructions
- [Agent Reference](AGENT_REFERENCE.md) - Documentation of available agents and their capabilities
- [Command Reference](COMMAND_REFERENCE.md) - List of available commands and their usage
- [Troubleshooting](TROUBLESHOOTING.md) - Common issues and solutions

## Quick Links

- **Version**: 4.0.0
- **Released**: 2025-08-20
- **Repository**: Internal repository (see your organization's documentation)

## Getting Help

If you encounter issues:
1. Check the troubleshooting guide
2. Review the setup logs in `.claude/logs/`
3. Contact your organization's support channel

## Project Structure After Setup

After running the setup script, your project will have:

```
your-project/
├── .claude/
│   ├── commands/       # Configured slash commands
│   ├── agents/         # Agent definitions
│   ├── hooks/          # Automation hooks (optional)
│   ├── config/         # Configuration files
│   │   └── projects.json
│   └── docs/           # Generated documentation
├── CLAUDE.md           # Your project-specific instructions (user-managed)
└── FEATURES.md         # Your feature documentation (user-managed)
```

## Notes

- CLAUDE.md and FEATURES.md are preserved during setup and remain user-managed
- The setup script detects projects based on file markers (angular.json, .csproj)
- All template variables are replaced with your actual project names