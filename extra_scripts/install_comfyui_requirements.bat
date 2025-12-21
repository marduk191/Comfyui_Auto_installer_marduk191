@echo off
REM ComfyUI Requirements Installer (Batch file for Windows)
REM Scans ComfyUI directory and installs all requirements.txt files

setlocal enabledelayedexpansion

REM Parse arguments
set "COMFYUI_PATH=%CD%"
set "DRY_RUN=0"
set "SKIP_MAIN=0"

:parse_args
if "%~1"=="" goto end_parse
if /i "%~1"=="--help" goto show_help
if /i "%~1"=="-h" goto show_help
if /i "%~1"=="--dry-run" (
    set "DRY_RUN=1"
    shift
    goto parse_args
)
if /i "%~1"=="--skip-main" (
    set "SKIP_MAIN=1"
    shift
    goto parse_args
)
set "COMFYUI_PATH=%~1"
shift
goto parse_args

:show_help
echo ComfyUI Requirements Installer
echo.
echo Usage: install_comfyui_requirements.bat [OPTIONS] [COMFYUI_PATH]
echo.
echo Options:
echo   --dry-run     Show what would be installed without installing
echo   --skip-main   Skip main requirements.txt, only install custom nodes
echo   --help, -h    Show this help message
echo.
echo Examples:
echo   install_comfyui_requirements.bat
echo   install_comfyui_requirements.bat C:\ComfyUI
echo   install_comfyui_requirements.bat --dry-run
echo   install_comfyui_requirements.bat --skip-main
exit /b 0

:end_parse

REM Validate path
if not exist "%COMFYUI_PATH%" (
    echo [91m ERROR: Directory not found: %COMFYUI_PATH%[0m
    exit /b 1
)

cd /d "%COMFYUI_PATH%"
set "COMFYUI_PATH=%CD%"

echo [96m Scanning ComfyUI directory...[0m
echo Base path: %COMFYUI_PATH%
echo.

REM Counters
set "TOTAL=0"
set "SUCCESS=0"
set "FAILED=0"

REM Install main requirements
if %SKIP_MAIN%==0 (
    if exist "%COMFYUI_PATH%\requirements.txt" (
        call :install_requirements "%COMFYUI_PATH%\requirements.txt" "Main ComfyUI"
    )
)

REM Install custom nodes requirements
if exist "%COMFYUI_PATH%\custom_nodes\" (
    for /d %%D in ("%COMFYUI_PATH%\custom_nodes\*") do (
        if exist "%%D\requirements.txt" (
            call :install_requirements "%%D\requirements.txt" "Custom Node: %%~nxD"
        )
    )
)

REM Summary
echo.
echo ====================================================
echo INSTALLATION SUMMARY
echo ====================================================
echo [92mSuccessful: %SUCCESS%[0m
echo [91mFailed: %FAILED%[0m
echo [96mTotal: %TOTAL%[0m

if %DRY_RUN%==1 (
    echo.
    echo [93mThis was a dry run. Run without --dry-run to actually install.[0m
)

if %TOTAL%==0 (
    echo.
    echo [93mNo requirements.txt files found![0m
    exit /b 0
)

if %FAILED% gtr 0 (
    echo.
    echo [91mSome installations failed. Please check the output above.[0m
    exit /b 1
) else (
    echo.
    echo [92mAll requirements installed successfully![0m
    exit /b 0
)

REM Function to install requirements
:install_requirements
set "REQ_FILE=%~1"
set "LOCATION=%~2"
set /a TOTAL+=1

echo.
echo ====================================================
echo [96m%LOCATION%[0m
echo ====================================================
echo File: %REQ_FILE%

REM Check if file is empty
for %%A in ("%REQ_FILE%") do set "FILE_SIZE=%%~zA"
if %FILE_SIZE%==0 (
    echo [93mEmpty requirements file, skipping...[0m
    set /a SUCCESS+=1
    goto :eof
)

REM Show packages
echo.
echo Packages to install:
for /f "usebackq delims=" %%L in ("%REQ_FILE%") do (
    set "LINE=%%L"
    if not "!LINE:~0,1!"=="#" (
        if not "!LINE!"=="" (
            echo   * %%L
        )
    )
)

if %DRY_RUN%==1 (
    echo [93mDRY RUN - Not actually installing[0m
    set /a SUCCESS+=1
    goto :eof
)

echo.
echo [96mInstalling...[0m

REM Install requirements
python -m pip install -r "%REQ_FILE%"
if %ERRORLEVEL%==0 (
    echo [92mSuccessfully installed![0m
    set /a SUCCESS+=1
) else (
    echo [91mInstallation failed![0m
    set /a FAILED+=1
)

goto :eof
pause
