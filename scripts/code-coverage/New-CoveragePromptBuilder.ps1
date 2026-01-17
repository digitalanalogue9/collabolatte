#!/usr/bin/env pwsh
<#
.SYNOPSIS
    Automated coverage improvement loop with AI assistant-ready prompts.

.DESCRIPTION
    Runs coverage analysis, identifies the lowest-coverage files, blends in CRAP hotspots,
    and generates detailed prompt packs that can be fed to an AI assistant for targeted
    test or refactoring work. Output is written to test-results/ai-prompts.

.PARAMETER MinCoverage
    Minimum coverage threshold (default: 80%).

.PARAMETER MaxIterations
    Maximum number of files to analyse (default: 5).

.PARAMETER AutoRun
    If set, refreshes the coverage summary by running Update-CodeCoverageArtifacts.ps1 before generating prompts.

.PARAMETER Focus
    Focus on specific assembly family: 'FunctionApp', 'CodeGen', or 'All'.

.PARAMETER IgnoreListPath
    Path to a newline-delimited list of fully qualified or short type names to ignore.
    Defaults to .\scripts\code-coverage\coverage-ignore.txt if present.

.PARAMETER CrapHotspotThreshold
    Minimum CRAP score to include when reporting risk hotspots (default: 30).

.PARAMETER CrapHotspotMax
    Maximum number of CRAP hotspots to include in generated outputs (default: 10).

.PARAMETER RepoRoot
    Optional override for the repository root. Intended primarily for testing.

.PARAMETER ImportantNotice
    Optional string to include in the generated prompts as an important notice.

.EXAMPLE
    .\scripts\code-coverage\New-CoveragePromptBuilder.ps1 -AutoRun -MinCoverage 90 -CrapHotspotThreshold 10 -Focus All
    Run coverage and generate prompts for all assemblies, focusing on files below 90% coverage and CRAP hotspots above 10.

.EXAMPLE
    .\scripts\code-coverage\New-CoveragePromptBuilder.ps1
    Run coverage and generate prompts for the worst files.

.EXAMPLE
    .\scripts\code-coverage\New-CoveragePromptBuilder.ps1 -Focus FunctionApp -AutoRun
    Focus on FunctionApp assembly and skip confirmation.
#>

[CmdletBinding()]
param(
    [int]$MinCoverage = 80,
    [int]$MaxIterations = 5,
    [switch]$AutoRun,
    [ValidateSet('All', 'Api')]
    [string]$Focus = 'All',
    [string]$IgnoreListPath = '.\scripts\code-coverage\coverage-ignore.txt',
    [int]$CrapHotspotThreshold = 30,
    [int]$CrapHotspotMax = 10,
    [string]$RepoRoot,
    [string]$ImportantNotice = 'Collabolatte has strict trust-critical constraints: no surveillance features, data must be isolated by ProgrammeId, and participation is always voluntary. Any changes must comply with these principles.'
)

$ErrorActionPreference = 'Stop'
$InformationPreference = 'Continue'

function Get-SafeName {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return 'Item'
    }

    $safe = $Value -replace '[^A-Za-z0-9]+', '_'
    return $safe.Trim('_')
}

function Convert-ToRelativePath {
    param(
        [string]$RepoRoot,
        [string]$FullPath
    )

    if ([string]::IsNullOrWhiteSpace($FullPath)) {
        return $null
    }

    $relative = $FullPath -replace [regex]::Escape($RepoRoot), ''
    $relative = $relative -replace '^\\', ''
    return $relative -replace '\\', '/'
}

function Get-SourceFilePath {
    param(
        [string]$RepoRoot,
        [hashtable]$Cache,
        [string]$AssemblyShort,
        [string]$ClassName
    )

    $cacheKey = "$AssemblyShort|$ClassName"
    if ($Cache.ContainsKey($cacheKey)) {
        return $Cache[$cacheKey]
    }

    $classShort = if ($ClassName) { $ClassName -replace '^.*\.', '' } else { $null }
    $searchPattern = if ($classShort) { "*$classShort.cs" } else { '*.cs' }

    $searchRoots = [System.Collections.Generic.List[string]]::new()
    if ($AssemblyShort) {
        $searchRoots.Add((Join-Path $RepoRoot "apps/api/src/$AssemblyShort")) | Out-Null
        $searchRoots.Add((Join-Path $RepoRoot "apps/api/src")) | Out-Null
    }
    $searchRoots.Add((Join-Path $RepoRoot 'apps/api/src')) | Out-Null
    $searchRoots.Add((Join-Path $RepoRoot 'packages')) | Out-Null

    $found = $null
    foreach ($root in ($searchRoots | Select-Object -Unique)) {
        if (-not (Test-Path $root)) {
            continue
        }

        $found = Get-ChildItem -Path $root -Filter $searchPattern -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
        if ($found) { break }
    }

    $Cache[$cacheKey] = if ($found) { $found.FullName } else { $null }
    return $Cache[$cacheKey]
}

function Get-AssemblyShortName {
    param([string]$AssemblyName)

    if ([string]::IsNullOrWhiteSpace($AssemblyName)) {
        return 'Api'
    }

    $segments = $AssemblyName -split '\\.'
    $candidate = if ($segments.Count -gt 0) { $segments[-1] } else { $AssemblyName }

    if ($candidate -like '*Tests') {
        $candidate = $candidate -replace 'Tests$', ''
    }

    switch -Regex ($AssemblyName) {
        'Collabolatte\\.Api$' { return 'Api' }
        'Api$' { return 'Api' }
        'Functions' { return 'Functions' }
        'Application' { return 'Application' }
        'Contracts'   { return 'Contracts' }
        'Agent'       { return 'Agent' }
        default { return $candidate }
    }
}
function Invoke-CoverageLoop {
    [CmdletBinding()]
    param(
        [int]$MinCoverage = 80,
        [int]$MaxIterations = 5,
        [switch]$AutoRun,
        [string]$Focus = 'All',
        [string]$IgnoreListPath = '.\scripts\code-coverage\coverage-ignore.txt',
        [int]$CrapHotspotThreshold = 30,
        [int]$CrapHotspotMax = 10,
        [string]$RepoRoot
    )

    $resolvedRepoRoot = if ($RepoRoot) { Resolve-Path $RepoRoot } else { Resolve-Path (Join-Path $PSScriptRoot '../..') }
    $coverageDir = Join-Path $resolvedRepoRoot 'test-results/coverage-report'
    $summaryPath = Join-Path $coverageDir 'Summary.json'
    $promptsDir = Join-Path $resolvedRepoRoot 'test-results/ai-prompts'
    $ignoreSet = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    $sourcePathCache = @{}
    $runCoverageScript = Join-Path $PSScriptRoot 'Update-CodeCoverageArtifacts.ps1'

    Push-Location $resolvedRepoRoot
    try {
        Write-Output "[INFO] Coverage loop starting at $resolvedRepoRoot"

        $summaryExists = Test-Path $summaryPath
        $shouldRefreshCoverage = -not $summaryExists -or $AutoRun.IsPresent

        if ($shouldRefreshCoverage) {
            if (-not (Test-Path $runCoverageScript)) {
                throw "Required coverage script missing at $runCoverageScript."
            }

            if ($AutoRun.IsPresent -and $summaryExists) {
                Write-Output "[INFO] AutoRun enabled. Refreshing coverage summary via $runCoverageScript."
            }
            else {
                Write-Output "[INFO] Coverage summary not found at $summaryPath. Refreshing coverage..."
            }

            & $runCoverageScript
            if ($LASTEXITCODE -ne 0) {
                throw "Update-CodeCoverageArtifacts.ps1 failed with exit code $LASTEXITCODE."
            }

            if (-not (Test-Path $summaryPath)) {
                throw "Coverage summary still missing at $summaryPath after running Update-CodeCoverageArtifacts.ps1."
            }
        }

        if ($IgnoreListPath) {
            $resolvedIgnorePath = $IgnoreListPath
            if (-not (Test-Path $resolvedIgnorePath)) {
                $candidate = Join-Path $resolvedRepoRoot $IgnoreListPath
                if (Test-Path $candidate) {
                    $resolvedIgnorePath = $candidate
                }
            }

            if (Test-Path $resolvedIgnorePath) {
                Get-Content -Path $resolvedIgnorePath | ForEach-Object {
                    $entry = $_.Trim()
                    if (-not [string]::IsNullOrWhiteSpace($entry) -and -not $entry.StartsWith('#')) {
                        $ignoreSet.Add($entry) | Out-Null
                    }
                }
                Write-Output "[INFO] Loaded ignore list from $resolvedIgnorePath ($($ignoreSet.Count) entries)"
            }
        }

        $summary = Get-Content $summaryPath | ConvertFrom-Json

        $crapModulePath = Join-Path $PSScriptRoot 'CrapReport.psm1'
        $crapReportPath = Join-Path $coverageDir 'index.html'
        $crapHotspots = @()
        $crapGuidance = @()

        if ((Test-Path $crapModulePath) -and (Test-Path $crapReportPath)) {
            Import-Module $crapModulePath -Force -ErrorAction SilentlyContinue
            if (Get-Command Get-CrapInsights -ErrorAction SilentlyContinue) {
                try {
                    $insights = Get-CrapInsights -ReportPath $crapReportPath -MinimumCrapScore $CrapHotspotThreshold -MaxGuidanceItems ([math]::Max(5, $CrapHotspotMax))
                    $crapHotspots = @($insights.Hotspots)
                    $crapGuidance = @($insights.Guidance)
                }
                catch {
                    Write-Warning "Failed to parse CRAP hotspots: $_"
                    $crapHotspots = @()
                    $crapGuidance = @()
                }
            }
        }
        elseif (-not (Test-Path $crapReportPath)) {
            Write-Warning "CRAP report HTML not found at $crapReportPath."
        }

        $ignoredEntries = [System.Collections.Generic.List[object]]::new()

        $lowCoverageFiles = $summary.coverage.assemblies | ForEach-Object {
            $assemblyName = $_.name

            if ($Focus -ne 'All' -and ($assemblyName -notmatch [regex]::Escape($Focus))) {
                return
            }

            $_.classesinassembly | Where-Object { $_.coverage -lt $MinCoverage } | ForEach-Object {
                $shortName = $_.name -replace '^.*\.([^.]+)$', '$1'
                [PSCustomObject]@{
                    Assembly        = $assemblyName
                    Name            = $_.name
                    ShortName       = $shortName
                    Coverage        = $_.coverage
                    CoveredLines    = $_.coveredlines
                    CoverableLines  = $_.coverablelines
                    CoveredBranches = $_.coveredbranches
                    TotalBranches   = $_.totalbranches
                }
            }
        } | Where-Object {
            if ($ignoreSet.Count -eq 0) { return $true }

            $matchesIgnore = $ignoreSet.Contains($_.ShortName) -or $ignoreSet.Contains($_.Name)
            if ($matchesIgnore) {
                $ignoredEntries.Add($_) | Out-Null
                return $false
            }
            $true
        } | Sort-Object Coverage | Select-Object -First $MaxIterations

        if ($ignoredEntries.Count -gt 0) {
            $ignoredNames = $ignoredEntries | ForEach-Object { $_.ShortName } | Sort-Object -Unique
            Write-Output ("Skipped {0} low-coverage item(s) due to ignore list: {1}" -f $ignoredEntries.Count, ($ignoredNames -join ', '))
        }

        $crapHotspotCount = $crapHotspots.Count
        $crapHotspotLimit = [math]::Min($CrapHotspotMax, [math]::Max($crapHotspotCount, 0))
        $crapHotspotsPreview = if ($crapHotspotCount -gt 0) { $crapHotspots | Sort-Object CrapScore -Descending | Select-Object -First $crapHotspotLimit } else { @() }

        if ($crapHotspotCount -gt 0) {
            $crapHotspotDisplayCount = [math]::Min($crapHotspotLimit, $crapHotspotCount)
            Write-Output ("Top {0} CRAP hotspots (CRAP = {1})" -f $crapHotspotDisplayCount, $CrapHotspotThreshold)
            Write-Output ""
            $index = 1
            foreach ($hotspot in $crapHotspotsPreview) {
                Write-Output ("  [{0}] {1} :: {2} (CRAP {3}, Complexity {4})" -f $index, $hotspot.Class, $hotspot.Method, [math]::Round($hotspot.CrapScore, 1), $hotspot.CyclomaticComplexity)
                $index++
            }

            if ($crapHotspotCount -gt $crapHotspotsPreview.Count) {
                Write-Output ("  ...and {0} more (see test-results/coverage-report/index.html)" -f ($crapHotspotCount - $crapHotspotsPreview.Count))
            }

            if ($crapGuidance.Count -gt 0) {
                Write-Output "  Suggested remediation steps:"
                foreach ($line in $crapGuidance) {
                    Write-Output ("    - {0}" -f $line)
                }
            }

            Write-Output ""
        }
        else {
            Write-Output ("No CRAP hotspots at or above the threshold of {0}." -f $CrapHotspotThreshold)
            if ($crapGuidance.Count -gt 0) {
                Write-Output "  Suggested remediation steps:"
                foreach ($line in $crapGuidance) {
                    Write-Output ("    - {0}" -f $line)
                }
            }
            Write-Output ""
        }

        if ($lowCoverageFiles.Count -eq 0) {
            Write-Output "No files below $MinCoverage% coverage threshold."
            Write-Output "All files meet the quality bar. Great work!"
            return [PSCustomObject]@{
                RepoRoot         = $resolvedRepoRoot
                PromptDirectory  = $promptsDir
                PromptManifest   = @()
                LowCoverageFiles = $lowCoverageFiles
                CrapHotspots     = $crapHotspots
                IgnoredEntries   = $ignoredEntries
            }
        }

        Write-Output "Found $($lowCoverageFiles.Count) file(s) below $MinCoverage% coverage"
        Write-Output ""

        $workItems = [System.Collections.Generic.List[object]]::new()
        $coverageIndex = @{}

        foreach ($file in $lowCoverageFiles) {
            $assemblyShort = Get-AssemblyShortName -AssemblyName $file.Assembly
            $item = [PSCustomObject]@{
                Key           = $file.Name
                Type          = 'TEST'
                Assembly      = $file.Assembly
                AssemblyShort = $assemblyShort
                ClassName     = $file.Name
                ClassShort    = $file.ShortName
                Coverage      = $file
                CoverageGap   = [math]::Max(0, $MinCoverage - $file.Coverage)
                CrapEntries   = [System.Collections.Generic.List[object]]::new()
            }

            [void]$workItems.Add($item)

            if (-not [string]::IsNullOrWhiteSpace($file.Name)) {
                $coverageIndex[$file.Name] = $item
            }

            if (-not [string]::IsNullOrWhiteSpace($file.ShortName)) {
                $coverageIndex[$file.ShortName] = $item
            }
        }

        foreach ($hotspot in $crapHotspots) {
            $classKey = $hotspot.Class
            $classShort = if ($hotspot.Class) { $hotspot.Class -replace '^.*\.', '' } else { $null }

            $matchedCoverage = $null
            if ($classKey -and $coverageIndex.ContainsKey($classKey)) {
                $matchedCoverage = $coverageIndex[$classKey]
            }
            elseif ($classShort -and $coverageIndex.ContainsKey($classShort)) {
                $matchedCoverage = $coverageIndex[$classShort]
            }

            $crapEntry = [PSCustomObject]@{
                Method               = $hotspot.Method
                Class                = $hotspot.Class
                ClassShort           = $classShort
                Assembly             = $hotspot.Assembly
                CrapScore            = $hotspot.CrapScore
                CyclomaticComplexity = $hotspot.CyclomaticComplexity
                MethodUrl            = $hotspot.MethodUrl
                ClassUrl             = $hotspot.ClassUrl
            }

            if ($matchedCoverage) {
                [void]$matchedCoverage.CrapEntries.Add($crapEntry)
                if ($matchedCoverage.Type -ne 'TEST_CRAP') {
                    $matchedCoverage.Type = 'TEST_CRAP'
                }
                continue
            }

            $assemblyShort = Get-AssemblyShortName -AssemblyName $hotspot.Assembly
            $crapItem = [PSCustomObject]@{
                Key           = "{0}::{1}" -f $hotspot.Class, $hotspot.Method
                Type          = 'CRAP'
                Assembly      = $hotspot.Assembly
                AssemblyShort = $assemblyShort
                ClassName     = $hotspot.Class
                ClassShort    = $classShort
                Coverage      = $null
                CoverageGap   = 0
                CrapEntries   = [System.Collections.Generic.List[object]]::new()
            }
            [void]$crapItem.CrapEntries.Add($crapEntry)
            [void]$workItems.Add($crapItem)
        }

        foreach ($item in $workItems) {
            $highestCrap = $null
            if ($item.CrapEntries.Count -gt 0) {
                $highestCrap = ($item.CrapEntries | Sort-Object CrapScore -Descending | Select-Object -First 1).CrapScore
            }
            $item | Add-Member -NotePropertyName HighestCrapScore -NotePropertyValue $highestCrap -Force

            $coverageGap = if ($item.CoverageGap -gt 0) { [math]::Round($item.CoverageGap, 2) } else { 0 }
            $crapBoost = if ($highestCrap) { [math]::Max(0, [math]::Round($highestCrap - $CrapHotspotThreshold, 2)) } else { 0 }

            $priority = switch ($item.Type) {
                'TEST' { $coverageGap }
                'TEST_CRAP' { $coverageGap + $crapBoost }
                'CRAP' { $crapBoost }
                default { $coverageGap + $crapBoost }
            }

            $item | Add-Member -NotePropertyName PriorityScore -NotePropertyValue $priority -Force
        }

        $orderedItems = $workItems | Where-Object { $_.PriorityScore -gt 0 } | Sort-Object PriorityScore -Descending

        if ($orderedItems.Count -eq 0) {
            Write-Output "No actionable work items were generated."
            return [PSCustomObject]@{
                RepoRoot         = $resolvedRepoRoot
                PromptDirectory  = $promptsDir
                PromptManifest   = @()
                LowCoverageFiles = $lowCoverageFiles
                CrapHotspots     = $crapHotspots
                IgnoredEntries   = $ignoredEntries
            }
        }

        Write-Output ("Prepared {0} prioritized work item(s) for prompt generation" -f $orderedItems.Count)
        Write-Output ""

        if (Test-Path $promptsDir) {
            Remove-Item $promptsDir -Recurse -Force
        }
        New-Item -ItemType Directory -Path $promptsDir | Out-Null

        $masterEntries = [System.Collections.Generic.List[object]]::new()
        $iteration = 1

        foreach ($item in $orderedItems) {
            $assemblyShort = if ($item.AssemblyShort) { $item.AssemblyShort } else { Get-AssemblyShortName -AssemblyName $item.Assembly }
            $classDisplay = if ($item.ClassShort) { $item.ClassShort } elseif ($item.ClassName) { $item.ClassName -replace '^.*\.', '' } else { 'Target' }
            $primaryCrap = $null
            if ($item.CrapEntries.Count -gt 0) {
                $primaryCrap = $item.CrapEntries | Sort-Object CrapScore -Descending | Select-Object -First 1
            }

            $slugSource = switch ($item.Type) {
                'CRAP' {
                    if ($primaryCrap) {
                        Get-SafeName "$($primaryCrap.ClassShort)_$($primaryCrap.Method)"
                    }
                    else {
                        Get-SafeName $classDisplay
                    }
                }
                default { Get-SafeName $classDisplay }
            }

            if ([string]::IsNullOrWhiteSpace($slugSource)) {
                $slugSource = 'Target'
            }

            $promptFileName = '{0}-{1}-{2}-prompt.md' -f $iteration, $item.Type, $slugSource
            $promptFilePath = Join-Path $promptsDir $promptFileName

            $sourceFile = $null
            if ($item.Type -ne 'CRAP') {
                $sourceFile = Get-SourceFilePath -RepoRoot $resolvedRepoRoot -Cache $sourcePathCache -AssemblyShort $assemblyShort -ClassName $item.ClassName
            }
            elseif ($primaryCrap) {
                $sourceFile = Get-SourceFilePath -RepoRoot $resolvedRepoRoot -Cache $sourcePathCache -AssemblyShort $assemblyShort -ClassName $primaryCrap.Class
            }

            $relativeSource = Convert-ToRelativePath -RepoRoot $resolvedRepoRoot -FullPath $sourceFile
            $testsProjectPath = "tests/$assemblyShort.Tests/"

            $builder = [System.Text.StringBuilder]::new()

            if ($item.Type -eq 'CRAP') {
                $methodName = if ($primaryCrap) { $primaryCrap.Method } else { 'Method' }
                $className = if ($primaryCrap) { $primaryCrap.Class } else { $item.ClassName }
                $crapScore = if ($primaryCrap) { [math]::Round($primaryCrap.CrapScore, 1) } else { $null }
                $complexity = if ($primaryCrap) { $primaryCrap.CyclomaticComplexity } else { $null }

                [void]$builder.AppendLine("# Complexity Reduction Plan for $methodName")
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## Snapshot')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine("- **Class**: ``$className``")
                if ($relativeSource) { [void]$builder.AppendLine("- **Source**: ``$relativeSource``") }
                [void]$builder.AppendLine("- **Assembly**: $($item.Assembly)")
                if ($crapScore) { [void]$builder.AppendLine("- **CRAP score**: $crapScore") }
                if ($complexity) { [void]$builder.AppendLine("- **Cyclomatic complexity**: $complexity") }
                if ($primaryCrap.MethodUrl) { [void]$builder.AppendLine("- **Report link**: $($primaryCrap.MethodUrl)") }
                elseif ($primaryCrap.ClassUrl) { [void]$builder.AppendLine("- **Report link**: $($primaryCrap.ClassUrl)") }
                else { [void]$builder.AppendLine('- **Report**: test-results/coverage-report/index.html') }

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## What To Do')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('1. Review the method and note branches, deep nesting, or duplication driving the score.')
                [void]$builder.AppendLine('2. Plan refactors that lower complexity without altering behaviour (helpers, guards, early returns).')
                [void]$builder.AppendLine("3. Update or create tests in ``$testsProjectPath`` before finalising changes so behaviour stays locked down.")
                [void]$builder.AppendLine('4. Add cases that exercise risky paths: error handling, null inputs, boundary data.')
                [void]$builder.AppendLine('5. Keep naming and XML documentation consistent with nearby code when introducing helpers.')
                if ($ImportantNotice) { [void]$builder.AppendLine("6. $ImportantNotice") }

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## AI Assistant Prompt')
                [void]$builder.AppendLine()

                $promptLines = [System.Collections.Generic.List[string]]::new()
                [void]$promptLines.Add('```text')
                [void]$promptLines.Add("Goal: reduce the CRAP score for $className.$methodName in $assemblyShort.")
                if ($crapScore) { [void]$promptLines.Add("Current CRAP score: $crapScore (threshold $CrapHotspotThreshold).") }
                if ($complexity) { [void]$promptLines.Add("Cyclomatic complexity: $complexity.") }
                if ($relativeSource) { [void]$promptLines.Add("Source file: $relativeSource") }
                else { [void]$promptLines.Add("Source file: find $className under src/$assemblyShort or tools/$assemblyShort") }
                [void]$promptLines.Add("Tests target: $testsProjectPath")
                [void]$promptLines.Add('')
                [void]$promptLines.Add('Deliverables:')
                [void]$promptLines.Add('1. Summarise high-risk areas causing complexity.')
                [void]$promptLines.Add('2. Describe refactor steps that keep behaviour intact.')
                [void]$promptLines.Add('3. Provide the refactored method code.')
                [void]$promptLines.Add('4. Supply the supporting xUnit tests using AwesomeAssertions and NSubstitute as needed.')
                if ($ImportantNotice) { [void]$promptLines.Add("5. $ImportantNotice") }
                [void]$promptLines.Add('```')

                foreach ($line in $promptLines) {
                    [void]$builder.AppendLine($line)
                }

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## After Refactoring')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('1. Run ``dotnet test`` for the impacted projects.')
                [void]$builder.AppendLine('2. Re-run coverage: ``.\scripts\code-coverage\New-CoverageSummary.ps1``.')
                [void]$builder.AppendLine('3. Confirm the CRAP score improved in ``test-results/coverage-report/index.html``.')
                [void]$builder.AppendLine('4. Move to the next prompt once the score reduction is verified.')
            }
            else {
                $coverage = $item.Coverage
                $fileCoverage = [math]::Round($coverage.Coverage, 1)
                $coverageGap = [math]::Round($MinCoverage - $coverage.Coverage, 1)
                $lineSummary = "{0}/{1}" -f $coverage.CoveredLines, $coverage.CoverableLines
                $branchSummary = "{0}/{1}" -f $coverage.CoveredBranches, $coverage.TotalBranches

                $title = if ($item.Type -eq 'TEST_CRAP') { 'Coverage & Complexity Plan' } else { 'Test Coverage Improvement Plan' }
                [void]$builder.AppendLine("# $title for $($item.ClassShort)")
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## Snapshot')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine("- **Class**: ``$($coverage.Name)``")
                if ($relativeSource) { [void]$builder.AppendLine("- **Source**: ``$relativeSource``") }
                else { [void]$builder.AppendLine("- **Source**: search for ``$($item.ClassShort).cs`` under ``src/$assemblyShort`` or ``tools/$assemblyShort``") }
                [void]$builder.AppendLine("- **Assembly**: $($item.Assembly)")
                [void]$builder.AppendLine("- **Line coverage**: **$fileCoverage%** ($lineSummary lines)")
                [void]$builder.AppendLine("- **Branch coverage**: $branchSummary branches")
                [void]$builder.AppendLine("- **Target**: $MinCoverage% (gap: $coverageGap%)")

                if ($item.CrapEntries.Count -gt 0) {
                    [void]$builder.AppendLine()
                    [void]$builder.AppendLine('## Notable Hotspots In Class')
                    [void]$builder.AppendLine()
                    [void]$builder.AppendLine('| Method | CRAP | Complexity | Link |')
                    [void]$builder.AppendLine('|--------|------|------------|------|')
                    foreach ($entry in ($item.CrapEntries | Sort-Object CrapScore -Descending)) {
                        $linkDisplay = if ($entry.MethodUrl) { $entry.MethodUrl } elseif ($entry.ClassUrl) { $entry.ClassUrl } else { 'test-results/coverage-report/index.html' }
                        [void]$builder.AppendLine("| ``$($entry.Method)`` | $([math]::Round($entry.CrapScore, 1)) | $($entry.CyclomaticComplexity) | $linkDisplay |")
                    }
                }

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## What To Do')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('1. Audit the current tests - where do we miss coverage?')
                [void]$builder.AppendLine('2. Add tests targeting missing branches, edge cases, and error handling.')
                [void]$builder.AppendLine('3. Consider refactoring for clarity if complexity hotspots are present.')
                [void]$builder.AppendLine('4. Keep naming consistent and validate with AwesomeAssertions/NSubstitute.')

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## AI Assistant Prompt')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('```text')
                [void]$builder.AppendLine("Goal: raise coverage for $($item.ClassShort) in $assemblyShort to at least $MinCoverage%.")
                if ($relativeSource) { [void]$builder.AppendLine("Source file: $relativeSource") }
                else { [void]$builder.AppendLine("Source file: locate $($item.ClassShort).cs under src/$assemblyShort or tools/$assemblyShort") }
                [void]$builder.AppendLine("Tests project: $testsProjectPath")
                [void]$builder.AppendLine("Current coverage: $fileCoverage% (gap: $coverageGap%).")
                if ($item.CrapEntries.Count -gt 0) {
                    $top = $item.CrapEntries | Sort-Object CrapScore -Descending | Select-Object -First 1
                    [void]$builder.AppendLine("Hotspot method: $($top.Method) (CRAP $([math]::Round($top.CrapScore, 1))).")
                }
                [void]$builder.AppendLine('')
                [void]$builder.AppendLine('Deliverables: improved tests with clear Arrange/Act/Assert, covering success, failure, and edge paths.')
                [void]$builder.AppendLine('```')

                [void]$builder.AppendLine()
                [void]$builder.AppendLine('## After Shipping Tests')
                [void]$builder.AppendLine()
                [void]$builder.AppendLine('1. Run ``dotnet test`` locally.')
                [void]$builder.AppendLine('2. Re-run coverage: ``.\scripts\code-coverage\New-CoverageSummary.ps1``.')
                [void]$builder.AppendLine('3. Confirm the coverage gain in ``test-results/coverage-report/index.html``.')
                [void]$builder.AppendLine('4. Update any related documentation if behaviour shifted.')
            }

            [System.IO.File]::WriteAllText($promptFilePath, $builder.ToString(), [System.Text.Encoding]::UTF8)
            Write-Output "[$iteration/$($orderedItems.Count)] Generated $($item.Type) prompt -> test-results/ai-prompts/$promptFileName"

            $masterEntry = [PSCustomObject]@{
                Index         = $iteration
                Type          = $item.Type
                AssemblyShort = $assemblyShort
                ClassShort    = $classDisplay
                ClassName     = $item.ClassName
                PromptFile    = $promptFileName
                Coverage      = $item.Coverage
                CoverageGap   = $item.CoverageGap
                HighestCrap   = $item.HighestCrapScore
                CrapCount     = $item.CrapEntries.Count
                PrimaryMethod = if ($primaryCrap) { $primaryCrap.Method } else { $null }
            }
            [void]$masterEntries.Add($masterEntry)

            $iteration++
        }

        $masterPromptPath = Join-Path $promptsDir '00-MASTER-PROMPT.md'

        $masterBuilder = [System.Text.StringBuilder]::new()
        [void]$masterBuilder.AppendLine('# Coverage & Complexity Master Plan')
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine("Arguments: -Focus '$Focus' -MinCoverage $MinCoverage% -CrapHotspotThreshold $CrapHotspotThreshold -CrapHotspotMax $CrapHotspotMax -MaxIterations $MaxIterations")
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('## Overall Status')
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine("- **Focus**: $Focus")
        [void]$masterBuilder.AppendLine("- **Coverage threshold**: $MinCoverage%")
        [void]$masterBuilder.AppendLine("- **Coverage gaps identified**: $($lowCoverageFiles.Count)")
        [void]$masterBuilder.AppendLine("- **CRAP hotspots considered**: $crapHotspotCount")
        [void]$masterBuilder.AppendLine("- **Prompts generated**: $($masterEntries.Count)")

        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('## Prioritized Work Queue')

        foreach ($entry in $masterEntries) {
            $coverageSection = ''
            if ($entry.Coverage) {
                $coverageValue = [math]::Round($entry.Coverage.Coverage, 1)
                $gapValue = [math]::Round($MinCoverage - $entry.Coverage.Coverage, 1)
                $coverageSection = "- **Coverage**: $coverageValue% (gap $gapValue%)`n- **Lines**: $($entry.Coverage.CoveredLines)/$($entry.Coverage.CoverableLines) | Branches $($entry.Coverage.CoveredBranches)/$($entry.Coverage.TotalBranches)"
            }

            $crapSection = ''
            if ($entry.HighestCrap) {
                $crapSection = "- **Highest CRAP**: $([math]::Round($entry.HighestCrap, 1)) (methods: $($entry.CrapCount))"
            }

            $titleLabel = if ($entry.Type -eq 'CRAP' -and $entry.PrimaryMethod) {
                "{0} [{1}] {2}.{3}" -f $entry.Index, $entry.Type, $entry.AssemblyShort, $entry.PrimaryMethod
            }
            elseif ($entry.PrimaryMethod -and $entry.Type -eq 'TEST_CRAP') {
                "{0} [{1}] {2}/{3} (hotspot: {4})" -f $entry.Index, $entry.Type, $entry.AssemblyShort, $entry.ClassShort, $entry.PrimaryMethod
            }
            else {
                "{0} [{1}] {2}/{3}" -f $entry.Index, $entry.Type, $entry.AssemblyShort, $entry.ClassShort
            }

            [void]$masterBuilder.AppendLine()
            [void]$masterBuilder.AppendLine("### $titleLabel`n")
            if ($coverageSection) { [void]$masterBuilder.AppendLine($coverageSection) }
            if ($crapSection) { [void]$masterBuilder.AppendLine($crapSection) }
            [void]$masterBuilder.AppendLine("- **Prompt**: ``$($entry.PromptFile)``")
        }

        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('## Recommended Workflow')
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('1. Work through the prompt files in numerical order (they are already sorted by combined priority).')
        [void]$masterBuilder.AppendLine('2. Complete every prompt in this batch before rerunning the coverage loop to avoid reshuffling in-progress tasks.')
        [void]$masterBuilder.AppendLine('3. After finishing the batch, execute ``.\scripts\code-coverage\New-CoveragePromptBuilder.ps1 -AutoRun`` to regenerate statistics and a new queue if needed.')

        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('## Quick Access')
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('- **Prompts folder**: ``test-results/ai-prompts/``')
        [void]$masterBuilder.AppendLine('- **Coverage report**: ``test-results/coverage-report/index.html``')
        [void]$masterBuilder.AppendLine('- **CRAP threshold**: ' + $CrapHotspotThreshold)

        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('---')
        [void]$masterBuilder.AppendLine()
        [void]$masterBuilder.AppendLine('Start with ``1-*-prompt.md`` and only rerun the loop once every work item here is complete.')

        [System.IO.File]::WriteAllText($masterPromptPath, $masterBuilder.ToString(), [System.Text.Encoding]::UTF8)

        Write-Output ""
        Write-Output "--------------------------------------------"
        Write-Output "Coverage loop complete"
        Write-Output "--------------------------------------------"
        Write-Output ""
        Write-Output "Generated $($masterEntries.Count) prioritized prompt(s)"
        Write-Output "Location: test-results/ai-prompts/"
        Write-Output ""
        Write-Output "Next steps:"
        Write-Output "  1. Open: test-results/ai-prompts/00-MASTER-PROMPT.md"
        Write-Output "  2. Complete prompts in order, covering both tests and CRAP remediation as directed"
        Write-Output "  3. Re-run this script only after the full prompt batch is complete"
        Write-Output ""

        return [PSCustomObject]@{
            RepoRoot         = $resolvedRepoRoot
            PromptDirectory  = $promptsDir
            PromptManifest   = $masterEntries
            LowCoverageFiles = $lowCoverageFiles
            CrapHotspots     = $crapHotspots
            IgnoredEntries   = $ignoredEntries
        }
    }
    finally {
        Pop-Location
    }
}

if ($MyInvocation.InvocationName -ne '.') {
    Invoke-CoverageLoop @PSBoundParameters
    #| Out-Null
}
