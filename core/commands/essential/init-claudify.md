---
description: Initialize complete Claude Code setup for your repository with intelligent component selection
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Write, MultiEdit, TodoWrite]
argument-hint: --standard | --comprehensive (default)
complexity: high
estimated-time: 5-10 minutes
category: setup
---

# Initialize Claude Code Base Configuration

<think harder about how to intelligently set up Claude Code based on the repository analysis>

I'll analyze your repository and set up a complete Claude Code environment tailored to your project.

## 🎯 Primary Purpose
This command will:
1. **Install agents** - All Opus 4 optimized agents for parallel analysis
2. **Install commands** - Domain-specific commands based on your tech stack
3. **Install agent-tools** - Supporting tools for agent operations
4. **Install hooks** - Quality and security validation hooks
5. **Install generators** - Tools to create custom components
6. **Create/preserve documentation** - CLAUDE.md and FEATURES.md (won't overwrite existing)

## 📌 Claudify Version Check

@Bash(command="echo '🔍 Checking Claudify installation...'; if [ -f .claudify/VERSION ]; then ver=$(cat .claudify/VERSION); echo \"  ✓ Claudify resources v$ver found\"; if [ \"$ver\" != \"2.0.0\" ]; then echo \"  ⚠️ WARNING: You have v$ver but v2.0.0 is recommended\"; echo \"     Please update Claudify for best results\"; fi; elif [ -f .claude/VERSION ]; then ver=$(cat .claude/VERSION); echo \"  ℹ Installed version: v$ver\"; echo \"  ❌ Missing .claudify directory - cannot install components\"; echo \"\"; echo \"  To fix: Download Claudify v2.0.0 and run setup.ps1\"; exit 1; else echo \"  ❌ Claudify not found - please run setup.ps1 first\"; exit 1; fi", description="Check Claudify version and resources")

@Bash(command="echo && echo '📦 Checking existing installation...' && test -d .claude && echo '  ✓ .claude directory exists' || echo '  ✗ .claude directory not found'; claude_exists=false; features_exists=false; test -f CLAUDE.md && { echo '  ✓ CLAUDE.md exists'; claude_exists=true; } || echo '  ✗ CLAUDE.md not found (will create)'; test -f FEATURES.md && { echo '  ✓ FEATURES.md exists'; features_exists=true; } || echo '  ✗ FEATURES.md not found (will create)'; echo; export CLAUDE_EXISTS=$claude_exists; export FEATURES_EXISTS=$features_exists", description="Check existing Claude Code setup and set flags")

@Read(file_path=".claudify/components-manifest.json", limit=6)

## Phase 1: Repository Analysis

Let me analyze your repository structure to understand your technology stack and patterns.

### Technology Stack Detection

<think about what files indicate which technologies>

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "in_progress", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "pending", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "pending", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "pending", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "pending", "priority": "high", "id": "setup-5"}])

First, I'll check for backend technology indicators:

@Glob(pattern="**/*.csproj", path=".")
@Glob(pattern="**/go.mod", path=".")
@Glob(pattern="**/package.json", path=".")
@Glob(pattern="**/pom.xml", path=".")
@Glob(pattern="**/requirements.txt", path=".")

Now checking for frontend frameworks:

@Glob(pattern="**/angular.json", path=".")
@Glob(pattern="**/next.config.js", path=".")

### Architecture Pattern Recognition

Let me search for common architectural patterns:

@Grep(pattern="IRepository|Repository<|RepositoryBase", path=".", output_mode="files_with_matches", head_limit=10)
@Grep(pattern="Result<.*>|Result\\.Success|Result\\.Failure", path=".", output_mode="files_with_matches", head_limit=10)
@Grep(pattern="OrganizationId|TenantId|CompanyId|CustomerId", path=".", output_mode="files_with_matches", head_limit=10)
@Grep(pattern="async.*Task|await|async function|Promise", path=".", output_mode="files_with_matches", head_limit=10)
@Grep(pattern="Controller|Service|Repository|Handler|Middleware", path=".", output_mode="files_with_matches", head_limit=10)

<think about the analysis results and determine the tech stack and patterns>

Based on my analysis:
- **Backend**: [DETECTED]
- **Frontend**: [DETECTED]
- **Database**: [INFERRED]
- **Patterns**: [DETECTED PATTERNS]
- **Multi-tenancy**: [YES/NO with field name]

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "in_progress", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "pending", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "pending", "priority": "high", "id": "setup-5"}])

## Phase 2: Component Selection

<think about which components are most appropriate for this tech stack>

Based on your detected project structure, I'll determine the best components for your project.

<think step-by-step about component selection based on the analysis>

### Recommended Components:

**For Backend** (if detected):
- Commands: `add-backend-feature`, `fix-backend-bug`, `review-backend-code`, `fix-backend-build-and-tests`
- Agents: `code-reviewer`, `tech-lead` (if DDD detected)

**For Frontend** (if detected):
- Commands: `add-frontend-feature`, `fix-frontend-bug`, `review-frontend-code`, `fix-frontend-build-and-tests`
- Agents: `frontend-developer`, `ux-reviewer`

**For Multi-tenant** (if detected):
- Agents: `security-reviewer`
- Hooks: `check-tenant-scoping`

**Essential for all projects**:
- Commands: `comprehensive-review`, `do-extensive-research`, `quick-research`, `create-command-and-or-agent`, `generate-documentation`, `update-changelog`
- Agents: `code-reviewer`, `infrastructure-architect`
- Agent Tools: Security scanner, complexity analyzer, deployment analyzer
- Generators: All generator scripts
- Hooks: `add-context`, `pre-commit-quality-check`, `check-changelog-updates`
- Validation: Architecture validator, code quality validator, test coverage analyzer
- Documentation: Templates for API, architecture, development, and troubleshooting guides

## 📦 Setup Type Selection

@Bash(command="echo ''
echo '╔══════════════════════════════════════════════════════╗'
echo '║           CLAUDIFY SETUP TYPE SELECTION              ║'
echo '╚══════════════════════════════════════════════════════╝'
echo ''
echo 'Choose your installation type:'
echo ''
echo '  🔸 STANDARD (~15-25 files)'
echo '     Core commands, agents, and tools for your tech stack'
echo '     Perfect for: Most projects'
echo ''
echo '  🔺 COMPREHENSIVE (~40+ files) [RECOMMENDED]'
echo '     Everything available - all agents, commands, tools'
echo '     Perfect for: Most projects, ensures full capabilities'
echo ''
echo '────────────────────────────────────────────────────────'
echo ''
echo 'To select, run init-claudify with one of these options:'
echo '  /init-claudify --standard'
echo '  /init-claudify --comprehensive  (or just /init-claudify)'
echo ''", description="Show setup options")

### Determining Setup Type

@Bash(command="setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; elif echo '$ARGUMENTS' | grep -q '\-\-comprehensive\|\-\-full\|\-\-all'; then setup_type='comprehensive'; fi; echo \"📋 Setup Type Selected: $(echo $setup_type | tr '[:lower:]' '[:upper:]')\"; echo '────────────────────────────────────────────────────────'", description="Determine setup type from arguments")

### Detecting Your Technology Stack

Let me determine which components to install:

@Bash(command="echo '🔍 Detecting backend technology...' && if ls *.csproj 1>/dev/null 2>&1 || ls **/*.csproj 1>/dev/null 2>&1; then echo '  ✓ .NET/C# detected'; elif [ -f go.mod ]; then echo '  ✓ Go detected'; elif [ -f pom.xml ] || [ -f build.gradle ]; then echo '  ✓ Java detected'; elif [ -f requirements.txt ] || ls *.py 1>/dev/null 2>&1; then echo '  ✓ Python detected'; elif [ -f package.json ] && grep -q 'express\\|fastify\\|nestjs' package.json 2>/dev/null; then echo '  ✓ Node.js backend detected'; else echo '  ℹ No specific backend detected'; fi", description="Detect backend technology")

@Bash(command="echo '🔍 Detecting frontend technology...' && if [ -f package.json ]; then if grep -q 'react' package.json 2>/dev/null; then echo '  ✓ React detected'; elif grep -q 'angular' package.json 2>/dev/null; then echo '  ✓ Angular detected'; elif grep -q 'vue' package.json 2>/dev/null; then echo '  ✓ Vue detected'; elif grep -q 'svelte' package.json 2>/dev/null; then echo '  ✓ Svelte detected'; else echo '  ℹ No specific frontend framework detected'; fi; elif [ -f angular.json ]; then echo '  ✓ Angular detected'; else echo '  ℹ No frontend detected'; fi", description="Detect frontend framework")

@Bash(command="echo '🔍 Checking for multi-tenancy...' && if grep -r 'OrganizationId\\|TenantId\\|multi.tenant\\|IMultiTenant' --include='*.cs' --include='*.ts' --include='*.js' --include='*.py' --include='*.go' --include='*.java' . 2>/dev/null | head -1 > /dev/null; then echo '  ✓ Multi-tenant patterns detected'; else echo '  ℹ No multi-tenancy detected'; fi", description="Check for multi-tenancy")

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "completed", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "in_progress", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "pending", "priority": "high", "id": "setup-5"}])

## Phase 3: Installation

Now I'll set up your Claude Code environment:

### Creating Directory Structure

@Bash(command="mkdir -p .claude/agents .claude/commands .claude/hooks .claude/generators", description="Create Claude Code directories")

### Fetching Components

<think about where to get the components from>

I'll use the claudify resources that were copied during setup:

@Bash(command="if [ -d .claudify ]; then echo '✅ Claudify resources found'; else echo '❌ CRITICAL: Missing .claudify directory!'; echo ''; echo 'The .claudify directory with source files is missing.'; echo 'This happens when:'; echo '  1. You installed with an older version of setup.ps1'; echo '  2. The .claudify directory was deleted'; echo '  3. You are in a different repository'; echo ''; echo 'To fix this:'; echo '  1. Download the latest Claudify from GitHub'; echo '  2. Run setup.ps1 with clean install option'; echo '  3. Then run /init-claudify again'; echo ''; echo 'Aborting installation...'; exit 1; fi", description="Check for claudify resources with detailed error")

Let me verify the temporary resources are complete:

@Bash(command="if [ ! -f .claudify/components-manifest.json ]; then echo '❌ Missing components manifest - setup.ps1 may need to be re-run'; exit 1; else echo '✅ Components manifest found'; fi", description="Verify manifest exists with error handling")

Now reading the components manifest:

@Read(file_path=".claudify/components-manifest.json")

### Installing Selected Components

Based on your selection, I'll now copy the components:

<think about which specific components to install based on the selection and detected tech stack>

#### Installing Commands Based on Setup Type

@Bash(command="echo 'Installing commands...'; mkdir -p .claude/commands; failed=0; setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; fi; echo \"  Setup: $setup_type\"; if [ \"$setup_type\" = 'comprehensive' ]; then cmds='comprehensive-review do-extensive-research quick-research create-command-and-or-agent update-changelog optimize-performance refactor-code analyze-test-quality generate-documentation analyze-technical-debt analyze-architecture analyze-security analyze-ux fix-all-bugs'; else cmds='comprehensive-review do-extensive-research quick-research create-command-and-or-agent update-changelog optimize-performance refactor-code'; fi; for cmd in $cmds; do if [ -f \".claudify/.claude/commands/${cmd}.md\" ]; then cp \".claudify/.claude/commands/${cmd}.md\" .claude/commands/ && echo \"  ✓ ${cmd}\"; else echo \"  ✗ ${cmd} (not found)\"; failed=$((failed+1)); fi; done; if [ $failed -gt 0 ]; then echo \"⚠️ WARNING: $failed commands could not be installed\"; else echo '✅ Commands installed successfully'; fi", description="Install commands based on setup type")

#### Installing Backend Components
@Bash(command="if ls *.csproj 1>/dev/null 2>&1 || ls **/*.csproj 1>/dev/null 2>&1 || [ -f go.mod ] || [ -f pom.xml ] || [ -f build.gradle ] || [ -f requirements.txt ] || ls *.py 1>/dev/null 2>&1 || ([ -f package.json ] && grep -q 'express\\|fastify\\|nestjs' package.json 2>/dev/null); then echo 'Installing backend components...'; failed=0; for cmd in 'add-backend-feature' 'fix-backend-bug' 'review-backend-code' 'fix-backend-build-and-tests'; do if [ -f \".claudify/.claude/commands/${cmd}.md\" ]; then cp \".claudify/.claude/commands/${cmd}.md\" .claude/commands/ && echo \"  ✓ ${cmd}\"; else echo \"  ✗ ${cmd} (not found)\"; failed=$((failed+1)); fi; done; if [ $failed -eq 0 ]; then echo '  ✓ All backend commands installed'; else echo \"  ⚠️ $failed backend commands missing\"; fi; else echo '  ℹ No backend detected - skipping backend components'; fi", description="Install backend components with error checking")

#### Installing Frontend Components
@Bash(command="if [ -f package.json ] && grep -q 'react\|angular\|vue\|next\|nuxt\|svelte' package.json || [ -f angular.json ]; then echo 'Installing frontend components...'; failed=0; for cmd in 'add-frontend-feature' 'fix-frontend-bug' 'review-frontend-code' 'fix-frontend-build-and-tests'; do if [ -f \".claudify/.claude/commands/${cmd}.md\" ]; then cp \".claudify/.claude/commands/${cmd}.md\" .claude/commands/ && echo \"  ✓ ${cmd}\"; else echo \"  ✗ ${cmd} (not found)\"; failed=$((failed+1)); fi; done; if [ -f '.claudify/.claude/agents/frontend-developer.md' ]; then cp '.claudify/.claude/agents/frontend-developer.md' .claude/agents/ && echo '  ✓ frontend-developer agent'; else echo '  ✗ frontend-developer agent (not found)'; failed=$((failed+1)); fi; if [ $failed -eq 0 ]; then echo '  ✓ All frontend components installed'; else echo \"  ⚠️ $failed frontend components missing\"; fi; else echo '  ℹ No frontend framework detected - skipping frontend components'; fi", description="Install frontend components with error checking")

#### Installing Agents Based on Setup Type

@Bash(command="echo 'Installing agents...'; mkdir -p .claude/agents; failed=0; setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; fi; if [ \"$setup_type\" = 'comprehensive' ]; then agents='code-reviewer tech-lead researcher code-simplifier technical-debt-analyst test-quality-analyst infrastructure-architect ux-reviewer business-domain-analyst legacy-system-analyzer visual-designer security-reviewer frontend-developer'; else agents='code-reviewer tech-lead researcher code-simplifier technical-debt-analyst test-quality-analyst'; fi; for agent in $agents; do if [ -f \".claudify/.claude/agents/${agent}.md\" ]; then cp \".claudify/.claude/agents/${agent}.md\" .claude/agents/ && echo \"  ✓ ${agent}\"; else echo \"  ✗ ${agent} (not found)\"; failed=$((failed+1)); fi; done; if [ $failed -gt 0 ]; then echo \"⚠️ WARNING: $failed agents could not be installed\"; else echo '✅ Agents installed successfully'; fi", description="Install agents based on setup type")

#### Installing Security Components
@Bash(command="if grep -r 'OrganizationId\|TenantId\|multi.tenant\|IMultiTenant' --include='*.cs' --include='*.ts' --include='*.js' . 2>/dev/null | head -1 > /dev/null; then echo 'Multi-tenancy detected - installing security components...'; cp '.claudify/.claude/agents/security-reviewer.md' .claude/agents/ 2>/dev/null; cp '.claudify/.claude/hooks/check-tenant-scoping.ps1' .claude/hooks/ 2>/dev/null; echo 'Security components installed'; else echo 'No multi-tenancy detected - skipping security components'; fi", description="Conditionally install security components")

#### Installing Generators and Tools

@Bash(command="setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; fi; if [ \"$setup_type\" = 'standard' -o \"$setup_type\" = 'comprehensive' ]; then echo 'Installing generators...'; mkdir -p .claude/generators; cp '.claudify/templates/generators/command-generator.ps1' .claude/generators/ 2>/dev/null && echo '  ✓ command-generator'; cp '.claudify/templates/generators/agent-generator.ps1' .claude/generators/ 2>/dev/null && echo '  ✓ agent-generator'; cp '.claudify/templates/generators/hook-generator.ps1' .claude/generators/ 2>/dev/null && echo '  ✓ hook-generator'; cp '.claudify/templates/META-GENERATOR-README.md' .claude/generators/README.md 2>/dev/null && echo '  ✓ documentation'; fi", description="Conditionally install generators")

#### Installing Agent Tools

@Bash(command="setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; fi; if [ \"$setup_type\" = 'comprehensive' ]; then echo 'Installing agent tools...'; mkdir -p .claude/agent-tools; cp -r '.claudify/.claude/agent-tools/security-reviewer' .claude/agent-tools/ 2>/dev/null && echo '  ✓ security-reviewer tools'; cp -r '.claudify/.claude/agent-tools/technical-debt-analyst' .claude/agent-tools/ 2>/dev/null && echo '  ✓ technical-debt tools'; cp -r '.claudify/.claude/agent-tools/infrastructure-architect' .claude/agent-tools/ 2>/dev/null && echo '  ✓ infrastructure tools'; cp '.claudify/.claude/agent-tools/agent-tools-config.json' .claude/agent-tools/ 2>/dev/null && echo '  ✓ config'; else echo 'Skipping agent tools (not comprehensive setup)'; fi", description="Conditionally install agent tools")

#### Installing Hooks

@Bash(command="setup_type='comprehensive'; if echo '$ARGUMENTS' | grep -q '\-\-standard'; then setup_type='standard'; fi; if [ \"$setup_type\" = 'standard' -o \"$setup_type\" = 'comprehensive' ]; then echo 'Installing hooks...'; mkdir -p .claude/hooks; cp '.claudify/.claude/hooks/add-context.ps1' .claude/hooks/ 2>/dev/null && echo '  ✓ add-context'; cp '.claudify/.claude/hooks/pre-commit-quality-check.ps1' .claude/hooks/ 2>/dev/null && echo '  ✓ pre-commit-quality'; cp '.claudify/.claude/hooks/check-changelog-updates.ps1' .claude/hooks/ 2>/dev/null && echo '  ✓ changelog-updates'; if [ \"$setup_type\" = 'comprehensive' ]; then cp '.claudify/.claude/hooks/validate-tenant-scoping.ps1' .claude/hooks/ 2>/dev/null && echo '  ✓ tenant-validation'; cp '.claudify/.claude/hooks/hooks-config.json' .claude/hooks/ 2>/dev/null && echo '  ✓ config'; cp '.claudify/.claude/hooks/install-hooks.ps1' .claude/hooks/ 2>/dev/null && echo '  ✓ installer'; fi; fi", description="Conditionally install hooks")

#### Installing Validation Tools
@Bash(command="mkdir -p .claude/validation", description="Create validation directory")
@Bash(command="cp '.claudify/.claude/validation/architecture-validator.ps1' .claude/validation/", description="Copy architecture validator")
@Bash(command="cp '.claudify/.claude/validation/code-quality-validator.ps1' .claude/validation/", description="Copy code quality validator")
@Bash(command="cp '.claudify/.claude/validation/test-coverage-analyzer.ps1' .claude/validation/", description="Copy test coverage analyzer")

#### Installing Documentation Templates
@Bash(command="mkdir -p .claude/templates/documentation", description="Create documentation templates directory")
@Bash(command="cp '.claudify/.claude/templates/documentation/*.template' .claude/templates/documentation/", description="Copy documentation templates")
@Bash(command="cp '.claudify/.claude/templates/documentation/documentation-generator.ps1' .claude/templates/documentation/", description="Copy documentation generator")
@Bash(command="cp '.claudify/.claude/templates/documentation/template-config.json' .claude/templates/documentation/", description="Copy template configuration")

#### Copying Additional Resources
@Bash(command="cp '.claudify/.claude/COMMAND-AGENT-DESIGN-GUIDELINES.md' .claude/", description="Copy design guidelines")

### Verifying Installation

@Bash(command="echo && echo '📊 Installation Summary:' && echo '========================' && cmd_count=$(ls .claude/commands/*.md 2>/dev/null | wc -l); echo \"✓ Commands installed: $cmd_count\"; agent_count=$(ls .claude/agents/*.md 2>/dev/null | wc -l); echo \"✓ Agents installed: $agent_count\"; gen_count=$(ls .claude/generators/*.ps1 2>/dev/null | wc -l); echo \"✓ Generators installed: $gen_count\"; tool_count=$(find .claude/agent-tools -type f 2>/dev/null | wc -l); echo \"✓ Agent tools installed: $tool_count\"; hook_count=$(ls .claude/hooks/*.ps1 2>/dev/null | wc -l); echo \"✓ Hooks installed: $hook_count\"; val_count=$(ls .claude/validation/*.ps1 2>/dev/null | wc -l); echo \"✓ Validation tools: $val_count\"; echo; success=true; if [ $cmd_count -eq 0 ]; then echo '❌ CRITICAL: No commands were installed!'; echo '   The .claudify directory may be missing or incomplete.'; echo '   Please re-run setup.ps1 with the latest version.'; success=false; fi; if [ $agent_count -eq 0 ]; then echo '❌ CRITICAL: No agents were installed!'; echo '   This will severely limit Claude Code functionality.'; success=false; fi; if [ \"$success\" = false ]; then echo ''; echo '🔧 To fix this issue:'; echo '1. Download latest Claudify from GitHub'; echo '2. Run: .\\setup.ps1 -TargetRepository \"$(pwd)\"'; echo '3. Choose clean install when prompted'; echo '4. Run /init-claudify again'; fi", description="Verify installation with detailed troubleshooting")

### Managing CLAUDE.md

Let me check if CLAUDE.md already exists:

@Bash(command="echo ''; if [ -f CLAUDE.md ]; then echo '📄 CLAUDE.md already exists'; echo '   Size: $(wc -l CLAUDE.md | awk \'{print $1}\') lines'; echo '   Modified: $(stat -c %y CLAUDE.md 2>/dev/null || stat -f %Sm CLAUDE.md 2>/dev/null || echo \"unknown\")'; echo ''; echo 'Choose action for CLAUDE.md:'; echo '  [K] Keep existing file (default)'; echo '  [U] Update with new template'; echo '  [V] View current file'; echo ''; echo -n 'Your choice [K/U/V]: '; if [ -t 0 ] && [ \"${CI:-false}\" != \"true\" ] && [ \"${GITHUB_ACTIONS:-false}\" != \"true\" ] && [ \"${JENKINS_HOME:-}\" = \"\" ]; then read -r claude_choice; else echo '(Auto-keeping in non-interactive mode)'; claude_choice='k'; fi; claude_choice=$(echo \"${claude_choice:-k}\" | tr '[:upper:]' '[:lower:]'); case \"$claude_choice\" in u) echo 'Will update CLAUDE.md with new template'; UPDATE_CLAUDE=true;; v) echo ''; echo '=== Current CLAUDE.md (first 20 lines) ==='; head -20 CLAUDE.md; echo '=== End preview ==='; echo ''; exec bash -c \"$0\";; *) echo 'Keeping existing CLAUDE.md'; UPDATE_CLAUDE=false;; esac; else echo 'CLAUDE.md not found - will create new one'; UPDATE_CLAUDE=true; fi; export UPDATE_CLAUDE", description="Interactive prompt for existing CLAUDE.md")

@Bash(command="if [ \"$UPDATE_CLAUDE\" = \"true\" ]; then if [ -f CLAUDE.md ]; then echo 'Backing up existing CLAUDE.md...'; cp CLAUDE.md \"CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)\"; fi; echo 'Creating new CLAUDE.md...'; cat > CLAUDE.md << 'EOF'
# CLAUDE.md - Project Configuration

## 🧠 CONTEXT
**System**: [Your detected project type]
**Stack**: [Your detected tech stack]
**Domain**: [Your business domain]

## ⚡ CRITICAL RULES

### Architecture
- [Your detected patterns and rules]
- [Multi-tenancy rules if applicable]
- [Framework-specific guidelines]

### Development Workflow
1. Backend first: Model → Repository → Service → API
2. Update FEATURES.md immediately
3. Frontend last: Only for existing APIs
4. Test business logic (80% target)

## 💻 CODE PATTERNS

[Your specific code patterns based on analysis]

## 🔒 SECURITY CHECKLIST
- [ ] [Your security requirements]
- [ ] [Multi-tenant isolation if applicable]
- [ ] [Authentication/authorization patterns]

## 🔍 QUICK REFERENCE

### Key Commands
- \`/add-backend-feature\` - Create new backend features
- \`/fix-backend-bug\` - Debug backend issues
- \`/comprehensive-review\` - Full code review
- \`/do-extensive-research\` - Deep technical analysis

---
**Remember**: [Your key principle based on domain]
EOF
else echo 'Preserved existing CLAUDE.md'; fi", description="Create CLAUDE.md only if it doesn't exist")

### Managing FEATURES.md

Let me check if FEATURES.md already exists:

@Bash(command="echo ''; if [ -f FEATURES.md ]; then echo '📄 FEATURES.md already exists'; echo '   Size: $(wc -l FEATURES.md | awk \'{print $1}\') lines'; echo '   Modified: $(stat -c %y FEATURES.md 2>/dev/null || stat -f %Sm FEATURES.md 2>/dev/null || echo \"unknown\")'; echo ''; echo 'Choose action for FEATURES.md:'; echo '  [K] Keep existing file (default)'; echo '  [U] Update with new template'; echo '  [V] View current file'; echo ''; echo -n 'Your choice [K/U/V]: '; if [ -t 0 ] && [ \"${CI:-false}\" != \"true\" ] && [ \"${GITHUB_ACTIONS:-false}\" != \"true\" ] && [ \"${JENKINS_HOME:-}\" = \"\" ]; then read -r features_choice; else echo '(Auto-keeping in non-interactive mode)'; features_choice='k'; fi; features_choice=$(echo \"${features_choice:-k}\" | tr '[:upper:]' '[:lower:]'); case \"$features_choice\" in u) echo 'Will update FEATURES.md with new template'; UPDATE_FEATURES=true;; v) echo ''; echo '=== Current FEATURES.md (first 20 lines) ==='; head -20 FEATURES.md; echo '=== End preview ==='; echo ''; exec bash -c \"$0\";; *) echo 'Keeping existing FEATURES.md'; UPDATE_FEATURES=false;; esac; else echo 'FEATURES.md not found - will create new one'; UPDATE_FEATURES=true; fi; export UPDATE_FEATURES", description="Interactive prompt for existing FEATURES.md")

@Bash(command="if [ \"$UPDATE_FEATURES\" = \"true\" ]; then if [ -f FEATURES.md ]; then echo 'Backing up existing FEATURES.md...'; cp FEATURES.md \"FEATURES.md.backup.$(date +%Y%m%d_%H%M%S)\"; fi; echo 'Creating new FEATURES.md...'; cat > FEATURES.md << 'EOF'
# Features Documentation

## Overview

[Your project description]

## System Architecture

### Technology Stack
- Backend: [Detected backend]
- Frontend: [Detected frontend]
- Database: [Your database]
- Infrastructure: [Your infrastructure]

### Architectural Patterns
[Your detected patterns]

---

## Core Features

### Feature 1: [Name]
- Description: [What it does]
- API Endpoints: [List endpoints]
- Business Rules: [Key rules]

---

## Planned Features

1. [Feature Name] - [Brief description]
2. [Feature Name] - [Brief description]

---

*Last updated: [Today's date]*
EOF
else echo 'Preserved existing FEATURES.md'; fi", description="Create FEATURES.md only if it doesn't exist")

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "completed", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "completed", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "completed", "priority": "high", "id": "setup-5"}])

### Keeping Claudify Resources for Future Updates

The `.claudify` directory will remain in your repository (excluded from git via .gitignore) to allow for:
- Re-running `/init-claudify` with different configurations
- Updating components when new versions are available
- Switching between standard/comprehensive setups

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "completed", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "completed", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "completed", "priority": "high", "id": "setup-5"}])

## ✅ Setup Complete!

Your Claude Code environment is now configured for your project

### What I've Set Up:
1. **Custom CLAUDE.md** - Tailored instructions for your project
2. **Specialized Agents** - Experts for your tech stack
3. **Domain Commands** - Tools specific to your needs
4. **Project Templates** - FEATURES.md and settings
5. **Generators** - For creating custom components

### Next Steps:
1. Review `CLAUDE.md` for accuracy
2. Update `FEATURES.md` with your actual features
3. Try `/add-backend-feature` to create your first feature
4. Use `/comprehensive-review` for code quality checks
5. Run `/help` to see all available commands

### Available Commands:

<think about which commands were installed based on the selection>

**Backend Commands** (if backend detected):
- `/add-backend-feature` - Create new backend features with DDD
- `/fix-backend-bug` - Debug and fix backend issues
- `/review-backend-code` - Backend code quality review
- `/fix-backend-build-and-tests` - Fix build and test failures

**Frontend Commands** (if frontend detected):
- `/add-frontend-feature` - Create UI features with excellence
- `/fix-frontend-bug` - Debug UI issues systematically
- `/review-frontend-code` - Frontend code review with UX focus
- `/fix-frontend-build-and-tests` - Fix frontend build issues

**Quality & Analysis Commands**:
- `/comprehensive-review` - Multi-agent comprehensive review
- `/analyze-technical-debt` - Identify and prioritize tech debt
- `/do-extensive-research` - Deep technical research
- `/quick-research` - Quick focused analysis
- `/generate-documentation` - Create comprehensive documentation
- `/update-changelog` - Update CHANGELOG.md with recent changes

**Validation & Testing Commands**:
- `.claude/validation/architecture-validator.ps1` - Validate architectural compliance
- `.claude/validation/code-quality-validator.ps1` - Analyze code quality metrics
- `.claude/validation/test-coverage-analyzer.ps1` - Measure test coverage

**Infrastructure Commands**:
- Deploy analysis with infrastructure architect agent
- Cost optimization recommendations
- Performance baseline generation

**Meta Commands**:
- `/create-command-and-or-agent` - Create custom components
- `/sync-to-templates` - Share improvements back to claudify

**Hooks (Auto-activated)**:
- `add-context` - Enriches your prompts with project context
- `pre-commit-quality-check` - Validates code before commits
- `validate-tenant-scoping` - Ensures multi-tenant isolation (if applicable)

Happy coding with Claude Code! 🚀

### Troubleshooting

If you encounter issues:
1. Ensure the .claudify directory exists (created by setup.ps1)
2. Check file permissions in .claude directory
3. Re-run `/init-claudify` to reconfigure your setup
4. The .claudify directory persists to allow updates - no manual cleanup needed
5. Report issues at the claudify repository

### Re-running Setup

You can safely re-run `/init-claudify` at any time to:
- Change your setup mode (standard/comprehensive)
- Update to newer versions of components
- Add components after initial setup
- Refresh your configuration

The .claudify directory contains all available components and will remain in your repository for future use.