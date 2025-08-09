# Claude Code Agents

This directory contains specialized AI agents that Claude Code can delegate to for specific tasks. Each agent has its own context window, expertise, and tools access.

## Agent Categories

### Technical Excellence
- **Code Quality**: Code Reviewer, Code Simplifier, Tech Lead
- **Security**: Security Reviewer
- **Architecture**: Technical Debt Analyst, Legacy System Analyzer

### Documentation & Communication
- **Technical Docs**: Technical Documentation Expert, Documentation Code Example Generator
- **Doc Quality**: Technical Documentation Accuracy, Documentation Readability Clarity, Documentation Consistency Checker

### Business & Marketing
- **Domain Analysis**: Business Domain Analyst, Feature Analyzer
- **Value Translation**: Customer Value Translator
- **Marketing**: Marketing Strategist, Sales Genius, Visual Designer (Marketing)

### User Experience
- **Frontend**: Frontend Developer, UX Reviewer
- **Design**: Visual Designer

### Research & Analysis
- **Deep Research**: Researcher
- **Test Analysis**: Test Quality Analyst

## Available Agents

### 🔍 Code Reviewer
**Expertise**: Multi-tenant SaaS security, domain-driven design, production systems

**Specializes in**:
- Enforcing organization-scoped queries (multi-tenant isolation)
- Result<T> pattern compliance
- Performance optimization (N+1 queries, caching strategies)
- Domain-driven design principles
- Testing coverage (80% target)

**When to use**: Code reviews, PR analysis, architecture compliance checks

---

### 🧹 Code Simplifier
**Expertise**: Refactoring complex code into maintainable solutions

**Specializes in**:
- Reducing cyclomatic complexity
- Extracting methods and common patterns
- Improving naming and readability
- Applying DRY principles
- Breaking down large classes/methods

**When to use**: Legacy code refactoring, complexity reduction, code cleanup

---

### 🔐 Security Reviewer
**Expertise**: OWASP compliance, multi-tenant isolation, data protection

**Specializes in**:
- Multi-tenant data isolation verification
- OWASP API Security Top 10
- Input validation and sanitization
- JWT and Auth0 security
- SQL injection prevention
- Domain-specific compliance (GDPR, industry regulations)

**When to use**: Security audits, penetration test preparation, compliance reviews

---

### 🏗️ Tech Lead
**Expertise**: Scalable SaaS architecture, team leadership, strategic technical decisions

**Specializes in**:
- System architecture and design patterns
- Technology selection and trade-offs
- Scalability planning (1K → 100K+ organizations)
- Technical debt management
- Migration strategies
- Team productivity and developer experience

**When to use**: Architecture decisions, technology evaluation, roadmap planning

---

### 🔬 Researcher
**Expertise**: Complex systems analysis, pattern recognition, strategic synthesis across technical and business domains

**Specializes in**:
- Multi-dimensional analysis (technical, business, operational)
- Pattern recognition and system decomposition
- Evidence-based research with actionable insights
- Domain expertise and industry best practices
- Strategic recommendations with implementation roadmaps
- Risk analysis and mitigation strategies

**When to use**: Deep research, feasibility studies, technology evaluation, strategic analysis

---

### 🎨 UX Reviewer
**Expertise**: User interfaces, accessibility, domain-specific usability

**Specializes in**:
- WCAG 2.1 AA compliance
- Mobile-first interfaces
- Domain-specific UI requirements
- Touch targets and gesture support
- Internationalization
- Offline-capable interfaces

**When to use**: UI reviews, accessibility audits, mobile optimization

---

### 🧪 Test Quality Analyst
**Expertise**: Test coverage analysis, test design patterns, quality metrics

**Specializes in**:
- Coverage intelligence (line, branch, path, mutation)
- Test anti-pattern detection
- Test pyramid optimization
- Framework-specific best practices (.NET, Angular)
- Flakiness detection and elimination
- Test performance optimization

**When to use**: Test quality assessment, coverage gap analysis, test refactoring

## How Agents Work

1. **Independent Context**: Each agent maintains its own context window, preventing main Claude's context from being consumed
2. **Parallel Execution**: Up to 10 agents can work simultaneously
3. **Specialized Knowledge**: Each agent has deep expertise in their domain
4. **Tool Access**: Agents have access to specific tools relevant to their role

## Usage Examples

```
# Claude automatically delegates to appropriate agents:

"Review the security of this new API endpoint"
→ Security Reviewer agent activated

"This component is too complex, help me simplify it"
→ Code Simplifier agent activated

"What's the best architecture for handling 50K concurrent users?"
→ Tech Lead agent activated

"Is this form accessible for mobile users?"
→ UX Reviewer agent activated

"Review this PR for production readiness"
→ Code Reviewer agent activated

"Research the best approach for implementing feature X"
→ Researcher agent activated

"Analyze our test coverage and identify gaps"
→ Test Quality Analyst agent activated
```

## Agent Collaboration

Agents can work together on complex tasks:

```
"Review this new feature end-to-end"
→ Tech Lead: Architecture review
→ Security Reviewer: Security audit
→ Code Reviewer: Code quality check
→ UX Reviewer: Interface assessment
→ Combined report with all perspectives
```

## Domain Context

All agents understand the specific requirements of your domain and will adapt their analysis accordingly. They reference:
- CLAUDE.md for project-specific patterns
- FEATURES.md for implemented functionality
- Domain configuration for business rules

## Configuration

Each agent is configured with:
- Only official Claude Code YAML fields (name, description, tools)
- Extended thinking via `MAX_THINKING_TOKENS` in `.claude/settings.json` (project-level)
- Specific tools relevant to their expertise (comma-separated list)
- System prompts incorporating domain knowledge
- Understanding of project documentation (CLAUDE.md, FEATURES.md)

