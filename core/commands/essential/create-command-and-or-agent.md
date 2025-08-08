---
description: Intelligently analyze requirements and generate optimized commands, agents, hooks, and tools that maximize Opus 4's capabilities through deep reasoning and multi-agent collaboration
allowed-tools: [Task, Read, Write, Edit, MultiEdit, Grep, Glob, LS, TodoWrite, WebSearch, WebFetch, Bash]
argument-hint: Describe what you want to achieve (e.g., "analyze database performance bottlenecks" or "validate accessibility compliance for React components")
agent-dependencies: [Researcher, Tech Lead, Code Reviewer, Security Reviewer]
complexity: complex
estimated-time: 30-45 minutes
category: meta-automation
opus4-optimization: maximum
---

# 🧠 Intelligent Command & Agent Generator

## OPUS 4 MAXIMUM ACTIVATION - META-REASONING MODE
<think harder about the fundamental nature of the request, its implications, and the optimal combination of components to achieve the goal>

**Meta Directive**: Analyze the user's intent deeply, research best practices exhaustively, and generate the optimal combination of commands, agents, hooks, and tools that fully leverage Opus 4's extended reasoning capabilities to solve complex problems elegantly.

## Phase 1: Deep Intent Analysis & Research

<think step-by-step about what the user really needs versus what they asked for>

### Intent Classification Engine
I'll analyze your request across multiple dimensions to understand the true need.

```yaml
Analysis Framework:
  Domain:
    - Technical: [backend|frontend|infrastructure|security|performance]
    - Business: [compliance|analytics|operations|strategy]
    - Process: [automation|validation|monitoring|documentation]
  
  Complexity:
    - Simple: Single-purpose utility command
    - Moderate: Command with supporting hooks
    - Complex: Multi-agent collaboration required
    - Meta: Requires custom agent with specialized tools
  
  Interaction:
    - One-shot: Execute and complete
    - Interactive: Multi-phase with user decisions
    - Continuous: Monitoring or ongoing analysis
    - Generative: Creates other artifacts
```

### Existing Pattern Research
@Task(description="Research patterns", prompt="Analyze existing commands and agents in .claude directory for:
1. Successful patterns and conventions
2. Multi-agent collaboration examples
3. Opus 4 optimization techniques (extended thinking, interleaved reasoning)
4. Hook integration patterns
5. Agent tool usage patterns
6. Common pitfalls to avoid
Synthesize best practices for: $ARGUMENTS", subagent_type="general-purpose")

### Domain Best Practices Investigation
@Task(description="Domain research", prompt="Research industry best practices for: $ARGUMENTS
1. Similar tools or solutions in the ecosystem
2. Common implementation patterns
3. Performance considerations
4. Security implications
5. User experience patterns
6. Future extensibility needs
Provide comprehensive recommendations", subagent_type="general-purpose")

## Phase 2: Component Architecture Design

<use maximum thinking depth to design the optimal component architecture>

### Multi-Agent Component Analysis

#### Tech Lead Architectural Review
@Task(description="Architecture design", prompt="Design component architecture for: $ARGUMENTS
1. Determine if this needs: command only, command + agents, or full suite
2. Define component boundaries and interactions
3. Specify data flow and state management
4. Identify integration points with existing tools
5. Plan for extensibility and maintenance
6. Consider performance and scalability
Provide detailed technical blueprint", subagent_type="general-purpose")

#### Security Component Requirements
@Task(description="Security design", prompt="Analyze security requirements for: $ARGUMENTS
1. Identify sensitive operations or data
2. Define authorization requirements
3. Specify audit trail needs
4. Design input validation strategies
5. Plan output sanitization
6. Consider multi-tenant implications
Provide security implementation guide", subagent_type="general-purpose")

### Component Decision Matrix

Based on agent analysis, I'll determine the optimal component mix:

```markdown
## Component Requirements Analysis

### Core Components Needed:
- [ ] **Command**: [Always required for user interface]
- [ ] **Agent(s)**: [If specialized expertise needed]
- [ ] **Hooks**: [If validation/enhancement required]
- [ ] **Agent Tools**: [If agents need custom scripts]
- [ ] **Agent Configs**: [If agents need MCP servers or special settings]

### Interaction Model:
- [ ] Single-phase execution
- [ ] Multi-phase with checkpoints
- [ ] Continuous monitoring
- [ ] Recursive generation

### Collaboration Pattern:
- [ ] Solo command execution
- [ ] Sequential agent collaboration
- [ ] Parallel agent analysis
- [ ] Hierarchical agent orchestration
```

## Phase 3: Intelligent Generation Engine

<think deeply about creating components that bring out the best in Opus 4>

### Command Generation Intelligence

```typescript
interface CommandMetadata {
  description: string;           // Clear, action-oriented
  allowedTools: Tool[];         // Minimal necessary set
  argumentHint: string;         // Helpful examples
  agentDependencies?: Agent[];  // If multi-agent needed
  complexity: 'simple' | 'moderate' | 'complex';
  estimatedTime: string;        // Realistic estimate
  category: Category;           // Proper classification
  opus4Features?: {
    extendedThinking: boolean;  // <think harder> blocks
    interleavedReasoning: boolean; // <think step-by-step>
    multiAgentSynthesis: boolean;  // Agent result integration
    recursiveAnalysis: boolean;    // Self-improvement loops
  };
}
```

### Agent Persona Engineering

```typescript
interface AgentPersona {
  experience: string;      // Years and specific domains
  philosophy: string;      // Core beliefs and approach
  expertise: {
    primary: string[];     // Core competencies
    secondary: string[];   // Supporting skills
    emerging: string[];    // Learning areas
  };
  personality: {
    traits: string[];      // Professional characteristics
    communication: string; // How they interact
    decisionMaking: string; // How they think
  };
  opus4Optimization: {
    thinkingTokens: number; // 65536 for complex reasoning
    reasoningPatterns: Pattern[]; // Specific thinking approaches
  };
}
```

### Hook Design Patterns

```powershell
# Intelligent hook structure
param(
    [string]$FilePath,
    [string]$ToolName,
    [string]$Arguments,
    [string]$Context      # Additional context from command
)

# Multi-level validation
function Test-Preconditions { }
function Enhance-Input { }
function Validate-Output { }
function Add-Metadata { }

# Conditional logic based on context
switch ($Context) {
    "security-critical" { }
    "performance-sensitive" { }
    "user-facing" { }
}
```

## Phase 4: Generation Execution

### Step 1: Generate Primary Command

Based on analysis, I'll create a command that:
- Uses Opus 4's extended thinking at critical decision points
- Orchestrates multi-agent collaboration effectively
- Provides interactive checkpoints for complex operations
- Includes comprehensive error handling and recovery
- Generates detailed audit trails and documentation

### Step 2: Generate Supporting Agents (if needed)

For each required agent:
1. **Persona Development**: Rich backstory and expertise
2. **Capability Definition**: Specific skills and tools
3. **Integration Design**: How it collaborates with others
4. **Output Specification**: Clear, actionable deliverables

### Step 3: Generate Hooks (if needed)

For each validation or enhancement point:
1. **Trigger Definition**: When the hook activates
2. **Validation Logic**: What it checks or enhances
3. **Failure Handling**: Graceful degradation
4. **Metadata Addition**: Context for downstream tools

### Step 4: Generate Agent Tools & Configs (if needed)

For specialized agent capabilities:
1. **Tool Scripts**: PowerShell/Bash for specific analysis
2. **Config Files**: MCP servers, restrictions, focus areas
3. **Integration Tests**: Verify tool functionality
4. **Documentation**: Usage and troubleshooting

## Phase 5: Template Integration

<think about sustainable maintenance and evolution>

### Template Generator Creation

I'll create a meta-generator for the templating solution that:

```powershell
# meta-generator.ps1
function Generate-IntelligentComponent {
    param(
        [string]$Type,        # command|agent|hook|tool|config
        [object]$Analysis,    # From Phase 1-2
        [object]$Metadata     # Additional context
    )
    
    # Intelligent generation based on analysis
    switch ($Type) {
        "command" { Generate-Opus4Command -Analysis $Analysis }
        "agent" { Generate-SpecializedAgent -Analysis $Analysis }
        "hook" { Generate-ValidationHook -Analysis $Analysis }
        "tool" { Generate-AgentTool -Analysis $Analysis }
        "config" { Generate-AgentConfig -Analysis $Analysis }
    }
}
```

### Integration with Existing Generators

Update existing generators to leverage meta-generator:
- command-generator.ps1: Import and use meta-generator
- agent-generator.ps1: Delegate to meta-generator
- hook-generator.ps1: Enhance with meta-generator

## Phase 6: Quality Assurance & Optimization

### Multi-Agent Review Process

#### Code Quality Review
@Task(description="Quality review", prompt="Review generated components for:
1. Code clarity and maintainability
2. Error handling completeness
3. Performance optimization opportunities
4. Documentation quality
5. Test coverage requirements
6. Integration smoothness
Provide improvement recommendations", subagent_type="general-purpose")

#### Opus 4 Optimization Review
@Task(description="Opus4 optimization", prompt="Analyze generated components for Opus 4 optimization:
1. Extended thinking usage effectiveness
2. Multi-agent collaboration efficiency
3. Reasoning pattern optimization
4. Token usage efficiency
5. Response quality maximization
6. User experience enhancement
Suggest optimizations", subagent_type="general-purpose")

## Phase 7: Delivery & Documentation

### Generated Component Summary

```markdown
## Generation Complete: [Component Name]

### Components Created:
1. **Command**: `/[command-name]` - [description]
2. **Agents**: [List of agents if created]
3. **Hooks**: [List of hooks if created]
4. **Tools**: [List of tools if created]
5. **Configs**: [List of configs if created]

### Key Features:
- [Feature 1]: [How it helps]
- [Feature 2]: [What it enables]
- [Feature 3]: [Why it's optimized]

### Usage Examples:
```bash
# Basic usage
/[command-name] "example input"

# Advanced usage with options
/[command-name] "complex scenario" --parallel --verbose
```

### Integration Points:
- Works with: [existing commands/agents]
- Enhances: [current capabilities]
- Enables: [new workflows]

### Opus 4 Optimizations:
- Extended thinking at: [critical points]
- Multi-agent synthesis for: [complex decisions]
- Interleaved reasoning in: [analysis phases]
```

## Phase 8: Continuous Improvement Loop

<think about how the generated components can self-improve>

### Feedback Integration
The generated components include:
1. **Usage Analytics**: Track effectiveness
2. **Error Patterns**: Learn from failures
3. **Performance Metrics**: Identify bottlenecks
4. **User Feedback**: Gather improvement ideas

### Evolution Strategy
```yaml
improvement_cycle:
  monitor:
    - usage_patterns
    - error_rates
    - performance_metrics
    - user_satisfaction
  
  analyze:
    - pattern_recognition
    - bottleneck_identification
    - opportunity_discovery
  
  enhance:
    - incremental_improvements
    - major_revisions
    - new_capabilities
```

## Meta-Command Benefits

This intelligent generator provides:

1. **Optimal Component Selection**: Not just what you asked for, but what you need
2. **Opus 4 Maximization**: Every component leverages advanced reasoning
3. **Sustainable Architecture**: Maintainable, extensible, evolvable
4. **Integrated Intelligence**: Components work together synergistically
5. **Continuous Learning**: Self-improving through usage patterns
6. **Time Efficiency**: Hours of manual work in minutes


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

### Parallel Documentation Check
Check all documentation files simultaneously for existing references:
```bash
@Grep(pattern="$ARGUMENTS", path="CHANGELOG.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="FEATURES.md", output_mode="content", head_limit=5)
@Grep(pattern="$ARGUMENTS", path="CLAUDE.md", output_mode="content", head_limit=5)
```

## Final Integration Checklist

- [ ] All components tested individually
- [ ] Integration tests passing
- [ ] Documentation complete
- [ ] Template generators updated
- [ ] Examples provided
- [ ] Performance benchmarked
- [ ] Security validated
- [ ] User experience polished
- [ ] **Synced to template repository** (automatic)

## Template Synchronization

<think about maintaining the templating solution synchronized>

### Automatic Sync
After creating components, they are automatically synchronized to the templating solution:
1. New commands copied to `claudify/.claude/commands/`
2. New agents copied to `claudify/.claude/agents/`
3. Related configurations and tools included
4. Template README updated with new components

### Manual Sync
For bulk synchronization or updates:
```bash
# Sync all components to templates
/sync-to-templates

# Preview what would be synced
/sync-to-templates --mode preview

# Force overwrite templates
/sync-to-templates --force
```

This ensures new projects always get the latest components!

---

**Remember**: This meta-command doesn't just generate code—it architects intelligent solutions that grow more capable over time. By deeply understanding intent, researching exhaustively, and leveraging Opus 4's full potential, it creates components that don't just work, but excel.