@echo off
setlocal EnableDelayedExpansion

rem --- Build Configuration ---
rem Default build type is 'onefile'.
rem To build as a folder, run: build.bat folder
set "BUILD_TYPE=onefile"
set "PYINSTALLER_FLAG=--onefile"

if /i "%1" == "folder" (
    set "BUILD_TYPE=onedir"
    set "PYINSTALLER_FLAG=--onedir"
)

echo --- Starting application build process ---

rem Check for python3
set "PYTHON_CMD=python3"
where python3 >nul 2>&1
if %errorlevel% neq 0 (
    where py >nul 2>&1
    if %errorlevel% neq 0 (
        echo Error: python3 or py command not found.
        echo Please ensure Python 3.12+ is installed and available in your PATH.
        goto :eof
    )
    set "PYTHON_CMD=py"
)

rem 1. Create virtual environment if it doesn't exist
if not exist "venv" (
    echo Virtual environment not found. Creating 'venv'...
    !PYTHON_CMD! -m venv venv
)

rem 2. Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat

rem Check if activation was successful
if %errorlevel% neq 0 (
    echo Error: Failed to activate virtual environment. Please ensure Python and venv are set up correctly.
    goto :eof
)

rem 2. Install dependencies
echo Installing dependencies from requirements.txt...
pip install -r requirements.txt

rem 3. Clean previous builds
echo Cleaning old build artifacts (build/ and dist/ folders)...
rmdir /s /q build > nul 2>&1
rmdir /s /q dist > nul 2>&1

rem 3. Build main application
echo Building Gemini CLI Launcher (!BUILD_TYPE! mode)...
pyinstaller !PYINSTALLER_FLAG! --windowed --name "Gemini CLI Launcher" ^
--add-data "app.ico;." ^
--icon "app.ico" ^
start_gemini.py

if %errorlevel% neq 0 (
    echo Error: Failed to build Gemini CLI Launcher.
    goto :eof
)

rem 4. Build reset application
echo Building Reset Settings (!BUILD_TYPE! mode)...
pyinstaller !PYINSTALLER_FLAG! --windowed --name "Reset Settings" ^
--add-data "app.ico;." ^
--icon "app.ico" ^
reset_settings.py

if %errorlevel% neq 0 (
    echo Error: Failed to build Reset Settings.
    goto :eof
)

echo.
echo ==================================================
echo   Build process completed successfully!
echo   Applications are in the 'dist' folder.
echo ==================================================
echo.

endlocal