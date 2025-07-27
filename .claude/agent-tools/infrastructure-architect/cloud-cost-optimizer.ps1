# Cloud Cost Optimizer - Analyzes and optimizes cloud resource costs
# Supports Azure, AWS, and GCP with intelligent recommendations

param(
    [string]$CloudProvider = "auto",  # auto, azure, aws, gcp
    [string]$ResourcePath = ".",
    [string]$SubscriptionId = "",
    [string]$ResourceGroup = "",
    [switch]$GenerateReport,
    [switch]$ShowSavings,
    [switch]$IncludeReserved
)

Write-Host "💰 Cloud Cost Optimizer - Claudify Edition" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Initialize cost analysis
$costAnalysis = @{
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Provider = $CloudProvider
    CurrentCosts = @{
        Monthly = 0
        Yearly = 0
        ByService = @{}
        ByResource = @()
    }
    OptimizedCosts = @{
        Monthly = 0
        Yearly = 0
        PotentialSavings = 0
        SavingsPercentage = 0
    }
    Recommendations = @()
    QuickWins = @()
    ReservedInstanceOpportunities = @()
}

# Auto-detect cloud provider from files
if ($CloudProvider -eq "auto") {
    Write-Host "`nDetecting cloud provider..." -ForegroundColor Yellow
    
    if (Get-ChildItem -Path $ResourcePath -Include "*.bicep", "azuredeploy.json" -Recurse -ErrorAction SilentlyContinue) {
        $CloudProvider = "azure"
        Write-Host "✓ Detected Azure resources" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $ResourcePath -Include "*.tf" -Recurse -ErrorAction SilentlyContinue | 
            Select-String -Pattern "provider.*aws|resource.*aws_" -Quiet) {
        $CloudProvider = "aws"
        Write-Host "✓ Detected AWS resources" -ForegroundColor Green
    }
    elseif (Get-ChildItem -Path $ResourcePath -Include "*.tf" -Recurse -ErrorAction SilentlyContinue | 
            Select-String -Pattern "provider.*google|resource.*google_" -Quiet) {
        $CloudProvider = "gcp"
        Write-Host "✓ Detected GCP resources" -ForegroundColor Green
    }
}

# Common cost optimization patterns
function Get-CommonOptimizations {
    param($Resource, $Provider)
    
    $optimizations = @()
    
    # Check for over-provisioned resources
    if ($Resource.Type -match "VM|Instance|Compute") {
        if ($Resource.Size -match "Standard_D8|m5.2xlarge|n1-standard-8" -and $Resource.Metrics.AvgCPU -lt 20) {
            $optimizations += @{
                Type = "Right-sizing"
                Current = $Resource.Size
                Recommended = "Smaller instance (2-4 vCPUs)"
                MonthlySavings = $Resource.MonthlyCost * 0.5
                Effort = "Low"
                Risk = "Low"
            }
        }
    }
    
    # Storage optimization
    if ($Resource.Type -match "Storage|Disk") {
        if ($Resource.Tier -eq "Premium" -and $Resource.Metrics.IOPS -lt 500) {
            $optimizations += @{
                Type = "Storage Tier"
                Current = "Premium SSD"
                Recommended = "Standard SSD"
                MonthlySavings = $Resource.MonthlyCost * 0.3
                Effort = "Low"
                Risk = "Low"
            }
        }
    }
    
    # Idle resource detection
    if ($Resource.State -eq "Running" -and $Resource.Metrics.LastAccessed -gt 30) {
        $optimizations += @{
            Type = "Idle Resource"
            Current = "Running 24/7"
            Recommended = "Stop or delete"
            MonthlySavings = $Resource.MonthlyCost
            Effort = "Low"
            Risk = "Medium"
        }
    }
    
    return $optimizations
}

# Provider-specific analysis
switch ($CloudProvider) {
    "azure" {
        Write-Host "`nAnalyzing Azure resources..." -ForegroundColor Yellow
        
        # Parse Azure resources from templates/current state
        $resources = @()
        
        # Check Bicep/ARM templates
        $templateFiles = Get-ChildItem -Path $ResourcePath -Include "*.bicep", "*.json" -Recurse
        
        foreach ($file in $templateFiles) {
            $content = Get-Content $file.FullName -Raw
            
            # Parse resources (simplified - would use proper parser)
            if ($file.Extension -eq ".bicep") {
                $resourceMatches = [regex]::Matches($content, "resource\s+(\w+)\s+'([^']+)'")
                
                foreach ($match in $resourceMatches) {
                    $resourceName = $match.Groups[1].Value
                    $resourceType = $match.Groups[2].Value
                    
                    $resource = @{
                        Name = $resourceName
                        Type = $resourceType
                        Provider = "Azure"
                        MonthlyCost = 0
                        Metrics = @{}
                        Optimizations = @()
                    }
                    
                    # Estimate costs based on resource type
                    switch -Wildcard ($resourceType) {
                        "*virtualMachines*" {
                            # Extract VM size
                            if ($content -match "$resourceName[\s\S]*?vmSize:\s*'([^']+)'") {
                                $vmSize = $Matches[1]
                                $resource.Size = $vmSize
                                
                                # Cost estimates (simplified)
                                $vmCosts = @{
                                    "Standard_B1s" = 10
                                    "Standard_B2s" = 40
                                    "Standard_D2s_v3" = 100
                                    "Standard_D4s_v3" = 200
                                    "Standard_D8s_v3" = 400
                                }
                                
                                $resource.MonthlyCost = $vmCosts[$vmSize] ?? 150
                                
                                # Optimization checks
                                if ($vmSize -match "Standard_D8|Standard_E8") {
                                    $resource.Optimizations += @{
                                        Type = "Consider B-series"
                                        Savings = $resource.MonthlyCost * 0.4
                                        Description = "Use burstable VMs for variable workloads"
                                    }
                                }
                            }
                        }
                        
                        "*storageAccounts*" {
                            # Storage tier check
                            if ($content -match "$resourceName[\s\S]*?kind:\s*'([^']+)'") {
                                $kind = $Matches[1]
                                if ($kind -eq "StorageV2" -and $content -match "Premium") {
                                    $resource.MonthlyCost = 200
                                    $resource.Optimizations += @{
                                        Type = "Storage Tier"
                                        Savings = 100
                                        Description = "Consider Standard tier for cool data"
                                    }
                                }
                            }
                        }
                        
                        "*applicationGateways*" {
                            $resource.MonthlyCost = 250
                            if ($content -notmatch "autoscaleConfiguration") {
                                $resource.Optimizations += @{
                                    Type = "Enable Autoscale"
                                    Savings = 50
                                    Description = "Scale down during off-peak hours"
                                }
                            }
                        }
                    }
                    
                    $resources += $resource
                    $costAnalysis.CurrentCosts.Monthly += $resource.MonthlyCost
                }
            }
        }
        
        # Azure-specific recommendations
        $costAnalysis.Recommendations += "Enable Azure Advisor cost recommendations"
        $costAnalysis.Recommendations += "Use Azure Hybrid Benefit for Windows VMs"
        $costAnalysis.Recommendations += "Implement auto-shutdown for non-production VMs"
        
        # Reserved instances
        if ($IncludeReserved) {
            $totalVMCost = ($resources | Where-Object { $_.Type -match "virtualMachine" } | 
                           Measure-Object -Property MonthlyCost -Sum).Sum
            
            if ($totalVMCost -gt 500) {
                $costAnalysis.ReservedInstanceOpportunities += @{
                    Type = "Azure Reserved VM Instances"
                    CurrentMonthly = $totalVMCost
                    WithReserved = $totalVMCost * 0.4
                    MonthlySavings = $totalVMCost * 0.6
                    Term = "3-year"
                    BreakEven = "8 months"
                }
            }
        }
    }
    
    "aws" {
        Write-Host "`nAnalyzing AWS resources..." -ForegroundColor Yellow
        
        # Parse Terraform AWS resources
        $tfFiles = Get-ChildItem -Path $ResourcePath -Include "*.tf" -Recurse
        $resources = @()
        
        foreach ($file in $tfFiles) {
            $content = Get-Content $file.FullName -Raw
            
            # EC2 Instances
            if ($content -match 'resource\s+"aws_instance"\s+"([^"]+)"') {
                $instanceName = $Matches[1]
                
                $resource = @{
                    Name = $instanceName
                    Type = "aws_instance"
                    Provider = "AWS"
                    MonthlyCost = 0
                    Optimizations = @()
                }
                
                # Get instance type
                if ($content -match "$instanceName[\s\S]*?instance_type\s*=\s*\"([^\"]+)\"") {
                    $instanceType = $Matches[1]
                    $resource.Size = $instanceType
                    
                    # Cost estimates
                    $ec2Costs = @{
                        "t3.micro" = 8
                        "t3.small" = 16
                        "t3.medium" = 32
                        "m5.large" = 70
                        "m5.xlarge" = 140
                        "m5.2xlarge" = 280
                    }
                    
                    $resource.MonthlyCost = $ec2Costs[$instanceType] ?? 100
                    
                    # Optimization: Spot instances
                    if ($content -notmatch "spot_price") {
                        $resource.Optimizations += @{
                            Type = "Use Spot Instances"
                            Savings = $resource.MonthlyCost * 0.7
                            Description = "For fault-tolerant workloads"
                        }
                    }
                    
                    # Optimization: Instance family
                    if ($instanceType -match "m5" -and $content -notmatch "cpu_credits") {
                        $resource.Optimizations += @{
                            Type = "Switch to T3"
                            Savings = $resource.MonthlyCost * 0.3
                            Description = "T3 instances for burstable workloads"
                        }
                    }
                }
                
                $resources += $resource
            }
            
            # RDS Instances
            if ($content -match 'resource\s+"aws_db_instance"\s+"([^"]+)"') {
                $dbName = $Matches[1]
                
                $resource = @{
                    Name = $dbName
                    Type = "aws_db_instance"
                    Provider = "AWS"
                    MonthlyCost = 300  # Base estimate
                    Optimizations = @()
                }
                
                # Multi-AZ optimization
                if ($content -match "$dbName[\s\S]*?multi_az\s*=\s*true" -and 
                    $content -match "environment\s*=\s*\"(dev|test)\"") {
                    $resource.Optimizations += @{
                        Type = "Disable Multi-AZ for non-prod"
                        Savings = 150
                        Description = "Single-AZ for dev/test environments"
                    }
                }
                
                $resources += $resource
            }
        }
        
        # AWS-specific recommendations
        $costAnalysis.Recommendations += "Enable AWS Cost Explorer"
        $costAnalysis.Recommendations += "Use S3 Intelligent-Tiering"
        $costAnalysis.Recommendations += "Implement Lambda for event-driven workloads"
        
        # Calculate totals
        $resources | ForEach-Object {
            $costAnalysis.CurrentCosts.Monthly += $_.MonthlyCost
        }
    }
    
    "gcp" {
        Write-Host "`nAnalyzing GCP resources..." -ForegroundColor Yellow
        
        # Similar pattern for GCP resources
        $costAnalysis.Recommendations += "Use committed use discounts"
        $costAnalysis.Recommendations += "Enable GCP Recommender"
        $costAnalysis.Recommendations += "Use preemptible VMs for batch workloads"
    }
}

# Calculate optimized costs and savings
$totalSavings = 0
$costAnalysis.CurrentCosts.ByResource = $resources

foreach ($resource in $resources) {
    foreach ($optimization in $resource.Optimizations) {
        $totalSavings += $optimization.Savings
        
        # Add to quick wins if easy
        if ($optimization.Savings -gt 50 -and $optimization.Type -notmatch "Reserved|Spot") {
            $costAnalysis.QuickWins += @{
                Resource = $resource.Name
                Action = $optimization.Type
                MonthlySavings = $optimization.Savings
                Implementation = $optimization.Description
            }
        }
    }
}

# Add reserved instance savings
foreach ($ri in $costAnalysis.ReservedInstanceOpportunities) {
    $totalSavings += $ri.MonthlySavings
}

$costAnalysis.OptimizedCosts.Monthly = $costAnalysis.CurrentCosts.Monthly - $totalSavings
$costAnalysis.OptimizedCosts.PotentialSavings = $totalSavings
$costAnalysis.OptimizedCosts.SavingsPercentage = if ($costAnalysis.CurrentCosts.Monthly -gt 0) {
    [Math]::Round(($totalSavings / $costAnalysis.CurrentCosts.Monthly) * 100, 1)
} else { 0 }

# Calculate yearly costs
$costAnalysis.CurrentCosts.Yearly = $costAnalysis.CurrentCosts.Monthly * 12
$costAnalysis.OptimizedCosts.Yearly = $costAnalysis.OptimizedCosts.Monthly * 12

# Display results
Write-Host "`n💵 Cost Analysis Summary" -ForegroundColor Green
Write-Host "=======================" -ForegroundColor Green
Write-Host "Cloud Provider: $CloudProvider" -ForegroundColor White
Write-Host "`nCurrent Costs:" -ForegroundColor Yellow
Write-Host "  Monthly: `$$([Math]::Round($costAnalysis.CurrentCosts.Monthly, 2))" -ForegroundColor White
Write-Host "  Yearly: `$$([Math]::Round($costAnalysis.CurrentCosts.Yearly, 2))" -ForegroundColor White

if ($ShowSavings -and $totalSavings -gt 0) {
    Write-Host "`n💰 Potential Savings:" -ForegroundColor Cyan
    Write-Host "  Monthly: `$$([Math]::Round($totalSavings, 2)) ($($costAnalysis.OptimizedCosts.SavingsPercentage)%)" -ForegroundColor Green
    Write-Host "  Yearly: `$$([Math]::Round($totalSavings * 12, 2))" -ForegroundColor Green
    
    Write-Host "`nOptimized Costs:" -ForegroundColor Yellow
    Write-Host "  Monthly: `$$([Math]::Round($costAnalysis.OptimizedCosts.Monthly, 2))" -ForegroundColor White
    Write-Host "  Yearly: `$$([Math]::Round($costAnalysis.OptimizedCosts.Yearly, 2))" -ForegroundColor White
}

# Quick wins
if ($costAnalysis.QuickWins.Count -gt 0) {
    Write-Host "`n🎯 Quick Wins (Easy Optimizations):" -ForegroundColor Cyan
    $costAnalysis.QuickWins | Sort-Object -Property MonthlySavings -Descending | Select-Object -First 5 | ForEach-Object {
        Write-Host "  • $($_.Resource): $($_.Action) - Save `$$([Math]::Round($_.MonthlySavings, 2))/month" -ForegroundColor White
        Write-Host "    → $($_.Implementation)" -ForegroundColor Gray
    }
}

# Reserved instances
if ($costAnalysis.ReservedInstanceOpportunities.Count -gt 0) {
    Write-Host "`n📋 Reserved Instance Opportunities:" -ForegroundColor Yellow
    $costAnalysis.ReservedInstanceOpportunities | ForEach-Object {
        Write-Host "  • $($_.Type)" -ForegroundColor White
        Write-Host "    Current: `$$($_.CurrentMonthly)/month" -ForegroundColor Gray
        Write-Host "    With RI: `$$($_.WithReserved)/month" -ForegroundColor Gray
        Write-Host "    Savings: `$$($_.MonthlySavings)/month ($($_.Term))" -ForegroundColor Green
        Write-Host "    Break-even: $($_.BreakEven)" -ForegroundColor Gray
    }
}

# General recommendations
if ($costAnalysis.Recommendations.Count -gt 0) {
    Write-Host "`n💡 Additional Recommendations:" -ForegroundColor Yellow
    $costAnalysis.Recommendations | ForEach-Object {
        Write-Host "  • $_" -ForegroundColor White
    }
}

# Generate detailed report
if ($GenerateReport) {
    $reportPath = "cloud-cost-optimization-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
    $costAnalysis | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
    Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
    
    # Generate markdown summary
    $mdPath = "cost-optimization-summary-$(Get-Date -Format 'yyyyMMdd-HHmmss').md"
    $markdown = @"
# Cloud Cost Optimization Report

Generated: $($costAnalysis.Timestamp)  
Provider: $CloudProvider

## Executive Summary

- **Current Monthly Cost**: `$$([Math]::Round($costAnalysis.CurrentCosts.Monthly, 2))
- **Potential Monthly Savings**: `$$([Math]::Round($totalSavings, 2)) ($($costAnalysis.OptimizedCosts.SavingsPercentage)%)
- **Optimized Monthly Cost**: `$$([Math]::Round($costAnalysis.OptimizedCosts.Monthly, 2))

## Quick Wins

| Resource | Action | Monthly Savings | Effort |
|----------|--------|-----------------|--------|
$(foreach ($win in $costAnalysis.QuickWins | Sort-Object -Property MonthlySavings -Descending | Select-Object -First 10) {
"| $($win.Resource) | $($win.Action) | `$$($win.MonthlySavings) | Low |`n"
})

## Implementation Roadmap

1. **Week 1**: Implement quick wins (low risk, high impact)
2. **Week 2-3**: Evaluate and purchase reserved instances
3. **Month 2**: Implement architectural optimizations
4. **Ongoing**: Monitor and adjust based on usage patterns

---
*Generated by Claudify Cloud Cost Optimizer*
"@
    
    $markdown | Out-File -FilePath $mdPath -Encoding UTF8
    Write-Host "📄 Summary report saved to: $mdPath" -ForegroundColor Gray
}

Write-Host "`n✨ Analysis complete! Total potential savings: `$$([Math]::Round($totalSavings * 12, 2))/year" -ForegroundColor Green

# Return analysis for automation
return $costAnalysis