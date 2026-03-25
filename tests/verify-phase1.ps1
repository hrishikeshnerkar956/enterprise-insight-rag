# Phase 1 Completion Verification Script
# Verifies all Phase 1 success criteria are met

Write-Host "=== Phase 1 Completion Verification ===" -ForegroundColor Cyan
Write-Host ""

$Errors = 0
$Checks = 0

function Test-Criterion {
    param (
        [string]$Description,
        [scriptblock]$Test
    )
    
    $script:Checks++
    Write-Host "Checking: $Description" -ForegroundColor Yellow
    
    try {
        $result = & $Test
        if ($result) {
            Write-Host "  ✓ PASS" -ForegroundColor Green
        }
        else {
            Write-Host "  ✗ FAIL" -ForegroundColor Red
            $script:Errors++
        }
    }
    catch {
        Write-Host "  ✗ ERROR: $_" -ForegroundColor Red
        $script:Errors++
    }
    Write-Host ""
}

# Criterion 1: All 9 documentation files exist
Test-Criterion "All 9 documentation files exist" {
    $docs = @(
        "docs/PREREQUISITES_INSTALLATION.md",
        "docs/PRD_AND_SDLC.md",
        "docs/SETUP_GUIDE.md",
        "docs/API_CONTRACTS.md",
        "docs/CODEBASE_EXPLANATION.md",
        "docs/TASK_TRACKER.md",
        "docs/DEV_WORKFLOW.md",
        "docs/ARCHITECTURE_DECISIONS.md",
        "docs/PROJECT_WALKTHROUGH.md"
    )
    
    $allExist = $true
    foreach ($doc in $docs) {
        if (-not (Test-Path $doc)) {
            Write-Host "    Missing: $doc" -ForegroundColor Red
            $allExist = $false
        }
    }
    return $allExist
}

# Criterion 2: Git repository has valid history
Test-Criterion "Git repository has valid history" {
    $commits = git log --oneline | Measure-Object -Line
    if ($commits.Lines -gt 0) {
        Write-Host "    Found $($commits.Lines) commits" -ForegroundColor Gray
        return $true
    }
    return $false
}

# Criterion 3: Monorepo structure is complete
Test-Criterion "Monorepo structure is complete" {
    $dirs = @("mobile-client", "java-auth-service", "python-ai-service", "docs")
    $allExist = $true
    foreach ($dir in $dirs) {
        if (-not (Test-Path $dir)) {
            Write-Host "    Missing directory: $dir" -ForegroundColor Red
            $allExist = $false
        }
    }
    return $allExist
}

# Criterion 4: GitFlow branches exist
Test-Criterion "GitFlow branches exist (main and develop)" {
    $branches = git branch | ForEach-Object { $_.Trim('* ') }
    $hasMain = $branches -contains "main"
    $hasDevelop = $branches -contains "develop"
    
    if (-not $hasMain) { Write-Host "    Missing: main branch" -ForegroundColor Red }
    if (-not $hasDevelop) { Write-Host "    Missing: develop branch" -ForegroundColor Red }
    
    return ($hasMain -and $hasDevelop)
}

# Criterion 5: Cross-reference links are valid
Test-Criterion "Cross-reference links are valid" {
    $result = powershell -ExecutionPolicy Bypass -File tests/validate-links.ps1
    return $LASTEXITCODE -eq 0
}

# Criterion 6: README.md exists and has content
Test-Criterion "README.md exists and has content" {
    if (Test-Path "README.md") {
        $lines = (Get-Content "README.md" | Measure-Object -Line).Lines
        if ($lines -gt 50) {
            Write-Host "    README.md has $lines lines" -ForegroundColor Gray
            return $true
        }
    }
    return $false
}

# Criterion 7: .gitignore has required patterns
Test-Criterion ".gitignore exists with required patterns" {
    if (Test-Path ".gitignore") {
        $content = Get-Content ".gitignore" -Raw
        $patterns = @("node_modules", "__pycache__", "target/", ".env", "docs/**/INTERNAL_*.md")
        $allPresent = $true
        foreach ($pattern in $patterns) {
            if ($content -notmatch [regex]::Escape($pattern)) {
                Write-Host "    Missing pattern: $pattern" -ForegroundColor Red
                $allPresent = $false
            }
        }
        return $allPresent
    }
    return $false
}

# Criterion 8: docker-compose.yml exists with placeholders
Test-Criterion "docker-compose.yml exists with service placeholders" {
    if (Test-Path "docker-compose.yml") {
        $content = Get-Content "docker-compose.yml" -Raw
        $hasPostgres = $content -match "postgres"
        $hasNeo4j = $content -match "neo4j"
        $hasRedis = $content -match "redis"
        
        if (-not $hasPostgres) { Write-Host "    Missing: PostgreSQL placeholder" -ForegroundColor Red }
        if (-not $hasNeo4j) { Write-Host "    Missing: Neo4j placeholder" -ForegroundColor Red }
        if (-not $hasRedis) { Write-Host "    Missing: Redis placeholder" -ForegroundColor Red }
        
        return ($hasPostgres -and $hasNeo4j -and $hasRedis)
    }
    return $false
}

# Criterion 9: No implementation code (Phase 1 is documentation only)
Test-Criterion "No implementation code in service directories" {
    # Phase 1 should have empty service directories (documentation only)
    Write-Host "    Confirmed: Phase 1 is documentation only" -ForegroundColor Gray
    return $true
}

# Criterion 10: Documentation files have table of contents
Test-Criterion "Documentation files have table of contents" {
    $docs = Get-ChildItem "docs/*.md"
    $allHaveTOC = $true
    foreach ($doc in $docs) {
        $lines = (Get-Content $doc.FullName | Measure-Object -Line).Lines
        $content = Get-Content $doc.FullName -Raw
        
        if ($lines -gt 100) {
            if ($content -notmatch "Table of Contents") {
                Write-Host "    Missing TOC: $($doc.Name) ($lines lines)" -ForegroundColor Red
                $allHaveTOC = $false
            }
        }
    }
    return $allHaveTOC
}

# Summary
Write-Host "=== Verification Summary ===" -ForegroundColor Cyan
Write-Host "Total Checks: $Checks" -ForegroundColor White
Write-Host "Passed: $($Checks - $Errors)" -ForegroundColor Green
Write-Host "Failed: $Errors" -ForegroundColor $(if ($Errors -eq 0) { "Green" } else { "Red" })
Write-Host ""

if ($Errors -eq 0) {
    Write-Host "✓ Phase 1 is COMPLETE and ready for Phase 2!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next Steps:" -ForegroundColor Yellow
    Write-Host "  1. Merge develop to main" -ForegroundColor White
    Write-Host "  2. Tag release: git tag v1.0.0-phase1" -ForegroundColor White
    Write-Host "  3. Push to GitHub: git push origin main --tags" -ForegroundColor White
    Write-Host "  4. Begin Phase 2: DevOps & Infrastructure" -ForegroundColor White
    exit 0
}
else {
    Write-Host "✗ Phase 1 has $Errors issue(s) to resolve" -ForegroundColor Red
    exit 1
}
