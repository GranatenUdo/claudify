# Security Secrets Detection Hook - Blocks exposed credentials
# Prevents accidental commit of secrets, keys, and passwords

param(
    [string]$ToolName,
    [string]$Content
)

# TOP 3 secret patterns to block

$secrets = @()

# 1. API KEYS & TOKENS - Most common leak
if ($Content -match '(?i)(api[_-]?key|apikey|api_secret|access[_-]?token)\s*[:=]\s*["'']([a-zA-Z0-9+/]{20,})["'']') {
    $secrets += "API key or token detected"
}

# Azure/AWS/Google Cloud keys
if ($Content -match '(?i)(DefaultEndpointsProtocol|AccountKey|aws_access_key|aws_secret|google.*api.*key)\s*=\s*["''][^"'']+["'']') {
    $secrets += "Cloud provider credentials detected"
}

# JWT tokens
if ($Content -match 'eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}') {
    $secrets += "JWT token detected"
}

# 2. PASSWORDS - Critical security risk
if ($Content -match '(?i)password\s*[:=]\s*["''][^"'']{6,}["'']' -and 
    $Content -notmatch '(?i)password\s*[:=]\s*["''](prompt|ask|input|\$\{|\$\(|env\.|process\.env)') {
    $secrets += "Hardcoded password detected"
}

# Connection strings with passwords
if ($Content -match '(?i)(connection[_-]?string|conn[_-]?str|database[_-]?url|mongodb://|postgres://|mysql://).*password\s*=\s*[^;\s]+') {
    $secrets += "Connection string with password detected"
}

# 3. PRIVATE KEYS - Severe risk
if ($Content -match '-----BEGIN (RSA |EC |DSA |OPENSSH )?PRIVATE KEY-----') {
    $secrets += "Private key detected"
}

# GitHub/GitLab/Bitbucket tokens
if ($Content -match '(?i)(gh[ps]_[a-zA-Z0-9]{36}|gitlab[_-]?token|bitbucket[_-]?token)\s*[:=]\s*["''][^"'']+["'']') {
    $secrets += "Git service token detected"
}

# Report findings
if ($secrets.Count -gt 0) {
    Write-Host "`n🚨 SECURITY ALERT - SECRETS DETECTED" -ForegroundColor Red
    Write-Host "════════════════════════════════════" -ForegroundColor Red
    
    foreach ($secret in $secrets) {
        Write-Host "  ❌ $secret" -ForegroundColor Yellow
    }
    
    Write-Host "`n⚠️  OPERATION BLOCKED" -ForegroundColor Red
    Write-Host "  Secrets must not be committed to version control" -ForegroundColor White
    
    Write-Host "`n💡 SOLUTIONS:" -ForegroundColor Cyan
    Write-Host "  1. Use environment variables: process.env.API_KEY" -ForegroundColor Gray
    Write-Host "  2. Use user secrets: dotnet user-secrets" -ForegroundColor Gray
    Write-Host "  3. Use Azure Key Vault or similar service" -ForegroundColor Gray
    Write-Host "  4. Add to .gitignore if config file" -ForegroundColor Gray
    
    exit 2  # Block the operation
}

exit 0  # No secrets found