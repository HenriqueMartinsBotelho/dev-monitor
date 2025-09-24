# Dev Monitor Installation Script for Windows
# This script downloads and installs the latest release of Dev Monitor

param(
    [string]$InstallPath = "$env:LOCALAPPDATA\Programs\DevMonitor",
    [switch]$AddToPath = $true,
    [switch]$CreateShortcut = $true
)

# Configuration
$Repo = "HenriqueMartinsBotelho/dev-monitor"
$AppName = "dev-monitor"
$BinaryName = "dev-monitor-win-x64.exe"

# Colors for output
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

# Check if running as administrator (optional, for system-wide install)
function Test-Administrator {
    $currentUser = [Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object Security.Principal.WindowsPrincipal($currentUser)
    return $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
}

# Check dependencies
function Test-Dependencies {
    Write-Info "Checking dependencies..."
    
    # Check for PowerShell version
    if ($PSVersionTable.PSVersion.Major -lt 5) {
        Write-Error "PowerShell 5.0 or higher is required"
        exit 1
    }
    
    # Check for VS Code
    $codeCommand = Get-Command "code" -ErrorAction SilentlyContinue
    if (-not $codeCommand) {
        Write-Warning "VS Code 'code' command not found in PATH"
        Write-Warning "Make sure VS Code is installed and the 'code' command is available"
        Write-Warning "You can still install Dev Monitor, but project opening may not work"
        
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -ne "y" -and $response -ne "Y") {
            exit 1
        }
    }
}

# Get latest release information
function Get-LatestRelease {
    Write-Info "Fetching latest release information..."
    
    try {
        $apiUrl = "https://api.github.com/repos/$Repo/releases/latest"
        $releaseInfo = Invoke-RestMethod -Uri $apiUrl -ErrorAction Stop
        
        # Find the Windows binary download URL
        $asset = $releaseInfo.assets | Where-Object { $_.name -eq $BinaryName }
        
        if (-not $asset) {
            Write-Error "Could not find $BinaryName in the latest release"
            Write-Error "Available assets:"
            $releaseInfo.assets | ForEach-Object { Write-Host "  - $($_.name)" }
            exit 1
        }
        
        $script:DownloadUrl = $asset.browser_download_url
        $script:Version = $releaseInfo.tag_name
        
        Write-Info "Latest version: $Version"
    }
    catch {
        Write-Error "Failed to fetch release information: $($_.Exception.Message)"
        exit 1
    }
}

# Create installation directory
function New-InstallDirectory {
    Write-Info "Creating installation directory: $InstallPath"
    
    if (-not (Test-Path $InstallPath)) {
        try {
            New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null
        }
        catch {
            Write-Error "Failed to create installation directory: $($_.Exception.Message)"
            exit 1
        }
    }
}

# Download and install the binary
function Install-Binary {
    $tempBinary = [System.IO.Path]::GetTempFileName() + ".exe"
    $tempResources = [System.IO.Path]::GetTempFileName()
    $finalBinaryPath = Join-Path $InstallPath "$AppName.exe"
    $finalResourcesPath = Join-Path $InstallPath "resources.neu"
    
    Write-Info "Downloading $BinaryName..."
    
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $tempBinary -ErrorAction Stop
        Write-Success "Binary download completed"
        
        # Download resources.neu file
        $resourcesUrl = $DownloadUrl -replace "$BinaryName", "resources.neu"
        Write-Info "Downloading resources.neu..."
        Invoke-WebRequest -Uri $resourcesUrl -OutFile $tempResources -ErrorAction Stop
        Write-Success "Resources download completed"
        
        Write-Info "Installing to $finalBinaryPath..."
        Move-Item $tempBinary $finalBinaryPath -Force
        
        Write-Info "Installing resources to $finalResourcesPath..."
        Move-Item $tempResources $finalResourcesPath -Force
        
        Write-Success "$AppName installed successfully!"
    }
    catch {
        Write-Error "Failed to download or install: $($_.Exception.Message)"
        if (Test-Path $tempBinary) {
            Remove-Item $tempBinary -Force
        }
        if (Test-Path $tempResources) {
            Remove-Item $tempResources -Force
        }
        exit 1
    }
}

# Add to system PATH
function Add-ToPath {
    if (-not $AddToPath) {
        return
    }
    
    Write-Info "Adding installation directory to user PATH..."
    
    try {
        $userPath = [Environment]::GetEnvironmentVariable("PATH", "User")
        
        if ($userPath -notlike "*$InstallPath*") {
            $newPath = "$userPath;$InstallPath"
            [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")
            Write-Success "Added to PATH. Please restart your terminal or PowerShell session."
        }
        else {
            Write-Info "Installation directory is already in PATH"
        }
    }
    catch {
        Write-Warning "Failed to add to PATH: $($_.Exception.Message)"
        Write-Info "You can manually add '$InstallPath' to your PATH environment variable"
    }
}

# Create desktop shortcut
function New-DesktopShortcut {
    if (-not $CreateShortcut) {
        return
    }
    
    Write-Info "Creating desktop shortcut..."
    
    try {
        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $shortcutPath = Join-Path $desktopPath "$AppName.lnk"
        $exePath = Join-Path $InstallPath "$AppName.exe"
        
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $exePath
        $shortcut.WorkingDirectory = $InstallPath
        $shortcut.Description = "Development Project Manager"
        $shortcut.Save()
        
        Write-Success "Desktop shortcut created at $shortcutPath"
    }
    catch {
        Write-Warning "Failed to create desktop shortcut: $($_.Exception.Message)"
    }
}

# Create Start Menu shortcut
function New-StartMenuShortcut {
    Write-Info "Creating Start Menu shortcut..."
    
    try {
        $startMenuPath = [Environment]::GetFolderPath("Programs")
        $shortcutPath = Join-Path $startMenuPath "$AppName.lnk"
        $exePath = Join-Path $InstallPath "$AppName.exe"
        
        $shell = New-Object -ComObject WScript.Shell
        $shortcut = $shell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $exePath
        $shortcut.WorkingDirectory = $InstallPath
        $shortcut.Description = "Development Project Manager"
        $shortcut.Save()
        
        Write-Success "Start Menu shortcut created"
    }
    catch {
        Write-Warning "Failed to create Start Menu shortcut: $($_.Exception.Message)"
    }
}

# Main installation function
function Main {
    Write-Info "Dev Monitor Installation Script for Windows"
    Write-Info "=========================================="
    
    if (Test-Administrator) {
        Write-Info "Running as administrator"
    }
    else {
        Write-Info "Running as regular user (installing to user directory)"
    }
    
    Test-Dependencies
    Get-LatestRelease
    New-InstallDirectory
    Install-Binary
    Add-ToPath
    New-DesktopShortcut
    New-StartMenuShortcut
    
    Write-Host ""
    Write-Success "Installation complete!"
    Write-Info "Run '$AppName' from any terminal or use the desktop shortcut"
    
    if ($env:PATH -notlike "*$InstallPath*") {
        Write-Info "Or use the full path: $InstallPath\$AppName.exe"
    }
    
    Write-Host ""
    Write-Info "Thank you for using Dev Monitor! 🚀"
}

# Error handling
trap {
    Write-Error "An unexpected error occurred: $($_.Exception.Message)"
    exit 1
}

# Run the installation
Main
