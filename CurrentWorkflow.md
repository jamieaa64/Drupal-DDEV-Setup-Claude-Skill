# Current Workflow for starting a new project

This Workflow is one organisation's approach to starting a new project with Drupal and DDEV (which uses Docker) to get started with a new full-website and track it safely in git. It is a mixture of standard approaches and organisation specific opinions on best practises. This normally takes the process of setting things up locally and then pushing to git. However with Claude Code on the Web and a Skill, we will do things in Claude Code's container, push to a github repo and then a developer can deploy it locally or remotely for testing and therefore this process may need to be tweaked. (For example, step 1 is create the repo on github)

## Summary of Current Workflow:
(This is a mixture of 

1. Create your working directory
2. Create the DDEV project (following the Drupal/Drupal CMS quickstart).
 a) You can opt to use the UI rather than the drush for the site install.
3. An empty settings.local.php is created and anything that doesn't want to be pushed in a public repo (API keys) could go there. 
4. Remove the boiler plate from settings.php, but our organisation will typically set the following (see full file later):
  a) The config directory to ../config/sync
  b) Private file system (if needed)
  c) Verbose logging when running in DDEV
  d) Include the settings.local.php
5. Set up the .gitignore by copying the web/example.gitignore and adjusting the paths (will include a full example)
6. If pushing to github/gitlab create the project and follow the steps on the project page (typically git init git remote add origin .... git commit ... git push ...)

## Workflow for setting up the process locally after start.

0. DDEV and Docker are setup and installed.
1. git clone URL TARGET_FOLDER (which will create TARGET_FOLDER for you)
2. cd TARGET_FOLDER
3. ddev start
4. ddev composer install
5. ddev drush site:install --existing-config

For this to work during develop update scripts are needed and drush config:export needs to happen.


## Workflow for DDEV install for Drupal

Create the project directory and configure DDEV:

        mkdir my-drupal-site && cd my-drupal-site
        ddev config --project-type=drupal11 --docroot=web

Start DDEV (this may take a minute):

        ddev start
        
Install Drupal via Composer:

        ddev composer create-project "drupal/recommended-project:^11"
        ddev composer require drush/drush
        
Run Drupal installation and launch:

        ddev drush site:install --account-name=admin --account-pass=admin -y
        ddev launch
        
# or automatically log in with:

        ddev launch $(ddev drush uli)

## Workflow for DDEV install for Drupal CMS

Create the project directory and configure DDEV:

        mkdir my-drupal-site && cd my-drupal-site
        ddev config --project-type=drupal11 --docroot=web

Start DDEV (this may take a minute):

        ddev start

Install Drupal CMS via Composer:

        ddev composer create-project drupal/cms
        ddev si --account-pass=admin
  
Launch the site:

        ddev launch

Note: You may want to ask the user if they want Drupal Core (11) or Drupal CMS and if they are happy with admin/admin for logging in.


## Template Files

### settings.php

```

<?php

/**
 * @file
 * Drupal site-specific configuration file.
 */

/**
 * The application root directory.
 *
 * @var string $app_root
 */

/**
 * The path to the site in use.
 *
 * @var string $site_path
 */

/**
 * Location of the site configuration files.
 */

$settings['config_sync_directory'] = '../config/sync';

/**
 * Public file path.
 */
$settings['file_public_path'] = 'sites/default/files';

/**
 * Private file path.
 */
$settings['file_private_path'] = '../../private';

/**
 * Temporary file path.
 */
$settings['file_temp_path'] = '/tmp';

/**
 * A custom theme for the offline page:
 */
$settings['maintenance_theme'] = 'gin';

/**
 * Load services definition file.
 */
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.yml';
$settings['container_yamls'][] = $app_root . '/' . $site_path . '/services.local.yml';

/**
 * The default list of directories that will be ignored by Drupal's file API.
 */
$settings['file_scan_ignore_directories'] = [
  'node_modules',
  'bower_components',
];

// Exclude dev only modules.
$settings['config_exclude_modules'] = [];

// Automatically generated include for settings managed by ddev.
if (getenv('IS_DDEV_PROJECT') == 'true' && file_exists(__DIR__ . '/settings.ddev.php')) {
  include __DIR__ . '/settings.ddev.php';

  $settings['file_private_path'] = '../.ddev/private';

  // Show all error messages, with backtrace information.
  $config['system.logging']['error_level'] = 'verbose';

  // Display all the errors.
  error_reporting(E_ALL);
  ini_set('display_errors', TRUE);
  ini_set('display_startup_errors', TRUE);

  // Service containers.
  $settings['container_yamls'][] = $app_root . '/sites/development.services.yml';
  $settings['container_yamls'][] = $app_root . '/sites/ddev.services.yml';
}

/**
 * Load local development override configuration, if available.
 */
if (file_exists($app_root . '/' . $site_path . '/settings.local.php')) {
  include $app_root . '/' . $site_path . '/settings.local.php';
}

```

### .gitignore

```

# Ignore directories generated by Composer
/drush/contrib/
/vendor/
/web/core/
/web/modules/contrib/
/web/themes/contrib/
/web/profiles/contrib/
/web/libraries/

# Ignore sensitive information
/web/sites/*/settings.local.php
/web/sites/*/local.services.yml

# Ignore Drupal's file directory
/web/sites/*/files/

# Ignore SimpleTest multi-site environment.
/web/sites/simpletest

# Ignore files generated by PhpStorm
/.idea/
/.phpstorm.meta.php/

# Ignore DDev local files.
.ddev/private
.ddev/homeadditions/.bashrc_local
.editorconfig
.gitattributes

# Ignore scaffold files.
.editorconfig
.gitattributes
web/.htaccess.orig
web/maintenance.html
/web/*/README.txt
/web/sites/default/default.settings.php
/web/sites/default/default.services.yml
/web/sites/development.services.yml
/web/sites/example.settings.local.php
/web/sites/example.sites.php
/web/sites/README.txt
/web/.csslintrc
/web/.eslintignore
/web/.eslintrc.json
/web/.ht.router.php
/web/INSTALL.txt
/web/README.md
/web/example.gitignore
/web/web.config

# Ignore cache files.
/.phpcs-cache

# Local drush files.
drush/drush.yml

```


### Claude.md starting point file

```
# Claude Guidance for Drupal Projects

## Build/Lint/Test Commands
- **Build**: `composer install`
- **Install**: `drush site:install --existing-config`
- **Lint**:
  - If the project has a `/phpcs.xml` or `/phpcs.xml.dist`: `phpcs`
  - Otherwise: `phpcs --standard=Drupal path/to/test`
- **Static Analysis**:
  - If the project has a `/phpstan.neon` or `phpstan.neon.dist`: `phpstan`
  - Otherwise: `phpstan analyse --level 6 path/to/test`
- **Run Single Test**:
  - If the project has a `/phpunit.xml` or `/phpunit.xml.dist`: `phpunit --filter Test path/to/test`
  - Otherwise: `phpunit -c [web-root]/core/phpunit.xml.dist --filter Test path/to/test`

## Configuration Management
- **Export configuration**: `drush config:export -y`
- **Import configuration**: `drush config:import -y`
- **Import partial configuration**: E.g. to reset to a module's install config `drush config:import --partial --source=[path-to-module/config/install`
- **Verify configuration**: `drush config:export --diff`
- **View config details**: `drush config:get [config.name]`
- **Change config value**: `drush config:set [config.name] [key] [value]`
- **Install from config**: `drush site:install --existing-config`
- **Get the config sync directory**: `ddev drush status --field=config-sync`

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
- Always export configuration after making changes
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

When working in this codebase, prioritize adherence to Drupal patterns and conventions.

```
