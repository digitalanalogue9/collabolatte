<#
.SYNOPSIS
    Retrieves Azure Static Web App deployment tokens and sets them as GitHub secrets.

.DESCRIPTION
    This script fetches deployment tokens from Azure Static Web Apps and automatically
    configures them as GitHub repository secrets for CI/CD workflows.

.PARAMETER Environment
    The environment to retrieve tokens for (dev, staging, or prod). Default: dev

.PARAMETER Project
    The project name. Default: collabolatte

.PARAMETER Location
    The Azure region. Default: westeurope

.EXAMPLE
    .\Set-AzureSecretsToGitHub.ps1 -Environment dev

.NOTES
    Prerequisites:
    - Azure CLI installed and logged in (az login)
    - GitHub CLI installed and authenticated (gh auth login)
    - Contributor access to Azure subscription
    - Admin access to GitHub repository
#>

[CmdletBinding()]
param(
    [Parameter()]
    [ValidateSet('dev', 'staging', 'prod')]
    [string]$Environment = 'dev',

    [Parameter()]
    [string]$Project = 'collabolatte',

    [Parameter()]
    [string]$Location = 'westeurope'
)

$ErrorActionPreference = 'Stop'

Write-Host "`n🔐 Azure to GitHub Secrets Configuration" -ForegroundColor Cyan
Write-Host "==========================================`n" -ForegroundColor Cyan

# Check prerequisites
Write-Host "Checking prerequisites..." -ForegroundColor Yellow

# Check Azure CLI
try {
    $azVersion = (az version -o json 2>$null | ConvertFrom-Json).'azure-cli'
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($azVersion)) { throw }
    Write-Host "✓ Azure CLI installed (version $azVersion)" -ForegroundColor Green
} catch {
    Write-Error "Azure CLI not found. Install from: https://aka.ms/installazurecli"
    exit 1
}

# Check Azure login
try {
    $account = az account show 2>$null | ConvertFrom-Json
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "✓ Logged into Azure (Subscription: $($account.name))" -ForegroundColor Green
} catch {
    Write-Host "! Not logged into Azure. Starting login process..." -ForegroundColor Yellow
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Azure login failed or was cancelled."
        exit 1
    }
    $account = az account show | ConvertFrom-Json
    Write-Host "✓ Logged into Azure (Subscription: $($account.name))" -ForegroundColor Green
}

# Check GitHub CLI
try {
    $ghVersion = gh --version 2>$null | Select-Object -First 1
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "✓ GitHub CLI installed ($ghVersion)" -ForegroundColor Green
} catch {
    Write-Error "GitHub CLI not found. Install from: https://cli.github.com"
    exit 1
}

# Check GitHub auth
try {
    $ghAuth = gh auth status 2>&1
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "✓ Authenticated with GitHub" -ForegroundColor Green
} catch {
    Write-Host "! Not authenticated with GitHub. Starting login process..." -ForegroundColor Yellow
    gh auth login
    if ($LASTEXITCODE -ne 0) {
        Write-Error "GitHub authentication failed or was cancelled."
        exit 1
    }
    Write-Host "✓ Authenticated with GitHub" -ForegroundColor Green
}

Write-Host "`nFetching Azure Static Web App tokens..." -ForegroundColor Yellow

# Construct resource names
$appSwaName = "stapp-${Project}-app-${Environment}-${Location}"
$marketingSwaName = "stapp-${Project}-www-${Environment}-${Location}"

# Get App SWA token
Write-Host "  → Retrieving token for: $appSwaName" -ForegroundColor Gray
try {
    $appToken = az staticwebapp secrets list --name $appSwaName --query 'properties.apiKey' -o tsv 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($appToken)) {
        throw "Failed to retrieve token"
    }
    Write-Host "    ✓ App token retrieved (${appToken.Substring(0, 10)}...)" -ForegroundColor Green
} catch {
    Write-Error "Failed to get App SWA token. Ensure resource '$appSwaName' exists and you have access."
    Write-Host "`nTip: List available Static Web Apps with:" -ForegroundColor Yellow
    Write-Host "  az staticwebapp list --query '[].name' -o table" -ForegroundColor Gray
    exit 1
}

# Get Marketing SWA token
Write-Host "  → Retrieving token for: $marketingSwaName" -ForegroundColor Gray
try {
    $marketingToken = az staticwebapp secrets list --name $marketingSwaName --query 'properties.apiKey' -o tsv 2>$null
    if ($LASTEXITCODE -ne 0 -or [string]::IsNullOrWhiteSpace($marketingToken)) {
        throw "Failed to retrieve token"
    }
    Write-Host "    ✓ Marketing token retrieved (${marketingToken.Substring(0, 10)}...)" -ForegroundColor Green
} catch {
    Write-Error "Failed to get Marketing SWA token. Ensure resource '$marketingSwaName' exists and you have access."
    exit 1
}

Write-Host "`nSetting GitHub repository secrets..." -ForegroundColor Yellow

# Set App token as GitHub secret
Write-Host "  → Setting AZURE_STATIC_WEB_APPS_API_TOKEN_APP" -ForegroundColor Gray
try {
    $appToken | gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN_APP 2>$null
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "    ✓ Secret set successfully" -ForegroundColor Green
} catch {
    Write-Error "Failed to set AZURE_STATIC_WEB_APPS_API_TOKEN_APP. Ensure you have admin access to the repository."
    exit 1
}

# Set Marketing token as GitHub secret
Write-Host "  → Setting AZURE_STATIC_WEB_APPS_API_TOKEN_WWW" -ForegroundColor Gray
try {
    $marketingToken | gh secret set AZURE_STATIC_WEB_APPS_API_TOKEN_WWW 2>$null
    if ($LASTEXITCODE -ne 0) { throw }
    Write-Host "    ✓ Secret set successfully" -ForegroundColor Green
} catch {
    Write-Error "Failed to set AZURE_STATIC_WEB_APPS_API_TOKEN_WWW. Ensure you have admin access to the repository."
    exit 1
}

Write-Host "`n✅ Configuration complete!" -ForegroundColor Green
Write-Host "`nGitHub secrets have been set:" -ForegroundColor Cyan
Write-Host "  • AZURE_STATIC_WEB_APPS_API_TOKEN_APP" -ForegroundColor White
Write-Host "  • AZURE_STATIC_WEB_APPS_API_TOKEN_WWW" -ForegroundColor White
Write-Host "`nYour GitHub Actions workflows should now be able to deploy to Azure Static Web Apps." -ForegroundColor Cyan
Write-Host ""
