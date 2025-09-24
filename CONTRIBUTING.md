# Contributing to Dev Monitor

First off, thank you for considering contributing to Dev Monitor! It's people like you that make Dev Monitor such a great tool.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the [issue list](../../issues) as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible:

- **Use a clear and descriptive title** for the issue to identify the problem
- **Describe the exact steps which reproduce the problem** in as many details as possible
- **Provide specific examples to demonstrate the steps**
- **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior
- **Explain which behavior you expected to see instead and why**
- **Include screenshots and animated GIFs** which show you following the described steps and clearly demonstrate the problem

### Suggesting Enhancements

Enhancement suggestions are tracked as [GitHub issues](../../issues). When creating an enhancement suggestion, please include:

- **Use a clear and descriptive title** for the issue to identify the suggestion
- **Provide a step-by-step description of the suggested enhancement** in as many details as possible
- **Provide specific examples to demonstrate the steps** or point out the part of Dev Monitor where the suggestion is related to
- **Describe the current behavior** and **explain which behavior you expected to see instead** and why
- **Explain why this enhancement would be useful** to most Dev Monitor users

### Pull Requests

The process described here has several goals:

- Maintain Dev Monitor's quality
- Fix problems that are important to users
- Engage the community in working toward the best possible Dev Monitor
- Enable a sustainable system for Dev Monitor's maintainers to review contributions

Please follow these steps to have your contribution considered by the maintainers:

1. Follow all instructions in [the template](PULL_REQUEST_TEMPLATE.md)
2. Follow the [styleguides](#styleguides)
3. After you submit your pull request, verify that all [status checks](https://help.github.com/articles/about-status-checks/) are passing

## Development Setup

### Quick Setup

Run the automated setup script:

```bash
./scripts/dev-setup.sh
```

This will install all dependencies and set up the development environment.

### Manual Setup

#### Prerequisites

- [Node.js](https://nodejs.org/) (v14 or higher)
- [Git](https://git-scm.com/)
- [Visual Studio Code](https://code.visualstudio.com/) (recommended for testing)
- [Neutralino.js CLI](https://neutralino.js.org/docs/getting-started/installation)

### Local Development

1. Fork and clone the repository:

   ```bash
   git clone https://github.com/HenriqueMartinsBotelho/dev-monitor.git
   cd dev-monitor
   ```

2. Install Neutralino.js CLI globally:

   ```bash
   npm install -g @neutralinojs/neu
   ```

3. Update Neutralino.js binaries:

   ```bash
   neu update
   ```

4. Run the application in development mode:
   ```bash
   neu run
   ```

### Building

To build the application for all platforms:

```bash
neu build
```

The built binaries will be available in the `dist/` directory.

### Project Structure

```
dev-monitor/
├── .github/workflows/     # GitHub Actions workflows
├── bin/                   # Neutralino.js binaries
├── resources/
│   ├── index.html        # Main HTML file
│   ├── styles.css        # Application styles
│   ├── icons/            # Application icons
│   └── js/
│       ├── main.js       # Main application logic
│       ├── tray.js       # System tray functionality
│       └── neutralino.js # Neutralino.js client library
├── install.sh            # Linux/macOS installation script
├── install.ps1           # Windows installation script
├── neutralino.config.json # Neutralino.js configuration
├── package.json          # Project metadata
├── CHANGELOG.md          # Version history
└── README.md            # Project documentation
```

## Styleguides

### Git Commit Messages

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line
- Consider starting the commit message with an applicable emoji:
  - 🎉 `:tada:` when adding a new feature
  - 🐛 `:bug:` when fixing a bug
  - 📚 `:books:` when writing docs
  - 🎨 `:art:` when improving the format/structure of the code
  - 🐎 `:racehorse:` when improving performance
  - 🔧 `:wrench:` when adding configuration files
  - ✅ `:white_check_mark:` when adding tests

### JavaScript Styleguide

- Use 2 spaces for indentation
- Use semicolons at the end of statements
- Use single quotes for strings
- Use `const` for constants and `let` for variables (avoid `var`)
- Use descriptive variable and function names
- Add comments for complex logic
- Follow modern ES6+ practices

Example:

```javascript
// Good
const projectList = [];

function displayProjectList() {
  const mainDiv = document.getElementById("main");
  // Clear existing content
  mainDiv.innerHTML = "";

  // Render projects
  projectList.forEach((project) => {
    renderProject(project);
  });
}

// Bad
var list = [];

function display() {
  var div = document.getElementById("main");
  div.innerHTML = "";
  for (var i = 0; i < list.length; i++) {
    // render project
  }
}
```

### CSS Styleguide

- Use 2 spaces for indentation
- Use kebab-case for class names
- Group related properties together
- Use shorthand properties when possible
- Add comments for complex layouts

Example:

```css
/* Good */
.project-item {
  display: flex;
  justify-content: space-between;
  align-items: center;

  padding: 15px;
  margin: 10px 0;

  background-color: #f8f9fa;
  border: 1px solid #e9ecef;
  border-radius: 8px;

  transition: all 0.2s ease;
}

.project-item:hover {
  background-color: #e9ecef;
  transform: translateY(-1px);
}
```

## Testing

Currently, the project doesn't have automated tests, but this is something we'd love to add! If you're interested in contributing test infrastructure, please open an issue to discuss the approach.

### Manual Testing Checklist

Before submitting a pull request, please manually test:

- [ ] Application starts without errors
- [ ] Can add new projects with valid names and paths
- [ ] Can edit existing projects
- [ ] Can delete projects with confirmation
- [ ] Projects open correctly in VS Code (if installed)
- [ ] System tray works (Linux/Windows)
- [ ] Project list persists between app restarts
- [ ] Path validation works correctly
- [ ] Browse button opens folder dialog

## Release Process

1. Update version numbers in relevant files
2. Update CHANGELOG.md with new features and fixes
3. Create a new git tag: `git tag -a v1.x.x -m "Release v1.x.x"`
4. Push the tag: `git push origin v1.x.x`
5. GitHub Actions will automatically build and create a release

## Questions?

Don't hesitate to ask questions by opening an issue or reaching out to the maintainers. We're here to help!

Thank you for contributing! 🚀
