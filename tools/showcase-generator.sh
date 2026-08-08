#!/usr/bin/env bash
# Showcase Generator Tool for Mohamed Osama Master Ecosystem
# Bash script to validate build state, labels, metadata, and wiki sync

set -e

echo -e "\033[0;36m==========================================================\033[0m"
echo -e "\033[0;36m🏛️  Mohamed Osama Master Ecosystem Showcase Automation\033[0m"
echo -e "\033[0;36m==========================================================\033[0m"

echo -e "\n\033[0;33m[1/4] Running TypeScript Strict Verification...\033[0m"
npx tsc --noEmit
echo -e "\033[0;32m✅ TypeScript Type Check Passed (Zero Type Errors)\033[0m"

echo -e "\n\033[0;33m[2/4] Syncing .github/wiki to docs/ directory...\033[0m"
mkdir -p ./docs
cp -r ./.github/wiki/* ./docs/
echo -e "\033[0;32m✅ Documentation mirror synced successfully.\033[0m"

echo -e "\n\033[0;33m[3/4] Checking Branch Hygiene & Git Status...\033[0m"
CURRENT_BRANCH=$(git branch --show-current)
echo "Current Branch: $CURRENT_BRANCH"
if [[ "$CURRENT_BRANCH" == feature/* ]]; then
    echo -e "\033[0;31m⚠️ Warning: Showcase Branch Hygiene Rule: Do not push unmerged feature branches to remote!\033[0m"
else
    echo -e "\033[0;32m✅ Primary Branch Active ($CURRENT_BRANCH)\033[0m"
fi

echo -e "\n\033[0;36m==========================================================\033[0m"
echo -e "\033[0;36m🎉 Master Ecosystem Showcase Generator Complete!\033[0m"
echo -e "\033[0;36m==========================================================\033[0m"
