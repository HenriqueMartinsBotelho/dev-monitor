#!/bin/bash

# Dev Monitor Installation Script for Linux/macOS
# This script downloads and installs the latest release of Dev Monitor

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
REPO="YOUR_USERNAME/dev-monitor"
APP_NAME="dev-monitor"
INSTALL_DIR="$HOME/.local/bin"

# Functions
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Detect OS and architecture
detect_platform() {
    local os=$(uname -s | tr '[:upper:]' '[:lower:]')
    local arch=$(uname -m)
    
    case "$os" in
        linux*)
            OS="linux"
            ;;
        darwin*)
            OS="mac"
            ;;
        *)
            print_error "Unsupported operating system: $os"
            exit 1
            ;;
    esac
    
    case "$arch" in
        x86_64|amd64)
            ARCH="x64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        armv7l)
            if [ "$OS" = "linux" ]; then
                ARCH="armhf"
            else
                print_error "ARM32 not supported on macOS"
                exit 1
            fi
            ;;
        *)
            print_error "Unsupported architecture: $arch"
            exit 1
            ;;
    esac
    
    if [ "$OS" = "mac" ] && [ "$ARCH" = "x64" ]; then
        # Use universal binary for macOS
        BINARY_NAME="${APP_NAME}-${OS}_universal"
    else
        BINARY_NAME="${APP_NAME}-${OS}_${ARCH}"
    fi
    
    print_status "Detected platform: $OS-$ARCH"
    print_status "Binary to download: $BINARY_NAME"
}

# Check if required tools are installed
check_dependencies() {
    local deps=("curl" "tar" "chmod")
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            print_error "Required dependency '$dep' is not installed"
            exit 1
        fi
    done
    
    # Check for VS Code
    if ! command -v "code" >/dev/null 2>&1; then
        print_warning "VS Code 'code' command not found in PATH"
        print_warning "Make sure VS Code is installed and the 'code' command is available"
        print_warning "You can still install Dev Monitor, but project opening may not work"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

# Get the latest release information
get_latest_release() {
    print_status "Fetching latest release information..."
    
    local api_url="https://api.github.com/repos/$REPO/releases/latest"
    local release_info=$(curl -s "$api_url")
    
    if [ $? -ne 0 ]; then
        print_error "Failed to fetch release information"
        exit 1
    fi
    
    # Extract download URL for our binary
    DOWNLOAD_URL=$(echo "$release_info" | grep -o "https://github.com/$REPO/releases/download/[^\"]*$BINARY_NAME[^\"]*" | head -1)
    
    if [ -z "$DOWNLOAD_URL" ]; then
        print_error "Could not find download URL for $BINARY_NAME"
        print_error "Available assets:"
        echo "$release_info" | grep -o "https://github.com/$REPO/releases/download/[^\"]*" | sed 's/.*\//  - /'
        exit 1
    fi
    
    VERSION=$(echo "$release_info" | grep '"tag_name":' | sed -E 's/.*"tag_name": *"([^"]+)".*/\1/')
    print_status "Latest version: $VERSION"
}

# Create installation directory
create_install_dir() {
    if [ ! -d "$INSTALL_DIR" ]; then
        print_status "Creating installation directory: $INSTALL_DIR"
        mkdir -p "$INSTALL_DIR"
    fi
}

# Download and install the binary
download_and_install() {
    local temp_file=$(mktemp)
    local final_path="$INSTALL_DIR/$APP_NAME"
    
    print_status "Downloading $BINARY_NAME..."
    if curl -L --progress-bar -o "$temp_file" "$DOWNLOAD_URL"; then
        print_success "Download completed"
    else
        print_error "Failed to download the binary"
        exit 1
    fi
    
    if [ $? -ne 0 ]; then
        print_error "Failed to download $BINARY_NAME"
        rm -f "$temp_file"
        exit 1
    fi
    
    print_status "Installing to $final_path..."
    mv "$temp_file" "$final_path"
    chmod +x "$final_path"
    
    print_success "$APP_NAME installed successfully!"
}

# Add to PATH if needed
setup_path() {
    local shell_rc=""
    
    # Detect shell and set appropriate RC file
    case "$SHELL" in
        */bash)
            shell_rc="$HOME/.bashrc"
            ;;
        */zsh)
            shell_rc="$HOME/.zshrc"
            ;;
        */fish)
            shell_rc="$HOME/.config/fish/config.fish"
            ;;
        *)
            shell_rc="$HOME/.profile"
            ;;
    esac
    
    # Check if INSTALL_DIR is already in PATH
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_status "Adding $INSTALL_DIR to PATH in $shell_rc"
        
        if [ "$SHELL" = "*/fish" ]; then
            echo "set -gx PATH \$PATH $INSTALL_DIR" >> "$shell_rc"
        else
            echo "export PATH=\"\$PATH:$INSTALL_DIR\"" >> "$shell_rc"
        fi
        
        print_warning "Please restart your terminal or run: source $shell_rc"
    else
        print_status "$INSTALL_DIR is already in PATH"
    fi
}

# Create desktop entry (Linux only)
create_desktop_entry() {
    if [ "$OS" != "linux" ]; then
        return
    fi
    
    local desktop_dir="$HOME/.local/share/applications"
    local desktop_file="$desktop_dir/$APP_NAME.desktop"
    
    if [ ! -d "$desktop_dir" ]; then
        mkdir -p "$desktop_dir"
    fi
    
    print_status "Creating desktop entry..."
    
    cat > "$desktop_file" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Dev Monitor
Comment=Development Project Manager
Exec=$INSTALL_DIR/$APP_NAME
Icon=$APP_NAME
Terminal=false
Categories=Development;IDE;
StartupWMClass=$APP_NAME
EOF
    
    chmod +x "$desktop_file"
    print_success "Desktop entry created at $desktop_file"
}

# Main installation function
main() {
    print_status "Dev Monitor Installation Script"
    print_status "==============================="
    
    detect_platform
    check_dependencies
    get_latest_release
    create_install_dir
    download_and_install
    setup_path
    create_desktop_entry
    
    echo
    print_success "Installation complete!"
    print_status "Run '$APP_NAME' to start the application"
    
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        print_status "Or use the full path: $INSTALL_DIR/$APP_NAME"
    fi
    
    echo
    print_status "Thank you for using Dev Monitor! 🚀"
}

# Run the installation
main "$@"
