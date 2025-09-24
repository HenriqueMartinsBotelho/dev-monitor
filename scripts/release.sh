#!/bin/bash

# Release Script for Dev Monitor
# This script helps create and push a new release

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

# Function to check if we're in a git repository
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_error "Not in a git repository"
        exit 1
    fi
}

# Function to check for uncommitted changes
check_clean_working_tree() {
    if ! git diff-index --quiet HEAD --; then
        print_error "Working tree is not clean. Please commit or stash your changes."
        exit 1
    fi
}

# Function to validate version format
validate_version() {
    local version=$1
    if [[ ! $version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_error "Version must be in format v0.0.0 (e.g., v1.0.0)"
        exit 1
    fi
}

# Function to update version in files
update_version() {
    local version=$1
    local version_no_v=${version#v}
    
    print_info "Updating version to $version in project files..."
    
    # Update package.json
    if [ -f "package.json" ]; then
        sed -i.bak "s/\"version\": \"[^\"]*\"/\"version\": \"$version_no_v\"/" package.json
        rm package.json.bak
        print_success "Updated package.json"
    fi
    
    # Update neutralino.config.json
    if [ -f "neutralino.config.json" ]; then
        sed -i.bak "s/\"version\": \"[^\"]*\"/\"version\": \"$version_no_v\"/" neutralino.config.json
        rm neutralino.config.json.bak
        print_success "Updated neutralino.config.json"
    fi
    
    # Check if there are changes to commit
    if ! git diff --quiet; then
        git add package.json neutralino.config.json
        git commit -m "Bump version to $version"
        print_success "Committed version changes"
    fi
}

# Function to create and push tag
create_and_push_tag() {
    local version=$1
    
    print_info "Creating git tag $version..."
    git tag -a "$version" -m "Release $version"
    
    print_info "Pushing tag to origin..."
    git push origin "$version"
    
    print_success "Tag $version created and pushed"
}

# Main script
main() {
    print_info "🚀 Dev Monitor Release Script"
    echo
    
    # Check prerequisites
    check_git_repo
    check_clean_working_tree
    
    # Get version from user
    read -p "Enter release version (e.g., v1.0.0): " version
    
    # Validate version
    validate_version "$version"
    
    # Check if tag already exists
    if git rev-parse "$version" >/dev/null 2>&1; then
        print_error "Tag $version already exists"
        exit 1
    fi
    
    # Confirm release
    echo
    print_warning "This will:"
    echo "  1. Update version in package.json and neutralino.config.json"
    echo "  2. Commit version changes"
    echo "  3. Create and push tag $version"
    echo "  4. Trigger GitHub Actions to build and create release"
    echo
    read -p "Continue? (y/N): " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Release cancelled"
        exit 0
    fi
    
    # Update version in files
    update_version "$version"
    
    # Create and push tag
    create_and_push_tag "$version"
    
    echo
    print_success "🎉 Release $version initiated!"
    print_info "GitHub Actions will now build and publish the release."
    print_info "Check the progress at: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:/]\([^.]*\).*/\1/')/actions"
}

# Run main function
main "$@"
