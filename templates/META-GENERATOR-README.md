# 🧠 Meta-Generator & Intelligent Component Creation

## Overview

The Meta-Generator is an advanced system that intelligently creates Claude Code commands, agents, hooks, and tools optimized for Opus 4. It analyzes user intent, researches best practices, and generates components that leverage Opus 4's extended reasoning capabilities.

## Key Features

### 🎯 Intelligent Intent Analysis
- Analyzes user requests across multiple dimensions (technical, business, process)
- Determines optimal component mix (command only, command + agents, full suite)
- Classifies complexity and interaction models

### 🤖 Multi-Agent Collaboration
- Leverages specialized agents for comprehensive analysis
- Tech Lead for architecture decisions
- Security Reviewer for compliance and safety
- Researcher for best practices and patterns
- Code Reviewer for quality assurance

### ⚡ Opus 4 Optimizations
- Extended thinking (`<think harder>`) at critical decision points
- Interleaved reasoning for step-by-step analysis
- Multi-agent synthesis for complex decisions
- Maximum thinking tokens (65536) for deep reasoning

## Usage

### Via Command Line

The easiest way to use the meta-generator is through the `/create-command-and-or-agent` command:

```bash
/create-command-and-or-agent "analyze database performance bottlenecks"
```

This will:
1. Analyze your request
2. Research existing patterns
3. Design optimal architecture
4. Generate all necessary components
5. Update template generators

### Via PowerShell (Direct Usage)

```powershell
# Import the meta-generator
. .\templates\generators\meta-generator.ps1

# Create a new intelligent component
New-IntelligentComponent `
    -Name "performance-analyzer" `
    -Description "Analyze and optimize database query performance" `
    -OutputDirectory ".\.claude\commands"
```

### Via Template System

When running the template setup, the meta-generator automatically:
1. Detects when complex commands are needed
2. Generates the `/create-command-and-or-agent` command
3. Makes it available for creating future components

## Component Types Generated

### 📝 Commands
- YAML frontmatter with metadata
- Multi-phase execution flows
- Agent orchestration
- Interactive checkpoints
- Comprehensive error handling

### 🤖 Agents
- Rich personas with experience
- Specialized expertise sections
- Philosophy and approach
- Collaboration patterns
- Output templates

### 🔒 Hooks
- PowerShell validation scripts
- Pre/post operation checks
- Security validations
- Context enhancement
- Metadata injection

### 🛠️ Agent Tools
- Specialized analysis scripts
- Environment validation
- Result formatting
- Integration tests

### ⚙️ Agent Configs
- Tool restrictions
- MCP server definitions
- Focus areas
- Domain rules

## Examples

### Security Analysis Command
```bash
/create-command-and-or-agent "comprehensive security audit for multi-tenant APIs"
```

Generates:
- `/security-audit` command
- Security Auditor agent
- API validation hooks
- Tenant isolation checker tool
- Security config with OWASP rules

### Performance Optimization Suite
```bash
/create-command-and-or-agent "database and API performance optimization toolkit"
```

Generates:
- `/optimize-performance` command
- Performance Analyst agent
- Query analyzer tool
- Cache validator hook
- Performance monitoring config

### Legacy System Modernization
```bash
/create-command-and-or-agent "analyze and modernize legacy .NET Framework applications"
```

Generates:
- `/modernize-legacy` command
- Legacy System Specialist agent
- Code analyzer tools
- Migration validation hooks
- Modernization roadmap generator

## Intent Classification

The meta-generator classifies requests into:

### Domains
- **Technical**: Backend, frontend, infrastructure, security, performance
- **Business**: Compliance, analytics, operations, strategy
- **Process**: Automation, validation, monitoring, documentation

### Complexity Levels
- **Simple**: Single-purpose utility command
- **Moderate**: Command with supporting hooks
- **Complex**: Multi-agent collaboration required
- **Meta**: Custom agent with specialized tools

### Interaction Models
- **One-shot**: Execute and complete
- **Interactive**: Multi-phase with user decisions
- **Continuous**: Monitoring or ongoing analysis
- **Generative**: Creates other artifacts

## Best Practices

### 1. Be Specific
```bash
# ❌ Too vague
/create-command-and-or-agent "fix bugs"

# ✅ Specific and actionable
/create-command-and-or-agent "diagnose and fix React component rendering performance issues"
```

### 2. Include Context
```bash
# ❌ Missing context
/create-command-and-or-agent "analyze code"

# ✅ Context-rich
/create-command-and-or-agent "analyze Angular 19 signal usage patterns for optimization opportunities"
```

### 3. Specify Constraints
```bash
# ❌ No constraints
/create-command-and-or-agent "security check"

# ✅ Clear constraints
/create-command-and-or-agent "OWASP Top 10 security audit for .NET Core APIs with Auth0"
```

## Advanced Features

### Custom Agent Personas
The meta-generator creates agents with:
- 15+ years of specialized experience
- Domain-specific expertise
- Philosophical approaches
- Communication styles
- Decision-making patterns

### Intelligent Tool Selection
Automatically determines optimal toolsets:
- Read/Write/Edit for code manipulation
- Task for multi-agent orchestration
- WebSearch/WebFetch for research
- Bash for system operations
- TodoWrite for complex workflows

### Self-Improving Components
Generated components include:
- Usage analytics tracking
- Error pattern learning
- Performance metrics
- Feedback integration
- Evolution strategies

## Integration with Existing System

The meta-generator seamlessly integrates with:
- `command-generator.ps1` - Enhances standard commands
- `agent-generator.ps1` - Creates specialized agents
- `hook-generator.ps1` - Generates validation hooks
- `legacy-generator.ps1` - Works with legacy analysis

## Troubleshooting

### Component Not Generated
- Check if request is too vague
- Verify meta-generator.ps1 is loaded
- Ensure output directory exists

### Missing Dependencies
- Verify all generator modules are present
- Check PowerShell execution policy
- Ensure proper file permissions

### Performance Issues
- Complex requests may take time
- Multi-agent analysis is thorough
- Check system resources

## Future Enhancements

### Planned Features
1. **Learning System**: Components learn from usage patterns
2. **Cross-Component Communication**: Agents share insights
3. **Automatic Updates**: Components self-optimize
4. **Custom Templates**: User-defined component patterns

### Contribution Guidelines
To enhance the meta-generator:
1. Study existing patterns in `meta-generator.ps1`
2. Follow the established architecture
3. Test with various use cases
4. Document new capabilities

---

**Remember**: The meta-generator doesn't just create commands—it architects intelligent systems that understand context, leverage expertise, and continuously improve. Use it to transform your development workflow with the full power of Opus 4.