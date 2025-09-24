# Dev Monitor 🚀

> A lightweight, cross-platform desktop application for managing and monitoring your development projects.

Built with [Neutralino.js](https://neutralino.js.org/), Dev Monitor provides a simple and elegant interface to organize your coding projects and quickly open them in Visual Studio Code.

[![GitHub release](https://img.shields.io/github/v/release/YOUR_USERNAME/dev-monitor)](https://github.com/YOUR_USERNAME/dev-monitor/releases)
[![GitHub license](https://img.shields.io/github/license/YOUR_USERNAME/dev-monitor)](LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/YOUR_USERNAME/dev-monitor?style=social)](https://github.com/YOUR_USERNAME/dev-monitor/stargazers)

![Dev Monitor Screenshot](resources/icons/logo.gif)

## ✨ Features

- **Project Management**: Add, edit, and delete development projects with ease
- **Quick Access**: One-click opening of projects in Visual Studio Code
- **Cross-Platform**: Works seamlessly on Windows, macOS, and Linux
- **Lightweight**: Built with Neutralino.js for minimal resource usage
- **System Tray Integration**: Access your projects from the system tray (Linux/Windows)
- **Persistent Storage**: Your project list is automatically saved and restored
- **Modern UI**: Clean, intuitive interface with hover effects and animations

## 📸 Screenshots

### Main Interface

- Clean project listing with project names and paths
- Easy-to-use Add/Edit/Delete functionality
- Responsive design that works across different screen sizes

### System Tray (Linux/Windows)

- Quick access to projects without opening the main window
- Version information and quit options available

## 🚀 Quick Start

### 📦 One-Line Install (Recommended)

#### Linux/macOS

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/dev-monitor/main/install.sh | bash
```

#### Windows (PowerShell as Administrator)

```powershell
iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/dev-monitor/main/install.ps1 | iex
```

### 📥 Manual Download

1. Go to the [**Releases**](../../releases/latest) page
2. Download the binary for your system:

   | Platform   | Architecture | Download                    |
   | ---------- | ------------ | --------------------------- |
   | 🐧 Linux   | x64          | `dev-monitor-linux-x64`     |
   | 🐧 Linux   | ARM64        | `dev-monitor-linux-arm64`   |
   | 🐧 Linux   | ARM32        | `dev-monitor-linux-armhf`   |
   | 🪟 Windows | x64          | `dev-monitor-win-x64.exe`   |
   | 🍎 macOS   | Universal    | `dev-monitor-mac-universal` |
   | 🍎 macOS   | ARM64        | `dev-monitor-mac-arm64`     |

3. **Linux/macOS**: Make executable and run

   ```bash
   chmod +x dev-monitor-*
   ./dev-monitor-*
   ```

4. **Windows**: Simply double-click the `.exe` file

## 🛠️ Prerequisites

- **Visual Studio Code** must be installed and accessible via the `code` command
  - On Windows: Install VS Code and ensure it's added to PATH
  - On macOS: Install VS Code and run `Shell Command: Install 'code' command in PATH` from the Command Palette
  - On Linux: Install VS Code via your package manager or from the official website

## 💾 Installation Methods

### Method 1: Download and Run (Recommended)

1. Download the latest release for your platform
2. Extract if needed and run the executable
3. The app will create its configuration automatically

### Method 2: Build from Source

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dev-monitor.git
cd dev-monitor

# Quick setup (automated)
./scripts/dev-setup.sh

# Or manual setup
npm install -g @neutralinojs/neu  # Install Neutralino CLI
neu update                        # Update binaries
neu build                        # Build the application
neu run                          # Run the application
```

### Method 3: Build from Source

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/dev-monitor.git
cd dev-monitor

# Install Neutralino.js CLI (if not already installed)
npm install -g @neutralinojs/neu

# Update Neutralino.js binaries
neu update

# Build the application
neu build

# Run the application
neu run
```

## 🗑️ Uninstallation

### Automated Uninstall

#### Linux/macOS

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/dev-monitor/main/scripts/uninstall.sh | bash
```

#### Windows (PowerShell)

```powershell
iwr -useb https://raw.githubusercontent.com/YOUR_USERNAME/dev-monitor/main/scripts/uninstall.ps1 | iex
```

### Manual Uninstall

#### Linux/macOS

```bash
# Remove the binary
rm ~/.local/bin/dev-monitor

# Remove desktop entry (Linux)
rm ~/.local/share/applications/dev-monitor.desktop

# Remove from PATH (edit your shell's RC file)
# Remove the line that adds ~/.local/bin to PATH if no longer needed
```

#### Windows

```powershell
# Remove from installation directory
Remove-Item "$env:LOCALAPPDATA\Programs\DevMonitor" -Recurse -Force

# Remove from PATH (via System Properties > Environment Variables)
# Or use: [Environment]::SetEnvironmentVariable("PATH", $newPath, "User")

# Remove shortcuts from Desktop and Start Menu
```

## 🎮 Usage

1. **Launch the Application**: Run the dev-monitor executable
2. **Add Projects**: Click "Add New Project" and provide:
   - Project name (e.g., "My Web App")
   - Project path (use Browse button or type manually)
3. **Open Projects**: Click on any project in the list to open it in VS Code
4. **Manage Projects**: Use Edit/Delete buttons to modify or remove projects
5. **System Tray**: Look for the tray icon to access projects without opening the main window

### Keyboard Shortcuts

- **Enter**: Save project when in the Add/Edit modal
- **Escape**: Close modal (planned feature)

## 🏗️ Project Structure

```
dev-monitor/
├── bin/                    # Neutralino.js binaries
├── resources/
│   ├── index.html         # Main HTML file
│   ├── styles.css         # Application styles
│   ├── icons/             # Application icons
│   └── js/
│       ├── main.js        # Main application logic
│       ├── tray.js        # System tray functionality
│       └── neutralino.js  # Neutralino.js client library
├── neutralino.config.json # Neutralino.js configuration
├── package.json           # Project metadata
└── README.md             # This file
```

## 🔧 Configuration

The application automatically saves your project list using Neutralino.js storage. No manual configuration is required.

### Default Projects

If no projects are configured, the app will create sample projects to demonstrate functionality.

## 🐛 Troubleshooting

### Common Issues

**"Could not open project in VS Code"**

- Ensure VS Code is installed and the `code` command is available in your PATH
- Try running `code --version` in your terminal to verify the installation

**Tray icon not appearing (macOS)**

- Tray functionality is disabled on macOS due to platform limitations
- Use the main window to access all features

**Application won't start**

- Ensure you have the correct binary for your platform and architecture
- Check that the binary has executable permissions (Linux/macOS)

### Getting Help

1. Check the [Issues](../../issues) page for known problems
2. Create a new issue with:
   - Operating system and version
   - Steps to reproduce the problem
   - Error messages (if any)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

### Quick Development Setup

```bash
# Clone and setup
git clone https://github.com/YOUR_USERNAME/dev-monitor.git
cd dev-monitor
./scripts/dev-setup.sh

# Development workflow
./scripts/tasks.sh dev      # Run in development mode
./scripts/tasks.sh build    # Build the application
./scripts/tasks.sh clean    # Clean build artifacts
```

### Available Scripts

- `npm run dev` - Run in development mode
- `npm run build` - Build for all platforms
- `npm run setup` - Run development setup
- `npm run tasks` - Show available tasks
- `./scripts/release.sh` - Create a new release

## 📋 Roadmap

- [ ] Keyboard shortcuts (Escape to close modal)
- [ ] Project categories/tags
- [ ] Recent projects list
- [ ] Custom IDE support (not just VS Code)
- [ ] Project templates
- [ ] Dark mode theme
- [ ] Project search/filter functionality
- [ ] Export/Import project lists
- [ ] Package manager integration (Homebrew, Chocolatey, Snap)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Neutralino.js](https://neutralino.js.org/) for the lightweight desktop app framework
- [Visual Studio Code](https://code.visualstudio.com/) for being an amazing code editor
- The open-source community for inspiration and support

## 🎯 Why Dev Monitor?

- **🚀 Fast**: Native performance with minimal resource usage
- **🔒 Secure**: No data leaves your machine - everything is stored locally
- **🎨 Beautiful**: Modern, clean interface that's pleasant to use
- **⚡ Efficient**: Quick access to all your projects from anywhere
- **🔧 Simple**: No complex configuration - just add projects and go

## 📊 Project Stats

![GitHub forks](https://img.shields.io/github/forks/YOUR_USERNAME/dev-monitor?style=social)
![GitHub issues](https://img.shields.io/github/issues/YOUR_USERNAME/dev-monitor)
![GitHub pull requests](https://img.shields.io/github/issues-pr/YOUR_USERNAME/dev-monitor)
![Downloads](https://img.shields.io/github/downloads/YOUR_USERNAME/dev-monitor/total)

---

<div align="center">
  <strong>Made with ❤️ by <a href="https://github.com/YOUR_USERNAME">Your Name</a></strong>
  <br>
  <sub>⭐ Star this repo if you find it useful!</sub>
</div>
