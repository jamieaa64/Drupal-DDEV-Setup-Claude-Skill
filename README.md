# Drupal Setup & Development Skill for Claude Code

A comprehensive Claude Code skill for the complete Drupal development lifecycle - from project creation to team collaboration and ongoing maintenance.

**Works in both Claude Code CLI (local) and Web environments.**

## ⚡ Quick Start

### 1. Install the Skill

**See [INSTALL.md](INSTALL.md) for detailed installation instructions.**

**Quick install (Claude Code CLI):**
```bash
# Clone repository
git clone https://github.com/jamieaa64/Drupal-DDEV-Setup-Claude-Skill.git
cd Drupal-DDEV-Setup-Claude-Skill

# Copy to user skills directory
mkdir -p ~/.claude/skills
cp -r .claude/skills/drupal-setup ~/.claude/skills/
```

**Quick install (Claude Code Web):**
```bash
# Package the skill
./package-skill.sh

# Upload drupal-setup-skill.zip to Claude Code Web
```

### 2. Use the Skill

**New project:**
```
Create a new Drupal site called "my-project"
```

**Existing project:**
```
Set up this existing Drupal project
```

**Update after pulling:**
```
Update my local Drupal environment
```

## 🎯 What This Skill Does

### For New Projects
- **30-second setup** with organizational best practices
- Creates Drupal 11 Core or Drupal CMS projects
- Generates all configuration files (settings.php, .gitignore, DDEV config)
- Sets up Git repository and pushes to GitHub
- Includes comprehensive documentation

### For Existing Projects
- **2-minute onboarding** for new team members
- Automatic environment sync after pulling changes
- One-command reset for clean slate
- Works with or without DDEV
- Environment-aware (adapts to local CLI vs web)

### Key Features
- ✅ Intelligent scenario detection (new vs existing project)
- ✅ Environment detection (DDEV vs web)
- ✅ Template-based Quick Mode (fast, production-aligned)
- ✅ Optional Full Mode (SQLite for testing)
- ✅ Complete lifecycle management (setup → develop → maintain)
- ✅ Team collaboration workflows
- ✅ **Drupal Forge/DrupalPod integration** - Generate instant live site URLs from GitHub repos

## 🌐 Drupal Forge & DrupalPod Integration

This repository now includes a **`drupal-forge` skill** that extends the original DDEV-focused skill with support for Drupal Forge/Dev Panel environments.

Realizes the "dream" mentioned in Jamie's LinkedIn post from Nov 11 2025 about making it work with DevPanel and Drupal Forge so when AI pushes something to a branch, you can immediately see the changes on a hosted site.

### What It Does

The `drupal-forge` skill enables **instant live site creation** from GitHub repositories:

1. **Create a Drupal project** using Claude Code
2. **Push to GitHub** (automated)
3. **Get a DrupalPod URL** (automatically generated)
4. **Click to create** your live Drupal Forge site instantly

### Workflow

```
Claude Code (AI creates project)
    ↓
GitHub (auto-pushed)
    ↓
DrupalPod URL (auto-generated)
    ↓
Live Drupal Forge Site (one click!)
```

### Using the Drupal Forge Skill

The `drupal-forge` skill works similarly to `drupal-setup` but:
- Commands run directly (no `ddev` prefix needed)
- Designed for live Drupal Forge environments
- Automatically generates DrupalPod URLs after pushing to GitHub
- Includes safety checks for live site operations

**Location**: `.claude/skills/drupal-forge/`

**Documentation**: See [.claude/skills/drupal-forge/README.md](.claude/skills/drupal-forge/README.md)

## 📚 Documentation

- **[INSTALL.md](INSTALL.md)** - Complete installation guide
- **[plan.md](plan.md)** - Architecture and design decisions
- **[CurrentWorkflow.md](CurrentWorkflow.md)** - Organization's Drupal workflow
- **[.claude/skills/drupal-setup/README.md](.claude/skills/drupal-setup/README.md)** - Detailed skill documentation for DDEV
- **[.claude/skills/drupal-forge/README.md](.claude/skills/drupal-forge/README.md)** - Detailed skill documentation for Drupal Forge

## 🚀 Usage Examples

### Scenario 1: Creating a New Project

```
You: "Create a new Drupal site called 'client-portal'"

Claude: I'll help you set up a new Drupal project!

1. Project name: client-portal
2. Drupal variant: [1] Drupal 11 Core / [2] Drupal CMS / [3] Minimal
   Choice: 1
3. Setup mode: [1] Quick (30s) / [2] Full (5-8min)
   Choice: 1 (default)
4. GitHub repository: https://github.com/org/client-portal
5. Include common modules? Y

✓ Project created in 30 seconds!
✓ Pushed to GitHub
✓ Ready for team to clone and deploy
```

### Scenario 2: New Team Member Onboarding

```bash
# New developer joins team
git clone https://github.com/org/client-portal
cd client-portal
```

```
You: "Set up this existing Drupal project"

Claude: This looks like an existing Drupal project!

What would you like to do?
[1] Initial setup (first time working on this project)
[2] Update after pulling changes
[3] Reset local environment
[4] Create new project instead

Choice: 1

[With DDEV - Fully Automated]
✓ ddev start
✓ ddev composer install
✓ ddev drush site:install --existing-config
✓ ddev launch

Done! Site ready at https://client-portal.ddev.site
Login: admin / admin

Your local development environment is ready!
```

### Scenario 3: Syncing After Pulling Changes

```bash
git pull  # Team member pushed changes
```

```
You: "Update my local Drupal environment"

Claude: Syncing your environment...

✓ ddev composer install (new dependencies)
✓ ddev drush config:import -y (config changes)
✓ ddev drush updb -y (database updates)
✓ ddev drush cache:rebuild

Changes applied:
- Dependencies updated (composer.lock changed)
- Configuration imported (3 config files changed)
- Database updates run (2 updates)
- Cache cleared

Your local environment is now in sync with the repository!
```

### Scenario 4: Reset Broken Environment

```
You: "Reset my Drupal environment"

Claude: Resetting your local environment...

✓ ddev delete -y (removed database)
✓ ddev start
✓ ddev composer install
✓ ddev drush site:install --existing-config
✓ ddev launch

Environment reset complete!
Fresh Drupal installation with current configuration.
```

### Scenario 5: Instant Live Preview with DrupalPod

```
You: "Create a new Drupal CMS site called 'demo-site'"

Claude: I'll help you set up a new Drupal project!

[... project setup ...]

✓ Project created in 30 seconds!
✓ Pushed to GitHub: https://github.com/username/demo-site.git

🚀 Create Your Live Drupal Site:
Click here to instantly create your Drupal Forge site:
https://www.drupalforge.org/drupalpod?DP_REPO_BRANCH=https%3A%2F%2Fgithub.com%2Fusername%2Fdemo-site%2Ftree%2Fmain&...

[Click the URL]

✓ DrupalPod creates your live site instantly
✓ Share the URL with team members or clients
✓ Changes pushed to GitHub automatically update the live site
✓ Perfect for demos, previews, and client reviews!
```

## 🏗️ Project Structure

Created projects include:

```
project-name/
├── .ddev/
│   └── config.yaml          # DDEV configuration
├── config/
│   └── sync/                # Drupal configuration (version controlled)
├── private/                 # Private files directory
├── web/                     # Drupal web root
│   ├── modules/custom/     # Custom modules
│   ├── themes/custom/      # Custom themes
│   └── sites/default/
│       ├── settings.php    # Organization-specific settings
│       └── settings.local.php
├── .gitignore              # Comprehensive Drupal .gitignore
├── composer.json           # PHP dependencies
├── README.md               # Project documentation
└── CLAUDE.md               # Claude Code guidance for this project
```

## 🔧 Requirements

### For New Projects (Quick Mode)
- Claude Code (Web or CLI)
- Composer access
- Git
- GitHub account

### For Full Automation (Existing Projects)
- Claude Code CLI (local)
- [DDEV](https://ddev.readthedocs.io/) installed
- Docker installed and running

### For Web (Limited Functionality)
- Claude Code Web
- Can do: File operations, composer install, config editing
- Cannot do: Database operations, drush commands

## 🎓 Benefits for Teams

| Benefit | Before | After |
|---------|--------|-------|
| **New developer onboarding** | 2-4 hours (manual setup, troubleshooting) | 2 minutes (automated) |
| **Environment sync** | Remember drush commands, manual steps | One command |
| **Project setup** | Copy/paste from wiki, adapt settings | 30 seconds, consistent |
| **Broken environment** | Reinstall from scratch, lose local changes | One command reset |
| **Team consistency** | Everyone does it differently | Same workflow for all |

## 🛠️ Workflows Supported

1. **New Project Creation**
   - Quick Mode (default): Template-based, fast
   - Full Mode (advanced): Live Drupal with SQLite

2. **Existing Project Setup**
   - Initial setup (first time)
   - Update after pull (sync environment)
   - Reset environment (clean slate)

3. **Environment Types**
   - Local CLI with DDEV (full automation)
   - Web without DDEV (file operations + guidance)

## 📦 What's in the Box

This repository includes **two skills**:

### 1. `drupal-setup` (Original - DDEV-focused)
- **skill.md** (15KB) - Main skill instructions
- **init.sh** (1KB) - Initialization script
- **README.md** (12KB) - Skill documentation
- **templates/** - Production-ready templates
  - settings.php - Organization settings
  - gitignore - Drupal .gitignore
  - ddev-config.yaml - DDEV configuration
  - README.md - Project documentation
  - CLAUDE.md - Claude guidance for projects

### 2. `drupal-forge` (New - Drupal Forge/DrupalPod)
- **skill.md** (17KB) - Main skill instructions with DrupalPod integration
- **README.md** (15KB) - Skill documentation
- **templates/** - Drupal Forge-adapted templates
  - settings.php - Forge-adapted settings
  - gitignore - Drupal .gitignore
  - README.md - Project documentation
  - CLAUDE.md - Claude guidance for projects

**Total size**: ~78KB (both skills)

## 🚧 Future Enhancements

Planned features (see [plan.md](plan.md)):

- ✅ **DrupalPod Integration** - Push to GitHub → Instant Drupal Forge site creation (implemented in `drupal-forge` skill)
- **Drupal.org Integration** - Work with Drupal.org issues and GitLab branches
- **Multi-environment support** - Dev/staging/prod configurations
- **CI/CD templates** - GitHub Actions workflows
- **Custom module scaffolding** - Generate module boilerplate

## 🤝 Contributing

Contributions welcome! This skill is designed to evolve with team needs.

**Ideas for contributions:**
- Additional Drupal variants (Drupal 10, contrib distributions)
- More template variations
- Additional common module presets
- DevPanel integration implementation
- Testing frameworks setup

## 📄 License

See [LICENSE](LICENSE) file.

## 🙏 Acknowledgments

Built for efficient Drupal development with Claude Code, incorporating:
- Drupal community best practices
- DDEV local development standards
- Configuration-first development approach
- Team collaboration workflows

## 📞 Support

- **Documentation**: Start with [INSTALL.md](INSTALL.md)
- **Issues**: [GitHub Issues](https://github.com/jamieaa64/Drupal-DDEV-Setup-Claude-Skill/issues)
- **Claude Code Docs**: https://docs.claude.com/claude-code

---

**Ready to streamline your Drupal development?** [Install now →](INSTALL.md)
