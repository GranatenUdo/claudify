# Agent Reference

This document describes the available agents and their capabilities.

## Core Agents

### code-reviewer
- **Purpose**: Reviews code for quality, standards, and best practices
- **Allowed Tools**: Read, Edit, MultiEdit, Grep, Glob, LS
- **Use Cases**: Post-implementation reviews, refactoring validation, pattern compliance
- **Included In**: Minimal installation

### security-reviewer
- **Purpose**: Identifies security vulnerabilities and risks
- **Allowed Tools**: Read, Grep, Glob, LS, WebSearch, Bash
- **Use Cases**: Security audits, vulnerability scanning, compliance checks
- **Included In**: Comprehensive installation

### tech-lead
- **Purpose**: Provides architectural guidance and technical decisions
- **Allowed Tools**: Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite
- **Use Cases**: System design, architectural reviews, technical planning
- **Included In**: Comprehensive installation

## Frontend Agents

### frontend-developer
- **Purpose**: Implements frontend features and UI components
- **Allowed Tools**: Read, Write, Edit, MultiEdit, Grep, Glob, LS
- **Use Cases**: Component development, UI implementation, frontend bug fixes
- **Included In**: Comprehensive installation (when frontend detected)

### ux-reviewer
- **Purpose**: Reviews UX design and accessibility
- **Allowed Tools**: Read, Grep, Glob, LS, WebFetch
- **Use Cases**: Usability reviews, accessibility audits, design feedback
- **Included In**: Comprehensive installation (when frontend detected)

## Quality Agents

### test-quality-analyst
- **Purpose**: Analyzes test coverage and quality
- **Allowed Tools**: Read, Write, Edit, Grep, Glob, LS, Bash
- **Use Cases**: Test coverage analysis, test strategy, quality metrics
- **Included In**: Comprehensive installation

### technical-debt-analyst
- **Purpose**: Identifies and tracks technical debt
- **Allowed Tools**: Read, Grep, Glob, LS
- **Use Cases**: Debt assessment, refactoring priorities, maintenance planning
- **Included In**: Comprehensive installation

## Infrastructure Agents

### infrastructure-architect
- **Purpose**: Designs and configures infrastructure
- **Allowed Tools**: Read, Write, Edit, Grep, Glob, LS, Bash
- **Use Cases**: Docker configuration, Kubernetes setup, CI/CD pipelines
- **Included In**: Comprehensive installation

## Agent Tool Restrictions

Each agent has specific tool access based on the principle of least privilege:

| Agent | Read | Write | Edit | Grep | Glob | LS | Bash | Other |
|-------|------|-------|------|------|------|----|------|-------|
| code-reviewer | ✓ | - | ✓ | ✓ | ✓ | ✓ | - | MultiEdit |
| security-reviewer | ✓ | - | - | ✓ | ✓ | ✓ | ✓ | WebSearch |
| tech-lead | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - | MultiEdit, TodoWrite |
| frontend-developer | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - | MultiEdit |
| ux-reviewer | ✓ | - | - | ✓ | ✓ | ✓ | - | WebFetch |
| test-quality-analyst | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - |
| technical-debt-analyst | ✓ | - | - | ✓ | ✓ | ✓ | - | - |
| infrastructure-architect | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | - |

## Using Agents

Agents are typically invoked through commands. For example:
- `/comprehensive-review` uses multiple agents in parallel
- `/add-backend-feature` uses the tech-lead agent
- `/fix-frontend-bug` uses the frontend-developer agent

## Agent Selection

The setup script recommends agents based on your project type:
- **.NET projects**: code-reviewer, security-reviewer, tech-lead
- **Angular projects**: frontend-developer, ux-reviewer
- **Multi-tenant apps**: security-reviewer (with tenant validation hooks)
- **Legacy systems**: technical-debt-analyst

## Notes

- Agents operate independently with their own context
- Multiple agents can run in parallel for faster results
- Each agent follows the patterns defined in your CLAUDE.md file
- Tool restrictions ensure agents can't perform unauthorized operations