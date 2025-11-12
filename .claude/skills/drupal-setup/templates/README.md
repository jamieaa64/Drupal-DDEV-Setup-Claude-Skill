# {{PROJECT_NAME}}

A Drupal {{DRUPAL_VARIANT}} project created on {{CURRENT_DATE}} using Claude Code.

## Quick Start

### Local Development with DDEV

1. **Prerequisites**:
   - [DDEV](https://ddev.readthedocs.io/en/stable/#installation) installed
   - [Docker](https://docs.docker.com/get-docker/) installed and running

2. **Clone and start**:
   ```bash
   git clone {{GITHUB_URL}} {{PROJECT_NAME}}
   cd {{PROJECT_NAME}}
   ddev start
   ```

3. **Install Drupal** (if not already installed):
   ```bash
   ddev drush site:install --existing-config --account-pass=admin -y
   ```

4. **Access the site**:
   ```bash
   ddev launch
   ```

5. **Log in as admin**:
   ```bash
   ddev launch $(ddev drush uli)
   ```

## Project Structure

```
{{PROJECT_NAME}}/
├── .ddev/              # DDEV configuration
├── config/sync/        # Drupal configuration files
├── private/            # Private files (not web accessible)
├── vendor/             # Composer dependencies (not in Git)
├── web/                # Drupal web root
│   ├── core/          # Drupal core (not in Git)
│   ├── modules/       # Contributed and custom modules
│   ├── themes/        # Contributed and custom themes
│   └── sites/         # Site-specific files
├── composer.json       # PHP dependencies
└── README.md          # This file
```

## Development Workflow

### Making Configuration Changes

1. Make changes in the Drupal UI or via code
2. Export configuration:
   ```bash
   ddev drush config:export -y
   ```
3. Review changes:
   ```bash
   git diff config/sync
   ```
4. Commit and push:
   ```bash
   git add config/sync
   git commit -m "Description of config changes"
   git push
   ```

### Installing Modules

1. Add via Composer:
   ```bash
   ddev composer require drupal/module_name
   ```
2. Enable the module:
   ```bash
   ddev drush en module_name -y
   ```
3. Export configuration:
   ```bash
   ddev drush config:export -y
   ```
4. Commit changes to `composer.json`, `composer.lock`, and `config/sync`

### Pulling Changes

When other developers push changes:

```bash
git pull
ddev composer install
ddev drush config:import -y
ddev drush updb -y
ddev drush cache:rebuild
```

## Common Commands

### DDEV Commands

```bash
ddev start              # Start the project
ddev stop               # Stop the project
ddev restart            # Restart the project
ddev ssh                # SSH into the container
ddev logs               # View logs
ddev describe           # Show project info
```

### Drush Commands

```bash
ddev drush status                    # Show Drupal status
ddev drush cache:rebuild             # Clear all caches
ddev drush config:export             # Export configuration
ddev drush config:import             # Import configuration
ddev drush updb                      # Run database updates
ddev drush user:login                # Generate one-time login link
ddev drush watchdog:show             # Show recent log messages
```

### Composer Commands

```bash
ddev composer install                # Install dependencies
ddev composer update                 # Update dependencies
ddev composer require <package>      # Add a package
ddev composer remove <package>       # Remove a package
```

## Testing & Quality

### Code Standards

```bash
ddev exec phpcs --standard=Drupal web/modules/custom
ddev exec phpcs --standard=DrupalPractice web/modules/custom
```

### Static Analysis

```bash
ddev exec phpstan analyse web/modules/custom
```

### Unit Tests

```bash
ddev exec phpunit -c web/core/phpunit.xml.dist web/modules/custom
```

## Troubleshooting

### "Database connection error"
```bash
ddev restart
```

### "Permission denied" errors
```bash
ddev ssh
chmod -R 755 web/sites/default/files
```

### Configuration import fails
```bash
# Check for config differences
ddev drush config:status

# Force import
ddev drush config:import --partial -y
```

### Clear all caches
```bash
ddev drush cache:rebuild
```

## Additional Resources

- [Drupal Documentation](https://www.drupal.org/documentation)
- [DDEV Documentation](https://ddev.readthedocs.io/)
- [Drush Documentation](https://www.drush.org/)

## Working with Claude Code

See `CLAUDE.md` for guidance on using Claude Code with this project.

## License

[Specify your license here]

## Maintainers

- [Your name/organization]
