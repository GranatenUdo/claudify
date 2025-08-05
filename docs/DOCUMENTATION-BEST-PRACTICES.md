# Documentation Best Practices for Claudify

This guide captures the best practices learned from implementing documentation update instructions across all Claudify commands and agents.

## Core Principles

### 1. Documentation as Code
Treat documentation with the same rigor as code:
- Version control all documentation
- Review documentation changes in PRs
- Automate where possible
- Test documentation accuracy

### 2. Intelligent Automation
Leverage Opus 4's capabilities:
- Use `<think>` tags for context-aware decisions
- Implement confidence scoring for prioritization
- Utilize parallel processing for efficiency
- Reference automation tools like `/update-changelog`

### 3. Consistency Through Templates
Maintain uniformity across all components:
- Standard templates for commands and agents
- Consistent formatting and structure
- Clear section headers and organization
- Predictable user experience

## Implementation Guidelines

### For New Commands

When creating a new command, always include:

```markdown
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
```

### For New Agents

When creating a new agent, always include:

```markdown
## Documentation Reminders

<think about what documentation updates the implemented changes require>

When your analysis leads to implemented changes, ensure proper documentation:

### Documentation Checklist (Confidence Scoring)
- **CHANGELOG.md** - Update if changes implemented (Confidence: [X]%)
- **FEATURES.md** - Update if capabilities added/modified (Confidence: [X]%)
- **CLAUDE.md** - Update if patterns/conventions introduced (Confidence: [X]%)

### Recommended Updates
Based on the changes suggested:

1. **For Bug Fixes**: 
   ```markdown
   /update-changelog "Fixed [issue description]"
   ```

2. **For New Features**:
   ```markdown
   /update-changelog "Added [feature description]"
   ```

3. **For Refactoring**:
   ```markdown
   /update-changelog "Changed [component] to [improvement]"
   ```

### Important
- Use confidence scores to prioritize documentation updates
- High confidence (>90%) = Critical to document
- Medium confidence (70-90%) = Should document
- Low confidence (<70%) = Consider documenting

**Remember**: Well-documented changes help the entire team understand system evolution!
```

## Confidence Scoring Guidelines

### How to Assign Confidence Scores

**95-100% Confidence**
- Direct code changes implemented
- Clear user-facing impact
- Measurable improvements
- Breaking changes

**85-94% Confidence**
- Significant refactoring
- Performance optimizations
- Security enhancements
- API modifications

**70-84% Confidence**
- Internal improvements
- Code cleanup
- Test additions
- Documentation updates

**Below 70% Confidence**
- Exploratory changes
- Experimental features
- Minor tweaks
- Style changes

## Documentation File Guidelines

### CHANGELOG.md
Follow [Keep a Changelog](https://keepachangelog.com/) format:
- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Vulnerability fixes

### FEATURES.md
Document capabilities and usage:
- Feature name and description
- Technical implementation details
- Configuration options
- Usage examples
- API references

### CLAUDE.md
Capture patterns and conventions:
- Coding patterns
- Architectural decisions
- Domain-specific rules
- Team conventions
- Best practices

## Automation Best Practices

### Use `/update-changelog` Command
- Always reference in documentation sections
- Provide example usage with actual arguments
- Show both automated and manual options

### Parallel Processing
Leverage Opus 4's parallel capabilities:
```bash
# Check all files simultaneously
@Grep(pattern="$PATTERN", path="file1.md", output_mode="content")
@Grep(pattern="$PATTERN", path="file2.md", output_mode="content")
@Grep(pattern="$PATTERN", path="file3.md", output_mode="content")
```

### TodoWrite Integration
Track documentation tasks:
```javascript
@TodoWrite(todos=[
  {id: "doc-1", content: "Update CHANGELOG.md", status: "pending", priority: "high"},
  {id: "doc-2", content: "Update FEATURES.md", status: "pending", priority: "medium"},
  {id: "doc-3", content: "Update CLAUDE.md", status: "pending", priority: "low"}
])
```

## Common Patterns

### Pattern 1: Feature Addition
1. Implement feature
2. Update FEATURES.md with details
3. Update CHANGELOG.md under "Added"
4. Update CLAUDE.md if new patterns introduced

### Pattern 2: Bug Fix
1. Fix the bug
2. Update CHANGELOG.md under "Fixed"
3. Include root cause and impact
4. Document prevention measures

### Pattern 3: Refactoring
1. Refactor code
2. Update CHANGELOG.md under "Changed"
3. Update CLAUDE.md with new patterns
4. Document migration steps if needed

### Pattern 4: Performance Optimization
1. Optimize performance
2. Update CHANGELOG.md with metrics
3. Document configuration changes
4. Update monitoring guidelines

## Maintenance Guidelines

### Regular Audits
- Monthly: Check documentation currency
- Quarterly: Review and update templates
- Annually: Assess overall documentation strategy

### Continuous Improvement
- Gather feedback from users
- Monitor documentation update compliance
- Refine templates based on usage
- Update automation tools

### Team Training
- Onboard new developers with documentation practices
- Share examples of good documentation
- Celebrate documentation achievements
- Make documentation part of definition of done

## Anti-Patterns to Avoid

### ❌ Don't Skip Documentation
- Never merge without updating docs
- Don't assume changes are "too small"
- Avoid batching documentation updates

### ❌ Don't Over-Document
- Avoid documenting implementation details in CHANGELOG
- Don't duplicate information across files
- Skip documenting temporary changes

### ❌ Don't Use Generic Descriptions
- Avoid "Fixed bug" or "Updated feature"
- Don't use technical jargon for user-facing docs
- Skip internal variable names in CHANGELOG

## Tools and Resources

### Scripts
- `add-documentation-updates.ps1` - Add documentation sections to files
- `/update-changelog` - Automated changelog updates
- `/generate-documentation` - Generate technical documentation

### Templates
- Command documentation template
- Agent documentation template
- CHANGELOG entry templates
- Feature documentation template

### References
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Write the Docs](https://www.writethedocs.org/)

## Success Metrics

### Quantitative Metrics
- Documentation update rate: >95% of changes
- Time to document: <2 minutes per change
- Documentation accuracy: >98%
- Automation usage: >80% use `/update-changelog`

### Qualitative Metrics
- User satisfaction with documentation
- Developer confidence in making changes
- Reduced onboarding time
- Fewer documentation-related questions

## Conclusion

Good documentation is a force multiplier for development teams. By following these best practices and leveraging Opus 4's intelligent capabilities, Claudify maintains documentation that is:

- **Current**: Always up-to-date with latest changes
- **Comprehensive**: Covers all aspects of the system
- **Consistent**: Follows predictable patterns
- **Accessible**: Easy to find and understand
- **Automated**: Minimal manual effort required

Remember: Documentation is not a chore, but an investment in your team's future productivity and success!