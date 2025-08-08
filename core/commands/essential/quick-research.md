---
description: Perform focused research on specific technical topics or implementation approaches
allowed-tools: [Task, Read, WebSearch, TodoWrite]
argument-hint: research topic (e.g., "best practices for real-time agricultural data streaming")
agent-dependencies: [Researcher]
complexity: simple
estimated-time: 5-15 minutes
category: research
---

# 🔍 Quick Research: $ARGUMENTS

## Quick Context
Get rapid, focused insights on specific technical questions without the overhead of comprehensive analysis.

## Execution Flow
1. **Focused Research** - Targeted investigation of the specific topic
2. **Key Findings** - Summarized insights and recommendations
3. **Action Items** - Next steps based on findings

## Research Approach

<think step-by-step about the most efficient research strategy>

### Targeted Investigation
@Task(description="Quick research", prompt="Conduct focused research on $ARGUMENTS:
1. Find the most relevant and recent information
2. Identify best practices and common patterns
3. Note any warnings or pitfalls
4. Provide 3-5 key takeaways
5. Suggest practical next steps
Keep response concise and actionable", subagent_type="general-purpose")

### Quick Web Search
If needed for current information:
```
@WebSearch(query="$ARGUMENTS site:stackoverflow.com OR site:github.com OR site:docs.microsoft.com")
```

## Output Format

### Executive Summary
- **Topic**: $ARGUMENTS
- **Key Finding**: [Most important insight]
- **Recommendation**: [Primary action to take]

### Key Insights
1. [Finding 1]
2. [Finding 2]
3. [Finding 3]

### Resources
- [Link 1]: [Description]
- [Link 2]: [Description]

#
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

## Next Steps
- [ ] [Action 1]
- [ ] [Action 2]
- [ ] [Action 3]

This quick research provides focused insights without extensive analysis overhead.