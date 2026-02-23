#!/bin/bash
# Install auntie from GitHub
# Usage: curl -sSf https://longrunningagents.com/auntie/install.sh | bash
#
# This script installs auntie to ~/.cargo/bin/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo ""
echo "=========================================="
echo "  Auntie Installer"
echo "=========================================="
echo ""

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "System check:"
echo "  OS: $OS"
echo "  Architecture: $ARCH"
echo ""

# Check OS compatibility
case "$OS" in
    Linux|Darwin)
        echo -e "  ${GREEN}✓${NC} Operating system supported"
        ;;
    MINGW*|MSYS*|CYGWIN*)
        echo -e "  ${YELLOW}⚠${NC} Windows detected - using Windows compatibility mode"
        ;;
    *)
        echo -e "  ${RED}✗${NC} Unsupported operating system: $OS"
        echo "  Supported: Linux, macOS, Windows (WSL recommended)"
        exit 1
        ;;
esac

# Check architecture
case "$ARCH" in
    x86_64|amd64|arm64|aarch64)
        echo -e "  ${GREEN}✓${NC} Architecture supported"
        ;;
    *)
        echo -e "  ${YELLOW}⚠${NC} Architecture $ARCH may work but is untested"
        ;;
esac

# Check for git
if command -v git &> /dev/null; then
    GIT_VERSION=$(git --version | cut -d' ' -f3)
    echo -e "  ${GREEN}✓${NC} Git installed (v$GIT_VERSION)"
else
    echo -e "  ${RED}✗${NC} Git is not installed"
    echo ""
    echo "Please install git first:"
    case "$OS" in
        Linux)
            echo "  Ubuntu/Debian: sudo apt install git"
            echo "  Fedora/RHEL:   sudo dnf install git"
            echo "  Arch:          sudo pacman -S git"
            ;;
        Darwin)
            echo "  macOS: xcode-select --install"
            ;;
    esac
    exit 1
fi

# Check for curl (needed for rustup if cargo not installed)
if command -v curl &> /dev/null; then
    echo -e "  ${GREEN}✓${NC} curl installed"
else
    echo -e "  ${RED}✗${NC} curl is not installed"
    echo ""
    echo "Please install curl first:"
    case "$OS" in
        Linux)
            echo "  Ubuntu/Debian: sudo apt install curl"
            echo "  Fedora/RHEL:   sudo dnf install curl"
            echo "  Arch:          sudo pacman -S curl"
            ;;
        Darwin)
            echo "  macOS: brew install curl"
            ;;
    esac
    exit 1
fi

echo ""

# Check for cargo/rust, install if missing
if command -v cargo &> /dev/null; then
    CARGO_VERSION=$(cargo --version | cut -d' ' -f2)
    echo -e "${GREEN}✓${NC} Cargo already installed (v$CARGO_VERSION)"
else
    echo -e "${YELLOW}!${NC} Cargo/Rust not found - installing now..."
    echo ""

    # Install rustup non-interactively
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Source cargo env for current session
    if [ -f "$HOME/.cargo/env" ]; then
        source "$HOME/.cargo/env"
    elif [ -f "$HOME/.cargo/bin/cargo" ]; then
        export PATH="$HOME/.cargo/bin:$PATH"
    fi

    # Verify installation
    if command -v cargo &> /dev/null; then
        CARGO_VERSION=$(cargo --version | cut -d' ' -f2)
        echo ""
        echo -e "${GREEN}✓${NC} Cargo installed successfully (v$CARGO_VERSION)"
    else
        echo -e "${RED}✗${NC} Cargo installation failed"
        echo "Please install manually: https://rustup.rs"
        exit 1
    fi
fi

# Check if ~/.cargo/bin is in PATH
if [[ ":$PATH:" != *":$HOME/.cargo/bin:"* ]]; then
    echo ""
    echo -e "${YELLOW}⚠${NC} ~/.cargo/bin is not in your PATH"
    echo "  Add this to your shell profile (~/.bashrc, ~/.zshrc, etc.):"
    echo "  export PATH=\"\$HOME/.cargo/bin:\$PATH\""
    echo ""
fi

echo ""
echo "Installing auntie from GitHub..."
echo ""

# Use system git for SSH key support, with HTTPS fallback
if CARGO_NET_GIT_FETCH_WITH_CLI=true cargo install --git ssh://git@github.com/xeb/auntie.git --force 2>/dev/null; then
    echo ""
elif cargo install --git https://github.com/xeb/auntie.git --force; then
    echo ""
else
    echo -e "${RED}✗${NC} Installation failed"
    echo ""
    echo "Try installing manually:"
    echo "  cargo install --git https://github.com/xeb/auntie.git"
    exit 1
fi

echo "=========================================="
echo -e "  ${GREEN}Installation complete!${NC}"
echo "=========================================="
echo ""
echo "Installed:"
echo "  auntie - Chrome browser automation CLI"
echo ""
echo "Location: ~/.cargo/bin/"
echo ""
echo "Verify with:"
echo "  auntie --version"
echo ""
echo "Quick start:"
echo "  auntie start                # Start Chrome with debugging"
echo "  auntie open https://example.com"
echo "  auntie screenshot shot.png"
echo "  auntie stop"
echo ""
echo "GitHub: https://github.com/xeb/auntie"
echo ""
