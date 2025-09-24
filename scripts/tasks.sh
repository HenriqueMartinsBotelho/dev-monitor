#!/bin/bash

# Dev Monitor Task Runner
# Simple script to run common development tasks

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_usage() {
    echo "Dev Monitor Task Runner"
    echo "Usage: ./scripts/tasks.sh [command]"
    echo ""
    echo "Available commands:"
    echo "  dev       - Run in development mode"
    echo "  build     - Build the application"
    echo "  release   - Build for release"
    echo "  clean     - Clean build artifacts"
    echo "  setup     - Run development setup"
    echo "  test      - Run tests (placeholder)"
    echo "  format    - Format code (placeholder)"
    echo "  lint      - Lint code (placeholder)"
    echo "  update    - Update Neutralino binaries"
    echo "  help      - Show this help message"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Task functions
task_dev() {
    print_info "Starting development server..."
    neu run
}

task_build() {
    print_info "Building application..."
    neu build
    print_success "Build completed"
}

task_release() {
    print_info "Building for release..."
    neu build --release
    print_success "Release build completed"
}

task_clean() {
    print_info "Cleaning build artifacts..."
    rm -rf dist/
    rm -f neutralinojs.log
    print_success "Cleaned build artifacts"
}

task_setup() {
    print_info "Running development setup..."
    ./scripts/dev-setup.sh
}

task_test() {
    print_info "Running tests..."
    echo "TODO: Add test framework (Jest, Mocha, etc.)"
}

task_format() {
    print_info "Formatting code..."
    echo "TODO: Add code formatter (Prettier, etc.)"
}

task_lint() {
    print_info "Linting code..."
    echo "TODO: Add linter (ESLint, etc.)"
}

task_update() {
    print_info "Updating Neutralino binaries..."
    neu update
    print_success "Neutralino binaries updated"
}

# Main script logic
case "${1:-help}" in
    "dev")
        task_dev
        ;;
    "build")
        task_build
        ;;
    "release")
        task_release
        ;;
    "clean")
        task_clean
        ;;
    "setup")
        task_setup
        ;;
    "test")
        task_test
        ;;
    "format")
        task_format
        ;;
    "lint")
        task_lint
        ;;
    "update")
        task_update
        ;;
    "help"|"--help"|"-h")
        print_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        print_usage
        exit 1
        ;;
esac
