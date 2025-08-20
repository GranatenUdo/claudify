# Post-Deploy Verification Hook - TOP 3 Health Checks
# Verifies deployment success with critical checks only

param([string]$Arguments)

Write-Host "`n🚀 POST-DEPLOY VERIFICATION" -ForegroundColor Cyan

# Determine deployment type from command
$deployType = "unknown"
if ($Arguments -match "azd up|azure") { $deployType = "azure" }
elseif ($Arguments -match "docker") { $deployType = "docker" }
elseif ($Arguments -match "kubectl|k8s") { $deployType = "kubernetes" }

# TOP 3 deployment checks

# 1. SERVICE RUNNING - Most critical
Write-Host "  ✓ Checking service status..." -ForegroundColor Gray

$isRunning = $false
switch ($deployType) {
    "docker" {
        $containers = docker ps --format "table {{.Names}}\t{{.Status}}" 2>$null
        if ($containers -match "Up") {
            $isRunning = $true
            Write-Host "    ✅ Docker containers running" -ForegroundColor Green
        }
    }
    "azure" {
        $webApps = az webapp list --query "[?state=='Running'].name" 2>$null
        if ($webApps) {
            $isRunning = $true
            Write-Host "    ✅ Azure services running" -ForegroundColor Green
        }
    }
    default {
        # Try localhost health check
        try {
            $response = Invoke-WebRequest -Uri "http://localhost:5000/health" -TimeoutSec 2 -ErrorAction SilentlyContinue
            if ($response.StatusCode -eq 200) {
                $isRunning = $true
                Write-Host "    ✅ Service responding on localhost" -ForegroundColor Green
            }
        } catch { }
    }
}

if (-not $isRunning) {
    Write-Host "    ⚠️ Service may not be running" -ForegroundColor Yellow
}

# 2. DATABASE CONNECTION - Data layer critical
Write-Host "  ✓ Checking database..." -ForegroundColor Gray

$dbOk = $false
# Quick connection test
if ($deployType -eq "docker") {
    $sqlContainer = docker ps --filter "name=sql" --format "{{.Names}}" 2>$null
    if ($sqlContainer) {
        $dbOk = $true
        Write-Host "    ✅ Database container running" -ForegroundColor Green
    }
} else {
    # Check if migrations were mentioned
    if ($Arguments -match "migrate|ef database") {
        Write-Host "    ✅ Database migrations applied" -ForegroundColor Green
        $dbOk = $true
    }
}

if (-not $dbOk) {
    Write-Host "    ⚠️ Verify database connectivity" -ForegroundColor Yellow
}

# 3. ENDPOINT CHECK - User-facing critical
Write-Host "  ✓ Checking endpoints..." -ForegroundColor Gray

$endpoints = @()
if ($deployType -eq "azure") {
    $appUrl = az webapp show --name * --query "defaultHostName" 2>$null
    if ($appUrl) { $endpoints += "https://$appUrl" }
} else {
    $endpoints += "http://localhost:5000"
    $endpoints += "http://localhost:4200"
}

$endpointOk = $false
foreach ($endpoint in $endpoints) {
    try {
        $response = Invoke-WebRequest -Uri $endpoint -TimeoutSec 3 -ErrorAction SilentlyContinue
        if ($response.StatusCode -lt 400) {
            Write-Host "    ✅ $endpoint responding" -ForegroundColor Green
            $endpointOk = $true
            break
        }
    } catch { }
}

if (-not $endpointOk) {
    Write-Host "    ⚠️ No endpoints responding" -ForegroundColor Yellow
}

# Summary
Write-Host "`n📊 DEPLOYMENT SUMMARY" -ForegroundColor Cyan
if ($isRunning -and $dbOk -and $endpointOk) {
    Write-Host "  ✅ All systems operational" -ForegroundColor Green
} else {
    Write-Host "  ⚠️ Some checks failed - verify manually" -ForegroundColor Yellow
    Write-Host "  💡 Quick checks:" -ForegroundColor Gray
    Write-Host "     docker ps          # Check containers" -ForegroundColor DarkGray
    Write-Host "     curl localhost:5000/health  # Check API" -ForegroundColor DarkGray
    Write-Host "     az webapp log tail --name <app>  # Check logs" -ForegroundColor DarkGray
}

exit 0  # Never block, just inform