#!/usr/bin/env bash

# Configuration
INSTALL_DIR="${HOME}/.local/bin"
PROMPT_DIR="${HOME}/.local/share/xv-ensemble/prompts"

echo "🚀 Installing Local AI Ensemble Validation Tools..."

# OS Check (Simple)
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    # PowerShell/CMD is not supported directly.
    echo "❌ Windows (Powershell/CMD) is not directly supported."
    echo "   Please use WSL (Windows Subsystem for Linux) instead."
    exit 1
fi

# 1. Create Directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$PROMPT_DIR"

# 2. Copy Scripts
echo "- Copying scripts to $INSTALL_DIR..."
cp 02-scripts/xv-local "$INSTALL_DIR/"
cp 02-scripts/xv-ensemble "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/xv-local" "$INSTALL_DIR/xv-ensemble"

# 3. Copy Prompts
echo "- Copying prompts to $PROMPT_DIR..."
cp 01-system-prompts/* "$PROMPT_DIR/"

echo ""
echo "✅ Installation Complete!"
echo ""
echo "Please ensure $INSTALL_DIR is in your PATH."
echo "Tip: Add 'export PATH=$HOME/.local/bin:\$PATH' to your ~/.zshrc or ~/.bashrc if needed."
