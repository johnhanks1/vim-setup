#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== teampowers + vim setup ==="
echo ""

# --- Vim Setup ---
echo "[vim] Setting up Vim configuration..."

# Symlink .vimrc
if [ -L "$HOME/.vimrc" ]; then
    echo "[vim] Removing existing .vimrc symlink"
    rm "$HOME/.vimrc"
elif [ -f "$HOME/.vimrc" ]; then
    echo "[vim] Backing up existing .vimrc to ~/.vimrc.bak"
    mv "$HOME/.vimrc" "$HOME/.vimrc.bak"
fi
ln -s "$SCRIPT_DIR/vim/.vimrc" "$HOME/.vimrc"
echo "[vim] Linked ~/.vimrc -> $SCRIPT_DIR/vim/.vimrc"

# Install Vundle if not present
VUNDLE_DIR="$HOME/.vim/bundle/Vundle.vim"
if [ ! -d "$VUNDLE_DIR" ]; then
    echo "[vim] Installing Vundle..."
    git clone https://github.com/VundleVim/Vundle.vim.git "$VUNDLE_DIR"
else
    echo "[vim] Vundle already installed"
fi

# Install Vim plugins
echo "[vim] Installing Vim plugins..."
vim +PluginInstall +qall 2>/dev/null || echo "[vim] Plugin install requires interactive vim"

echo ""

# --- Teampowers Setup ---
echo "[teampowers] Setting up Claude Code plugin..."

# Check if Claude Code plugin CLI is available
if command -v claude &>/dev/null; then
    echo "[teampowers] Claude Code CLI found"
    echo "[teampowers] To install teampowers as a plugin, run:"
    echo "  claude plugin install $SCRIPT_DIR/teampowers"
else
    echo "[teampowers] Claude Code CLI not found"
    echo "[teampowers] Install Claude Code first, then run:"
    echo "  claude plugin install $SCRIPT_DIR/teampowers"
fi

echo ""
echo "=== Setup complete ==="
