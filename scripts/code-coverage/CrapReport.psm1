#requires -Version 7.0

using namespace System.Text.RegularExpressions
using namespace System.Globalization
using namespace System.Net
using namespace System.Management.Automation

function Get-CrapHotspots {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReportPath,

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$MinimumCrapScore = 0
    )

    if (-not (Test-Path -LiteralPath $ReportPath)) {
        $exception = [System.IO.FileNotFoundException]::new("Coverage report not found at path '$ReportPath'.", $ReportPath)
        $errorRecord = [ErrorRecord]::new($exception, 'CrapReport.FileNotFound', [ErrorCategory]::ObjectNotFound, $ReportPath)
        throw $errorRecord
    }

    $content = Get-Content -LiteralPath $ReportPath -Raw

    $hotspotMatch = [Regex]::Match($content, '<risk-hotspots>(.*?)</risk-hotspots>', [RegexOptions]::Singleline)
    if (-not $hotspotMatch.Success) {
        return @()
    }

    $rows = @()
    $rowMatches = [Regex]::Matches($hotspotMatch.Groups[1].Value, '<tr>(.*?)</tr>', [RegexOptions]::Singleline)
    foreach ($rowMatch in $rowMatches) {
        $rowContent = $rowMatch.Groups[1].Value
        if ($rowContent -notmatch '<td') {
            continue
        }

        $cellMatches = [Regex]::Matches($rowContent, '<td[^>]*>(.*?)</td>', [RegexOptions]::Singleline)
        if ($cellMatches.Count -lt 5) {
            continue
        }

        $assemblyText = ConvertTo-InnerText $cellMatches[0].Groups[1].Value
        $classCell = $cellMatches[1].Groups[1].Value
        $methodCell = $cellMatches[2].Groups[1].Value
        $crapCell = $cellMatches[3].Groups[1].Value
        $complexityCell = $cellMatches[4].Groups[1].Value

        $classUrl = Get-LinkHref $cellMatches[1].Groups[1].Value
        $methodUrl = Get-LinkHref $cellMatches[2].Groups[1].Value

        $classText = ConvertTo-InnerText $classCell
        $methodText = ConvertTo-InnerText $methodCell

        $crapScore = ConvertTo-Double $crapCell
        $complexity = ConvertTo-Int $complexityCell

        if ($crapScore -lt $MinimumCrapScore) {
            continue
        }

        $rows += [pscustomobject]@{
            Assembly             = $assemblyText
            Class                = $classText
            ClassUrl             = $classUrl
            Method               = $methodText
            MethodUrl            = $methodUrl
            CrapScore            = $crapScore
            CyclomaticComplexity = $complexity
        }
    }

    return $rows | Sort-Object -Property CrapScore -Descending
}

function Get-CrapInsights {
    [CmdletBinding()]
    [OutputType([pscustomobject])]
    param(
        [Parameter(Mandatory = $true)]
        [string]$ReportPath,

        [Parameter()]
        [ValidateRange(0, [double]::MaxValue)]
        [double]$MinimumCrapScore = 0,

        [Parameter()]
        [ValidateRange(1, [int]::MaxValue)]
        [int]$MaxGuidanceItems = 5
    )

    $hotspots = Get-CrapHotspots -ReportPath $ReportPath -MinimumCrapScore $MinimumCrapScore
    $guidance = [System.Collections.Generic.List[string]]::new()

    if ($hotspots.Count -eq 0) {
        [void]$guidance.Add("No CRAP hotspots exceeded the threshold of $MinimumCrapScore. Focus on low coverage files first.")
    }
    else {
        $topHotspots = $hotspots | Select-Object -First $MaxGuidanceItems
        foreach ($hotspot in $topHotspots) {
            $target = if ($hotspot.MethodUrl) {
                $hotspot.MethodUrl
            }
            elseif ($hotspot.ClassUrl) {
                $hotspot.ClassUrl
            }
            else {
                'testresults/coverage-report/index.html'
            }

            $message = [string]::Format(
                'Prioritize additional tests or refactoring for {0}::{1} (CRAP {2}, complexity {3}). Inspect {4} for uncovered branches.',
                $hotspot.Class,
                $hotspot.Method,
                [math]::Round($hotspot.CrapScore, 1),
                $hotspot.CyclomaticComplexity,
                $target)

            [void]$guidance.Add($message)
        }

        if ($hotspots.Count -gt $topHotspots.Count) {
            [void]$guidance.Add('Additional hotspots are listed in testresults/coverage-report/index.html.')
        }
    }

    return [pscustomobject]@{
        Hotspots = $hotspots
        Guidance = @($guidance)
    }
}

function ConvertTo-InnerText {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Html
    )

    if ([string]::IsNullOrWhiteSpace($Html)) {
        return ''
    }

    $stripped = [Regex]::Replace($Html, '<.*?>', ' ')
    $decoded = [WebUtility]::HtmlDecode($stripped)
    return ($decoded -replace '\s+', ' ').Trim()
}

function Get-LinkHref {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Html
    )

    $match = [Regex]::Match($Html, 'href\s*=\s*"(?<href>[^"]+)"', [RegexOptions]::IgnoreCase)
    if ($match.Success) {
        return $match.Groups['href'].Value
    }

    return $null
}

function ConvertTo-Double {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    [double]$parsed = 0
    if ([double]::TryParse($Value, [NumberStyles]::Any, [CultureInfo]::InvariantCulture, [ref]$parsed)) {
        return $parsed
    }

    return 0
}

function ConvertTo-Int {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Value
    )

    [int]$parsed = 0
    if ([int]::TryParse($Value, [NumberStyles]::Integer, [CultureInfo]::InvariantCulture, [ref]$parsed)) {
        return $parsed
    }

    return 0
}

Export-ModuleMember -Function Get-CrapHotspots, Get-CrapInsights
