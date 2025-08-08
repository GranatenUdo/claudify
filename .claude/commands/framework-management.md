# framework-management

Manage framework plugins and components in the multi-framework Claudify architecture.

## Description
This command provides comprehensive framework plugin management capabilities for Claudify 4.0+, allowing you to list, install, update, and configure framework-specific components.

## Usage
```bash
/framework-management <action> [options]
```

## Actions

### list
List all available framework plugins:
```bash
/framework-management list
```

### install
Install a specific framework plugin:
```bash
/framework-management install angular
/framework-management install react
/framework-management install dotnet
```

### update
Update installed framework plugins:
```bash
/framework-management update all
/framework-management update angular
```

### detect
Detect frameworks in current project:
```bash
/framework-management detect
```

### info
Show detailed information about a framework:
```bash
/framework-management info angular
```

### configure
Configure framework-specific settings:
```bash
/framework-management configure angular --version 17
```

## Framework Plugin Structure

Each framework plugin contains:
- **Agents**: Framework-specific AI specialists
- **Commands**: Framework-specific commands
- **Templates**: Code generation templates
- **Patterns**: Best practices and patterns
- **Hooks**: Framework-specific validation

## Available Frameworks

### Frontend Frameworks
- `angular` - Angular 16+ with signals, standalone components
- `react` - React 18+ with hooks, context, Redux
- `vue` - Vue 3+ with Composition API
- `svelte` - Svelte/SvelteKit
- `nextjs` - Next.js with App Router

### Backend Frameworks
- `dotnet` - .NET 6+ with Entity Framework
- `nodejs` - Node.js with Express/Fastify
- `python` - Python with Django/FastAPI
- `java` - Java with Spring Boot
- `go` - Go with Gin/Echo

### Database Plugins
- `mssql` - Microsoft SQL Server
- `postgresql` - PostgreSQL
- `mongodb` - MongoDB
- `mysql` - MySQL/MariaDB

## Multi-Framework Projects

For projects using multiple frameworks:
```bash
/framework-management install angular,dotnet,postgresql
```

## Monorepo Support

Automatically detects and configures for monorepos:
```bash
/framework-management detect --monorepo
```

## Custom Framework Plugins

Create custom framework plugins:
```bash
/framework-management create-plugin my-framework
```

## Migration from v3

Migrate existing Claudify 3.x installation:
```bash
/framework-management migrate
```

## Examples

### Angular + .NET Project
```bash
/framework-management install angular,dotnet
/framework-management configure angular --version 17
/framework-management configure dotnet --version 8
```

### React + Node.js Project
```bash
/framework-management install react,nodejs
/framework-management configure react --typescript true
/framework-management configure nodejs --package-manager pnpm
```

### Detect and Auto-Install
```bash
/framework-management detect
/framework-management install --auto-detected
```

## Framework-Specific Commands

After installing a framework, new commands become available:

### Angular Commands
- `/add-angular-component`
- `/fix-angular-routing`
- `/optimize-angular-bundle`
- `/migrate-angular-version`

### React Commands
- `/add-react-component`
- `/create-react-hook`
- `/optimize-react-performance`
- `/setup-react-testing`

### .NET Commands
- `/add-dotnet-controller`
- `/add-entity-framework-model`
- `/implement-ddd-pattern`
- `/setup-dotnet-testing`

## Configuration File

Framework configurations are stored in `.claudify/framework-config.json`:

```json
{
  "installed": ["angular", "dotnet", "postgresql"],
  "configurations": {
    "angular": {
      "version": "17",
      "standalone": true,
      "signals": true
    },
    "dotnet": {
      "version": "8",
      "nullable": true,
      "implicitUsings": true
    }
  }
}
```

## Troubleshooting

### Framework Not Detected
```bash
/framework-management detect --verbose
/framework-management install <framework> --force
```

### Version Conflicts
```bash
/framework-management check-compatibility
/framework-management update --resolve-conflicts
```

### Plugin Issues
```bash
/framework-management validate
/framework-management repair
```

## Related Commands
- `/init-claudify` - Initialize Claudify in a repository
- `/create-command-and-or-agent` - Create custom components
- `/comprehensive-review` - Review code with framework-aware agents

## Notes
- Framework plugins are stored in `frameworks/` directory
- Core components remain in `core/` directory
- Backward compatibility maintained with v3 installations
- Community plugins available in `plugins/community/`

---
**Category**: essential
**Since**: v4.0.0
**Requires**: Claudify multi-framework architecture