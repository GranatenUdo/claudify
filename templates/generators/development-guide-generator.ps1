# Development Guide Generator Script
# Generates comprehensive development guide with all details that don't belong in CLAUDE.md

param(
    [Parameter(Mandatory=$true)]
    [PSCustomObject]$Analysis,
    
    [Parameter(Mandatory=$true)]
    [string]$BusinessDomain,
    
    [Parameter(Mandatory=$true)]
    [string]$OutputPath
)

$ErrorActionPreference = "Stop"

function Generate-SetupInstructions {
    param($TechStack)
    
    $setup = @"
## 🛠️ DEVELOPMENT SETUP

### Initial Setup (One Time)
``````bash
"@
    
    if ($TechStack.Backend.Framework -match "\.NET") {
        $setup += @"
# Install .NET SDK
winget install Microsoft.DotNet.SDK.$($TechStack.Backend.Version)

"@
    }
    
    if ($TechStack.Frontend.Framework) {
        $setup += @"
# Install Node.js
winget install OpenJS.NodeJS.LTS

"@
    }
    
    $setup += @"
# Run setup script from repository root
.\scripts\setup\setup-developer-environment.ps1
``````

### Daily Development Flow
``````bash
"@
    
    if ($TechStack.Orchestration -eq "Aspire") {
        $setup += @"
# 1. Start Aspire (includes all services)
cd src
dotnet run --project *AppHost
"@
    }
    elseif ($TechStack.Orchestration -eq "Docker") {
        $setup += @"
# 1. Start all services
docker-compose up -d
"@
    }
    else {
        if ($TechStack.Backend.Framework -match "ASP.NET") {
            $setup += @"
# 1. Start API
cd src
dotnet run
"@
        }
    }
    
    if ($TechStack.Frontend.Framework) {
        $setup += @"

# 2. Start Frontend (separate terminal)
cd src/*Web
npm start
"@
    }
    
    $setup += @"

# 3. Access points
"@
    
    if ($TechStack.Frontend.Framework) {
        $setup += @"
# Frontend: http://localhost:4200
"@
    }
    
    if ($TechStack.Backend.Framework -match "ASP.NET") {
        $setup += @"
# API: https://localhost:7028/swagger
"@
    }
    
    if ($TechStack.Orchestration -eq "Aspire") {
        $setup += @"
# Aspire Dashboard: http://localhost:15888
"@
    }
    
    $setup += @"
``````
"@
    
    return $setup
}

function Generate-TestingSection {
    param($TechStack)
    
    $testing = @"

## 🧪 TESTING

### Running Tests
``````bash
"@
    
    if ($TechStack.Backend.Framework -match "\.NET") {
        $testing += @"
# Backend tests
dotnet test

# Integration tests
cd src/*IntegrationTests
dotnet test

# Architecture compliance tests
dotnet test --filter "FullyQualifiedName~Architecture"
"@
    }
    
    if ($TechStack.Frontend.Framework) {
        $testing += @"

# Frontend tests
npm test

# Coverage report
npm run test:coverage

# E2E tests
npm run e2e
"@
    }
    
    $testing += @"
``````

### Test Scripts & Utilities
All test scripts are organized in the ``/scripts`` folder:

- ``/scripts/test-*/`` - Feature-specific test scripts
- ``/scripts/infrastructure/`` - System validation scripts  
- ``/scripts/setup/`` - Environment setup scripts
- ``/scripts/database/`` - Database utility scripts
- ``/scripts/README.md`` - Comprehensive documentation
"@
    
    return $testing
}

function Generate-DatabaseSection {
    param($TechStack)
    
    if ($TechStack.Database.Count -eq 0) {
        return ""
    }
    
    $db = @"

## 💾 DATABASE OPERATIONS
"@
    
    if ($TechStack.Backend.Framework -match "\.NET" -and $TechStack.Database -contains "SQL Server") {
        $db += @"

### Migrations
``````bash
# Create new migration
dotnet ef migrations add MigrationName

# IMPORTANT: DO NOT manually update database!
# MigrationService auto-applies migrations when app starts
``````
"@
    }
    elseif ($TechStack.Backend.Framework -match "Node" -and $TechStack.Database -contains "PostgreSQL") {
        $db += @"

### Migrations
``````bash
# Create new migration
npm run migration:create MigrationName

# Run migrations
npm run migration:run
``````
"@
    }
    
    return $db
}

function Generate-CommandsSection {
    $commands = @"

## 💡 DEVELOPER COMMANDS

### Core Development Commands
- ``/add-backend-feature [description]`` - Create new backend feature with DDD
- ``/add-frontend-feature [description]`` - Create frontend following backend-first workflow
- ``/fix-backend-bug [description]`` - Debug backend issues with deep analysis
- ``/fix-frontend-bug [description]`` - Fix frontend issues systematically
- ``/review-backend-code [file/path]`` - Security & performance review
- ``/review-frontend-code [file/path]`` - Accessibility & UX review
- ``/do-extensive-research [topic]`` - Deep architectural analysis
- ``/run-ci-pipeline [options]`` - Execute full CI/CD pipeline locally

### Specialized Commands
- ``/generate-documentation [type] [target]`` - Generate technical documentation
- ``/generate-marketing-material [type] [audience]`` - Create sales content
- ``/update-changelog`` - Update CHANGELOG.md with recent changes
- ``/analyze-technical-debt`` - Comprehensive technical debt analysis
"@
    
    return $commands
}

# Generate the development guide
$guide = @"
# Development Guide - $BusinessDomain

This guide contains detailed setup, testing, and troubleshooting information. For essential rules and patterns, see [CLAUDE.md](../CLAUDE.md).

$(Generate-SetupInstructions $Analysis.TechStack)

$(Generate-TestingSection $Analysis.TechStack)

$(Generate-DatabaseSection $Analysis.TechStack)

## 🚀 CI/CD PIPELINE

### Local Pipeline Execution
``````bash
/run-ci-pipeline --coverage --environment=ci
/run-ci-pipeline --skipUnit --skipIntegration  # E2E only
/run-ci-pipeline --testFilter="*" --verbose
``````

Options:
- ``--coverage`` - Generate coverage reports
- ``--skipUnit``, ``--skipIntegration``, ``--skipE2E`` - Skip test types
- ``--environment=[local|ci|staging]`` - Environment configuration
- ``--useDocker`` - Use docker-compose.ci.yml
- ``--testFilter`` - Filter tests by name pattern

$(Generate-CommandsSection)

## 🎯 COMMON DEVELOPER TASKS

### Adding a New Feature
1. Use ``/add-backend-feature`` to create backend first
2. Verify API endpoint works via Swagger
3. Update FEATURES.md immediately
4. Use ``/add-frontend-feature`` to create frontend
5. Run all tests before committing

### Debugging Tips
1. Check organization/tenant scoping - every query needs proper filtering
2. Use Result<T> pattern - no throwing exceptions
3. Check caching keys include tenant identifier
4. Verify authentication claims are properly validated
5. Ensure all coordinates use the correct system

## 🔍 TROUBLESHOOTING

### Common Issues

**Authentication Not Working**
``````bash
# Check auth configuration
dotnet user-secrets list

# Use development auth header (if configured)
curl -H "X-Dev-Auth: tenant_123:dev@example.com:true" https://localhost:7028/api/v1/testauth/me
``````

**Build Errors**
- Run ``/fix-frontend-build-and-tests`` for frontend issues
- Run ``/fix-backend-build-and-tests`` for backend issues
- Check for missing package references
- Verify SDK versions match

**Multi-Tenant Issues**
- Verify tenant context is properly injected
- Check repository queries include tenant filter
- Validate cache keys include tenant identifier
- Review authentication claims

## 📋 PR CHECKLIST

Before submitting a PR, ensure:
- [ ] All tests pass (100% pass rate required)
- [ ] FEATURES.md updated if adding features
- [ ] CHANGELOG.md updated for significant changes
- [ ] No phantom properties without DB backing
- [ ] Organization/tenant scoping verified
- [ ] Result<T> pattern used for services
- [ ] Caching invalidated after writes
- [ ] No arbitrary delays (setTimeout)
- [ ] Security review completed
- [ ] Documentation updated
- [ ] No user input in security-sensitive parameters
- [ ] Authentication properly validated

## 🚨 PERFORMANCE GUIDELINES

- Cache read operations (1-5 min TTL)
- Invalidate cache after writes
- Use pagination for large datasets
- Implement async/await properly
- Monitor bundle size (<250KB target)
- Use database indexes appropriately
- Profile critical paths

## 🤖 CLAUDE CODE OPTIMIZATION

### Memory Usage
- CLAUDE.md auto-loads when Claude Code starts
- Use ``#`` prefix to add quick memories
- Review with ``/memory`` command quarterly

### Extended Thinking Triggers
- Architecture changes: "think harder about security implications"
- Complex bugs: "think step-by-step through the data flow"
- Performance: "analyze caching strategy before implementing"

### File References
Use @ syntax for context:
- @src/Domain/Models
- @src/Services
- @src/Frontend/Components

## 📚 ADDITIONAL RESOURCES

- [FEATURES.md](../FEATURES.md) - Complete feature documentation
- [CHANGELOG.md](../CHANGELOG.md) - Version history and changes
- [Architecture Documentation](./architecture/) - System design docs
- [API Documentation](./api/) - API reference
- [Scripts README](../scripts/README.md) - Script documentation
"@

# Write the file
$guide | Out-File -FilePath $OutputPath -Encoding UTF8

Write-Host "✓ Generated DEVELOPMENT-GUIDE.md at $OutputPath" -ForegroundColor Green