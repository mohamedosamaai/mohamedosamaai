# Showcase Generator Tool for Mohamed Osama Master Ecosystem
# PowerShell script to validate build state, labels, metadata, and wiki sync

param (
    [switch]$SkipWikiSync = $false
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "🏛️  Mohamed Osama Master Ecosystem Showcase Automation" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Type Check Verification
Write-Host "`n[1/4] Running TypeScript Strict Verification..." -ForegroundColor Yellow
$typeCheckResult = npx tsc --noEmit
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ TypeScript Type Check Failed!" -ForegroundColor Red
    exit 1
}
Write-Host "✅ TypeScript Type Check Passed (Zero Type Errors)" -ForegroundColor Green

# 2. Mirror Wiki Docs to /docs Directory
if (-not $SkipWikiSync) {
    Write-Host "`n[2/4] Syncing .github/wiki to docs/ directory..." -ForegroundColor Yellow
    if (-not (Test-Path "./docs")) { New-Item -ItemType Directory -Path "./docs" | Out-Null }
    Copy-Item -Path "./.github/wiki/*" -Destination "./docs/" -Recurse -Force
    Write-Host "✅ Documentation mirror synced successfully." -ForegroundColor Green
}

# 3. Check Git Status & Branch Hygiene
Write-Host "`n[3/4] Checking Branch Hygiene & Git Status..." -ForegroundColor Yellow
$currentBranch = (git branch --show-current).Trim()
Write-Host "Current Branch: $currentBranch" -ForegroundColor White
if ($currentBranch -like "feature/*") {
    Write-Host "⚠️ Warning: Showcase Branch Hygiene Rule: Do not push unmerged feature branches to remote!" -ForegroundColor Red
} else {
    Write-Host "✅ Primary Branch Active ($currentBranch)" -ForegroundColor Green
}

# 4. Final Status Summary
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "🎉 Master Ecosystem Showcase Generator Complete!" -ForegroundColor Cyan
Write-Host "Repository: mohamedosamaai/mohamedosamaai" -ForegroundColor White
Write-Host "==========================================================" -ForegroundColor Cyan
