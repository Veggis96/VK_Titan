# VK Titan Deploy Script
# Copies addon files to WoW TBC Anniversary addon folder for testing.

$src = $PSScriptRoot
$dst = "C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns"

$addons = @(
    "VK_Titan",
    "VK_TitanAmmo",
    "VK_TitanBag",
    "VK_TitanClassic",
    "VK_TitanGold",
    "VK_TitanRepair",
    "VK_TitanXP"
)

foreach ($addon in $addons) {
    $sourcePath = Join-Path $src $addon
    $destPath = Join-Path $dst $addon
    if (Test-Path $sourcePath) {
        Copy-Item -Recurse -Force $sourcePath $destPath
        Write-Host "Deployed $addon" -ForegroundColor Green
    } else {
        Write-Host "SKIPPED $addon (not found in source)" -ForegroundColor Yellow
    }
}

Write-Host "`nDone. Reload in WoW (/reload) to apply." -ForegroundColor Cyan
