$ErrorActionPreference = "Stop"
$python = Get-Command python -ErrorAction SilentlyContinue
if ($null -eq $python) { $python = Get-Command py -ErrorAction SilentlyContinue }
if ($null -eq $python) { throw "Python is required to run runx tests." }
& $python.Source (Join-Path $PSScriptRoot "run-tests.py")
exit $LASTEXITCODE
