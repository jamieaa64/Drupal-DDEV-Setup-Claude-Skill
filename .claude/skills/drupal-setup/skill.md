---
name: drupal-setup
description: Complete Drupal development lifecycle - setup, onboarding, and maintenance
---

# Drupal Project Setup & Development Skill

You are helping with Drupal project setup and ongoing development with best practices and organizational standards.

## Capabilities

This skill enables you to:
- **Set up NEW Drupal projects** - Drupal 11 Core or Drupal CMS (FAST - 30 seconds)
- **Set up EXISTING projects** - Onboard to projects created with this skill
- **Maintain & update** - Keep local environment in sync with team changes
- Configure with organizational best practices
- Work in both Claude Code CLI (local) and Web environments
- Generate comprehensive documentation

## Scenario Detection

**FIRST STEP: Detect the current scenario**

Check the current directory:

```bash
# Check for composer.json
if [ -f "composer.json" ]; then
  # Check if it's a Drupal project
  if grep -q "drupal" composer.json; then
    SCENARIO="EXISTING_PROJECT"
  else
    SCENARIO="NOT_DRUPAL"
  fi
else
  SCENARIO="NEW_PROJECT"
fi

# Check environment capabilities
if command -v ddev &> /dev/null; then
  ENVIRONMENT="LOCAL_CLI"
else
  ENVIRONMENT="WEB"
fi
```

## User Interaction Flow

### Scenario A: Existing Drupal Project

**Detected: composer.json with Drupal dependencies exists**

Ask the user what they want to do:
```
This looks like an existing Drupal project!

What would you like to do?
[1] Initial setup (first time working on this project)
[2] Update after pulling changes (composer install, config import, etc.)
[3] Reset local environment (fresh install)
[4] Create new project instead

Choice [1]:
```

**Option 1: Initial Setup** → Go to "Existing Project Setup" section below

**Option 2: Update** → Go to "Update Existing Project" section below

**Option 3: Reset** → Go to "Reset Local Environment" section below

**Option 4: New Project** → Create new project in a different directory

### Scenario B: New Drupal Project

**Detected: No composer.json in current directory**

Proceed with new project creation. Gather the following information:

1. **Project name** (e.g., "my-drupal-site")
   - Must be valid directory name
   - Will be used for Git repository name

2. **Drupal variant** (ALWAYS ask the user which variant):
   - `1` - Drupal CMS (Full-featured with recipes) [RECOMMENDED DEFAULT]
   - `2` - Drupal 11 Core (Standard)
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

## Existing Project Workflows

### Existing Project Setup (Initial)

**Use case**: First time working on a project that was created with this skill.

**IMPORTANT**: This workflow requires manual steps for authentication. Do NOT attempt to run git clone or ddev start automatically.

#### If DDEV Available (Local CLI - Recommended):

**Step 1: Show upfront summary and manual steps**

First, ask the user for the GitHub repository URL and desired project directory. Then immediately display:

```
Drupal Project Setup Plan
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 MANUAL STEPS (you):
   [ ] 1. Clone repository (authentication required)
   [ ] 2. Start DDEV (sudo password required)

🤖 AUTOMATED STEPS (me):
   [ ] 3. Verify project structure
   [ ] 4. Install Composer dependencies (~2-3 min)
   [ ] 5. Install Drupal
   [ ] 6. Export configuration (if needed)
   [ ] 7. Provide access details

Estimated time: ~5 minutes
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

┌─────────────────────────────────────────────────────────────┐
│ MANUAL STEPS REQUIRED (authentication needed)              │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ Please run these commands:                                  │
│                                                             │
│ 1. Clone repository:                                        │
│    cd <parent-directory>                                    │
│    git clone <github-url> <project-directory>              │
│    cd <project-directory>                                   │
│                                                             │
│ 2. Start DDEV (requires sudo):                             │
│    ddev start                                              │
│                                                             │
│ Type 'done' when complete                                   │
└─────────────────────────────────────────────────────────────┘
```

**Step 2: Wait for user confirmation**

Wait for the user to type 'done' before proceeding.

**Step 3: Verify DDEV is running**

```bash
# Check if DDEV is running
ddev describe
```

If this fails, prompt user to run `ddev start` again.

**Step 4: Verify project structure**
```bash
# Check for required files
ls -la composer.json .ddev/config.yaml config/sync
```

**Step 5: Install dependencies**
```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing Composer dependencies (~2-3 minutes)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
ddev composer install
```

**Step 6: Install Drupal (with empty config detection)**
```bash
# Check if config exists and has actual content
if [ -f "config/sync/core.extension.yml" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✓ Found existing configuration"
  echo "🔧 Installing Drupal from existing config..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  ddev drush site:install --existing-config --account-pass=admin -y
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ℹ No configuration found - performing fresh install"
  echo "🔧 Installing Drupal..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  ddev drush site:install --account-pass=admin -y
  ddev drush config:export -y
  echo "Note: Initial config exported. Consider committing config/sync/ directory."
fi
```

**Step 7: Clear cache and get site details**
```bash
ddev drush cache:rebuild

# Get the site URL
SITE_URL=$(ddev describe | grep -oP 'https://[^ ]+' | head -1)

# Get one-time login link
ULI=$(ddev drush uli)
```

**Step 8: Report success with actionable next steps**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Setup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌐 Your Site:
   URL: <SITE_URL>
   One-time login: <SITE_URL><ULI>

   Username: admin
   Password: admin

📝 Next Steps:

   Development workflow:
   • Make changes in Drupal UI
   • Export config: ddev drush cex -y
   • Commit: git add -A && git commit -m "message"
   • Push: git push

   Common commands:
   • ddev drush uli          # One-time login
   • ddev drush cr           # Clear cache
   • ddev launch             # Open in browser
   • ddev drush watchdog:show # View logs
   • ddev drush status       # Check Drupal status

📖 See README.md for more details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

#### If DDEV NOT Available (Web):

1. **Verify project structure**
   ```bash
   ls -la composer.json config/sync
   ```

2. **Install dependencies**
   ```bash
   composer install
   ```

3. **Report limitations**
   ```
   ✓ Dependencies installed
   ⚠ DDEV not available - cannot install Drupal in this environment

   To complete setup:
   1. Work on configuration files and custom code here
   2. Test locally with DDEV or on a server

   When working without DDEV:
   - Modify config YAML files in config/sync/
   - Create/modify custom modules in web/modules/custom/
   - Update composer.json for dependencies
   - Push changes to Git
   - Pull and test on a DDEV environment
   ```

### Update Existing Project

**Use case**: Pulled latest changes from Git, need to sync local environment.

#### If DDEV Available (Local CLI):

1. **Update dependencies**
   ```bash
   ddev composer install
   ```

2. **Import configuration**
   ```bash
   ddev drush config:import -y
   ```

3. **Run database updates**
   ```bash
   ddev drush updb -y
   ```

4. **Clear cache**
   ```bash
   ddev drush cache:rebuild
   ```

5. **Report what was updated**
   ```bash
   # Show config changes
   git diff HEAD~1 config/sync/ --name-only

   # Show composer changes
   git diff HEAD~1 composer.lock --name-only
   ```

6. **Report success**
   ```
   ✓ Environment updated successfully!

   Changes applied:
   - Dependencies updated (if composer.lock changed)
   - Configuration imported (if config/sync/ changed)
   - Database updates run
   - Cache cleared

   Your local environment is now in sync with the repository!
   ```

#### If DDEV NOT Available (Web):

1. **Update dependencies**
   ```bash
   composer install
   ```

2. **Report what changed**
   ```bash
   git diff HEAD~1 config/sync/ --name-only
   git diff HEAD~1 composer.json composer.lock
   ```

3. **Report limitations**
   ```
   ✓ Dependencies updated
   ⚠ Configuration and database updates require DDEV

   Configuration changes detected:
   [List changed config files]

   To complete update:
   - Import config: ddev drush config:import -y
   - Run updates: ddev drush updb -y
   - Clear cache: ddev drush cache:rebuild
   ```

### Reset Local Environment

**Use case**: Clean slate - reinstall Drupal from scratch with current config.

#### If DDEV Available (Local CLI):

1. **Stop and remove database**
   ```bash
   ddev stop
   ddev delete -y
   ```

2. **Restart DDEV**
   ```bash
   ddev start
   ```

3. **Install dependencies**
   ```bash
   ddev composer install
   ```

4. **Reinstall Drupal (with empty config detection)**
   ```bash
   # Check if config exists and has actual content
   if [ -f "config/sync/core.extension.yml" ]; then
     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     echo "✓ Found existing configuration"
     echo "🔧 Reinstalling Drupal from existing config..."
     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     ddev drush site:install --existing-config --account-pass=admin -y
   else
     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     echo "ℹ No configuration found - performing fresh install"
     echo "🔧 Installing Drupal..."
     echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
     ddev drush site:install --account-pass=admin -y
     ddev drush config:export -y
     echo "Note: Initial config exported. Consider committing config/sync/ directory."
   fi
   ```

5. **Clear cache and get site details**
   ```bash
   ddev drush cache:rebuild

   # Get the site URL
   SITE_URL=$(ddev describe | grep -oP 'https://[^ ]+' | head -1)

   # Get one-time login link
   ULI=$(ddev drush uli)
   ```

6. **Report success with actionable next steps**
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ✅ Environment Reset Complete!
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   🌐 Your Site:
      URL: <SITE_URL>
      One-time login: <SITE_URL><ULI>

      Username: admin
      Password: admin

   📝 Next Steps:

      • ddev launch             # Open in browser
      • ddev drush uli          # Get new one-time login
      • ddev drush status       # Check Drupal status

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

#### If DDEV NOT Available (Web):

Report that reset requires DDEV:
```
⚠ Environment reset requires DDEV (local development environment)

This operation needs to:
1. Drop and recreate the database
2. Reinstall Drupal
3. Import configuration

Please run this on a local machine with DDEV installed.
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
