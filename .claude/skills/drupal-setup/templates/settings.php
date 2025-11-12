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
