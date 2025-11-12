# Claude Guidance for {{PROJECT_NAME}}

This is a Drupal {{DRUPAL_VARIANT}} project. Follow these guidelines when working on this codebase.

## Build/Lint/Test Commands

- **Build**: `ddev composer install`
- **Install**: `ddev drush site:install --existing-config`
- **Lint**:
  - If the project has a `/phpcs.xml` or `/phpcs.xml.dist`: `ddev exec phpcs`
  - Otherwise: `ddev exec phpcs --standard=Drupal web/modules/custom`
- **Static Analysis**:
  - If the project has a `/phpstan.neon` or `phpstan.neon.dist`: `ddev exec phpstan`
  - Otherwise: `ddev exec phpstan analyse --level 6 web/modules/custom`
- **Run Single Test**:
  - If the project has a `/phpunit.xml` or `/phpunit.xml.dist`: `ddev exec phpunit --filter Test path/to/test`
  - Otherwise: `ddev exec phpunit -c web/core/phpunit.xml.dist --filter Test path/to/test`

## Configuration Management

- **Export configuration**: `ddev drush config:export -y`
- **Import configuration**: `ddev drush config:import -y`
- **Import partial configuration**: `ddev drush config:import --partial --source=web/modules/custom/mymodule/config/install`
- **Verify configuration**: `ddev drush config:export --diff`
- **View config details**: `ddev drush config:get [config.name]`
- **Change config value**: `ddev drush config:set [config.name] [key] [value]`
- **Install from config**: `ddev drush site:install --existing-config`
- **Get the config sync directory**: `ddev drush status --field=config-sync`

## Development Commands

- **List available modules**: `ddev drush pm:list [--filter=FILTER]`
- **List enabled modules**: `ddev drush pm:list --status=enabled [--filter=FILTER]`
- **Download a Drupal module**: `ddev composer require drupal/[module_name]`
- **Install a Drupal module**: `ddev drush en [module_name]`
- **Clear cache**: `ddev drush cache:rebuild`
- **Inspect logs**: `ddev drush watchdog:show --count=20`
- **Delete logs**: `ddev drush watchdog:delete all`
- **Run cron**: `ddev drush cron`
- **Show status**: `ddev drush status`

## Entity Management

- **View fields on entity**: `ddev drush field:info [entity_type] [bundle]`

## Best Practices

- If making configuration changes to a module's config/install, these should also be applied to active configuration
- Always export configuration after making changes: `ddev drush config:export -y`
- Check configuration diffs before importing
- If a module provides install configuration, this should be done via `config/install` not `hook_install`
- Attempt to use contrib modules for functionality, rather than replicating in a custom module
- If phpcs/phpstan/phpunit are not available, they should be installed by `ddev composer require --dev drupal/core-dev`

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

## Working with DDEV

This project uses DDEV for local development. All commands should be prefixed with `ddev`:

- **SSH into container**: `ddev ssh`
- **Run PHP**: `ddev exec php script.php`
- **View logs**: `ddev logs`
- **Restart**: `ddev restart`

## Working WITHOUT DDEV (Claude Code Web)

If you're working in Claude Code web where DDEV is not available:

- Read and modify configuration YAML files directly in `config/sync/`
- Create new modules with `config/install/` directories
- Write update hooks in `mymodule.install`
- Generate drush commands in documentation for users to run locally
- Focus on code review, static analysis, and config file management

## Configuration-First Development

When possible, make changes via configuration files rather than database interactions:

1. **Adding a content type**: Create YAML files in `config/sync/` or `web/modules/custom/mymodule/config/install/`
2. **Adding fields**: Create field config YAML
3. **Changing settings**: Modify existing config YAML
4. **Installing modules**: Add to `core.extension.yml` (but prefer using `composer require` + `drush en`)

## Common Tasks

### Creating a Custom Module

```bash
ddev drush generate module
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
ddev drush generate field
```

Then export the configuration:
```bash
ddev drush config:export -y
```

### Creating a View

1. Use the Drupal UI to create the view
2. Export configuration:
   ```bash
   ddev drush config:export -y
   ```
3. The view config will be in `config/sync/views.view.[view_id].yml`

### Debugging

- **Enable verbose logging** (already configured in settings.php for DDEV)
- **Check watchdog logs**: `ddev drush watchdog:show`
- **Enable devel module**: `ddev composer require --dev drupal/devel && ddev drush en devel -y`
- **Use Xdebug**: Configure in `.ddev/config.yaml`

## Git Workflow

1. Create feature branch
2. Make changes
3. Export configuration if needed
4. Test locally
5. Commit with descriptive message
6. Push and create PR

When working in this codebase, prioritize adherence to Drupal patterns and conventions.
