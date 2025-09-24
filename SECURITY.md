# Security Policy

## Supported Versions

We release patches for security vulnerabilities. Which versions are eligible for receiving such patches depends on the CVSS v3.0 Rating:

| Version | Supported          |
| ------- | ------------------ |
| 1.x.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability within Dev Monitor, please send an e-mail to [your-email@example.com]. All security vulnerabilities will be promptly addressed.

Please do not publicly disclose the issue until it has been addressed by our team.

### What to include in your report

- A description of the vulnerability
- Steps to reproduce the issue
- Possible impact of the vulnerability
- Any suggested fixes (if you have them)

### What to expect

- We will respond to your email within 48 hours
- We will provide a more detailed response within 7 days indicating the next steps
- We will notify you when the vulnerability has been fixed
- We may ask for additional information or guidance

## Security Best Practices

When using Dev Monitor:

1. **Keep it updated**: Always use the latest version
2. **Verify downloads**: Check file hashes when downloading releases
3. **Source code**: Only download from official sources (GitHub releases)
4. **Permissions**: Dev Monitor only needs access to:
   - File system (to read project paths)
   - OS commands (to launch VS Code)
   - Local storage (to save your project list)

## Scope

This security policy applies to:

- The Dev Monitor application
- Installation scripts
- Documentation and examples

This security policy does not apply to:

- Third-party dependencies (report to their respective maintainers)
- User configurations or project files managed by Dev Monitor
