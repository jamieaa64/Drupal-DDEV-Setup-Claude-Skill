# Drupal Project Setup Skill

A comprehensive Claude Code skill for setting up production-ready Drupal 11 and Drupal CMS projects with organizational best practices.

## Features

- **Automated project setup** with Drupal 11 Core or Drupal CMS
- **Intelligent installation modes**:
  - Full installation with SQLite (if available in environment)
  - Template-based setup (fallback for restricted environments)
- **Best practice configuration**:
  - Organization-specific settings.php
  - Comprehensive .gitignore
  - DDEV configuration for team development
  - Config-first approach with `config/sync` directory
- **Optional common modules**: Admin Toolbar, Gin, Pathauto, and more
- **Complete documentation**: README.md and CLAUDE.md generated
- **Git repository initialization** and push to GitHub

## Installation

This skill is designed to be used with Claude Code. Place it in your `.claude/skills/` directory:

```
.claude/skills/drupal-setup/
├── skill.md              # Main skill instructions
├── init.sh               # Initialization script (attempts SQLite install)
├── README.md             # This file
└── templates/            # Template files
    ├── settings.php
    ├── gitignore
    ├── ddev-config.yaml
    ├── README.md
    └── CLAUDE.md
```

## Usage

Invoke the skill in Claude Code:

```
Use the drupal-setup skill to create a new Drupal project
```

Or simply:

```
Create a new Drupal site called "my-awesome-site"
```

Claude will guide you through:
1. Project name
2. Drupal variant (Core/CMS/Minimal)
3. GitHub repository setup
4. Common modules installation
5. Initial configuration

## Installation Modes

### Full Installation Mode (SQLite Available)

When PHP SQLite extension is available, the skill will:
- Create complete Drupal installation
- Install Drupal using SQLite database
- Enable and configure common modules
- Export initial configuration to `config/sync/`
- Create fully functional Drupal site

**Result**: Immediately usable Drupal site with exported configuration.

### Template Mode (SQLite Not Available)

When SQLite is not available (common in restricted environments), the skill will:
- Create project structure
- Install Composer dependencies
- Generate configuration files
- Prepare for deployment

**Result**: Ready-to-deploy project that can be installed locally with DDEV.

## Environment Detection

The skill automatically detects capabilities by checking:

```bash
php -r "echo in_array('sqlite', PDO::getAvailableDrivers()) ? 'available' : 'not available';"
```

- **SQLite available** → Full installation mode
- **SQLite not available** → Template mode

No user intervention required!

## What Gets Created

Every project includes:

### Directory Structure
```
project-name/
├── .ddev/
│   └── config.yaml        # DDEV configuration
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
- DDEV-specific settings
- Verbose error logging for development
- Local settings include

**DDEV config** includes:
- Drupal 11 project type
- PHP 8.3
- MySQL 8.0
- Nginx web server
- Post-start hook for `composer install`

**.gitignore** excludes:
- Vendor directory
- Drupal core
- Contributed modules/themes
- User uploaded files
- IDE files
- DDEV private files
- Scaffold files

### Documentation

**README.md** includes:
- Quick start guide
- Project structure overview
- Development workflow
- Common commands (DDEV, Drush, Composer)
- Testing & quality guidelines
- Troubleshooting section

**CLAUDE.md** includes:
- Build/lint/test commands
- Configuration management workflows
- Development commands
- Code style guidelines
- Best practices for Drupal development

## Common Modules (Optional)

When enabled, installs and configures:
- **admin_toolbar** + **admin_toolbar_tools**: Enhanced admin menu
- **gin** + **gin_toolbar**: Modern admin theme
- **pathauto**: Automatic URL aliases
- **redirect**: URL redirect management
- **simple_sitemap**: XML sitemap generation
- **metatag**: Meta tag management

All modules are installed via Composer and enabled via Drush (in full install mode).

## Next Steps After Creation

### For Full Installation Mode

Your site is ready! Just:

```bash
git clone <repo-url> project-name
cd project-name
# Site is already installed, just start developing!
```

To run locally with DDEV:
```bash
ddev start
ddev launch
```

### For Template Mode

Complete the installation locally:

```bash
git clone <repo-url> project-name
cd project-name
ddev start
ddev drush site:install --existing-config --account-pass=admin -y
```

Or without `--existing-config` for initial setup:
```bash
ddev drush site:install --account-pass=admin -y
ddev drush config:export -y
git add config/sync
git commit -m "Add initial configuration export"
git push
```

## Customization

### Modifying Templates

Edit files in `templates/` directory:
- `settings.php` - Drupal settings
- `gitignore` - Git ignore patterns
- `ddev-config.yaml` - DDEV configuration
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
- Files are in `.claude/skills/drupal-setup/`
- `skill.md` exists and is readable
- You're in a Claude Code environment

### "SQLite not available" message

This is normal for security-restricted environments. The skill will use template mode automatically.

To enable full installation mode, the environment needs:
- PHP PDO SQLite extension
- Permission to install system packages

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

## Contributing

To improve this skill:
1. Test with different Drupal configurations
2. Add new template variations
3. Improve error handling
4. Add support for Drupal 10

## Future Enhancements

Planned features:
- DevPanel CI/CD integration
- Drupal.org issue workflow support
- GitLab MR creation
- Multi-environment configuration
- Automated testing setup
- Custom module scaffolding

## License

This skill is part of the Drupal DDEV Setup project and follows the same license.

## Resources

- [Drupal Documentation](https://www.drupal.org/docs)
- [DDEV Documentation](https://ddev.readthedocs.io/)
- [Claude Code Skills](https://docs.anthropic.com/claude/docs/skills)
- [Drupal Composer Project](https://github.com/drupal/recommended-project)

---

Created with Claude Code for efficient Drupal development workflows.
