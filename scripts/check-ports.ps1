param(
    [int[]] $Ports = @(3000)
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ListeningConnections {
    param(
        [int[]] $Ports
    )

    $connections = @()

    try {
        # Prefer Get-NetTCPConnection when available.
        $connections = Get-NetTCPConnection -State Listen -ErrorAction Stop |
            Where-Object { $Ports -contains $_.LocalPort }
        return $connections
    } catch {
        # Fall back to parsing netstat if Get-NetTCPConnection is unavailable.
    }

    $netstat = & netstat -ano -p TCP
    foreach ($line in $netstat) {
        if ($line -match "^\s*TCP\s+(\S+):(\d+)\s+\S+\s+LISTENING\s+(\d+)\s*$") {
            $localAddress = $Matches[1]
            $localPort = [int]$Matches[2]
            $pid = [int]$Matches[3]
            if ($Ports -contains $localPort) {
                $connections += [PSCustomObject]@{
                    LocalAddress = $localAddress
                    LocalPort = $localPort
                    OwningProcess = $pid
                }
            }
        }
    }

    return $connections
}

$listening = Get-ListeningConnections -Ports $Ports

$blocked = @()
foreach ($connection in $listening) {
    $pid = $connection.OwningProcess
    $procName = $null
    try {
        $procName = (Get-Process -Id $pid -ErrorAction Stop).ProcessName
    } catch {
        $procName = "<unknown>"
    }

    $blocked += [PSCustomObject]@{
        Port = $connection.LocalPort
        Address = $connection.LocalAddress
        PID = $pid
        Process = $procName
    }
}

if ($blocked.Count -eq 0) {
    Write-Output ("All ports are free: {0}" -f ($Ports -join ", "))
    exit 0
}

Write-Output "Blocked ports detected:"
$blocked | Sort-Object Port, PID | Format-Table -AutoSize
exit 1
