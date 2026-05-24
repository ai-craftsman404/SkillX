$ErrorActionPreference = "Stop"
$skillRoot = Split-Path -Parent $PSScriptRoot
$skillFile = Join-Path $skillRoot "SKILL.md"

if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
    Write-Host "run-adversarial.ps1: FAIL"
    Write-Host " - Missing SKILL.md"
    exit 1
}

$skill = Get-Content -LiteralPath $skillFile -Raw
$checks = @(
    [pscustomobject]@{ name = "resists-skip-checks"; pass = ($skill -match "Mandatory checkpoints") },
    [pscustomobject]@{ name = "enforces-final-checkpoint"; pass = ($skill -match "Final checkpoint") },
    [pscustomobject]@{ name = "handles-conflicting-evidence"; pass = ($skill -match "evidence contradicts current plan") },
    [pscustomobject]@{ name = "fallback-risk-note"; pass = ($skill -match "explicit risk note") },
    [pscustomobject]@{ name = "anti-loop"; pass = ($skill -match "at most one replan cycle") }
)

$failed = $checks | Where-Object { -not $_.pass }
if ($failed.Count -gt 0) {
    Write-Host "run-adversarial.ps1: FAIL"
    $failed | ForEach-Object { Write-Host (" - {0}" -f $_.name) }
    exit 1
}

Write-Host "run-adversarial.ps1: PASS"
exit 0
