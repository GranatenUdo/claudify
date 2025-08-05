---
description: Manage Claude Code agents - create, list, edit, and test specialized AI agents
allowed-tools: [Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, Bash]
argument-hint: "list | create <name> | edit <name> | test <name> | share <name>"
complexity: simple
estimated-time: 1-10 minutes
category: utility
---

# 🤖 Agent Management: $ARGUMENTS

## Quick Context
Manage your Claude Code agents following best practices for focused, single-purpose sub-agents with appropriate tool access.

## Command Options
- `list` - Show all available agents with their roles and tools
- `create <name>` - Create a new agent with interactive wizard
- `edit <name>` - Modify an existing agent
- `test <name>` - Test agent functionality
- `share <name>` - Share agent with team (version control)

<think about which agent operation to perform based on the arguments>

## Parsing Command Arguments

Let me understand what you want to do with agents.

@TodoWrite(todos=[
  {id: "1", content: "Parse agent command arguments", status: "in_progress", priority: "high"},
  {id: "2", content: "Execute requested agent operation", status: "pending", priority: "high"},
  {id: "3", content: "Validate agent configuration", status: "pending", priority: "high"}
])

### Determining Operation

Based on your input: **$ARGUMENTS**

## Agent Operations

### List All Agents

<if arguments contain "list" or are empty>

#### 📋 Available Agents

Let me scan for all available agents in your project:

@Glob(pattern=".claude/agents/*.md")
@Glob(pattern=".claude/agent-configs/*.json")

Now let me provide a formatted list with details:

@Bash(command="echo ''; echo '🤖 PROJECT AGENTS'; echo '================'; for f in .claude/agents/*.md; do if [ -f \"$f\" ]; then name=$(basename \"$f\" .md); echo \"\"; echo \"📌 $name\"; head -20 \"$f\" | grep -E '^name:|^description:|^tools:' -A1 | sed 's/^/  /'; fi; done; echo ''; echo '✅ Total agents found: '$(ls -1 .claude/agents/*.md 2>/dev/null | wc -l)", description="List all agents with details")

#### Agent Analysis

@Task(description="Analyze agent configurations", prompt="Review all agents in the project and provide:
1. Agent inventory with roles and specializations
2. Tool access analysis - identify over-privileged agents
3. Naming convention compliance check
4. Missing standard agents (based on project type)
5. Recommendations for improvement

Focus on Claude Code best practices:
- Single, clear responsibilities
- Limited tool access
- Simple naming conventions
- Version control readiness", subagent_type="general-purpose")

</if>

### Create New Agent

<if arguments contain "create">

#### 🛠️ Creating New Agent: $ARGUMENTS

Let me help you create a new agent following Claude Code best practices.

##### Step 1: Agent Profile

```markdown
## Agent Configuration Wizard

Please provide the following information:

1. **Agent Name** (lowercase-hyphenated): ___________
   Examples: code-reviewer, security-analyst, test-engineer

2. **Display Name**: ___________
   Examples: Code Reviewer, Security Analyst, Test Engineer

3. **Primary Role**: ___________
   Options: quality, security, development, testing, research, architecture

4. **Description** (one line): ___________
   Example: "Expert code reviewer focusing on multi-tenant security"

5. **Specializations** (comma-separated): ___________
   Examples: multi-tenant, performance, accessibility, cloud-native
```

##### Step 2: Tool Selection (Principle of Least Privilege)

Based on the agent's role, here are recommended tools:

```yaml
# Core Tools (usually needed)
- Read      # Read files and documentation
- Grep      # Search for patterns
- Glob      # Find files
- LS        # Navigate directories

# Modification Tools (only if needed)
- Edit      # Modify single files
- MultiEdit # Modify multiple files
- Write     # Create new files

# Execution Tools (restrict carefully)
- Bash      # Run commands (security risk)

# Research Tools (for analysis agents)
- WebSearch # Search internet
- WebFetch  # Fetch web content

# Management Tools (for planning agents)
- TodoWrite # Task management
- Task      # Delegate to other agents
```

##### Step 3: Agent Template

Let me create the agent file:

@Write(file_path=".claude/agents/[AGENT-NAME].md", content="---
name: [agent-name]
display_name: [Display Name]
description: [One-line description]
role: [primary-role]
specialization: [specialization-list]
tools:
  - Read
  - Grep
  - Glob
  - LS
  # Add only necessary tools
tool_justification:
  Read: \"Required to analyze code and documentation\"
  Grep: \"Required to search for patterns and issues\"
  Glob: \"Required to find relevant files\"
  LS: \"Required to navigate project structure\"
---

<think harder about [agent's domain] from multiple perspectives>

You are a specialized Claude Code agent focused on [specific responsibility].

## Your Expertise
- **Primary Focus**: [Main area of expertise]
- **Specializations**: [List key specializations]
- **Approach**: [How you work]

## Core Responsibilities
1. [Responsibility 1]
2. [Responsibility 2]
3. [Responsibility 3]

## Working Principles
- **Single Focus**: You concentrate solely on [your domain]
- **Best Practices**: You follow [relevant standards]
- **Collaboration**: You hand off to other agents when you encounter [out-of-scope items]

## Analysis Framework

### Phase 1: Initial Assessment
<think step-by-step about the task>
[Describe your analysis approach]

### Phase 2: Deep Analysis
[Describe your detailed review process]

### Phase 3: Recommendations
[Describe how you provide actionable feedback]

## Output Format
```markdown
# [Agent Type] Analysis

## Summary
[Brief overview]

## Findings
1. [Finding with severity and confidence]
2. [Finding with severity and confidence]

## Recommendations
1. [Actionable recommendation]
2. [Actionable recommendation]

## Handoff Suggestions
- If [condition], recommend [other-agent]
```

## Collaboration Protocol
When you encounter issues outside your expertise:
- Security concerns → security-analyst
- Architecture questions → tech-lead
- Performance issues → performance-analyst
- UI/UX matters → frontend-dev

Remember: Focus on your specialization and maintain clear boundaries.")

##### Step 4: Agent Configuration

@Write(file_path=".claude/agent-configs/[AGENT-NAME].json", content="{
  \"name\": \"[agent-name]\",
  \"display_name\": \"[Display Name]\",
  \"description\": \"[One-line description]\",
  \"agent_type\": \"[agent-name]\",
  \"system_prompt_override\": \"file:.claude/agents/[agent-name].md\",
  \"max_thinking_tokens\": 32768
}")

</if>

### Edit Existing Agent

<if arguments contain "edit">

#### ✏️ Editing Agent: $ARGUMENTS

Let me help you edit an existing agent while maintaining best practices.

First, let me find the agent:

@Glob(pattern=".claude/agents/*$ARGUMENTS*.md")
@Read(file_path=".claude/agents/$ARGUMENTS.md")

Now I'll help you modify this agent. Key areas to consider:

1. **Tool Access Review** - Remove unnecessary tools
2. **Description Clarity** - Ensure single, clear purpose
3. **Naming Convention** - Follow lowercase-hyphenated format
4. **Specialization Focus** - Avoid scope creep

@Edit(file_path=".claude/agents/$ARGUMENTS.md", old_string="[CURRENT]", new_string="[UPDATED]")

</if>

### Test Agent

<if arguments contain "test">

#### 🧪 Testing Agent: $ARGUMENTS

Let me test the agent's functionality and compliance with best practices.

@Read(file_path=".claude/agents/$ARGUMENTS.md")

##### Running Agent Tests

1. **Configuration Validation**
@Bash(command="echo 'Checking agent configuration...'; if [ -f .claude/agents/$ARGUMENTS.md ]; then echo '✅ Agent file exists'; grep -E '^name:|^tools:|^description:' .claude/agents/$ARGUMENTS.md; else echo '❌ Agent not found'; fi", description="Validate agent configuration")

2. **Tool Access Audit**
@Task(description="Audit agent tool access", prompt="Review the $ARGUMENTS agent and verify:
1. Each tool in the tools list is justified
2. No unnecessary tools are included
3. Security-sensitive tools (Bash, Write) are properly justified
4. Tools match the agent's stated purpose
Provide a security assessment and recommendations", subagent_type="security-analyst")

3. **Functional Test**
@Task(description="Test agent functionality", prompt="Test the $ARGUMENTS agent by:
1. Giving it a typical task for its role
2. Verifying it stays within its defined scope
3. Checking if it properly hands off out-of-scope tasks
4. Assessing output quality and format
Provide a functionality report", subagent_type="general-purpose")

</if>

### Share Agent

<if arguments contain "share">

#### 🌐 Sharing Agent: $ARGUMENTS

Preparing agent for team collaboration:

1. **Version Control Check**
@Bash(command="cd .claude/agents && git status $ARGUMENTS.md", description="Check git status")

2. **Documentation Generation**
@Write(file_path=".claude/agents/README-$ARGUMENTS.md", content="# $ARGUMENTS Agent

## Overview
[Agent description]

## Usage
```bash
# Direct invocation
/use-agent $ARGUMENTS [task]

# In commands
@Task(description=\"[task]\", subagent_type=\"$ARGUMENTS\")
```

## Tool Access
[List tools and justifications]

## Collaboration
This agent hands off to:
- [agent-name] for [scenario]

## Version History
- v1.0.0 - Initial creation
- [Future versions]
")

3. **Team Sync**
@Bash(command="echo 'Preparing agent for team sharing...'; cd .claude && git add agents/$ARGUMENTS.md agent-configs/$ARGUMENTS.json && echo '✅ Agent staged for commit'", description="Stage agent for version control")

</if>

## Best Practices Summary

@TodoWrite(todos=[
  {id: "1", content: "Parse agent command arguments", status: "completed", priority: "high"},
  {id: "2", content: "Execute requested agent operation", status: "completed", priority: "high"},
  {id: "3", content: "Validate agent configuration", status: "completed", priority: "high"}
])

### 📚 Agent Development Guidelines

1. **Single Responsibility**: Each agent should do one thing well
2. **Limited Tools**: Only grant necessary tools (security principle)
3. **Clear Naming**: Use lowercase-hyphenated names
4. **Version Control**: Check agents into source control
5. **Documentation**: Include usage examples and handoff patterns
6. **Testing**: Validate before team deployment

### 🎯 Next Steps

Based on the operation performed:
- Review the agent configuration
- Test the agent with real tasks
- Share with team when ready
- Iterate based on feedback

Remember: Well-designed agents are focused, secure, and collaborative!

## Documentation Updates

<think about what documentation needs updating based on the changes made>

### Update Checklist
Based on the changes made, update these files:

1. **CHANGELOG.md** (Confidence: 95%)
   - Add entry under `[Unreleased]` section
   - Use appropriate section: Added/Changed/Fixed/Removed
   - Include technical details and user impact

2. **FEATURES.md** (If capabilities changed)
   - Document new or modified features
   - Update technical implementation details
   - Include usage examples

3. **CLAUDE.md** (If patterns/conventions introduced)
   - Document new code patterns
   - Update architectural decisions
   - Add domain-specific rules

### Quick Update Commands
```bash
# Automated changelog update
/update-changelog "$ARGUMENTS"

# Manual update template
### [Section]
- Description of change
  - Technical implementation details
  - User-facing impact
  - Breaking changes (if any)
```