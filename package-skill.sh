#!/bin/bash

# Package Drupal Setup Skill for Claude Code
# This script creates a properly structured ZIP file for the skill

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$SCRIPT_DIR/.claude/skills/drupal-setup"
OUTPUT_FILE="$SCRIPT_DIR/drupal-setup-skill.zip"

echo "📦 Packaging Drupal Setup Skill..."
echo ""

# Check if skill directory exists
if [ ! -d "$SKILL_DIR" ]; then
    echo "❌ Error: Skill directory not found at $SKILL_DIR"
    exit 1
fi

# Check if skill.md exists (required)
if [ ! -f "$SKILL_DIR/skill.md" ]; then
    echo "❌ Error: skill.md not found (required file)"
    exit 1
fi

# Remove old ZIP if exists
if [ -f "$OUTPUT_FILE" ]; then
    echo "🗑️  Removing old ZIP file..."
    rm "$OUTPUT_FILE"
fi

# Create ZIP with correct structure
echo "📁 Creating ZIP file..."
cd "$SCRIPT_DIR/.claude/skills"
zip -r "$OUTPUT_FILE" drupal-setup/ -x "*.DS_Store" -x "__MACOSX/*"

# Verify ZIP contents
echo ""
echo "✅ ZIP file created: $OUTPUT_FILE"
echo ""
echo "📋 Contents:"
unzip -l "$OUTPUT_FILE" | grep -E "drupal-setup/(skill\.md|init\.sh|README\.md|templates/)"

echo ""
echo "📊 File size:"
ls -lh "$OUTPUT_FILE" | awk '{print $9, $5}'

echo ""
echo "✅ Package complete!"
echo ""
echo "To install in Claude Code Web:"
echo "  1. Upload this file: $OUTPUT_FILE"
echo "  2. The skill will be available as 'drupal-setup'"
echo ""
echo "To install in Claude Code CLI:"
echo "  macOS/Linux:"
echo "    unzip -q drupal-setup-skill.zip -d ~/.claude/skills/"
echo ""
echo "  Windows (PowerShell):"
echo "    Expand-Archive -Path drupal-setup-skill.zip -DestinationPath \$env:USERPROFILE\\.claude\\skills\\"
echo ""
