# Drupal Project Setup Skill

You are helping to set up a new Drupal project with best practices and organizational standards.

## Capabilities

This skill enables you to:
- Set up a new Drupal 11 or Drupal CMS project (FAST - 30 seconds)
- Configure the project with organizational best practices
- Create deployment-ready structure for DDEV or DevPanel
- Set up Git repository and push to GitHub
- Generate comprehensive documentation
- Optionally: Full Drupal installation for testing (SLOW - 5-8 minutes)

## Default Mode: Template-Based (Recommended)

**This skill defaults to TEMPLATE MODE for speed and efficiency:**
- Creates project structure in ~30 seconds
- No vendor bloat in workspace
- Production-aligned (uses MySQL via DDEV, not SQLite)
- Clean context window
- Ready for immediate deployment

**Full installation mode is available but should only be used when:**
- You need to test complex configuration immediately
- You're validating custom module behavior
- You explicitly need a live Drupal instance

## Mode Selection

The skill will ask which mode to use:
- **Quick Mode** (default, recommended): Template-based, fast setup
- **Full Mode** (advanced): Install live Drupal with SQLite (requires SQLite extension)

## User Interaction Flow

When this skill is invoked, gather the following information from the user:

1. **Project name** (e.g., "my-drupal-site")
   - Must be valid directory name
   - Will be used for Git repository name

2. **Drupal variant**:
   - `1` - Drupal 11 Core (Standard)
   - `2` - Drupal CMS (Full-featured with recipes)
   - `3` - Drupal 11 Minimal

3. **Setup mode** (default to Quick Mode):
   - Ask: "Setup mode: [1] Quick (recommended, ~30s) or [2] Full (advanced, ~5-8 min)? [1]"
   - Default: Quick Mode (template-based)
   - If user selects Full Mode:
     - Check SQLite availability: `php -r "exit(in_array('sqlite', PDO::getAvailableDrivers()) ? 0 : 1);"`
     - If SQLite NOT available: "SQLite not available. Falling back to Quick Mode."
     - If SQLite available: Proceed with Full Mode

4. **GitHub repository**:
   - Ask if they want to create new repo or use existing
   - If new: "Please create the repository on GitHub first, then provide the URL"
   - If existing: "Please provide the repository URL"

5. **Common modules** (if Drupal 11 Core selected):
   - Ask: "Include common contributed modules? (Admin Toolbar, Gin, Pathauto, etc.) [Y/n]"
   - Default: Yes

6. **Admin credentials** (only if Full Mode):
   - Username: default "admin"
   - Password: default "admin" (they can change later)

## Installation Process

### Quick Mode (Default, Recommended)

**Use this mode for normal project setup. It's FAST (~30 seconds) and creates a production-ready structure.**

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

8. **Create .gitignore** (use template from templates/gitignore)

9. **Create DDEV config** (use template from templates/ddev-config.yaml → .ddev/config.yaml)

10. **Create documentation**
    - README.md (use template from templates/README.md)
    - CLAUDE.md (use template from templates/CLAUDE.md)

11. **Initialize Git and push**
    ```bash
    git init
    git add .
    git commit -m "Initial Drupal project setup via Claude Code"
    git remote add origin <github-url>
    git branch -M main
    git push -u origin main
    ```

12. **Report what needs to be done next**:
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

### Full Mode (Advanced, Optional)

**Only use this mode when you need to test complex configuration or validate custom modules immediately.**
**Warning: This is SLOW (5-8 minutes) and creates large vendor directory in workspace.**

1. **Verify SQLite is available**
   ```bash
   php -r "exit(in_array('sqlite', PDO::getAvailableDrivers()) ? 0 : 1);"
   ```
   If this fails, fall back to Quick Mode.

2. **Create project directory**
   ```bash
   mkdir <project-name>
   cd <project-name>
   ```

3. **Initialize Composer project**
   ```bash
   # For Drupal 11
   composer create-project drupal/recommended-project:^11 . --no-interaction

   # For Drupal CMS
   composer create-project drupal/cms . --no-interaction
   ```

4. **Install Drush**
   ```bash
   composer require drush/drush --no-interaction
   ```

5. **Install common modules** (if requested)
   ```bash
   composer require drupal/admin_toolbar drupal/gin drupal/gin_toolbar \
     drupal/pathauto drupal/redirect drupal/simple_sitemap \
     drupal/metatag drupal/config_split --no-interaction
   ```

6. **Create directory structure**
   ```bash
   mkdir -p config/sync
   mkdir -p private
   ```

7. **Create settings.php** (use template from templates/settings.php)

8. **Create settings.local.php** (empty file for local overrides)

9. **Install Drupal with SQLite**
   ```bash
   ./vendor/bin/drush site:install standard \
     --db-url=sqlite://sites/default/files/.ht.sqlite \
     --site-name="<project-name>" \
     --account-name=admin \
     --account-pass=admin \
     --yes
   ```

10. **Enable common modules** (if installed)
    ```bash
    ./vendor/bin/drush en admin_toolbar admin_toolbar_tools gin gin_toolbar \
      pathauto redirect simple_sitemap metatag -y
    ```

11. **Set Gin as admin theme**
    ```bash
    ./vendor/bin/drush config:set system.theme admin gin -y
    ./vendor/bin/drush config:set node.settings use_admin_theme true -y
    ```

12. **Export initial configuration**
    ```bash
    ./vendor/bin/drush config:export -y
    ```

13. **Create .gitignore** (use template)

14. **Create DDEV config** (use template)

15. **Create documentation**
    - README.md (use template)
    - CLAUDE.md (use template)

16. **Initialize Git and push**
    ```bash
    git init
    git add .
    git commit -m "Initial Drupal project setup via Claude Code (Full Mode)"
    git remote add origin <github-url>
    git branch -M main
    git push -u origin main
    ```

17. **Report success**
    ```
    ✓ Drupal installed successfully!
    ✓ Configuration exported to config/sync/
    ✓ Pushed to GitHub: <github-url>

    Your site is ready. To access it locally with DDEV:
      git clone <github-url> <project-name>
      cd <project-name>
      ddev start
      ddev launch
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
