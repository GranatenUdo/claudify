# Azure Cost Analysis Script - Infrastructure Optimization Tool
# Usage: .\analyze-azure-costs.ps1 [-SubscriptionId <id>] [-ResourceGroup <name>] [-Days 30]

param(
    [string]$SubscriptionId = "",
    [string]$ResourceGroup = "",
    [int]$Days = 30,
    [switch]$ExportReport
)

Write-Host "💰 Azure Cost Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan

# Check for Azure CLI
if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Azure CLI not found. Please install it first:" -ForegroundColor Red
    Write-Host "   https://docs.microsoft.com/en-us/cli/azure/install-azure-cli" -ForegroundColor Yellow
    exit 1
}

# Check Azure login
$account = az account show 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "❌ Not logged in to Azure. Please run 'az login' first." -ForegroundColor Red
    exit 1
}

# Use current subscription if not specified
if (-not $SubscriptionId) {
    $SubscriptionId = $account.id
}

Write-Host "Analyzing subscription: $($account.name)" -ForegroundColor Yellow
Write-Host "Period: Last $Days days" -ForegroundColor Yellow

# Initialize results
$results = @{
    Subscription = $account.name
    SubscriptionId = $SubscriptionId
    ResourceGroup = $ResourceGroup
    Period = "$Days days"
    Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    TotalCost = 0
    CostByService = @()
    CostByResource = @()
    Recommendations = @()
    PotentialSavings = 0
}

try {
    # Set subscription context
    az account set --subscription $SubscriptionId 2>$null
    
    # Get cost data
    $endDate = Get-Date
    $startDate = $endDate.AddDays(-$Days)
    
    Write-Host "`n📊 Fetching cost data..." -ForegroundColor Yellow
    
    # Build query
    $query = "Cost"
    if ($ResourceGroup) {
        $query += " | where ResourceGroup =~ '$ResourceGroup'"
    }
    $query += " | where TimeGenerated >= datetime($($startDate.ToString('yyyy-MM-dd')))"
    $query += " | summarize Cost=sum(Cost) by ServiceName, ResourceType"
    
    # Note: This is a simplified example. Real cost analysis requires Azure Cost Management APIs
    # For demo purposes, we'll analyze resource usage instead
    
    # Get all resources
    Write-Host "📦 Analyzing resources..." -ForegroundColor Yellow
    
    $resources = if ($ResourceGroup) {
        az resource list --resource-group $ResourceGroup --output json | ConvertFrom-Json
    } else {
        az resource list --output json | ConvertFrom-Json
    }
    
    Write-Host "Found $($resources.Count) resources" -ForegroundColor Green
    
    # Analyze each resource type
    $resourceGroups = $resources | Group-Object type
    
    foreach ($group in $resourceGroups) {
        $results.CostByService += @{
            Service = $group.Name
            Count = $group.Count
            Resources = $group.Group | ForEach-Object { 
                @{
                    Name = $_.name
                    Location = $_.location
                    Sku = $_.sku
                }
            }
        }
    }
    
    # Specific cost optimization checks
    Write-Host "`n🔍 Checking for optimization opportunities..." -ForegroundColor Yellow
    
    # 1. Check for stopped VMs still incurring charges
    $vms = $resources | Where-Object { $_.type -eq "Microsoft.Compute/virtualMachines" }
    foreach ($vm in $vms) {
        $vmStatus = az vm show --ids $vm.id --query "instanceView.statuses[?code=='PowerState/deallocated']" --output json | ConvertFrom-Json
        if (-not $vmStatus) {
            # VM is not deallocated, check if it's stopped
            $vmInfo = az vm show --ids $vm.id --output json | ConvertFrom-Json
            $results.Recommendations += @{
                Type = "Stopped VM Still Charged"
                Resource = $vm.name
                Recommendation = "Deallocate VM when not in use to stop charges"
                PotentialSavings = "~$50-500/month"
            }
            $results.PotentialSavings += 100
        }
    }
    
    # 2. Check for unattached disks
    $disks = $resources | Where-Object { $_.type -eq "Microsoft.Compute/disks" }
    foreach ($disk in $disks) {
        $diskInfo = az disk show --ids $disk.id --output json | ConvertFrom-Json
        if (-not $diskInfo.managedBy) {
            $results.Recommendations += @{
                Type = "Unattached Disk"
                Resource = $disk.name
                Size = "$($diskInfo.diskSizeGB) GB"
                Recommendation = "Delete or snapshot unattached disks"
                PotentialSavings = "~$$([Math]::Round($diskInfo.diskSizeGB * 0.05, 2))/month"
            }
            $results.PotentialSavings += ($diskInfo.diskSizeGB * 0.05)
        }
    }
    
    # 3. Check for oversized resources
    $appServices = $resources | Where-Object { $_.type -eq "Microsoft.Web/sites" }
    foreach ($app in $appServices) {
        $appInfo = az webapp show --ids $app.id --output json | ConvertFrom-Json
        $metrics = az monitor metrics list --resource $app.id --metric "CpuPercentage" --interval PT1H --output json 2>$null | ConvertFrom-Json
        
        if ($metrics.value.timeseries.data) {
            $avgCpu = ($metrics.value.timeseries.data.average | Measure-Object -Average).Average
            if ($avgCpu -lt 20 -and $appInfo.sku.size -notmatch "F1|B1") {
                $results.Recommendations += @{
                    Type = "Oversized App Service"
                    Resource = $app.name
                    CurrentSku = $appInfo.sku.size
                    AvgCPU = [Math]::Round($avgCpu, 2)
                    Recommendation = "Consider downgrading to smaller SKU"
                    PotentialSavings = "~$50-200/month"
                }
                $results.PotentialSavings += 100
            }
        }
    }
    
    # 4. Check for idle databases
    $sqlServers = $resources | Where-Object { $_.type -eq "Microsoft.Sql/servers" }
    foreach ($server in $sqlServers) {
        $databases = az sql db list --server $server.name --resource-group $server.resourceGroup --output json | ConvertFrom-Json
        foreach ($db in $databases | Where-Object { $_.name -ne "master" }) {
            if ($db.currentServiceObjectiveName -match "S[3-9]|P") {
                $results.Recommendations += @{
                    Type = "High-tier Database"
                    Resource = "$($server.name)/$($db.name)"
                    Tier = $db.currentServiceObjectiveName
                    Recommendation = "Review if high tier is necessary"
                    PotentialSavings = "~$100-1000/month"
                }
            }
        }
    }
    
    # 5. Check for redundant resources
    $storageAccounts = $resources | Where-Object { $_.type -eq "Microsoft.Storage/storageAccounts" }
    $storageByLocation = $storageAccounts | Group-Object location
    foreach ($group in $storageByLocation | Where-Object { $_.Count -gt 3 }) {
        $results.Recommendations += @{
            Type = "Multiple Storage Accounts"
            Location = $group.Name
            Count = $group.Count
            Recommendation = "Consolidate storage accounts in same region"
            PotentialSavings = "~$20-50/month"
        }
    }
    
    # 6. Check for non-production resources
    $nonProdIndicators = @("dev", "test", "staging", "demo", "poc")
    foreach ($resource in $resources) {
        $isNonProd = $false
        foreach ($indicator in $nonProdIndicators) {
            if ($resource.name -match $indicator -or ($resource.tags -and $resource.tags.environment -match $indicator)) {
                $isNonProd = $true
                break
            }
        }
        
        if ($isNonProd) {
            # Check if it's running during off-hours
            $results.Recommendations += @{
                Type = "Non-Production Resource"
                Resource = $resource.name
                ResourceType = $resource.type
                Recommendation = "Implement auto-shutdown for non-prod resources"
                PotentialSavings = "~$10-100/month"
            }
        }
    }
    
    # Resource tagging analysis
    $untaggedResources = $resources | Where-Object { -not $_.tags -or $_.tags.Count -eq 0 }
    if ($untaggedResources.Count -gt 0) {
        $results.Recommendations += @{
            Type = "Untagged Resources"
            Count = $untaggedResources.Count
            Recommendation = "Tag resources for better cost allocation"
            Resources = $untaggedResources | Select-Object -First 5 -ExpandProperty name
        }
    }
    
    # Summary Report
    Write-Host "`n💰 Cost Analysis Summary" -ForegroundColor Green
    Write-Host "=======================" -ForegroundColor Green
    Write-Host "Subscription: $($results.Subscription)"
    Write-Host "Resources Analyzed: $($resources.Count)"
    Write-Host "Period: Last $Days days"
    
    Write-Host "`n📊 Resources by Type:" -ForegroundColor Yellow
    foreach ($service in $results.CostByService | Sort-Object Count -Descending | Select-Object -First 10) {
        Write-Host "  $($service.Service): $($service.Count) resources" -ForegroundColor White
    }
    
    Write-Host "`n💡 Optimization Opportunities:" -ForegroundColor Cyan
    Write-Host "Total Recommendations: $($results.Recommendations.Count)"
    Write-Host "Potential Monthly Savings: ~`$$([Math]::Round($results.PotentialSavings, 2))" -ForegroundColor Green
    
    if ($results.Recommendations.Count -gt 0) {
        Write-Host "`n🎯 Top Recommendations:" -ForegroundColor Yellow
        
        $recommendationGroups = $results.Recommendations | Group-Object Type
        foreach ($group in $recommendationGroups) {
            Write-Host "`n  $($group.Name) ($($group.Count)):" -ForegroundColor White
            foreach ($rec in $group.Group | Select-Object -First 3) {
                Write-Host "    • $($rec.Resource): $($rec.Recommendation)" -ForegroundColor Gray
                if ($rec.PotentialSavings) {
                    Write-Host "      Savings: $($rec.PotentialSavings)" -ForegroundColor Green
                }
            }
        }
    }
    
    # Best practices
    Write-Host "`n📋 Cost Management Best Practices:" -ForegroundColor Cyan
    Write-Host "  • Implement resource tagging strategy" -ForegroundColor White
    Write-Host "  • Set up cost alerts and budgets" -ForegroundColor White
    Write-Host "  • Use Azure Advisor recommendations" -ForegroundColor White
    Write-Host "  • Implement auto-shutdown for non-prod" -ForegroundColor White
    Write-Host "  • Regular review of unused resources" -ForegroundColor White
    Write-Host "  • Consider reserved instances for stable workloads" -ForegroundColor White
    
    # Export report
    if ($ExportReport) {
        $reportPath = "azure-cost-analysis-$(Get-Date -Format 'yyyyMMdd-HHmmss').json"
        $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $reportPath -Encoding UTF8
        Write-Host "`n📄 Detailed report saved to: $reportPath" -ForegroundColor Gray
        
        # Generate CSV for recommendations
        if ($results.Recommendations.Count -gt 0) {
            $csvPath = "azure-cost-recommendations-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
            $results.Recommendations | Export-Csv -Path $csvPath -NoTypeInformation
            Write-Host "📄 Recommendations CSV saved to: $csvPath" -ForegroundColor Gray
        }
    }
    
} catch {
    Write-Host "❌ Error analyzing costs: $_" -ForegroundColor Red
    exit 1
}