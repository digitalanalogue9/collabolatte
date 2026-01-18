#requires -Version 7.0

Describe "CrapReport module" {
  BeforeAll {
    $modulePath = Join-Path $PSScriptRoot '..' | Join-Path -ChildPath 'CrapReport.psm1'
    if (-not (Test-Path $modulePath)) {
      throw "CrapReport module not found at path '$modulePath'."
    }

    Import-Module $modulePath -Force -ErrorAction Stop
  }

  AfterAll {
    Remove-Module CrapReport -ErrorAction SilentlyContinue
  }

  Context "Get-CrapHotspots" {
    It "parses CRAP hotspot rows and sorts by score" {
        $html = @'
<html>
<body>
<risk-hotspots>
  <table>
    <tbody>
      <tr>
        <td>FunctionApp</td>
        <td><a href="FunctionApp_ClassA.html">FunctionApp.ClassA</a></td>
        <td title="DoWork()"><a href="FunctionApp_ClassA.html#file0_line10">DoWork()</a></td>
        <td>25</td>
        <td>10</td>
      </tr>
      <tr>
        <td>FunctionApp</td>
        <td><a href="FunctionApp_ClassB.html">FunctionApp.ClassB</a></td>
        <td title="HeavyLift()"><a href="FunctionApp_ClassB.html#file0_line99">HeavyLift()</a></td>
        <td>37</td>
        <td>12</td>
      </tr>
    </tbody>
  </table>
</risk-hotspots>
</body>
</html>
'@
        $reportPath = Join-Path $TestDrive 'report.html'
        Set-Content -Path $reportPath -Value $html -Encoding UTF8

  $results = Get-CrapHotspots -ReportPath $reportPath

  $results.Count | Should Be 2
  $results[0].Assembly | Should Be "FunctionApp"
  $results[0].Method | Should Be "HeavyLift()"
  $results[0].CrapScore | Should Be 37
  $results[0].CyclomaticComplexity | Should Be 12
  $results[0].Class | Should Be "FunctionApp.ClassB"
  $results[0].ClassUrl | Should Be "FunctionApp_ClassB.html"
  $results[0].MethodUrl | Should Be "FunctionApp_ClassB.html#file0_line99"
  }

  It "applies a minimum CRAP score filter" {
        $html = @'
<html>
<body>
<risk-hotspots>
  <table>
    <tbody>
      <tr>
        <td>FunctionApp</td>
        <td><a href="FunctionApp_ClassA.html">FunctionApp.ClassA</a></td>
        <td title="DoWork()"><a href="FunctionApp_ClassA.html#file0_line10">DoWork()</a></td>
        <td>18</td>
        <td>9</td>
      </tr>
    </tbody>
  </table>
</risk-hotspots>
</body>
</html>
'@
        $reportPath = Join-Path $TestDrive 'report-filter.html'
        Set-Content -Path $reportPath -Value $html -Encoding UTF8

    $results = Get-CrapHotspots -ReportPath $reportPath -MinimumCrapScore 20

    $results.Count | Should Be 0
    }

    It "returns empty collection when risk hotspot table missing" {
        $html = '<html><body><h1>No hotspots</h1></body></html>'
        $reportPath = Join-Path $TestDrive 'report-empty.html'
        Set-Content -Path $reportPath -Value $html -Encoding UTF8

    $results = Get-CrapHotspots -ReportPath $reportPath

    $results.Count | Should Be 0
    }

    It "throws descriptive error when report not found" {
        $missingPath = Join-Path $TestDrive 'missing.html'

        try {
            Get-CrapHotspots -ReportPath $missingPath
            throw 'Expected Get-CrapHotspots to throw.'
        }
        catch {
            $_.FullyQualifiedErrorId | Should Be 'CrapReport.FileNotFound'
        }
    }
    }

  Context "Get-CrapInsights" {
    It "returns hotspots with remediation guidance" {
      $html = @'
<html>
<body>
<risk-hotspots>
  <table>
  <tbody>
    <tr>
    <td>FunctionApp</td>
    <td><a href="FunctionApp_ClassA.html">FunctionApp.ClassA</a></td>
    <td title="DoWork()"><a href="FunctionApp_ClassA.html#file0_line10">DoWork()</a></td>
    <td>42</td>
    <td>15</td>
    </tr>
  </tbody>
  </table>
</risk-hotspots>
</body>
</html>
'@
      $reportPath = Join-Path $TestDrive 'insights.html'
      Set-Content -Path $reportPath -Value $html -Encoding UTF8

      $insights = Get-CrapInsights -ReportPath $reportPath -MinimumCrapScore 30 -MaxGuidanceItems 1

      $insights.Hotspots.Count | Should Be 1
      $insights.Guidance.Count | Should Be 1
      $insights.Guidance[0] | Should Match 'FunctionApp.ClassA::DoWork\(\)'
      $insights.Guidance[0] | Should Match 'CRAP 42'
    }

    It "returns fallback guidance when no hotspots meet threshold" {
      $html = '<html><body><risk-hotspots></risk-hotspots></body></html>'
      $reportPath = Join-Path $TestDrive 'no-hotspots.html'
      Set-Content -Path $reportPath -Value $html -Encoding UTF8

      $insights = Get-CrapInsights -ReportPath $reportPath -MinimumCrapScore 10

      $insights.Hotspots.Count | Should Be 0
      $insights.Guidance.Count | Should Be 1
      $insights.Guidance[0] | Should Match 'No CRAP hotspots exceeded the threshold'
    }
  }
}
