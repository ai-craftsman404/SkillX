$ErrorActionPreference = "Stop"
$skillRoot = Split-Path -Parent $PSScriptRoot
$skillFile = Join-Path $skillRoot "SKILL.md"
$templateFile = Join-Path $skillRoot "references\output-template.md"

if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
    Write-Host "run-adversarial.ps1: FAIL"
    Write-Host " - Missing SKILL.md"
    exit 1
}

if (-not (Test-Path -LiteralPath $templateFile -PathType Leaf)) {
    Write-Host "run-adversarial.ps1: FAIL"
    Write-Host " - Missing references/output-template.md"
    exit 1
}

$skill = Get-Content -LiteralPath $skillFile -Raw
$template = Get-Content -LiteralPath $templateFile -Raw

$checks = @(
    [pscustomobject]@{ name = "rejects-human-time-estimates"; pass = ($skill -match "Never output human time estimates" -and $template -match "No human time estimates") },
    [pscustomobject]@{ name = "prevents-skip-scoring"; pass = ($skill -match "Rubric Workflow" -and $skill -match "Compute weighted total") },
    [pscustomobject]@{ name = "requires-all-five-dimensions"; pass = ($template -match "CWL" -and $template -match "DCD" -and $template -match "AL" -and $template -match "BR" -and $template -match "VC") },
    [pscustomobject]@{ name = "uses-fixed-tier-thresholds"; pass = ($skill -match "5-10" -and $skill -match "24.1-30") },
    [pscustomobject]@{ name = "codex-native-language"; pass = (-not ($skill -match "anthropic-beta|tool_choice|messages.create|x-api-key|claude")) }
)

$failed = $checks | Where-Object { -not $_.pass }
if ($failed.Count -gt 0) {
    Write-Host "run-adversarial.ps1: FAIL"
    $failed | ForEach-Object { Write-Host (" - {0}" -f $_.name) }
    exit 1
}

Write-Host "run-adversarial.ps1: PASS"
exit 0
