#!/bin/bash
# Exit immediately if a command exits with a non-zero status.
set -e

# --- Pre-build Setup ---
echo "-- Starting application build process --"

# Check for python3
if ! command -v python3 &> /dev/null
then
    echo -e "\033[1;31mError: python3 command not found.\033[0m"
    echo -e "\033[1;31mPlease ensure Python 3.12+ is installed and available in your PATH.\033[0m"
    exit 1
fi

# Create virtual environment if it doesn't exist
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating 'venv'..."
    python3 -m venv venv
fi

# Activate virtual environment and install dependencies
echo "Activating virtual environment and installing dependencies..."
source venv/bin/activate
pip install -r requirements.txt

# Clean previous builds
echo "Cleaning old build artifacts (build/ and dist/ folders)..."
rm -rf build dist

# --- Build Logic ---

# Mode 1: Create macOS DMG Installer
if [[ "$1" == "dmg" ]]; then
    echo "-- Build mode: macOS DMG Installer --"

    if [[ "$(uname -s)" != "Darwin" ]]; then
        echo -e "\033[1;31mError: DMG creation is only supported on macOS.\033[0m"
        exit 1
    fi
    if ! command -v create-dmg &> /dev/null; then
        echo -e "\033[1;31mError: create-dmg command not found.\033[0m"
        echo -e "\033[1;31mPlease install it via Homebrew: brew install create-dmg\033[0m"
        exit 1
    fi

    # Build apps in ONEDIR mode for faster startup
    echo "Building Gemini CLI Launcher (onedir mode)..."
    pyinstaller --onedir --windowed --name "Gemini CLI Launcher" \
        --add-data "app.icns:." --icon "app.icns" start_gemini.py

    echo "Building Reset Settings (onedir mode)..."
    pyinstaller --onedir --windowed --name "Reset Settings" \
        --add-data "app.icns:." --icon "app.icns" reset_settings.py

    # --- Create a single DMG for both applications ---
    echo "Creating a unified DMG for both applications..."

    # 1. Create a temporary staging directory
    STAGING_DIR="dist/dmg_staging"
    mkdir -p "$STAGING_DIR"

    # 2. Copy both .app bundles into the staging directory
    echo "Staging applications..."
    cp -r "dist/Gemini CLI Launcher.app" "$STAGING_DIR/"
    cp -r "dist/Reset Settings.app" "$STAGING_DIR/"

    # 3. Create the single DMG from the staging directory
    create-dmg \
      --volname "Gemini CLI Tools" \
      --volicon "app.icns" \
      --window-pos 200 120 \
      --window-size 800 400 \
      --icon-size 100 \
      --icon "Gemini CLI Launcher.app" 200 190 \
      --hide-extension "Gemini CLI Launcher.app" \
      --icon "Reset Settings.app" 400 190 \
      --hide-extension "Reset Settings.app" \
      --app-drop-link 600 185 \
      "dist/Gemini_CLI_Tools.dmg" \
      "$STAGING_DIR"

    # 4. Clean up the staging directory and old DMGs
    rm -r "$STAGING_DIR"
    rm -f "dist/Gemini CLI Launcher.dmg" "dist/Reset Settings.dmg"

    echo -e "\n\033[1;32m==================================================\033[0m"
    echo -e "\033[1;32m  ✅ DMG creation completed successfully!        \033[0m"
    echo -e "\033[1;32m  📦 Installers are in the 'dist' folder.        \033[0m"
    echo -e "\033[1;32m==================================================\033[0m"

# Mode 2: Standard Folder (onedir) or Single File (onefile) build
else
    BUILD_TYPE="onefile"
    PYINSTALLER_FLAG="--onefile"
    if [[ "$1" == "folder" ]]; then
        BUILD_TYPE="onedir"
        PYINSTALLER_FLAG="--onedir"
    fi
    echo "-- Build mode: $BUILD_TYPE --"

    # Build main application
    echo "Building Gemini CLI Launcher ($BUILD_TYPE mode)..."
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Gemini CLI Launcher" \
        --add-data "app.icns:." --icon "app.icns" start_gemini.py

    # Build reset application
    echo "Building Reset Settings ($BUILD_TYPE mode)..."
    pyinstaller $PYINSTALLER_FLAG --windowed --name "Reset Settings" \
        --add-data "app.icns:." --icon "app.icns" reset_settings.py

    echo -e "\n\033[1;32m==================================================\033[0m"
    echo -e "\033[1;32m  ✅ Build process completed successfully!         \033[0m"
    echo -e "\033[1;32m  📦 Applications are in the 'dist' folder.        \033[0m"
    echo -e "\033[1;32m==================================================\033[0m"
fi

echo ""