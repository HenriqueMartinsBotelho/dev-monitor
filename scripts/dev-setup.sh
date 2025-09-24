#!/bin/bash

# Dev Monitor Development Setup Script
# This script helps developers set up the project for development

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

print_info() {
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

# Check if Node.js is installed
check_node() {
    if ! command -v node &> /dev/null; then
        print_error "Node.js is not installed. Please install Node.js (v14 or higher) first."
        print_info "Visit: https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node --version | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -lt 14 ]; then
        print_error "Node.js version 14 or higher is required. Current version: $(node --version)"
        exit 1
    fi
    
    print_success "Node.js $(node --version) detected"
}

# Check if npm is installed
check_npm() {
    if ! command -v npm &> /dev/null; then
        print_error "npm is not installed"
        exit 1
    fi
    
    print_success "npm $(npm --version) detected"
}

# Install Neutralino CLI
install_neutralino_cli() {
    print_info "Checking for Neutralino CLI..."
    
    if ! command -v neu &> /dev/null; then
        print_info "Installing Neutralino CLI globally..."
        npm install -g @neutralinojs/neu
        print_success "Neutralino CLI installed"
    else
        print_success "Neutralino CLI already installed: $(neu --version)"
    fi
}

# Update Neutralino binaries
update_neutralino() {
    print_info "Updating Neutralino binaries..."
    neu update
    print_success "Neutralino binaries updated"
}

# Check for VS Code
check_vscode() {
    if ! command -v code &> /dev/null; then
        print_warning "VS Code 'code' command not found"
        print_warning "Make sure VS Code is installed and the 'code' command is available"
        print_info "This is needed for the app to open projects, but you can still develop without it"
    else
        print_success "VS Code command available: $(code --version | head -1)"
    fi
}

# Set up git hooks (optional)
setup_git_hooks() {
    if [ -d ".git" ]; then
        print_info "Setting up git hooks..."
        
        # Create pre-commit hook
        cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook to run basic checks

echo "Running pre-commit checks..."

# Check if there are any JavaScript files with console.log (excluding main.js where it's expected)
if git diff --cached --name-only | grep -E '\.(js)$' | grep -v main.js | xargs grep -l "console\.log" 2>/dev/null; then
    echo "Warning: Found console.log statements in committed files (excluding main.js)"
    echo "Consider removing them before committing"
fi

echo "Pre-commit checks completed"
EOF
        
        chmod +x .git/hooks/pre-commit
        print_success "Git hooks set up"
    else
        print_warning "Not a git repository - skipping git hooks setup"
    fi
}

# Create development shortcuts
create_dev_shortcuts() {
    print_info "Creating development shortcuts..."
    
    # Add npm scripts if package.json doesn't have them
    if [ -f "package.json" ] && ! grep -q '"dev"' package.json; then
        print_info "Adding development scripts to package.json..."
        # This would require jq or manual editing, let's just inform the user
        print_info "Consider adding these scripts to package.json:"
        echo '  "dev": "neu run --frontend-lib-dev"'
        echo '  "build": "neu build"'
        echo '  "build:release": "neu build --release"'
    fi
}

# Run the application to test
test_run() {
    print_info "Testing the application..."
    
    read -p "Would you like to test run the application now? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_info "Starting Dev Monitor..."
        neu run
    else
        print_info "You can run the application later with: neu run"
    fi
}

# Main setup function
main() {
    print_info "🚀 Dev Monitor Development Setup"
    print_info "================================"
    
    check_node
    check_npm
    install_neutralino_cli
    update_neutralino
    check_vscode
    setup_git_hooks
    create_dev_shortcuts
    
    echo
    print_success "✅ Development setup complete!"
    echo
    print_info "Quick commands:"
    print_info "  neu run          - Run in development mode"
    print_info "  neu build        - Build the application"
    print_info "  neu run --help   - See all available options"
    echo
    print_info "For releases:"
    print_info "  ./scripts/release.sh - Create a new release"
    echo
    
    test_run
}

# Run the setup
main "$@"
