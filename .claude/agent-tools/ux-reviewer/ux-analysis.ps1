# UX Analysis Script - Accessibility and User Experience Validation
# Usage: .\ux-analysis.ps1 [-ProjectPath <path>] [-Framework <auto|angular|react|vue>] [-RunA11yTests]

param(
    [string]$ProjectPath = ".",
    [string]$Framework = "auto",
    [switch]$RunA11yTests,
    [switch]$Verbose
)

Write-Host "🎨 UX & Accessibility Analysis Tool - Claudify Edition" -ForegroundColor Cyan
Write-Host "===================================================" -ForegroundColor Cyan

Push-Location $ProjectPath

try {
    # Auto-detect framework
    if ($Framework -eq "auto") {
        Write-Host "`nDetecting frontend framework..." -ForegroundColor Yellow
        
        if (Test-Path "package.json") {
            $package = Get-Content "package.json" | ConvertFrom-Json
            
            if ($package.dependencies."@angular/core") {
                $Framework = "angular"
                $version = $package.dependencies."@angular/core"
            }
            elseif ($package.dependencies.react) {
                $Framework = "react"
                $version = $package.dependencies.react
            }
            elseif ($package.dependencies.vue) {
                $Framework = "vue"
                $version = $package.dependencies.vue
            }
        }
        
        Write-Host "Detected framework: $Framework $(if ($version) { "($version)" })" -ForegroundColor Green
    }
    
    # Initialize results
    $results = @{
        Framework = $Framework
        Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        Accessibility = @{
            Issues = @()
            Score = 100
            WCAG_Level = "Unknown"
        }
        UX = @{
            LoadingStates = @()
            ErrorHandling = @()
            ResponsiveDesign = @()
            Consistency = @()
        }
        Performance = @{
            BundleSize = @()
            LazyLoading = $false
            Optimizations = @()
        }
        BestPractices = @{
            Violations = @()
            Suggestions = @()
        }
    }
    
    # Get component files based on framework
    $componentFiles = switch ($Framework) {
        "angular" { Get-ChildItem -Path . -Recurse -Include "*.component.ts", "*.component.html" -File }
        "react" { Get-ChildItem -Path . -Recurse -Include "*.jsx", "*.tsx" -File }
        "vue" { Get-ChildItem -Path . -Recurse -Include "*.vue" -File }
        default { Get-ChildItem -Path . -Recurse -Include "*.html", "*.js" -File }
    } | Where-Object { $_.FullName -notmatch "node_modules|dist|build|test|spec" }
    
    Write-Host "`n🔍 Analyzing $($componentFiles.Count) component files..." -ForegroundColor Yellow
    
    # 1. Accessibility Analysis
    Write-Host "`n♿ Checking accessibility compliance..." -ForegroundColor Yellow
    
    foreach ($file in $componentFiles | Where-Object { $_.Extension -in @(".html", ".jsx", ".tsx", ".vue") }) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Check for missing alt text
        $images = [regex]::Matches($content, '<img[^>]+>')
        foreach ($img in $images) {
            if ($img.Value -notmatch 'alt\s*=') {
                $results.Accessibility.Issues += @{
                    Type = "Missing Alt Text"
                    Severity = "High"
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Line = Get-LineNumber $content $img.Index
                    Element = $img.Value
                    Fix = "Add descriptive alt text"
                }
            }
        }
        
        # Check for missing ARIA labels on interactive elements
        $interactiveElements = [regex]::Matches($content, '<(button|a|input|select|textarea)[^>]*>')
        foreach ($element in $interactiveElements) {
            if ($element.Value -notmatch '(aria-label|aria-labelledby|title)' -and 
                $element.Value -notmatch '>.*<') {
                $results.Accessibility.Issues += @{
                    Type = "Missing ARIA Label"
                    Severity = "Medium"
                    File = $file.FullName.Replace($ProjectPath, ".")
                    Line = Get-LineNumber $content $element.Index
                    Element = $element.Value
                    Fix = "Add aria-label or aria-labelledby"
                }
            }
        }
        
        # Check for form labels
        $inputs = [regex]::Matches($content, '<input[^>]+>')
        foreach ($input in $inputs) {
            if ($input.Value -match 'type\s*=\s*["'']?(text|email|password|number)' -and
                $input.Value -notmatch 'aria-label') {
                # Check if there's a label nearby
                $contextStart = [Math]::Max(0, $input.Index - 200)
                $contextLength = [Math]::Min(400, $content.Length - $contextStart)
                $context = $content.Substring($contextStart, $contextLength)
                
                if ($context -notmatch '<label[^>]*for\s*=' -and $context -notmatch '<label[^>]*>.*<input') {
                    $results.Accessibility.Issues += @{
                        Type = "Input Without Label"
                        Severity = "High"
                        File = $file.FullName.Replace($ProjectPath, ".")
                        Line = Get-LineNumber $content $input.Index
                        Element = $input.Value
                        Fix = "Add associated <label> element"
                    }
                }
            }
        }
        
        # Check for color contrast (basic check for hardcoded colors)
        $colorStyles = [regex]::Matches($content, 'color:\s*#([0-9a-fA-F]{3,6})|background(?:-color)?:\s*#([0-9a-fA-F]{3,6})')
        if ($colorStyles.Count -gt 0) {
            $results.Accessibility.Issues += @{
                Type = "Potential Color Contrast Issue"
                Severity = "Low"
                File = $file.FullName.Replace($ProjectPath, ".")
                Count = $colorStyles.Count
                Fix = "Verify color contrast ratios meet WCAG standards"
            }
        }
    }
    
    # 2. UX Pattern Analysis
    Write-Host "`n👤 Analyzing UX patterns..." -ForegroundColor Yellow
    
    foreach ($file in $componentFiles) {
        $content = Get-Content $file.FullName -Raw -ErrorAction SilentlyContinue
        if (-not $content) { continue }
        
        # Check for loading states
        $hasLoadingState = $false
        switch ($Framework) {
            "angular" {
                if ($content -match '(loading|isLoading|pending)\s*[=:]' -or
                    $content -match '\*ngIf\s*=\s*["''].*loading') {
                    $hasLoadingState = $true
                }
            }
            "react" {
                if ($content -match '(loading|isLoading|pending)\s*[=:]' -or
                    $content -match '{.*loading.*\?') {
                    $hasLoadingState = $true
                }
            }
        }
        
        if ($hasLoadingState) {
            $results.UX.LoadingStates += @{
                File = $file.FullName.Replace($ProjectPath, ".")
                HasLoadingState = $true
            }
        }
        
        # Check for error handling
        $hasErrorHandling = $false
        if ($content -match '(error|isError|hasError|errorMessage)\s*[=:]' -or
            $content -match 'catch\s*\(' -or
            $content -match '\.error\s*\(') {
            $hasErrorHandling = $true
            
            $results.UX.ErrorHandling += @{
                File = $file.FullName.Replace($ProjectPath, ".")
                HasErrorHandling = $true
            }
        }
        
        # Check for responsive design indicators
        if ($content -match '@media|breakpoint|col-(xs|sm|md|lg|xl)|responsive') {
            $results.UX.ResponsiveDesign += @{
                File = $file.FullName.Replace($ProjectPath, ".")
                HasResponsiveFeatures = $true
            }
        }
    }
    
    # 3. Performance Analysis
    Write-Host "`n⚡ Analyzing performance optimizations..." -ForegroundColor Yellow
    
    # Check for lazy loading in routing
    if ($Framework -eq "angular") {
        $routingFiles = Get-ChildItem -Path . -Recurse -Include "*routing*.ts", "*routes*.ts" -File
        foreach ($file in $routingFiles) {
            $content = Get-Content $file.FullName -Raw
            if ($content -match 'loadChildren.*=>.*import\(') {
                $results.Performance.LazyLoading = $true
            }
        }
    }
    
    # Check bundle size (if build output exists)
    $distPath = Join-Path $ProjectPath "dist"
    if (Test-Path $distPath) {
        $jsFiles = Get-ChildItem -Path $distPath -Recurse -Include "*.js" -File
        foreach ($file in $jsFiles | Where-Object { $_.Name -notmatch '\.map$' }) {
            $sizeKB = [Math]::Round($file.Length / 1KB, 2)
            $results.Performance.BundleSize += @{
                File = $file.Name
                SizeKB = $sizeKB
                Warning = $sizeKB -gt 500
            }
        }
    }
    
    # Check for common optimizations
    $optimizations = @()
    
    # Angular specific
    if ($Framework -eq "angular") {
        $mainFile = Get-ChildItem -Path . -Recurse -Include "main.ts" -File | Select-Object -First 1
        if ($mainFile) {
            $mainContent = Get-Content $mainFile.FullName -Raw
            if ($mainContent -match 'enableProdMode\(\)') {
                $optimizations += "Production mode enabled"
            }
        }
        
        # Check for OnPush strategy
        $componentsWithOnPush = $componentFiles | Where-Object { 
            $_.Extension -eq ".ts" -and 
            (Get-Content $_.FullName -Raw) -match 'ChangeDetectionStrategy\.OnPush'
        }
        if ($componentsWithOnPush) {
            $optimizations += "OnPush change detection used"
        }
    }
    
    $results.Performance.Optimizations = $optimizations
    
    # 4. Best Practices Check
    Write-Host "`n✅ Checking frontend best practices..." -ForegroundColor Yellow
    
    # Check for console.log statements
    $consoleStatements = $componentFiles | Select-String -Pattern "console\.(log|error|warn)" |
        Where-Object { $_.Path -notmatch "test|spec|debug" }
    
    if ($consoleStatements.Count -gt 0) {
        $results.BestPractices.Violations += @{
            Type = "Console Statements"
            Severity = "Low"
            Count = $consoleStatements.Count
            Files = $consoleStatements | Select-Object -First 5 | ForEach-Object { Split-Path $_.Path -Leaf }
        }
    }
    
    # Check for inline styles
    $inlineStyles = $componentFiles | Where-Object { $_.Extension -in @(".html", ".jsx", ".tsx") } |
        Select-String -Pattern 'style\s*=\s*["''][^"'']+["'']'
    
    if ($inlineStyles.Count -gt 0) {
        $results.BestPractices.Violations += @{
            Type = "Inline Styles"
            Severity = "Medium"
            Count = $inlineStyles.Count
            Recommendation = "Move styles to CSS/SCSS files or use CSS-in-JS properly"
        }
    }
    
    # Framework-specific checks
    switch ($Framework) {
        "angular" {
            # Check for proper signal usage (Angular 16+)
            $componentsWithSignals = $componentFiles | Where-Object {
                $_.Extension -eq ".ts" -and
                (Get-Content $_.FullName -Raw) -match 'signal\s*\('
            }
            
            $componentsWithSubjects = $componentFiles | Where-Object {
                $_.Extension -eq ".ts" -and
                (Get-Content $_.FullName -Raw) -match 'BehaviorSubject|Subject<'
            }
            
            if ($componentsWithSignals.Count -gt 0 -and $componentsWithSubjects.Count -gt 0) {
                $results.BestPractices.Suggestions += "Consider migrating all state management to signals for consistency"
            }
        }
    }
    
    # Calculate scores
    $a11yScore = 100
    foreach ($issue in $results.Accessibility.Issues) {
        switch ($issue.Severity) {
            "High" { $a11yScore -= 10 }
            "Medium" { $a11yScore -= 5 }
            "Low" { $a11yScore -= 2 }
        }
    }
    $results.Accessibility.Score = [Math]::Max(0, $a11yScore)
    
    # Determine WCAG level
    $results.Accessibility.WCAG_Level = if ($a11yScore -ge 90) { "AA" } 
                                       elseif ($a11yScore -ge 70) { "A" }
                                       else { "Non-compliant" }
    
    # Summary Report
    Write-Host "`n📊 UX & Accessibility Analysis Summary" -ForegroundColor Green
    Write-Host "====================================" -ForegroundColor Green
    Write-Host "Framework: $($results.Framework)"
    Write-Host "Components Analyzed: $($componentFiles.Count)"
    
    Write-Host "`n♿ Accessibility:"
    Write-Host "  Score: $($results.Accessibility.Score)/100" -ForegroundColor $(
        if ($results.Accessibility.Score -ge 90) { "Green" }
        elseif ($results.Accessibility.Score -ge 70) { "Yellow" }
        else { "Red" }
    )
    Write-Host "  WCAG Level: $($results.Accessibility.WCAG_Level)"
    Write-Host "  Issues Found: $($results.Accessibility.Issues.Count)"
    
    if ($results.Accessibility.Issues.Count -gt 0) {
        $issueGroups = $results.Accessibility.Issues | Group-Object Type
        foreach ($group in $issueGroups) {
            Write-Host "    - $($group.Name): $($group.Count)" -ForegroundColor Yellow
        }
    }
    
    Write-Host "`n👤 UX Patterns:"
    Write-Host "  Components with Loading States: $($results.UX.LoadingStates.Count)"
    Write-Host "  Components with Error Handling: $($results.UX.ErrorHandling.Count)"
    Write-Host "  Responsive Design Features: $(if ($results.UX.ResponsiveDesign.Count -gt 0) { "✓" } else { "✗" })"
    
    Write-Host "`n⚡ Performance:"
    Write-Host "  Lazy Loading: $(if ($results.Performance.LazyLoading) { "✓ Enabled" } else { "✗ Not detected" })"
    
    if ($results.Performance.BundleSize.Count -gt 0) {
        $totalSize = ($results.Performance.BundleSize | Measure-Object -Property SizeKB -Sum).Sum
        Write-Host "  Total Bundle Size: $([Math]::Round($totalSize, 2)) KB"
        
        $largeFiles = $results.Performance.BundleSize | Where-Object { $_.Warning }
        if ($largeFiles) {
            Write-Host "  ⚠️ Large bundles detected:" -ForegroundColor Yellow
            foreach ($file in $largeFiles) {
                Write-Host "    - $($file.File): $($file.SizeKB) KB" -ForegroundColor Yellow
            }
        }
    }
    
    # Recommendations
    Write-Host "`n💡 Recommendations:" -ForegroundColor Cyan
    
    if ($results.Accessibility.Score -lt 90) {
        Write-Host "  • Fix high-priority accessibility issues to achieve WCAG AA compliance" -ForegroundColor White
    }
    
    if ($results.UX.LoadingStates.Count -lt ($componentFiles.Count * 0.3)) {
        Write-Host "  • Add loading states to async operations for better user feedback" -ForegroundColor White
    }
    
    if ($results.UX.ErrorHandling.Count -lt ($componentFiles.Count * 0.3)) {
        Write-Host "  • Implement comprehensive error handling with user-friendly messages" -ForegroundColor White
    }
    
    if (-not $results.Performance.LazyLoading -and $Framework -eq "angular") {
        Write-Host "  • Implement lazy loading for route modules to improve initial load time" -ForegroundColor White
    }
    
    foreach ($suggestion in $results.BestPractices.Suggestions) {
        Write-Host "  • $suggestion" -ForegroundColor White
    }
    
    # Export results
    $outputPath = Join-Path $ProjectPath "ux-analysis-results.json"
    $results | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8
    Write-Host "`n📄 Detailed results saved to: $outputPath" -ForegroundColor Gray
    
    # Run automated a11y tests if requested
    if ($RunA11yTests) {
        Write-Host "`n🧪 Running automated accessibility tests..." -ForegroundColor Cyan
        
        # Check if testing tools are available
        if (Get-Command npm -ErrorAction SilentlyContinue) {
            # Check for axe-core or pa11y
            $hasAxe = Test-Path "node_modules/axe-core"
            $hasPa11y = Test-Path "node_modules/pa11y"
            
            if ($hasAxe -or $hasPa11y) {
                Write-Host "Automated testing tools found. Run 'npm test' with a11y configuration." -ForegroundColor Yellow
            } else {
                Write-Host "Consider installing axe-core or pa11y for automated accessibility testing:" -ForegroundColor Yellow
                Write-Host "  npm install --save-dev axe-core" -ForegroundColor Gray
                Write-Host "  npm install --save-dev pa11y" -ForegroundColor Gray
            }
        }
    }
    
} finally {
    Pop-Location
}

# Helper function
function Get-LineNumber {
    param([string]$Content, [int]$Index)
    
    $lines = $Content.Substring(0, $Index) -split "`n"
    return $lines.Count
}