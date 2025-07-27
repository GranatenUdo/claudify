# Command and Agent Design Guidelines for Opus 4

> **Version**: 1.0.0  
> **Last Updated**: 2025-01-27  
> **Model**: claude-opus-4-20250514  
> **Purpose**: Best practices for creating commands and agents that maximize Opus 4's capabilities

## 🧠 Core Principles

### 1. Leverage Extended Thinking
Opus 4 excels with extended reasoning. Design commands and agents that:
- Use `<think harder>` blocks for complex decisions
- Employ `<think step-by-step>` for systematic analysis
- Allow up to 65,536 thinking tokens for deep reasoning
- Place thinking blocks at critical decision points, not everywhere

### 2. Multi-Agent Collaboration
The most powerful solutions use multiple specialized agents:
- **Sequential**: For step-by-step workflows
- **Parallel**: For independent analyses to synthesize
- **Hierarchical**: For complex orchestration
- **Specialist Teams**: Combine domain experts for comprehensive solutions

### 3. Clear Intent Mapping
Commands should:
- Have descriptive, action-oriented names
- Include comprehensive usage examples
- Provide clear argument hints
- Estimate realistic completion times

## 📋 Command Design Best Practices

### Naming Conventions
```
Good: /analyze-deployment, /fix-security-vulnerabilities, /optimize-database-queries
Bad: /deploy, /fix, /check
```

### Command Structure Template
```markdown
# command-name

Brief description that explains value proposition.

## Usage
\`\`\`
/command-name [required] [--optional]
\`\`\`

## Examples
[3-5 concrete examples showing different use cases]

## Features
[Key capabilities, not implementation details]

## Process Flow
<think harder about the workflow>
[Step-by-step process description]

## Output
[What the user will receive]

## Integration
[How it works with other commands]
```

### Argument Design
- Required arguments: Core functionality
- Optional flags: Modify behavior
- Sensible defaults: Work out of the box
- Environment awareness: Adapt to context

### Error Handling
- Validate inputs early
- Provide helpful error messages
- Suggest corrections
- Gracefully degrade functionality

## 🤖 Agent Design Best Practices

### Persona Development
Create rich, believable experts:
```markdown
## Professional Background
- Specific roles and companies
- Years of experience (10-20 for senior experts)
- Certifications and achievements
- Published work or contributions

## Core Expertise
- Primary: 3-5 deep specializations
- Secondary: Supporting skills
- Emerging: Areas of growth

## Philosophy
"Quote that captures their approach"
- Core beliefs
- Methodologies
- Decision frameworks
```

### Agent Capabilities
- **Focused Expertise**: Deep rather than broad
- **Clear Boundaries**: What they won't do
- **Tool Proficiency**: Specific tools they use
- **Output Formats**: How they communicate

### Communication Style
- **Technical Experts**: Precise, detailed, example-rich
- **Business Strategists**: Executive summaries, ROI focus
- **Creative Professionals**: Visual, metaphorical, inspiring
- **Researchers**: Analytical, evidence-based, thorough

### Collaboration Patterns
```json
{
  "works_with": ["agent-1", "agent-2"],
  "handoff_points": ["after-analysis", "before-implementation"],
  "conflict_resolution": "defer-to-security",
  "synthesis_approach": "consensus-with-expertise-weighting"
}
```

## 🎯 Opus 4 Optimization Techniques

### 1. Thinking Token Allocation
```markdown
Simple tasks: Standard thinking
Complex analysis: <think harder>
Multi-step reasoning: <think step-by-step>
Critical decisions: Extended thinking with explicit reasoning
```

### 2. Context Management
- Provide focused context, not everything
- Use @ references for file content
- Summarize previous findings
- Chain reasoning across phases

### 3. Output Quality Optimization
- Request specific output formats
- Use structured data for complex results
- Provide examples of desired output
- Enable iterative refinement

### 4. Performance Patterns
```yaml
Fast Response:
  - Single agent
  - Focused task
  - Minimal thinking
  - Direct execution

Deep Analysis:
  - Multiple agents
  - Extended thinking
  - Parallel processing
  - Synthesis phase

Continuous:
  - Monitoring pattern
  - Incremental updates
  - State management
  - Progress tracking
```

## ⚡ Parallelization for Opus 4

### Why Parallelization Matters
Opus 4 supports parallel tool execution, enabling 40-60% performance improvements without quality sacrifice. Use parallelization to transform 30-minute analyses into 10-minute insights.

### Core Parallelization Patterns

#### 1. Parallel Agent Invocation
```markdown
# ✅ CORRECT: Single message, multiple agents
I'll analyze from multiple perspectives simultaneously:

@Task(description="UX analysis", prompt="...", subagent_type="UX Reviewer")
@Task(description="Security audit", prompt="...", subagent_type="Security Reviewer")
@Task(description="Performance review", prompt="...", subagent_type="Tech Lead")

Now synthesizing all findings...

# ❌ INCORRECT: Sequential messages
@Task(description="UX analysis", prompt="...", subagent_type="UX Reviewer")
[Wait for result]
@Task(description="Security audit", prompt="...", subagent_type="Security Reviewer")
```

#### 2. Batch File Operations
```markdown
# ✅ CORRECT: Parallel reads
Examining all configuration files:

@Read(file_path="package.json")
@Read(file_path="tsconfig.json")
@Read(file_path="angular.json")
@Glob(pattern="*.config.*", path="src/")

# ❌ INCORRECT: Sequential reads with waits
@Read(file_path="package.json")
[Process result]
@Read(file_path="tsconfig.json")
```

#### 3. Concurrent Searches
```markdown
# ✅ CORRECT: Multiple search patterns
Searching for various code issues:

@Grep(pattern="TODO|FIXME", path="src/", output_mode="content")
@Grep(pattern="console\\.log", path="src/", output_mode="files_with_matches")
@Grep(pattern="any\\s*//.*disable", path="src/", output_mode="content")

# ❌ INCORRECT: One search at a time
```

### Parallelization Decision Tree
```
Can operations run independently?
├─ YES → Can they share context?
│   ├─ YES → Parallel with shared prompt context
│   └─ NO → Parallel with independent contexts
└─ NO → Do they have a common dependency?
    ├─ YES → Batch after dependency resolution
    └─ NO → Keep sequential
```

### Quality Assurance in Parallel Workflows

#### 1. Context Preservation
```markdown
# Shared context for coherent analysis
CONTEXT = "Analyzing checkout feature for multi-tenant SaaS"

@Task(prompt=f"{CONTEXT}. Focus on UX accessibility...", ...)
@Task(prompt=f"{CONTEXT}. Review security isolation...", ...)
@Task(prompt=f"{CONTEXT}. Assess performance impact...", ...)
```

#### 2. Synthesis Requirements
- Always include synthesis phase after parallel operations
- Wait for all results before drawing conclusions
- Handle partial failures gracefully
- Cross-reference findings for conflicts

#### 3. Error Handling
```markdown
# Graceful degradation pattern
Results received: 5/6 agents completed
Missing: Performance analysis (timeout)

Proceeding with available insights...
```

### Performance Guidelines

#### When to Parallelize
- **Always**: Independent agent analyses
- **Always**: Multiple file reads/searches
- **Always**: Unrelated validation checks
- **Consider**: Batch similar operations
- **Avoid**: Dependent sequential steps

#### Expected Improvements
| Operation Type | Sequential | Parallel | Improvement |
|----------------|------------|----------|-------------|
| 6 Agent Analysis | 30 min | 10 min | 67% |
| 10 File Reads | 5 min | 1 min | 80% |
| 5 Search Patterns | 10 min | 2 min | 80% |
| Mixed Operations | 20 min | 8 min | 60% |

### Implementation Checklist
- [ ] Identify independent operations
- [ ] Group related parallel tasks
- [ ] Provide sufficient context in each prompt
- [ ] Include synthesis/correlation phase
- [ ] Handle partial results gracefully
- [ ] Test time improvements
- [ ] Validate quality maintenance

## 🛠️ Agent Tools Best Practices

### Tool Design Principles
1. **Single Responsibility**: One tool, one job
2. **Composable**: Work well together
3. **Fail Gracefully**: Handle errors elegantly
4. **Output Structured Data**: JSON/YAML preferred
5. **Cross-Platform**: PowerShell Core compatible

### Tool Categories
```
Analysis Tools:
- Input: Files, configurations
- Process: Validation, parsing, checking
- Output: Structured findings

Generation Tools:
- Input: Specifications, templates
- Process: Creation, transformation
- Output: Files, configurations

Integration Tools:
- Input: Multiple sources
- Process: Correlation, synthesis
- Output: Unified results
```

## 📊 Quality Metrics

### Command Success Criteria
- ✅ Completes primary task reliably
- ✅ Provides actionable output
- ✅ Handles edge cases gracefully
- ✅ Integrates with workflow
- ✅ Time estimate accurate ±20%

### Agent Effectiveness
- ✅ Expertise depth demonstrated
- ✅ Communication clarity high
- ✅ Collaboration smooth
- ✅ Output quality consistent
- ✅ Value delivery measurable

## 🎨 Design Patterns

### 1. Analyzer-Generator Pattern
```
/analyze-X command → findings → /generate-X command
Example: analyze-deployment → issues → fix-deployment
```

### 2. Multi-Phase Workflow
```
Phase 1: Discovery (parallel agents)
Phase 2: Analysis (specialized agents)
Phase 3: Synthesis (lead agent)
Phase 4: Implementation (execution agent)
```

### 3. Progressive Enhancement
```
Basic: Single agent, simple output
Enhanced: Multiple agents, detailed analysis
Advanced: Full workflow automation
```

### 4. Validation-First
```
1. Validate inputs
2. Check prerequisites
3. Confirm understanding
4. Execute with confidence
```

## 🚀 Advanced Techniques

### 1. Dynamic Agent Selection
Commands can choose agents based on:
- Input complexity
- Domain detection
- User preferences
- Available time

### 2. Recursive Improvement
```markdown
Initial analysis → Identify gaps → 
Deeper analysis → Refine findings → 
Generate solution → Validate → Iterate
```

### 3. Context-Aware Adaptation
- Detect project type
- Adjust for tech stack
- Respect conventions
- Learn from codebase

### 4. Intelligent Defaults
```python
def get_defaults(context):
    if context.is_production:
        return ProductionDefaults()
    elif context.is_testing:
        return TestDefaults()
    else:
        return DevelopmentDefaults()
```

## 📝 Documentation Standards

### Command Documentation
1. **Purpose**: Clear value proposition
2. **Usage**: Complete syntax guide
3. **Examples**: Real-world scenarios
4. **Features**: Capability overview
5. **Integration**: Ecosystem fit
6. **Limitations**: Honest boundaries

### Agent Documentation
1. **Persona**: Rich background
2. **Expertise**: Detailed capabilities
3. **Approach**: Methodology explanation
4. **Collaboration**: Team dynamics
5. **Output**: Deliverable formats
6. **Tools**: Technical arsenal

## 🔄 Evolution Strategy

### Continuous Improvement
1. **Usage Analytics**: Track effectiveness
2. **Error Patterns**: Learn from failures
3. **User Feedback**: Incorporate suggestions
4. **Model Updates**: Adapt to new capabilities
5. **Best Practice Evolution**: Stay current

### Version Management
```yaml
version: 1.0.0
compatibility:
  model: claude-opus-4-20250514
  min_model: claude-opus-4
  features:
    - extended_thinking
    - multi_agent
    - tool_use
```

## 🎯 Implementation Checklist

### For Commands
- [ ] Clear, action-oriented name
- [ ] Comprehensive documentation
- [ ] 3+ usage examples
- [ ] Error handling
- [ ] Time estimates
- [ ] Integration points defined
- [ ] Output format specified
- [ ] Agent selection logic

### For Agents
- [ ] Rich persona (200+ words)
- [ ] Specific expertise defined
- [ ] Communication style clear
- [ ] Collaboration patterns set
- [ ] Tool arsenal specified
- [ ] Output formats defined
- [ ] Philosophy articulated
- [ ] Example interactions

### For Tools
- [ ] Single responsibility
- [ ] Error handling
- [ ] Cross-platform compatible
- [ ] Structured output
- [ ] Documentation complete
- [ ] Integration tested
- [ ] Performance acceptable

## 🌟 Excellence Indicators

### Exceptional Commands
- Anticipate user needs
- Provide insights beyond request
- Enable workflows not just tasks
- Learn and improve over time
- Delight with thoughtful details

### Exceptional Agents
- Feel like real experts
- Provide unexpected value
- Collaborate naturally
- Communicate clearly
- Solve problems creatively

## 📚 References

### Model Capabilities
- Extended thinking: 65,536 tokens
- Context window: 200,000 tokens
- Tool use: Parallel execution
- Multi-agent: Native support

### Inspiration Sources
- UNIX philosophy: Do one thing well
- Domain-Driven Design: Ubiquitous language
- Microservices: Loose coupling
- DevOps: Automation first
- UX: User-centered design

---

**Remember**: The goal is not just to complete tasks, but to augment human capability in meaningful ways. Every command and agent should make complex work feel simple and expert knowledge accessible.