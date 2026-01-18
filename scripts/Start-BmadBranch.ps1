<#
.SYNOPSIS
Creates/switches to a topic branch before running BMAD workflows that write files.

.DESCRIPTION
This repo treats `main` as protected. Use this helper to ensure you are on a topic branch
before running workflows like sprint planning or story generation.

.PARAMETER Type
Branch type prefix. Common values: epic, story, ai.

.PARAMETER Name
Branch name suffix (without the prefix). Example: epic-2-join-trust.

.PARAMETER Branch
Full branch name (overrides Type/Name). Example: epic/epic-2-join-trust.

.PARAMETER AllowDirty
Allows switching/creating branches even if there are uncommitted changes.

.PARAMETER Force
Allows switching from a non-main branch to the target branch.

.EXAMPLE
pwsh -File scripts/Start-BmadBranch.ps1 -Type epic -Name epic-2-join-trust

.EXAMPLE
pwsh -File scripts/Start-BmadBranch.ps1 -Branch epic/epic-2-join-trust
#>

[CmdletBinding(DefaultParameterSetName = 'ByParts')]
param(
  [Parameter(Mandatory = $true, ParameterSetName = 'ByParts')]
  [ValidateSet('epic', 'story', 'ai')]
  [string] $Type,

  [Parameter(Mandatory = $true, ParameterSetName = 'ByParts')]
  [ValidateNotNullOrEmpty()]
  [string] $Name,

  [Parameter(Mandatory = $true, ParameterSetName = 'Full')]
  [ValidateNotNullOrEmpty()]
  [string] $Branch,

  [switch] $AllowDirty,
  [switch] $Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Invoke-Git {
  param([Parameter(Mandatory = $true)][string[]] $Args)
  & git @Args
  return $LASTEXITCODE
}

$targetBranch = if ($PSCmdlet.ParameterSetName -eq 'Full') { $Branch } else { "$Type/$Name" }

$exit = Invoke-Git -Args @('rev-parse', '--is-inside-work-tree')
if ($exit -ne 0) {
  throw 'Not a git repository (or git not available).'
}

$currentBranch = (& git branch --show-current).Trim()
if ([string]::IsNullOrWhiteSpace($currentBranch)) {
  throw 'Unable to determine current branch.'
}

if (-not $AllowDirty) {
  $status = (& git status --porcelain)
  if (-not [string]::IsNullOrWhiteSpace($status)) {
    throw "Working tree has uncommitted changes. Commit/stash first, or rerun with -AllowDirty."
  }
}

if ($currentBranch -ne 'main' -and $currentBranch -ne $targetBranch -and -not $Force) {
  throw "Currently on '$currentBranch'. Refusing to switch branches without -Force."
}

if ($currentBranch -eq $targetBranch) {
  Write-Host "Already on branch: $targetBranch"
  exit 0
}

$branchExists = (Invoke-Git -Args @('show-ref', '--verify', '--quiet', "refs/heads/$targetBranch")) -eq 0
if ($branchExists) {
  $exit = Invoke-Git -Args @('switch', $targetBranch)
  if ($exit -ne 0) { throw "Failed to switch to existing branch '$targetBranch'." }
  Write-Host "Switched to existing branch: $targetBranch"
  exit 0
}

$exit = Invoke-Git -Args @('switch', '-c', $targetBranch)
if ($exit -ne 0) { throw "Failed to create and switch to new branch '$targetBranch'." }

Write-Host "Created and switched to new branch: $targetBranch"
