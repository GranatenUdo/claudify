---
description: Security-focused research for vulnerabilities and best practices
allowed-tools: [Task, WebSearch, WebFetch, Grep, Read]
argument-hint: security concern or vulnerability type (e.g., "JWT validation", "SQL injection", "multi-tenant isolation")
---

# 🔒 Security Research: $ARGUMENTS

**For complex vulnerabilities or novel attack vectors, enable extended thinking for comprehensive threat analysis.**

## Phase 1: Parallel Security Analysis (2 minutes)

### 🛡️ Vulnerability Research Agent
@Task(
  description="Vulnerability and exploit research",
  prompt="Research security vulnerability '$ARGUMENTS':
  
  FIND:
  1. How is this vulnerability actually exploited?
  2. Real-world breaches caused by this
  3. OWASP/CWE classification and severity
  
  Search for:
  - CVE databases for recent exploits
  - GitHub security advisories
  - Real breach post-mortems
  
  Focus on:
  - Actual attack vectors (not theoretical)
  - Tools attackers use
  - Time to exploit
  
  Provide proof-of-concept if safe to demonstrate.",
  subagent_type="security-vulnerability-scanner"
)

### 🔐 Defense Research Agent
@Task(
  description="Defense and mitigation research",
  prompt="Research defenses for '$ARGUMENTS':
  
  FIND:
  1. Industry-standard prevention methods
  2. Framework-specific protections (.NET 9, Angular 19)
  3. Configuration best practices
  
  Look for:
  - Microsoft security guidance
  - OWASP prevention cheat sheets
  - Production-tested solutions
  
  Prioritize:
  - Simple, effective fixes
  - Defense in depth approach
  - Automated detection methods
  
  Include code examples that work in our stack.",
  subagent_type="security-vulnerability-scanner"
)

### 🔍 Codebase Vulnerability Scan
@Task(
  description="Check our codebase for this vulnerability",
  prompt="Scan our code for '$ARGUMENTS' vulnerabilities:
  
  CHECK:
  1. Direct vulnerability patterns
  2. Related risky patterns
  3. Missing protections
  
  Use Grep to find:
  - Vulnerable code patterns
  - Missing security attributes
  - TODO comments about security
  
  For each finding:
  - File:line location
  - Severity (Critical/High/Medium)
  - Specific fix required
  
  Be paranoid. Assume attackers know our code.",
  subagent_type="security-vulnerability-scanner"
)

## Phase 2: Synthesis (1 minute)

```markdown
# Security Research: $ARGUMENTS

## 🚨 Threat Assessment
**Severity**: [Critical/High/Medium/Low]
**Exploitability**: [Trivial/Easy/Moderate/Hard]
**Our Exposure**: [# of vulnerable points found]

## 🎯 Attack Vector
### How It Works
[Brief explanation of the attack]

### Real-World Example
[Actual breach or CVE example]

### Proof of Concept (if safe)
```code
// Demonstration of vulnerability
```

## 🛡️ Defense Strategy

### Immediate Fix (Today)
```csharp
// Code to fix the vulnerability
[Specific implementation]
```

### Long-term Protection (This Sprint)
1. [Systematic fix approach]
2. [Automated detection]
3. [Policy changes needed]

## 📍 Our Vulnerable Code

| Location | Severity | Fix Required |
|----------|----------|--------------|
| File:line | Critical | [Specific fix] |
| File:line | High | [Specific fix] |

## ✅ Action Items
- [ ] Apply immediate fix to [locations]
- [ ] Add security test for this pattern
- [ ] Update security guidelines
- [ ] Schedule team security training

## 🔗 References
- [OWASP Guide](link)
- [Microsoft Security](link)
- [CVE Details](link)
```

## What Makes This Effective

1. **Parallel analysis** - Attack and defense simultaneously
2. **Real-world focus** - Actual exploits, not theory
3. **Codebase-specific** - Finds OUR vulnerabilities
4. **Actionable fixes** - Copy-paste solutions
5. **Severity-based** - Prioritizes critical issues

## Convention Awareness

Security fixes are based on observed patterns in the codebase and work within your architecture, not against it.

Remember: Research that doesn't lead to patches is just FUD.