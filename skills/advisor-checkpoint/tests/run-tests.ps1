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

if (-not (Test-Path -LiteralPath $skillFile -PathType Leaf)) {
    Add-Check "file:SKILL.md" $false "missing"
}
else {
    $skill = Get-Content -LiteralPath $skillFile -Raw
    Add-Check "policy:budget-2-3" ($skill -match "2-3") "expects default budget"
    Add-Check "policy:mandatory-early" ($skill -match "Mandatory checkpoints" -and $skill -match "Early checkpoint") "expects early checkpoint"
    Add-Check "policy:mandatory-final" ($skill -match "Mandatory checkpoints" -and $skill -match "Final checkpoint") "expects final checkpoint"
    Add-Check "policy:mid-task-conditional" ($skill -match "Optional mid-task checkpoint") "expects conditional mid-task"
    Add-Check "policy:fallback" ($skill -match "If advisor checkpoint cannot run") "expects fallback policy"
    Add-Check "native:no-claude-protocol" (-not ($skill -match "anthropic-beta|tool_choice|messages.create|x-api-key|claude")) "no Claude protocol blocks"
}

if (-not (Test-Path -LiteralPath $promptFile -PathType Leaf)) {
    Add-Check "file:tests/test-prompts.md" $false "missing"
}
else {
    $prompts = Get-Content -LiteralPath $promptFile -Raw
    Add-Check "coverage:trigger-positive" ($prompts -match "Trigger-Positive") "has positive prompts"
    Add-Check "coverage:trigger-negative" ($prompts -match "Trigger-Negative") "has negative prompts"
    Add-Check "coverage:adversarial" ($prompts -match "Adversarial") "has adversarial prompts"
    Add-Check "coverage:fallback" ($prompts -match "Fallback") "has fallback prompt"
}

$failed = $checks | Where-Object { -not $_.passed }
if ($failed.Count -gt 0) {
    Write-Host "run-tests.ps1: FAIL"
    $failed | ForEach-Object { Write-Host (" - {0}: {1}" -f $_.check, $_.detail) }
    exit 1
}

Write-Host "run-tests.ps1: PASS"
exit 0
