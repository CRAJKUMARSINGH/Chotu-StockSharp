# Chotu-StockSharp Maintenance Automation Guide

## Overview

This guide explains how to use the `maintain-chotu-stocksharp.ps1` PowerShell script to automate the complete maintenance pipeline for your StockSharp trading platform fork.

## What the Script Does

The script executes a **7-step automated pipeline**:

1. **UPDATE** - Pulls latest changes from remote repository
2. **OPTIMIZE** - Cleans solution and restores NuGet packages
3. **REMOVE BUGS** - Builds solution in Release mode
4. **MAKE DEPLOYABLE** - Verifies critical build artifacts
5. **TEST RUN** - Executes unit tests and smoke tests
6. **REMOVE CACHE** - Clears all build and NuGet caches
7. **PUSH** - Commits and pushes changes back to remote

## Prerequisites

### Required Software

- **Windows 10/11** (or Windows Server 2019+)
- **.NET SDK 8.0 or later** - [Download](https://dotnet.microsoft.com/download)
- **Git** - [Download](https://git-scm.com/downloads)
- **PowerShell 5.1+** (included with Windows)

### Verify Installation

```powershell
# Check .NET SDK
dotnet --version

# Check Git
git --version

# Check PowerShell version
$PSVersionTable.PSVersion
```

## Quick Start

### 1. Enable Script Execution (One-Time Setup)

Open PowerShell as Administrator and run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### 2. Navigate to Repository

```powershell
cd C:\path\to\Chotu-StockSharp
```

### 3. Run the Script

```powershell
.\maintain-chotu-stocksharp.ps1
```

## Usage Options

### Basic Usage

```powershell
# Full pipeline (default)
.\maintain-chotu-stocksharp.ps1

# Skip tests
.\maintain-chotu-stocksharp.ps1 -SkipTests

# Skip smoke tests only
.\maintain-chotu-stocksharp.ps1 -SkipSmoke

# Don't push to remote
.\maintain-chotu-stocksharp.ps1 -NoPush

# Use different branch
.\maintain-chotu-stocksharp.ps1 -Branch "develop"
```

### Combined Options

```powershell
# Build and verify only (no tests, no push)
.\maintain-chotu-stocksharp.ps1 -SkipTests -NoPush

# Quick local maintenance
.\maintain-chotu-stocksharp.ps1 -SkipSmoke -NoPush
```

## Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `-SkipTests` | Switch | False | Skip all test execution |
| `-SkipSmoke` | Switch | False | Skip smoke tests only |
| `-NoPush` | Switch | False | Don't push changes to remote |
| `-Branch` | String | "main" | Git branch to work with |

## What Gets Verified

### Critical Artifacts Checked

The script verifies these core components are built successfully:

- **Algo** - Core algorithmic trading library
- **BusinessEntities** - Business entity models
- **Messages** - Message infrastructure
- **Configuration** - Configuration management

### Test Coverage

- Runs all tests in `Tests\Tests.csproj`
- Executes smoke test on sample projects
- Reports test failures without stopping pipeline

### Cache Cleanup

The script clears:

- NuGet package caches (all locations)
- All `bin/` and `obj/` directories
- Visual Studio Roslyn caches
- Visual Studio ComponentModel caches

## Troubleshooting

### Script Won't Run

**Error**: "cannot be loaded because running scripts is disabled"

**Solution**:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Build Failures

**Error**: "Build failed! Please fix compilation errors."

**Solution**:
1. Review the build output above the error
2. Fix compilation errors in Visual Studio
3. Run the script again

### Git Push Failures

**Error**: "Push failed. You may need to pull first"

**Solution**:
```powershell
# Pull latest changes manually
git pull origin main

# Resolve any conflicts
# Then run script again
.\maintain-chotu-stocksharp.ps1
```

### Missing .NET SDK

**Error**: "dotnet: The term 'dotnet' is not recognized"

**Solution**:
1. Install .NET SDK 8.0+ from https://dotnet.microsoft.com/download
2. Restart PowerShell
3. Verify: `dotnet --version`

## CI/CD Integration

### GitHub Actions

Create `.github/workflows/maintenance.yml`:

```yaml
name: Automated Maintenance

on:
  schedule:
    - cron: '0 2 * * *'  # Daily at 2 AM UTC
  workflow_dispatch:

jobs:
  maintain:
    runs-on: windows-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Setup .NET
        uses: actions/setup-dotnet@v3
        with:
          dotnet-version: '8.0.x'
      
      - name: Run Maintenance
        shell: pwsh
        run: |
          .\maintain-chotu-stocksharp.ps1 -NoPush
      
      - name: Upload Artifacts
        uses: actions/upload-artifact@v3
        with:
          name: build-artifacts
          path: |
            **/bin/Release/**/*.dll
            **/bin/Release/**/*.exe
```

### Azure DevOps

Create `azure-pipelines.yml`:

```yaml
trigger:
  - main

pool:
  vmImage: 'windows-latest'

steps:
- task: UseDotNet@2
  inputs:
    version: '8.0.x'

- powershell: |
    .\maintain-chotu-stocksharp.ps1 -NoPush
  displayName: 'Run Maintenance Pipeline'
```

## Best Practices

### Daily Maintenance

Run the script daily to:
- Keep dependencies updated
- Catch build breaks early
- Maintain clean caches
- Ensure tests pass

### Before Deployment

Always run with full tests:
```powershell
.\maintain-chotu-stocksharp.ps1
```

### Local Development

Use lighter options:
```powershell
.\maintain-chotu-stocksharp.ps1 -SkipSmoke -NoPush
```

### Team Collaboration

Coordinate script runs to avoid:
- Merge conflicts
- Simultaneous pushes
- Cache corruption

## Script Output

### Success Example

```
🔷 Starting Chotu-StockSharp Maintenance Pipeline
=================================================

📥 STEP 1: Updating from remote repository...
✅ Repository updated successfully

🧹 STEP 2: Cleaning and optimizing...
✅ Solution cleaned
✅ NuGet packages restored

⚙️  STEP 3: Building solution (Release mode)...
✅ Solution built successfully

📦 STEP 4: Verifying deployable artifacts...
✅ All critical artifacts verified

🧪 STEP 5: Running unit tests...
✅ All tests passed

🗑️  STEP 6: Clearing caches...
✅ Clean rebuild completed

📤 STEP 7: Committing and pushing changes...
✅ Changes pushed successfully

=================================================
✨ Chotu-StockSharp maintenance completed successfully!
=================================================
```

## Advanced Customization

### Modify Critical Artifacts

Edit the `$criticalProjects` array in the script:

```powershell
$criticalProjects = @(
    @{Name="YourProject"; Path="YourProject\bin\Release"},
    # Add more projects
)
```

### Change Build Configuration

Replace `Release` with `Debug` throughout the script if needed.

### Add Custom Steps

Insert custom steps between existing ones:

```powershell
# After STEP 3
Write-Step "🔧 CUSTOM: Running code analysis..."
# Your custom commands here
```

## Support

For issues specific to:
- **StockSharp platform**: https://github.com/StockSharp/StockSharp/issues
- **This fork**: https://github.com/CRAJKUMARSINGH/Chotu-StockSharp/issues
- **Script problems**: Create an issue with the error output

## License

This maintenance script is provided as-is for use with the Chotu-StockSharp project.
StockSharp itself is licensed under Apache License 2.0.
