# Deployment Configuration Analyzer - Adapts to different orchestration platforms
# Analyzes Kubernetes, Docker Compose, CloudFormation, Terraform, and more

param(
    [string]$DeploymentPath = ".",
    [string]$Platform = "auto",  # auto, kubernetes, docker, terraform, cloudformation
    [switch]$SecurityScan,
    [switch]$CostAnalysis,
    [switch]$PerformanceCheck,
    [switch]$Verbose
)

Write-Host "🏗️ Infrastructure Deployment Analyzer" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan

# Auto-detect platform if not specified
if ($Platform -eq "auto") {
    Write-Host "`nDetecting deployment platform..." -ForegroundColor Yellow
    
    if (Get-ChildItem -Path $DeploymentPath -Include "*.yaml", "*.yml" -Recurse | 
        Select-String -Pattern "apiVersion:.*kubernetes|kind:.*Deployment|kind:.*Service" -Quiet) {
        $Platform = "kubernetes"
        Write-Host "✓ Detected Kubernetes manifests" -ForegroundColor Green
    }
    elseif (Test-Path (Join-Path $DeploymentPath "docker-compose*.yml")) {
        $Platform = "docker"
        Write-Host "✓ Detected Docker Compose" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $DeploymentPath -Include "*.tf" -Recurse) {
        $Platform = "terraform"
        Write-Host "✓ Detected Terraform" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $DeploymentPath -Include "*.bicep" -Recurse) {
        $Platform = "bicep"
        Write-Host "✓ Detected Azure Bicep" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $DeploymentPath -Include "template.json", "template.yaml" -Recurse |
        Select-String -Pattern "AWSTemplateFormatVersion" -Quiet) {
        $Platform = "cloudformation"
        Write-Host "✓ Detected AWS CloudFormation" -ForegroundColor Green
    }
}

# Initialize analysis results
$analysis = @{
    Platform = $Platform
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Summary = @{
        TotalResources = 0
        SecurityIssues = @()
        CostEstimate = @{
            Monthly = 0
            Yearly = 0
            Currency = "USD"
        }
        PerformanceMetrics = @()
        BestPractices = @()
        Warnings = @()
    }
    Resources = @()
    Recommendations = @()
}

# Platform-specific analyzers
switch ($Platform) {
    "kubernetes" {
        Write-Host "`nAnalyzing Kubernetes manifests..." -ForegroundColor Yellow
        
        $manifests = Get-ChildItem -Path $DeploymentPath -Include "*.yaml", "*.yml" -Recurse |
            Where-Object { $_.FullName -notmatch "node_modules|vendor" }
        
        foreach ($manifest in $manifests) {
            try {
                # Parse YAML (simplified - in production use proper YAML parser)
                $content = Get-Content $manifest.FullName -Raw
                
                # Extract resource info
                if ($content -match "kind:\s*(\w+)") {
                    $kind = $Matches[1]
                    $resource = @{
                        Type = "Kubernetes/$kind"
                        File = $manifest.Name
                        Issues = @()
                        Metrics = @{}
                    }
                    
                    # Security checks
                    if ($SecurityScan) {
                        # Check for security contexts
                        if ($kind -in @("Deployment", "StatefulSet", "DaemonSet", "Pod")) {
                            if ($content -notmatch "securityContext:") {
                                $resource.Issues += "Missing securityContext"
                                $analysis.Summary.SecurityIssues += "No security context in $($manifest.Name)"
                            }
                            
                            # Check for non-root user
                            if ($content -notmatch "runAsNonRoot:\s*true") {
                                $resource.Issues += "Container may run as root"
                            }
                            
                            # Check for privileged containers
                            if ($content -match "privileged:\s*true") {
                                $resource.Issues += "Privileged container detected"
                                $analysis.Summary.SecurityIssues += "Privileged container in $($manifest.Name)"
                            }
                        }
                        
                        # Check for resource limits
                        if ($kind -in @("Deployment", "StatefulSet", "DaemonSet")) {
                            if ($content -notmatch "limits:") {
                                $resource.Issues += "No resource limits defined"
                                $analysis.Summary.Warnings += "Missing resource limits in $($manifest.Name)"
                            }
                        }
                        
                        # Check for latest image tags
                        if ($content -match "image:.*:latest") {
                            $resource.Issues += "Using 'latest' image tag"
                            $analysis.Summary.Warnings += "Latest tag used in $($manifest.Name)"
                        }
                        
                        # Check for image pull policy
                        if ($content -notmatch "imagePullPolicy:") {
                            $resource.Issues += "No imagePullPolicy specified"
                        }
                    }
                    
                    # Multi-tenant checks
                    if ($content -match "namespace:") {
                        $resource.Metrics["HasNamespace"] = $true
                    } else {
                        $resource.Issues += "No namespace specified (will use default)"
                    }
                    
                    # Network policies
                    if ($kind -eq "NetworkPolicy") {
                        $analysis.Summary.BestPractices += "Network policies implemented"
                    }
                    
                    # Cost estimation for cloud providers
                    if ($CostAnalysis -and $kind -in @("Deployment", "StatefulSet")) {
                        if ($content -match "replicas:\s*(\d+)") {
                            $replicas = [int]$Matches[1]
                            $resource.Metrics["Replicas"] = $replicas
                            
                            # Rough cost estimate (would need cloud provider info)
                            $cpuRequest = 0.1  # Default assumption
                            if ($content -match "cpu:\s*[\"']?(\d+)m?[\"']?") {
                                $cpuRequest = [int]$Matches[1] / 1000.0
                            }
                            
                            $costPerCPUMonth = 25  # Rough estimate
                            $monthlyCost = $replicas * $cpuRequest * $costPerCPUMonth
                            $analysis.Summary.CostEstimate.Monthly += $monthlyCost
                        }
                    }
                    
                    $analysis.Resources += $resource
                    $analysis.Summary.TotalResources++
                }
            }
            catch {
                Write-Warning "Failed to parse $($manifest.Name): $_"
            }
        }
        
        # Kubernetes-specific recommendations
        if ($analysis.Resources | Where-Object { $_.Type -match "Deployment|StatefulSet" }) {
            if (-not ($analysis.Resources | Where-Object { $_.Type -eq "Kubernetes/HorizontalPodAutoscaler" })) {
                $analysis.Recommendations += "Consider adding HorizontalPodAutoscaler for auto-scaling"
            }
        }
        
        if (-not ($analysis.Resources | Where-Object { $_.Type -eq "Kubernetes/NetworkPolicy" })) {
            $analysis.Recommendations += "Implement NetworkPolicies for network segmentation"
        }
    }
    
    "docker" {
        Write-Host "`nAnalyzing Docker Compose files..." -ForegroundColor Yellow
        
        $composeFiles = Get-ChildItem -Path $DeploymentPath -Include "docker-compose*.yml", "docker-compose*.yaml" -Recurse
        
        foreach ($compose in $composeFiles) {
            $content = Get-Content $compose.FullName -Raw
            
            # Parse services (simplified)
            $services = @()
            if ($content -match "services:") {
                $serviceMatches = [regex]::Matches($content, "^\s{2}(\w+):", [System.Text.RegularExpressions.RegexOptions]::Multiline)
                foreach ($match in $serviceMatches) {
                    $serviceName = $match.Groups[1].Value
                    $resource = @{
                        Type = "Docker/Service"
                        Name = $serviceName
                        File = $compose.Name
                        Issues = @()
                    }
                    
                    # Security checks
                    if ($SecurityScan) {
                        # Check for user specification
                        if ($content -notmatch "$serviceName[\s\S]*?user:") {
                            $resource.Issues += "No user specified (may run as root)"
                        }
                        
                        # Check for capability drops
                        if ($content -notmatch "$serviceName[\s\S]*?cap_drop:") {
                            $resource.Issues += "No capabilities dropped"
                        }
                        
                        # Check for read-only root filesystem
                        if ($content -notmatch "$serviceName[\s\S]*?read_only:\s*true") {
                            $resource.Issues += "Root filesystem is not read-only"
                        }
                    }
                    
                    $services += $resource
                    $analysis.Summary.TotalResources++
                }
            }
            
            $analysis.Resources += $services
            
            # Docker Compose recommendations
            if ($content -notmatch "version:") {
                $analysis.Recommendations += "Specify Compose file version"
            }
            
            if ($content -notmatch "networks:") {
                $analysis.Recommendations += "Define custom networks for service isolation"
            }
        }
    }
    
    "terraform" {
        Write-Host "`nAnalyzing Terraform configurations..." -ForegroundColor Yellow
        
        $tfFiles = Get-ChildItem -Path $DeploymentPath -Include "*.tf" -Recurse
        
        foreach ($tf in $tfFiles) {
            $content = Get-Content $tf.FullName -Raw
            
            # Extract resources
            $resourceMatches = [regex]::Matches($content, 'resource\s+"([^"]+)"\s+"([^"]+)"')
            foreach ($match in $resourceMatches) {
                $resourceType = $match.Groups[1].Value
                $resourceName = $match.Groups[2].Value
                
                $resource = @{
                    Type = "Terraform/$resourceType"
                    Name = $resourceName
                    File = $tf.Name
                    Issues = @()
                }
                
                # Cloud-specific checks
                if ($resourceType -match "^aws_") {
                    # AWS security checks
                    if ($SecurityScan) {
                        if ($resourceType -eq "aws_s3_bucket" -and $content -notmatch "$resourceName[\s\S]*?server_side_encryption") {
                            $resource.Issues += "S3 bucket missing encryption"
                            $analysis.Summary.SecurityIssues += "Unencrypted S3 bucket: $resourceName"
                        }
                        
                        if ($resourceType -match "aws_db_instance|aws_rds_cluster" -and $content -match "$resourceName[\s\S]*?publicly_accessible\s*=\s*true") {
                            $resource.Issues += "Database is publicly accessible"
                            $analysis.Summary.SecurityIssues += "Public database: $resourceName"
                        }
                    }
                }
                elseif ($resourceType -match "^azurerm_") {
                    # Azure security checks
                    if ($SecurityScan) {
                        if ($resourceType -eq "azurerm_storage_account" -and $content -notmatch "$resourceName[\s\S]*?enable_https_traffic_only\s*=\s*true") {
                            $resource.Issues += "Storage account allows HTTP"
                            $analysis.Summary.SecurityIssues += "Storage allows HTTP: $resourceName"
                        }
                    }
                }
                
                $analysis.Resources += $resource
                $analysis.Summary.TotalResources++
            }
        }
        
        # Terraform best practices
        if (-not (Test-Path (Join-Path $DeploymentPath "terraform.tfvars")) -and 
            -not (Test-Path (Join-Path $DeploymentPath "terraform.tfvars.json"))) {
            $analysis.Recommendations += "Use terraform.tfvars for variable values"
        }
        
        if (-not ($tfFiles | Where-Object { $_.Name -eq "versions.tf" })) {
            $analysis.Recommendations += "Create versions.tf to pin provider versions"
        }
    }
}

# Performance analysis (if requested)
if ($PerformanceCheck) {
    Write-Host "`nRunning performance analysis..." -ForegroundColor Yellow
    
    # Platform-specific performance checks
    switch ($Platform) {
        "kubernetes" {
            # Check for anti-affinity rules
            $hasAntiAffinity = $analysis.Resources | Where-Object { 
                $_.File -match "deployment|statefulset" -and 
                (Get-Content (Join-Path $DeploymentPath $_.File) -Raw) -match "podAntiAffinity"
            }
            
            if (-not $hasAntiAffinity) {
                $analysis.Summary.PerformanceMetrics += @{
                    Metric = "Pod Distribution"
                    Status = "Warning"
                    Message = "No pod anti-affinity rules found"
                }
            }
            
            # Check for PodDisruptionBudget
            if (-not ($analysis.Resources | Where-Object { $_.Type -eq "Kubernetes/PodDisruptionBudget" })) {
                $analysis.Summary.PerformanceMetrics += @{
                    Metric = "Availability"
                    Status = "Warning"
                    Message = "No PodDisruptionBudget defined"
                }
            }
        }
    }
}

# Cost analysis summary
if ($CostAnalysis) {
    $analysis.Summary.CostEstimate.Yearly = $analysis.Summary.CostEstimate.Monthly * 12
    Write-Host "`nEstimated Costs:" -ForegroundColor Yellow
    Write-Host "  Monthly: `$$([Math]::Round($analysis.Summary.CostEstimate.Monthly, 2))" -ForegroundColor White
    Write-Host "  Yearly: `$$([Math]::Round($analysis.Summary.CostEstimate.Yearly, 2))" -ForegroundColor White
}

# Generate report
Write-Host "`n📊 Analysis Summary" -ForegroundColor Green
Write-Host "==================" -ForegroundColor Green
Write-Host "Platform: $Platform" -ForegroundColor White
Write-Host "Total Resources: $($analysis.Summary.TotalResources)" -ForegroundColor White

if ($analysis.Summary.SecurityIssues.Count -gt 0) {
    Write-Host "`n🔒 Security Issues ($($analysis.Summary.SecurityIssues.Count)):" -ForegroundColor Red
    $analysis.Summary.SecurityIssues | Select-Object -Unique | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor Yellow
    }
}

if ($analysis.Summary.Warnings.Count -gt 0) {
    Write-Host "`n⚠️  Warnings ($($analysis.Summary.Warnings.Count)):" -ForegroundColor Yellow
    $analysis.Summary.Warnings | Select-Object -Unique | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor Yellow
    }
}

if ($analysis.Summary.BestPractices.Count -gt 0) {
    Write-Host "`n✅ Best Practices Detected:" -ForegroundColor Green
    $analysis.Summary.BestPractices | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor Green
    }
}

if ($analysis.Recommendations.Count -gt 0) {
    Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
    $analysis.Recommendations | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor White
    }
}

# Export detailed report
$reportPath = "deployment-analysis-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
$analysis | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray

# Return analysis for pipeline use
return $analysis