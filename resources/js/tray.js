class TrayManager {
  constructor() {
    this.isInitialized = false;
  }

  init() {
    console.log(`INFO: Initializing tray menu. OS: ${NL_OS}, Mode: ${NL_MODE}`);

    // Skip initialization on macOS due to known issues
    if (NL_OS === "Darwin") {
      console.log(
        "INFO: Tray menu disabled on macOS due to platform limitations."
      );
      return;
    }

    if (NL_MODE !== "window") {
      console.log("INFO: Tray menu is only available in the window mode.");
      return;
    }

    try {
      this.setupTray();
      this.setupEventListeners();
      this.isInitialized = true;
      console.log(
        "SUCCESS: Tray menu initialized successfully. Look for the tray icon in your system tray!"
      );
    } catch (error) {
      console.error("ERROR: Failed to initialize tray menu:", error);
    }
  }

  setupTray() {
    console.log("INFO: Setting up tray with icon and menu items...");

    const tray = {
      icon: "/resources/icons/trayIcon.png",
      menuItems: [
        { id: "VERSION", text: "Get version" },
        { id: "SEP", text: "-" },
        { id: "PROJECTS", text: "Show Projects" },
        { id: "SEP2", text: "-" },
        { id: "QUIT", text: "Quit" },
      ],
    };

    Neutralino.os.setTray(tray);
    console.log(
      "INFO: Tray setup completed. Check your system tray area for the icon."
    );
  }

  setupEventListeners() {
    Neutralino.events.on(
      "trayMenuItemClicked",
      this.handleTrayMenuClick.bind(this)
    );
  }

  handleTrayMenuClick(event) {
    switch (event.detail.id) {
      case "VERSION":
        this.showVersionInfo();
        break;
      case "PROJECTS":
        this.showMainWindow();
        break;
      case "QUIT":
        this.quitApplication();
        break;
    }
  }

  showVersionInfo() {
    Neutralino.os.showMessageBox(
      "Version Information",
      `Neutralinojs server: v${NL_VERSION}\nNeutralinojs client: v${NL_CVERSION}`
    );
  }

  showMainWindow() {
    Neutralino.window.show();
    Neutralino.window.focus();
  }

  quitApplication() {
    Neutralino.app.exit();
  }

  isReady() {
    return this.isInitialized;
  }
}

const trayManager = new TrayManager();

Neutralino.events.on("ready", () => {
  trayManager.init();
});

window.trayManager = trayManager;
