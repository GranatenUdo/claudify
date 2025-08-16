---
description: Parallel security audit with 5 specialized agents checking different attack vectors
allowed-tools: [Task, Read, Grep, Glob, Bash]
argument-hint: scope to audit (e.g., "all", "api", "frontend", "infrastructure")
complexity: moderate
estimated-time: 1-2 minutes (parallel execution)
category: security
---

# 🔒 Parallel Security Audit: $ARGUMENTS

## Parallel Multi-Vector Security Analysis (60 seconds)

### 🛡️ Application Security Agent
@Task(
  description="Application security scan",
  prompt="Audit application security for '$ARGUMENTS':
  
  CRITICAL CHECKS:
  1. Multi-tenant data isolation
     - Missing OrganizationId filters
     - Cross-tenant data access risks
  2. Authentication/Authorization
     - Missing [Authorize] attributes
     - userId in URLs instead of JWT
  3. Input validation
     - SQL injection risks
     - XSS vulnerabilities
  
  Use Grep to find:
  - '.ToListAsync()' without OrganizationId
  - Controllers without [Authorize]
  - String concatenation in SQL queries
  - Unsafe HTML rendering
  
  Return CRITICAL vulnerabilities with:
  - File:line location
  - Proof of concept
  - Fix code
  
  Focus on exploitable issues only.",
  subagent_type="security-reviewer"
)

### 🔑 Secrets & Credentials Agent
@Task(
  description="Secrets exposure scan",
  prompt="Scan for exposed secrets in '$ARGUMENTS':
  
  SEARCH FOR:
  1. Hardcoded credentials
     - Passwords in code
     - API keys in source
     - Connection strings with passwords
  2. Sensitive data in logs
     - PII being logged
     - Tokens in error messages
  3. Configuration issues
     - Secrets in appsettings.json
     - Keys in frontend code
  
  Use Grep patterns:
  - 'password\\s*=\\s*[\"'][^\"']+[\"']'
  - 'api[_-]?key\\s*=\\s*[\"'][^\"']+[\"']'
  - 'token\\s*[:=]\\s*[\"'][^\"']+[\"']'
  - 'connectionstring.*password'
  
  Return each finding with:
  - Severity level
  - Immediate action required
  - Proper secret management approach",
  subagent_type="security-reviewer"
)

### 🌐 Infrastructure Security Agent
@Task(
  description="Infrastructure security scan",
  prompt="Audit infrastructure security for '$ARGUMENTS':
  
  CHECK:
  1. Container security
     - Dockerfile vulnerabilities
     - Running as root
     - Exposed unnecessary ports
  2. CORS configuration
     - Overly permissive origins
     - Credential inclusion risks
  3. Network exposure
     - Unnecessary public endpoints
     - Missing TLS/HTTPS
  4. Cloud configuration
     - Public storage buckets
     - Excessive IAM permissions
  
  Review files:
  - Dockerfile
  - docker-compose.yml
  - appsettings.json (CORS section)
  - .github/workflows/*.yml
  
  Return infrastructure risks with:
  - Attack scenario
  - Mitigation steps",
  subagent_type="infrastructure-architect"
)

### 🔐 Authentication & Session Agent
@Task(
  description="Auth and session security scan",
  prompt="Audit authentication/session for '$ARGUMENTS':
  
  ANALYZE:
  1. JWT implementation
     - Token validation logic
     - Expiration handling
     - Refresh token security
  2. Session management
     - Session fixation risks
     - Concurrent session handling
  3. Password policies
     - Weak password acceptance
     - Missing password complexity
     - No rate limiting on login
  4. MFA implementation
     - Is MFA enforced?
     - Backup codes security
  
  Check for:
  - JWT signature validation
  - Token storage in frontend
  - Password reset flow
  - Account lockout policies
  
  Return auth vulnerabilities with:
  - Attack vector
  - Risk level
  - Implementation fix",
  subagent_type="security-reviewer"
)

### 📊 Compliance & Audit Agent
@Task(
  description="Compliance and audit scan",
  prompt="Check compliance requirements for '$ARGUMENTS':
  
  VERIFY:
  1. Data privacy (GDPR/CCPA)
     - PII handling
     - Right to deletion
     - Data retention policies
  2. Audit logging
     - Security events logged
     - Data access tracking
     - Change audit trail
  3. Encryption
     - Data at rest encryption
     - Data in transit (TLS)
     - Key management
  4. Backup & Recovery
     - Backup encryption
     - Recovery procedures
     - Data integrity checks
  
  Review:
  - Logging implementations
  - Data models for PII
  - Encryption configurations
  - Backup procedures
  
  Return compliance gaps with:
  - Regulation violated
  - Business impact
  - Remediation priority",
  subagent_type="business-domain-analyst"
)

## 🎯 Consolidated Security Report

After parallel analysis:

```markdown
# Security Audit Report: $ARGUMENTS
Generated: $(date)

## 🔴 CRITICAL - Immediate Action Required
### Issue #1: [Multi-tenant Data Breach Risk]
- **Location**: FieldRepository.cs:45
- **Evidence**: No OrganizationId filter
- **Impact**: Complete data breach
- **Fix**: [Provided code]
- **Time to fix**: 5 minutes

### Issue #2: [Hardcoded API Key]
- **Location**: EmailService.cs:23
- **Evidence**: SendGrid key in source
- **Impact**: Service compromise
- **Fix**: Move to KeyVault
- **Time to fix**: 15 minutes

## 🟠 HIGH - Fix This Sprint
### Issue #3: [Missing Authorization]
- **Location**: ReportsController.cs
- **Evidence**: No [Authorize] attribute
- **Impact**: Unauthorized access
- **Fix**: Add authorization
- **Time to fix**: 2 minutes

## 🟡 MEDIUM - Plan for Next Sprint
### Issue #4: [Weak Session Management]
- **Evidence**: No session timeout
- **Impact**: Session hijacking
- **Fix**: Implement timeout
- **Time to fix**: 1 hour

## 📊 Security Scorecard
| Category | Score | Status |
|----------|-------|--------|
| Multi-tenant Isolation | 3/10 | ❌ CRITICAL |
| Authentication | 7/10 | ⚠️ NEEDS WORK |
| Secrets Management | 4/10 | ❌ CRITICAL |
| Infrastructure | 8/10 | ✅ GOOD |
| Compliance | 6/10 | ⚠️ GAPS EXIST |
| **OVERALL** | **5.6/10** | **❌ HIGH RISK** |

## 🚀 Remediation Priority
1. **Today**: Fix all CRITICAL issues (est. 2 hours)
2. **This Week**: Address HIGH issues (est. 4 hours)
3. **This Sprint**: Close MEDIUM gaps (est. 8 hours)
4. **Next Quarter**: Achieve 8+/10 score

## 🛡️ Quick Fixes Available
```bash
# Add authorization to all controllers
find . -name "*Controller.cs" -exec sed -i 's/public class/[Authorize]\npublic class/g' {} \;

# Find all hardcoded secrets
grep -r "password\|api[_-]key\|token" --include="*.cs" --include="*.json"

# Add organization filtering
/fix-tenant-isolation all
```

## 📋 Compliance Status
- [ ] GDPR: 60% compliant (missing data deletion)
- [ ] SOC2: 70% ready (need audit logs)
- [ ] HIPAA: N/A
- [ ] PCI DSS: N/A
```

## Parallel Execution Advantages
- **Comprehensive**: 5 specialized agents check all vectors
- **Fast**: 60 seconds vs 10+ minutes sequential
- **Thorough**: No blind spots
- **Actionable**: Specific fixes provided
- **Prioritized**: Risk-based ordering

Remember: Fix CRITICAL issues immediately - they're being exploited in the wild.