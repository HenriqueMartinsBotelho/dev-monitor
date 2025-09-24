# Dev Monitor Uninstall Script for Windows

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\Programs\DevMonitor",
    [switch]$RemoveFromPath = $true,
    [switch]$RemoveShortcuts = $true,
    [switch]$RemoveAppData = $false
)

# Configuration
$AppName = "dev-monitor"

# Functions for colored output
function Write-Info($Message) {
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-Success($Message) {
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

function Write-Warning($Message) {
    Write-Host "[WARNING] $Message" -ForegroundColor Yellow
}

function Write-Error($Message) {
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

# Remove binary
function Remove-Binary {
    $binaryPath = Join-Path $InstallPath "$AppName.exe"
    
    if (Test-Path $binaryPath) {
        Write-Info "Removing binary from $binaryPath..."
        try {
            Remove-Item $binaryPath -Force
            Write-Success "Binary removed"
        }
        catch {
            Write-Error "Failed to remove binary: $($_.Exception.Message)"
        }
    }
    else {
        Write-Warning "Binary not found at $binaryPath"
    }
    
    # Remove installation directory if empty
    if (Test-Path $InstallPath) {
        try {
            $items = Get-ChildItem $InstallPath -ErrorAction SilentlyContinue
            if (-not $items) {
                Remove-Item $InstallPath -Force
                Write-Success "Removed empty installation directory"
            }
        }
        catch {
            Write-Warning "Could not remove installation directory: $($_.Exception.Message)"
        }
    }
}

# Remove from PATH
function Remove-FromPath {
    if (-not $RemoveFromPath) {
        return
    }
    
    Write-Info "Removing installation directory from user PATH..."
    
    try {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        
        if ($userPath -like "*$InstallPath*") {
            $newPath = ($userPath -split ';' | Where-Object { $_ -ne $InstallPath }) -join ';'
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Write-Success "Removed from PATH"
        }
        else {
            Write-Info "Installation directory was not in PATH"
        }
    }
    catch {
        Write-Warning "Failed to remove from PATH: $($_.Exception.Message)"
    }
}

# Remove shortcuts
function Remove-Shortcuts {
    if (-not $RemoveShortcuts) {
        return
    }
    
    # Remove desktop shortcut
    try {
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $desktopShortcut = Join-Path $desktopPath "$AppName.lnk"
        
        if (Test-Path $desktopShortcut) {
            Remove-Item $desktopShortcut -Force
            Write-Success "Removed desktop shortcut"
        }
    }
    catch {
        Write-Warning "Failed to remove desktop shortcut: $($_.Exception.Message)"
    }
    
    # Remove Start Menu shortcut
    try {
        $startMenuPath = [Environment]::GetFolderPath("Programs")
        $startMenuShortcut = Join-Path $startMenuPath "$AppName.lnk"
        
        if (Test-Path $startMenuShortcut) {
            Remove-Item $startMenuShortcut -Force
            Write-Success "Removed Start Menu shortcut"
        }
    }
    catch {
        Write-Warning "Failed to remove Start Menu shortcut: $($_.Exception.Message)"
    }
}

# Remove application data
function Remove-AppData {
    if (-not $RemoveAppData) {
        Write-Info "Application data will be kept (use -RemoveAppData to remove)"
        return
    }
    
    Write-Warning "Removing application data (this cannot be undone)..."
    Write-Info "Application data is managed by Neutralino.js and may be in:"
    Write-Info "  $env:LOCALAPPDATA\neutralinojs\dev-monitor"
    Write-Info "  $env:APPDATA\neutralinojs\dev-monitor"
    Write-Info "The system will clean this up automatically over time."
}

# Main uninstall function
function Main {
    Write-Info "Dev Monitor Uninstall Script for Windows"
    Write-Info "========================================"
    
    # Confirm uninstallation
    Write-Warning "This will remove Dev Monitor from your system."
    $confirmation = Read-Host "Continue? (y/N)"
    
    if ($confirmation -ne "y" -and $confirmation -ne "Y") {
        Write-Info "Uninstall cancelled"
        exit 0
    }
    
    Remove-Binary
    Remove-FromPath
    Remove-Shortcuts
    Remove-AppData
    
    Write-Host ""
    Write-Success "Dev Monitor has been uninstalled successfully!"
    Write-Info "Thank you for using Dev Monitor! 👋"
}

# Error handling
trap {
    Write-Error "An unexpected error occurred: $($_.Exception.Message)"
    exit 1
}

# Run the uninstallation
Main
