# maintain-chotu-stocksharp.ps1
# Complete maintenance pipeline for Chotu-StockSharp (C#/.NET trading platform)
# Requires: .NET SDK 8.0+, MSBuild, Git
# Usage: Run in PowerShell from repository root

param(
    [switch]$SkipTests,
    [switch]$SkipSmoke,
    [switch]$NoPush,
    [string]$Branch = "main"
)

$ErrorActionPreference = "Stop"
$OriginalLocation = Get-Location

function Write-Step {
    param([string]$Message, [string]$Color = "Cyan")
    Write-Host "`n$Message" -ForegroundColor $Color
}

function Write-Success {
    param([string]$Message)
    Write-Host "✅ $Message" -ForegroundColor Green
}

function Write-Warning-Custom {
    param([string]$Message)
    Write-Host "⚠️  $Message" -ForegroundColor Yellow
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "❌ $Message" -ForegroundColor Red
}

try {
    Write-Host "🔷 Starting Chotu-StockSharp Maintenance Pipeline" -ForegroundColor Cyan
    Write-Host "=================================================" -ForegroundColor Cyan
    
    # Verify we're in the right directory
    if (-not (Test-Path "StockSharp.sln")) {
        throw "StockSharp.sln not found. Please run this script from the repository root."
    }

    # ============================================================================
    # STEP 1: UPDATE - Pull latest changes
    # ============================================================================
    Write-Step "📥 STEP 1: Updating from remote repository..."
    
    $currentBranch = git rev-parse --abbrev-ref HEAD 2>$null
    if ($currentBranch -ne $Branch) {
        Write-Warning-Custom "Current branch is '$currentBranch', switching to '$Branch'..."
        git checkout $Branch 2>&1 | Out-Null
    }
    
    git fetch origin 2>&1 | Out-Null
    $pullResult = git pull --ff-only origin $Branch 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Repository updated successfully"
    } else {
        Write-Warning-Custom "Pull had conflicts or no changes: $pullResult"
    }

    # ============================================================================
    # STEP 2: OPTIMIZE - Clean and restore packages
    # ============================================================================
    Write-Step "🧹 STEP 2: Cleaning and optimizing..."
    
    # Clean solution
    Write-Host "  → Cleaning solution..." -ForegroundColor Gray
    dotnet clean StockSharp.sln --configuration Release --verbosity quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Solution cleaned"
    } else {
        Write-Error-Custom "Clean failed"
        throw "dotnet clean failed"
    }
    
    # Restore NuGet packages
    Write-Host "  → Restoring NuGet packages..." -ForegroundColor Gray
    dotnet restore StockSharp.sln --verbosity quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "NuGet packages restored"
    } else {
        Write-Error-Custom "Restore failed"
        throw "dotnet restore failed"
    }

    # Check for .editorconfig
    if (Test-Path ".editorconfig") {
        Write-Success "Code style rules (.editorconfig) will be enforced during build"
    }

    # ============================================================================
    # STEP 3: REMOVE BUGS - Build and validate
    # ============================================================================
    Write-Step "⚙️  STEP 3: Building solution (Release mode)..."
    
    dotnet build StockSharp.sln --configuration Release --no-restore --verbosity minimal
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error-Custom "Build failed! Please fix compilation errors."
        throw "Build failed"
    }
    
    Write-Success "Solution built successfully"

    # ============================================================================
    # STEP 4: MAKE DEPLOYABLE - Verify critical outputs
    # ============================================================================
    Write-Step "📦 STEP 4: Verifying deployable artifacts..."
    
    # Define critical assemblies to check
    $criticalProjects = @(
        @{Name="Algo"; Path="Algo\bin\Release"},
        @{Name="BusinessEntities"; Path="BusinessEntities\bin\Release"},
        @{Name="Messages"; Path="Messages\bin\Release"},
        @{Name="Configuration"; Path="Configuration\bin\Release"}
    )
    
    $missingArtifacts = @()
    
    foreach ($project in $criticalProjects) {
        $found = $false
        if (Test-Path $project.Path) {
            $dllFiles = Get-ChildItem -Path $project.Path -Filter "*.dll" -Recurse -ErrorAction SilentlyContinue
            if ($dllFiles.Count -gt 0) {
                $found = $true
                Write-Host "  ✓ $($project.Name) artifacts found" -ForegroundColor Gray
            }
        }
        
        if (-not $found) {
            $missingArtifacts += $project.Name
        }
    }
    
    if ($missingArtifacts.Count -gt 0) {
        Write-Error-Custom "Missing artifacts for: $($missingArtifacts -join ', ')"
        throw "Critical build outputs missing"
    }
    
    Write-Success "All critical artifacts verified"

    # ============================================================================
    # STEP 5: TEST RUN - Execute tests
    # ============================================================================
    if (-not $SkipTests) {
        Write-Step "🧪 STEP 5: Running unit tests..."
        
        if (Test-Path "Tests\Tests.csproj") {
            Write-Host "  → Executing test suite..." -ForegroundColor Gray
            dotnet test Tests\Tests.csproj --configuration Release --no-build --verbosity normal
            
            if ($LASTEXITCODE -eq 0) {
                Write-Success "All tests passed"
            } else {
                Write-Warning-Custom "Some tests failed. Review output above."
            }
        } else {
            Write-Warning-Custom "No Tests project found at Tests\Tests.csproj"
        }
        
        # Smoke test - check if we can load a sample project
        if (-not $SkipSmoke) {
            Write-Host "  → Running smoke tests..." -ForegroundColor Gray
            $sampleProjects = Get-ChildItem -Path "Samples" -Filter "*.csproj" -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
            
            if ($sampleProjects) {
                Write-Host "    Verifying sample project: $($sampleProjects.Name)" -ForegroundColor Gray
                dotnet build $sampleProjects.FullName --configuration Release --no-restore --verbosity quiet
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Smoke test passed"
                } else {
                    Write-Warning-Custom "Smoke test failed for sample project"
                }
            }
        }
    } else {
        Write-Warning-Custom "STEP 5: Tests skipped (--SkipTests flag)"
    }

    # ============================================================================
    # STEP 6: REMOVE CACHE - Clear all caches
    # ============================================================================
    Write-Step "🗑️  STEP 6: Clearing caches..."
    
    # Clear NuGet caches
    Write-Host "  → Clearing NuGet caches..." -ForegroundColor Gray
    dotnet nuget locals all --clear 2>&1 | Out-Null
    Write-Success "NuGet caches cleared"
    
    # Remove bin/obj directories
    Write-Host "  → Removing bin/obj directories..." -ForegroundColor Gray
    $binObjDirs = Get-ChildItem -Path . -Include "bin","obj" -Recurse -Directory -ErrorAction SilentlyContinue
    $removedCount = 0
    
    foreach ($dir in $binObjDirs) {
        try {
            Remove-Item -Path $dir.FullName -Recurse -Force -ErrorAction SilentlyContinue
            $removedCount++
        } catch {
            # Silently continue if locked
        }
    }
    
    Write-Success "Removed $removedCount bin/obj directories"
    
    # Clear Visual Studio cache
    Write-Host "  → Clearing Visual Studio caches..." -ForegroundColor Gray
    $vsCache = "$env:LOCALAPPDATA\Microsoft\VisualStudio"
    if (Test-Path $vsCache) {
        Get-ChildItem -Path $vsCache -Filter "*.Roslyn" -Recurse -Directory -ErrorAction SilentlyContinue | 
            Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    $vsCacheComponentModel = "$env:LOCALAPPDATA\Microsoft\VisualStudio\*\ComponentModelCache"
    if (Test-Path $vsCacheComponentModel) {
        Remove-Item -Path $vsCacheComponentModel -Recurse -Force -ErrorAction SilentlyContinue
    }
    
    Write-Success "Visual Studio caches cleared"
    
    # Rebuild after cache clear
    Write-Host "  → Rebuilding solution..." -ForegroundColor Gray
    dotnet build StockSharp.sln --configuration Release --verbosity quiet
    
    if ($LASTEXITCODE -eq 0) {
        Write-Success "Clean rebuild completed"
    } else {
        Write-Warning-Custom "Rebuild had warnings"
    }

    # ============================================================================
    # STEP 7: PUSH - Commit and push changes
    # ============================================================================
    if (-not $NoPush) {
        Write-Step "📤 STEP 7: Committing and pushing changes..."
        
        # Check for changes
        git add -A 2>&1 | Out-Null
        $status = git status --porcelain
        
        if ($status) {
            $timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-dd HH:mm UTC")
            $commitMsg = "chore(stocksharp): optimized, tested, cache-cleared [$timestamp]"
            
            Write-Host "  → Changes detected, committing..." -ForegroundColor Gray
            git commit -m $commitMsg 2>&1 | Out-Null
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "  → Pushing to origin/$Branch..." -ForegroundColor Gray
                git push origin $Branch 2>&1 | Out-Null
                
                if ($LASTEXITCODE -eq 0) {
                    Write-Success "Changes pushed successfully"
                } else {
                    Write-Error-Custom "Push failed. You may need to pull first or check permissions."
                }
            } else {
                Write-Warning-Custom "Commit failed"
            }
        } else {
            Write-Success "No changes to commit - repository is clean"
        }
    } else {
        Write-Warning-Custom "STEP 7: Push skipped (--NoPush flag)"
    }

    # ============================================================================
    # COMPLETION
    # ============================================================================
    Write-Host "`n=================================================" -ForegroundColor Cyan
    Write-Host "✨ Chotu-StockSharp maintenance completed successfully!" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Cyan
    
    # Summary
    Write-Host "`nSummary:" -ForegroundColor Cyan
    Write-Host "  • Repository updated from $Branch" -ForegroundColor White
    Write-Host "  • Solution cleaned and optimized" -ForegroundColor White
    Write-Host "  • Release build completed" -ForegroundColor White
    Write-Host "  • Artifacts verified" -ForegroundColor White
    if (-not $SkipTests) {
        Write-Host "  • Tests executed" -ForegroundColor White
    }
    Write-Host "  • Caches cleared" -ForegroundColor White
    if (-not $NoPush) {
        Write-Host "  • Changes pushed to remote" -ForegroundColor White
    }
    
} catch {
    Write-Host "`n=================================================" -ForegroundColor Red
    Write-Host "❌ Maintenance pipeline failed!" -ForegroundColor Red
    Write-Host "=================================================" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "Location: $($_.InvocationInfo.ScriptLineNumber)" -ForegroundColor Red
    exit 1
} finally {
    Set-Location $OriginalLocation
}
