# Technical Debt Analyzer Usage Guide

## Overview
The Technical Debt Analyzer is a comprehensive tool for identifying and quantifying technical debt across your codebase. It analyzes code quality, dependencies, security vulnerabilities, and architectural patterns to provide actionable remediation recommendations.

## Basic Usage

### Analyze Entire Project
```bash
/analyze-technical-debt "."
```

### Analyze Specific Directory
```bash
/analyze-technical-debt "src/PTA.VineyardManagement.Api"
```

### Analyze Specific File Types
```bash
/analyze-technical-debt "src/**/*.cs"     # All C# files
/analyze-technical-debt "**/*.{js,ts}"   # All JavaScript/TypeScript files
```

## Advanced Usage

### With Options
The command supports various analysis options:
- `analysis-depth`: shallow|standard|deep (default: standard)
- `include-dependencies`: true|false (default: true)
- `include-security`: true|false (default: true)
- `check-newer-versions`: true|false (default: true)
- `output-format`: markdown|json|html (default: markdown)

## What It Analyzes

### 1. Code Quality
- Cyclomatic complexity
- Method length
- Code duplication
- Naming conventions
- SOLID principle violations

### 2. Dependencies
- Outdated packages
- Security vulnerabilities
- Deprecated packages
- Version conflicts
- License compliance

### 3. Architecture
- Layer violations
- Circular dependencies
- Missing abstractions
- Anti-patterns
- Coupling/cohesion issues

### 4. Security
- Known vulnerabilities
- Hardcoded secrets
- SQL injection risks
- Authentication issues
- Configuration problems

### 5. Testing
- Test coverage gaps
- Test quality issues
- Missing test scenarios
- Flaky tests
- Test execution time

## Output

The analyzer provides:
1. **Executive Summary** - High-level findings and recommendations
2. **Detailed Analysis** - Specific issues with code examples
3. **Risk Assessment** - Security, performance, and maintainability risks
4. **Remediation Roadmap** - Prioritized action items with effort estimates
5. **Technical Debt Score** - Quantified debt in developer days

## Example Output

```markdown
## Technical Debt Analysis: src/PTA.VineyardManagement.Api

### Debt Overview
- **Total Debt**: 47 developer days
- **Monthly Interest**: 8 hours of additional work
- **Critical Issues**: 3 requiring immediate attention

### Key Risks
1. **Vulnerable Dependencies**: 2 packages with critical CVEs
2. **High Complexity**: 5 methods exceed complexity threshold
3. **Missing Tests**: 30% of business logic lacks coverage

### Recommended Actions
1. **Immediate** (This Week): Update vulnerable packages
2. **Short-term** (This Month): Refactor complex methods
3. **Long-term** (This Quarter): Improve test coverage
```

## Integration with CI/CD

The analyzer can be integrated into your CI/CD pipeline:

```yaml
# Azure DevOps Pipeline Example
- task: PowerShell@2
  displayName: 'Run Technical Debt Analysis'
  inputs:
    targetType: 'inline'
    script: |
      claude-code /analyze-technical-debt "src" --output-format=json
      # Parse results and fail build if debt exceeds threshold
```

## Creating Custom Analyzers

Use the generator template to create specialized analyzers:

```powershell
# Create React-specific analyzer
.\technical-debt-analyzer-generator.ps1 `
    -AnalyzerName "React" `
    -AnalyzerType "framework" `
    -TargetLanguages @("jsx", "tsx") `
    -Patterns @("Class components", "Direct state mutation") `
    -IncludeAgent -IncludeHook -IncludeTool
```

## Best Practices

1. **Regular Analysis**: Run weekly to track debt trends
2. **Focused Scans**: Analyze specific modules for faster results
3. **Team Reviews**: Review findings in team meetings
4. **Debt Budget**: Allocate time each sprint for debt reduction
5. **Metrics Tracking**: Monitor debt score over time

## Troubleshooting

### "Path does not exist" Error
Ensure you're providing a valid path relative to your current directory.

### Analysis Taking Too Long
- Narrow the scope to specific directories
- Use glob patterns to target specific file types
- Consider using shallow analysis depth

### Missing Dependencies
Some analysis features require external tools:
- `npm audit` for Node.js vulnerability scanning
- `dotnet list package` for .NET dependency analysis

## Related Commands
- `/review-backend-code` - Code review focused on quality
- `/analyze-legacy-system` - Legacy system modernization analysis
- `/optimize-performance` - Performance-focused analysis