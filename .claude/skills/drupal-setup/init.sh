#!/bin/bash

# Drupal Setup Skill Initialization Script
# This script attempts to install PHP SQLite support during skill loading

echo "Initializing Drupal Setup Skill..."

# Check if we already have SQLite
php -r "echo in_array('sqlite', PDO::getAvailableDrivers()) ? 'SQLite already available' : 'SQLite NOT available';" 2>&1
SQLITE_STATUS=$?

if [ $SQLITE_STATUS -eq 0 ]; then
    if php -r "exit(in_array('sqlite', PDO::getAvailableDrivers()) ? 0 : 1);" 2>/dev/null; then
        echo "✓ PHP SQLite support is already available"
        exit 0
    fi
fi

echo "Attempting to install PHP SQLite extension..."

# Try to install php8.4-sqlite3
apt-get update -qq 2>/dev/null && apt-get install -y php8.4-sqlite3 sqlite3 2>/dev/null

# Check if installation succeeded
if php -r "exit(in_array('sqlite', PDO::getAvailableDrivers()) ? 0 : 1);" 2>/dev/null; then
    echo "✓ Successfully installed PHP SQLite support"
    echo "✓ Full Drupal installation mode will be available"
    exit 0
else
    echo "⚠ Could not install PHP SQLite extension"
    echo "⚠ Skill will use template-based mode (no live Drupal installation)"
    echo "⚠ This is normal for security-restricted environments"
    exit 0  # Exit 0 so skill still loads
fi
