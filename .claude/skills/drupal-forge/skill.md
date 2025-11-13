---
name: drupal-forge
description: Complete Drupal development lifecycle on Drupal Forge/Dev Panel - setup, onboarding, and maintenance
---

# Drupal Forge Project Setup & Development Skill

You are helping with Drupal project setup and ongoing development on Drupal Forge/Dev Panel with best practices and organizational standards.

## Capabilities

This skill enables you to:
- **Set up NEW Drupal projects** - Drupal 11 Core or Drupal CMS (FAST - 30 seconds)
- **Set up EXISTING projects** - Onboard to projects on Drupal Forge
- **Maintain & update** - Keep environment in sync with team changes
- **Live environment management** - Work directly on live Drupal Forge sites
- Configure with organizational best practices
- Generate comprehensive documentation

## Important: Live Environment Safety

⚠️ **CRITICAL**: This skill works on LIVE Drupal Forge sites. Always:
- Confirm destructive operations before executing
- Check current environment status before making changes
- Provide clear warnings about live site impacts
- Use dry-run options when available
- Verify backups exist before major operations

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

# Check if we're in a Drupal Forge environment
# Drupal Forge provides direct terminal access - no prefix needed
ENVIRONMENT="FORGE"
```

## User Interaction Flow

### Scenario A: Existing Drupal Project

**Detected: composer.json with Drupal dependencies exists**

Ask the user what they want to do:
```
This looks like an existing Drupal project on Drupal Forge!

What would you like to do?
[1] Initial setup (first time working on this project)
[2] Update after pulling changes (composer install, config import, etc.)
[3] Check site status and health
[4] Create new project instead

Choice [1]:
```

**Option 1: Initial Setup** → Go to "Existing Project Setup" section below

**Option 2: Update** → Go to "Update Existing Project" section below

**Option 3: Status Check** → Go to "Site Status Check" section below

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

9. **Create documentation**
   - README.md (use template from templates/README.md)
   - CLAUDE.md (use template from templates/CLAUDE.md)

10. **Initialize Git and push**
    ```bash
    git init
    git add .
    git commit -m "Initial Drupal project setup via Claude Code on Drupal Forge"
    git remote add origin <github-url>
    git branch -M main
    git push -u origin main
    ```

11. **Generate DrupalPod URL for instant site creation**
    ```bash
    # Extract GitHub repo URL and construct DrupalPod URL
    GITHUB_REPO_URL="<github-url>"
    # Convert GitHub URL to branch format (e.g., https://github.com/user/repo -> https://github.com/user/repo/tree/main)
    DP_REPO_BRANCH="${GITHUB_REPO_URL%.git}/tree/main"
    
    # URL-encode the DP_REPO_BRANCH parameter
    ENCODED_REPO=$(echo "$DP_REPO_BRANCH" | sed 's/:/%3A/g; s/\//%2F/g; s/#/%23/g; s/?/%3F/g; s/&/%26/g')
    
    # Construct DrupalPod URL
    DRUPALPOD_URL="https://www.drupalforge.org/drupalpod?DP_APP_ROOT=/var/www/html&DP_WEB_ROOT=/var/www/html/web&DP_REPO_BRANCH=${ENCODED_REPO}&DP_IMAGE=drupalforge/drupalpod:latest"
    ```

12. **Report success with DrupalPod URL**:
    ```
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ✅ Project Created and Pushed to GitHub!
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    📦 Repository: <github-url>
    🌿 Branch: main

    🚀 Create Your Live Drupal Site:
    
    Click this link to instantly create a Drupal Forge site from your repository:
    
    <DRUPALPOD_URL>
    
    Or visit: https://www.drupalforge.org/drupalpod
    And use these parameters:
    - DP_APP_ROOT: /var/www/html
    - DP_WEB_ROOT: /var/www/html/web
    - DP_REPO_BRANCH: <DP_REPO_BRANCH>
    - DP_IMAGE: drupalforge/drupalpod:latest

    📝 Next Steps:
    
    After DrupalPod creates your site:
    1. Access your new Drupal Forge site
    2. Install Drupal (if not already installed):
       drush site:install --account-pass=admin -y
    
    3. Export configuration:
       drush config:export -y
    
    4. Commit the configuration:
       git add config/sync
       git commit -m "Add initial configuration export"
       git push

    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
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

14. **Create documentation**
    - README.md (use template)
    - CLAUDE.md (use template)

15. **Initialize Git and push**
    ```bash
    git init
    git add .
    git commit -m "Initial Drupal project setup via Claude Code on Drupal Forge (Full Mode)"
    git remote add origin <github-url>
    git branch -M main
    git push -u origin main
    ```

16. **Generate DrupalPod URL for instant site creation**
    ```bash
    # Extract GitHub repo URL and construct DrupalPod URL
    GITHUB_REPO_URL="<github-url>"
    # Convert GitHub URL to branch format (e.g., https://github.com/user/repo -> https://github.com/user/repo/tree/main)
    DP_REPO_BRANCH="${GITHUB_REPO_URL%.git}/tree/main"
    
    # URL-encode the DP_REPO_BRANCH parameter
    ENCODED_REPO=$(echo "$DP_REPO_BRANCH" | sed 's/:/%3A/g; s/\//%2F/g; s/#/%23/g; s/?/%3F/g; s/&/%26/g')
    
    # Construct DrupalPod URL
    DRUPALPOD_URL="https://www.drupalforge.org/drupalpod?DP_APP_ROOT=/var/www/html&DP_WEB_ROOT=/var/www/html/web&DP_REPO_BRANCH=${ENCODED_REPO}&DP_IMAGE=drupalforge/drupalpod:latest"
    ```

17. **Report success with DrupalPod URL**
    ```
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ✅ Drupal Installed and Pushed to GitHub!
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

    ✓ Drupal installed successfully!
    ✓ Configuration exported to config/sync/
    ✓ Pushed to GitHub: <github-url>

    📦 Repository: <github-url>
    🌿 Branch: main

    🚀 Create Your Live Drupal Site:
    
    Click this link to instantly create a Drupal Forge site from your repository:
    
    <DRUPALPOD_URL>
    
    Or visit: https://www.drupalforge.org/drupalpod
    And use these parameters:
    - DP_APP_ROOT: /var/www/html
    - DP_WEB_ROOT: /var/www/html/web
    - DP_REPO_BRANCH: <DP_REPO_BRANCH>
    - DP_IMAGE: drupalforge/drupalpod:latest

    Your site is ready! Access it through DrupalPod.
    ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
    ```

## Existing Project Workflows

### Existing Project Setup (Initial)

**Use case**: First time working on a project on Drupal Forge.

**IMPORTANT**: This workflow works directly in the Drupal Forge terminal environment.

**Step 1: Verify project structure**
```bash
# Check for required files
ls -la composer.json config/sync
```

**Step 2: Check site status**
```bash
# Verify Drupal is installed and accessible
drush status
```

**Step 3: Install dependencies**
```bash
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 Installing Composer dependencies (~2-3 minutes)..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
composer install
```

**Step 4: Install Drupal (with empty config detection)**
```bash
# Check if config exists and has actual content
if [ -f "config/sync/core.extension.yml" ]; then
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "✓ Found existing configuration"
  echo "🔧 Installing Drupal from existing config..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  drush site:install --existing-config --account-pass=admin -y
else
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "ℹ No configuration found - performing fresh install"
  echo "🔧 Installing Drupal..."
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  drush site:install --account-pass=admin -y
  drush config:export -y
  echo "Note: Initial config exported. Consider committing config/sync/ directory."
fi
```

**Step 5: Clear cache and get site details**
```bash
drush cache:rebuild

# Get the site URL (from drush status)
SITE_URL=$(drush status --field=uri)

# Get one-time login link
ULI=$(drush uli)
```

**Step 6: Report success with actionable next steps**
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ Setup Complete!
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🌐 Your Site:
   URL: <SITE_URL>
   One-time login: <ULI>

   Username: admin
   Password: admin

📝 Next Steps:

   Development workflow:
   • Make changes in Drupal UI or via code
   • Export config: drush cex -y
   • Commit: git add -A && git commit -m "message"
   • Push: git push

   Common commands:
   • drush uli          # One-time login
   • drush cr           # Clear cache
   • drush status       # Check Drupal status
   • drush watchdog:show # View logs

⚠️  Remember: You're working on a LIVE site. Always:
   • Test changes carefully
   • Export config before major changes
   • Commit frequently
   • Consider backups before destructive operations

📖 See README.md for more details
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Update Existing Project

**Use case**: Pulled latest changes from Git, need to sync environment.

**⚠️ SAFETY CHECK**: Before proceeding, confirm this is safe to run on live site.

1. **Check current status**
   ```bash
   drush status
   ```

2. **Update dependencies**
   ```bash
   composer install
   ```

3. **Import configuration**
   ```bash
   # Show what will be imported
   drush config:status
   
   # Ask for confirmation if there are changes
   # Then import
   drush config:import -y
   ```

4. **Run database updates**
   ```bash
   drush updb -y
   ```

5. **Clear cache**
   ```bash
   drush cache:rebuild
   ```

6. **Report what was updated**
   ```bash
   # Show config changes
   git diff HEAD~1 config/sync/ --name-only

   # Show composer changes
   git diff HEAD~1 composer.lock --name-only
   ```

7. **Report success**
   ```
   ✓ Environment updated successfully!

   Changes applied:
   - Dependencies updated (if composer.lock changed)
   - Configuration imported (if config/sync/ changed)
   - Database updates run
   - Cache cleared

   Your Drupal Forge environment is now in sync with the repository!
   ```

### Site Status Check

**Use case**: Check the health and status of the Drupal Forge site.

1. **Check Drupal status**
   ```bash
   drush status
   ```

2. **Check for pending updates**
   ```bash
   drush updb --status
   ```

3. **Check configuration status**
   ```bash
   drush config:status
   ```

4. **Check recent logs**
   ```bash
   drush watchdog:show --count=20
   ```

5. **Check PHP version**
   ```bash
   php -v
   ```

6. **Check Composer status**
   ```bash
   composer validate
   ```

7. **Report findings**
   ```
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   📊 Site Status Report
   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

   Drupal Status: [from drush status]
   PHP Version: [from php -v]
   Pending Updates: [from drush updb --status]
   Config Changes: [from drush config:status]
   Recent Errors: [from watchdog:show]

   ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
   ```

## Safety Checks for Live Environment

**ALWAYS perform these checks before destructive operations:**

1. **Before config import:**
   ```bash
   # Show what will change
   drush config:status
   # Ask user to confirm
   ```

2. **Before database updates:**
   ```bash
   # Check what updates will run
   drush updb --status
   # Ask user to confirm
   ```

3. **Before module uninstall:**
   ```bash
   # Check dependencies
   drush pm:list --status=enabled --filter=<module>
   # Warn about data loss
   ```

4. **Before cache clear:**
   - Usually safe, but warn if site is high-traffic
   - Consider doing during low-traffic periods

5. **Before composer update:**
   ```bash
   # Show what will update
   composer outdated
   # Ask user to confirm
   ```

## Templates

All template files are located in the `templates/` subdirectory:
- `settings.php` - Organization-specific Drupal settings (Forge-adapted)
- `gitignore` - Comprehensive .gitignore for Drupal
- `README.md` - Project documentation template (Forge-adapted)
- `CLAUDE.md` - Claude Code guidance template (Forge-adapted)

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
- If live site operations fail, provide rollback instructions

## Success Criteria

A successful setup includes:
- ✓ All files created without errors
- ✓ Composer dependencies installed
- ✓ Configuration files properly structured
- ✓ Git repository initialized and pushed
- ✓ Documentation complete and accurate
- ✓ (If full install) Drupal installed and initial config exported
- ✓ Site accessible and functional on Drupal Forge

## Post-Setup Guidance

After setup, inform the user:
- How to access their site on Drupal Forge
- Next steps for development
- How to work with configuration management
- Common drush commands (reference CLAUDE.md)
- Safety reminders about working on live sites

## Notes

- This skill creates production-ready projects on Drupal Forge
- All settings follow organizational best practices from CurrentWorkflow.md
- Config-first approach: changes should be made via config files when possible
- **Live environment**: Always consider the impact of changes on live site
- Commands run directly in Drupal Forge terminal (no `ddev` prefix needed)
- Changes made via Claude Code will immediately reflect on the live Drupal site

