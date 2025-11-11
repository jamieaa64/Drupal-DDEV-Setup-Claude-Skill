# Drupal Project Setup Skill

You are helping to set up a new Drupal project with best practices and organizational standards.

## Capabilities

This skill enables you to:
- Set up a new Drupal 11 or Drupal CMS project
- Configure the project with organizational best practices
- Attempt full Drupal installation using SQLite (if available)
- Fall back to template-based approach if SQLite unavailable
- Set up Git repository and push to GitHub
- Generate comprehensive documentation

## Prerequisites Check

Before starting, check if SQLite support is available:

```bash
php -r "echo in_array('sqlite', PDO::getAvailableDrivers()) ? 'SQLite available' : 'SQLite NOT available';"
```

If SQLite is available, you can do a **full installation** with live Drupal.
If not available, use the **template-based approach** (prepare files for later deployment).

## User Interaction Flow

When this skill is invoked, gather the following information from the user:

1. **Project name** (e.g., "my-drupal-site")
   - Must be valid directory name
   - Will be used for Git repository name

2. **Drupal variant**:
   - `1` - Drupal 11 Core (Standard)
   - `2` - Drupal CMS (Full-featured with recipes)
   - `3` - Drupal 11 Minimal

3. **Installation mode** (auto-detect based on SQLite availability):
   - If SQLite available: "Full installation (with live Drupal)"
   - If SQLite NOT available: "Template mode (prepare for deployment)"

4. **GitHub repository**:
   - Ask if they want to create new repo or use existing
   - If new: "Please create the repository on GitHub first, then provide the URL"
   - If existing: "Please provide the repository URL"

5. **Common modules** (if Drupal 11 Core selected):
   - Ask: "Include common contributed modules? (Admin Toolbar, Gin, Pathauto, etc.) [Y/n]"
   - Default: Yes

6. **Admin credentials** (if full installation):
   - Username: default "admin"
   - Password: default "admin" (they can change later)

## Installation Process

### Full Installation Mode (SQLite Available)

1. **Create project directory**
   ```bash
   mkdir <project-name>
   cd <project-name>
   ```

2. **Initialize Composer project**
   ```bash
   # For Drupal 11
   composer create-project drupal/recommended-project:^11 . --no-interaction

   # For Drupal CMS
   composer create-project drupal/cms . --no-interaction
   ```

3. **Install Drush**
   ```bash
   composer require drush/drush --no-interaction
   ```

4. **Install common modules** (if requested)
   ```bash
   composer require drupal/admin_toolbar drupal/gin drupal/gin_toolbar \
     drupal/pathauto drupal/redirect drupal/simple_sitemap \
     drupal/metatag drupal/config_split --no-interaction
   ```

5. **Create directory structure**
   ```bash
   mkdir -p config/sync
   mkdir -p private
   ```

6. **Create settings.php** (use template from templates/settings.php)

7. **Create settings.local.php** (empty file for local overrides)

8. **Install Drupal with SQLite**
   ```bash
   ./vendor/bin/drush site:install standard \
     --db-url=sqlite://sites/default/files/.ht.sqlite \
     --site-name="<project-name>" \
     --account-name=admin \
     --account-pass=admin \
     --yes
   ```

9. **Enable common modules** (if installed)
   ```bash
   ./vendor/bin/drush en admin_toolbar admin_toolbar_tools gin gin_toolbar \
     pathauto redirect simple_sitemap metatag -y
   ```

10. **Set Gin as admin theme**
    ```bash
    ./vendor/bin/drush config:set system.theme admin gin -y
    ./vendor/bin/drush config:set node.settings use_admin_theme true -y
    ```

11. **Export initial configuration**
    ```bash
    ./vendor/bin/drush config:export -y
    ```

12. **Create .gitignore** (use template)

13. **Create DDEV config** (use template)

14. **Create documentation**
    - README.md (use template)
    - CLAUDE.md (use template)

15. **Initialize Git and push**
    ```bash
    git init
    git add .
    git commit -m "Initial Drupal project setup via Claude Code"
    git remote add origin <github-url>
    git branch -M main
    git push -u origin main
    ```

16. **Report success with next steps**

### Template Mode (SQLite NOT Available)

1. **Create project directory**
   ```bash
   mkdir <project-name>
   cd <project-name>
   ```

2. **Initialize Composer project** (same as above)

3. **Install Drush and modules** (same as above)

4. **Create directory structure** (same as above)

5. **Create configuration files** (same as above)

6. **Create .gitignore, DDEV config, documentation** (same as above)

7. **Initialize Git and push** (same as above)

8. **Report what needs to be done next**:
   ```
   Project structure created! To complete the setup:

   1. Clone the repository locally:
      git clone <github-url> <project-name>
      cd <project-name>

   2. Start DDEV:
      ddev start

   3. Install Drupal:
      ddev drush site:install --account-pass=admin -y

   4. Export configuration:
      ddev drush config:export -y

   5. Commit the configuration:
      git add config/sync
      git commit -m "Add initial configuration export"
      git push
   ```

## Templates

All template files are located in the `templates/` subdirectory:
- `settings.php` - Organization-specific Drupal settings
- `gitignore` - Comprehensive .gitignore for Drupal
- `ddev-config.yaml` - DDEV configuration template
- `README.md` - Project documentation template
- `CLAUDE.md` - Claude Code guidance template

When using templates:
1. Read the template file
2. Replace placeholders:
   - `{{PROJECT_NAME}}` - Replace with actual project name
   - `{{GITHUB_URL}}` - Replace with GitHub repository URL
   - `{{DRUPAL_VARIANT}}` - Replace with selected variant
   - `{{CURRENT_DATE}}` - Replace with current date
3. Write the processed template to the target location

## Error Handling

- If Composer fails, check network connectivity and retry
- If Git push fails, use exponential backoff retry (up to 4 times)
- If drush commands fail, provide clear error messages and suggest fixes
- If SQLite installation fails mid-way, fall back to template mode

## Success Criteria

A successful setup includes:
- ✓ All files created without errors
- ✓ Composer dependencies installed
- ✓ Configuration files properly structured
- ✓ Git repository initialized and pushed
- ✓ Documentation complete and accurate
- ✓ (If full install) Drupal installed and initial config exported

## Post-Setup Guidance

After setup, inform the user:
- How to access their site (if full install)
- Next steps for development
- How to work with configuration management
- Common drush commands (reference CLAUDE.md)

## Notes

- This skill creates production-ready projects, not quick demos
- All settings follow organizational best practices from CurrentWorkflow.md
- Config-first approach: changes should be made via config files when possible
- DDEV config is included even for full installs (for team collaboration)
