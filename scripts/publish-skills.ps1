param(
    [string]$SourceRoot = (Join-Path $PSScriptRoot "..\skills"),
    [string]$TargetRoot = "",
    [string]$LogPath = (Join-Path $PSScriptRoot "..\publish-log.csv"),
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

$resolvedSourceRoot = [System.IO.Path]::GetFullPath($SourceRoot)
if (-not (Test-Path -LiteralPath $resolvedSourceRoot -PathType Container)) {
    throw "Skills source folder not found: $resolvedSourceRoot"
}

if ([string]::IsNullOrWhiteSpace($TargetRoot)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $TargetRoot = Join-Path $env:CODEX_HOME "skills"
    }
    else {
        $TargetRoot = Join-Path $env:USERPROFILE ".codex\skills"
    }
}

$resolvedTargetRoot = [System.IO.Path]::GetFullPath($TargetRoot)
New-Item -ItemType Directory -Force -Path $resolvedTargetRoot | Out-Null

$resolvedLogPath = [System.IO.Path]::GetFullPath($LogPath)
$logDirectory = Split-Path -Parent $resolvedLogPath
if (-not [string]::IsNullOrWhiteSpace($logDirectory)) {
    New-Item -ItemType Directory -Force -Path $logDirectory | Out-Null
}
if ((-not (Test-Path -LiteralPath $resolvedLogPath -PathType Leaf)) -and (-not $WhatIf)) {
    Add-Content -LiteralPath $resolvedLogPath -Value "timestamp,skill,version,status"
}

$skillDirs = Get-ChildItem -LiteralPath $resolvedSourceRoot -Directory |
    Where-Object { Test-Path -LiteralPath (Join-Path $_.FullName "SKILL.md") }

if (-not $skillDirs) {
    Write-Host "No skill folders found in $resolvedSourceRoot (expected SKILL.md in each folder)."
    exit 0
}

Write-Host "Publishing $($skillDirs.Count) skill(s) to $resolvedTargetRoot"

foreach ($dir in $skillDirs) {
    $qualityGateScript = Join-Path $PSScriptRoot "quality-gate.ps1"
    if (-not (Test-Path -LiteralPath $qualityGateScript -PathType Leaf)) {
        throw "Missing quality gate script: $qualityGateScript"
    }

    Write-Host " - $($dir.Name) [quality gate]"
    & $qualityGateScript -SkillPath $dir.FullName -WhatIf:$WhatIf
    if ($LASTEXITCODE -ne 0) {
        throw "Quality gate failed for skill '$($dir.Name)'"
    }

    $versionFile = Join-Path $dir.FullName "VERSION"
    $version = (Get-Content -LiteralPath $versionFile -Raw).Trim()

    $destination = Join-Path $resolvedTargetRoot $dir.Name
    $backupPath = "${destination}__prev"
    Write-Host " - $($dir.Name) v$version"

    if ((Test-Path -LiteralPath $destination -PathType Container) -and (-not $WhatIf)) {
        if (Test-Path -LiteralPath $backupPath -PathType Container) {
            Remove-Item -LiteralPath $backupPath -Recurse -Force
        }
        Copy-Item -LiteralPath $destination -Destination $backupPath -Recurse -Force -Container
    }

    if (-not $WhatIf) {
        if (Test-Path -LiteralPath $destination -PathType Container) {
            Remove-Item -LiteralPath $destination -Recurse -Force
        }
        New-Item -ItemType Directory -Force -Path $destination | Out-Null
        Get-ChildItem -LiteralPath $dir.FullName -Force | Copy-Item -Destination $destination -Recurse -Force -Container
    }
    else {
        Copy-Item -LiteralPath $dir.FullName -Destination $destination -Recurse -Force -Container -WhatIf
    }

    if (-not $WhatIf) {
        $line = '{0},{1},{2},{3}' -f (Get-Date -Format s), $dir.Name, $version, "published"
        Add-Content -LiteralPath $resolvedLogPath -Value $line
    }
}

if ($WhatIf) {
    Write-Host "Dry run complete. No files were changed."
}
else {
    Write-Host "Publish complete. Log: $resolvedLogPath"
}
