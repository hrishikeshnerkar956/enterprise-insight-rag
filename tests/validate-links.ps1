# Script to validate cross-reference links in documentation
# Usage: .\tests\validate-links.ps1

Write-Host "=== Validating Documentation Cross-References ===" -ForegroundColor Cyan
Write-Host ""

$Errors = 0

# Check if all 9 documentation files exist
Write-Host "Checking documentation files..." -ForegroundColor Yellow
$Docs = @(
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

foreach ($doc in $Docs) {
    if (Test-Path $doc) {
        Write-Host "✓ $doc exists" -ForegroundColor Green
    }
    else {
        Write-Host "✗ $doc missing" -ForegroundColor Red
        $Errors++
    }
}

Write-Host ""
Write-Host "Checking README.md links to all documentation files..." -ForegroundColor Yellow

# Check README.md links
$ReadmeContent = Get-Content "README.md" -Raw
foreach ($doc in $Docs) {
    if ($ReadmeContent -match [regex]::Escape($doc)) {
        Write-Host "✓ README.md links to $doc" -ForegroundColor Green
    }
    else {
        Write-Host "✗ README.md missing link to $doc" -ForegroundColor Red
        $Errors++
    }
}

Write-Host ""
Write-Host "Checking cross-references in documentation files..." -ForegroundColor Yellow

# Function to check if a file contains a reference to another file
function Check-Link {
    param (
        [string]$File,
        [string]$Target,
        [string]$Description
    )
    
    $Content = Get-Content $File -Raw
    if ($Content -match [regex]::Escape($Target)) {
        Write-Host "✓ $Description" -ForegroundColor Green
    }
    else {
        Write-Host "✗ $Description" -ForegroundColor Red
        $script:Errors++
    }
}

# Check specific cross-references
Check-Link "docs/PREREQUISITES_INSTALLATION.md" "SETUP_GUIDE.md" "PREREQUISITES_INSTALLATION.md → SETUP_GUIDE.md"
Check-Link "docs/SETUP_GUIDE.md" "PREREQUISITES_INSTALLATION.md" "SETUP_GUIDE.md → PREREQUISITES_INSTALLATION.md"
Check-Link "docs/SETUP_GUIDE.md" "API_CONTRACTS.md" "SETUP_GUIDE.md → API_CONTRACTS.md"
Check-Link "docs/PRD_AND_SDLC.md" "API_CONTRACTS.md" "PRD_AND_SDLC.md → API_CONTRACTS.md"
Check-Link "docs/PRD_AND_SDLC.md" "ARCHITECTURE_DECISIONS.md" "PRD_AND_SDLC.md → ARCHITECTURE_DECISIONS.md"
Check-Link "docs/API_CONTRACTS.md" "SETUP_GUIDE.md" "API_CONTRACTS.md → SETUP_GUIDE.md"
Check-Link "docs/DEV_WORKFLOW.md" "TASK_TRACKER.md" "DEV_WORKFLOW.md → TASK_TRACKER.md"
Check-Link "docs/DEV_WORKFLOW.md" "ARCHITECTURE_DECISIONS.md" "DEV_WORKFLOW.md → ARCHITECTURE_DECISIONS.md"
Check-Link "docs/ARCHITECTURE_DECISIONS.md" "PRD_AND_SDLC.md" "ARCHITECTURE_DECISIONS.md → PRD_AND_SDLC.md"
Check-Link "docs/ARCHITECTURE_DECISIONS.md" "PROJECT_WALKTHROUGH.md" "ARCHITECTURE_DECISIONS.md → PROJECT_WALKTHROUGH.md"
Check-Link "docs/PROJECT_WALKTHROUGH.md" "ARCHITECTURE_DECISIONS.md" "PROJECT_WALKTHROUGH.md → ARCHITECTURE_DECISIONS.md"
Check-Link "docs/PROJECT_WALKTHROUGH.md" "API_CONTRACTS.md" "PROJECT_WALKTHROUGH.md → API_CONTRACTS.md"

Write-Host ""
Write-Host "=== Validation Complete ===" -ForegroundColor Cyan
if ($Errors -eq 0) {
    Write-Host "All cross-references validated successfully!" -ForegroundColor Green
    exit 0
}
else {
    Write-Host "Found $Errors error(s)" -ForegroundColor Red
    exit 1
}
