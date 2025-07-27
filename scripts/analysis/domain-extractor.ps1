# Domain Model Extractor Script
# Used by init-claudify command

param(
    [string]$RepositoryPath = "."
)

$ErrorActionPreference = "Stop"

# Initialize domain model results
$domainModel = @{
    Entities = @()
    ValueObjects = @()
    Aggregates = @()
    Services = @()
    Repositories = @()
    Events = @()
    Commands = @()
    Queries = @()
}

Write-Host "🔍 Extracting Domain Model..." -ForegroundColor Cyan

# Find common domain directories
$domainPaths = @()
$possiblePaths = @("Domain", "Models", "Entities", "Core", "src/Domain", "src/Models")

foreach ($path in $possiblePaths) {
    $fullPath = Join-Path $RepositoryPath $path
    if (Test-Path $fullPath) {
        $domainPaths += $fullPath
    }
}

# If no specific domain paths found, search entire repository
if ($domainPaths.Count -eq 0) {
    $domainPaths = @($RepositoryPath)
}

# Entity Detection
Write-Host "`n📦 Entity Detection:" -ForegroundColor Yellow

$entityPatterns = @(
    'class\s+(\w+)\s*:\s*Entity',
    'class\s+(\w+)\s*:\s*BaseEntity',
    'class\s+(\w+)\s*\{[^}]*\bId\s*\{',
    'class\s+(\w+)\s*\{[^}]*\bGuid\s+Id\s*\{'
)

$foundEntities = @{}

foreach ($path in $domainPaths) {
    $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        foreach ($pattern in $entityPatterns) {
            if ($content -match $pattern) {
                $entityName = $matches[1]
                if ($entityName -and -not $foundEntities.ContainsKey($entityName)) {
                    # Extract properties
                    $properties = @()
                    if ($content -match "class\s+$entityName[^{]*\{([^}]+)\}") {
                        $classBody = $matches[1]
                        $propMatches = [regex]::Matches($classBody, 'public\s+(\w+\??)\s+(\w+)\s*\{')
                        foreach ($propMatch in $propMatches) {
                            $properties += @{
                                Type = $propMatch.Groups[1].Value
                                Name = $propMatch.Groups[2].Value
                            }
                        }
                    }
                    
                    $foundEntities[$entityName] = @{
                        Name = $entityName
                        File = $file.Name
                        Properties = $properties
                        HasFactoryMethod = $content -match "public\s+static\s+$entityName\s+Create\("
                    }
                }
            }
        }
    }
}

$domainModel.Entities = $foundEntities.Values | Sort-Object Name
Write-Host "  ✓ Found $($domainModel.Entities.Count) entities: $($domainModel.Entities.Name -join ', ')" -ForegroundColor Green

# Value Object Detection
Write-Host "`n💎 Value Object Detection:" -ForegroundColor Yellow

$valueObjectPatterns = @(
    'class\s+(\w+)\s*:\s*ValueObject',
    'record\s+(\w+)\s*\(',
    'class\s+(\w+)\s*\{[^}]*\bEquals\s*\([^}]*GetHashCode'
)

$foundValueObjects = @{}

foreach ($path in $domainPaths) {
    $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        foreach ($pattern in $valueObjectPatterns) {
            if ($content -match $pattern) {
                $voName = $matches[1]
                if ($voName -and -not $foundValueObjects.ContainsKey($voName) -and -not $foundEntities.ContainsKey($voName)) {
                    $foundValueObjects[$voName] = @{
                        Name = $voName
                        File = $file.Name
                        IsRecord = $pattern -match 'record'
                    }
                }
            }
        }
    }
}

$domainModel.ValueObjects = $foundValueObjects.Values | Sort-Object Name
if ($domainModel.ValueObjects.Count -gt 0) {
    Write-Host "  ✓ Found $($domainModel.ValueObjects.Count) value objects: $($domainModel.ValueObjects.Name -join ', ')" -ForegroundColor Green
}

# Aggregate Detection
Write-Host "`n🏛️ Aggregate Detection:" -ForegroundColor Yellow

# Look for explicit aggregates
$aggregatePatterns = @(
    'class\s+(\w+)Aggregate',
    'class\s+(\w+)\s*:\s*IAggregateRoot',
    'class\s+(\w+)\s*:\s*AggregateRoot'
)

$foundAggregates = @{}

foreach ($entity in $domainModel.Entities) {
    # Check if entity has collection properties of other entities
    $hasCollections = $entity.Properties | Where-Object { $_.Type -match 'List<|ICollection<|IEnumerable<' }
    
    if ($hasCollections) {
        $foundAggregates[$entity.Name] = @{
            Root = $entity.Name
            Members = @()
        }
    }
}

# Check for explicit aggregate classes
foreach ($path in $domainPaths) {
    $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        foreach ($pattern in $aggregatePatterns) {
            if ($content -match $pattern) {
                $aggName = $matches[1]
                if (-not $foundAggregates.ContainsKey($aggName)) {
                    $foundAggregates[$aggName] = @{
                        Root = $aggName
                        Members = @()
                    }
                }
            }
        }
    }
}

$domainModel.Aggregates = $foundAggregates.Values | Sort-Object Root
if ($domainModel.Aggregates.Count -gt 0) {
    Write-Host "  ✓ Found $($domainModel.Aggregates.Count) aggregate roots: $($domainModel.Aggregates.Root -join ', ')" -ForegroundColor Green
}

# Service Detection
Write-Host "`n⚙️ Service Detection:" -ForegroundColor Yellow

$servicePatterns = @(
    'class\s+(\w+Service)\s*:',
    'interface\s+I(\w+Service)',
    'class\s+(\w+BusinessService)'
)

$foundServices = @{}

$servicePaths = $domainPaths + @(
    (Join-Path $RepositoryPath "Services"),
    (Join-Path $RepositoryPath "Application"),
    (Join-Path $RepositoryPath "src/Services")
)

foreach ($path in $servicePaths) {
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw
            
            foreach ($pattern in $servicePatterns) {
                if ($content -match $pattern) {
                    $serviceName = $matches[1]
                    if ($serviceName -and -not $foundServices.ContainsKey($serviceName)) {
                        # Extract main methods
                        $methods = @()
                        $methodMatches = [regex]::Matches($content, 'public\s+(?:async\s+)?(?:Task<)?(\w+)(?:>)?\s+(\w+)\s*\(')
                        foreach ($methodMatch in $methodMatches) {
                            $methods += $methodMatch.Groups[2].Value
                        }
                        
                        $foundServices[$serviceName] = @{
                            Name = $serviceName
                            File = $file.Name
                            Methods = $methods | Select-Object -First 5
                        }
                    }
                }
            }
        }
    }
}

$domainModel.Services = $foundServices.Values | Sort-Object Name
Write-Host "  ✓ Found $($domainModel.Services.Count) domain services" -ForegroundColor Green

# Repository Detection
Write-Host "`n📂 Repository Detection:" -ForegroundColor Yellow

$repoPatterns = @(
    'interface\s+I(\w+Repository)',
    'class\s+(\w+Repository)\s*:'
)

$foundRepos = @{}

foreach ($path in $domainPaths + @((Join-Path $RepositoryPath "Repositories"), (Join-Path $RepositoryPath "Infrastructure"))) {
    if (Test-Path $path) {
        $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
        
        foreach ($file in $files) {
            $content = Get-Content $file.FullName -Raw
            
            foreach ($pattern in $repoPatterns) {
                if ($content -match $pattern) {
                    $repoName = $matches[1]
                    if ($repoName -and -not $foundRepos.ContainsKey($repoName)) {
                        # Try to determine entity
                        $entityName = $repoName -replace 'Repository$', ''
                        
                        $foundRepos[$repoName] = @{
                            Name = $repoName
                            Entity = $entityName
                            File = $file.Name
                        }
                    }
                }
            }
        }
    }
}

$domainModel.Repositories = $foundRepos.Values | Sort-Object Name
Write-Host "  ✓ Found $($domainModel.Repositories.Count) repositories" -ForegroundColor Green

# Event Detection (if using event-driven)
Write-Host "`n📨 Domain Event Detection:" -ForegroundColor Yellow

$eventPatterns = @(
    'class\s+(\w+Event)\s*:',
    'class\s+(\w+)\s*:\s*IDomainEvent',
    'class\s+(\w+)\s*:\s*IEvent'
)

$foundEvents = @{}

foreach ($path in $domainPaths) {
    $files = Get-ChildItem -Path $path -Include "*.cs" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        foreach ($pattern in $eventPatterns) {
            if ($content -match $pattern) {
                $eventName = $matches[1]
                if ($eventName -and -not $foundEvents.ContainsKey($eventName)) {
                    $foundEvents[$eventName] = @{
                        Name = $eventName
                        File = $file.Name
                    }
                }
            }
        }
    }
}

$domainModel.Events = $foundEvents.Values | Sort-Object Name
if ($domainModel.Events.Count -gt 0) {
    Write-Host "  ✓ Found $($domainModel.Events.Count) domain events" -ForegroundColor Green
}

# Build vocabulary summary
$vocabulary = @{
    EntityNames = $domainModel.Entities.Name
    ServiceOperations = $domainModel.Services | ForEach-Object { $_.Methods } | Select-Object -Unique
    BusinessTerms = @()
}

# Extract business terms from method names
$allMethods = $domainModel.Services | ForEach-Object { $_.Methods }
$businessVerbs = $allMethods | ForEach-Object {
    if ($_ -match '^(Create|Update|Delete|Get|Find|Calculate|Process|Validate|Submit|Approve|Reject)(\w+)') {
        $matches[2]
    }
} | Select-Object -Unique

$vocabulary.BusinessTerms = $businessVerbs

# Output results
@{
    DomainModel = $domainModel
    Vocabulary = $vocabulary
    Summary = @{
        TotalEntities = $domainModel.Entities.Count
        TotalValueObjects = $domainModel.ValueObjects.Count
        TotalAggregates = $domainModel.Aggregates.Count
        TotalServices = $domainModel.Services.Count
        TotalRepositories = $domainModel.Repositories.Count
        HasEventDriven = $domainModel.Events.Count -gt 0
        HasCQRS = ($domainModel.Commands.Count + $domainModel.Queries.Count) -gt 0
    }
} | ConvertTo-Json -Depth 5