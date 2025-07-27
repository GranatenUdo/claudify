---
description: Initialize complete Claude Code setup for your repository with intelligent component selection
allowed-tools: [Task, Bash, Glob, Grep, LS, Read, Write, MultiEdit, TodoWrite]
argument-hint: business domain description (e.g., "multi-tenant SaaS for vineyard management")
complexity: high
estimated-time: 5-10 minutes
category: setup
---

# Initialize Claude Code Base Configuration

<think harder about how to intelligently set up Claude Code based on the repository analysis>

I'll analyze your repository and set up a complete Claude Code environment tailored to your project: **$ARGUMENTS**

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

Based on your project structure and the business domain "$ARGUMENTS", I'll determine the best components for your project.

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
- Commands: `comprehensive-review`, `do-extensive-research`, `quick-research`, `create-command-and-or-agent`
- Agents: `code-reviewer`
- Generators: All generator scripts

Would you like me to proceed with this setup? You can also choose:
- **[S]tandard** (Recommended) - Components based on your tech stack (~15-25 files)
- **[M]inimal** - Essential components only (~5-10 files)  
- **[C]omprehensive** - Everything available (~40+ files)
- **[Cu]stomize** - I'll show you all options to select from

Please enter your choice (S/M/C/Cu) or press Enter for Standard:

<wait for user input - default to 'S' if empty>

### Processing Selection

<think about the user's choice and determine components to install>

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "completed", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "in_progress", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "pending", "priority": "high", "id": "setup-5"}])

## Phase 3: Installation

Now I'll set up your Claude Code environment:

### Creating Directory Structure

@Bash(command="mkdir -p .claude/agents .claude/commands .claude/hooks .claude/generators", description="Create Claude Code directories")

### Fetching Components

<think about where to get the components from>

I need to locate the claudify directory. Let me check common locations:

@Bash(command="ls ~/.claudify/components-manifest.json 2>/dev/null || ls ~/claudify/components-manifest.json 2>/dev/null || echo 'Not in home directory'", description="Check home directory for claudify")

@Bash(command="find . -name '.claude' -type d -exec test -f {}/commands/init-claudify.md \; -print 2>/dev/null | grep -v '^\./.claude$' | head -1", description="Search current directory tree")

If I cannot find it automatically, please provide the full path to your claudify directory.
This is the directory where you cloned/downloaded claudify and ran setup.ps1 from.

**Enter claudify path (or press Enter if found above):**

<wait for user input or use found path>

Verifying the claudify directory:

@Bash(command="test -f '[CLAUDIFY_PATH]/components-manifest.json' && echo '✅ Valid claudify directory' || echo '❌ Invalid path - missing components-manifest.json'", description="Verify claudify path")

If the path is invalid, I'll stop here. Please run this command again with the correct claudify path.

Now reading the components manifest:

@Read(file_path="[CLAUDIFY_PATH]/components-manifest.json")

### Installing Selected Components

Based on your selection, I'll now copy the components:

<think about which specific components to install based on the selection and detected tech stack>

#### Installing Core Commands
These essential commands will be installed for all projects:

@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/comprehensive-review.md' .claude/commands/", description="Copy comprehensive review command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/do-extensive-research.md' .claude/commands/", description="Copy extensive research command")  
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/quick-research.md' .claude/commands/", description="Copy quick research command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/create-command-and-or-agent.md' .claude/commands/", description="Copy meta-generator command")

#### Installing Backend Components (if backend detected)
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/add-backend-feature.md' .claude/commands/", description="Copy add backend feature command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/fix-backend-bug.md' .claude/commands/", description="Copy fix backend bug command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/review-backend-code.md' .claude/commands/", description="Copy review backend code command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/fix-backend-build-and-tests.md' .claude/commands/", description="Copy fix backend build command")

#### Installing Frontend Components (if frontend detected)
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/add-frontend-feature.md' .claude/commands/", description="Copy add frontend feature command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/fix-frontend-bug.md' .claude/commands/", description="Copy fix frontend bug command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/review-frontend-code.md' .claude/commands/", description="Copy review frontend code command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/commands/fix-frontend-build-and-tests.md' .claude/commands/", description="Copy fix frontend build command")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/agents/frontend-developer.md' .claude/agents/", description="Copy frontend developer agent")

#### Installing Essential Agents
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/agents/code-reviewer.md' .claude/agents/", description="Copy code reviewer agent")

#### Installing Security Components (if multi-tenant detected)
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/agents/security-reviewer.md' .claude/agents/", description="Copy security reviewer agent")
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/hooks/check-tenant-scoping.ps1' .claude/hooks/", description="Copy tenant scoping validation hook")

#### Installing Generators
@Bash(command="mkdir -p .claude/generators", description="Create generators directory")
@Bash(command="cp '[CLAUDIFY_PATH]/templates/generators/command-generator.ps1' .claude/generators/", description="Copy command generator")
@Bash(command="cp '[CLAUDIFY_PATH]/templates/generators/agent-generator.ps1' .claude/generators/", description="Copy agent generator")
@Bash(command="cp '[CLAUDIFY_PATH]/templates/generators/hook-generator.ps1' .claude/generators/", description="Copy hook generator")
@Bash(command="cp '[CLAUDIFY_PATH]/templates/META-GENERATOR-README.md' .claude/generators/README.md", description="Copy generator documentation")

#### Copying Additional Resources
@Bash(command="cp '[CLAUDIFY_PATH]/.claude/COMMAND-AGENT-DESIGN-GUIDELINES.md' .claude/", description="Copy design guidelines")

### Verifying Installation

@Bash(command="echo 'Components installed:' && echo '- Commands: '$(ls .claude/commands/*.md 2>/dev/null | wc -l) && echo '- Agents: '$(ls .claude/agents/*.md 2>/dev/null | wc -l) && echo '- Generators: '$(ls .claude/generators/*.ps1 2>/dev/null | wc -l)", description="Count installed components")

### Generating CLAUDE.md

Based on my analysis, I'll create a customized CLAUDE.md for your project:

@Write(file_path="CLAUDE.md", content=`# CLAUDE.md - $ARGUMENTS

## 🧠 CONTEXT
**System**: [Your detected project type]
**Stack**: [Your detected tech stack]
**Domain**: $ARGUMENTS

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
`)

### Generating FEATURES.md Template

@Write(file_path="FEATURES.md", content=`# $ARGUMENTS - Features Documentation

## Overview

[Your project description based on domain: $ARGUMENTS]

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
`)

@TodoWrite(todos=[{"content": "Detect backend technology", "status": "completed", "priority": "high", "id": "setup-1"}, {"content": "Detect frontend framework", "status": "completed", "priority": "high", "id": "setup-2"}, {"content": "Analyze architecture patterns", "status": "completed", "priority": "high", "id": "setup-3"}, {"content": "Install appropriate components", "status": "completed", "priority": "high", "id": "setup-4"}, {"content": "Generate documentation", "status": "completed", "priority": "high", "id": "setup-5"}])

## ✅ Setup Complete!

Your Claude Code environment is now configured for: **$ARGUMENTS**

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

**Meta Commands**:
- `/create-command-and-or-agent` - Create custom components
- `/sync-to-templates` - Share improvements back to claudify

Happy coding with Claude Code! 🚀

### Troubleshooting

If you encounter issues:
1. Ensure the claudify path is correct
2. Check file permissions in .claude directory
3. Re-run this command with the correct path
4. Report issues at the claudify repository