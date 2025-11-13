# Claude Guidance for {{PROJECT_NAME}}

This is a Drupal {{DRUPAL_VARIANT}} project hosted on Drupal Forge. Follow these guidelines when working on this codebase.

## Important: Live Environment

⚠️ **CRITICAL**: This project runs on Drupal Forge, a LIVE production environment. Always:
- Confirm destructive operations before executing
- Test changes carefully
- Export configuration before major changes
- Consider backups before database operations

## Build/Lint/Test Commands

- **Build**: `composer install`
- **Install**: `drush site:install --existing-config`
- **Lint**:
  - If the project has a `/phpcs.xml` or `/phpcs.xml.dist`: `phpcs`
  - Otherwise: `phpcs --standard=Drupal web/modules/custom`
- **Static Analysis**:
  - If the project has a `/phpstan.neon` or `phpstan.neon.dist`: `phpstan`
  - Otherwise: `phpstan analyse --level 6 web/modules/custom`
- **Run Single Test**:
  - If the project has a `/phpunit.xml` or `/phpunit.xml.dist`: `phpunit --filter Test path/to/test`
  - Otherwise: `phpunit -c web/core/phpunit.xml.dist --filter Test path/to/test`

## Configuration Management

- **Export configuration**: `drush config:export -y`
- **Import configuration**: `drush config:import -y`
- **Import partial configuration**: `drush config:import --partial --source=web/modules/custom/mymodule/config/install`
- **Verify configuration**: `drush config:export --diff`
- **View config details**: `drush config:get [config.name]`
- **Change config value**: `drush config:set [config.name] [key] [value]`
- **Install from config**: `drush site:install --existing-config`
- **Get the config sync directory**: `drush status --field=config-sync`

## Development Commands

- **List available modules**: `drush pm:list [--filter=FILTER]`
- **List enabled modules**: `drush pm:list --status=enabled [--filter=FILTER]`
- **Download a Drupal module**: `composer require drupal/[module_name]`
- **Install a Drupal module**: `drush en [module_name]`
- **Clear cache**: `drush cache:rebuild`
- **Inspect logs**: `drush watchdog:show --count=20`
- **Delete logs**: `drush watchdog:delete all`
- **Run cron**: `drush cron`
- **Show status**: `drush status`

## Entity Management

- **View fields on entity**: `drush field:info [entity_type] [bundle]`

## Best Practices

- If making configuration changes to a module's config/install, these should also be applied to active configuration
- Always export configuration after making changes: `drush config:export -y`
- Check configuration diffs before importing
- If a module provides install configuration, this should be done via `config/install` not `hook_install`
- Attempt to use contrib modules for functionality, rather than replicating in a custom module
- If phpcs/phpstan/phpunit are not available, they should be installed by `composer require --dev drupal/core-dev`

## Code Style Guidelines

- **PHP Version**: 8.3+ compatibility required
- **Coding Standard**: Drupal coding standards
- **Indentation**: 2 spaces, no tabs
- **Line Length**: 120 characters maximum
- **Comment**: 80 characters maximum line length, always finishing with a full stop
- **Namespaces**: PSR-4 standard, `Drupal\{module_name}`
- **Types**: Strict typing with PHP 8 features, union types when needed
- **Documentation**: Required for classes and methods with PHPDoc
- **Class Structure**: Properties before methods, dependency injection via constructor
- **Naming**: CamelCase for classes/methods/properties, snake_case for variables, ALL_CAPS for constants
- **Error Handling**: Specific exception types with `@throws` annotations, meaningful messages
- **Plugins**: Follow Drupal plugin conventions with attributes for definition

## Working on Drupal Forge

This project uses Drupal Forge for hosting. All commands run directly in the Forge terminal:

- **No prefix needed**: Commands run directly (no `ddev` prefix)
- **Direct access**: Full terminal access through Drupal Forge interface
- **Live environment**: Changes immediately affect the live site
- **File system**: Full access to project files
- **Database**: Managed by Drupal Forge (use drush for database operations)

### Safety Reminders

Before running commands that modify the site:

1. **Config import**: Check what will change with `drush config:status`
2. **Database updates**: Review with `drush updb --status`
3. **Module operations**: Check dependencies before enabling/disabling
4. **Cache clear**: Usually safe, but consider timing on high-traffic sites

## Configuration-First Development

When possible, make changes via configuration files rather than database interactions:

1. **Adding a content type**: Create YAML files in `config/sync/` or `web/modules/custom/mymodule/config/install/`
2. **Adding fields**: Create field config YAML
3. **Changing settings**: Modify existing config YAML
4. **Installing modules**: Add to `core.extension.yml` (but prefer using `composer require` + `drush en`)

## Common Tasks

### Creating a Custom Module

```bash
drush generate module
```

Or create manually:
```
web/modules/custom/mymodule/
├── mymodule.info.yml
├── mymodule.module
├── composer.json
└── src/
```

### Adding a Field to a Content Type

```bash
drush generate field
```

Then export the configuration:
```bash
drush config:export -y
```

### Creating a View

1. Use the Drupal UI to create the view
2. Export configuration:
   ```bash
   drush config:export -y
   ```
3. The view config will be in `config/sync/views.view.[view_id].yml`

### Debugging

- **Check watchdog logs**: `drush watchdog:show`
- **Enable devel module**: `composer require --dev drupal/devel && drush en devel -y`
- **Check site status**: `drush status`
- **View recent errors**: `drush watchdog:show --severity=Error --count=50`

## Git Workflow

1. Create feature branch
2. Make changes
3. Export configuration if needed
4. Test on live site (carefully!)
5. Commit with descriptive message
6. Push and create PR

## Live Site Considerations

Since this is a live production environment:

- **Test carefully**: Changes affect real users immediately
- **Export before changes**: Always export config before major modifications
- **Commit frequently**: Preserve your work with frequent commits
- **Monitor logs**: Watch for errors after making changes
- **Backup strategy**: Understand Drupal Forge's backup options
- **Low-traffic periods**: Consider timing for major operations

When working in this codebase, prioritize adherence to Drupal patterns and conventions, and always consider the impact on the live site.

