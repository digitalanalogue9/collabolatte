#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Runs the full test suite with coverage, refreshing all artefacts under test-results.

.DESCRIPTION
    Cleans the existing test-results folder, runs dotnet test with coverage collection,
    regenerates HTML/JSON coverage reports, and records an ISO-8601 timestamp marker
    (coverage-timestamp.txt) that downstream scripts use to determine freshness.

.OUTPUTS
    Writes coverage artefacts to test-results/coverage-report and raw test outputs to
    test-results/coverage-raw, and updates test-results/coverage-timestamp.txt with the completion time.
#>

[CmdletBinding()]
param(
    [string]$RepoRoot
)

$ErrorActionPreference = 'Stop'

function Invoke-RunCoverage {
    [CmdletBinding()]
    param(
        [string]$RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '../..'))
    )

    $resolvedRepoRoot = Resolve-Path $RepoRoot
    $testRoot = Join-Path $resolvedRepoRoot 'test-results'
    $timestampPath = Join-Path $testRoot 'coverage-timestamp.txt'
    $resultsRoot = Join-Path $testRoot 'coverage-raw'
    $targetDir = Join-Path $testRoot 'coverage-report'

    $result = [ordered]@{
        RepoRoot    = $resolvedRepoRoot
        TestRoot    = $testRoot
        Timestamp   = $null
        TargetDir   = $targetDir
    }

    Push-Location $resolvedRepoRoot
    try {
        Write-Output "Refreshing $testRoot"
        if (-not (Test-Path $testRoot)) {
            New-Item -ItemType Directory -Path $testRoot | Out-Null
        }

        if (Test-Path $resultsRoot) {
            Remove-Item $resultsRoot -Recurse -Force
        }
        if (Test-Path $targetDir) {
            Remove-Item $targetDir -Recurse -Force
        }

        # Create marker file early so downstream scripts can detect work-in-progress
        New-Item -ItemType File -Path $timestampPath -Force | Out-Null

        New-Item -ItemType Directory -Path $resultsRoot | Out-Null

        $runSettingsPath = Join-Path $resolvedRepoRoot 'Collabolatte.runsettings'
        if (-not (Test-Path $runSettingsPath)) {
            throw "Run settings file not found at $runSettingsPath."
        }

        dotnet tool restore
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet tool restore failed with exit code $LASTEXITCODE."
        }

        $solutionPath = Join-Path $resolvedRepoRoot 'apps\api\Collabolatte.Api.sln'
        dotnet test $solutionPath --settings $runSettingsPath --logger "trx" --collect:"XPlat Code Coverage" --results-directory $resultsRoot
        if ($LASTEXITCODE -ne 0) {
            throw "dotnet test failed with exit code $LASTEXITCODE."
        }

        $coveragePattern = Join-Path $resultsRoot '**/coverage.cobertura.xml'

        $reportArgs = @(
            "-reports:$coveragePattern",
            "-targetdir:$targetDir",
            '-reporttypes:Html;HtmlSummary;Badges;JsonSummary',
            '-filefilters:-**/obj/**'
        )

        dotnet tool run reportgenerator @reportArgs
        if ($LASTEXITCODE -ne 0) {
            throw "reportgenerator failed with exit code $LASTEXITCODE."
        }

        Write-Output "Coverage report generated at $targetDir/index.html"

        $currentTimestamp = Get-Date -Format 'o'
        Set-Content -Path $timestampPath -Value $currentTimestamp
        Write-Output "Recorded coverage run timestamp: $currentTimestamp"

        $result.Timestamp = $currentTimestamp
        return [PSCustomObject]$result
    }
    finally {
        Pop-Location
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-RunCoverage @PSBoundParameters 
    #| Out-Null
}
