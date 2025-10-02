let projectList = [];

async function loadProjects() {
  try {
    const storedProjects = await Neutralino.storage.getData("projectList");
    projectList = JSON.parse(storedProjects);
  } catch (error) {
    projectList = [
      {
        name: "Project A",
        path: "~/path/to/projectA",
        repo: "http://github.com/user/projectA",
      },
      {
        name: "Project B",
        path: "/path/to/projectB",
        repo: "http://github.com/user/projectB",
      },
      {
        name: "Project C",
        path: "/path/to/projectC",
        repo: "http://github.com/user/projectC",
      },
    ];
    await saveProjects();
  }
}

async function saveProjects() {
  try {
    await Neutralino.storage.setData(
      "projectList",
      JSON.stringify(projectList)
    );
  } catch (error) {
    console.error("Error saving projects:", error);
  }
}

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

  projectHTML += `
    <div class="project-controls">
      <button id="addProjectBtn" class="btn btn-primary">Add New Project</button>
    </div>
  `;

  projectHTML += '<div class="project-list">';

  if (projectList.length === 0) {
    projectHTML +=
      '<p class="no-projects">No projects configured. Click "Add New Project" to get started.</p>';
  } else {
    projectList.forEach((project, index) => {
      console.log(project.name);
      projectHTML += `
        <div class="project-item">
          <div class="project-content" onclick="openProject('${project.path}')">
            <h3>${project.name}</h3>
            <p class="project-path">${project.path}</p>
          </div>
          <div class="project-actions">
            <button onclick="editProject(${index})" class="btn btn-small btn-edit">Edit</button>
            <button onclick="deleteProject(${index})" class="btn btn-small btn-delete">Delete</button>
            ${
              project.repo
                ? `<button onclick="openRepo('${project.repo}')" class="btn btn-small btn-open">Github</button>`
                : `<button class="btn btn-small btn-open" disabled title="No repository configured">Github</button>`
            }
          </div>
        </div>
      `;
    });
  }

  projectHTML += "</div>";
  mainDiv.innerHTML = projectHTML;

  document
    .getElementById("addProjectBtn")
    .addEventListener("click", showAddProjectModal);
}

function showAddProjectModal() {
  showProjectModal();
}

function editProject(index) {
  const project = projectList[index];
  showProjectModal(project, index);
}

async function deleteProject(index) {
  const project = projectList[index];
  const confirmed = await Neutralino.os.showMessageBox(
    "Confirm Delete",
    `Are you sure you want to delete "${project.name}"?`,
    "YES_NO",
    "QUESTION"
  );

  if (confirmed === "YES") {
    projectList.splice(index, 1);
    await saveProjects();
    displayProjectList();
  }
}

function openRepo(repoUrl) {
  if (!repoUrl || repoUrl === "undefined") {
    Neutralino.os.showMessageBox(
      "Repository not set",
      "This project does not have a repository URL configured."
    );
    return;
  }

  console.log(`Opening repository: ${repoUrl}`);

  // Cross-platform open in default browser
  let cmd = "";
  if (NL_OS === "Windows") {
    cmd = `cmd /c start "" "${repoUrl}"`;
  } else if (NL_OS === "Darwin") {
    cmd = `open "${repoUrl}"`;
  } else {
    cmd = `xdg-open "${repoUrl}"`;
  }

  Neutralino.os.execCommand(cmd);
}

function showProjectModal(project = null, index = null) {
  const isEdit = project !== null;

  const modal = document.createElement("div");
  modal.className = "modal";
  modal.innerHTML = `
    <div class="modal-content">
      <div class="modal-header">
        <h3>${isEdit ? "Edit Project" : "Add New Project"}</h3>
        <span class="modal-close" onclick="closeModal()">&times;</span>
      </div>
      <div class="modal-body">
        <form id="projectForm">
          <div class="form-group">
            <label for="projectName">Project Name:</label>
            <input type="text" id="projectName" value="${
              project ? project.name : ""
            }" required>
          </div>
          <div class="form-group">
            <label for="projectPath">Project Path:</label>
            <div class="path-input-group">
              <input type="text" id="projectPath" value="${
                project ? project.path : ""
              }" required>
              <button type="button" id="browseBtn" class="btn btn-secondary">Browse</button>
            </div>
          </div>
          <div class="form-group">
            <label for="projectRepo">Repository URL (optional):</label>
            <input type="url" id="projectRepo" value="${
              project && project.repo ? project.repo : ""
            }" placeholder="https://github.com/user/repo">
          </div>
        </form>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" onclick="closeModal()">Cancel</button>
        <button type="button" class="btn btn-primary" onclick="saveProject(${index})">${
    isEdit ? "Update" : "Add"
  } Project</button>
      </div>
    </div>
  `;

  document.body.appendChild(modal);

  document
    .getElementById("browseBtn")
    .addEventListener("click", selectProjectPath);

  document.getElementById("projectName").focus();

  document.getElementById("projectForm").addEventListener("keypress", (e) => {
    if (e.key === "Enter") {
      e.preventDefault();
      saveProject(index);
    }
  });
}

async function selectProjectPath() {
  try {
    const selectedPath = await Neutralino.os.showFolderDialog(
      "Select Project Folder"
    );
    if (selectedPath) {
      document.getElementById("projectPath").value = selectedPath;
    }
  } catch (error) {
    console.error("Error selecting folder:", error);
  }
}

async function saveProject(index) {
  const name = document.getElementById("projectName").value.trim();
  const path = document.getElementById("projectPath").value.trim();
  const repoInput = document.getElementById("projectRepo");
  const repo = repoInput ? repoInput.value.trim() : "";

  if (!name || !path) {
    await Neutralino.os.showMessageBox(
      "Error",
      "Please fill in all fields.",
      "OK",
      "ERROR"
    );
    return;
  }

  const newProject = { name, path, repo: repo || "" };

  if (index !== null) {
    projectList[index] = newProject;
  } else {
    projectList.push(newProject);
  }

  await saveProjects();
  closeModal();
  displayProjectList();
}

function closeModal() {
  const modal = document.querySelector(".modal");
  if (modal) {
    modal.remove();
  }
}

function onWindowClose() {
  Neutralino.app.exit();
}

async function initApp() {
  await loadProjects();
  displayProjectList();
}

Neutralino.init();

Neutralino.events.on("windowClose", onWindowClose);

initApp();
