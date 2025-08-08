# Multi-Framework Detection Script for Claudify v4.0.0
# Enhanced detection for multiple frameworks and monorepos

param(
    [Parameter(Mandatory=$false)]
    [string]$RepositoryPath = ".",
    
    [Parameter(Mandatory=$false)]
    [switch]$IncludeSubdirectories = $true,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxDepth = 3
)

$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest

# Framework detection patterns
$FrameworkPatterns = @{
    Frontend = @{
        Angular = @{
            Files = @("angular.json", ".angular.json", "angular-cli.json")
            PackageIndicators = @("@angular/core", "@angular/cli", "@angular/common")
            DirectoryPatterns = @("src/app", "src/environments")
            FileExtensions = @("*.component.ts", "*.module.ts", "*.service.ts")
            Confidence = 0
        }
        React = @{
            Files = @("react-scripts", ".cracorc.js", "craco.config.js")
            PackageIndicators = @("react", "react-dom", "create-react-app", "next", "gatsby")
            DirectoryPatterns = @("src/components", "pages", "components")
            FileExtensions = @("*.jsx", "*.tsx")
            Confidence = 0
        }
        Vue = @{
            Files = @("vue.config.js", "nuxt.config.js", "vite.config.js")
            PackageIndicators = @("vue", "@vue/cli", "nuxt", "vuepress")
            DirectoryPatterns = @("src/components", "src/views", "pages")
            FileExtensions = @("*.vue")
            Confidence = 0
        }
        Svelte = @{
            Files = @("svelte.config.js", "rollup.config.js")
            PackageIndicators = @("svelte", "@sveltejs/kit", "sapper")
            DirectoryPatterns = @("src/routes", "src/lib")
            FileExtensions = @("*.svelte")
            Confidence = 0
        }
    }
    Backend = @{
        DotNet = @{
            Files = @("*.csproj", "*.sln", "Program.cs", "Startup.cs", "appsettings.json")
            PackageIndicators = @()
            DirectoryPatterns = @("Controllers", "Models", "Services", "Domain", "Infrastructure")
            FileExtensions = @("*.cs", "*.cshtml")
            Confidence = 0
        }
        NodeJS = @{
            Files = @("server.js", "index.js", "app.js")
            PackageIndicators = @("express", "fastify", "koa", "hapi", "nestjs", "@nestjs/core")
            DirectoryPatterns = @("routes", "controllers", "models", "middleware")
            FileExtensions = @("*.js", "*.ts")
            Confidence = 0
        }
        Python = @{
            Files = @("requirements.txt", "setup.py", "Pipfile", "pyproject.toml", "manage.py")
            PackageIndicators = @()
            DirectoryPatterns = @("app", "src", "api", "views", "models")
            FileExtensions = @("*.py")
            Confidence = 0
        }
        Java = @{
            Files = @("pom.xml", "build.gradle", "settings.gradle", "gradlew")
            PackageIndicators = @()
            DirectoryPatterns = @("src/main/java", "src/main/resources")
            FileExtensions = @("*.java")
            Confidence = 0
        }
        Go = @{
            Files = @("go.mod", "go.sum", "main.go")
            PackageIndicators = @()
            DirectoryPatterns = @("cmd", "pkg", "internal")
            FileExtensions = @("*.go")
            Confidence = 0
        }
    }
    Database = @{
        MSSQL = @{
            Files = @()
            PackageIndicators = @("Microsoft.Data.SqlClient", "System.Data.SqlClient", "mssql")
            DirectoryPatterns = @("Migrations", "SqlScripts")
            FileExtensions = @("*.sql")
            Confidence = 0
        }
        PostgreSQL = @{
            Files = @()
            PackageIndicators = @("Npgsql", "pg", "node-postgres", "psycopg2")
            DirectoryPatterns = @("migrations", "sql")
            FileExtensions = @("*.sql")
            Confidence = 0
        }
        MongoDB = @{
            Files = @()
            PackageIndicators = @("MongoDB.Driver", "mongoose", "mongodb", "pymongo")
            DirectoryPatterns = @("models", "schemas")
            FileExtensions = @()
            Confidence = 0
        }
        MySQL = @{
            Files = @()
            PackageIndicators = @("MySql.Data", "mysql", "mysql2", "pymysql")
            DirectoryPatterns = @("migrations", "sql")
            FileExtensions = @("*.sql")
            Confidence = 0
        }
    }
    Testing = @{
        Jest = @{
            Files = @("jest.config.js", "jest.config.ts", "jest.setup.js")
            PackageIndicators = @("jest", "@types/jest", "ts-jest")
            DirectoryPatterns = @("__tests__", "__mocks__", "tests")
            FileExtensions = @("*.test.js", "*.spec.js", "*.test.ts", "*.spec.ts")
            Confidence = 0
        }
        Jasmine = @{
            Files = @("karma.conf.js", "jasmine.json")
            PackageIndicators = @("jasmine", "karma-jasmine")
            DirectoryPatterns = @("spec", "test")
            FileExtensions = @("*.spec.ts", "*.spec.js")
            Confidence = 0
        }
        XUnit = @{
            Files = @()
            PackageIndicators = @("xunit", "xunit.runner.visualstudio")
            DirectoryPatterns = @("Tests", "UnitTests", "IntegrationTests")
            FileExtensions = @("*Tests.cs", "*Test.cs")
            Confidence = 0
        }
        Pytest = @{
            Files = @("pytest.ini", "setup.cfg", "tox.ini")
            PackageIndicators = @()
            DirectoryPatterns = @("tests", "test")
            FileExtensions = @("test_*.py", "*_test.py")
            Confidence = 0
        }
    }
    DevOps = @{
        Docker = @{
            Files = @("Dockerfile", "docker-compose.yml", "docker-compose.yaml", ".dockerignore")
            PackageIndicators = @()
            DirectoryPatterns = @("docker")
            FileExtensions = @()
            Confidence = 0
        }
        Kubernetes = @{
            Files = @("*.yaml", "*.yml")
            PackageIndicators = @()
            DirectoryPatterns = @("k8s", "kubernetes", "charts", "manifests")
            FileExtensions = @()
            Confidence = 0
        }
        GitHub = @{
            Files = @()
            PackageIndicators = @()
            DirectoryPatterns = @(".github/workflows", ".github/actions")
            FileExtensions = @("*.yml", "*.yaml")
            Confidence = 0
        }
        Azure = @{
            Files = @("azure-pipelines.yml", "azure-pipelines.yaml")
            PackageIndicators = @()
            DirectoryPatterns = @(".azure", "azure")
            FileExtensions = @()
            Confidence = 0
        }
    }
}

# Check for file patterns
function Test-FilePattern {
    param(
        [string]$Path,
        [string[]]$Patterns
    )
    
    foreach ($pattern in $Patterns) {
        if ($pattern -match '\*') {
            $files = Get-ChildItem -Path $Path -Filter $pattern -ErrorAction SilentlyContinue
            if ($files) { return $true }
        } else {
            if (Test-Path (Join-Path $Path $pattern)) { return $true }
        }
    }
    return $false
}

# Check package.json for indicators
function Test-PackageJson {
    param(
        [string]$Path,
        [string[]]$Indicators
    )
    
    $packageJsonPath = Join-Path $Path "package.json"
    if (-not (Test-Path $packageJsonPath)) { return $false }
    
    try {
        $packageJson = Get-Content $packageJsonPath | ConvertFrom-Json
        $allDeps = @()
        
        if ($packageJson.dependencies) {
            $allDeps += $packageJson.dependencies.PSObject.Properties.Name
        }
        if ($packageJson.devDependencies) {
            $allDeps += $packageJson.devDependencies.PSObject.Properties.Name
        }
        
        foreach ($indicator in $Indicators) {
            if ($allDeps -contains $indicator) { return $true }
        }
    } catch {
        # Invalid JSON
    }
    
    return $false
}

# Check for .NET packages
function Test-DotNetPackages {
    param(
        [string]$Path,
        [string[]]$Indicators
    )
    
    $csprojFiles = Get-ChildItem -Path $Path -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue
    
    foreach ($csproj in $csprojFiles) {
        $content = Get-Content $csproj.FullName -Raw
        foreach ($indicator in $Indicators) {
            if ($content -match $indicator) { return $true }
        }
    }
    
    return $false
}

# Check Python requirements
function Test-PythonPackages {
    param(
        [string]$Path,
        [string[]]$Indicators
    )
    
    $requirementsPath = Join-Path $Path "requirements.txt"
    if (Test-Path $requirementsPath) {
        $content = Get-Content $requirementsPath -Raw
        foreach ($indicator in $Indicators) {
            if ($content -match $indicator) { return $true }
        }
    }
    
    return $false
}

# Detect framework in a specific path
function Detect-FrameworkInPath {
    param([string]$Path)
    
    $detectedFrameworks = @{
        Frontend = @()
        Backend = @()
        Database = @()
        Testing = @()
        DevOps = @()
    }
    
    foreach ($category in $FrameworkPatterns.Keys) {
        foreach ($framework in $FrameworkPatterns[$category].Keys) {
            $config = $FrameworkPatterns[$category][$framework]
            $confidence = 0
            
            # Check files
            if (Test-FilePattern -Path $Path -Patterns $config.Files) {
                $confidence += 40
            }
            
            # Check package indicators
            if ($config.PackageIndicators.Count -gt 0) {
                $hasPackage = $false
                
                switch ($framework) {
                    { $_ -in @("Angular", "React", "Vue", "Svelte", "NodeJS", "Jest", "Jasmine") } {
                        $hasPackage = Test-PackageJson -Path $Path -Indicators $config.PackageIndicators
                    }
                    { $_ -in @("DotNet", "MSSQL", "PostgreSQL", "MongoDB", "MySQL", "XUnit") } {
                        $hasPackage = Test-DotNetPackages -Path $Path -Indicators $config.PackageIndicators
                    }
                    { $_ -in @("Python", "Pytest") } {
                        $hasPackage = Test-PythonPackages -Path $Path -Indicators $config.PackageIndicators
                    }
                }
                
                if ($hasPackage) { $confidence += 40 }
            }
            
            # Check directory patterns
            foreach ($dir in $config.DirectoryPatterns) {
                if (Test-Path (Join-Path $Path $dir)) {
                    $confidence += 10
                    break
                }
            }
            
            # Check file extensions
            if ($config.FileExtensions.Count -gt 0) {
                if (Test-FilePattern -Path $Path -Patterns $config.FileExtensions) {
                    $confidence += 10
                }
            }
            
            # Store confidence
            $FrameworkPatterns[$category][$framework].Confidence = $confidence
            
            # Consider detected if confidence > 40
            if ($confidence -ge 40) {
                $detectedFrameworks[$category] += @{
                    Name = $framework
                    Confidence = $confidence
                    Path = $Path
                }
            }
        }
    }
    
    return $detectedFrameworks
}

# Detect monorepo structure
function Detect-MonorepoStructure {
    param([string]$Path)
    
    $monorepoIndicators = @{
        Lerna = @{ File = "lerna.json"; Type = "Lerna" }
        Nx = @{ File = "nx.json"; Type = "Nx" }
        Rush = @{ File = "rush.json"; Type = "Rush" }
        Yarn = @{ File = "yarn.lock"; Workspaces = $true; Type = "Yarn Workspaces" }
        Pnpm = @{ File = "pnpm-workspace.yaml"; Type = "Pnpm Workspaces" }
    }
    
    foreach ($tool in $monorepoIndicators.Keys) {
        $indicator = $monorepoIndicators[$tool]
        if (Test-Path (Join-Path $Path $indicator.File)) {
            
            # Check for workspaces
            $workspaces = @()
            
            if ($tool -eq "Yarn" -and $indicator.Workspaces) {
                $packageJsonPath = Join-Path $Path "package.json"
                if (Test-Path $packageJsonPath) {
                    $packageJson = Get-Content $packageJsonPath | ConvertFrom-Json
                    if ($packageJson.workspaces) {
                        $workspaces = $packageJson.workspaces
                    }
                }
            }
            
            return @{
                IsMonorepo = $true
                Type = $indicator.Type
                Workspaces = $workspaces
            }
        }
    }
    
    # Check for common monorepo patterns
    $commonPatterns = @("packages", "apps", "libs", "services")
    $foundPatterns = @()
    
    foreach ($pattern in $commonPatterns) {
        if (Test-Path (Join-Path $Path $pattern)) {
            $foundPatterns += $pattern
        }
    }
    
    if ($foundPatterns.Count -ge 2) {
        return @{
            IsMonorepo = $true
            Type = "Convention-based"
            Directories = $foundPatterns
        }
    }
    
    return @{ IsMonorepo = $false }
}

# Main detection function
function Start-MultiFrameworkDetection {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Multi-Framework Detection v4.0.0     " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
    
    Write-Host "Scanning: $RepositoryPath" -ForegroundColor Yellow
    
    # Check for monorepo
    $monorepoInfo = Detect-MonorepoStructure -Path $RepositoryPath
    
    if ($monorepoInfo.IsMonorepo) {
        Write-Host "[OK] Monorepo detected: $($monorepoInfo.Type)" -ForegroundColor Green
        if ($monorepoInfo.Workspaces) {
            Write-Host "  Workspaces: $($monorepoInfo.Workspaces -join ', ')" -ForegroundColor Gray
        }
        if ($monorepoInfo.Directories) {
            Write-Host "  Directories: $($monorepoInfo.Directories -join ', ')" -ForegroundColor Gray
        }
    }
    
    # Detect frameworks in root
    Write-Host "`nDetecting frameworks..." -ForegroundColor Yellow
    $rootFrameworks = Detect-FrameworkInPath -Path $RepositoryPath
    
    # If including subdirectories, scan them too
    $allFrameworks = @{
        Frontend = $rootFrameworks.Frontend
        Backend = $rootFrameworks.Backend
        Database = $rootFrameworks.Database
        Testing = $rootFrameworks.Testing
        DevOps = $rootFrameworks.DevOps
    }
    
    if ($IncludeSubdirectories) {
        $subDirs = @("src", "packages", "apps", "libs", "services", "ClientApp", "frontend", "backend", "api", "web")
        
        foreach ($subDir in $subDirs) {
            $subPath = Join-Path $RepositoryPath $subDir
            if (Test-Path $subPath) {
                if ($VerbosePreference -eq 'Continue') {
                    Write-Host "  Scanning: $subDir/" -ForegroundColor Gray
                }
                
                $subFrameworks = Detect-FrameworkInPath -Path $subPath
                
                foreach ($category in $subFrameworks.Keys) {
                    $allFrameworks[$category] += $subFrameworks[$category]
                }
            }
        }
    }
    
    # Display results
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "         Detection Results              " -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    
    $hasFrameworks = $false
    
    foreach ($category in $allFrameworks.Keys) {
        if ($allFrameworks[$category].Count -gt 0) {
            $hasFrameworks = $true
            Write-Host ""
            Write-Host "$category Frameworks:" -ForegroundColor Yellow
            
            $uniqueFrameworks = $allFrameworks[$category] | Sort-Object -Property Name -Unique
            
            foreach ($framework in $uniqueFrameworks) {
                $confidence = switch ($framework.Confidence) {
                    { $_ -ge 80 } { "High" }
                    { $_ -ge 50 } { "Medium" }
                    default { "Low" }
                }
                
                Write-Host "  [OK] $($framework.Name)" -ForegroundColor Green
                Write-Host "    Confidence: $confidence ($($framework.Confidence)%)" -ForegroundColor Gray
                if ($framework.Path -ne $RepositoryPath) {
                    $relativePath = $framework.Path.Replace($RepositoryPath, "")
                    if ($relativePath.StartsWith("\") -or $relativePath.StartsWith("/")) {
                        $relativePath = $relativePath.Substring(1)
                    }
                    Write-Host "    Location: $relativePath" -ForegroundColor Gray
                }
            }
        }
    }
    
    if (-not $hasFrameworks) {
        Write-Host ""
        Write-Host "No frameworks detected" -ForegroundColor Yellow
        Write-Host "This may be a new project or use uncommon patterns" -ForegroundColor Gray
    }
    
    # Recommendations
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "         Recommendations                " -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    
    $recommendedPlugins = @()
    
    # Map detected frameworks to plugins
    $pluginMapping = @{
        "Angular" = "frontend-angular"
        "React" = "frontend-react"
        "Vue" = "frontend-vue"
        "DotNet" = "backend-dotnet-mssql"
        "NodeJS" = "backend-nodejs"
        "Python" = "backend-python"
        "MSSQL" = "backend-dotnet-mssql"
        "PostgreSQL" = "database-postgresql"
        "MongoDB" = "database-mongodb"
    }
    
    foreach ($category in $allFrameworks.Keys) {
        foreach ($framework in $allFrameworks[$category]) {
            if ($pluginMapping.ContainsKey($framework.Name)) {
                $plugin = $pluginMapping[$framework.Name]
                if ($recommendedPlugins -notcontains $plugin) {
                    $recommendedPlugins += $plugin
                }
            }
        }
    }
    
    if ($recommendedPlugins.Count -gt 0) {
        Write-Host ""
        Write-Host "Recommended Claudify plugins:" -ForegroundColor Yellow
        foreach ($plugin in $recommendedPlugins) {
            Write-Host "  - $plugin" -ForegroundColor White
        }
        
        Write-Host ""
        Write-Host "To install these plugins, run:" -ForegroundColor Cyan
        Write-Host "  /framework-management install $($recommendedPlugins -join ',')" -ForegroundColor White
    } else {
        Write-Host ""
        Write-Host "No specific framework plugins recommended" -ForegroundColor Yellow
        Write-Host "Core Claudify components will be used" -ForegroundColor Gray
    }
    
    return @{
        IsMonorepo = $monorepoInfo.IsMonorepo
        MonorepoType = $monorepoInfo.Type
        Frameworks = $allFrameworks
        RecommendedPlugins = $recommendedPlugins
    }
}

# Execute detection
$results = Start-MultiFrameworkDetection

# Export results if needed
if ($VerbosePreference -eq 'Continue') {
    $resultsPath = Join-Path $RepositoryPath ".claudify-detection-results.json"
    $results | ConvertTo-Json -Depth 10 | Set-Content -Path $resultsPath -Encoding UTF8
    Write-Host ""
    Write-Host "Results saved to: $resultsPath" -ForegroundColor Gray
}