#!/bin/bash

# Dev Monitor Uninstall Script for Linux/macOS

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="dev-monitor"
INSTALL_DIR="$HOME/.local/bin"

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

# Remove binary
remove_binary() {
    local binary_path="$INSTALL_DIR/$APP_NAME"
    
    if [ -f "$binary_path" ]; then
        print_status "Removing binary from $binary_path..."
        rm -f "$binary_path"
        print_success "Binary removed"
    else
        print_warning "Binary not found at $binary_path"
    fi
}

# Remove desktop entry (Linux only)
remove_desktop_entry() {
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        return
    fi
    
    local desktop_file="$HOME/.local/share/applications/$APP_NAME.desktop"
    
    if [ -f "$desktop_file" ]; then
        print_status "Removing desktop entry..."
        rm -f "$desktop_file"
        print_success "Desktop entry removed"
    fi
}

# Remove from PATH (optional)
remove_from_path() {
    print_warning "The installation directory ($INSTALL_DIR) may still be in your PATH."
    print_warning "If you no longer need it, you can manually remove it from your shell configuration file."
    
    # Detect shell and suggest appropriate RC file
    case "$SHELL" in
        */bash)
            print_status "Check: $HOME/.bashrc"
            ;;
        */zsh)
            print_status "Check: $HOME/.zshrc"
            ;;
        */fish)
            print_status "Check: $HOME/.config/fish/config.fish"
            ;;
        *)
            print_status "Check: $HOME/.profile"
            ;;
    esac
}

# Remove application data
remove_app_data() {
    read -p "Do you want to remove saved project data? This cannot be undone. (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Application data is stored by Neutralino.js in system-specific locations:"
        print_status "This data will be automatically cleaned up by the system over time."
        print_warning "Manual cleanup locations (if they exist):"
        print_status "  Linux: ~/.config/dev-monitor/ or ~/.local/share/dev-monitor/"
        print_status "  macOS: ~/Library/Application Support/dev-monitor/"
    else
        print_status "Keeping application data"
    fi
}

# Main uninstall function
main() {
    print_status "Dev Monitor Uninstall Script"
    print_status "============================"
    
    # Confirm uninstallation
    print_warning "This will remove Dev Monitor from your system."
    read -p "Continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Uninstall cancelled"
        exit 0
    fi
    
    remove_binary
    remove_desktop_entry
    remove_app_data
    remove_from_path
    
    echo
    print_success "Dev Monitor has been uninstalled successfully!"
    print_status "Thank you for using Dev Monitor! 👋"
}

# Run main function
main "$@"
