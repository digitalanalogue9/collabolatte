# Collabolatte Scripts

This directory contains utility scripts for development, testing, and deployment workflows.

## Table of Contents

- [Development Scripts](#development-scripts)
- [Testing Scripts](#testing-scripts)
- [Deployment Scripts](#deployment-scripts)
- [Code Coverage Scripts](#code-coverage-scripts)

---

## Development Scripts

### `Start-BmadBranch.ps1`

**Purpose:** Creates/switches to a topic branch before running BMAD workflows that write files
(sprint planning, story generation, etc.).

**Usage:**

```powershell
pwsh -File scripts/Start-BmadBranch.ps1 -Type epic -Name epic-2-join-trust
pwsh -File scripts/Start-BmadBranch.ps1 -Type story -Name 2-1-first-contact
pwsh -File scripts/Start-BmadBranch.ps1 -Branch epic/epic-2-join-trust
```

**Parameters:**

- `-Type` / `-Name` - Build branch name as `<type>/<name>`
- `-Branch` - Provide a full branch name (overrides `-Type`/`-Name`)
- `-AllowDirty` - Allow switching/creating with uncommitted changes
- `-Force` - Allow switching away from a non-`main` branch

---

### `port-guard.ps1`

**Purpose:** Checks if required ports are available before starting development servers.

**Usage:**

```powershell
.\scripts\port-guard.ps1 -Ports 3000,8080,4173
```

**Parameters:**

- `-Ports` - Array of port numbers to check (default: 3000, 8080)

**Example:**

```powershell
# Check if web and marketing ports are available
.\scripts\port-guard.ps1

# Check custom ports
.\scripts\port-guard.ps1 -Ports 3000,4000,5000
```

**Common Use Case:**  
Run before starting dev servers to avoid "port already in use" errors.

---

## Testing Scripts

### `run-e2e-local.mjs`

**Purpose:** Orchestrates local end-to-end testing with Playwright by managing preview servers.

**Usage:**

```bash
node scripts/run-e2e-local.mjs
# or
pnpm test:e2e:local
```

**What it does:**

1. Builds web and marketing apps
2. Starts preview servers on ports 3000 and 8080
3. Waits for servers to be ready
4. Runs Playwright tests
5. Cleans up servers after tests complete

**Environment Variables:**

- `CI` - Set to `true` to enable CI mode behavior

**Example:**

```bash
# Run E2E tests locally with auto server management
pnpm test:e2e:local

# Run in CI mode
CI=true node scripts/run-e2e-local.mjs
```

**When to use:**

- Testing E2E flows locally without manually starting servers
- Debugging CI failures locally
- Running full integration tests before pushing

---

## Deployment Scripts

### `Set-AzureSecretsToGitHub.ps1`

**Purpose:** Retrieves Azure Static Web App deployment tokens and configures them as GitHub
repository secrets.

**Usage:**

```powershell
.\scripts\Set-AzureSecretsToGitHub.ps1 [-Environment <env>] [-Project <name>] [-Location <region>]
```

**Parameters:**

- `-Environment` - Target environment: `dev`, `staging`, or `prod` (default: `dev`)
- `-Project` - Project name (default: `collabolatte`)
- `-Location` - Azure region (default: `westeurope`)

**Prerequisites:**

- Azure CLI installed and logged in (`az login`)
- GitHub CLI installed and authenticated (`gh auth login`)
- Contributor access to Azure subscription
- Admin access to GitHub repository

**Examples:**

```powershell
# Configure secrets for dev environment
.\scripts\Set-AzureSecretsToGitHub.ps1

# Configure secrets for production
.\scripts\Set-AzureSecretsToGitHub.ps1 -Environment prod

# Use custom project/region
.\scripts\Set-AzureSecretsToGitHub.ps1 -Project myapp -Location eastus
```

**What it does:**

1. Validates prerequisites (Azure CLI, GitHub CLI, authentication)
2. Fetches deployment tokens from Azure Static Web Apps
3. Sets the following GitHub secrets:
   - `AZURE_STATIC_WEB_APPS_API_TOKEN_APP`
   - `AZURE_STATIC_WEB_APPS_API_TOKEN_WWW`

**When to use:**

- After deploying Azure infrastructure for the first time
- When rotating deployment tokens
- When setting up CI/CD for a new environment
- When GitHub Actions deployment workflows fail with authentication errors

---

## Code Coverage Scripts

Located in `code-coverage/` subdirectory. These scripts help analyze and visualize code coverage for
the .NET API.

### `Update-CodeCoverageArtifacts.ps1`

**Purpose:** Runs tests with coverage collection and generates coverage reports.

**Usage:**

```powershell
.\scripts\code-coverage\Update-CodeCoverageArtifacts.ps1 [-Force]
```

**Parameters:**

- `-Force` - Skip timestamp check and force regeneration of coverage

**What it does:**

1. Cleans existing test results
2. Runs `dotnet test` with coverage collection
3. Generates Cobertura XML and HTML reports
4. Updates timestamp for freshness tracking

**Example:**

```powershell
# Update coverage (only if stale)
.\scripts\code-coverage\Update-CodeCoverageArtifacts.ps1

# Force regeneration
.\scripts\code-coverage\Update-CodeCoverageArtifacts.ps1 -Force
```

---

### `New-CoverageSummary.ps1`

**Purpose:** Generates comprehensive code coverage reports optimized for AI analysis and human
review.

**Usage:**

```powershell
.\scripts\code-coverage\New-CoverageSummary.ps1 `
    [-MinimumCoverage <percentage>] `
    [-OutputFormat <format>] `
    [-CheckFreshness] `
    [-CrapThreshold <score>]
```

**Parameters:**

- `-MinimumCoverage` - Minimum acceptable coverage percentage (default: 80)
- `-OutputFormat` - Output format: `Markdown`, `Json`, or `Both` (default: `Both`)
- `-CheckFreshness` - Warn if coverage data is older than 1 hour
- `-CrapThreshold` - CRAP score threshold for hotspots (default: 30)

**Outputs:**

- `coverage-summary.md` - Human-readable markdown report
- `coverage-summary.json` - Machine-readable JSON report

**Examples:**

```powershell
# Generate standard summary
.\scripts\code-coverage\New-CoverageSummary.ps1

# Require 90% coverage and check freshness
.\scripts\code-coverage\New-CoverageSummary.ps1 -MinimumCoverage 90 -CheckFreshness

# Generate only JSON output
.\scripts\code-coverage\New-CoverageSummary.ps1 -OutputFormat Json
```

**Report Includes:**

- Overall coverage metrics (line, branch, method)
- Files with low coverage (< 80%)
- CRAP hotspots (complex, untested code)
- Remediation guidance for each issue

---

### `New-CoveragePromptBuilder.ps1`

**Purpose:** Generates context-rich prompts for AI assistants to help improve test coverage.

**Usage:**

```powershell
.\scripts\code-coverage\New-CoveragePromptBuilder.ps1 [-TargetFile <path>]
```

**Parameters:**

- `-TargetFile` - Specific file to analyze (optional, prompts if not provided)

**What it does:**

1. Analyzes coverage report
2. Identifies uncovered lines in target file
3. Reads file contents and related test files
4. Generates structured prompt with context

**Example:**

```powershell
# Interactive mode (prompts for file selection)
.\scripts\code-coverage\New-CoveragePromptBuilder.ps1

# Target specific file
.\scripts\code-coverage\New-CoveragePromptBuilder.ps1 -TargetFile "src/Services/UserService.cs"
```

**Use with AI:**  
Copy the generated prompt to Claude, ChatGPT, or GitHub Copilot to get targeted test suggestions.

---

### `CrapReport.psm1`

**Purpose:** PowerShell module for parsing and analyzing CRAP (Change Risk Anti-Patterns) metrics.

**Usage:**

```powershell
Import-Module .\scripts\code-coverage\CrapReport.psm1

# Parse CRAP report
$hotspots = Get-CrapHotspots -ReportPath "TestResults/coverage.cobertura.xml" -Threshold 30

# Filter by score
$critical = $hotspots | Where-Object { $_.CrapScore -gt 50 }
```

**Functions:**

- `Get-CrapHotspots` - Extracts methods with high CRAP scores
- `Format-CrapReport` - Formats hotspots as readable text

**CRAP Score Interpretation:**

- **1-10:** Low risk - simple, well-tested code
- **11-30:** Medium risk - consider refactoring or adding tests
- **31+:** High risk - complex, untested code that's risky to change

---

### `coverage-ignore.txt`

**Purpose:** Configuration file specifying types to exclude from coverage analysis.

**Format:**  
One type pattern per line, supports wildcards.

**Example:**

```
*Controller
*Dto
*Model
Program
Startup
```

**When to edit:**  
Add patterns for generated code, DTOs, or infrastructure code that doesn't require testing.

---

## Workflow Integration

### Local Development

```bash
# 1. Check ports before starting servers
pwsh -File scripts/port-guard.ps1

# 2. Start dev servers
pnpm dev

# 3. Run E2E tests (auto-manages servers)
pnpm test:e2e:local
```

### Code Coverage Analysis

```powershell
# 1. Generate coverage
.\scripts\code-coverage\Update-CodeCoverageArtifacts.ps1

# 2. Review summary
.\scripts\code-coverage\New-CoverageSummary.ps1 -CheckFreshness

# 3. Get AI help for specific file
.\scripts\code-coverage\New-CoveragePromptBuilder.ps1
```

### CI/CD Setup

```powershell
# 1. Login to Azure and GitHub
az login
gh auth login

# 2. Deploy Azure infrastructure
az deployment sub create --location westeurope --template-file infra/main.bicep --parameters infra/parameters/dev.json

# 3. Configure GitHub secrets
.\scripts\Set-AzureSecretsToGitHub.ps1 -Environment dev

# 4. Push code to trigger workflows
git push
```

---

## Testing Scripts

All PowerShell scripts have corresponding Pester tests:

```powershell
# Run coverage module tests
Invoke-Pester .\scripts\code-coverage\tests\CrapReport.Tests.ps1

# Run all script tests
Invoke-Pester .\scripts\ -Recurse
```

---

## Contributing

When adding new scripts:

1. **Include inline documentation** - Use comment-based help for PowerShell
2. **Add usage examples** - Show common use cases
3. **Update this README** - Document purpose, parameters, and examples
4. **Write tests** - Add Pester tests for PowerShell scripts
5. **Follow naming conventions:**
   - PowerShell: `Verb-NounDescription.ps1` (e.g., `Set-AzureSecretsToGitHub.ps1`)
   - Node.js: `kebab-case.mjs` (e.g., `run-e2e-local.mjs`)

---

## Troubleshooting

### "Port already in use"

Run `port-guard.ps1` to identify which process is using the port, then kill it or use a different
port.

### "Azure CLI not found"

Install Azure CLI: https://aka.ms/installazurecli

### "GitHub CLI not found"

Install GitHub CLI: `winget install --id GitHub.cli`

### "Not authenticated"

```bash
az login          # Azure
gh auth login     # GitHub
```

### Coverage reports not generating

Ensure you have .NET test coverage tools installed:

```bash
dotnet tool install --global coverlet.console
dotnet tool install --global dotnet-reportgenerator-globaltool
```
