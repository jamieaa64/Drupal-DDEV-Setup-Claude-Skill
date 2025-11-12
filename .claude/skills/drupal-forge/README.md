# Drupal Forge Project Setup & Development Skill

A comprehensive Claude Code skill for the complete Drupal development lifecycle on Drupal Forge/Dev Panel - from project creation to ongoing team collaboration. Works directly in the Drupal Forge terminal environment.

## Features

### For New Projects
- **Lightning-fast project setup** - Complete in ~30 seconds (Quick Mode)
- **Automated project setup** with Drupal 11 Core or Drupal CMS
- **Two setup modes**:
  - **Quick Mode** (default, recommended): Template-based, fast, production-aligned
  - **Full Mode** (optional, advanced): Live Drupal with SQLite for testing
- **Best practice configuration**:
  - Organization-specific settings.php (Forge-adapted)
  - Comprehensive .gitignore
  - Config-first approach with `config/sync` directory
- **Optional common modules**: Admin Toolbar, Gin, Pathauto, and more
- **Complete documentation**: README.md and CLAUDE.md generated
- **Git repository initialization** and push to GitHub

### For Existing Projects
- **Intelligent scenario detection** - Automatically detects existing Drupal projects
- **Live environment workflows** - Work directly on Drupal Forge sites
- **Initial setup automation** - Get new team members productive in minutes
- **Update workflows** - Sync environment after pulling changes (composer, config, database)
- **Status checks** - Monitor site health and configuration
- **Safety checks** - Confirmations for live environment operations

### Live Environment Safety
- ⚠️ **Safety warnings** for destructive operations
- **Status checks** before major changes
- **Confirmation prompts** for live site modifications
- **Clear impact warnings** for all operations

## Installation

This skill is designed to be used with Claude Code. Place it in your `.claude/skills/` directory:

```
.claude/skills/drupal-forge/
├── skill.md              # Main skill instructions
├── README.md             # This file
└── templates/            # Template files
    ├── settings.php
    ├── gitignore
    ├── README.md
    └── CLAUDE.md
```

## Usage

The skill automatically detects your scenario and provides appropriate workflows.

### New Project Setup

From an empty directory in Drupal Forge:

```
Create a new Drupal site called "my-awesome-site"
```

Or:

```
Use the drupal-forge skill to create a new Drupal project
```

Claude will guide you through:
1. Project name
2. Drupal variant (Core/CMS/Minimal)
3. Setup mode (Quick/Full)
4. GitHub repository setup
5. Common modules installation
6. Initial configuration

### Existing Project Setup

From a Drupal Forge project directory:

```
Set up this existing Drupal project
```

Or:

```
Use the drupal-forge skill
```

The skill will detect the existing project and offer:
1. **Initial setup** - First time working on this project
2. **Update** - Sync after pulling changes
3. **Status check** - Monitor site health
4. **New project** - Create new project instead

### Update After Changes

After pulling changes from Git:

```
Update my Drupal Forge environment
```

The skill will:
- Check current site status
- Install new composer dependencies
- Import configuration changes (with confirmation)
- Run database updates (with confirmation)
- Clear caches

### Working on Live Sites

⚠️ **Important**: All commands run directly on your live Drupal Forge site. Changes take effect immediately.

**Commands run directly** (no prefix needed):
- `drush status` (not `ddev drush status`)
- `composer install` (not `ddev composer install`)
- `drush config:import` (not `ddev drush config:import`)

## New Project Modes

### Quick Mode (Default, Recommended)

**The skill defaults to Quick Mode for optimal performance:**
- Creates project structure in ~30 seconds
- Installs Composer dependencies
- Generates all configuration files
- Prepares for deployment on Drupal Forge
- **Clean workspace** - No vendor bloat
- **Production-aligned** - Uses Forge database, not SQLite

**Result**: Ready-to-deploy project that can be installed on Drupal Forge in minutes.

**When to use**:
- ✅ Normal project setup (95% of use cases)
- ✅ When speed matters
- ✅ Production deployments

### Full Mode (Advanced, Optional)

**Only select Full Mode when explicitly needed:**
- Creates complete Drupal installation with SQLite
- Installs and configures Drupal live
- Enables and configures common modules
- Exports initial configuration
- **Takes 5-8 minutes**
- **Large workspace** - Thousands of vendor files

**Result**: Immediately usable Drupal site with exported configuration.

**When to use**:
- Testing complex configuration immediately
- Validating custom module behavior
- Explicit need for live Drupal instance

## What Gets Created

Every project includes:

### Directory Structure
```
project-name/
├── config/
│   └── sync/              # Drupal configuration (empty or populated)
├── private/               # Private files directory
├── vendor/                # Composer dependencies (gitignored)
├── web/
│   ├── core/             # Drupal core
│   ├── modules/
│   │   ├── contrib/      # Contributed modules
│   │   └── custom/       # Custom modules (empty initially)
│   ├── themes/
│   │   ├── contrib/      # Contributed themes
│   │   └── custom/       # Custom themes (empty initially)
│   └── sites/
│       └── default/
│           ├── settings.php
│           └── settings.local.php (empty)
├── .gitignore
├── composer.json
├── composer.lock
├── README.md
└── CLAUDE.md
```

### Configuration Files

**settings.php** includes:
- Config sync directory: `../config/sync`
- Private file path configuration
- Drupal Forge environment detection
- Production/development environment settings
- Local settings include

**.gitignore** excludes:
- Vendor directory
- Drupal core
- Contributed modules/themes
- User uploaded files
- IDE files
- Scaffold files

### Documentation

**README.md** includes:
- Quick start guide for Drupal Forge
- Project structure overview
- Development workflow
- Common commands (Drush, Composer)
- Testing & quality guidelines
- Troubleshooting section
- Live site safety reminders

**CLAUDE.md** includes:
- Build/lint/test commands
- Configuration management workflows
- Development commands
- Code style guidelines
- Best practices for Drupal development
- Live environment safety considerations

## Common Modules (Optional)

When enabled, installs and configures:
- **admin_toolbar** + **admin_toolbar_tools**: Enhanced admin menu
- **gin** + **gin_toolbar**: Modern admin theme
- **pathauto**: Automatic URL aliases
- **redirect**: URL redirect management
- **simple_sitemap**: XML sitemap generation
- **metatag**: Meta tag management

All modules are installed via Composer and enabled via Drush (in full install mode).

## Existing Project Workflows

### Workflow 1: Initial Setup (New Team Member)

**Scenario**: Just connected to a Drupal Forge project.

**Drupal Forge Terminal** (~2 minutes):
```bash
# Invoke skill
"Set up this existing Drupal project"
# Select: [1] Initial setup

# Skill automatically runs:
# ✓ composer install
# ✓ drush site:install --existing-config
# ✓ drush cache:rebuild
# ✓ drush uli (one-time login)
# Done! Site ready on Drupal Forge
```

### Workflow 2: Update After Pulling Changes

**Scenario**: Team member pushed changes, you need to sync.

**Drupal Forge Terminal** (~30 seconds):
```bash
git pull

# Invoke skill
"Update my Drupal Forge environment"
# Or: Select [2] Update after pulling changes

# Skill automatically runs:
# ✓ drush status (check current state)
# ✓ composer install (if composer.lock changed)
# ✓ drush config:status (show what will change)
# [Confirmation prompt]
# ✓ drush config:import -y (if config changed)
# ✓ drush updb -y (database updates)
# ✓ drush cache:rebuild
# Done! Environment synced with repository
```

### Workflow 3: Status Check

**Scenario**: Check site health and configuration status.

**Drupal Forge Terminal**:
```bash
# Invoke skill
"Check my Drupal site status"
# Or: Select [3] Check site status and health

# Skill automatically runs:
# ✓ drush status
# ✓ drush updb --status
# ✓ drush config:status
# ✓ drush watchdog:show --count=20
# ✓ php -v
# ✓ composer validate
# Report generated with findings
```

## Safety Features for Live Environments

### Confirmation Prompts

Before destructive operations, the skill will:
- Show what will change (`drush config:status`)
- Ask for confirmation
- Provide rollback instructions if needed

### Status Checks

Before major operations:
- Check current site status
- Verify configuration state
- Check for pending updates
- Review recent errors

### Safety Warnings

The skill provides warnings for:
- Configuration imports (may affect live site)
- Database updates (irreversible changes)
- Module operations (may cause downtime)
- Cache clears (brief performance impact)

## Next Steps After New Project Creation

### For Quick Mode (Default)

Complete the installation on Drupal Forge:

```bash
drush site:install --existing-config --account-pass=admin -y
```

Or without `--existing-config` for initial setup:
```bash
drush site:install --account-pass=admin -y
drush config:export -y
git add config/sync
git commit -m "Add initial configuration export"
git push
```

### For Full Mode (Advanced)

Your site is already installed! Access it through Drupal Forge:

```bash
drush uli  # Get one-time login link
```

The Drupal database and configuration are already set up.

## Customization

### Modifying Templates

Edit files in `templates/` directory:
- `settings.php` - Drupal settings (Forge-adapted)
- `gitignore` - Git ignore patterns
- `README.md` - Project documentation
- `CLAUDE.md` - Claude guidance

Templates support placeholders:
- `{{PROJECT_NAME}}` - Replaced with actual project name
- `{{GITHUB_URL}}` - Replaced with GitHub repository URL
- `{{DRUPAL_VARIANT}}` - Replaced with selected variant
- `{{CURRENT_DATE}}` - Replaced with current date

### Adding Default Modules

Edit `skill.md` and add to the common modules section:

```bash
composer require drupal/your_module --no-interaction
```

## Troubleshooting

### Skill doesn't load

Check that:
- Files are in `.claude/skills/drupal-forge/`
- `skill.md` exists and is readable
- You're in a Claude Code environment

### "SQLite not available" when selecting Full Mode

This is normal for some environments. The skill will automatically fall back to Quick Mode.

**Quick Mode is recommended anyway** for speed and efficiency. Only use Full Mode when you specifically need to test live Drupal.

### Composer install fails

Usually network issues. The skill will retry automatically.

If persistent:
- Check internet connectivity
- Try manually: `composer install --no-interaction`

### Git push fails

The skill uses exponential backoff retry (up to 4 attempts).

If still failing:
- Check GitHub repository exists
- Verify you have push permissions
- Check network connectivity

### Live site issues

If changes cause problems:
- Check `drush watchdog:show` for errors
- Review `drush status` for site health
- Consider rolling back via Git if needed
- Contact Drupal Forge support for infrastructure issues

## Differences from DDEV Skill

This skill is adapted for Drupal Forge:

| Feature | DDEV Skill | Drupal Forge Skill |
|---------|-----------|-------------------|
| Command prefix | `ddev` | None (direct) |
| Environment | Local Docker | Live Forge site |
| Safety checks | Basic | Enhanced (live site) |
| DDEV config | Included | Not needed |
| Settings.php | DDEV-specific | Forge-adapted |
| Workflow | Local → Deploy | Direct on Forge |

## Contributing

To improve this skill:
1. Test with different Drupal configurations on Forge
2. Add new template variations
3. Improve error handling
4. Enhance safety checks
5. Add support for Drupal 10

## Future Enhancements

Planned features:
- DevPanel CI/CD integration
- Automated backup workflows
- Multi-environment support (staging/production)
- Automated testing setup
- Custom module scaffolding
- Performance monitoring integration

## License

This skill is part of the Drupal DDEV Setup project and follows the same license.

## Resources

- [Drupal Documentation](https://www.drupal.org/docs)
- [Drupal Forge Documentation](https://forge.laravel.com/docs)
- [Drush Documentation](https://www.drush.org/)
- [Claude Code Skills](https://docs.anthropic.com/claude/docs/skills)
- [Drupal Composer Project](https://github.com/drupal/recommended-project)

---

Created with Claude Code for efficient Drupal development workflows on Drupal Forge.

