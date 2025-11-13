# {{PROJECT_NAME}}

A Drupal {{DRUPAL_VARIANT}} project created on {{CURRENT_DATE}} using Claude Code on Drupal Forge.

## Quick Start

### Working on Drupal Forge

This project is hosted on Drupal Forge/Dev Panel. You can access it directly through the Forge terminal environment.

1. **Access the site**:
   - Open your Drupal Forge project
   - Use the terminal provided in the Forge interface
   - All commands run directly (no prefix needed)

2. **Install Drupal** (if not already installed):
   ```bash
   composer install
   drush site:install --existing-config --account-pass=admin -y
   ```

3. **Access the site**:
   - Your site URL is provided by Drupal Forge
   - Log in as admin with the password you set

4. **Get one-time login link**:
   ```bash
   drush uli
   ```

## Project Structure

```
{{PROJECT_NAME}}/
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
   drush config:export -y
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
   composer require drupal/module_name
   ```
2. Enable the module:
   ```bash
   drush en module_name -y
   ```
3. Export configuration:
   ```bash
   drush config:export -y
   ```
4. Commit changes to `composer.json`, `composer.lock`, and `config/sync`

### Pulling Changes

When other developers push changes:

```bash
git pull
composer install
drush config:import -y
drush updb -y
drush cache:rebuild
```

## Common Commands

### Drush Commands

```bash
drush status                    # Show Drupal status
drush cache:rebuild            # Clear all caches
drush config:export            # Export configuration
drush config:import            # Import configuration
drush updb                     # Run database updates
drush user:login               # Generate one-time login link
drush watchdog:show            # Show recent log messages
drush uli                      # Get one-time login link
```

### Composer Commands

```bash
composer install               # Install dependencies
composer update                # Update dependencies
composer require <package>     # Add a package
composer remove <package>      # Remove a package
```

## Working on Drupal Forge

### Important Notes

⚠️ **You're working on a LIVE site!**

- Changes made here will immediately affect your live Drupal site
- Always test changes carefully
- Export configuration before making major changes
- Commit frequently to preserve your work
- Consider backups before destructive operations

### Environment Access

- **Terminal**: Access provided directly in Drupal Forge interface
- **Commands**: Run directly without any prefix (no `ddev` needed)
- **File Access**: Full file system access through Forge interface
- **Database**: Managed by Drupal Forge (no direct access needed for most operations)

## Testing & Quality

### Code Standards

```bash
phpcs --standard=Drupal web/modules/custom
phpcs --standard=DrupalPractice web/modules/custom
```

### Static Analysis

```bash
phpstan analyse web/modules/custom
```

### Unit Tests

```bash
phpunit -c web/core/phpunit.xml.dist web/modules/custom
```

## Troubleshooting

### "Database connection error"
- Check Drupal Forge status dashboard
- Verify database credentials in settings.php
- Contact Drupal Forge support if issues persist

### "Permission denied" errors
```bash
chmod -R 755 web/sites/default/files
```

### Configuration import fails
```bash
# Check for config differences
drush config:status

# Force import
drush config:import --partial -y
```

### Clear all caches
```bash
drush cache:rebuild
```

## Additional Resources

- [Drupal Documentation](https://www.drupal.org/documentation)
- [Drush Documentation](https://www.drush.org/)
- [Drupal Forge Documentation](https://forge.laravel.com/docs)

## Working with Claude Code

See `CLAUDE.md` for guidance on using Claude Code with this project.

## License

[Specify your license here]

## Maintainers

- [Your name/organization]

