#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Build Configuration ---
# Default build type is 'onefile'.
# To build as a folder, run: ./build.sh folder
BUILD_TYPE="onefile"
PYINSTALLER_FLAG="--onefile"

if [[ "$1" == "folder" ]]; then
    BUILD_TYPE="onedir"
    PYINSTALLER_FLAG="--onedir"
    echo "-- Build mode: folder (onedir) --"
else
    echo "-- Build mode: single file (onefile) --"
fi

echo "-- Starting application build process --"

# Check for python3
if ! command -v python3 &> /dev/null
then
    echo -e "\033[1;31mError: python3 command not found.\033[0m"
    echo -e "\033[1;31mPlease ensure Python 3.12+ is installed and available in your PATH.\033[0m"
    exit 1
fi

# 1. Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating 'venv'..."
    python3 -m venv venv
fi

# 2. Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# 2. Install dependencies
echo "Installing dependencies from requirements.txt..."
pip install -r requirements.txt

# 3. Clean previous builds
echo "Cleaning old build artifacts (build/ and dist/ folders)..."
rm -rf build dist

# 3. Build main application
echo "Building Gemini CLI Launcher ($BUILD_TYPE mode)..."
# macOS build command
if [[ "$(uname -s)" == "Darwin" ]]; then
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Gemini CLI Launcher" \
    --add-data "app.icns:." \
    --icon "app.icns" \
    start_gemini.py
# Windows build command (requires running this script on Windows)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Gemini CLI Launcher" \
    --add-data "app.ico;." \
    --icon "app.ico" \
    start_gemini.py
else
    echo "Unsupported OS for direct build via this script. Please build manually."
    exit 1
fi

# 4. Build reset application
echo "Building Reset Settings ($BUILD_TYPE mode)..."
# macOS build command
if [[ "$(uname -s)" == "Darwin" ]]; then
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Reset Settings" \
    --add-data "app.icns:." \
    --icon "app.icns" \
    reset_settings.py
# Windows build command (requires running this script on Windows)
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Reset Settings" \
    --add-data "app.ico;." \
    --icon "app.ico" \
    reset_settings.py
else
    echo "Unsupported OS for direct build via this script. Please build manually."
    exit 1
fi

echo ""
echo -e "\033[1;32m==================================================\033[0m"
echo -e "\033[1;32m  ✅ Build process completed successfully!         \033[0m"
echo -e "\033[1;32m  📦 Applications are in the 'dist' folder.        \033[0m"
echo -e "\033[1;32m==================================================\033[0m"
echo ""