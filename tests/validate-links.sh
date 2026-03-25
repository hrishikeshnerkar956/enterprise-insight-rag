#!/bin/bash

# Script to validate cross-reference links in documentation
# Usage: bash tests/validate-links.sh

echo "=== Validating Documentation Cross-References ==="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

ERRORS=0

# Check if all 9 documentation files exist
echo "Checking documentation files..."
DOCS=(
    "docs/PREREQUISITES_INSTALLATION.md"
    "docs/PRD_AND_SDLC.md"
    "docs/SETUP_GUIDE.md"
    "docs/API_CONTRACTS.md"
    "docs/CODEBASE_EXPLANATION.md"
    "docs/TASK_TRACKER.md"
    "docs/DEV_WORKFLOW.md"
    "docs/ARCHITECTURE_DECISIONS.md"
    "docs/PROJECT_WALKTHROUGH.md"
)

for doc in "${DOCS[@]}"; do
    if [ -f "$doc" ]; then
        echo -e "${GREEN}✓${NC} $doc exists"
    else
        echo -e "${RED}✗${NC} $doc missing"
        ((ERRORS++))
    fi
done

echo ""
echo "Checking README.md links to all documentation files..."

# Check README.md links
for doc in "${DOCS[@]}"; do
    if grep -q "$doc" README.md; then
        echo -e "${GREEN}✓${NC} README.md links to $doc"
    else
        echo -e "${RED}✗${NC} README.md missing link to $doc"
        ((ERRORS++))
    fi
done

echo ""
echo "Checking cross-references in documentation files..."

# Check specific cross-references
check_link() {
    local file=$1
    local target=$2
    local description=$3
    
    if grep -q "$target" "$file"; then
        echo -e "${GREEN}✓${NC} $description"
    else
        echo -e "${RED}✗${NC} $description"
        ((ERRORS++))
    fi
}

# PREREQUISITES_INSTALLATION.md → SETUP_GUIDE.md
check_link "docs/PREREQUISITES_INSTALLATION.md" "SETUP_GUIDE.md" "PREREQUISITES_INSTALLATION.md → SETUP_GUIDE.md"

# SETUP_GUIDE.md → PREREQUISITES_INSTALLATION.md
check_link "docs/SETUP_GUIDE.md" "PREREQUISITES_INSTALLATION.md" "SETUP_GUIDE.md → PREREQUISITES_INSTALLATION.md"

# SETUP_GUIDE.md → API_CONTRACTS.md
check_link "docs/SETUP_GUIDE.md" "API_CONTRACTS.md" "SETUP_GUIDE.md → API_CONTRACTS.md"

# PRD_AND_SDLC.md → API_CONTRACTS.md
check_link "docs/PRD_AND_SDLC.md" "API_CONTRACTS.md" "PRD_AND_SDLC.md → API_CONTRACTS.md"

# PRD_AND_SDLC.md → ARCHITECTURE_DECISIONS.md
check_link "docs/PRD_AND_SDLC.md" "ARCHITECTURE_DECISIONS.md" "PRD_AND_SDLC.md → ARCHITECTURE_DECISIONS.md"

# API_CONTRACTS.md → SETUP_GUIDE.md
check_link "docs/API_CONTRACTS.md" "SETUP_GUIDE.md" "API_CONTRACTS.md → SETUP_GUIDE.md"

# DEV_WORKFLOW.md → TASK_TRACKER.md
check_link "docs/DEV_WORKFLOW.md" "TASK_TRACKER.md" "DEV_WORKFLOW.md → TASK_TRACKER.md"

# DEV_WORKFLOW.md → ARCHITECTURE_DECISIONS.md
check_link "docs/DEV_WORKFLOW.md" "ARCHITECTURE_DECISIONS.md" "DEV_WORKFLOW.md → ARCHITECTURE_DECISIONS.md"

# ARCHITECTURE_DECISIONS.md → PRD_AND_SDLC.md
check_link "docs/ARCHITECTURE_DECISIONS.md" "PRD_AND_SDLC.md" "ARCHITECTURE_DECISIONS.md → PRD_AND_SDLC.md"

# ARCHITECTURE_DECISIONS.md → PROJECT_WALKTHROUGH.md
check_link "docs/ARCHITECTURE_DECISIONS.md" "PROJECT_WALKTHROUGH.md" "ARCHITECTURE_DECISIONS.md → PROJECT_WALKTHROUGH.md"

# PROJECT_WALKTHROUGH.md → ARCHITECTURE_DECISIONS.md
check_link "docs/PROJECT_WALKTHROUGH.md" "ARCHITECTURE_DECISIONS.md" "PROJECT_WALKTHROUGH.md → ARCHITECTURE_DECISIONS.md"

# PROJECT_WALKTHROUGH.md → API_CONTRACTS.md
check_link "docs/PROJECT_WALKTHROUGH.md" "API_CONTRACTS.md" "PROJECT_WALKTHROUGH.md → API_CONTRACTS.md"

echo ""
echo "=== Validation Complete ==="
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}All cross-references validated successfully!${NC}"
    exit 0
else
    echo -e "${RED}Found $ERRORS error(s)${NC}"
    exit 1
fi
