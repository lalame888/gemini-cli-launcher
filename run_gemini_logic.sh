#!/bin/bash
echo "--- Setting up NVM environment ---"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" || echo "NVM script not found, skipping..."
echo "--- Switching to Node v22 ---"
nvm use 22
echo "--- Changing to project directory: /Users/lala.huang/Documents/projects ---"
cd "/Users/lala.huang/Documents/projects"
echo "--- Starting Gemini CLI ---"
gemini
echo "--- Gemini CLI exited. Press Enter to close this terminal. ---"
read