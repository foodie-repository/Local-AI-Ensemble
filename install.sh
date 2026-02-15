#!/usr/bin/env bash

# Configuration
INSTALL_DIR="${HOME}/.local/bin"
TEMPLATE_DIR="${HOME}/.local/share/xv-ensemble/templates"

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
mkdir -p "$TEMPLATE_DIR"

# 2. Copy Scripts
echo "- Copying scripts to $INSTALL_DIR..."
cp xv-local "$INSTALL_DIR/" # Should create symlink instead? No, copy for portability.
cp xv-ensemble "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/xv-local" "$INSTALL_DIR/xv-ensemble"

# 3. Copy Templates
echo "- Copying templates to $TEMPLATE_DIR..."
cp templates/* "$TEMPLATE_DIR/" # Copy all templates

echo ""
echo "✅ Installation Complete!"
echo ""
echo "Please ensure $INSTALL_DIR is in your PATH."
echo "Tip: Add 'export PATH=$HOME/.local/bin:$PATH' to your ~/.zshrc or ~/.bashrc if needed."
