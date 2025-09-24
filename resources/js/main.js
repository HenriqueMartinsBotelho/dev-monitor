const projectList = [
  { name: "Project A", path: "~/dev/main-projects/dream-frontend" },
  { name: "Project B", path: "/path/to/projectB" },
  { name: "Project C", path: "/path/to/projectC" },
];

async function openProject(projectPath) {
  try {
    let expandedPath = projectPath;
    if (projectPath.startsWith("~")) {
      const homeEnvVar = NL_OS === "Windows" ? "USERPROFILE" : "HOME";
      const homeDir = await Neutralino.os.getEnv(homeEnvVar);
      expandedPath = projectPath.replace("~", homeDir);
    }

    await Neutralino.os.execCommand(`code "${expandedPath}"`);
    console.log(`Opened project: ${expandedPath}`);
  } catch (error) {
    console.error("Error opening project:", error);
    Neutralino.os.showMessageBox(
      "Error",
      `Could not open project in VS Code. Make sure VS Code is installed and accessible via 'code' command.\nPath: ${projectPath}`
    );
  }
}

function displayProjectList() {
  const mainDiv = document.getElementById("main");

  let projectHTML = "<h2>Development Projects</h2>";
  projectHTML += '<div class="project-list">';

  projectList.forEach((project, index) => {
    projectHTML += `
      <div class="project-item" onclick="openProject('${project.path}')">
        <h3>${project.name}</h3>
        <p class="project-path">${project.path}</p>
      </div>
    `;
  });

  projectHTML += "</div>";
  mainDiv.innerHTML = projectHTML;
}

function onWindowClose() {
  Neutralino.app.exit();
}

Neutralino.init();

Neutralino.events.on("windowClose", onWindowClose);

displayProjectList();
