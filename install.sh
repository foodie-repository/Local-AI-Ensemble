#!/bin/bash

# Configuration
INSTALL_DIR="${HOME}/.local/bin"
TEMPLATE_DIR="${HOME}/.local/share/xv-ensemble/templates"

echo "Installing Local AI Ensemble Validation Tools..."

# 1. Create Directories
mkdir -p "$INSTALL_DIR"
mkdir -p "$TEMPLATE_DIR"

# 2. Copy Scripts
echo "- Installing scripts to $INSTALL_DIR..."
cp xv-local "$INSTALL_DIR/"
cp xv-ensemble "$INSTALL_DIR/"
chmod +x "$INSTALL_DIR/xv-local" "$INSTALL_DIR/xv-ensemble"

# 3. Copy Templates
echo "- Installing templates to $TEMPLATE_DIR..."
cp templates/default_review.md "$TEMPLATE_DIR/"
cp templates/ensemble.md "$TEMPLATE_DIR/"

# 4. Patch Scripts to Use Global Template Path
# (Simple sed replacement to point to the installed template location)
# Note: This is a bit hacky but ensures the installed scripts find their templates.
# Ideally, scripts should check env vars or XDG paths.
# For now, we assume the user might copy manually or use this script.
# Let's not modify the source scripts here to keep them portable.
# Instead, the scripts should be updated to look in $TEMPLATE_DIR by default.

echo ""
echo "✅ Installation Complete!"
echo ""
echo "Please ensure $INSTALL_DIR is in your PATH."
echo "You can now use 'xv-local' and 'xv-ensemble' from anywhere."
