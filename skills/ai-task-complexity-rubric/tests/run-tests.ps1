$ErrorActionPreference = "Stop"
$skillRoot = Split-Path -Parent $PSScriptRoot

$checks = @()
function Add-Check([string]$Name, [bool]$Passed, [string]$Detail) {
    $script:checks += [pscustomobject]@{
        check = $Name
        passed = $Passed
        detail = $Detail
    }
}

$skillFile = Join-Path $skillRoot "SKILL.md"
$promptFile = Join-Path $PSScriptRoot "test-prompts.md"
$rubricFile = Join-Path $skillRoot "references\rubric-dimensions.md"
$tierFile = Join-Path $skillRoot "references\decomposition-tiers.md"
$templateFile = Join-Path $skillRoot "references\output-template.md"
$mappingFile = Join-Path $skillRoot "references\codex-mapping-notes.md"

foreach ($file in @($skillFile, $promptFile, $rubricFile, $tierFile, $templateFile, $mappingFile)) {
    Add-Check ("file:{0}" -f [System.IO.Path]::GetFileName($file)) (Test-Path -LiteralPath $file -PathType Leaf) "required artifact"
}

if (Test-Path -LiteralPath $skillFile -PathType Leaf) {
    $skill = Get-Content -LiteralPath $skillFile -Raw
    Add-Check "policy:no-human-time" ($skill -match "Never output human time estimates") "strict no-time rule"
    Add-Check "policy:fixed-thresholds" ($skill -match "5-10" -and $skill -match "10.1-18" -and $skill -match "18.1-24" -and $skill -match "24.1-30") "v1 thresholds retained"
    Add-Check "policy:five-dimensions" ($skill -match "5 dimensions") "dimension model retained"
    Add-Check "native:no-claude-protocol" (-not ($skill -match "anthropic-beta|tool_choice|messages.create|x-api-key|claude")) "no Claude protocol terms"
}

if (Test-Path -LiteralPath $rubricFile -PathType Leaf) {
    $rubric = Get-Content -LiteralPath $rubricFile -Raw
    Add-Check "rubric:dimensions-present" ($rubric -match "CWL" -and $rubric -match "DCD" -and $rubric -match "AL" -and $rubric -match "BR" -and $rubric -match "VC") "all dimensions present"
    Add-Check "rubric:weights-present" ($rubric -match "0.25" -and $rubric -match "0.20" -and $rubric -match "0.15") "weights present"
    Add-Check "rubric:formula" ($rubric -match "Total =") "weighted formula present"
}

if (Test-Path -LiteralPath $tierFile -PathType Leaf) {
    $tiers = Get-Content -LiteralPath $tierFile -Raw
    Add-Check "tiers:v1-thresholds" ($tiers -match "5-10" -and $tiers -match "10.1-18" -and $tiers -match "18.1-24" -and $tiers -match "24.1-30") "thresholds present"
    Add-Check "tiers:small-task-guardrail" ($tiers -match "plainly trivial" -or $tiers -match "skip full rubric") "guardrail present"
}

if (Test-Path -LiteralPath $promptFile -PathType Leaf) {
    $prompts = Get-Content -LiteralPath $promptFile -Raw
    Add-Check "coverage:trigger-positive" ($prompts -match "Trigger-Positive") "has positive prompts"
    Add-Check "coverage:trigger-negative" ($prompts -match "Trigger-Negative") "has negative prompts"
    Add-Check "coverage:adversarial" ($prompts -match "Adversarial") "has adversarial prompts"
    Add-Check "coverage:consistency" ($prompts -match "Consistency") "has consistency prompt"
}

$failed = $checks | Where-Object { -not $_.passed }
if ($failed.Count -gt 0) {
    Write-Host "run-tests.ps1: FAIL"
    $failed | ForEach-Object { Write-Host (" - {0}: {1}" -f $_.check, $_.detail) }
    exit 1
}

Write-Host "run-tests.ps1: PASS"
exit 0
