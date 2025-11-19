@echo off
REM ============================================================================
REM ONE-CLICK LOCAL RUN SCRIPT FOR CHOTU-STOCKSHARP
REM ============================================================================
REM Last Updated: 2025-11-15
REM ============================================================================

cls
echo ============================================================================
echo           CHOTU-STOCKSHARP - C# TRADING PLATFORM
echo ============================================================================
echo.
echo This is a C# .NET application that requires Visual Studio.
echo.
echo To run Chotu-StockSharp:
echo   1. Open Visual Studio
echo   2. Open StockSharp.sln
echo   3. Build and run the solution
echo.
echo ============================================================================
echo.
set /p open="Do you want to open the solution folder in Explorer? (y/n): "

if /i "%open%"=="y" (
    echo Opening folder in Explorer...
    explorer .
)

echo.
echo You can also open the solution directly:
echo   - StockSharp.sln (Main solution)
echo   - StockSharp_Tests.sln (Test solution)
echo.

pause
