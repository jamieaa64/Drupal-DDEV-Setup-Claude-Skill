# Drupal Setup Skill - Comprehensive Plan

## Executive Summary

This skill will enable Claude Code (web and local) to set up new Drupal projects with best practices baked in. Due to environment constraints in Claude Code web, the approach will be a **hybrid model**: Claude Code creates the project structure and configuration, while actual Drupal installation happens in a DDEV environment (locally or on a remote server).

## Environment Analysis

### Claude Code Web Container Capabilities

**Available:**
- PHP 8.4.14 ✓
- Composer ✓
- PDO MySQL and PostgreSQL extensions ✓
- Git ✓

**NOT Available:**
- Docker ✗
- DDEV ✗
- MySQL/PostgreSQL server ✗
- SQLite ✗
- Drush (but can be installed via Composer) ⚠️

### Key Constraint

**Claude Code web CANNOT run a full Drupal installation** because there's no database server. This fundamentally changes our approach.

## Proposed Architecture

### Phase 1: Template-Based Setup (MVP)

Claude Code will create a "ready-to-run" Drupal project that can be immediately deployed locally or remotely.

**What Claude Code Will Do:**
1. Create project directory structure
2. Initialize Git repository
3. Create `composer.json` with Drupal core/recommended project
4. Run `composer install` to download dependencies
5. Create custom configuration files:
   - `web/sites/default/settings.php` (organization-specific)
   - `web/sites/default/settings.local.php` (empty template)
   - `.gitignore` (based on organization template)
   - `.ddev/config.yaml` (DDEV configuration)
   - `config/sync/.gitkeep` (prepare config directory)
   - `private/.gitkeep` (prepare private files directory)
6. Create starter documentation:
   - `README.md` (deployment instructions)
   - `CLAUDE.md` (guidance for Claude when working on this project)
7. Commit and push to GitHub

**What Happens Next (Outside Claude Code):**
```bash
# Developer or CI system:
git clone <repo-url> <project-name>
cd <project-name>
ddev start
ddev composer install  # If needed
ddev drush site:install --account-pass=admin -y
ddev drush config:export -y  # Export initial config
```

The developer then commits the initial config back to the repo.

### Phase 2: Config-First Approach

Once initial config is in the repository, subsequent projects can use `site:install --existing-config` for reproducible installations.

**Enhanced Workflow:**
1. Claude Code creates project from template
2. Template includes base configuration in `config/sync/`
3. Deployment uses `drush site:install --existing-config`
4. Result: Fully configured site on first install

### Phase 3: Template Repository Strategy

Create organization-specific template repositories on GitHub:
- `drupal-11-starter`
- `drupal-cms-starter`
- `drupal-11-minimal-starter`

These templates include:
- Pre-configured composer.json with common modules
- Base configuration exports
- Organization-specific settings
- CI/CD configuration for DevPanel

**Claude Code Workflow:**
1. Ask user which template to use
2. Clone template repository
3. Customize for new project (rename, update README, etc.)
4. Push to new repository
5. Provide deployment instructions

## Addressing Specific Questions

### Q1: Can we assume DDEV in Claude Code container?

**Answer: NO**

Docker and DDEV are not available in Claude Code web. The container is designed for code manipulation, not for running full stack applications with databases.

**Implication:** We cannot install Drupal inside Claude Code web. We can only prepare the project structure.

### Q2: DDEV steps elsewhere and pull from template?

**Answer: YES - This is the recommended approach**

**Two-Stage Strategy:**

**Stage 1 - Claude Code (Creation):**
- Create project structure
- Install Composer dependencies
- Configure files (settings.php, .ddev/config.yaml, .gitignore)
- Initialize Git and push to GitHub

**Stage 2 - Local/Remote (Installation):**
- Clone repository
- Run DDEV
- Install Drupal with drush
- Export initial configuration
- Push config back to repository

### Q3: How will drush config sync work?

**Answer: Deferred to post-creation phase**

**Initial Setup (Claude Code cannot do this):**
- Drupal installation happens outside Claude Code
- Developer runs `drush config:export` after initial setup
- Configuration is committed to repo

**Ongoing Development (Claude Code CAN help with this):**
- Read existing config YAML files
- Modify config files directly (e.g., enabling modules, adding fields)
- Cannot test changes, but can prepare them
- Developer imports with `drush config:import`

**Realistic Workflow:**
```bash
# Claude Code modifies config/sync/core.extension.yml to enable a module
# Pushes changes to GitHub

# Developer locally:
git pull
ddev drush config:import -y
ddev drush cache:rebuild
```

### Q4: Can Claude Code create things in Drupal with scripts and export via config sync?

**Answer: NO for creation, PARTIAL YES for preparation**

**What Claude Code CANNOT Do:**
- Run drush commands that interact with a database
- Create content types, fields, views, blocks, etc. in a live Drupal
- Export configuration from a running Drupal

**What Claude Code CAN Do:**
- Create custom modules with hook_install()
- Create config/install YAML files in modules
- Create update hooks that will run on deployment
- Modify existing config YAML files
- Create migration configurations

**Example - Creating a Content Type:**

Claude Code creates `web/modules/custom/mymodule/config/install/node.type.article.yml`:
```yaml
langcode: en
status: true
dependencies: {  }
name: Article
type: article
description: 'Articles are blog posts or news items.'
help: ''
new_revision: true
preview_mode: 1
display_submitted: true
```

When the module is installed via `drush en mymodule`, this config is automatically imported.

**Recommended Pattern:**
1. Claude Code creates configuration YAML files
2. Claude Code writes installation scripts/hooks
3. Pushes to GitHub
4. CI/CD or developer runs drush commands
5. Configuration is activated in Drupal

## Skill File Structure

```
.claude/skills/drupal-setup/
├── skill.md                 # Main skill file with instructions
├── templates/
│   ├── settings.php.tpl     # Organization settings.php template
│   ├── gitignore.tpl        # .gitignore template
│   ├── ddev-config.yaml.tpl # DDEV configuration template
│   ├── README.md.tpl        # Project README template
│   ├── CLAUDE.md.tpl        # Claude guidance template
│   └── composer.json.tpl    # Composer template (if needed)
└── README.md                # Documentation about the skill
```

## Future Enhancements

### DevPanel Integration

**Goal:** Push to GitHub → Automatic deployment to DevPanel → Live site updates

**Requirements:**
1. DevPanel-specific configuration files
2. Automated deployment scripts
3. Environment-specific settings (dev/staging/prod)
4. Database sync strategies

**Claude Code Role:**
- Create DevPanel configuration files
- Set up CI/CD workflows (GitHub Actions)
- Configure multi-environment settings
- Document deployment process

**Technical Approach:**
```yaml
# .github/workflows/deploy-devpanel.yml
name: Deploy to DevPanel
on:
  push:
    branches: [main, develop]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Deploy to DevPanel
        run: |
          # DevPanel deployment commands
          # Could use rsync, git deploy, or DevPanel API
```

### Drupal.org Issue Integration

**Goal:** Point at Drupal.org issue → Use GitLab branch as starting point → Create PR for issue

**Workflow:**
1. User provides Drupal.org issue URL (e.g., https://www.drupal.org/project/drupal/issues/1234567)
2. Skill extracts issue number and project
3. Determines GitLab repository URL
4. Clones specific issue branch from GitLab
5. Creates local branch for work
6. After changes, creates merge request on GitLab
7. Links MR to Drupal.org issue

**Technical Requirements:**
- Drupal.org API integration (to fetch issue details)
- GitLab API integration (to create MRs)
- Issue number → GitLab branch name mapping
- Automatic MR description with issue reference

**Example Implementation:**
```bash
# User: "Work on drupal.org issue 3234567"
# Skill:
# 1. Fetch issue from https://www.drupal.org/api-d7/node/3234567.json
# 2. Determine GitLab URL: https://git.drupalcode.org/project/drupal
# 3. Find issue branch: 3234567-issue-description
# 4. Clone and set up workspace
# 5. Create feature branch: claude/3234567-implementation
```

## Skill Implementation Phases

### Phase 1: MVP - Basic Setup (Week 1)
- [ ] Create skill file structure
- [ ] Implement basic Drupal 11 project creation
- [ ] Generate required configuration files
- [ ] Create documentation templates
- [ ] Test with local DDEV deployment

### Phase 2: Enhanced Setup (Week 2-3)
- [ ] Add Drupal CMS option
- [ ] Implement template repository strategy
- [ ] Add common module presets (Admin Toolbar, Gin, Pathauto, etc.)
- [ ] Create update hook helpers
- [ ] Add config file manipulation capabilities

### Phase 3: DevPanel Integration (Week 4-5)
- [ ] Research DevPanel deployment methods
- [ ] Create DevPanel configuration templates
- [ ] Implement CI/CD workflow generation
- [ ] Add environment management
- [ ] Test end-to-end deployment

### Phase 4: Drupal.org Integration (Week 6-7)
- [ ] Research Drupal.org and GitLab APIs
- [ ] Implement issue fetching
- [ ] Create GitLab branch cloning
- [ ] Implement MR creation
- [ ] Add issue linking
- [ ] Create comprehensive documentation

## User Interaction Flow

### Skill Invocation

```
User: /drupal-setup

Claude: I'll help you set up a new Drupal project. Let me ask you a few questions:

1. Project name: ___
2. Drupal version:
   - [1] Drupal 11 (Core)
   - [2] Drupal CMS (Full featured)
   - [3] Drupal 11 Minimal
3. GitHub repository URL (if already created): ___
4. Include common modules? [Y/n]
5. Use organization template? [Y/n]

[After gathering info]

Creating your Drupal project...
✓ Created project structure
✓ Installed Composer dependencies
✓ Created settings.php with organization defaults
✓ Created .ddev/config.yaml
✓ Created .gitignore
✓ Created documentation (README.md, CLAUDE.md)
✓ Initialized Git repository
✓ Committed initial files
✓ Pushed to GitHub: <repo-url>

Next Steps:
To deploy this project locally, run:
  git clone <repo-url> <project-name>
  cd <project-name>
  ddev start
  ddev drush site:install --account-pass=admin -y
  ddev drush config:export -y
  git add config/sync
  git commit -m "Add initial configuration export"
  git push

Your project is ready! 🚀
```

## Configuration Management Strategy

### The Config-First Approach

Rather than trying to manipulate a live Drupal database, the skill will focus on **declarative configuration**.

**Benefits:**
- Version controlled
- Reviewable via Git
- Testable via CI/CD
- Reproducible across environments
- No database access needed during development

**Workflow:**

1. **Initial Setup:**
   - Claude Code creates project structure
   - Developer installs Drupal locally
   - Developer exports initial config
   - Config is committed to repo

2. **Development:**
   - Claude Code modifies config YAML files
   - Claude Code creates new config files in `config/install/`
   - Claude Code writes update hooks
   - Changes are pushed to GitHub

3. **Deployment:**
   - CI/CD or developer pulls changes
   - Runs `drush config:import`
   - Runs `drush updb` (update database)
   - Runs `drush cache:rebuild`

4. **Verification:**
   - Run tests
   - Check for config changes: `drush config:export --diff`

### Example: Adding a Content Type

**Traditional Approach (Requires Database):**
```bash
# Can't do this in Claude Code web
drush generate content-type
drush config:export
```

**Config-First Approach (Claude Code Can Do This):**

Create `web/modules/custom/myproject/config/install/node.type.article.yml`:
```yaml
langcode: en
status: true
dependencies: {  }
name: Article
type: article
description: 'Use articles for time-sensitive content.'
help: ''
new_revision: true
preview_mode: 1
display_submitted: true
```

Create corresponding field config, view modes, form displays, etc.

When module is installed: `drush en myproject`, all config is imported automatically.

## Limitations and Workarounds

### Limitation 1: Cannot Test Drupal Code
**Impact:** Can't verify that configuration changes work
**Workaround:**
- Provide clear deployment instructions
- Include validation in CI/CD
- Use Schema validation for YAML files
- Reference Drupal documentation

### Limitation 2: Cannot Run Drush Commands
**Impact:** Can't interact with Drupal database
**Workaround:**
- Focus on file-based operations
- Generate drush commands for documentation
- Create scripts for developers to run

### Limitation 3: Cannot Install Drupal
**Impact:** Can't create initial configuration
**Workaround:**
- Use template repositories with pre-exported config
- Defer installation to local/remote environment
- Provide comprehensive setup documentation

### Limitation 4: Cannot Debug Runtime Issues
**Impact:** Can't troubleshoot database-related problems
**Workaround:**
- Focus on static analysis (phpcs, phpstan)
- Review code against Drupal coding standards
- Provide debugging guidance in documentation

## Success Metrics

### MVP Success Criteria:
- [ ] Can create a Drupal 11 project in < 2 minutes
- [ ] Generated project can be deployed locally with `ddev start` + `ddev drush si`
- [ ] All configuration files are properly structured
- [ ] Documentation is clear and complete
- [ ] Follows organization best practices

### Full Feature Success Criteria:
- [ ] Supports multiple Drupal templates
- [ ] Integrates with DevPanel for automatic deployment
- [ ] Can work with Drupal.org issues and GitLab
- [ ] Can modify configuration files safely
- [ ] Generates update hooks correctly
- [ ] CI/CD pipelines work end-to-end

## Risk Assessment

### High Risk:
- **Config file syntax errors:** YAML mistakes could break site
  - *Mitigation:* Validate YAML syntax, use proven templates

- **DDEV version compatibility:** Config might not work with all DDEV versions
  - *Mitigation:* Document required DDEV version, use stable features

### Medium Risk:
- **Composer dependency conflicts:** Version mismatches
  - *Mitigation:* Use well-tested version constraints, lock files

- **DevPanel API changes:** Integration might break
  - *Mitigation:* Version pin, comprehensive error handling

### Low Risk:
- **Git push failures:** Network issues
  - *Mitigation:* Retry logic with exponential backoff (already implemented)

## Conclusion

The Drupal Setup Skill will be a powerful tool for initializing Drupal projects, but with clear boundaries:

**What It Does Well:**
✓ Creates project structure rapidly
✓ Applies organization best practices
✓ Generates configuration files
✓ Sets up version control
✓ Prepares deployment documentation

**What It Cannot Do:**
✗ Install Drupal in Claude Code web
✗ Run drush commands against a database
✗ Test configuration in a live Drupal
✗ Debug runtime errors

**The Sweet Spot:**
The skill excels at the **project initialization and configuration management** phases, delegating the **runtime and testing** phases to proper environments with database access.

This hybrid approach maximizes Claude Code's strengths while acknowledging its constraints, providing a practical and valuable tool for Drupal development teams.
