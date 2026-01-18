 [CmdletBinding()]
param(
    # Defaults cover ports used by local dev, previews, Storybook, and SWA CLI.
    [int[]] $Ports = @(3000, 8080, 5173, 6006, 7071, 7076, 4280),
    [switch] $Kill
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ListeningConnections {
    param(
        [int[]] $Ports
    )

    $connections = @()

    Write-Verbose ("Checking ports: {0}" -f ($Ports -join ", "))
    try {
        # Prefer Get-NetTCPConnection when available.
        Write-Verbose "Using Get-NetTCPConnection to find listeners."
        $connections = Get-NetTCPConnection -State Listen -ErrorAction Stop |
            Where-Object { $Ports -contains $_.LocalPort }
        return $connections
    } catch {
        # Fall back to parsing netstat if Get-NetTCPConnection is unavailable.
        Write-Verbose "Get-NetTCPConnection unavailable; falling back to netstat."
    }

    Write-Verbose "Parsing netstat output."
    $netstat = & netstat -ano -p TCP
    foreach ($line in $netstat) {
        if ($line -match "^\s*TCP\s+(\S+):(\d+)\s+\S+\s+LISTENING\s+(\d+)\s*$") {
            $localAddress = $Matches[1]
            $localPort = [int]$Matches[2]
            $processId = [int]$Matches[3]
            if ($Ports -contains $localPort) {
                $connections += [PSCustomObject]@{
                    LocalAddress = $localAddress
                    LocalPort = $localPort
                    OwningProcess = $processId
                }
            }
        }
    }

    return $connections
}

$listening = Get-ListeningConnections -Ports $Ports

$blocked = @()
foreach ($connection in $listening) {
    $owningProcess = $connection.OwningProcess
    $procName = $null
    try {
        $procName = (Get-Process -Id $owningProcess -ErrorAction Stop).ProcessName
    } catch {
        $procName = "<unknown>"
    }

    $blocked += [PSCustomObject]@{
        Port = $connection.LocalPort
        Address = $connection.LocalAddress
        PID = $owningProcess
        Process = $procName
    }
}

if ($blocked.Count -eq 0) {
    Write-Output ("All ports are free: {0}" -f ($Ports -join ", "))
    exit 0
}

Write-Output "Blocked ports detected:"
$blocked | Sort-Object Port, PID | Format-Table -AutoSize

if ($Kill) {
    Write-Verbose "Kill switch enabled; attempting to stop blocking processes."
    $killed = @()
    foreach ($item in $blocked) {
        try {
            Write-Verbose ("Stopping PID {0} (port {1})" -f $item.PID, $item.Port)
            Stop-Process -Id $item.PID -Force -ErrorAction Stop
            $killed += $item
        } catch {
            Write-Warning ("Failed to stop PID {0} (port {1})" -f $item.PID, $item.Port)
        }
    }

    if ($killed.Count -gt 0) {
        Write-Output "Stopped processes:"
        $killed | Sort-Object Port, PID | Format-Table -AutoSize
    }
}

exit 1
