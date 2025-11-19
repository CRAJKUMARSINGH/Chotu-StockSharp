@echo off
REM Quick launcher for Chotu-StockSharp maintenance script
REM Double-click this file to run the full maintenance pipeline

echo ========================================
echo Chotu-StockSharp Maintenance Launcher
echo ========================================
echo.

REM Check if PowerShell is available
where powershell >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: PowerShell not found!
    echo Please ensure PowerShell is installed.
    pause
    exit /b 1
)

REM Check if script exists
if not exist "maintain-chotu-stocksharp.ps1" (
    echo ERROR: maintain-chotu-stocksharp.ps1 not found!
    echo Please ensure you're running this from the repository root.
    pause
    exit /b 1
)

echo Starting maintenance pipeline...
echo.

REM Run the PowerShell script
powershell -ExecutionPolicy Bypass -File "maintain-chotu-stocksharp.ps1"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ========================================
    echo Maintenance completed successfully!
    echo ========================================
) else (
    echo.
    echo ========================================
    echo Maintenance failed! Check errors above.
    echo ========================================
)

echo.
pause
