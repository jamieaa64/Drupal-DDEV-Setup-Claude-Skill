# Installing the Drupal Setup Skill

This guide explains how to install this skill in Claude Code (web or local CLI).

## Quick Install

### For Claude Code Web

1. **Download or clone this repository**
   ```bash
   git clone https://github.com/jamieaa64/Drupal-DDEV-Setup-Claude-Skill.git
   ```

2. **Locate the skill files**

   The skill files are in the `.claude/skills/drupal-setup/` directory:
   ```
   .claude/skills/drupal-setup/
   ├── skill.md              # Main skill instructions (REQUIRED)
   ├── init.sh               # Initialization script
   ├── README.md             # Skill documentation
   └── templates/
       ├── settings.php
       ├── gitignore
       ├── ddev-config.yaml
       ├── README.md
       └── CLAUDE.md
   ```

3. **Create a ZIP file with the exact structure**

   **IMPORTANT**: Claude Code expects a specific folder structure in the ZIP file.

   **Option A: ZIP the drupal-setup directory directly**
   ```bash
   cd .claude/skills
   zip -r drupal-setup.zip drupal-setup/
   ```

   The ZIP should contain:
   ```
   drupal-setup/
   ├── skill.md
   ├── init.sh
   ├── README.md
   └── templates/
       └── (all template files)
   ```

   **Option B: Create ZIP from repository root**
   ```bash
   # From repository root
   cd Drupal-DDEV-Setup-Claude-Skill
   zip -r drupal-setup-skill.zip .claude/skills/drupal-setup
   ```

4. **Upload to Claude Code Web**

   - Open Claude Code in your browser
   - Navigate to Skills settings
   - Click "Upload Skill"
   - Select the `drupal-setup.zip` file
   - The skill will be installed to your user skills directory

### For Claude Code CLI (Local)

**Method 1: Manual Installation**

1. **Clone or download this repository**
   ```bash
   git clone https://github.com/jamieaa64/Drupal-DDEV-Setup-Claude-Skill.git
   cd Drupal-DDEV-Setup-Claude-Skill
   ```

2. **Copy the skill to your user skills directory**

   **On macOS/Linux:**
   ```bash
   # Create skills directory if it doesn't exist
   mkdir -p ~/.claude/skills

   # Copy the skill
   cp -r .claude/skills/drupal-setup ~/.claude/skills/
   ```

   **On Windows (PowerShell):**
   ```powershell
   # Create skills directory if it doesn't exist
   New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.claude\skills"

   # Copy the skill
   Copy-Item -Recurse .claude/skills/drupal-setup "$env:USERPROFILE\.claude\skills\"
   ```

3. **Verify installation**
   ```bash
   ls ~/.claude/skills/drupal-setup
   # Should show: skill.md, init.sh, README.md, templates/
   ```

**Method 2: Using ZIP**

1. Create ZIP as described above
2. Extract to `~/.claude/skills/` (macOS/Linux) or `%USERPROFILE%\.claude\skills\` (Windows)
3. Ensure the folder structure is: `~/.claude/skills/drupal-setup/skill.md`

## Skill Directory Structure

**Critical**: The skill MUST be in this exact structure:

```
~/.claude/skills/                    # User skills directory
└── drupal-setup/                    # Skill name (folder)
    ├── skill.md                     # REQUIRED - Main skill file
    ├── init.sh                      # Optional - Initialization script
    ├── README.md                    # Optional - Documentation
    └── templates/                   # Optional - Template files
        ├── settings.php
        ├── gitignore
        ├── ddev-config.yaml
        ├── README.md
        └── CLAUDE.md
```

**Common Mistakes:**
- ❌ `drupal-setup/drupal-setup/skill.md` (nested too deep)
- ❌ `skill.md` directly in `~/.claude/skills/` (not in subdirectory)
- ❌ Wrong skill name in folder (must match how you want to invoke it)
- ✅ `drupal-setup/skill.md` (correct!)

## Verifying Installation

### In Claude Code Web

1. Open a chat in Claude Code
2. Type: "What skills are available?"
3. You should see "drupal-setup" in the list

### In Claude Code CLI

1. Open terminal in any directory
2. Run: `claude`
3. Type: "What skills are available?"
4. You should see "drupal-setup" in the list

Or check directly:
```bash
ls ~/.claude/skills/drupal-setup/skill.md
# Should show the file path
```

## Using the Skill

Once installed, you can invoke it in several ways:

**Explicit invocation:**
```
Use the drupal-setup skill
```

**Natural language (new project):**
```
Create a new Drupal site called "my-project"
```

**Natural language (existing project):**
```
Set up this existing Drupal project
```

**Natural language (update):**
```
Update my local Drupal environment
```

Claude will detect which scenario you're in and provide appropriate options.

## Project-Specific Installation

If you want this skill available only in a specific project (not globally):

1. **Create `.claude/skills/` in your project root**
   ```bash
   mkdir -p .claude/skills
   ```

2. **Copy the skill there**
   ```bash
   cp -r /path/to/Drupal-DDEV-Setup-Claude-Skill/.claude/skills/drupal-setup .claude/skills/
   ```

3. **Commit to Git** (optional - shares skill with team)
   ```bash
   git add .claude/skills/drupal-setup
   git commit -m "Add Drupal setup skill to project"
   git push
   ```

Now team members who clone the repository will have the skill available when working on this project.

## Skill Scoping

Claude Code searches for skills in this order:

1. **Project skills**: `.claude/skills/` in current project (takes precedence)
2. **User skills**: `~/.claude/skills/` in user home directory (global)

If you have the same skill in both locations, the project version will be used.

## Troubleshooting

### "Skill not found" error

**Check location:**
```bash
# Should be here
ls ~/.claude/skills/drupal-setup/skill.md

# NOT here
ls ~/.claude/skills/skill.md  # Wrong!
```

**Check structure in ZIP:**
```bash
unzip -l drupal-setup.zip
# Should show:
#   drupal-setup/skill.md
#   drupal-setup/init.sh
#   drupal-setup/templates/...
```

### "Permission denied" on init.sh

```bash
chmod +x ~/.claude/skills/drupal-setup/init.sh
```

### Skill not loading in Claude Code Web

1. Check ZIP structure (most common issue)
2. Re-upload the ZIP
3. Clear browser cache and reload
4. Check Claude Code Web skill management UI

### Changes not taking effect

**For User Skills:**
- Restart Claude Code session
- Or reload/refresh if in web

**For Project Skills:**
- Changes are picked up immediately
- No restart needed

## Updating the Skill

### From Git Repository

```bash
cd Drupal-DDEV-Setup-Claude-Skill
git pull
cp -r .claude/skills/drupal-setup ~/.claude/skills/
```

### Manual Update

1. Download latest version
2. Delete old skill directory: `rm -rf ~/.claude/skills/drupal-setup`
3. Copy new version: `cp -r .claude/skills/drupal-setup ~/.claude/skills/`

## Uninstalling

```bash
# Remove user skill
rm -rf ~/.claude/skills/drupal-setup

# Remove project skill
rm -rf .claude/skills/drupal-setup
```

## Support

- **Documentation**: See README.md in the skill directory
- **Issues**: https://github.com/jamieaa64/Drupal-DDEV-Setup-Claude-Skill/issues
- **Claude Code Docs**: https://docs.claude.com/claude-code

## File Manifest

Here's exactly what should be in your skill directory:

```
drupal-setup/
├── skill.md                          # 15 KB - Main skill instructions
├── init.sh                          # 1 KB - Initialization script
├── README.md                        # 12 KB - Skill documentation
└── templates/
    ├── CLAUDE.md                    # 5 KB - Project guidance template
    ├── README.md                    # 8 KB - Project readme template
    ├── ddev-config.yaml            # 1 KB - DDEV config template
    ├── gitignore                   # 2 KB - Git ignore template
    └── settings.php                # 2 KB - Drupal settings template
```

Total size: ~46 KB

If your ZIP or directory is significantly larger, you may have included extra files accidentally.

## Quick Reference

**User Skills Location:**
- macOS/Linux: `~/.claude/skills/drupal-setup/`
- Windows: `%USERPROFILE%\.claude\skills\drupal-setup\`

**Project Skills Location:**
- Any OS: `<project-root>/.claude/skills/drupal-setup/`

**Required Files:**
- `skill.md` (only this file is strictly required)

**Optional but Recommended:**
- `init.sh` - For automatic package installation
- `README.md` - Documentation
- `templates/` - Template files used by the skill

Happy Drupal development! 🚀
