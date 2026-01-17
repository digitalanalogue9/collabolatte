#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Generates code coverage reports and a AI-friendly summary for improving tests.

.DESCRIPTION
    Runs coverlet via dotnet test, generates HTML reports, and creates a markdown summary
    optimized for AI prompts. The summary includes:
    - Overall coverage statistics
    - Files with low coverage (<80%)
    - Uncovered lines and branches
    - Suggested prompts for AI

.PARAMETER MinCoverage
    Minimum coverage threshold to highlight (default: 80%). Files below this are flagged.

.PARAMETER OutputFormat
    Output format for the AI summary: 'markdown' (default), 'json', or 'both'.

.PARAMETER TimestampCheck
    Number of minutes before existing coverage results are considered stale (default: 5).

.PARAMETER CrapHotspotThreshold
    Minimum CRAP score to include when reporting risk hotspots (default: 30).

.PARAMETER RepoRoot
    Optional override for the repository root. Intended primarily for testing.

.PARAMETER ImportantNotice
    Optional string to include in the generated prompts as an important notice.

.EXAMPLE
    .\New-CoverageSummary.ps1
    Run coverage and generate a AI-friendly summary.

.EXAMPLE
    .\New-CoverageSummary.ps1 -MinCoverage 90
    Clean previous results, run coverage, and flag files below 90% coverage.
#>

[CmdletBinding()]
param(
    [int]$MinCoverage = 80,
    [ValidateSet('markdown', 'json', 'both')]
    [string]$OutputFormat = 'markdown',
    [int]$TimestampCheck = 5,
    [int]$CrapHotspotThreshold = 30,
    [string]$RepoRoot,
    [string]$ImportantNotice = 'Collabolatte has strict trust-critical constraints: no surveillance features, data must be isolated by ProgrammeId, and participation is always voluntary. Any changes must comply with these principles.'
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

function Invoke-CoverageForAI {
    [CmdletBinding()]
    param(
        [int]$MinCoverage,
        [ValidateSet('markdown', 'json', 'both')]
        [string]$OutputFormat,
        [int]$TimestampCheck,
        [int]$CrapHotspotThreshold,
        [string]$RepoRoot
    )

    $resolvedRepoRoot = if ($RepoRoot) { Resolve-Path $RepoRoot } else { Resolve-Path (Join-Path $PSScriptRoot '../..') }
    $testRoot = Join-Path $resolvedRepoRoot 'test-results'
    $coverageDir = Join-Path $testRoot 'coverage-report'
    $jsonSummaryPath = Join-Path $coverageDir 'Summary.json'
    $markdownPath = Join-Path $coverageDir 'AI-SUMMARY.md'
    $jsonDataPath = Join-Path $coverageDir 'AI-DATA.json'
    $runCoverageScript = Join-Path $PSScriptRoot 'Update-CodeCoverageArtifacts.ps1'
    $timestampPath = Join-Path $testRoot 'coverage-timestamp.txt'

    $result = [ordered]@{
        RepoRoot          = $resolvedRepoRoot
        SummaryPath       = $jsonSummaryPath
        MarkdownPath      = if ($OutputFormat -eq 'markdown' -or $OutputFormat -eq 'both') { $markdownPath } else { $null }
        JsonDataPath      = if ($OutputFormat -eq 'json' -or $OutputFormat -eq 'both') { $jsonDataPath } else { $null }
        LowCoverageFiles  = @()
        CrapHotspots      = @()
        CrapGuidance      = @()
        RefreshedCoverage = $false
    }

    Push-Location $resolvedRepoRoot
    try {
        Write-Output "[INFO] Project coverage analysis for AI"
        Write-Output "Minimum coverage threshold: $MinCoverage%"
        Write-Output "Root: $resolvedRepoRoot"
        Write-Output ""

        # Step 1: Determine whether to refresh coverage
        Write-Output "[INFO] Determining whether to refresh coverage results..."
        $refreshReason = $null
        if (-not (Test-Path $testRoot)) {
            $refreshReason = 'test-results directory missing'
        }
        elseif (-not (Test-Path $timestampPath)) {
            $refreshReason = 'timestamp marker missing'
        }
        else {
            try {
                $timestampRaw = Get-Content -Path $timestampPath -ErrorAction Stop
                $timestamp = [DateTime]::Parse($timestampRaw, $null, [System.Globalization.DateTimeStyles]::RoundtripKind)
                $age = (Get-Date) - $timestamp
                $maxAge = [TimeSpan]::FromMinutes($TimestampCheck)

                if ($age -gt $maxAge) {
                    $refreshReason = "coverage data is $([math]::Round($age.TotalMinutes, 2)) minutes old"
                }
            }
            catch {
                $refreshReason = 'failed to read timestamp marker'
            }
        }

        if ($refreshReason) {
            Write-Output "[INFO] Running base coverage script because $refreshReason..."
            & $runCoverageScript

            if ($LASTEXITCODE -ne 0) {
                throw "Coverage script failed with exit code $LASTEXITCODE."
            }

            Write-Output "[INFO] Base coverage refreshed"
            $result.RefreshedCoverage = $true
        }
        else {
            Write-Output "[INFO] Using existing coverage results (timestamp within ${TimestampCheck} minute(s))."
        }

        Write-Output ""
        Write-Output "[INFO] Generating AI-friendly summary..."

        if (-not (Test-Path $jsonSummaryPath)) {
            throw "[WARN] Summary.json not found. Cannot generate AI summary."
        }

        $summary = Get-Content $jsonSummaryPath | ConvertFrom-Json

        # Extract coverage data
        $overallLineCoverage = [math]::Round($summary.summary.linecoverage, 2)
        $overallBranchCoverage = [math]::Round($summary.summary.branchcoverage, 2)
        $overallMethodCoverage = [math]::Round($summary.summary.methodcoverage, 2)

        $coveredLines = $summary.summary.coveredlines
        $coverableLines = $summary.summary.coverablelines
        $uncoveredLines = $coverableLines - $coveredLines

        $coveredBranches = $summary.summary.coveredbranches
        $totalBranches = $summary.summary.totalbranches
        $uncoveredBranches = $totalBranches - $coveredBranches

        # Find files with low coverage
        $lowCoverageFiles = $summary.coverage.assemblies | ForEach-Object {
            $assemblyName = $_.name
            $_.classesinassembly | Where-Object { $_.coverage -lt $MinCoverage } | ForEach-Object {
                [PSCustomObject]@{
                    Assembly        = $assemblyName
                    Name            = $_.name
                    Coverage        = $_.coverage
                    CoveredLines    = $_.coveredlines
                    CoverableLines  = $_.coverablelines
                    CoveredBranches = $_.coveredbranches
                    TotalBranches   = $_.totalbranches
                }
            }
        } | Sort-Object Coverage | Select-Object -First 20

        $result.LowCoverageFiles = $lowCoverageFiles

        $crapModulePath = Join-Path $PSScriptRoot 'CrapReport.psm1'
        $crapReportPath = Join-Path $coverageDir 'index.html'
        $crapHotspots = @()
        $crapGuidance = @()

        if ((Test-Path $crapModulePath) -and (Test-Path $crapReportPath)) {
            Import-Module $crapModulePath -Force -ErrorAction SilentlyContinue
            if (Get-Command Get-CrapInsights -ErrorAction SilentlyContinue) {
                try {
                    $insights = Get-CrapInsights -ReportPath $crapReportPath -MinimumCrapScore $CrapHotspotThreshold -MaxGuidanceItems 5
                    $crapHotspots = @($insights.Hotspots)
                    $crapGuidance = @($insights.Guidance)
                }
                catch {
                    Write-Warning "Failed to parse CRAP hotspots: $_"
                    $crapHotspots = @()
                    $crapGuidance = @()
                }
            }
            else {
                Write-Warning "CrapReport module does not expose Get-CrapInsights. Skipping hotspot extraction."
            }
        }
        elseif (-not (Test-Path $crapReportPath)) {
            Write-Warning "CRAP report HTML not found at $crapReportPath."
        }
        else {
            Write-Warning "CRAP report module missing at $crapModulePath. Skipping hotspot extraction."
        }

        $crapHotspotCount = $crapHotspots.Count
        $crapHotspotsPreview = $crapHotspots | Select-Object -First 5
        $result.CrapHotspots = $crapHotspots
        $result.CrapGuidance = $crapGuidance

        # Generate Markdown summary
        if ($OutputFormat -eq 'markdown' -or $OutputFormat -eq 'both') {
            $builder = [System.Text.StringBuilder]::new()

            $builder.AppendLine('# Code Coverage Analysis for AI-Assisted Development') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine("> Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')") | Out-Null
            $builder.AppendLine("> Minimum threshold: **$MinCoverage%**") | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('## Overall Coverage') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('| Metric | Coverage | Covered | Total | Uncovered |') | Out-Null
            $builder.AppendLine('|--------|----------|---------|-------|-----------|') | Out-Null
            $builder.AppendLine("| **Lines** | **$overallLineCoverage%** | $coveredLines | $coverableLines | $uncoveredLines |") | Out-Null
            $builder.AppendLine("| **Branches** | **$overallBranchCoverage%** | $coveredBranches | $totalBranches | $uncoveredBranches |") | Out-Null
            $builder.AppendLine("| **Methods** | **$overallMethodCoverage%** | - | - | - |") | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine("## Files Below $MinCoverage% Coverage") | Out-Null
            $builder.AppendLine() | Out-Null

            if ($lowCoverageFiles.Count -eq 0) {
                $builder.AppendLine("All files meet or exceed the $MinCoverage% coverage threshold.") | Out-Null
                $builder.AppendLine() | Out-Null
            }
            else {
                $builder.AppendLine('The following files need attention:') | Out-Null
                $builder.AppendLine() | Out-Null
                $builder.AppendLine('| Assembly | Class/File | Coverage | Lines | Branches |') | Out-Null
                $builder.AppendLine('|----------|------------|----------|-------|----------|') | Out-Null

                foreach ($file in $lowCoverageFiles) {
                    if ($file.Name) {
                        $className = $file.Name -replace '^.*\.([^.]+)$', '$1'
                        $fileCoverage = [math]::Round($file.Coverage, 1)
                        $builder.AppendLine("| $($file.Assembly) | ``$className`` | $fileCoverage% | $($file.CoveredLines)/$($file.CoverableLines) | $($file.CoveredBranches)/$($file.TotalBranches) |") | Out-Null
                    }
                }

                $builder.AppendLine() | Out-Null
            }

            if ($crapHotspotCount -gt 0) {
                $builder.AppendLine("## CRAP Hotspots (CRAP = $CrapHotspotThreshold)") | Out-Null
                $builder.AppendLine() | Out-Null
                $builder.AppendLine('| Assembly | Method | CRAP | Cyclomatic | Link |') | Out-Null
                $builder.AppendLine('|----------|--------|------|------------|------|') | Out-Null

                foreach ($hotspot in $crapHotspotsPreview) {
                    $linkDisplay = if ($hotspot.MethodUrl) { "[View]($($hotspot.MethodUrl))" } elseif ($hotspot.ClassUrl) { "[View]($($hotspot.ClassUrl))" } else { '-' }
                    $builder.AppendLine("| $($hotspot.Assembly) | ``$($hotspot.Method)`` | $([math]::Round($hotspot.CrapScore, 1)) | $($hotspot.CyclomaticComplexity) | $linkDisplay |") | Out-Null
                }

                if ($crapHotspotCount -gt $crapHotspotsPreview.Count) {
                    $builder.AppendLine() | Out-Null
                    $builder.AppendLine("_Additional hotspots available in test-results/coverage-report/index.html_.") | Out-Null
                }

                $builder.AppendLine() | Out-Null
                $builder.AppendLine('### Remediation Guidance') | Out-Null
                $builder.AppendLine() | Out-Null
                if ($crapGuidance.Count -gt 0) {
                    foreach ($line in $crapGuidance) {
                        $builder.AppendLine("- $line") | Out-Null
                    }
                }
                else {
                    $builder.AppendLine('No specific remediation guidance available yet. Inspect the coverage report for detailed recommendations.') | Out-Null
                }
                $builder.AppendLine() | Out-Null
            }
            else {
                $builder.AppendLine("## CRAP Hotspots") | Out-Null
                $builder.AppendLine() | Out-Null
                $builder.AppendLine("No functions exceed the CRAP threshold of $CrapHotspotThreshold.") | Out-Null
                if ($crapGuidance.Count -gt 0) {
                    $builder.AppendLine() | Out-Null
                    $builder.AppendLine('### Remediation Guidance') | Out-Null
                    $builder.AppendLine() | Out-Null
                    foreach ($line in $crapGuidance) {
                        $builder.AppendLine("- $line") | Out-Null
                    }
                    $builder.AppendLine() | Out-Null
                }
            }

            $builder.AppendLine('## Suggested AI Prompts') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('### General Test Improvement') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('```text') | Out-Null
            $builder.AppendLine('@workspace Review the coverage report at test-results/coverage-report/AI-SUMMARY.md.') | Out-Null
            $builder.AppendLine("Focus on the files with coverage below $MinCoverage%.") | Out-Null
            $builder.AppendLine('Generate tests that cover edge cases, invalid inputs, and error handling.') | Out-Null
            $builder.AppendLine('```') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('### Low Coverage Files') | Out-Null
            $builder.AppendLine() | Out-Null

            foreach ($file in $lowCoverageFiles) {
                $className = $file.Name -replace '^.*\.([^.]+)$', '$1'
                $fileCoverage = [math]::Round($file.Coverage, 1)
                $builder.AppendLine("#### $className ($fileCoverage%)") | Out-Null
                $builder.AppendLine() | Out-Null
                $builder.AppendLine('```text') | Out-Null
                $builder.AppendLine("@workspace Focus on tests for $className in $($file.Assembly).") | Out-Null
                $builder.AppendLine("Current coverage: $fileCoverage%. Target: $MinCoverage%.") | Out-Null
                $builder.AppendLine('Add tests covering:') | Out-Null
                $builder.AppendLine('1. Happy path scenarios') | Out-Null
                $builder.AppendLine('2. Edge cases and invalid inputs') | Out-Null
                $builder.AppendLine('3. Error handling and exceptions') | Out-Null
                $builder.AppendLine('4. Branching logic and alternate flows') | Out-Null
                $builder.AppendLine('```') | Out-Null
                $builder.AppendLine() | Out-Null
            }

            $builder.AppendLine('## Next Steps') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('1. Work through the low coverage files above.') | Out-Null
            $builder.AppendLine('2. Use the suggested prompts to generate targeted tests.') | Out-Null
            $builder.AppendLine('3. Re-run ``.\scripts\code-coverage\New-CoverageSummary.ps1`` to verify improvements.') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('## Tips for Using with AI Development Tools') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('- **Provide context**: Open related source files before prompting the AI tool.') | Out-Null
            $builder.AppendLine('- **Iterate**: Ask the AI tool to refine tests if assertions are weak or missing edge cases.') | Out-Null
            $builder.AppendLine('- **Review**: Always review and run generated tests before committing changes.') | Out-Null
            $builder.AppendLine() | Out-Null
            $builder.AppendLine('*Generated by New-CoverageSummary.ps1*') | Out-Null

            [System.IO.File]::WriteAllText($markdownPath, $builder.ToString(), [System.Text.Encoding]::UTF8)
            Write-Output "[INFO] AI summary (Markdown) saved to: $markdownPath"
        }

        if ($OutputFormat -eq 'json' -or $OutputFormat -eq 'both') {
            $AIData = @{
                generatedAt        = (Get-Date).ToString('o')
                minCoverage        = $MinCoverage
                overall            = @{
                    lines    = $overallLineCoverage
                    branches = $overallBranchCoverage
                    methods  = $overallMethodCoverage
                    coveredLines    = $coveredLines
                    coverableLines  = $coverableLines
                    uncoveredLines  = $uncoveredLines
                    coveredBranches = $coveredBranches
                    totalBranches   = $totalBranches
                    uncoveredBranches = $uncoveredBranches
                }
                lowCoverage        = $lowCoverageFiles | ForEach-Object {
                    @{
                        assembly        = $_.Assembly
                        class           = $_.Name
                        coverage        = [math]::Round($_.Coverage, 2)
                        coveredLines    = $_.CoveredLines
                        coverableLines  = $_.CoverableLines
                        coveredBranches = $_.CoveredBranches
                        totalBranches   = $_.TotalBranches
                    }
                }
                crapHotspots       = $crapHotspots | ForEach-Object {
                    @{
                        assembly   = $_.Assembly
                        class      = $_.Class
                        method     = $_.Method
                        crapScore  = [math]::Round($_.CrapScore, 1)
                        complexity = $_.CyclomaticComplexity
                        classUrl   = $_.ClassUrl
                        methodUrl  = $_.MethodUrl
                    }
                }
                crapThreshold      = $CrapHotspotThreshold
                crapGuidance       = @($crapGuidance)
            }

            $AIData | ConvertTo-Json -Depth 10 | Out-File -FilePath $jsonDataPath -Encoding UTF8
            Write-Output "[INFO] AI data (JSON) saved to: $jsonDataPath"
        }

        Write-Output ""
        Write-Output "--------------------------------------------"
        Write-Output "Coverage Summary"
        Write-Output "--------------------------------------------"
        Write-Output "  Line Coverage:   $overallLineCoverage%"
        Write-Output "  Branch Coverage: $overallBranchCoverage%"
        Write-Output "  Method Coverage: $overallMethodCoverage%"
        Write-Output ""
        Write-Output "  Files below ${MinCoverage}%: $($lowCoverageFiles.Count)"
        Write-Output "  CRAP hotspots (CRAP = $CrapHotspotThreshold): $crapHotspotCount"
        Write-Output "--------------------------------------------"
        Write-Output ""
        Write-Output "Ready for Fixing!"
        if ($OutputFormat -eq 'markdown' -or $OutputFormat -eq 'both') {
            Write-Output "   Summary: test-results/coverage-report/AI-SUMMARY.md"
        }
        if ($OutputFormat -eq 'json' -or $OutputFormat -eq 'both') {
            Write-Output "   JSON: test-results/coverage-report/AI-DATA.json"
        }
        Write-Output ""
        Write-Output "Next: Run .\scripts\code-coverage\New-CoveragePromptBuilder.ps1 for automated test generation prompts"
        Write-Output ""

        return [PSCustomObject]$result
    }
    finally {
        Pop-Location
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-CoverageForAI @PSBoundParameters 
    #| Out-Null
}
