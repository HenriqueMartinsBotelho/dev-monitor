# Release Checklist

Use this checklist when preparing a new release of Dev Monitor.

## Pre-Release

- [ ] **Update version numbers**

  - [ ] `package.json`
  - [ ] `neutralino.config.json`
  - [ ] Any hardcoded version references

- [ ] **Update documentation**

  - [ ] `CHANGELOG.md` with new features, fixes, and changes
  - [ ] `README.md` if there are new features or installation changes
  - [ ] Screenshots if UI has changed

- [ ] **Code quality checks**

  - [ ] All console.log statements reviewed (keep only essential ones in main.js)
  - [ ] No TODO comments in production code
  - [ ] Error handling is comprehensive
  - [ ] Code is formatted and clean

- [ ] **Testing**

  - [ ] Manual test on Linux
  - [ ] Manual test on Windows (if possible)
  - [ ] Manual test on macOS (if possible)
  - [ ] Test all core features:
    - [ ] Adding projects
    - [ ] Editing projects
    - [ ] Deleting projects
    - [ ] Opening projects in VS Code
    - [ ] Application startup and shutdown
    - [ ] Data persistence

- [ ] **Build verification**
  - [ ] `neu build --release` completes without errors
  - [ ] All target binaries are created
  - [ ] Binaries are executable and launch correctly

## Release Process

- [ ] **Version tag**

  - [ ] Create and push version tag: `git tag v1.x.x`
  - [ ] Or use the release script: `./scripts/release.sh`

- [ ] **GitHub Actions**

  - [ ] Verify CI/CD pipeline completes successfully
  - [ ] All binaries are built and uploaded to release
  - [ ] Checksums file is created

- [ ] **Release notes**
  - [ ] Review auto-generated release notes
  - [ ] Add any missing important changes
  - [ ] Include installation instructions
  - [ ] Add upgrade notes if applicable

## Post-Release

- [ ] **Verification**

  - [ ] Download and test binaries from GitHub release
  - [ ] Test installation scripts work with new release
  - [ ] Verify checksums match

- [ ] **Documentation updates**

  - [ ] Update any external documentation
  - [ ] Update download links if needed
  - [ ] Post announcement (social media, forums, etc.)

- [ ] **Monitor**
  - [ ] Watch for issues reported after release
  - [ ] Monitor download statistics
  - [ ] Check for user feedback

## Emergency Hotfix

If a critical issue is found after release:

- [ ] **Immediate action**

  - [ ] Create hotfix branch from release tag
  - [ ] Fix the critical issue
  - [ ] Test thoroughly
  - [ ] Create new patch release (e.g., 1.0.1)

- [ ] **Communication**
  - [ ] Update release notes with hotfix information
  - [ ] Notify users through appropriate channels
  - [ ] Consider creating GitHub issue to track the problem

## Release Versioning

Follow [Semantic Versioning](https://semver.org/):

- **MAJOR** (x.0.0): Breaking changes
- **MINOR** (0.x.0): New features, backwards compatible
- **PATCH** (0.0.x): Bug fixes, backwards compatible

## Automation

- Use `./scripts/release.sh` for streamlined releases
- GitHub Actions handle building and publishing
- Install scripts automatically fetch latest release
