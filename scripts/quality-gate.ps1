param(
    [Parameter(Mandatory = $true)]
    [string]$SkillPath,
    [switch]$WhatIf
)

$ErrorActionPreference = "Stop"

function Add-Result {
    param(
        [System.Collections.Generic.List[object]]$Results,
        [string]$Check,
        [bool]$Passed,
        [string]$Detail
    )
    $Results.Add([pscustomobject]@{
            check  = $Check
            passed = $Passed
            detail = $Detail
        })
}

$resolvedSkillPath = [System.IO.Path]::GetFullPath($SkillPath)
if (-not (Test-Path -LiteralPath $resolvedSkillPath -PathType Container)) {
    throw "Skill path not found: $resolvedSkillPath"
}

$results = New-Object 'System.Collections.Generic.List[object]'
$hasFailure = $false

$requiredFiles = @(
    "SKILL.md",
    "PLAN.md",
    "VERSION",
    "CHANGELOG.md",
    "tests\test-prompts.md",
    "tests\run-tests.ps1",
    "tests\run-adversarial.ps1"
)

foreach ($relative in $requiredFiles) {
    $full = Join-Path $resolvedSkillPath $relative
    $exists = Test-Path -LiteralPath $full -PathType Leaf
    Add-Result -Results $results -Check "file:$relative" -Passed $exists -Detail $(if ($exists) { "present" } else { "missing" })
    if (-not $exists) {
        $hasFailure = $true
    }
}

$version = ""
$versionFile = Join-Path $resolvedSkillPath "VERSION"
if (Test-Path -LiteralPath $versionFile -PathType Leaf) {
    $version = (Get-Content -LiteralPath $versionFile -Raw).Trim()
    $isSemver = $version -match "^\d+\.\d+\.\d+$"
    Add-Result -Results $results -Check "version:semver" -Passed $isSemver -Detail $version
    if (-not $isSemver) {
        $hasFailure = $true
    }
}

$changelogFile = Join-Path $resolvedSkillPath "CHANGELOG.md"
if ((Test-Path -LiteralPath $changelogFile -PathType Leaf) -and -not [string]::IsNullOrWhiteSpace($version)) {
    $changelog = Get-Content -LiteralPath $changelogFile -Raw
    $hasVersionInChangelog = $changelog -match [regex]::Escape($version)
    Add-Result -Results $results -Check "changelog:references-version" -Passed $hasVersionInChangelog -Detail "version $version"
    if (-not $hasVersionInChangelog) {
        $hasFailure = $true
    }
}

$planFile = Join-Path $resolvedSkillPath "PLAN.md"
if (Test-Path -LiteralPath $planFile -PathType Leaf) {
    $plan = Get-Content -LiteralPath $planFile -Raw
    $planRequiredHeadings = @(
        "Reference Intake",
        "Assumptions",
        "Verification Gate",
        "Option Matrix",
        "Recommended Approach",
        "Codex Mapping",
        "Implementation Plan"
    )
    foreach ($heading in $planRequiredHeadings) {
        $found = $plan -match [regex]::Escape($heading)
        Add-Result -Results $results -Check "plan:$heading" -Passed $found -Detail $(if ($found) { "found" } else { "missing" })
        if (-not $found) {
            $hasFailure = $true
        }
    }
}

if (-not $WhatIf) {
    $testRunner = Join-Path $resolvedSkillPath "tests\run-tests.ps1"
    if (Test-Path -LiteralPath $testRunner -PathType Leaf) {
        & $testRunner
        $testsPassed = ($LASTEXITCODE -eq 0)
        Add-Result -Results $results -Check "tests:run-tests.ps1" -Passed $testsPassed -Detail $(if ($testsPassed) { "passed" } else { "failed" })
        if (-not $testsPassed) {
            $hasFailure = $true
        }
    }

    $adversarialRunner = Join-Path $resolvedSkillPath "tests\run-adversarial.ps1"
    if (Test-Path -LiteralPath $adversarialRunner -PathType Leaf) {
        & $adversarialRunner
        $adversarialPassed = ($LASTEXITCODE -eq 0)
        Add-Result -Results $results -Check "tests:run-adversarial.ps1" -Passed $adversarialPassed -Detail $(if ($adversarialPassed) { "passed" } else { "failed" })
        if (-not $adversarialPassed) {
            $hasFailure = $true
        }
    }
}
else {
    Add-Result -Results $results -Check "execution" -Passed $true -Detail "skipped runners due to -WhatIf"
}

$status = if ($hasFailure) { "FAIL" } else { "PASS" }
$resultsPath = Join-Path $resolvedSkillPath "tests\results"
New-Item -ItemType Directory -Force -Path $resultsPath | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
$reportFile = Join-Path $resultsPath ("gate-{0}-{1}.json" -f $(if ([string]::IsNullOrWhiteSpace($version)) { "unknown" } else { $version }), $timestamp)
$report = [pscustomobject]@{
    timestamp = Get-Date -Format s
    skillPath  = $resolvedSkillPath
    version   = $version
    status    = $status
    checks    = $results
}
$report | ConvertTo-Json -Depth 5 | Set-Content -LiteralPath $reportFile

Write-Host "Quality gate $status for $resolvedSkillPath"
Write-Host "Report: $reportFile"

if ($hasFailure) {
    exit 1
}

exit 0
