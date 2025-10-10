@echo off
setlocal EnableDelayedExpansion

rem --- Default Configuration ---
set "BUILD_TYPE=onefile"
set "PYINSTALLER_FLAG=--onefile"
set "BUILD_INSTALLER=false"

rem --- Argument Parsing ---
echo --- Parsing build arguments... ---
if /i "%1" == "installer" (
    echo Build mode: Installer (forces onedir)
    set "BUILD_TYPE=onedir"
    set "PYINSTALLER_FLAG=--onedir"
    set "BUILD_INSTALLER=true"
) else if /i "%1" == "folder" (
    echo Build mode: Folder (onedir)
    set "BUILD_TYPE=onedir"
    set "PYINSTALLER_FLAG=--onedir"
) else (
    echo Build mode: Single File (onefile)
)
echo.

rem --- Python Check ---
echo --- Checking for Python command... ---
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
echo Using Python command: !PYTHON_CMD!
echo.

rem --- Virtual Environment Setup ---
if not exist "venv" (
    echo --- Virtual environment not found. Creating 'venv'... ---
    !PYTHON_CMD! -m venv venv
)
echo --- Activating virtual environment... ---
call venv\Scripts\activate.bat
if %errorlevel% neq 0 (
    echo Error: Failed to activate virtual environment.
    goto :eof
)
echo --- Installing dependencies from requirements.txt... ---
pip install -r requirements.txt
echo.

rem --- Clean Previous Builds ---
echo --- Cleaning old build artifacts... ---
rmdir /s /q build > nul 2>&1
rmdir /s /q dist > nul 2>&1
echo.

rem --- PyInstaller Build ---
echo --- Building Gemini CLI Launcher (!BUILD_TYPE! mode)... ---
pyinstaller !PYINSTALLER_FLAG! --windowed --name "Gemini CLI Launcher" ^
--add-data "app.ico;." ^
--icon "app.ico" ^
start_gemini.py
if %errorlevel% neq 0 (
    echo Error: Failed to build Gemini CLI Launcher.
    goto :eof
)
echo.

echo --- Building Reset Settings (!BUILD_TYPE! mode)... ---
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
echo   PyInstaller build process completed successfully!
echo   Applications are in the 'dist' folder.
echo ==================================================
echo.

rem --- Conditional Installer Build ---
if "!BUILD_INSTALLER!" == "true" (
    echo --- Cleaning old release folder... ---
    rmdir /s /q release > nul 2>&1
    echo --- Creating Windows Installer using Inno Setup ---
    "%ProgramFiles(x86)%\Inno Setup 6\iscc.exe" setup.iss
    if !errorlevel! neq 0 (
        echo Error: Failed to create installer.
        goto :eof
    )
    echo Installer created successfully in the 'release' folder.
)

endlocal
