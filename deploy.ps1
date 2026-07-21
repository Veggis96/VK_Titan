# VK Titan Deploy Script
# Copies addon files to a WoW TBC Anniversary addon folder for local testing.

param(
    [string]$AddonPath = "C:\Program Files (x86)\World of Warcraft\_anniversary_\Interface\AddOns"
)

$src = $PSScriptRoot
$dst = $AddonPath

$addons = @(
    "VK_Titan",
    "VK_TitanAmmo",
    "VK_TitanBag",
    "VK_TitanBiS",
    "VK_TitanClassic",
    "VK_TitanGold",
    "VK_TitanRepair",
    "VK_TitanSession",
    "VK_TitanXP"
)

foreach ($addon in $addons) {
    $srcDir = Join-Path $src $addon
    $dstDir = Join-Path $dst $addon
    if (-not (Test-Path $srcDir)) {
        Write-Host "SKIPPED $addon (not found in source)" -ForegroundColor Yellow
        continue
    }
    Get-ChildItem -Path $srcDir -Recurse -File | ForEach-Object {
        $relPath = $_.FullName.Substring($srcDir.Length)
        $targetFile = Join-Path $dstDir $relPath
        $targetDir = Split-Path $targetFile
        if (-not (Test-Path $targetDir)) {
            New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
        }
        [System.IO.File]::Copy($_.FullName, $targetFile, $true)
    }
    Write-Host "Deployed $addon" -ForegroundColor Green
}

Write-Host "`nDone. Reload in WoW (/reload) to apply." -ForegroundColor Cyan
